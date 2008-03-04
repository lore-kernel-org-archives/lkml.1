Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbYCDDN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbYCDDN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYCDDKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:10:20 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:38813 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbYCDDKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d/UBZPSoGsHekCfxm5dZOrVZ0xwnyi1EFsbwizciw2nStVEoE8u4DrEA7GwnuQj8x0LxZWByf2CLJx03TG9wtqxXgXQyNT+bGwM6ESWsR0S6Qc+AIpcwhLGAmE/wyphHZ01Bj75YeBN4wcR6Q6ghaOJcdXipV1acXLu99df3wBY=
Subject: [PATCH 08/14] scsi: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:49 -0800
Message-Id: <1204600189.22933.88.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/advansys.c               |    2 +-
 drivers/scsi/aha152x.c                |   12 ++++----
 drivers/scsi/aic94xx/aic94xx.h        |    4 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c    |    2 +-
 drivers/scsi/aic94xx/aic94xx_scb.c    |   46 ++++++++++++++++----------------
 drivers/scsi/aic94xx/aic94xx_task.c   |    2 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c    |   18 ++++++------
 drivers/scsi/arm/fas216.c             |    4 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c      |    2 +-
 drivers/scsi/imm.c                    |    2 +-
 drivers/scsi/ipr.h                    |    6 ++--
 drivers/scsi/iscsi_tcp.c              |   12 ++++----
 drivers/scsi/libsas/sas_ata.c         |   16 +++++-----
 drivers/scsi/libsas/sas_expander.c    |   12 ++++----
 drivers/scsi/libsas/sas_port.c        |    4 +-
 drivers/scsi/libsas/sas_scsi_host.c   |   28 ++++++++++----------
 drivers/scsi/libsrp.c                 |    2 +-
 drivers/scsi/lpfc/lpfc_init.c         |    4 +-
 drivers/scsi/lpfc/lpfc_scsi.c         |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c          |    6 ++--
 drivers/scsi/megaraid/mega_common.h   |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c |   16 +++++-----
 drivers/scsi/megaraid/megaraid_mm.c   |    4 +-
 drivers/scsi/nsp32.c                  |    4 +-
 drivers/scsi/nsp32_debug.c            |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c          |    4 +-
 drivers/scsi/pcmcia/nsp_debug.c       |    2 +-
 drivers/scsi/ppa.c                    |    2 +-
 drivers/scsi/qla1280.c                |   12 ++++----
 drivers/scsi/scsi_debug.c             |   12 ++++----
 drivers/scsi/scsi_devinfo.c           |    6 ++--
 drivers/scsi/scsi_error.c             |   26 +++++++++---------
 drivers/scsi/scsi_lib.c               |    6 ++--
 drivers/scsi/scsi_netlink.c           |    8 +++---
 drivers/scsi/scsi_proc.c              |    4 +-
 drivers/scsi/scsi_scan.c              |   12 ++++----
 drivers/scsi/scsi_tgt_priv.h          |    2 +-
 drivers/scsi/scsi_transport_fc.c      |   12 ++++----
 drivers/scsi/scsi_transport_sas.c     |    4 +-
 drivers/scsi/tmscsim.c                |    8 +++---
 drivers/scsi/wd7000.c                 |    8 +++---
 drivers/scsi/zalon.c                  |    8 +++---
 42 files changed, 175 insertions(+), 175 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 3c2d688..2612fc8 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2278,7 +2278,7 @@ do { \
 #define ASC_DBG(lvl, format, arg...) {					\
 	if (asc_dbglvl >= (lvl))					\
 		printk(KERN_DEBUG "%s: %s: " format, DRV_NAME,		\
-			__FUNCTION__ , ## arg);				\
+			__func__ , ## arg);				\
 }
 
 #define ASC_DBG_PRT_SCSI_HOST(lvl, s) \
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 6ccdc96..1442d90 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -288,20 +288,20 @@ static LIST_HEAD(aha152x_host_list);
 #define DO_LOCK(flags)	\
 	do { \
 		if(spin_is_locked(&QLOCK)) { \
-			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
+			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __func__, __LINE__, QLOCKER, QLOCKERL); \
 		} \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
 		spin_lock_irqsave(&QLOCK,flags); \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
-		QLOCKER=__FUNCTION__; \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
+		QLOCKER=__func__; \
 		QLOCKERL=__LINE__; \
 	} while(0)
 
 #define DO_UNLOCK(flags)	\
 	do { \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __func__, __LINE__, QLOCKER, QLOCKERL); \
 		spin_unlock_irqrestore(&QLOCK,flags); \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
 		QLOCKER="(not locked)"; \
 		QLOCKERL=0; \
 	} while(0)
diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index 32f513b..452cc0e 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -39,9 +39,9 @@
 
 #ifdef ASD_ENTER_EXIT
 #define ENTER  printk(KERN_NOTICE "%s: ENTER %s\n", ASD_DRIVER_NAME, \
-		__FUNCTION__)
+		__func__)
 #define EXIT   printk(KERN_NOTICE "%s: --EXIT %s\n", ASD_DRIVER_NAME, \
-		__FUNCTION__)
+		__func__)
 #else
 #define ENTER
 #define EXIT
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 098b5f3..e70aa8a 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1361,7 +1361,7 @@ int asd_enable_phys(struct asd_ha_struct *asd_ha, const u8 phy_mask)
 	struct asd_ascb *ascb_list;
 
 	if (!phy_mask) {
-		asd_printk("%s called with phy_mask of 0!?\n", __FUNCTION__);
+		asd_printk("%s called with phy_mask of 0!?\n", __func__);
 		return 0;
 	}
 
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index ab35050..afe5bc8 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -212,7 +212,7 @@ static void asd_form_port(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
 		phy->asd_port = port;
 	}
 	ASD_DPRINTK("%s: updating phy_mask 0x%x for phy%d\n",
-		    __FUNCTION__, phy->asd_port->phy_mask, sas_phy->id);
+		    __func__, phy->asd_port->phy_mask, sas_phy->id);
 	asd_update_port_links(asd_ha, phy);
 	spin_unlock_irqrestore(&asd_ha->asd_ports_lock, flags);
 }
@@ -295,7 +295,7 @@ static inline void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
 		struct asd_ascb *cp = asd_ascb_alloc_list(ascb->ha, &num,
 							  GFP_ATOMIC);
 		if (!cp) {
-			asd_printk("%s: out of memory\n", __FUNCTION__);
+			asd_printk("%s: out of memory\n", __func__);
 			goto out;
 		}
 		ASD_DPRINTK("phy%d: retries:0 performing link reset seq\n",
@@ -447,7 +447,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		struct domain_device *failed_dev = NULL;
 
 		ASD_DPRINTK("%s: REQ_TASK_ABORT, reason=0x%X\n",
-			    __FUNCTION__, dl->status_block[3]);
+			    __func__, dl->status_block[3]);
 
 		/*
 		 * Find the task that caused the abort and abort it first.
@@ -475,7 +475,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 
 		if (!failed_dev) {
 			ASD_DPRINTK("%s: Can't find task (tc=%d) to abort!\n",
-				    __FUNCTION__, tc_abort);
+				    __func__, tc_abort);
 			goto out;
 		}
 
@@ -503,7 +503,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		conn_handle = *((u16*)(&dl->status_block[1]));
 		conn_handle = le16_to_cpu(conn_handle);
 
-		ASD_DPRINTK("%s: REQ_DEVICE_RESET, reason=0x%X\n", __FUNCTION__,
+		ASD_DPRINTK("%s: REQ_DEVICE_RESET, reason=0x%X\n", __func__,
 			    dl->status_block[3]);
 
 		/* Find the last pending task for the device... */
