Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab0CJXwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:52:33 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:36377 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab0CJXwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:52:31 -0500
X-Greylist: delayed 1871 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 18:52:30 EST
X-SMTPAUTH-B2: 
X-SENDER-IP: 83.226.248.79
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj05AGe4l0tT4vhPPGdsb2JhbACHYJJ1DAEBAQE3LbtIhHkE
X-IronPort-AV: E=Sophos;i="4.49,616,1262559600"; 
   d="scan'208";a="48698921"
From: lali@homelinux.net
To: gregkh@suse.de, jarod@redhat.com, abraham.manu@gmail.com, davilla@4pi.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: crystalhd: Whitespace fixes, indentation fixes and 3 changed #includes These patches fixes some whitspace and indentation warnings from checkpatch.pl Also these changed #includes: bc_dts_glob_lnx.h:43: WARNING: Use #include <linux/param.h> instead of <asm/param.h> crystalhd_lnx.h:45: WARNING: Use #include <linux/io.h> instead of <asm/io.h> crystalhd_lnx.h:49: WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h> It all compiles fine, but I don't have the hardware to test with.. Signed-off-by: Lars Lindley <lindley@coyote.org>
Date: Thu, 11 Mar 2010 00:21:20 +0100
Message-Id: <1268263280-16635-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/crystalhd/bc_dts_glob_lnx.h |    2 +-
 drivers/staging/crystalhd/bc_dts_types.h    |    2 +-
 drivers/staging/crystalhd/bcm_70012_regs.h  |   24 +++++++++++-----------
 drivers/staging/crystalhd/crystalhd_cmds.c  |   20 +++++++++---------
 drivers/staging/crystalhd/crystalhd_cmds.h  |    2 +-
 drivers/staging/crystalhd/crystalhd_hw.c    |   29 +++++++++++---------------
 drivers/staging/crystalhd/crystalhd_lnx.c   |   26 ++++++++++++------------
 drivers/staging/crystalhd/crystalhd_lnx.h   |    4 +-
 drivers/staging/crystalhd/crystalhd_misc.c  |   18 ++++++++--------
 9 files changed, 61 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/crystalhd/bc_dts_glob_lnx.h b/drivers/staging/crystalhd/bc_dts_glob_lnx.h
index b3125e3..0fd34e2 100644
--- a/drivers/staging/crystalhd/bc_dts_glob_lnx.h
+++ b/drivers/staging/crystalhd/bc_dts_glob_lnx.h
@@ -40,7 +40,7 @@
 #include <sys/time.h>
 #include <time.h>
 #include <arpa/inet.h>
-#include <asm/param.h>
+#include <linux/param.h>
 #include <linux/ioctl.h>
 #include <sys/select.h>
 
diff --git a/drivers/staging/crystalhd/bc_dts_types.h b/drivers/staging/crystalhd/bc_dts_types.h
index ac0c817..95a2f87 100644
--- a/drivers/staging/crystalhd/bc_dts_types.h
+++ b/drivers/staging/crystalhd/bc_dts_types.h
@@ -25,7 +25,7 @@
 #ifndef _BC_DTS_TYPES_H_
 #define _BC_DTS_TYPES_H_
 
-#ifdef __LINUX_USER__  // Don't include these for KERNEL..
+#ifdef __LINUX_USER__  /* Don't include these for KERNEL.. */
 #include <stdint.h>
 #endif
 
diff --git a/drivers/staging/crystalhd/bcm_70012_regs.h b/drivers/staging/crystalhd/bcm_70012_regs.h
index 6922f54..f3ab314 100644
--- a/drivers/staging/crystalhd/bcm_70012_regs.h
+++ b/drivers/staging/crystalhd/bcm_70012_regs.h
@@ -25,22 +25,22 @@
  * m = memory, c = core, r = register, f = field, d = data.
  */
 #if !defined(GET_FIELD) && !defined(SET_FIELD)
