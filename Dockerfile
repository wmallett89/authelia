# ===================================
# ===== Authelia official image =====
# ===================================
#FROM alpine:3.20.2@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5
FROM ubuntu:22.04

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

# Set environment variables
ENV PATH="/app:${PATH}" \
    PUID=0 \
    PGID=0 \
    X_AUTHELIA_CONFIG="/config/configuration.yml"

RUN \
        apt-get update && apt-get install -y ca-certificates gosu tzdata wget coreutils

COPY LICENSE .healthcheck.env entrypoint.sh healthcheck.sh ./

RUN \
        chmod 0666 /app/.healthcheck.env

COPY authelia-linux-amd64 ./authelia

EXPOSE 9091

VOLUME /config

ENTRYPOINT ["/app/entrypoint.sh"]
HEALTHCHECK --interval=30s --timeout=3s --start-period=1m CMD /app/healthcheck.sh
