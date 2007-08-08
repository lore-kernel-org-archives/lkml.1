Return-Path: <linux-kernel-owner+w=401wt.eu-S938198AbXHHSlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938198AbXHHSlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbXHHSkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:40:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36795 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936889AbXHHSku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:40:50 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 3/7] IB/ehca: Add 1 is not longer needed because of firmware interface change
Date: Wed, 8 Aug 2007 20:40:47 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com,
       "\"Hoang-Nam Nguyen\" @dyn-9-152-249-53" 
	<Hoang-Nam.Nguyen@d01av01.pok.ibm.com>,
       fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082040.47926.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/hcp_if.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 24f4541..8534061 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -317,9 +317,9 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 
 	max_r10_reg =
 		EHCA_BMASK_SET(H_ALL_RES_QP_MAX_OUTST_SEND_WR,
-			       parms->squeue.max_wr + 1)
+			       parms->squeue.max_wr)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_OUTST_RECV_WR,
-				 parms->rqueue.max_wr + 1)
+				 parms->rqueue.max_wr)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_SEND_SGE,
 				 parms->squeue.max_sge)
 		| EHCA_BMASK_SET(H_ALL_RES_QP_MAX_RECV_SGE,
-- 
1.5.2


