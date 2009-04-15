Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZDOCnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZDOCnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZDOCmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:42:42 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:51184 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077AbZDOCmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:42:40 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 1/2] Trivial: typo (en|dis|avail|remove)bale -> (en|dis|avail|remove)able
Date: Tue, 14 Apr 2009 23:14:10 -0300
Message-Id: <1239761650-16520-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/char/amiserial.c                |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c |    2 +-
 drivers/net/b44.h                       |    2 +-
 drivers/net/e100.c                      |    2 +-
 drivers/net/niu.h                       |    4 ++--
 drivers/scsi/megaraid.h                 |    2 +-
 drivers/scsi/megaraid/mbox_defs.h       |    2 +-
 drivers/staging/rt2860/common/mlme.c    |    2 +-
 drivers/staging/rt2870/common/mlme.c    |    2 +-
 drivers/staging/rt3070/common/mlme.c    |    2 +-
 drivers/watchdog/iop_wdt.c              |    2 +-
 sound/pci/aw2/aw2-saa7146.c             |    2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index fd3ebd1..72429b6 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -779,7 +779,7 @@ static void change_speed(struct async_struct *info,
 		info->IER |= UART_IER_MSI;
 	}
 	/* TBD:
-	 * Does clearing IER_MSI imply that we should disbale the VBL interrupt ?
+	 * Does clearing IER_MSI imply that we should disable the VBL interrupt ?
 	 */
 
 	/*
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 3e6ffee..ccd47f5 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -181,7 +181,7 @@ static int hdpvr_submit_buffers(struct hdpvr_device *dev)
 				 buff_list);
 		if (buf->status != BUFSTAT_AVAILABLE) {
 			v4l2_err(&dev->v4l2_dev,
-				 "buffer not marked as availbale\n");
+				 "buffer not marked as available\n");
 			ret = -EFAULT;
 			goto err;
 		}
diff --git a/drivers/net/b44.h b/drivers/net/b44.h
index e678498..d24158e 100644
--- a/drivers/net/b44.h
+++ b/drivers/net/b44.h
@@ -97,7 +97,7 @@
 #define B44_DMARX_STAT	0x021CUL /* DMA RX Current Active Desc. + Status */
 #define  DMARX_STAT_CDMASK	0x00000fff /* Current Descriptor Mask */
 #define  DMARX_STAT_SMASK	0x0000f000 /* State Mask */
-#define  DMARX_STAT_SDISABLED	0x00000000 /* State Disbaled */
+#define  DMARX_STAT_SDISABLED	0x00000000 /* State Disabled */
 #define  DMARX_STAT_SACTIVE	0x00001000 /* State Active */
 #define  DMARX_STAT_SIDLE	0x00002000 /* State Idle Wait */
 #define  DMARX_STAT_SSTOPPED	0x00003000 /* State Stopped */
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 5c0b457..43de4e1 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -2772,7 +2772,7 @@ static int e100_resume(struct pci_dev *pdev)
 	/* ack any pending wake events, disable PME */
 	pci_enable_wake(pdev, 0, 0);
 
