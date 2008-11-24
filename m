Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYKXRhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYKXRhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYKXRhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:37:11 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:36750 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYKXRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:37:10 -0500
Message-ID: <492AE7ED.8040304@suse.de>
Date: Tue, 25 Nov 2008 01:44:13 +0800
From: Coly Li <coyli@suse.de>
Reply-To: Coly Li <coyli@suse.de>
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] fix similar typos to successfull, v2
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I review ocfs2 code, find there are 2 typos to "successfull". After doing grep "successfull "
in kernel tree, 22 typos found totally --  great minds always think alike  :)

This patch fixes all the similar typos. Thanks for Randy's ack and comments.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/hwmon/abituguru-datasheet   |    4 ++--
 Documentation/scsi/scsi_fc_transport.txt  |    4 ++--
 arch/powerpc/platforms/cell/spufs/spufs.h |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c        |    2 +-
 drivers/isdn/hardware/eicon/debuglib.h    |    2 +-
 drivers/isdn/hardware/eicon/os_4bri.c     |    2 +-
 drivers/isdn/hardware/eicon/os_bri.c      |    2 +-
 drivers/isdn/hardware/eicon/os_pri.c      |    2 +-
 drivers/mtd/ubi/kapi.c                    |    2 +-
 drivers/net/wireless/ath5k/dma.c          |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c    |    2 +-
 drivers/s390/block/dasd_3990_erp.c        |    2 +-
 drivers/s390/block/dasd_int.h             |    2 +-
 drivers/s390/char/tape_3590.c             |    2 +-
 drivers/s390/cio/cio.c                    |    2 +-
 drivers/s390/cio/qdio_main.c              |    2 +-
 fs/ext4/extents.c                         |    2 +-
 fs/ocfs2/dlmglue.c                        |    4 ++--
 net/sctp/auth.c                           |    2 +-
 19 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/Documentation/hwmon/abituguru-datasheet b/Documentation/hwmon/abituguru-datasheet
index aef5a9b..12648f8 100644
--- a/Documentation/hwmon/abituguru-datasheet
+++ b/Documentation/hwmon/abituguru-datasheet
@@ -121,7 +121,7 @@ Once all bytes have been read data will hold 0x09, but there is no reason to
 test for this. Notice that the number of bytes is bank address dependent see
 above and below.

-After completing a successfull read it is advised to put the uGuru back in
+After completing a successful read it is advised to put the uGuru back in
 ready mode, so that it is ready for the next read / write cycle. This way
 if your program / driver is unloaded and later loaded again the detection
 algorithm described above will still work.
@@ -141,7 +141,7 @@ don't ask why this is the way it is.

 Once DATA holds 0x01 read CMD it should hold 0xAC now.

-After completing a successfull write it is advised to put the uGuru back in
+After completing a successful write it is advised to put the uGuru back in
 ready mode, so that it is ready for the next read / write cycle. This way
 if your program / driver is unloaded and later loaded again the detection
 algorithm described above will still work.
diff --git a/Documentation/scsi/scsi_fc_transport.txt b/Documentation/scsi/scsi_fc_transport.txt
index 38d324d..e5b071d 100644
--- a/Documentation/scsi/scsi_fc_transport.txt
+++ b/Documentation/scsi/scsi_fc_transport.txt
@@ -191,7 +191,7 @@ Vport States:
       This is equivalent to a driver "attach" on an adapter, which is
       independent of the adapter's link state.
     - Instantiation of the vport on the FC link via ELS traffic, etc.
-      This is equivalent to a "link up" and successfull link initialization.
+      This is equivalent to a "link up" and successful link initialization.
   Further information can be found in the interfaces section below for
   Vport Creation.

@@ -320,7 +320,7 @@ Vport Creation:
       This is equivalent to a driver "attach" on an adapter, which is
       independent of the adapter's link state.
     - Instantiation of the vport on the FC link via ELS traffic, etc.
-      This is equivalent to a "link up" and successfull link initialization.
+      This is equivalent to a "link up" and successful link initialization.

   The LLDD's vport_create() function will not synchronously wait for both
   parts to be fully completed before returning. It must validate that the
diff --git a/arch/powerpc/platforms/cell/spufs/spufs.h b/arch/powerpc/platforms/cell/spufs/spufs.h
index 15c62d3..3bf908e 100644
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -314,7 +314,7 @@ extern char *isolated_loader;
  *	we need to call spu_release(ctx) before sleeping, and
  *	then spu_acquire(ctx) when awoken.
  *
- * 	Returns with state_mutex re-acquired when successfull or
+ * 	Returns with state_mutex re-acquired when successful or
  * 	with -ERESTARTSYS and the state_mutex dropped when interrupted.
  */

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 2caf9da..121ff14 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2717,7 +2717,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	attr.qp_state = IB_QPS_RTS;
 	nes_modify_qp(&nesqp->ibqp, &attr, IB_QP_STATE, NULL);

