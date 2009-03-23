Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbZCWPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbZCWPet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbZCWPd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:33:28 -0400
Received: from mx1.emlix.com ([193.175.82.87]:45438 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbZCWPdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:33:25 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 6/6] xtensa: enable spi mmc host in s6105_defconfig
Date: Mon, 23 Mar 2009 16:34:22 +0100
Message-Id: <1237822462-32109-6-git-send-email-dg@emlix.com>
In-Reply-To: <1237822462-32109-1-git-send-email-dg@emlix.com>
References: <1237822462-32109-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/configs/s6105_defconfig |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 02bab6e..c5ea056 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -509,7 +509,23 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_SOUND is not set
 # CONFIG_USB_SUPPORT is not set
-# CONFIG_MMC is not set
+CONFIG_MMC=y
+# CONFIG_MMC_DEBUG is not set
+# CONFIG_MMC_UNSAFE_RESUME is not set
+
+#
+# MMC/SD/SDIO Card Drivers
+#
+CONFIG_MMC_BLOCK=y
+# CONFIG_MMC_BLOCK_BOUNCE is not set
+# CONFIG_SDIO_UART is not set
+# CONFIG_MMC_TEST is not set
+
+#
+# MMC/SD/SDIO Host Controller Drivers
+#
+# CONFIG_MMC_SDHCI is not set
+CONFIG_MMC_SPI=y
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
 # CONFIG_ACCESSIBILITY is not set
@@ -646,9 +662,9 @@ CONFIG_GENERIC_FIND_LAST_BIT=y
 # CONFIG_CRC_CCITT is not set
 # CONFIG_CRC16 is not set
 # CONFIG_CRC_T10DIF is not set
-# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC_ITU_T=y
 # CONFIG_CRC32 is not set
-# CONFIG_CRC7 is not set
+CONFIG_CRC7=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_PLIST=y
 CONFIG_HAS_IOMEM=y
-- 
1.6.2.107.ge47ee

