Return-Path: <linux-kernel-owner+w=401wt.eu-S1764568AbXIUUvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764568AbXIUUvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763327AbXIUUpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:50035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763189AbXIUUpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:01 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: padator@wanadoo.fr, ak@suse.de, discuss@x86-64.org,
       akpm@linux-foundation.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [18/45] x86_64: 0 -> NULL, for arch/x86_64
Message-Id: <20070921204500.0B91314EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Yoann Padioleau <padator@wanadoo.fr>

When comparing a pointer, it's clearer to compare it to NULL than to 0.

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: ak@suse.de
Cc: discuss@x86-64.org
Cc: akpm@linux-foundation.org
---

 arch/x86_64/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/mm/numa.c
===================================================================
--- linux.orig/arch/x86_64/mm/numa.c
+++ linux/arch/x86_64/mm/numa.c
@@ -166,7 +166,7 @@ early_node_mem(int nodeid, unsigned long
 		return __va(mem);
 	ptr = __alloc_bootmem_nopanic(size,
 				SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS));
-	if (ptr == 0) {
+	if (ptr == NULL) {
 		printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
 			size, nodeid);
 		return NULL;