-#define BRCM_ALIGN(c,r,f)   c##_##r##_##f##_ALIGN
-#define BRCM_BITS(c,r,f)    c##_##r##_##f##_BITS
-#define BRCM_MASK(c,r,f)    c##_##r##_##f##_MASK
-#define BRCM_SHIFT(c,r,f)   c##_##r##_##f##_SHIFT
+#define BRCM_ALIGN(c, r, f)   c##_##r##_##f##_ALIGN
+#define BRCM_BITS(c, r, f)    c##_##r##_##f##_BITS
+#define BRCM_MASK(c, r, f)    c##_##r##_##f##_MASK
+#define BRCM_SHIFT(c, r, f)   c##_##r##_##f##_SHIFT
 
-#define GET_FIELD(m,c,r,f) \
-	((((m) & BRCM_MASK(c,r,f)) >> BRCM_SHIFT(c,r,f)) << BRCM_ALIGN(c,r,f))
+#define GET_FIELD(m, c, r, f) \
+	((((m) & BRCM_MASK(c, r, f)) >> BRCM_SHIFT(c, r, f)) << BRCM_ALIGN(c, r, f))
 
-#define SET_FIELD(m,c,r,f,d) \
-	((m) = (((m) & ~BRCM_MASK(c,r,f)) | ((((d) >> BRCM_ALIGN(c,r,f)) << \
-	 BRCM_SHIFT(c,r,f)) & BRCM_MASK(c,r,f))) \
+#define SET_FIELD(m, c, r, f, d) \
+	((m) = (((m) & ~BRCM_MASK(c, r, f)) | ((((d) >> BRCM_ALIGN(c, r, f)) << \
+	 BRCM_SHIFT(c, r, f)) & BRCM_MASK(c, r, f))) \
 	)
 
-#define SET_TYPE_FIELD(m,c,r,f,d) SET_FIELD(m,c,r,f,c##_##d)
-#define SET_NAME_FIELD(m,c,r,f,d) SET_FIELD(m,c,r,f,c##_##r##_##f##_##d)
-#define SET_VALUE_FIELD(m,c,r,f,d) SET_FIELD(m,c,r,f,d)
+#define SET_TYPE_FIELD(m, c, r, f, d) SET_FIELD(m, c, r, f, c##_##d)
+#define SET_NAME_FIELD(m, c, r, f, d) SET_FIELD(m, c, r, f, c##_##r##_##f##_##d)
+#define SET_VALUE_FIELD(m, c, r, f, d) SET_FIELD(m, c, r, f, d)
 
 #endif /* GET & SET */
 
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index 26145a8..d826715 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -88,7 +88,7 @@ static BC_STATUS bc_cproc_notify_mode(struct crystalhd_cmd *ctx,
 		return BC_STS_SUCCESS;
 	}
 	if (ctx->state != BC_LINK_INVALID) {
-		BCMLOG_ERR("Link invalid state %d \n", ctx->state);
+		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 	/* Check for duplicate playback sessions..*/
@@ -301,7 +301,7 @@ static BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 	}
 
 	if (ctx->state != BC_LINK_INVALID) {
-		BCMLOG_ERR("Link invalid state %d \n", ctx->state);
+		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 
@@ -309,7 +309,7 @@ static BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 				  idata->add_cdata_sz);
 
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("Firmware Download Failure!! - %d\n", sts);
+		BCMLOG_ERR("Firmware Download Failure!! - %d\n", sts)
 	} else
 		ctx->state |= BC_LINK_INIT;
 
