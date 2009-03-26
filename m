Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbZCZOt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbZCZOt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbZCZOsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:48:31 -0400
Received: from mx1.emlix.com ([193.175.82.87]:38950 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758837AbZCZOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:48:27 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 5/5] xtensa: s6000 video updates for s6105_defconfig
Date: Thu, 26 Mar 2009 15:49:34 +0100
Message-Id: <1238078974-26040-5-git-send-email-dg@emlix.com>
In-Reply-To: <1238078974-26040-1-git-send-email-dg@emlix.com>
References: <1238078974-26040-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/configs/s6105_defconfig |   42 ++++++++++++++++++++++++++++++++--
 1 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 8eec578..8c7a6ec 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.29-rc7-s6
-# Tue Mar 17 11:55:24 2009
+# Tue Mar 24 14:16:43 2009
 #
 # CONFIG_FRAME_POINTER is not set
 CONFIG_ZONE_DMA=y
@@ -400,6 +400,7 @@ CONFIG_I2C_S6000=y
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCA9539 is not set
+CONFIG_PCA9543=y
 # CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
 # CONFIG_SENSORS_TSL2550 is not set
@@ -483,13 +484,48 @@ CONFIG_SSB_POSSIBLE=y
 #
 # Multimedia core support
 #
-# CONFIG_VIDEO_DEV is not set
+CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_V4L2_COMMON=y
+# CONFIG_VIDEO_ALLOW_V4L1 is not set
+# CONFIG_VIDEO_V4L1_COMPAT is not set
 # CONFIG_DVB_CORE is not set
-# CONFIG_VIDEO_MEDIA is not set
+CONFIG_VIDEO_MEDIA=y
 
 #
 # Multimedia drivers
 #
+CONFIG_MEDIA_TUNER=y
+CONFIG_MEDIA_TUNER_CUSTOMIZE=y
+# CONFIG_MEDIA_TUNER_SIMPLE is not set
+# CONFIG_MEDIA_TUNER_TDA8290 is not set
+# CONFIG_MEDIA_TUNER_TDA827X is not set
+# CONFIG_MEDIA_TUNER_TDA18271 is not set
+# CONFIG_MEDIA_TUNER_TDA9887 is not set
+# CONFIG_MEDIA_TUNER_TEA5761 is not set
+# CONFIG_MEDIA_TUNER_TEA5767 is not set
+# CONFIG_MEDIA_TUNER_MT20XX is not set
+# CONFIG_MEDIA_TUNER_MT2060 is not set
+# CONFIG_MEDIA_TUNER_MT2266 is not set
+# CONFIG_MEDIA_TUNER_MT2131 is not set
+# CONFIG_MEDIA_TUNER_QT1010 is not set
+# CONFIG_MEDIA_TUNER_XC2028 is not set
+# CONFIG_MEDIA_TUNER_XC5000 is not set
+# CONFIG_MEDIA_TUNER_MXL5005S is not set
+# CONFIG_MEDIA_TUNER_MXL5007T is not set
+CONFIG_VIDEO_V4L2=y
+CONFIG_VIDEO_CAPTURE_DRIVERS=y
+# CONFIG_VIDEO_ADV_DEBUG is not set
+CONFIG_VIDEO_FIXED_MINOR_RANGES=y
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
+# CONFIG_VIDEO_SAA5246A is not set
+# CONFIG_VIDEO_SAA5249 is not set
+CONFIG_VIDEO_S6000=y
+CONFIG_VIDEO_S6000_CANONICAL=y
+CONFIG_VIDEO_S6DP_MT9D131=y
+CONFIG_VIDEO_S6DP_SAA7121=y
+# CONFIG_SOC_CAMERA is not set
+# CONFIG_RADIO_ADAPTERS is not set
 # CONFIG_DAB is not set
 
 #
-- 
1.6.2.107.ge47ee

