Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYDIIrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYDIIrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYDIIrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:47:00 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:15596 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752042AbYDIIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:46:59 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-164.messagelabs.com!1207730817!3023732!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds: add MODULE_ALIAS("platform:leds-gpio") for leds-gpio
Date: Wed,  9 Apr 2008 10:46:30 +0200
Message-Id: <1207730791-31326-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Apr 2008 08:46:32.0160 (UTC) FILETIME=[35C10E00:01C89A1E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15838.005
X-TM-AS-Result: No--8.006000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows leds-gpio to be automatically loaded by udev.
589499c04b9929ce3de9a9cc591f8a24cf1ebc91 has a more verbose
description (for ixp4xx-beeper though).

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 drivers/leds/leds-gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 4c0b058..1aae8b3 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -199,3 +199,4 @@ module_exit(gpio_led_exit);
 MODULE_AUTHOR("Raphael Assenat <raph@8d.com>");
 MODULE_DESCRIPTION("GPIO LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-gpio");
-- 
1.5.4.5

