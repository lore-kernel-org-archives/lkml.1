Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304Ab0AaUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0AaUDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157Ab0AaUDI
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:03:08 -0500
Received: from mail.perches.com ([173.55.12.10]:1651 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab0AaUCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:02:22 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 06/10] drivers/staging: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:08 -0800
Message-Id: <3ed42b473cd234c42a7c7a0f96f69b5cc4c9d752.1264967499.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264967493.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.
Fixed a "is tryied" / tried typo

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/dream/qdsp5/audio_mp3.c            |    3 +--
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    3 +--
 drivers/staging/rtl8187se/r8180_core.c             |    3 +--
 drivers/staging/sep/sep_driver.c                   |    3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/dream/qdsp5/audio_mp3.c b/drivers/staging/dream/qdsp5/audio_mp3.c
index b95574f..7ed6e26 100644
--- a/drivers/staging/dream/qdsp5/audio_mp3.c
+++ b/drivers/staging/dream/qdsp5/audio_mp3.c
@@ -650,8 +650,7 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 						       &audio->read_phys,
 						       GFP_KERNEL);
 				if (!audio->read_data) {
-					pr_err("audio_mp3: malloc pcm \
-					buf failed\n");
+					pr_err("audio_mp3: malloc pcm buf failed\n");
 					rc = -1;
 				} else {
 					uint8_t index;
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index f1d6cb4..ad42bcd 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -482,8 +482,7 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
 		(!ieee->enter_sleep_state) ||
 		(!ieee->ps_is_queue_empty)){
 
-		printk("ERROR. PS mode is tryied to be use but\
-driver missed a callback\n\n");
+		printk("ERROR. PS mode tried to be use but driver missed a callback\n\n");
 
 		return -1;
 	}
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index e0f13ef..278992a 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -3864,8 +3864,7 @@ static int __init rtl8180_pci_module_init(void)
 		return ret;
 	}
 
-	printk(KERN_INFO "\nLinux kernel driver for RTL8180 \
-/ RTL8185 based WLAN cards\n");
+	printk(KERN_INFO "\nLinux kernel driver for RTL8180 / RTL8185 based WLAN cards\n");
 	printk(KERN_INFO "Copyright (c) 2004-2005, Andrea Merello\n");
 	DMESG("Initializing module");
 	DMESG("Wireless extensions version %d", WIRELESS_EXT);
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index e7bc9ec..8793878 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -380,8 +380,7 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 	   shared area */
 	if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
 		edbg("SEP Driver mmap requested size is more than allowed\n");
-		printk(KERN_WARNING "SEP Driver mmap requested size is more \
-			than allowed\n");
+		printk(KERN_WARNING "SEP Driver mmap requested size is more than allowed\n");
 		printk(KERN_WARNING "SEP Driver vma->vm_end is %08lx\n", vma->vm_end);
 		printk(KERN_WARNING "SEP Driver vma->vm_end is %08lx\n", vma->vm_start);
 		return -EAGAIN;
-- 
1.6.6.rc0.57.gad7a