@@ -523,7 +523,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 
 		if (!last_dev_task) {
 			ASD_DPRINTK("%s: Device reset for idle device %d?\n",
-				    __FUNCTION__, conn_handle);
+				    __func__, conn_handle);
 			goto out;
 		}
 
@@ -550,10 +550,10 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		goto out;
 	}
 	case SIGNAL_NCQ_ERROR:
-		ASD_DPRINTK("%s: SIGNAL_NCQ_ERROR\n", __FUNCTION__);
+		ASD_DPRINTK("%s: SIGNAL_NCQ_ERROR\n", __func__);
 		goto out;
 	case CLEAR_NCQ_ERROR:
-		ASD_DPRINTK("%s: CLEAR_NCQ_ERROR\n", __FUNCTION__);
+		ASD_DPRINTK("%s: CLEAR_NCQ_ERROR\n", __func__);
 		goto out;
 	}
 
@@ -561,26 +561,26 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 
 	switch (sb_opcode) {
 	case BYTES_DMAED:
-		ASD_DPRINTK("%s: phy%d: BYTES_DMAED\n", __FUNCTION__, phy_id);
+		ASD_DPRINTK("%s: phy%d: BYTES_DMAED\n", __func__, phy_id);
 		asd_bytes_dmaed_tasklet(ascb, dl, edb, phy_id);
 		break;
 	case PRIMITIVE_RECVD:
-		ASD_DPRINTK("%s: phy%d: PRIMITIVE_RECVD\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: PRIMITIVE_RECVD\n", __func__,
 			    phy_id);
 		asd_primitive_rcvd_tasklet(ascb, dl, phy_id);
 		break;
 	case PHY_EVENT:
-		ASD_DPRINTK("%s: phy%d: PHY_EVENT\n", __FUNCTION__, phy_id);
+		ASD_DPRINTK("%s: phy%d: PHY_EVENT\n", __func__, phy_id);
 		asd_phy_event_tasklet(ascb, dl);
 		break;
 	case LINK_RESET_ERROR:
-		ASD_DPRINTK("%s: phy%d: LINK_RESET_ERROR\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: LINK_RESET_ERROR\n", __func__,
 			    phy_id);
 		asd_link_reset_err_tasklet(ascb, dl, phy_id);
 		break;
 	case TIMER_EVENT:
 		ASD_DPRINTK("%s: phy%d: TIMER_EVENT, lost dw sync\n",
-			    __FUNCTION__, phy_id);
+			    __func__, phy_id);
 		asd_turn_led(asd_ha, phy_id, 0);
 		/* the device is gone */
 		sas_phy_disconnected(sas_phy);
@@ -588,7 +588,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		sas_ha->notify_port_event(sas_phy, PORTE_TIMER_EVENT);
 		break;
 	default:
-		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __func__,
 			    phy_id, sb_opcode);
 		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n",
 			    edb, dl->opcode);
@@ -655,7 +655,7 @@ static void control_phy_tasklet_complete(struct asd_ascb *ascb,
 
 	if (status != 0) {
 		ASD_DPRINTK("%s: phy%d status block opcode:0x%x\n",
-			    __FUNCTION__, phy_id, status);
+			    __func__, phy_id, status);
 		goto out;
 	}
 
@@ -664,7 +664,7 @@ static void control_phy_tasklet_complete(struct asd_ascb *ascb,
 		asd_ha->hw_prof.enabled_phys &= ~(1 << phy_id);
 		asd_turn_led(asd_ha, phy_id, 0);
 		asd_control_led(asd_ha, phy_id, 0);
-		ASD_DPRINTK("%s: disable phy%d\n", __FUNCTION__, phy_id);
+		ASD_DPRINTK("%s: disable phy%d\n", __func__, phy_id);
 		break;
 
 	case ENABLE_PHY:
@@ -674,40 +674,40 @@ static void control_phy_tasklet_complete(struct asd_ascb *ascb,
 			get_lrate_mode(phy, oob_mode);
 			asd_turn_led(asd_ha, phy_id, 1);
 			ASD_DPRINTK("%s: phy%d, lrate:0x%x, proto:0x%x\n",
-				    __FUNCTION__, phy_id,phy->sas_phy.linkrate,
+				    __func__, phy_id,phy->sas_phy.linkrate,
 				    phy->sas_phy.iproto);
 		} else if (oob_status & CURRENT_SPINUP_HOLD) {
 			asd_ha->hw_prof.enabled_phys |= (1 << phy_id);
 			asd_turn_led(asd_ha, phy_id, 1);
-			ASD_DPRINTK("%s: phy%d, spinup hold\n", __FUNCTION__,
+			ASD_DPRINTK("%s: phy%d, spinup hold\n", __func__,
 				    phy_id);
 		} else if (oob_status & CURRENT_ERR_MASK) {
 			asd_turn_led(asd_ha, phy_id, 0);
 			ASD_DPRINTK("%s: phy%d: error: oob status:0x%02x\n",
-				    __FUNCTION__, phy_id, oob_status);
+				    __func__, phy_id, oob_status);
 		} else if (oob_status & (CURRENT_HOT_PLUG_CNCT
 					 | CURRENT_DEVICE_PRESENT))  {
 			asd_ha->hw_prof.enabled_phys |= (1 << phy_id);
 			asd_turn_led(asd_ha, phy_id, 1);
 			ASD_DPRINTK("%s: phy%d: hot plug or device present\n",
-				    __FUNCTION__, phy_id);
+				    __func__, phy_id);
 		} else {
 			asd_ha->hw_prof.enabled_phys |= (1 << phy_id);
 			asd_turn_led(asd_ha, phy_id, 0);
 			ASD_DPRINTK("%s: phy%d: no device present: "
 				    "oob_status:0x%x\n",
-				    __FUNCTION__, phy_id, oob_status);
+				    __func__, phy_id, oob_status);
 		}
 		break;
 	case RELEASE_SPINUP_HOLD:
 	case PHY_NO_OP:
 	case EXECUTE_HARD_RESET:
-		ASD_DPRINTK("%s: phy%d: sub_func:0x%x\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: sub_func:0x%x\n", __func__,
 			    phy_id, control_phy->sub_func);
 		/* XXX finish */
 		break;
 	default:
-		ASD_DPRINTK("%s: phy%d: sub_func:0x%x?\n", __FUNCTION__,
+		ASD_DPRINTK("%s: phy%d: sub_func:0x%x?\n", __func__,
 			    phy_id, control_phy->sub_func);
 		break;
 	}
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 965d4bb..aa4d65d 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -320,7 +320,7 @@ Again:
 	case TC_RESUME:
 	case TC_PARTIAL_SG_LIST:
 	default:
