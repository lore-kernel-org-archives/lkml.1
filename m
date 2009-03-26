Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbZCZNda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbZCZNda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZCZNcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:32:43 -0400
Received: from mx1.emlix.com ([193.175.82.87]:60145 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbZCZNcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:32:41 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 4/4] xtensa: enable on-board sound in s6105_defconfig
Date: Thu, 26 Mar 2009 14:33:48 +0100
Message-Id: <1238074428-24666-4-git-send-email-dg@emlix.com>
In-Reply-To: <1238074428-24666-1-git-send-email-dg@emlix.com>
References: <1238074428-24666-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/configs/s6105_defconfig |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index a386a01..6ced233 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.29-rc7-s6
-# Wed Mar 11 13:38:31 2009
+# Tue Mar 17 11:55:24 2009
 #
 # CONFIG_FRAME_POINTER is not set
 CONFIG_ZONE_DMA=y
@@ -505,7 +505,29 @@ CONFIG_SSB_POSSIBLE=y
 # Display device support
 #
 # CONFIG_DISPLAY_SUPPORT is not set
-# CONFIG_SOUND is not set
+CONFIG_SOUND=y
+# CONFIG_SOUND_OSS_CORE is not set
+CONFIG_SND=y
+CONFIG_SND_TIMER=y
+CONFIG_SND_PCM=y
+# CONFIG_SND_SEQUENCER is not set
+# CONFIG_SND_MIXER_OSS is not set
+# CONFIG_SND_PCM_OSS is not set
+# CONFIG_SND_DYNAMIC_MINORS is not set
+# CONFIG_SND_SUPPORT_OLD_API is not set
+CONFIG_SND_VERBOSE_PROCFS=y
+# CONFIG_SND_VERBOSE_PRINTK is not set
+# CONFIG_SND_DEBUG is not set
+# CONFIG_SND_DRIVERS is not set
+# CONFIG_SND_SPI is not set
+CONFIG_SND_SOC=y
+CONFIG_SND_S6000_SOC=y
+CONFIG_SND_S6000_SOC_I2S=y
+CONFIG_SND_S6000_SOC_S6IPCAM=y
+CONFIG_SND_SOC_I2C_AND_SPI=y
+# CONFIG_SND_SOC_ALL_CODECS is not set
+CONFIG_SND_SOC_TLV320AIC3X=y
+# CONFIG_SOUND_PRIME is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
 # CONFIG_MMC_DEBUG is not set
-- 
1.6.2.107.ge47ee

