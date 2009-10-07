Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZJGRGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZJGRGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbZJGRGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:06:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:10629 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZJGRGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:06:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,520,1249282800"; 
   d="scan'208";a="500751421"
Message-Id: <20091007170149.080617784@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 07 Oct 2009 10:00:50 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       a.beregalov@gmail.com
Subject: [patch 1/2] dmar: coding style cleanup for dmar_parse_one_rhsa()
Content-Disposition: inline; filename=fix_indentation_config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/pci/dmar.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: iommu-2.6/drivers/pci/dmar.c
===================================================================
--- iommu-2.6.orig/drivers/pci/dmar.c
+++ iommu-2.6/drivers/pci/dmar.c
@@ -362,8 +362,9 @@ dmar_parse_one_rhsa(struct acpi_dmar_hea
 			if (!node_online(node))
 				node = -1;
 			drhd->iommu->node = node;
-		return 0;
-	}
+
+			return 0;
+		}
 
 	return -ENODEV;
 }