-		ASD_DPRINTK("%s: dl opcode: 0x%x?\n", __FUNCTION__, opcode);
+		ASD_DPRINTK("%s: dl opcode: 0x%x?\n", __func__, opcode);
 		break;
 	}
 
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 144f5ad..25d163e 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -70,12 +70,12 @@ static inline void asd_timedout_common(unsigned long data)
 static void asd_clear_nexus_tasklet_complete(struct asd_ascb *ascb,
 					     struct done_list_struct *dl)
 {
-	ASD_DPRINTK("%s: here\n", __FUNCTION__);
+	ASD_DPRINTK("%s: here\n", __func__);
 	if (!del_timer(&ascb->timer)) {
-		ASD_DPRINTK("%s: couldn't delete timer\n", __FUNCTION__);
+		ASD_DPRINTK("%s: couldn't delete timer\n", __func__);
 		return;
 	}
-	ASD_DPRINTK("%s: opcode: 0x%x\n", __FUNCTION__, dl->opcode);
+	ASD_DPRINTK("%s: opcode: 0x%x\n", __func__, dl->opcode);
 	ascb->uldd_task = (void *) (unsigned long) dl->opcode;
 	complete(&ascb->completion);
 }
@@ -84,14 +84,14 @@ static void asd_clear_nexus_timedout(unsigned long data)
 {
 	struct asd_ascb *ascb = (void *) data;
 
-	ASD_DPRINTK("%s: here\n", __FUNCTION__);
+	ASD_DPRINTK("%s: here\n", __func__);
 	asd_timedout_common(data);
 	ascb->uldd_task = (void *) TMF_RESP_FUNC_FAILED;
 	complete(&ascb->completion);
 }
 
 #define CLEAR_NEXUS_PRE         \
-	ASD_DPRINTK("%s: PRE\n", __FUNCTION__); \
+	ASD_DPRINTK("%s: PRE\n", __func__); \
         res = 1;                \
 	ascb = asd_ascb_alloc_list(asd_ha, &res, GFP_KERNEL); \
 	if (!ascb)              \
@@ -101,12 +101,12 @@ static void asd_clear_nexus_timedout(unsigned long data)
 	scb->header.opcode = CLEAR_NEXUS
 
 #define CLEAR_NEXUS_POST        \
-	ASD_DPRINTK("%s: POST\n", __FUNCTION__); \
+	ASD_DPRINTK("%s: POST\n", __func__); \
 	res = asd_enqueue_internal(ascb, asd_clear_nexus_tasklet_complete, \
 				   asd_clear_nexus_timedout);              \
 	if (res)                \
 		goto out_err;   \
-	ASD_DPRINTK("%s: clear nexus posted, waiting...\n", __FUNCTION__); \
+	ASD_DPRINTK("%s: clear nexus posted, waiting...\n", __func__); \
 	wait_for_completion(&ascb->completion); \
 	res = (int) (unsigned long) ascb->uldd_task; \
 	if (res == TC_NO_ERROR) \
@@ -355,7 +355,7 @@ int asd_abort_task(struct sas_task *task)
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		res = TMF_RESP_FUNC_COMPLETE;
-		ASD_DPRINTK("%s: task 0x%p done\n", __FUNCTION__, task);
+		ASD_DPRINTK("%s: task 0x%p done\n", __func__, task);
 		goto out_done;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -418,7 +418,7 @@ int asd_abort_task(struct sas_task *task)
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		res = TMF_RESP_FUNC_COMPLETE;
-		ASD_DPRINTK("%s: task 0x%p done\n", __FUNCTION__, task);
+		ASD_DPRINTK("%s: task 0x%p done\n", __func__, task);
 		goto out_done;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index a715632..4775426 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -240,7 +240,7 @@ static void __fas216_checkmagic(FAS216_Info *info, const char *func)
 		panic("scsi memory space corrupted in %s", func);
 	}
 }
-#define fas216_checkmagic(info) __fas216_checkmagic((info), __FUNCTION__)
+#define fas216_checkmagic(info) __fas216_checkmagic((info), __func__)
 #else
 #define fas216_checkmagic(info)
 #endif
@@ -2658,7 +2658,7 @@ int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
 	fas216_checkmagic(info);
 
 	printk("scsi%d.%c: %s: resetting host\n",
-		info->host->host_no, '0' + SCpnt->device->id, __FUNCTION__);
+		info->host->host_no, '0' + SCpnt->device->id, __func__);
 
 	/*
 	 * Reset the SCSI chip.
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index bd62131..5fe60d6 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -55,7 +55,7 @@
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index f97d172..c2a9a13 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -163,7 +163,7 @@ static int imm_proc_info(struct Scsi_Host *host, char *buffer, char **start,
 
 #if IMM_DEBUG > 0
 #define imm_fail(x,y) printk("imm: imm_fail(%i) from %s at line %d\n",\
-	   y, __FUNCTION__, __LINE__); imm_fail_func(x,y);
+	   y, __func__, __LINE__); imm_fail_func(x,y);
 static inline void
 imm_fail_func(imm_struct *dev, int error_code)
 #else
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index d931566..4871dd1 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1403,10 +1403,10 @@ struct ipr_ucode_image_header {
 }
 
 #define ipr_trace ipr_dbg("%s: %s: Line: %d\n",\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 
-#define ENTER IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Entering %s\n", __FUNCTION__))
-#define LEAVE IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Leaving %s\n", __FUNCTION__))
+#define ENTER IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Entering %s\n", __func__))
+#define LEAVE IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Leaving %s\n", __func__))
 
 #define ipr_err_separator \
 ipr_err("----------------------------------------------------------\n")
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8a17867..a6f9dd2 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -535,7 +535,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	if (tcp_ctask->exp_datasn != datasn) {
 		debug_tcp("%s: ctask->exp_datasn(%d) != rhdr->datasn(%d)\n",
-		          __FUNCTION__, tcp_ctask->exp_datasn, datasn);
+		          __func__, tcp_ctask->exp_datasn, datasn);
 		return ISCSI_ERR_DATASN;
 	}
 
@@ -544,7 +544,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	tcp_ctask->data_offset = be32_to_cpu(rhdr->offset);
 	if (tcp_ctask->data_offset + tcp_conn->in.datalen > scsi_bufflen(sc)) {
 		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
-		          __FUNCTION__, tcp_ctask->data_offset,
+		          __func__, tcp_ctask->data_offset,
 		          tcp_conn->in.datalen, scsi_bufflen(sc));
 		return ISCSI_ERR_DATA_OFFSET;
 	}
@@ -637,7 +637,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	if (tcp_ctask->exp_datasn != r2tsn){
 		debug_tcp("%s: ctask->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
-		          __FUNCTION__, tcp_ctask->exp_datasn, r2tsn);
+		          __func__, tcp_ctask->exp_datasn, r2tsn);
 		return ISCSI_ERR_R2TSN;
 	}
 
@@ -1174,7 +1174,7 @@ iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
-	debug_tcp("%s(%p%s)\n", __FUNCTION__, tcp_conn,
+	debug_tcp("%s(%p%s)\n", __func__, tcp_conn,
 			conn->hdrdgst_en? ", digest enabled" : "");
 
 	/* Clear the data segment - needs to be filled in by the
@@ -1215,7 +1215,7 @@ iscsi_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, offset=%d, datalen=%d%s)\n", __FUNCTION__,
+	debug_tcp("%s(%p, offset=%d, datalen=%d%s)\n", __func__,
 			tcp_conn, offset, len,
 			conn->datadgst_en? ", digest enabled" : "");
 
@@ -1240,7 +1240,7 @@ iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, datalen=%d%s)\n", __FUNCTION__, tcp_conn, len,
+	debug_tcp("%s(%p, datalen=%d%s)\n", __func__, tcp_conn, len,
 		  conn->datadgst_en? ", digest enabled" : "");
 
 	/* Make sure the datalen matches what the caller
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7cd05b5..9acb06b 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -74,7 +74,7 @@ static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 		case SAS_OPEN_TO:
 		case SAS_OPEN_REJECT:
 			SAS_DPRINTK("%s: Saw error %d.  What to do?\n",
-				    __FUNCTION__, ts->stat);
+				    __func__, ts->stat);
 			return AC_ERR_OTHER;
 
 		case SAS_ABORTED_TASK:
@@ -115,7 +115,7 @@ static void sas_ata_task_done(struct sas_task *task)
 	} else if (stat->stat != SAM_STAT_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
-			SAS_DPRINTK("%s: SAS error %x\n", __FUNCTION__,
+			SAS_DPRINTK("%s: SAS error %x\n", __func__,
 				    stat->stat);
 			/* We saw a SAS error. Send a vague error. */
 			qc->err_mask = ac;