-	/* disbale reverse auto-negotiation */
+	/* disable reverse auto-negotiation */
 	if (nic->phy == phy_82552_v) {
 		u16 smartspeed = mdio_read(netdev, nic->mii.phy_id,
 		                           E100_82552_SMARTSPEED);
diff --git a/drivers/net/niu.h b/drivers/net/niu.h
index 8754e44..3bd0b59 100644
--- a/drivers/net/niu.h
+++ b/drivers/net/niu.h
@@ -3242,8 +3242,8 @@ struct niu {
 	struct niu_parent		*parent;
 
 	u32				flags;
-#define NIU_FLAGS_HOTPLUG_PHY_PRESENT	0x02000000 /* Removebale PHY detected*/
-#define NIU_FLAGS_HOTPLUG_PHY		0x01000000 /* Removebale PHY */
+#define NIU_FLAGS_HOTPLUG_PHY_PRESENT	0x02000000 /* Removeable PHY detected*/
+#define NIU_FLAGS_HOTPLUG_PHY		0x01000000 /* Removeable PHY */
 #define NIU_FLAGS_VPD_VALID		0x00800000 /* VPD has valid version */
 #define NIU_FLAGS_MSIX			0x00400000 /* MSI-X in use */
 #define NIU_FLAGS_MCAST			0x00200000 /* multicast filter enabled */
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 795201f..512c2cc 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -469,7 +469,7 @@ typedef struct {
 	u8	type;		/* Type of the device */
 	u8	cur_status;	/* current status of the device */
 	u8	tag_depth;	/* Level of tagging */
-	u8	sync_neg;	/* sync negotiation - ENABLE or DISBALE */
+	u8	sync_neg;	/* sync negotiation - ENABLE or DISABLE */
 	u32	size;		/* configurable size in terms of 512 byte
 				   blocks */
 }__attribute__ ((packed)) phys_drv;
diff --git a/drivers/scsi/megaraid/mbox_defs.h b/drivers/scsi/megaraid/mbox_defs.h
index 170399e..b25b747 100644
--- a/drivers/scsi/megaraid/mbox_defs.h
+++ b/drivers/scsi/megaraid/mbox_defs.h
@@ -686,7 +686,7 @@ typedef struct {
  * @type	: Type of the device
  * @cur_status	: current status of the device
  * @tag_depth	: Level of tagging
- * @sync_neg	: sync negotiation - ENABLE or DISBALE
+ * @sync_neg	: sync negotiation - ENABLE or DISABLE
  * @size	: configurable size in terms of 512 byte
  */
 typedef struct {
diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index c00f9ab..2edf299 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -5664,7 +5664,7 @@ VOID 	AsicUpdateProtect(
 #if 0
 	MacReg |= (pAd->CommonCfg.RtsThreshold << 8);
 #else
-	// If the user want disable RtsThreshold and enbale Amsdu/Ralink-Aggregation, set the RtsThreshold as 4096
+	// If the user want disable RtsThreshold and enable Amsdu/Ralink-Aggregation, set the RtsThreshold as 4096
         if ((
 #ifdef DOT11_N_SUPPORT
 			(pAd->CommonCfg.BACapability.field.AmsduEnable) ||
diff --git a/drivers/staging/rt2870/common/mlme.c b/drivers/staging/rt2870/common/mlme.c
index 8a82cee..a26bc03 100644
--- a/drivers/staging/rt2870/common/mlme.c
+++ b/drivers/staging/rt2870/common/mlme.c
@@ -5561,7 +5561,7 @@ VOID 	AsicUpdateProtect(
 #if 0
 	MacReg |= (pAd->CommonCfg.RtsThreshold << 8);
 #else
-	// If the user want disable RtsThreshold and enbale Amsdu/Ralink-Aggregation, set the RtsThreshold as 4096
+	// If the user want disable RtsThreshold and enable Amsdu/Ralink-Aggregation, set the RtsThreshold as 4096
         if ((
 #ifdef DOT11_N_SUPPORT
 			(pAd->CommonCfg.BACapability.field.AmsduEnable) ||
diff --git a/drivers/staging/rt3070/common/mlme.c b/drivers/staging/rt3070/common/mlme.c
index 0ffbfa3..0189bab 100644
--- a/drivers/staging/rt3070/common/mlme.c
+++ b/drivers/staging/rt3070/common/mlme.c
@@ -5575,7 +5575,7 @@ VOID 	AsicUpdateProtect(
 	RTMP_IO_READ32(pAd, TX_RTS_CFG, &MacReg);
 	MacReg &= 0xFF0000FF;
 
-	// If the user want disable RtsThreshold and enbale Amsdu/Ralink-Aggregation, set the RtsThreshold as 4096
+	// If the user want disable RtsThreshold and enable Amsdu/Ralink-Aggregation, set the RtsThreshold as 4096
     if ((
 #ifdef DOT11_N_SUPPORT
 		(pAd->CommonCfg.BACapability.field.AmsduEnable) ||
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index 96eb2cb..0c90596 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -192,7 +192,7 @@ static int iop_wdt_release(struct inode *inode, struct file *file)
 		if (test_bit(WDT_ENABLED, &wdt_status))
 			state = wdt_disable();
 
-	/* if the timer is not disbaled reload and notify that we are still
+	/* if the timer is not disabled reload and notify that we are still
 	 * going down
 	 */
 	if (state != 0) {
diff --git a/sound/pci/aw2/aw2-saa7146.c b/sound/pci/aw2/aw2-saa7146.c
index 6a3891a..296123a 100644
--- a/sound/pci/aw2/aw2-saa7146.c
+++ b/sound/pci/aw2/aw2-saa7146.c
@@ -108,7 +108,7 @@ void snd_aw2_saa7146_setup(struct snd_aw2_saa7146 *chip,
 #endif
 	/* WS0_CTRL, WS0_SYNC: input TSL1, I2S */
 
-	/* At initialization WS1 and WS2 are disbaled (configured as input */
+	/* At initialization WS1 and WS2 are disabled (configured as input) */
 	acon1 |= 0 * WS1_CTRL;
 	acon1 |= 0 * WS2_CTRL;
 
-- 
1.6.2.2

