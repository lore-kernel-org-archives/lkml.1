Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZFQPAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZFQPAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZFQPA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:00:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59964 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751238AbZFQPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:00:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH v2] leds: Further document parameters for blink_set()
Date: Wed, 17 Jun 2009 16:00:27 +0100
Message-Id: <1245250827-5602-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation for the parameters of blink_set() was a bit hard
to find so put some where I'd expected to find it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Fixed the spelling of milliseconds.

 include/linux/leds.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 376fe07..bab4af1 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -45,7 +45,9 @@ struct led_classdev {
 	/* Get LED brightness level */
 	enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
 
-	/* Activate hardware accelerated blink */
+	/* Activate hardware accelerated blink, delays are in
+	 * milliseconds and if none is provided then a sensible
+	 * default should be chosen. */
 	int		(*blink_set)(struct led_classdev *led_cdev,
 				     unsigned long *delay_on,
 				     unsigned long *delay_off);
-- 
1.6.3.1