@@ -242,20 +242,20 @@ static void sas_ata_phy_reset(struct ata_port *ap)
 		res = i->dft->lldd_I_T_nexus_reset(dev);
 
 	if (res)
-		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __FUNCTION__);
+		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __func__);
 
 	switch (dev->sata_dev.command_set) {
 		case ATA_COMMAND_SET:
-			SAS_DPRINTK("%s: Found ATA device.\n", __FUNCTION__);
+			SAS_DPRINTK("%s: Found ATA device.\n", __func__);
 			ap->link.device[0].class = ATA_DEV_ATA;
 			break;
 		case ATAPI_COMMAND_SET:
-			SAS_DPRINTK("%s: Found ATAPI device.\n", __FUNCTION__);
+			SAS_DPRINTK("%s: Found ATAPI device.\n", __func__);
 			ap->link.device[0].class = ATA_DEV_ATAPI;
 			break;
 		default:
 			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
-				    __FUNCTION__,
+				    __func__,
 				    dev->sata_dev.command_set);
 			ap->link.device[0].class = ATA_DEV_UNKNOWN;
 			break;
@@ -303,7 +303,7 @@ static int sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 {
 	struct domain_device *dev = ap->private_data;
 
-	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
+	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
 		case SCR_STATUS:
 			dev->sata_dev.sstatus = val;
@@ -328,7 +328,7 @@ static int sas_ata_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
 {
 	struct domain_device *dev = ap->private_data;
 
-	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
+	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
 		case SCR_STATUS:
 			*val = dev->sata_dev.sstatus;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index aefd865..3da02e4 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -121,7 +121,7 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 			break;
 		} else {
 			SAS_DPRINTK("%s: task to dev %016llx response: 0x%x "
-				    "status 0x%x\n", __FUNCTION__,
+				    "status 0x%x\n", __func__,
 				    SAS_ADDR(dev->sas_addr),
 				    task->task_status.resp,
 				    task->task_status.stat);
@@ -1279,7 +1279,7 @@ static int sas_configure_present(struct domain_device *dev, int phy_id,
 			goto out;
 		} else if (res != SMP_RESP_FUNC_ACC) {
 			SAS_DPRINTK("%s: dev %016llx phy 0x%x index 0x%x "
-				    "result 0x%x\n", __FUNCTION__,
+				    "result 0x%x\n", __func__,
 				    SAS_ADDR(dev->sas_addr), phy_id, i, res);
 			goto out;
 		}
@@ -1901,7 +1901,7 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	if (!rsp) {
 		printk("%s: space for a smp response is missing\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EINVAL;
 	}
 
@@ -1914,20 +1914,20 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	if (type != SAS_EDGE_EXPANDER_DEVICE &&
 	    type != SAS_FANOUT_EXPANDER_DEVICE) {
 		printk("%s: can we send a smp request to a device?\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EINVAL;
 	}
 
 	dev = sas_find_dev_by_rphy(rphy);
 	if (!dev) {
-		printk("%s: fail to find a domain_device?\n", __FUNCTION__);
+		printk("%s: fail to find a domain_device?\n", __func__);
 		return -EINVAL;
 	}
 
 	/* do we need to support multiple segments? */
 	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
 		printk("%s: multiple segments req %u %u, rsp %u %u\n",
-		       __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		       __func__, req->bio->bi_vcnt, req->data_len,
 		       rsp->bio->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index e1e2d08..dfce349 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -50,7 +50,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 			sas_deform_port(phy);
 		else {
 			SAS_DPRINTK("%s: phy%d belongs to port%d already(%d)!\n",
-				    __FUNCTION__, phy->id, phy->port->id,
+				    __func__, phy->id, phy->port->id,
 				    phy->port->num_phys);
 			return;
 		}
@@ -78,7 +78,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 
 	if (i >= sas_ha->num_phys) {
 		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",
-		       __FUNCTION__);
+		       __func__);
 		spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 		return;
 	}
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 704ea06..4fee9b2 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -341,7 +341,7 @@ static enum task_disposition sas_scsi_find_task(struct sas_task *task)
 						       flags);
 				SAS_DPRINTK("%s: task 0x%p aborted from "
 					    "task_queue\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_ABORTED;
 			}
 		}
@@ -349,13 +349,13 @@ static enum task_disposition sas_scsi_find_task(struct sas_task *task)
 	}
 
 	for (i = 0; i < 5; i++) {
-		SAS_DPRINTK("%s: aborting task 0x%p\n", __FUNCTION__, task);
+		SAS_DPRINTK("%s: aborting task 0x%p\n", __func__, task);
 		res = si->dft->lldd_abort_task(task);
 
 		spin_lock_irqsave(&task->task_state_lock, flags);
 		if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 			spin_unlock_irqrestore(&task->task_state_lock, flags);
-			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
+			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
 			return TASK_IS_DONE;
 		}
