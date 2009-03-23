Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZCWPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZCWPdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZCWPdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:33:25 -0400
Received: from mx1.emlix.com ([193.175.82.87]:55149 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbZCWPdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:33:24 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 5/6] xtensa: enable s6000 spi host in s6105_defconfig
Date: Mon, 23 Mar 2009 16:34:21 +0100
Message-Id: <1237822462-32109-5-git-send-email-dg@emlix.com>
In-Reply-To: <1237822462-32109-1-git-send-email-dg@emlix.com>
References: <1237822462-32109-1-git-send-email-dg@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/xtensa/configs/s6105_defconfig |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index e398710..02bab6e 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -260,6 +260,7 @@ CONFIG_MISC_DEVICES=y
 # EEPROM support
 #
 CONFIG_EEPROM_AT24=y
+# CONFIG_EEPROM_AT25 is not set
 # CONFIG_EEPROM_LEGACY is not set
 # CONFIG_EEPROM_93CX6 is not set
 CONFIG_HAVE_IDE=y
@@ -409,7 +410,22 @@ CONFIG_I2C_S6000=y
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
 # CONFIG_I2C_DEBUG_CHIP is not set
-# CONFIG_SPI is not set
+CONFIG_SPI=y
+# CONFIG_SPI_DEBUG is not set
+CONFIG_SPI_MASTER=y
+
+#
+# SPI Master Controller Drivers
+#
+# CONFIG_SPI_BITBANG is not set
+# CONFIG_SPI_GPIO is not set
+CONFIG_SPI_S6000=y
+
+#
+# SPI Protocol Masters
+#
+# CONFIG_SPI_SPIDEV is not set
+# CONFIG_SPI_TLE62X0 is not set
 CONFIG_ARCH_REQUIRE_GPIOLIB=y
 CONFIG_GPIOLIB=y
 # CONFIG_DEBUG_GPIO is not set
@@ -433,6 +449,8 @@ CONFIG_GPIOLIB=y
 #
 # SPI GPIO expanders:
 #
+# CONFIG_GPIO_MAX7301 is not set
+# CONFIG_GPIO_MCP23S08 is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
-- 
1.6.2.107.ge47ee

