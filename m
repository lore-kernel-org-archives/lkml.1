Return-Path: <linux-kernel-owner+w=401wt.eu-S1760487AbYDUVhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487AbYDUVhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbYDUVc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:32:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49769 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775AbYDUVc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:32:56 -0400
Date: Tue, 22 Apr 2008 00:32:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mm/sparse.c: make a function static
Message-ID: <20080421213225.GS2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global sparse_early_mem_map_alloc() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Apr 2008
- 31 Mar 2008
- 25 Feb 2008

47e8f879748b0e89a465a50626ae93dd55844a15 diff --git a/mm/sparse.c b/mm/sparse.c
index f6a43c0..99cd810 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -269,7 +269,7 @@ struct page __init *sparse_mem_map_populate(unsigned long pnum, int nid)
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
-struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
+static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
 	struct mem_section *ms = __nr_to_section(pnum);


k