@@ -363,24 +363,24 @@ static enum task_disposition sas_scsi_find_task(struct sas_task *task)
 
 		if (res == TMF_RESP_FUNC_COMPLETE) {
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			return TASK_IS_ABORTED;
 		} else if (si->dft->lldd_query_task) {
 			SAS_DPRINTK("%s: querying task 0x%p\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			res = si->dft->lldd_query_task(task);
 			switch (res) {
 			case TMF_RESP_FUNC_SUCC:
 				SAS_DPRINTK("%s: task 0x%p at LU\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_AT_LU;
 			case TMF_RESP_FUNC_COMPLETE:
 				SAS_DPRINTK("%s: task 0x%p not at LU\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_NOT_AT_LU;
 			case TMF_RESP_FUNC_FAILED:
                                 SAS_DPRINTK("%s: task 0x%p failed to abort\n",
-                                                __FUNCTION__, task);
+                                                __func__, task);
                                 return TASK_ABORT_FAILED;
                         }
 
@@ -547,7 +547,7 @@ Again:
 
 		switch (res) {
 		case TASK_IS_DONE:
-			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
+			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
 			sas_eh_finish_cmd(cmd);
 			if (need_reset)
@@ -555,7 +555,7 @@ Again:
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			sas_eh_finish_cmd(cmd);
 			if (need_reset)
 				try_to_reset_cmd_device(shost, cmd);
@@ -635,7 +635,7 @@ Again:
 	}
 	return list_empty(work_q);
 clear_q:
-	SAS_DPRINTK("--- Exit %s -- clear_q\n", __FUNCTION__);
+	SAS_DPRINTK("--- Exit %s -- clear_q\n", __func__);
 	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
 		sas_eh_finish_cmd(cmd);
 
@@ -652,7 +652,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	SAS_DPRINTK("Enter %s\n", __FUNCTION__);
+	SAS_DPRINTK("Enter %s\n", __func__);
 	/*
 	 * Deal with commands that still have SAS tasks (i.e. they didn't
 	 * complete via the normal sas_task completion mechanism)
@@ -671,7 +671,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 
 out:
 	scsi_eh_flush_done_q(&ha->eh_done_q);
-	SAS_DPRINTK("--- Exit %s\n", __FUNCTION__);
+	SAS_DPRINTK("--- Exit %s\n", __func__);
 	return;
 }
 
@@ -992,7 +992,7 @@ int __sas_task_abort(struct sas_task *task)
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED ||
 	    task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		SAS_DPRINTK("%s: Task %p already finished.\n", __FUNCTION__,
+		SAS_DPRINTK("%s: Task %p already finished.\n", __func__,
 			    task);
 		return 0;
 	}
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 6d6a76e..15e2d13 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -39,7 +39,7 @@ enum srp_task_attributes {
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2284375..0537cc3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2106,7 +2106,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 		if (iocbq_entry == NULL) {
 			printk(KERN_ERR "%s: only allocated %d iocbs of "
 				"expected %d count. Unloading driver.\n",
-				__FUNCTION__, i, LPFC_IOCB_LIST_CNT);
+				__func__, i, LPFC_IOCB_LIST_CNT);
 			error = -ENOMEM;
 			goto out_free_iocbq;
 		}
@@ -2116,7 +2116,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 			kfree (iocbq_entry);
 			printk(KERN_ERR "%s: failed to allocate IOTAG. "
 			       "Unloading driver.\n",
-				__FUNCTION__);
+				__func__);
 			error = -ENOMEM;
 			goto out_free_iocbq;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 70255c1..2b34910 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -342,7 +342,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
 			printk(KERN_ERR "%s: Too many sg segments from "
 			       "dma_map_sg.  Config %d, seg_cnt %d",
-			       __FUNCTION__, phba->cfg_sg_seg_cnt,
+			       __func__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
 			scsi_dma_unmap(scsi_cmnd);
 			return 1;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fc0d950..44ecd67 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -219,7 +219,7 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd)
 	case CMD_IOCB_LOGENTRY_CN:
 	case CMD_IOCB_LOGENTRY_ASYNC_CN:
 		printk("%s - Unhandled SLI-3 Command x%x\n",
-				__FUNCTION__, iocb_cmnd);
+				__func__, iocb_cmnd);
 		type = LPFC_UNKNOWN_IOCB;
 		break;
 	default:
@@ -1719,7 +1719,7 @@ lpfc_sli_handle_slow_ring_event(struct lpfc_hba *phba,
 		rspiocbp = __lpfc_sli_get_iocbq(phba);
 		if (rspiocbp == NULL) {
 			printk(KERN_ERR "%s: out of buffers! Failing "
-			       "completion.\n", __FUNCTION__);
+			       "completion.\n", __func__);
 			break;
 		}
 
@@ -3770,7 +3770,7 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 		break;
 	default:
 		printk(KERN_ERR "%s: Unknown context cmd type, value %d\n",
-			__FUNCTION__, ctx_cmd);
+			__func__, ctx_cmd);
 		break;
 	}
 
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index fef9ac9..2374459 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -266,7 +266,7 @@ typedef struct {
 #define ASSERT(expression)						\
 	if (!(expression)) {						\
 	ASSERT_ACTION("assertion failed:(%s), file: %s, line: %d:%s\n",	\
-			#expression, __FILE__, __LINE__, __FUNCTION__);	\
+			#expression, __FILE__, __LINE__, __func__);	\
 	}
 #else
 #define ASSERT(expression)
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 9f04192..78783f5 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -458,7 +458,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (adapter == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-		"megaraid: out of memory, %s %d.\n", __FUNCTION__, __LINE__));
+		"megaraid: out of memory, %s %d.\n", __func__, __LINE__));
 
 		goto out_probe_one;
 	}
@@ -1002,7 +1002,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 
 	if (!raid_dev->una_mbox64) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		return -1;
 	}
@@ -1030,7 +1030,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 	if (!adapter->ibuf) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		goto out_free_common_mbox;
@@ -1052,7 +1052,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 
 	if (adapter->kscb_list == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		goto out_free_ibuf;
 	}
@@ -1060,7 +1060,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 	// memory allocation for our command packets
 	if (megaraid_mbox_setup_dma_pools(adapter) != 0) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		goto out_free_scb_list;
 	}
@@ -2981,7 +2981,7 @@ megaraid_mbox_product_info(adapter_t *adapter)
 
 	if (pinfo == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		return -1;
@@ -3491,7 +3491,7 @@ megaraid_cmm_register(adapter_t *adapter)
 
 	if (adapter->uscb_list == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		return -1;
 	}
@@ -3862,7 +3862,7 @@ megaraid_sysfs_alloc_resources(adapter_t *adapter)
 		!raid_dev->sysfs_buffer) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		rval = -ENOMEM;
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 0ad215e..d0f3cb5 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -927,7 +927,7 @@ mraid_mm_register_adp(mraid_mmadp_t *lld_adp)
 			!adapter->pthru_dma_pool) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid cmm: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid cmm: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		rval = (-ENOMEM);
@@ -955,7 +955,7 @@ mraid_mm_register_adp(mraid_mmadp_t *lld_adp)
 
 			con_log(CL_ANN, (KERN_WARNING
 				"megaraid cmm: out of memory, %s %d\n",
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 
 			rval = (-ENOMEM);
 
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 7fed353..edf9fdb 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -299,9 +299,9 @@ static struct scsi_host_template nsp32_template = {
 #else
 # define NSP32_DEBUG_MASK	      0xffffff
 # define nsp32_msg(type, args...) \
-	nsp32_message (__FUNCTION__, __LINE__, (type), args)
+	nsp32_message (__func__, __LINE__, (type), args)
 # define nsp32_dbg(mask, args...) \
-	nsp32_dmessage(__FUNCTION__, __LINE__, (mask), args)
+	nsp32_dmessage(__func__, __LINE__, (mask), args)
 #endif
 
 #define NSP32_DEBUG_QUEUECOMMAND	BIT(0)
diff --git a/drivers/scsi/nsp32_debug.c b/drivers/scsi/nsp32_debug.c
index ef3c59c..2fb3fb5 100644
--- a/drivers/scsi/nsp32_debug.c
+++ b/drivers/scsi/nsp32_debug.c
@@ -88,7 +88,7 @@ static void print_commandk (unsigned char *command)
 	int i,s;
 //	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
-	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
+	/*printk(KERN_DEBUG "%s ", __func__);*/
 	if ((command[0] >> 5) == 6 ||
 	    (command[0] >> 5) == 7 ) {
 		s = 12; /* vender specific */
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 5082ca3..a221b6e 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -107,9 +107,9 @@ static nsp_hw_data nsp_data_base; /* attach <-> detect glue */
 #else
 # define NSP_DEBUG_MASK		0xffffff
 # define nsp_msg(type, args...) \
-	nsp_cs_message (__FUNCTION__, __LINE__, (type), args)
+	nsp_cs_message (__func__, __LINE__, (type), args)
 # define nsp_dbg(mask, args...) \
-	nsp_cs_dmessage(__FUNCTION__, __LINE__, (mask), args)
+	nsp_cs_dmessage(__func__, __LINE__, (mask), args)
 #endif
 
 #define NSP_DEBUG_QUEUECOMMAND		BIT(0)
diff --git a/drivers/scsi/pcmcia/nsp_debug.c b/drivers/scsi/pcmcia/nsp_debug.c
index 2f75fe6..3c6ef64 100644
--- a/drivers/scsi/pcmcia/nsp_debug.c
+++ b/drivers/scsi/pcmcia/nsp_debug.c
@@ -90,7 +90,7 @@ static void print_commandk (unsigned char *command)
 	int i, s;
 	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
-	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
+	/*printk(KERN_DEBUG "%s ", __func__);*/
 	if ((command[0] >> 5) == 6 ||
 	    (command[0] >> 5) == 7 ) {
 		s = 12; /* vender specific */
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index f655ae3..8aa0bd9 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -171,7 +171,7 @@ static int device_check(ppa_struct *dev);
 
 #if PPA_DEBUG > 0
 #define ppa_fail(x,y) printk("ppa: ppa_fail(%i) from %s at line %d\n",\
-	   y, __FUNCTION__, __LINE__); ppa_fail_func(x,y);
+	   y, __func__, __LINE__); ppa_fail_func(x,y);
 static inline void ppa_fail_func(ppa_struct *dev, int error_code)
 #else
 static inline void ppa_fail(ppa_struct *dev, int error_code)
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 68c0d09..c698f9d 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1700,7 +1700,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 	risc_code_size = *ql1280_board_tbl[ha->devnum].fwlen;
 
 	dprintk(1, "%s: DMA RISC code (%i) words\n",
-			__FUNCTION__, risc_code_size);
+			__func__, risc_code_size);
 
 	num = 0;
 	while (risc_code_size > 0) {
@@ -1726,7 +1726,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 		mb[7] = pci_dma_hi32(ha->request_dma) & 0xffff;
 		mb[6] = pci_dma_hi32(ha->request_dma) >> 16;
 		dprintk(2, "%s: op=%d  0x%p = 0x%4x,0x%4x,0x%4x,0x%4x\n",
-				__FUNCTION__, mb[0],
+				__func__, mb[0],
 				(void *)(long)ha->request_dma,
 				mb[6], mb[7], mb[2], mb[3]);
 		err = qla1280_mailbox_command(ha, BIT_4 | BIT_3 | BIT_2 |
@@ -1758,10 +1758,10 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 			if (tbuf[i] != sp[i] && warn++ < 10) {
 				printk(KERN_ERR "%s: FW compare error @ "
 						"byte(0x%x) loop#=%x\n",
-						__FUNCTION__, i, num);
+						__func__, i, num);
 				printk(KERN_ERR "%s: FWbyte=%x  "
 						"FWfromChip=%x\n",
-						__FUNCTION__, sp[i], tbuf[i]);
+						__func__, sp[i], tbuf[i]);
 				/*break; */
 			}
 		}
@@ -1786,7 +1786,7 @@ qla1280_start_firmware(struct scsi_qla_host *ha)
 	int err;
 
 	dprintk(1, "%s: Verifying checksum of loaded RISC code.\n",
-			__FUNCTION__);
+			__func__);
 
 	/* Verify checksum of loaded RISC code. */
 	mb[0] = MBC_VERIFY_CHECKSUM;
