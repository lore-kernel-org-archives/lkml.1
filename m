Return-Path: <linux-kernel-owner+w=401wt.eu-S933856AbXIKNgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbXIKNgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933724AbXIKNft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:35:49 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:65446 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661AbXIKNfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:35:47 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 12/12] IB/ehca: Bump version number and change its format
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:35:32 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111535.32952.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody needed the SVNEHCA_ prefix anyway.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 799f218..c84e310 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -49,10 +49,12 @@
 #include "ehca_tools.h"
 #include "hcp_if.h"
 
+#define HCAD_VERSION "0024"
+
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
 MODULE_DESCRIPTION("IBM eServer HCA InfiniBand Device Driver");
-MODULE_VERSION("SVNEHCA_0023");
+MODULE_VERSION(HCAD_VERSION);
 
 int ehca_open_aqp1     = 0;
 int ehca_debug_level   = 0;
@@ -909,7 +911,7 @@ int __init ehca_module_init(void)
 	int ret;
 
 	printk(KERN_INFO "eHCA Infiniband Device Driver "
-	       "(Rel.: SVNEHCA_0023)\n");
+	       "(Version " HCAD_VERSION ")\n");
 
 	ret = ehca_create_comp_pool();
 	if (ret) {
-- 
1.5.2


