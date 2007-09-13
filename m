Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbXIMQRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbXIMQRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763421AbXIMQPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:15:05 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:22358 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763388AbXIMQPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:15:02 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 1/3] IB/ehca: Fix large page HW cap defines
Date: Thu, 13 Sep 2007 18:14:58 +0200
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709131814.13937.fenkes@de.ibm.com>
In-Reply-To: <200709131814.13937.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131814.59307.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 206d4eb..c2edd4c 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -99,10 +99,10 @@ struct ehca_sport {
 	struct ehca_sma_attr saved_attr;
 };
 
-#define HCA_CAP_MR_PGSIZE_4K  1
-#define HCA_CAP_MR_PGSIZE_64K 2
-#define HCA_CAP_MR_PGSIZE_1M  4
-#define HCA_CAP_MR_PGSIZE_16M 8
+#define HCA_CAP_MR_PGSIZE_4K  0x80000000
+#define HCA_CAP_MR_PGSIZE_64K 0x40000000
+#define HCA_CAP_MR_PGSIZE_1M  0x20000000
+#define HCA_CAP_MR_PGSIZE_16M 0x10000000
 
 struct ehca_shca {
 	struct ib_device ib_device;
-- 
1.5.2