@@ -1799,7 +1799,7 @@ qla1280_start_firmware(struct scsi_qla_host *ha)
 	}
 
 	/* Start firmware execution. */
-	dprintk(1, "%s: start firmware running.\n", __FUNCTION__);
+	dprintk(1, "%s: start firmware running.\n", __func__);
 	mb[0] = MBC_EXECUTE_FIRMWARE;
 	mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
 	err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d1777a9..d9706ff 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2117,7 +2117,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 		open_devip = kzalloc(sizeof(*open_devip),GFP_ATOMIC);
 		if (NULL == open_devip) {
 			printk(KERN_ERR "%s: out of memory at line %d\n",
-				__FUNCTION__, __LINE__);
+				__func__, __LINE__);
 			return NULL;
 		}
 		open_devip->sdbg_host = sdbg_host;
@@ -3015,7 +3015,7 @@ static int sdebug_add_adapter(void)
         sdbg_host = kzalloc(sizeof(*sdbg_host),GFP_KERNEL);
         if (NULL == sdbg_host) {
                 printk(KERN_ERR "%s: out of memory at line %d\n",
-                       __FUNCTION__, __LINE__);
+                       __func__, __LINE__);
                 return -ENOMEM;
         }
 
@@ -3026,7 +3026,7 @@ static int sdebug_add_adapter(void)
                 sdbg_devinfo = kzalloc(sizeof(*sdbg_devinfo),GFP_KERNEL);
                 if (NULL == sdbg_devinfo) {
                         printk(KERN_ERR "%s: out of memory at line %d\n",
-                               __FUNCTION__, __LINE__);
+                               __func__, __LINE__);
                         error = -ENOMEM;
 			goto clean;
                 }
@@ -3093,7 +3093,7 @@ static int sdebug_driver_probe(struct device * dev)
 
         hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
         if (NULL == hpnt) {
-                printk(KERN_ERR "%s: scsi_register failed\n", __FUNCTION__);
+                printk(KERN_ERR "%s: scsi_register failed\n", __func__);
                 error = -ENODEV;
 		return error;
         }
@@ -3108,7 +3108,7 @@ static int sdebug_driver_probe(struct device * dev)
 
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
-                printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
+                printk(KERN_ERR "%s: scsi_add_host failed\n", __func__);
                 error = -ENODEV;
 		scsi_host_put(hpnt);
         } else
@@ -3128,7 +3128,7 @@ static int sdebug_driver_remove(struct device * dev)
 
 	if (!sdbg_host) {
 		printk(KERN_ERR "%s: Unable to locate host info\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENODEV;
 	}
 
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index b8de041..68e6116 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -272,7 +272,7 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 	}
 	if (from_length > to_length)
 		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
