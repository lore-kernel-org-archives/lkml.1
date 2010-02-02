Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0BCDps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:45:48 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45771 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab0BCDpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:45:43 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 04/11] tree-wide: Fix spelling of 'acknowledge'
Date: Wed,  3 Feb 2010 00:48:20 +0800
Message-Id: <1265129307-18201-4-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-3-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
 <1265129307-18201-3-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 drivers/char/hvc_iseries.c    |    2 +-
 drivers/gpu/drm/via/via_irq.c |    4 ++--
 drivers/net/sfc/regs.h        |    2 +-
 drivers/net/smsc9420.c        |    2 +-
 drivers/scsi/libfc/fc_fcp.c   |    2 +-
 drivers/scsi/pcmcia/nsp_cs.h  |    2 +-
 include/linux/hil.h           |   16 ++++++++--------
 net/sctp/sm_sideeffect.c      |    2 +-
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hvc_iseries.c b/drivers/char/hvc_iseries.c
index 936d05b..0794925 100644
--- a/drivers/char/hvc_iseries.c
+++ b/drivers/char/hvc_iseries.c
@@ -353,7 +353,7 @@ static void hvc_close_event(struct HvLpEvent *event)
 
 	if (!hvlpevent_is_int(event)) {
 		printk(KERN_WARNING
-			"hvc: got unexpected close acknowlegement\n");
+			"hvc: got unexpected close acknowledgement\n");
 		return;
 	}
 
diff --git a/drivers/gpu/drm/via/via_irq.c b/drivers/gpu/drm/via/via_irq.c
index 5935b88..34079f2 100644
--- a/drivers/gpu/drm/via/via_irq.c
+++ b/drivers/gpu/drm/via/via_irq.c
@@ -150,7 +150,7 @@ irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS)
 		cur_irq++;
 	}
 
-	/* Acknowlege interrupts */
+	/* Acknowledge interrupts */
 	VIA_WRITE(VIA_REG_INTERRUPT, status);
 
 
