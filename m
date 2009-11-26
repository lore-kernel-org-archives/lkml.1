Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZKZSmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZKZSmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZKZSmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:42:43 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52440 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZKZSmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:organization
         :to:cc:content-type:content-transfer-encoding:message-id;
        b=fZuuwZnFfj/2wnVVAQsV3Y39Bd3A6PdLBH9+f52wDevIFhH6p1hPN15qXJbCNCqo7u
         VZCzLoFt8eBCKnpaea0mTcgu4hmoZIQ7TzTRklmnj4RzNOt2MCfhVBlnllYnM0Jbj39F
         jNVG/WECKhJ/St6M5jk2pdZbO+p9t52qH8mz0=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 26 Nov 2009 19:41:02 +0100
Subject: [PATCH] leds: use default-on trigger for Cobalt Qube
MIME-Version: 1.0
X-Length: 1508
Organization: OpenWrt
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Martin Michlmayr <tbm@cyrius.com>, Sameer Verma <sverma@sfsu.edu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911261941.02431.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the default trigger from "ide-disk"
to "default-on". Users updating from kernels not having this
LED driver will prefer having the same LED behavior as they
used to.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/leds/leds-cobalt-qube.c b/drivers/leds/leds-cobalt-qube.c
index 8816806..81b2014 100644
--- a/drivers/leds/leds-cobalt-qube.c
+++ b/drivers/leds/leds-cobalt-qube.c
@@ -31,7 +31,7 @@ static struct led_classdev qube_front_led = {
 	.name			= "qube::front",
 	.brightness		= LED_FULL,
 	.brightness_set		= qube_front_led_set,
-	.default_trigger	= "ide-disk",
+	.default_trigger	= "default-on",
 };
 
 static int __devinit cobalt_qube_led_probe(struct platform_device *pdev)