-			__FUNCTION__, name, from);
+			__func__, name, from);
 }
 
 /**
@@ -298,7 +298,7 @@ static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
 
 	devinfo = kmalloc(sizeof(*devinfo), GFP_KERNEL);
 	if (!devinfo) {
-		printk(KERN_ERR "%s: no memory\n", __FUNCTION__);
+		printk(KERN_ERR "%s: no memory\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -363,7 +363,7 @@ static int scsi_dev_info_list_add_str(char *dev_list)
 			strflags = strsep(&next, next_check);
 		if (!model || !strflags) {
 			printk(KERN_ERR "%s: bad dev info string '%s' '%s'"
-			       " '%s'\n", __FUNCTION__, vendor, model,
+			       " '%s'\n", __func__, vendor, model,
 			       strflags);
 			res = -EINVAL;
 		} else
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 045a086..52ce43c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -139,7 +139,7 @@ void scsi_add_timer(struct scsi_cmnd *scmd, int timeout,
 	scmd->eh_timeout.function = (void (*)(unsigned long)) complete;
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p, time:"
-					  " %d, (%p)\n", __FUNCTION__,
+					  " %d, (%p)\n", __func__,
 					  scmd, timeout, complete));
 
 	add_timer(&scmd->eh_timeout);
@@ -163,7 +163,7 @@ int scsi_delete_timer(struct scsi_cmnd *scmd)
 	rtn = del_timer(&scmd->eh_timeout);
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p,"
-					 " rtn: %d\n", __FUNCTION__,
+					 " rtn: %d\n", __func__,
 					 scmd, rtn));
 
 	scmd->eh_timeout.data = (unsigned long)NULL;
@@ -233,7 +233,7 @@ int scsi_block_when_processing_errors(struct scsi_device *sdev)
 
 	online = scsi_device_online(sdev);
 
-	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __FUNCTION__,
+	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __func__,
 					  online));
 
 	return online;
@@ -271,7 +271,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 			SCSI_LOG_ERROR_RECOVERY(3,
 				sdev_printk(KERN_INFO, sdev,
 					    "%s: cmds failed: %d, cancel: %d\n",
-					    __FUNCTION__, cmd_failed,
+					    __func__, cmd_failed,
 					    cmd_cancel));
 			cmd_cancel = 0;
 			cmd_failed = 0;
@@ -459,7 +459,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s scmd: %p result: %x\n",
-			__FUNCTION__, scmd, scmd->result));
+			__func__, scmd, scmd->result));
 
 	eh_action = scmd->device->host->eh_action;
 	if (eh_action)
@@ -476,7 +476,7 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 	int rtn;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
-					  __FUNCTION__));
+					  __func__));
 
 	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
@@ -505,7 +505,7 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	int rtn;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
-					  __FUNCTION__));
+					  __func__));
 
 	if (!scmd->device->host->hostt->eh_bus_reset_handler)
 		return FAILED;
@@ -721,7 +721,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: scmd: %p, timeleft: %ld\n",
-			__FUNCTION__, scmd, timeleft));
+			__func__, scmd, timeleft));
 
 	/*
 	 * If there is time left scsi_eh_done got called, and we will
@@ -733,7 +733,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		rtn = scsi_eh_completed_normally(scmd);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			printk("%s: scsi_eh_completed_normally %x\n",
-			       __FUNCTION__, rtn));
+			       __func__, rtn));
 
 		switch (rtn) {
 		case SUCCESS:
@@ -868,7 +868,7 @@ retry_tur:
 	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6, SENSE_TIMEOUT, 0);
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
-		__FUNCTION__, scmd, rtn));
+		__func__, scmd, rtn));
 
 	switch (rtn) {
 	case NEEDS_RETRY:
@@ -1201,7 +1201,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	if (!scsi_device_online(scmd->device)) {
 		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline - report"
 						  " as SUCCESS\n",
-						  __FUNCTION__));
+						  __func__));
 		return SUCCESS;
 	}
 
@@ -1416,7 +1416,7 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * ioctls to queued block devices.
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
-					  __FUNCTION__));
+					  __func__));
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RUNNING))
@@ -1736,7 +1736,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: waking up host to restart after TMF\n",
-		__FUNCTION__));
+		__func__));
 
 	wake_up(&shost->host_wait);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..58edf63 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1348,7 +1348,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 
 	if (unlikely(cmd == NULL)) {
 		printk(KERN_CRIT "impossible request in %s.\n",
-				 __FUNCTION__);
+				 __func__);
 		BUG();
 	}
 
@@ -1472,7 +1472,7 @@ static void scsi_request_fn(struct request_queue *q)
 			printk(KERN_CRIT "impossible request in %s.\n"
 					 "please mail a stack trace to "
 					 "linux-scsi@vger.kernel.org\n",
-					 __FUNCTION__);
+					 __func__);
 			blk_dump_rq_flags(req, "foo");
 			BUG();
 		}
@@ -2461,7 +2461,7 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	if (unlikely(i == sg_count)) {
 		printk(KERN_ERR "%s: Bytes in sg: %zu, requested offset %zu, "
 			"elements %d\n",
-		       __FUNCTION__, sg_len, *offset, sg_count);
+		       __func__, sg_len, *offset, sg_count);
 		WARN_ON(1);
 		return NULL;
 	}
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index 370c78c..ae7ed9a 100644
--- a/drivers/scsi/scsi_netlink.c
+++ b/drivers/scsi/scsi_netlink.c
@@ -55,7 +55,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
 		if ((nlh->nlmsg_len < (sizeof(*nlh) + sizeof(*hdr))) ||
 		    (skb->len < nlh->nlmsg_len)) {
 			printk(KERN_WARNING "%s: discarding partial skb\n",
-				 __FUNCTION__);
+				 __func__);
 			return;
 		}
 
@@ -82,7 +82,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
 
 		if (nlh->nlmsg_len < (sizeof(*nlh) + hdr->msglen)) {
 			printk(KERN_WARNING "%s: discarding partial message\n",
-				 __FUNCTION__);
+				 __func__);
 			return;
 		}
 
@@ -139,7 +139,7 @@ scsi_netlink_init(void)
 	error = netlink_register_notifier(&scsi_netlink_notifier);
 	if (error) {
 		printk(KERN_ERR "%s: register of event handler failed - %d\n",
-				__FUNCTION__, error);
+				__func__, error);
 		return;
 	}
 
@@ -148,7 +148,7 @@ scsi_netlink_init(void)
 				THIS_MODULE);
 	if (!scsi_nl_sock) {
 		printk(KERN_ERR "%s: register of recieve handler failed\n",
-				__FUNCTION__);
+				__func__);
 		netlink_unregister_notifier(&scsi_netlink_notifier);
 	}
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index ed39515..db8163b 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -114,7 +114,7 @@ void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
         	if (!sht->proc_dir)
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
-			       __FUNCTION__, sht->proc_name);
+			       __func__, sht->proc_name);
 		else
 			sht->proc_dir->owner = sht->module;
 	}
@@ -157,7 +157,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 			sht->proc_dir, proc_scsi_read, shost);
 	if (!p) {
 		printk(KERN_ERR "%s: Failed to register host %d in"
-		       "%s\n", __FUNCTION__, shost->host_no,
+		       "%s\n", __func__, shost->host_no,
 		       sht->proc_name);
 		return;
 	} 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e67c14e..9e5549c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -318,7 +318,7 @@ out_device_destroy:
 	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+		printk(ALLOC_FAILURE_MSG, __func__);
 	return NULL;
 }
 
@@ -384,7 +384,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
 	}
 	dev = &starget->dev;
@@ -1331,7 +1331,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	lun_data = kmalloc(length, GFP_ATOMIC |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
 	}
 
@@ -1645,7 +1645,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 {
 	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
 		"%s: <%u:%u:%u>\n",
-		__FUNCTION__, channel, id, lun));
+		__func__, channel, id, lun));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
@@ -1699,7 +1699,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		return NULL;
 
 	if (shost->async_scan) {
-		printk("%s called twice for host %d", __FUNCTION__,
+		printk("%s called twice for host %d", __func__,
 				shost->host_no);
 		dump_stack();
 		return NULL;
@@ -1753,7 +1753,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	mutex_lock(&shost->scan_mutex);
 
 	if (!shost->async_scan) {
-		printk("%s called twice for host %d", __FUNCTION__,
+		printk("%s called twice for host %d", __func__,
 				shost->host_no);
 		dump_stack();
 		return;
diff --git a/drivers/scsi/scsi_tgt_priv.h b/drivers/scsi/scsi_tgt_priv.h
index cb92888..fe4c621 100644
--- a/drivers/scsi/scsi_tgt_priv.h
+++ b/drivers/scsi/scsi_tgt_priv.h
@@ -6,7 +6,7 @@ struct task_struct;
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 
 #define dprintk(fmt, args...)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index b1119da..f07bd0f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -570,7 +570,7 @@ send_fail:
 	name = get_fc_host_event_code_name(event_code);
 	printk(KERN_WARNING
 		"%s: Dropped Event : host %d %s data 0x%08x - err %d\n",
-		__FUNCTION__, shost->host_no,
+		__func__, shost->host_no,
 		(name) ? name : "<unknown>", event_data, err);
 	return;
 }
@@ -643,7 +643,7 @@ send_vendor_fail_skb:
 send_vendor_fail:
 	printk(KERN_WARNING
 		"%s: Dropped Event : host %d vendor_unique - err %d\n",
-		__FUNCTION__, shost->host_no, err);
+		__func__, shost->host_no, err);
 	return;
 }
 EXPORT_SYMBOL(fc_host_post_vendor_event);
@@ -2386,7 +2386,7 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 	size = (sizeof(struct fc_rport) + fci->f->dd_fcrport_size);
 	rport = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!rport)) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
 	}
 
@@ -3059,7 +3059,7 @@ fc_vport_create(struct Scsi_Host *shost, int channel, struct device *pdev,
 	size = (sizeof(struct fc_vport) + fci->f->dd_fcvport_size);
 	vport = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!vport)) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -3123,7 +3123,7 @@ fc_vport_create(struct Scsi_Host *shost, int channel, struct device *pdev,
 			printk(KERN_ERR
 				"%s: Cannot create vport symlinks for "
 				"%s, err=%d\n",
-				__FUNCTION__, dev->bus_id, error);
+				__func__, dev->bus_id, error);
 	}
 	spin_lock_irqsave(shost->host_lock, flags);
 	vport->flags &= ~FC_VPORT_CREATING;
@@ -3236,7 +3236,7 @@ fc_vport_sched_delete(struct work_struct *work)
 	if (stat)
 		dev_printk(KERN_ERR, vport->dev.parent,
 			"%s: %s could not be deleted created via "
-			"shost%d channel %d - error %d\n", __FUNCTION__,
+			"shost%d channel %d - error %d\n", __func__,
 			vport->dev.bus_id, vport->shost->host_no,
 			vport->channel, stat);
 }
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 43a964d..b089624 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -756,7 +756,7 @@ static void sas_port_create_link(struct sas_port *port,
 	return;
 err:
 	printk(KERN_ERR "%s: Cannot create port links, err=%d\n",
-	       __FUNCTION__, res);
+	       __func__, res);
 }
 
 static void sas_port_delete_link(struct sas_port *port,
@@ -1006,7 +1006,7 @@ void sas_port_mark_backlink(struct sas_port *port)
 	return;
 err:
 	printk(KERN_ERR "%s: Cannot create port backlink, err=%d\n",
-	       __FUNCTION__, res);
+	       __func__, res);
 
 }
 EXPORT_SYMBOL(sas_port_mark_backlink);
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5b04ddf..1723d71 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -452,7 +452,7 @@ static int dc390_pci_map (struct dc390_srb* pSRB)
 		/* TODO: error handling */
 		if (pSRB->SGcount != 1)
 			error = 1;