@@ -165,7 +165,7 @@ static __inline__ void viadrv_acknowledge_irqs(drm_via_private_t * dev_priv)
 	u32 status;
 
 	if (dev_priv) {
-		/* Acknowlege interrupts */
+		/* Acknowledge interrupts */
 		status = VIA_READ(VIA_REG_INTERRUPT);
 		VIA_WRITE(VIA_REG_INTERRUPT, status |
 			  dev_priv->irq_pending_mask);
diff --git a/drivers/net/sfc/regs.h b/drivers/net/sfc/regs.h
index 89d606f..18a3be4 100644
--- a/drivers/net/sfc/regs.h
+++ b/drivers/net/sfc/regs.h
@@ -95,7 +95,7 @@
 #define	FRF_AA_INT_ACK_KER_FIELD_LBN 0
 #define	FRF_AA_INT_ACK_KER_FIELD_WIDTH 32
 
-/* INT_ISR0_REG: Function 0 Interrupt Acknowlege Status register */
+/* INT_ISR0_REG: Function 0 Interrupt Acknowledge Status register */
 #define	FR_BZ_INT_ISR0 0x00000090
 #define	FRF_BZ_INT_ISR_REG_LBN 0
 #define	FRF_BZ_INT_ISR_REG_WIDTH 64
diff --git a/drivers/net/smsc9420.c b/drivers/net/smsc9420.c
index 12f0f5d..2ae1972 100644
--- a/drivers/net/smsc9420.c
+++ b/drivers/net/smsc9420.c
@@ -1348,7 +1348,7 @@ static int smsc9420_open(struct net_device *dev)
 
 	netif_carrier_off(dev);
 
-	/* disable, mask and acknowlege all interrupts */
+	/* disable, mask and acknowledge all interrupts */
 	spin_lock_irqsave(&pd->int_lock, flags);
 	int_cfg = smsc9420_reg_read(pd, INT_CFG) & (~INT_CFG_IRQ_EN_);
 	smsc9420_reg_write(pd, INT_CFG, int_cfg);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 881d5df..69e3f34 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -48,7 +48,7 @@ struct kmem_cache *scsi_pkt_cachep;
 #define FC_SRB_CMD_SENT		(1 << 0)	/* cmd has been sent */
 #define FC_SRB_RCV_STATUS	(1 << 1)	/* response has arrived */
 #define FC_SRB_ABORT_PENDING	(1 << 2)	/* cmd abort sent to device */
-#define FC_SRB_ABORTED		(1 << 3)	/* abort acknowleged */
+#define FC_SRB_ABORTED		(1 << 3)	/* abort acknowledged */
 #define FC_SRB_DISCONTIG	(1 << 4)	/* non-sequential data recvd */
 #define FC_SRB_COMPL		(1 << 5)	/* fc_io_compl has been run */
 #define FC_SRB_FCP_PROCESSING_TMO (1 << 6)	/* timer function processing */
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 7db28cd..8c61a4f 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -187,7 +187,7 @@
 #define S_IO		BIT(1)    /* Input/Output line from SCSI bus */
 #define S_CD		BIT(2)    /* Command/Data line from SCSI bus */
 #define S_BUSY		BIT(3)    /* Busy line from SCSI bus         */
-#define S_ACK		BIT(4)    /* Acknowlege line from SCSI bus   */
+#define S_ACK		BIT(4)    /* Acknowledge line from SCSI bus  */
 #define S_REQUEST	BIT(5)    /* Request line from SCSI bus      */
 #define S_SELECT	BIT(6)	  /*                                 */
 #define S_ATN		BIT(7)	  /*                                 */
diff --git a/include/linux/hil.h b/include/linux/hil.h
index 13352d7..523785a 100644
--- a/include/linux/hil.h
+++ b/include/linux/hil.h
@@ -168,14 +168,14 @@ enum hil_command {
 	HIL_CMD_PR6	= 0x45,	/* Prompt6 */
 	HIL_CMD_PR7	= 0x46,	/* Prompt7 */
 	HIL_CMD_PRM	= 0x47,	/* Prompt (General Purpose) */
-	HIL_CMD_AK1	= 0x48,	/* Acknowlege1 */  
-	HIL_CMD_AK2	= 0x49,	/* Acknowlege2 */
-	HIL_CMD_AK3	= 0x4a,	/* Acknowlege3 */
-	HIL_CMD_AK4	= 0x4b,	/* Acknowlege4 */
-	HIL_CMD_AK5	= 0x4c,	/* Acknowlege5 */
-	HIL_CMD_AK6	= 0x4d,	/* Acknowlege6 */
-	HIL_CMD_AK7	= 0x4e,	/* Acknowlege7 */
-	HIL_CMD_ACK	= 0x4f,	/* Acknowlege (General Purpose) */
+	HIL_CMD_AK1	= 0x48,	/* Acknowledge1 */  
+	HIL_CMD_AK2	= 0x49,	/* Acknowledge2 */
+	HIL_CMD_AK3	= 0x4a,	/* Acknowledge3 */
+	HIL_CMD_AK4	= 0x4b,	/* Acknowledge4 */
+	HIL_CMD_AK5	= 0x4c,	/* Acknowledge5 */
+	HIL_CMD_AK6	= 0x4d,	/* Acknowledge6 */
+	HIL_CMD_AK7	= 0x4e,	/* Acknowledge7 */
+	HIL_CMD_ACK	= 0x4f,	/* Acknowledge (General Purpose) */
 
 	/* 0x50 to 0x78 reserved for future use  */
 	/* 0x80 to 0xEF device-specific commands */
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 4e4ca65..500886b 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -475,7 +475,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 	 * used to provide an upper bound to this doubling operation.
 	 *
 	 * Special Case:  the first HB doesn't trigger exponential backoff.
-	 * The first unacknowleged HB triggers it.  We do this with a flag
+	 * The first unacknowledged HB triggers it.  We do this with a flag
 	 * that indicates that we have an outstanding HB.
 	 */
 	if (!is_hb || transport->hb_sent) {
-- 
1.6.3.3

