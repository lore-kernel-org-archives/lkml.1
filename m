Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbXGINVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbXGINVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXGINVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:21:00 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:46643 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbXGINU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:20:59 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 01/13] IB/ehca: change scaling_code parameter description to match default value
Date: Mon, 9 Jul 2007 15:20:55 +0200
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091520.56294.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index c3f99f3..fea199f 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -94,7 +94,7 @@ MODULE_PARM_DESC(poll_all_eqs,
 MODULE_PARM_DESC(static_rate,
 		 "set permanent static rate (default: disabled)");
 MODULE_PARM_DESC(scaling_code,
-		 "set scaling code (0: disabled, 1: enabled/default)");
+		 "set scaling code (0: disabled/default, 1: enabled)");
 
 spinlock_t ehca_qp_idr_lock;
 spinlock_t ehca_cq_idr_lock;
-- 
1.5.2