-		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__, pcmd->sense_buffer, cmdp->saved_dma_handle));
+		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __func__, pcmd->sense_buffer, cmdp->saved_dma_handle));
 	/* Map SG list */
 	} else if (scsi_sg_count(pcmd)) {
 		int nseg;
@@ -466,7 +466,7 @@ static int dc390_pci_map (struct dc390_srb* pSRB)
 		if (nseg < 0)
 			error = 1;
 		DEBUG1(printk("%s(): Mapped SG %p with %d (%d) elements\n",\
-			      __FUNCTION__, scsi_sglist(pcmd), nseg, scsi_sg_count(pcmd)));
+			      __func__, scsi_sglist(pcmd), nseg, scsi_sg_count(pcmd)));
 	/* Map single segment */
 	} else
 		pSRB->SGcount = 0;
@@ -483,11 +483,11 @@ static void dc390_pci_unmap (struct dc390_srb* pSRB)
 
 	if (pSRB->SRBFlag) {
 		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, DMA_FROM_DEVICE);
-		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
+		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __func__, cmdp->saved_dma_handle));
 	} else {
 		scsi_dma_unmap(pcmd);
 		DEBUG1(printk("%s(): Unmapped SG at %p with %d elements\n",
-			      __FUNCTION__, scsi_sglist(pcmd), scsi_sg_count(pcmd)));
+			      __func__, scsi_sglist(pcmd), scsi_sg_count(pcmd)));
 	}
 }
 
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index c975c01..d4c1356 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -148,7 +148,7 @@
  *
  * 2002/10/04 - Alan Cox <alan@redhat.com>
  *
- * Use dev_id for interrupts, kill __FUNCTION__ pasting
+ * Use dev_id for interrupts, kill __func__ pasting
  * Add a lock for the scb pool, clean up all other cli/sti usage stuff
  * Use the adapter lock for the other places we had the cli's
  *
@@ -640,12 +640,12 @@ static int __init wd7000_setup(char *str)
 	(void) get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (wd7000_card_num >= NUM_CONFIGS) {
-		printk(KERN_ERR "%s: Too many \"wd7000=\" configurations in " "command line!\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Too many \"wd7000=\" configurations in " "command line!\n", __func__);
 		return 0;
 	}
 
 	if ((ints[0] < 3) || (ints[0] > 5)) {
-		printk(KERN_ERR "%s: Error in command line!  " "Usage: wd7000=<IRQ>,<DMA>,IO>[,<BUS_ON>" "[,<BUS_OFF>]]\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Error in command line!  " "Usage: wd7000=<IRQ>,<DMA>,IO>[,<BUS_ON>" "[,<BUS_OFF>]]\n", __func__);
 	} else {
 		for (i = 0; i < NUM_IRQS; i++)
 			if (ints[1] == wd7000_irq[i])
@@ -1642,7 +1642,7 @@ static int wd7000_biosparam(struct scsi_device *sdev,
 			ip[2] = info[2];
 
 			if (info[0] == 255)
-				printk(KERN_INFO "%s: current partition table is " "using extended translation.\n", __FUNCTION__);
+				printk(KERN_INFO "%s: current partition table is " "using extended translation.\n", __func__);
 		}
 	}
 
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 4b5f908..3c4a300 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -68,11 +68,11 @@ lasi_scsi_clock(void * hpa, int defaultclock)
 	if (status == PDC_RET_OK) {
 		clock = (int) pdc_result[16];
 	} else {
-		printk(KERN_WARNING "%s: pdc_iodc_read returned %d\n", __FUNCTION__, status);
+		printk(KERN_WARNING "%s: pdc_iodc_read returned %d\n", __func__, status);
 		clock = defaultclock; 
 	}
 
-	printk(KERN_DEBUG "%s: SCSI clock %d\n", __FUNCTION__, clock);
+	printk(KERN_DEBUG "%s: SCSI clock %d\n", __func__, clock);
  	return clock;
 }
 #endif
@@ -108,13 +108,13 @@ zalon_probe(struct parisc_device *dev)
 	*/
 	dev->irq = gsc_alloc_irq(&gsc_irq);
 
-	printk(KERN_INFO "%s: Zalon version %d, IRQ %d\n", __FUNCTION__,
+	printk(KERN_INFO "%s: Zalon version %d, IRQ %d\n", __func__,
 		zalon_vers, dev->irq);
 
 	__raw_writel(gsc_irq.txn_addr | gsc_irq.txn_data, zalon + IO_MODULE_EIM);
 
 	if (zalon_vers == 0)
-		printk(KERN_WARNING "%s: Zalon 1.1 or earlier\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: Zalon 1.1 or earlier\n", __func__);
 
 	memset(&device, 0, sizeof(struct ncr_device));
 
-- 
1.5.4.3.500.g83a2c


