Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZFKNSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZFKNSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZFKNSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:18:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32923 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752030AbZFKNSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:18:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] leds: Further document parameters for blink_set()
Date: Thu, 11 Jun 2009 14:17:48 +0100
Message-Id: <1244726268-1517-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation for the parameters of blink_set() was a bit hard
to find so put some where I'd expected to find it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/leds.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 376fe07..c7f0b14 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -45,7 +45,9 @@ struct led_classdev {
 	/* Get LED brightness level */
 	enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
 
-	/* Activate hardware accelerated blink */
+	/* Activate hardware accelerated blink, delays are in
+	 * miliseconds and if none is provided then a sensible default
+	 * should be chosen. */
 	int		(*blink_set)(struct led_classdev *led_cdev,
 				     unsigned long *delay_on,
 				     unsigned long *delay_off);
-- 
1.6.3.1

