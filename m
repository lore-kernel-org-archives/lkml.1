Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZCYKz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZCYKz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZCYKyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:54:37 -0400
Received: from mx1.emlix.com ([193.175.82.87]:51361 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZCYKyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:54:35 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 3/3] xtensa: enable m41t80 driver in s6105_defconfig
Date: Wed, 25 Mar 2009 11:55:37 +0100
Message-Id: <1237978537-23681-3-git-send-email-dg@emlix.com>
In-Reply-To: <1237978537-23681-1-git-send-email-dg@emlix.com>
References: <1237978537-23681-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/configs/s6105_defconfig |   56 +++++++++++++++++++++++++++++++++--
 1 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index c5ea056..a386a01 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -363,8 +363,6 @@ CONFIG_UNIX98_PTYS=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_IPMI_HANDLER is not set
 # CONFIG_HW_RANDOM is not set
-# CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
 # CONFIG_TCG_TPM is not set
@@ -529,7 +527,59 @@ CONFIG_MMC_SPI=y
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
 # CONFIG_ACCESSIBILITY is not set
-# CONFIG_RTC_CLASS is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_HCTOSYS=y
+CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
+# CONFIG_RTC_DEBUG is not set
+
+#
+# RTC interfaces
+#
+# CONFIG_RTC_INTF_SYSFS is not set
+# CONFIG_RTC_INTF_PROC is not set
+# CONFIG_RTC_INTF_DEV is not set
+# CONFIG_RTC_DRV_TEST is not set
+
+#
+# I2C RTC drivers
+#
+# CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
+# CONFIG_RTC_DRV_DS1672 is not set
+# CONFIG_RTC_DRV_MAX6900 is not set
+# CONFIG_RTC_DRV_RS5C372 is not set
+# CONFIG_RTC_DRV_ISL1208 is not set
+# CONFIG_RTC_DRV_X1205 is not set
+# CONFIG_RTC_DRV_PCF8563 is not set
+# CONFIG_RTC_DRV_PCF8583 is not set
+CONFIG_RTC_DRV_M41T80=y
+# CONFIG_RTC_DRV_M41T80_WDT is not set
+# CONFIG_RTC_DRV_S35390A is not set
+# CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
+
+#
+# SPI RTC drivers
+#
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_DS1286 is not set
+# CONFIG_RTC_DRV_DS1511 is not set
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T35 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_BQ4802 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
 # CONFIG_DMADEVICES is not set
 # CONFIG_UIO is not set
 # CONFIG_STAGING is not set
-- 
1.6.2.107.ge47ee

