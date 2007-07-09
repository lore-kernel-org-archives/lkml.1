Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbXGIN3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbXGIN3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbXGIN3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:29:20 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:65298 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbXGIN3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:29:19 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 07/13] IB/ehca: Report RDMA atomic attributes in query_qp()
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:28:18 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091528.19168.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index cbb8b5b..989f75e 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1491,6 +1491,9 @@ int ehca_query_qp(struct ib_qp *qp,
 	qp_attr->alt_port_num = qpcb->alt_phys_port;
 	qp_attr->alt_timeout = qpcb->timeout_al;
 
+	qp_attr->max_dest_rd_atomic = qpcb->rdma_nr_atomic_resp_res;
+	qp_attr->max_rd_atomic = qpcb->rdma_atomic_outst_dest_qp;
+
 	/* primary av */
 	qp_attr->ah_attr.sl = qpcb->service_level;
 
-- 
1.5.2


