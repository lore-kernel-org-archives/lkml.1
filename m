Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0BCDpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:45:40 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45758 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0BCDpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:45:34 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 01/11] tree-wide: fix spelling of 'success'
Date: Wed,  3 Feb 2010 00:48:17 +0800
Message-Id: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 drivers/block/drbd/drbd_req.h   |    2 +-
 drivers/net/e1000e/82571.c      |    2 +-
 drivers/net/e1000e/lib.c        |    2 +-
 drivers/net/qlge/qlge_ethtool.c |    2 +-
 drivers/net/qlge/qlge_main.c    |    2 +-
 drivers/s390/char/raw3270.c     |    2 +-
 drivers/s390/char/sclp.c        |    2 +-
 drivers/scsi/lpfc/lpfc_els.c    |    2 +-
 drivers/spi/spi_s3c24xx.c       |    2 +-
 net/ipv4/tcp_timer.c            |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index f22c1bc..16119d7 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -57,7 +57,7 @@
  *
  *  It may me handed over to the local disk subsystem.
  *  It may be completed by the local disk subsystem,
- *    either sucessfully or with io-error.
+ *    either successfully or with io-error.
  *  In case it is a READ request, and it failed locally,
  *    it may be retried remotely.
  *
diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index 02d67d0..dc4eb87 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1363,7 +1363,7 @@ static s32 e1000_setup_fiber_serdes_link_82571(struct e1000_hw *hw)
  *
  *  1) down
  *  2) autoneg_progress
- *  3) autoneg_complete (the link sucessfully autonegotiated)
+ *  3) autoneg_complete (the link successfully autonegotiated)
  *  4) forced_up (the link has been forced up, it did not autonegotiate)
  *
  **/
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index 2fa9b36..3af0b1b 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -587,7 +587,7 @@ s32 e1000e_check_for_serdes_link(struct e1000_hw *hw)
 				if (!(rxcw & E1000_RXCW_IV)) {
 					mac->serdes_has_link = true;
 					e_dbg("SERDES: Link up - autoneg "
-					   "completed sucessfully.\n");
+					   "completed successfully.\n");
 				} else {
 					mac->serdes_has_link = false;
 					e_dbg("SERDES: Link down - invalid"
diff --git a/drivers/net/qlge/qlge_ethtool.c b/drivers/net/qlge/qlge_ethtool.c
index 058fa0a..b8d21ab 100644
--- a/drivers/net/qlge/qlge_ethtool.c
+++ b/drivers/net/qlge/qlge_ethtool.c
@@ -402,7 +402,7 @@ static int ql_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 		u32 wol = 0;
 		status = ql_mb_wol_mode(qdev, wol);
 		QPRINTK(qdev, DRV, ERR, "WOL %s (wol code 0x%x) on %s\n",
-			(status == 0) ? "cleared sucessfully" : "clear failed",
+			(status == 0) ? "cleared successfully" : "clear failed",
 			wol, qdev->ndev->name);
 	}
 
diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 894a7c8..a35845b 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -3517,7 +3517,7 @@ int ql_wol(struct ql_adapter *qdev)
 		wol |= MB_WOL_MODE_ON;
 		status = ql_mb_wol_mode(qdev, wol);
 		QPRINTK(qdev, DRV, ERR, "WOL %s (wol code 0x%x) on %s\n",
-			(status == 0) ? "Sucessfully set" : "Failed", wol,
+			(status == 0) ? "Successfully set" : "Failed", wol,
 			qdev->ndev->name);
 	}
 
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 62ddf52..2a4c566 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -373,7 +373,7 @@ raw3270_irq (struct ccw_device *cdev, unsigned long intparm, struct irb *irb)
 		rq->rc = ccw_device_start(rp->cdev, &rq->ccw,
 					  (unsigned long) rq, 0, 0);
 		if (rq->rc == 0)
-			return;	/* Sucessfully restarted. */
+			return;	/* Successfully restarted. */
 		break;
 	case RAW3270_IO_STOP:
 		if (!rq)
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index ec88c59..f6d72e1 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -196,7 +196,7 @@ __sclp_start_request(struct sclp_req *req)
 	req->start_count++;
 
 	if (rc == 0) {
-		/* Sucessfully started request */
+		/* Successfully started request */
 		req->status = SCLP_REQ_RUNNING;
 		sclp_running_state = sclp_running_state_running;
 		__sclp_set_request_timer(SCLP_RETRY_INTERVAL * HZ,
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2cc3968..930d2ac 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -969,7 +969,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
  * function returns, it does not guarantee all the IOCBs are actually aborted.
  *
  * Return code
- *   0 - Sucessfully issued abort iocb on all outstanding flogis (Always 0)
+ *   0 - Successfully issued abort iocb on all outstanding flogis (Always 0)
  **/
 int
 lpfc_els_abort_flogi(struct lpfc_hba *phba)
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index c010733..1fabede 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -275,7 +275,7 @@ static inline u32 ack_bit(unsigned int irq)
  * Claim the FIQ handler (only one can be active at any one time) and
  * then setup the correct transfer code for this transfer.
  *
- * This call updates all the necessary state information if sucessful,
+ * This call updates all the necessary state information if successful,
  * so the caller does not need to do anything more than start the transfer
  * as normal, since the IRQ will have been re-routed to the FIQ handler.
 */
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 8816a20..aff48d6 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -133,7 +133,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 }
 
 /* This function calculates a "timeout" which is equivalent to the timeout of a
- * TCP connection after "boundary" unsucessful, exponentially backed-off
+ * TCP connection after "boundary" unsuccessful, exponentially backed-off
  * retransmissions with an initial RTO of TCP_RTO_MIN.
  */
 static bool retransmits_timed_out(struct sock *sk,
-- 
1.6.3.3

