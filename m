Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbXKTB4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbXKTB4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbXKTBti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:38 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2082 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326AbXKTBtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:09 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <mshefty@ichips.intel.com>, general@lists.openfabrics.org
Subject: [PATCH 19/59] drivers/infiniband: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:11 -0800
Message-Id: <1195523331-15303-20-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-19-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
Message-Id: <de3db785bf1d8f7f5ae308ca366794cc3e5def83.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/ehca/ehca_cq.c         |    2 +-
 drivers/infiniband/hw/ehca/ehca_qp.c         |    6 +++---
 drivers/infiniband/ulp/iser/iser_initiator.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 79c25f5..0467c15 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -246,7 +246,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 		} else {
 			if (h_ret != H_PAGE_REGISTERED) {
 				ehca_err(device, "Registration of page failed "
-					 "ehca_cq=%p cq_num=%x h_ret=%li"
+					 "ehca_cq=%p cq_num=%x h_ret=%li "
 					 "counter=%i act_pages=%i",
 					 my_cq, my_cq->cq_number,
 					 h_ret, counter, param.act_pages);
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 2e3e654..091985b 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -858,7 +858,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 				update_mask,
 				mqpcb, my_qp->galpas.kernel);
 	if (hret != H_SUCCESS) {
-		ehca_err(pd->device, "Could not modify SRQ to INIT"
+		ehca_err(pd->device, "Could not modify SRQ to INIT "
 			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, my_qp->real_qp_num, hret);
 		goto create_srq2;
@@ -872,7 +872,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 				update_mask,
 				mqpcb, my_qp->galpas.kernel);
 	if (hret != H_SUCCESS) {
-		ehca_err(pd->device, "Could not enable SRQ"
+		ehca_err(pd->device, "Could not enable SRQ "
 			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, my_qp->real_qp_num, hret);
 		goto create_srq2;
@@ -886,7 +886,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 				update_mask,
 				mqpcb, my_qp->galpas.kernel);
 	if (hret != H_SUCCESS) {
-		ehca_err(pd->device, "Could not modify SRQ to RTR"
+		ehca_err(pd->device, "Could not modify SRQ to RTR "
 			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, my_qp->real_qp_num, hret);
 		goto create_srq2;
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index a6f2303..ba1b455 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -561,7 +561,7 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 	if (opcode == ISCSI_OP_SCSI_CMD_RSP) {
 	        itt = get_itt(hdr->itt); /* mask out cid and age bits */
 		if (!(itt < session->cmds_max))
-			iser_err("itt can't be matched to task!!!"
+			iser_err("itt can't be matched to task!!! "
 				 "conn %p opcode %d cmds_max %d itt %d\n",
 				 conn->iscsi_conn,opcode,session->cmds_max,itt);
 		/* use the mapping given with the cmds array indexed by itt */
-- 
1.5.3.5.652.gf192c

