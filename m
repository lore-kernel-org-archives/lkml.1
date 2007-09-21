Return-Path: <linux-kernel-owner+w=401wt.eu-S1764212AbXIUUwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764212AbXIUUwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763321AbXIUUpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763261AbXIUUpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:05 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [22/45] x86_64: Enable iommu_merge by default
Message-Id: <20070921204504.48A2E14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/pci-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-dma.c
+++ linux/arch/x86_64/kernel/pci-dma.c
@@ -11,7 +11,7 @@
 #include <asm/iommu.h>
 #include <asm/calgary.h>
 
-int iommu_merge __read_mostly = 0;
+int iommu_merge __read_mostly = 1;
 EXPORT_SYMBOL(iommu_merge);
 
 dma_addr_t bad_dma_address __read_mostly;
