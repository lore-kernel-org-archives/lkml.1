Return-Path: <linux-kernel-owner+w=401wt.eu-S936298AbXLQT5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936298AbXLQT5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933866AbXLQTlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:23 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3195 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761194AbXLQTlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:08 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Knut Petersen <Knut_Petersen@t-online.de>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>
Subject: [PATCH] drivers/video/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:19 -0800
Message-Id: <1197920439-5455-13-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/aty/radeon_pm.c   |    2 +-
 drivers/video/cyblafb.c         |    2 +-
 drivers/video/intelfb/intelfb.h |    2 +-
 drivers/video/omap/lcdc.c       |    2 +-
 drivers/video/sm501fb.c         |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
index 83ee3e7..675abda 100644
--- a/drivers/video/aty/radeon_pm.c
+++ b/drivers/video/aty/radeon_pm.c
@@ -2561,7 +2561,7 @@ static void radeon_set_suspend(struct radeonfb_info *rinfo, int suspend)
 			pci_read_config_dword(rinfo->pdev, i * 4,
 					      &rinfo->cfg_save[i]);
 
-		/* Switch PCI power managment to D2. */
+		/* Switch PCI power management to D2. */
 		pci_disable_device(rinfo->pdev);
 		for (;;) {
 			pci_read_config_word(
diff --git a/drivers/video/cyblafb.c b/drivers/video/cyblafb.c
index e23324d..9704b73 100644
--- a/drivers/video/cyblafb.c
+++ b/drivers/video/cyblafb.c
@@ -1156,7 +1156,7 @@ static struct fb_ops cyblafb_ops __devinitdata = {
 // need altered timings to display correctly. So I decided that it is much
 // better to provide a limited optimized set of modes plus the option of
 // using the mode in effect at startup time (might be selected using the
-// vga=??? paramter). After that the user might use fbset to select any
+// vga=??? parameter). After that the user might use fbset to select any
 // mode he likes, check_var will not try to alter geometry parameters as
 // it would be necessary otherwise.
 //
diff --git a/drivers/video/intelfb/intelfb.h b/drivers/video/intelfb/intelfb.h
index 2fe3f7d..8367961 100644
--- a/drivers/video/intelfb/intelfb.h
+++ b/drivers/video/intelfb/intelfb.h
@@ -111,7 +111,7 @@
 
 #define FIXED_MODE(d) ((d)->fixed_mode)
 
-/*** Driver paramters ***/
+/*** Driver parameters ***/
 
 #define RINGBUFFER_SIZE		KB(64)
 #define HW_CURSOR_SIZE		KB(4)
diff --git a/drivers/video/omap/lcdc.c b/drivers/video/omap/lcdc.c
index 9085188..fb19ed4 100644
--- a/drivers/video/omap/lcdc.c
+++ b/drivers/video/omap/lcdc.c
@@ -312,7 +312,7 @@ static irqreturn_t lcdc_irq_handler(int irq, void *dev_id)
 /*
  * Change to a new video mode. We defer this to a later time to avoid any
  * flicker and not to mess up the current LCD DMA context. For this we disable
- * the LCD controler, which will generate a DONE irq after the last frame has
+ * the LCD controller, which will generate a DONE irq after the last frame has
  * been transferred. Then it'll be safe to reconfigure both the LCD controller
  * as well as the LCD DMA.
  */
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 1be95a6..58f200c 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -48,7 +48,7 @@ enum sm501_controller {
 	HEAD_PANEL	= 1,
 };
 
-/* SM501 memory adress */
+/* SM501 memory address */
 struct sm501_mem {
 	unsigned long	 size;
 	unsigned long	 sm_addr;
-- 
1.5.3.7.949.g2221a6

