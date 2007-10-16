Return-Path: <linux-kernel-owner+w=401wt.eu-S934597AbXJPPcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbXJPPcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934476AbXJPPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:32:05 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:11101 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934464AbXJPPcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:32:02 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 5/5] IB/ehca: Enable large page MRs by default
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rolandd@cisco.com>, "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200710161722.29144.fenkes@de.ibm.com>
In-Reply-To: <200710161722.29144.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1982
Date: Tue, 16 Oct 2007 17:31:59 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710161731.59688.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index d477dc3..2f51c13 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -65,7 +65,7 @@ int ehca_port_act_time = 30;
 int ehca_poll_all_eqs  = 1;
 int ehca_static_rate   = -1;
 int ehca_scaling_code  = 0;
-int ehca_mr_largepage  = 0;
+int ehca_mr_largepage  = 1;
 
 module_param_named(open_aqp1,     ehca_open_aqp1,     int, S_IRUGO);
 module_param_named(debug_level,   ehca_debug_level,   int, S_IRUGO);
-- 
1.5.2


