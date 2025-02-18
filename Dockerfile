FROM public.ecr.aws/docker/library/maven:3.6-jdk-11-slim AS build

COPY src /app/src

WORKDIR /app

COPY pom.xml /app

RUN mvn clean install -DskipTests

RUN ls -lh /app/target

#
# Package stage
#

FROM public.ecr.aws/docker/library/openjdk:11-jre-slim

RUN apt-get update && apt-get install -y curl

WORKDIR /app

# COPY config/configs-dev.properties config/

COPY --from=build /app/target/medusa_merchant-0.0.1-SNAPSHOT.jar portal.jar

EXPOSE 3394

ENTRYPOINT ["java","-jar","portal.jar"]