-	/* notify OF layer that accept event was successfull */
+	/* notify OF layer that accept event was successful */
 	cm_id->add_ref(cm_id);

 	cm_event.event = IW_CM_EVENT_ESTABLISHED;
diff --git a/drivers/isdn/hardware/eicon/debuglib.h b/drivers/isdn/hardware/eicon/debuglib.h
index 016410c..8ea5877 100644
--- a/drivers/isdn/hardware/eicon/debuglib.h
+++ b/drivers/isdn/hardware/eicon/debuglib.h
@@ -235,7 +235,7 @@ typedef void ( * DbgOld) (unsigned short, char *, va_list) ;
 typedef void ( * DbgEv)  (unsigned short, unsigned long, va_list) ;
 typedef void ( * DbgIrq) (unsigned short, int, char *, va_list) ;
 typedef struct _DbgHandle_
-{ char    Registered ; /* driver successfull registered */
+{ char    Registered ; /* driver successfully registered */
 #define DBG_HANDLE_REG_NEW 0x01  /* this (new) structure    */
 #define DBG_HANDLE_REG_OLD 0x7f  /* old structure (see below)  */
  char    Version;  /* version of this structure  */
diff --git a/drivers/isdn/hardware/eicon/os_4bri.c b/drivers/isdn/hardware/eicon/os_4bri.c
index 7b4ec3f..c964b8d 100644
--- a/drivers/isdn/hardware/eicon/os_4bri.c
+++ b/drivers/isdn/hardware/eicon/os_4bri.c
@@ -997,7 +997,7 @@ diva_4bri_start_adapter(PISDN_ADAPTER IoAdapter,
 	diva_xdi_display_adapter_features(IoAdapter->ANum);

 	for (i = 0; i < IoAdapter->tasks; i++) {
-		DBG_LOG(("A(%d) %s adapter successfull started",
+		DBG_LOG(("A(%d) %s adapter successfully started",
 			 IoAdapter->QuadroList->QuadroAdapter[i]->ANum,
 			 (IoAdapter->tasks == 1) ? "BRI 2.0" : "4BRI"))
 		diva_xdi_didd_register_adapter(IoAdapter->QuadroList->QuadroAdapter[i]->ANum);
diff --git a/drivers/isdn/hardware/eicon/os_bri.c b/drivers/isdn/hardware/eicon/os_bri.c
index f31bba5..08f0199 100644
--- a/drivers/isdn/hardware/eicon/os_bri.c
+++ b/drivers/isdn/hardware/eicon/os_bri.c
@@ -736,7 +736,7 @@ diva_bri_start_adapter(PISDN_ADAPTER IoAdapter,

 	IoAdapter->Properties.Features = (word) features;
 	diva_xdi_display_adapter_features(IoAdapter->ANum);
-	DBG_LOG(("A(%d) BRI adapter successfull started", IoAdapter->ANum))
+	DBG_LOG(("A(%d) BRI adapter successfully started", IoAdapter->ANum))
 	    /*
 	       Register with DIDD
 	     */
diff --git a/drivers/isdn/hardware/eicon/os_pri.c b/drivers/isdn/hardware/eicon/os_pri.c
index 9033565..5d65405 100644
--- a/drivers/isdn/hardware/eicon/os_pri.c
+++ b/drivers/isdn/hardware/eicon/os_pri.c
@@ -513,7 +513,7 @@ diva_pri_start_adapter(PISDN_ADAPTER IoAdapter,

 	diva_xdi_display_adapter_features(IoAdapter->ANum);

-	DBG_LOG(("A(%d) PRI adapter successfull started", IoAdapter->ANum))
+	DBG_LOG(("A(%d) PRI adapter successfully started", IoAdapter->ANum))
 	/*
 	   Register with DIDD
 	 */
diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 5d9bcf1..4abbe57 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -564,7 +564,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_unmap);
  * @dtype: expected data type
  *
  * This function maps an un-mapped logical eraseblock @lnum to a physical
- * eraseblock. This means, that after a successfull invocation of this
+ * eraseblock. This means, that after a successful invocation of this
  * function the logical eraseblock @lnum will be empty (contain only %0xFF
  * bytes) and be mapped to a physical eraseblock, even if an unclean reboot
  * happens.
diff --git a/drivers/net/wireless/ath5k/dma.c b/drivers/net/wireless/ath5k/dma.c
index 7adceb2..650bed0 100644
--- a/drivers/net/wireless/ath5k/dma.c
+++ b/drivers/net/wireless/ath5k/dma.c
@@ -530,7 +530,7 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 	 * XXX: BMISS interrupts may occur after association.
 	 * I found this on 5210 code but it needs testing. If this is
 	 * true we should disable them before assoc and re-enable them
-	 * after a successfull assoc + some jiffies.
+	 * after a successful assoc + some jiffies.
 	 */
 #if 0
 	interrupt_mask &= ~AR5K_INT_BMISS;
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index fe1867b..e4a19a4 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -287,7 +287,7 @@ static void zd_op_stop(struct ieee80211_hw *hw)
  * @skb - a sk-buffer
  * @flags: extra flags to set in the TX status info
  * @ackssi: ACK signal strength
- * @success - True for successfull transmission of the frame
+ * @success - True for successful transmission of the frame
  *
  * This information calls ieee80211_tx_status_irqsafe() if required by the
  * control information. It copies the control information into the status
diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index b8f9c00..d82aad5 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2621,7 +2621,7 @@ dasd_3990_erp_action(struct dasd_ccw_req * cqr)
 		}
 	}

-	/* double-check if current erp/cqr was successfull */
+	/* double-check if current erp/cqr was successful */
 	if ((cqr->irb.scsw.cmd.cstat == 0x00) &&
 	    (cqr->irb.scsw.cmd.dstat ==
 	     (DEV_STAT_CHN_END | DEV_STAT_DEV_END))) {
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 05a1453..4a39084 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -199,7 +199,7 @@ struct dasd_ccw_req {
 #define DASD_CQR_ERROR		0x82	/* request is completed with error */
 #define DASD_CQR_CLEAR_PENDING	0x83	/* request is clear pending */
 #define DASD_CQR_CLEARED	0x84	/* request was cleared */
-#define DASD_CQR_SUCCESS	0x85	/* request was successfull */
+#define DASD_CQR_SUCCESS	0x85	/* request was successful */


 /* per dasd_ccw_req flags */
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index 4005c44..71605a1 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -801,7 +801,7 @@ tape_3590_done(struct tape_device *device, struct tape_request *request)
 static inline int
 tape_3590_erp_succeded(struct tape_device *device, struct tape_request *request)
 {
-	DBF_EVENT(3, "Error Recovery successfull for %s\n",
+	DBF_EVENT(3, "Error Recovery successful for %s\n",
 		  tape_op_verbose[request->op]);
 	return tape_3590_done(device, request);
 }
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 3db2c38..ecf77bd 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -380,7 +380,7 @@ cio_modify (struct subchannel *sch)
 		if (ccode < 0)	/* -EIO if msch gets a program check. */
 			return ccode;
 		switch (ccode) {
-		case 0: /* successfull */
+		case 0: /* successful */
 			return 0;
 		case 1:	/* status pending */
 			return -EBUSY;
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 7c86591..7d9194f 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -116,7 +116,7 @@ static inline int qdio_check_ccq(struct qdio_q *q, unsigned int ccq)
  * @start: buffer number to start at
  * @count: count of buffers to examine
  *
- * Returns the number of successfull extracted equal buffer states.
+ * Returns the number of successfully extracted equal buffer states.
  * Stops processing if a state is different from the last buffers state.
  */
 static int qdio_do_eqbs(struct qdio_q *q, unsigned char *state,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ea2ce3c..3f54db3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2536,7 +2536,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		 */
 		newdepth = ext_depth(inode);
 		/*
-		 * update the extent length after successfull insert of the
+		 * update the extent length after successful insert of the
 		 * split extent
 		 */
 		orig_ex.ee_len = cpu_to_le16(ee_len -
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index ec68442..d0cd0e1 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1290,7 +1290,7 @@ again:
 			goto out;
 		}

-		mlog(0, "lock %s, successfull return from ocfs2_dlm_lock\n",
+		mlog(0, "lock %s, successful return from ocfs2_dlm_lock\n",
 		     lockres->l_name);

 		/* At this point we've gone inside the dlm and need to
@@ -2923,7 +2923,7 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 		ocfs2_dlm_dump_lksb(&lockres->l_lksb);
 		BUG();
 	}
-	mlog(0, "lock %s, successfull return from ocfs2_dlm_unlock\n",
+	mlog(0, "lock %s, successful return from ocfs2_dlm_unlock\n",
 	     lockres->l_name);

 	ocfs2_wait_on_busy_lock(lockres);
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 52db5f6..e36c107 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -489,7 +489,7 @@ int sctp_auth_init_hmacs(struct sctp_endpoint *ep, gfp_t gfp)
 	return 0;

 out_err:
-	/* Clean up any successfull allocations */
+	/* Clean up any successful allocations */
 	sctp_auth_destroy_hmacs(ep->auth_hmacs);
 	return -ENOMEM;
 }
-- 
Coly Li
SuSE PRC Labs
