Return-Path: <linux-kernel-owner+w=401wt.eu-S1762823AbXGSUq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823AbXGSUq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbXGSUqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:46:20 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:54283 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbXGSUqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:46:19 -0400
Message-ID: <469FCD3F.7000708@pimpmylinux.org>
Date: Thu, 19 Jul 2007 22:44:47 +0200
From: Gabriel C <crazy@pimpmylinux.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: trivial@kernel.org
Subject: [PATCH][RESEND] Typo fixes errror -> error
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Craciunescu <nix.or.die@googlemail.com>

Typo fixes errror -> error

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 drivers/infiniband/hw/ehca/ehca_irq.c |    2 +-
 drivers/net/skfp/pmf.c                |    2 +-
 drivers/net/via-velocity.c            |    2 +-
 drivers/s390/block/dasd_eckd.c        |    4 ++--
 security/selinux/ss/services.c        |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 96eba38..533d7c4 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -116,7 +116,7 @@ static void print_error_data(struct ehca_shca * shca, void* data,
 	}
 	default:
 		ehca_err(&shca->ib_device,
-			 "Unknown errror type: %lx on %s.",
+			 "Unknown error type: %lx on %s.",
 			 type, shca->ib_device.name);
 		break;
 	}
diff --git a/drivers/net/skfp/pmf.c b/drivers/net/skfp/pmf.c
index efc639c..ea85de9 100644
--- a/drivers/net/skfp/pmf.c
+++ b/drivers/net/skfp/pmf.c
@@ -575,7 +575,7 @@ void smt_add_para(struct s_smc *smc, struct s_pcon *pcon, u_short para,
 	int		sp_len ;
 
 	/*
-	 * skip if errror
+	 * skip if error
 	 */
 	if (pcon->pc_err)
 		return ;
diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index f331843..93574ad 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -1613,7 +1613,7 @@ static void velocity_error(struct velocity_info *vptr, int status)
 	if (status & ISR_TXSTLI) {
 		struct mac_regs __iomem * regs = vptr->mac_regs;
 
-		printk(KERN_ERR "TD structure errror TDindex=%hx\n", readw(&regs->TDIdx[0]));
+		printk(KERN_ERR "TD structure error TDindex=%hx\n", readw(&regs->TDIdx[0]));
 		BYTE_REG_BITS_ON(TXESR_TDSTR, &regs->TXESR);
 		writew(TRDCSR_RUN, &regs->TDCSRClr);
 		netif_stop_queue(vptr->dev);
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 418b4e6..ea63ba7 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -555,7 +555,7 @@ dasd_eckd_read_conf(struct dasd_device *device)
 			if (conf_data == NULL) {
 				MESSAGE(KERN_WARNING, "%s", "No configuration "
 					"data retrieved");
-				continue;	/* no errror */
+				continue;	/* no error */
 			}
 			if (conf_len != sizeof (struct dasd_eckd_confdata)) {
 				MESSAGE(KERN_WARNING,
@@ -564,7 +564,7 @@ dasd_eckd_read_conf(struct dasd_device *device)
 					conf_len,
 					sizeof (struct dasd_eckd_confdata));
 				kfree(conf_data);
-				continue;	/* no errror */
+				continue;	/* no error */
 			}
 			/* save first valid configuration data */
 			if (!conf_data_saved){
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index b5f017f..b2c5b34 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -792,7 +792,7 @@ int security_context_to_sid(char *scontext, u32 scontext_len, u32 *sid)
  * @scontext: security context
  * @scontext_len: length in bytes
  * @sid: security identifier, SID
- * @def_sid: default SID to assign on errror
+ * @def_sid: default SID to assign on error
  *
  * Obtains a SID associated with the security context that
  * has the string representation specified by @scontext.
