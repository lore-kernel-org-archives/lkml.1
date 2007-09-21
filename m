Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbXIUUvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbXIUUvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758271AbXIUUpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:09 -0400
Received: from ns.suse.de ([195.135.220.2]:50049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758314AbXIUUpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:04 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [21/45] x86_64: Some cleanups for pci gart code
Message-Id: <20070921204503.3A12E14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Mark function static
- Clarify license

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/pci-gart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/pci-gart.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-gart.c
+++ linux/arch/x86_64/kernel/pci-gart.c
@@ -8,6 +8,7 @@
  * See Documentation/DMA-mapping.txt for the interface specification.
  * 
  * Copyright 2002 Andi Kleen, SuSE Labs.
+ * Subject to the GNU General Public License v2 only.
  */
 
 #include <linux/types.h>
@@ -374,7 +375,8 @@ static inline int dma_map_cont(struct sc
  * DMA map all entries in a scatterlist.
  * Merge chunks that have page aligned sizes into a continuous mapping. 
  */
-int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+			int dir)
 {
 	int i;
 	int out;
