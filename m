Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXEILuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXEILuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbXEILsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:48:38 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:50313 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbXEILsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:48:35 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 6/6] IB/ehca: disable scaling code by default, bump version number
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Wed, 9 May 2007 13:48:31 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705091348.31742.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Scaling code is still considered experimental, so disable it by default
- Increase version to SVNEHCA_0023

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index dc736e8..233788a 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -52,7 +52,7 @@ #include "hcp_if.h"
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
 MODULE_DESCRIPTION("IBM eServer HCA InfiniBand Device Driver");
-MODULE_VERSION("SVNEHCA_0022");
+MODULE_VERSION("SVNEHCA_0023");
 
 int ehca_open_aqp1     = 0;
 int ehca_debug_level   = 0;
@@ -62,7 +62,7 @@ int ehca_use_hp_mr     = 0;
 int ehca_port_act_time = 30;
 int ehca_poll_all_eqs  = 1;
 int ehca_static_rate   = -1;
-int ehca_scaling_code  = 1;
+int ehca_scaling_code  = 0;
 
 module_param_named(open_aqp1,     ehca_open_aqp1,     int, 0);
 module_param_named(debug_level,   ehca_debug_level,   int, 0);
@@ -799,7 +799,7 @@ int __init ehca_module_init(void)
 	int ret;
 
 	printk(KERN_INFO "eHCA Infiniband Device Driver "
-	       "(Rel.: SVNEHCA_0022)\n");
+	       "(Rel.: SVNEHCA_0023)\n");
 	idr_init(&ehca_qp_idr);
 	idr_init(&ehca_cq_idr);
 	spin_lock_init(&ehca_qp_idr_lock);
-- 
1.4.2.1


