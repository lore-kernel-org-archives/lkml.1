Return-Path: <linux-kernel-owner+w=401wt.eu-S965590AbXAWXSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590AbXAWXSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965593AbXAWXSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:18:05 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:39877 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965592AbXAWXSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:18:02 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, hch@infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, openfabrics-ewg@openib.org
Subject: [PATCH 2.6.21 4/4] ehca: remove obsolete prototypes
Date: Wed, 24 Jan 2007 00:14:18 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701240014.19439.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch for ehca_classes.h that removes obsolete prototypes.
Thanks
Nam


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_classes.h |   14 --------------
 1 files changed, 14 deletions(-)


diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h	2007-01-20 00:21:21.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h	2007-01-20 00:23:46.000000000 +0100
@@ -250,20 +250,6 @@ struct ehca_ucontext {
 	struct ib_ucontext ib_ucontext;
 };
 
-struct ehca_module *ehca_module_new(void);
-
-int ehca_module_delete(struct ehca_module *me);
-
-int ehca_eq_ctor(struct ehca_eq *eq);
-
-int ehca_eq_dtor(struct ehca_eq *eq);
-
-struct ehca_shca *ehca_shca_new(void);
-
-int ehca_shca_delete(struct ehca_shca *me);
-
-struct ehca_sport *ehca_sport_new(struct ehca_shca *anchor);
-
 int ehca_init_pd_cache(void);
 void ehca_cleanup_pd_cache(void);
 int ehca_init_cq_cache(void);