@@ -335,7 +335,7 @@ static BC_STATUS bc_cproc_do_fw_cmd(struct crystalhd_cmd *ctx, crystalhd_ioctl_d
 	uint32_t *cmd;
 
 	if (!(ctx->state & BC_LINK_INIT)) {
-		BCMLOG_ERR("Link invalid state %d \n", ctx->state);
+		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 
@@ -379,7 +379,7 @@ static void bc_proc_in_completion(crystalhd_dio_req *dio_hnd,
 		return;
 	}
 	if (sts == BC_STS_IO_USER_ABORT)
-		 return;
+		return;
 
 	dio_hnd->uinfo.comp_sts = sts;
 	dio_hnd->uinfo.ev_sts = 1;
@@ -452,7 +452,7 @@ static BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 	if (!rc) {
 		return dio->uinfo.comp_sts;
 	} else if (rc == -EBUSY) {
-		BCMLOG(BCMLOG_DBG, "_tx_post() T/O \n");
+		BCMLOG(BCMLOG_DBG, "_tx_post() T/O\n");
 		sts = BC_STS_TIMEOUT;
 	} else if (rc == -EINTR) {
 		BCMLOG(BCMLOG_DBG, "Tx Wait Signal int.\n");
@@ -482,7 +482,7 @@ static BC_STATUS bc_cproc_check_inbuffs(bool pin, void *ubuff, uint32_t ub_sz,
 
 	/* Check for alignment */
 	if (((uintptr_t)ubuff) & 0x03) {
-		BCMLOG_ERR("%s-->Un-aligned address not implemented yet.. %p \n",
+		BCMLOG_ERR("%s-->Un-aligned address not implemented yet.. %p\n",
 				((pin) ? "TX" : "RX"), ubuff);
 		return BC_STS_NOT_IMPL;
 	}
@@ -523,7 +523,7 @@ static BC_STATUS bc_cproc_proc_input(struct crystalhd_cmd *ctx, crystalhd_ioctl_
 
 	sts = crystalhd_map_dio(ctx->adp, ubuff, ub_sz, 0, 0, 1, &dio_hnd);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("dio map - %d \n", sts);
+		BCMLOG_ERR("dio map - %d\n", sts);
 		return sts;
 	}
 
@@ -563,7 +563,7 @@ static BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 	sts = crystalhd_map_dio(ctx->adp, ubuff, ub_sz, uv_off,
 			      en_422, 0, &dio_hnd);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("dio map - %d \n", sts);
+		BCMLOG_ERR("dio map - %d\n", sts);
 		return sts;
 	}
 
@@ -1026,7 +1026,7 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cm
 		if (g_crystalhd_cproc_tbl[i].cmd_id == cmd) {
 			if ((uc->mode == DTS_MONITOR_MODE) &&
 			    (g_crystalhd_cproc_tbl[i].block_mon)) {
-				BCMLOG(BCMLOG_INFO, "Blocking cmd %d \n", cmd);
+				BCMLOG(BCMLOG_INFO, "Blocking cmd %d\n", cmd);
 				break;
 			}
 			cproc = g_crystalhd_cproc_tbl[i].cmd_proc;
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.h b/drivers/staging/crystalhd/crystalhd_cmds.h
index 6b290ae..9989038 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.h
+++ b/drivers/staging/crystalhd/crystalhd_cmds.h
@@ -66,7 +66,7 @@ struct crystalhd_cmd {
 	struct crystalhd_hw	hw_ctx;
 };
 
-typedef BC_STATUS (*crystalhd_cmd_proc)(struct crystalhd_cmd *, crystalhd_ioctl_data *);
+typedef BC_STATUS(*crystalhd_cmd_proc)(struct crystalhd_cmd *, crystalhd_ioctl_data *);
 
 typedef struct _crystalhd_cmd_tbl {
 	uint32_t		cmd_id;
diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 01819d3..8440945 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -431,7 +431,7 @@ static void crystalhd_hw_delete_ioqs(struct crystalhd_hw *hw)
 	if (!hw)
 		return;
 
-	BCMLOG(BCMLOG_DBG, "Deleting IOQs \n");
+	BCMLOG(BCMLOG_DBG, "Deleting IOQs\n");
 	crystalhd_hw_delete_ioq(hw->adp, hw->tx_actq);
 	crystalhd_hw_delete_ioq(hw->adp, hw->tx_freeq);
 	crystalhd_hw_delete_ioq(hw->adp, hw->rx_actq);
@@ -569,7 +569,7 @@ static bool crystalhd_tx_list0_handler(struct crystalhd_hw *hw, uint32_t err_sts
 	if (!(err_sts & err_mask))
 		return false;
 
-	BCMLOG_ERR("Error on Tx-L0 %x \n", err_sts);
+	BCMLOG_ERR("Error on Tx-L0 %x\n", err_sts);
 
 	tmp = err_mask;
 
@@ -601,7 +601,7 @@ static bool crystalhd_tx_list1_handler(struct crystalhd_hw *hw, uint32_t err_sts
 	if (!(err_sts & err_mask))
 		return false;
 
-	BCMLOG_ERR("Error on Tx-L1 %x \n", err_sts);
+	BCMLOG_ERR("Error on Tx-L1 %x\n", err_sts);
 
 	tmp = err_mask;
 
@@ -634,9 +634,9 @@ static void crystalhd_tx_isr(struct crystalhd_hw *hw, uint32_t int_sts)
 					   BC_STS_SUCCESS);
 
 	if (!(int_sts & (INTR_INTR_STATUS_L0_TX_DMA_ERR_INTR_MASK |
-			 INTR_INTR_STATUS_L1_TX_DMA_ERR_INTR_MASK))) {
-			 /* No error mask set.. */
-			 return;
+		INTR_INTR_STATUS_L1_TX_DMA_ERR_INTR_MASK))) {
+		/* No error mask set.. */
+		return;
 	}
 
 	/* Handle Tx errors. */
@@ -1133,33 +1133,29 @@ static void crystalhd_stop_rx_dma_engine(struct crystalhd_hw *hw)
 		if (l0y) {
 			l0y = crystalhd_reg_rd(hw->adp, MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST0);
 			l0y &= DMA_START_BIT;
-			if (!l0y) {
+			if (!l0y)
 				hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
-			}
 		}
 
 		if (l1y) {
 			l1y = crystalhd_reg_rd(hw->adp, MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST1);
 			l1y &= DMA_START_BIT;
-			if (!l1y) {
+			if (!l1y)
 				hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
-			}
 		}
 
 		if (l0uv) {
 			l0uv = crystalhd_reg_rd(hw->adp, MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST0);
 			l0uv &= DMA_START_BIT;
-			if (!l0uv) {
+			if (!l0uv)
 				hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
-			}
 		}
 
 		if (l1uv) {
 			l1uv = crystalhd_reg_rd(hw->adp, MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST1);
 			l1uv &= DMA_START_BIT;
-			if (!l1uv) {
+			if (!l1uv)
 				hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
-			}
 		}
 		msleep_interruptible(100);
 		count--;
@@ -1431,9 +1427,8 @@ static bool crystalhd_rx_list1_handler(struct crystalhd_hw *hw, uint32_t int_sts
 
 	/* UV1 - DMA */
 	tmp = uv_err_sts & GET_UV1_ERR_MSK;
-	if (int_sts & INTR_INTR_STATUS_L1_UV_RX_DMA_DONE_INTR_MASK) {
+	if (int_sts & INTR_INTR_STATUS_L1_UV_RX_DMA_DONE_INTR_MASK)
 		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
-	}
 
 	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK) {
 		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
@@ -1739,7 +1734,7 @@ BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw, BC_FW_CMD *fw_cmd)
 	res_buff = fw_cmd->rsp;
 
 	if (!cmd_buff || !res_buff) {
-		BCMLOG_ERR("Invalid Parameters for F/W Command \n");
+		BCMLOG_ERR("Invalid Parameters for F/W Command\n");
 		return BC_STS_INV_ARG;
 	}
 
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 3eac70a..208edd4 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -50,7 +50,7 @@ static int chd_dec_enable_int(struct crystalhd_adp *adp)
 	rc = request_irq(adp->pdev->irq, chd_dec_isr, IRQF_SHARED,
 			 adp->name, (void *)adp);
 	if (rc) {
-		BCMLOG_ERR("Interrupt request failed.. \n");
+		BCMLOG_ERR("Interrupt request failed..\n");
 		pci_disable_msi(adp->pdev);
 	}
 
@@ -111,7 +111,7 @@ static inline int crystalhd_user_data(unsigned long ud, void *dr, int size, int
 	int rc;
 
 	if (!ud || !dr) {
-		BCMLOG_ERR("Invalid arg \n");
+		BCMLOG_ERR("Invalid arg\n");
 		return -EINVAL;
 	}
 
@@ -121,7 +121,7 @@ static inline int crystalhd_user_data(unsigned long ud, void *dr, int size, int
 		rc = copy_from_user(dr, (void *)ud, size);
 
 	if (rc) {
-		BCMLOG_ERR("Invalid args for command \n");
+		BCMLOG_ERR("Invalid args for command\n");
 		rc = -EFAULT;
 	}
 
@@ -205,7 +205,7 @@ static int chd_dec_proc_user_data(struct crystalhd_adp *adp,
 
 	rc = crystalhd_user_data(ua, &io->udata, sizeof(io->udata), set);
 	if (rc) {
-		BCMLOG_ERR("failed to %s iodata \n", (set ? "set" : "get"));
+		BCMLOG_ERR("failed to %s iodata\n", (set ? "set" : "get"));
 		return rc;
 	}
 
@@ -307,7 +307,7 @@ static int chd_dec_open(struct inode *in, struct file *fd)
 
 	sts = crystalhd_user_open(&adp->cmds, &uc);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("cmd_user_open - %d \n", sts);
+		BCMLOG_ERR("cmd_user_open - %d\n", sts);
 		rc = -EBUSY;
 	}
 
@@ -325,7 +325,7 @@ static int chd_dec_close(struct inode *in, struct file *fd)
 
 	BCMLOG_ENTER;
 	if (!adp) {
-		BCMLOG_ERR("Invalid adp \n");
+		BCMLOG_ERR("Invalid adp\n");
 		return -EINVAL;
 	}
 
@@ -520,7 +520,7 @@ static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
 
 	sts = crystalhd_delete_cmd_context(&pinfo->cmds);
 	if (sts != BC_STS_SUCCESS)
-		BCMLOG_ERR("cmd delete :%d \n", sts);
+		BCMLOG_ERR("cmd delete :%d\n", sts);
 
 	chd_dec_release_chdev(pinfo);
 
@@ -580,7 +580,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	chd_dec_init_chdev(pinfo);
 	rc = chd_dec_enable_int(pinfo);
 	if (rc) {
-		BCMLOG_ERR("_enable_int err:%d \n", rc);
+		BCMLOG_ERR("_enable_int err:%d\n", rc);
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
@@ -600,7 +600,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 
 	sts = crystalhd_setup_cmd_context(&pinfo->cmds, pinfo);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("cmd setup :%d \n", sts);
+		BCMLOG_ERR("cmd setup :%d\n", sts);
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
@@ -674,7 +674,7 @@ int chd_dec_pci_resume(struct pci_dev *pdev)
 
 	rc = chd_dec_enable_int(adp);
 	if (rc) {
-		BCMLOG_ERR("_enable_int err:%d \n", rc);
+		BCMLOG_ERR("_enable_int err:%d\n", rc);
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
@@ -737,13 +737,13 @@ static int __init chd_dec_module_init(void)
 	int rc;
 
 	chd_set_log_level(NULL, "debug");
-	BCMLOG(BCMLOG_DATA, "Loading crystalhd %d.%d.%d \n",
+	BCMLOG(BCMLOG_DATA, "Loading crystalhd %d.%d.%d\n",
 	       crystalhd_kmod_major, crystalhd_kmod_minor, crystalhd_kmod_rev);
 
 	rc = pci_register_driver(&bc_chd_70012_driver);
 
 	if (rc < 0)
-		BCMLOG_ERR("Could not find any devices. err:%d \n", rc);
+		BCMLOG_ERR("Could not find any devices. err:%d\n", rc);
 
 	return rc;
 }
@@ -751,7 +751,7 @@ module_init(chd_dec_module_init);
 
 static void __exit chd_dec_module_cleanup(void)
 {
-	BCMLOG(BCMLOG_DATA, "unloading crystalhd %d.%d.%d \n",
+	BCMLOG(BCMLOG_DATA, "unloading crystalhd %d.%d.%d\n",
 	       crystalhd_kmod_major, crystalhd_kmod_minor, crystalhd_kmod_rev);
 
 	pci_unregister_driver(&bc_chd_70012_driver);
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index d338ae9..eee4926 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -42,11 +42,11 @@
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "crystalhd_cmds.h"
 
diff --git a/drivers/staging/crystalhd/crystalhd_misc.c b/drivers/staging/crystalhd/crystalhd_misc.c
index 587dcc4..633967c 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.c
+++ b/drivers/staging/crystalhd/crystalhd_misc.c
@@ -235,7 +235,7 @@ BC_STATUS crystalhd_mem_rd(struct crystalhd_adp *adp, uint32_t start_off,
 
 	if (!adp || !rd_buff ||
 	    (bc_chk_dram_range(adp, start_off, dw_cnt) != BC_STS_SUCCESS)) {
-		BCMLOG_ERR("Invalid arg \n");
+		BCMLOG_ERR("Invalid arg\n");
 		return BC_STS_INV_ARG;
 	}
 	for (ix = 0; ix < dw_cnt; ix++)
@@ -263,7 +263,7 @@ BC_STATUS crystalhd_mem_wr(struct crystalhd_adp *adp, uint32_t start_off,
 
 	if (!adp || !wr_buff ||
 	    (bc_chk_dram_range(adp, start_off, dw_cnt) != BC_STS_SUCCESS)) {
-		BCMLOG_ERR("Invalid arg \n");
+		BCMLOG_ERR("Invalid arg\n");
 		return BC_STS_INV_ARG;
 	}
 
@@ -291,7 +291,7 @@ BC_STATUS crystalhd_pci_cfg_rd(struct crystalhd_adp *adp, uint32_t off,
 	int rc = 0;
 
 	if (!adp || !val) {
-		BCMLOG_ERR("Invalid arg \n");
+		BCMLOG_ERR("Invalid arg\n");
 		return BC_STS_INV_ARG;
 	}
 
@@ -336,7 +336,7 @@ BC_STATUS crystalhd_pci_cfg_wr(struct crystalhd_adp *adp, uint32_t off,
 	int rc = 0;
 
 	if (!adp || !val) {
-		BCMLOG_ERR("Invalid arg \n");
+		BCMLOG_ERR("Invalid arg\n");
 		return BC_STS_INV_ARG;
 	}
 
@@ -683,7 +683,7 @@ BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	int i = 0, rw = 0, res = 0, nr_pages = 0, skip_fb_sg = 0;
 
 	if (!adp || !ubuff || !ubuff_sz || !dio_hnd) {
-		BCMLOG_ERR("Invalid arg \n");
+		BCMLOG_ERR("Invalid arg\n");
 		return BC_STS_INV_ARG;
 	}
 	/* Compute pages */
@@ -789,7 +789,7 @@ BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	dio->sg_cnt = pci_map_sg(adp->pdev, dio->sg,
 				 dio->page_cnt, dio->direction);
 	if (dio->sg_cnt <= 0) {
-		BCMLOG_ERR("sg map %d-%d \n", dio->sg_cnt, dio->page_cnt);
+		BCMLOG_ERR("sg map %d-%d\n", dio->sg_cnt, dio->page_cnt);
 		crystalhd_unmap_dio(adp, dio);
 		return BC_STS_ERROR;
 	}
@@ -824,7 +824,7 @@ BC_STATUS crystalhd_unmap_dio(struct crystalhd_adp *adp, crystalhd_dio_req *dio)
 	int j = 0;
 
 	if (!adp || !dio) {
-		BCMLOG_ERR("Invalid arg \n");
+		BCMLOG_ERR("Invalid arg\n");
 		return BC_STS_INV_ARG;
 	}
 
@@ -945,7 +945,7 @@ void crystalhd_destroy_dio_pool(struct crystalhd_adp *adp)
 		adp->fill_byte_pool = NULL;
 	}
 
-	BCMLOG(BCMLOG_DBG, "Released dio pool %d \n", count);
+	BCMLOG(BCMLOG_DBG, "Released dio pool %d\n", count);
 }
 
 /**
@@ -971,7 +971,7 @@ int __devinit crystalhd_create_elem_pool(struct crystalhd_adp *adp,
 	for (i = 0; i < pool_size; i++) {
 		temp = kzalloc(sizeof(*temp), GFP_KERNEL);
 		if (!temp) {
-			BCMLOG_ERR("kalloc failed \n");
+			BCMLOG_ERR("kalloc failed\n");
 			return -ENOMEM;
 		}
 		crystalhd_free_elem(adp, temp);
-- 
1.7.0.2

