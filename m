Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYIDAJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYIDAJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYIDAJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:09:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:34249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYIDAJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:09:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="41316115"
Message-Id: <20080904000238.045108000@linux-os.sc.intel.com>
References: <20080904000237.746216000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 16:58:33 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/5] dmar: initialize the return value in dmar_parse_dev()
Content-Disposition: inline; filename=init_ret_value_dmar_parse_dev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: dmar: initialize the return value in dmar_parse_dev()

initialize the return value in dmar_parse_dev()

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c	2008-09-03 11:48:21.000000000 -0700
+++ tip/drivers/pci/dmar.c	2008-09-03 11:49:34.000000000 -0700
@@ -193,7 +193,7 @@
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	static int include_all;
-	int ret;
+	int ret = 0;
 
 	drhd = (struct acpi_dmar_hardware_unit *) dmaru->hdr;
 

-- 

