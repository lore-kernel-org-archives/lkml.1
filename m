Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYBYAId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYBYAId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYBYAII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:08:08 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46638 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYBYAIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:08:07 -0500
Date: Mon, 25 Feb 2008 02:07:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2,6 patch] make mm/sparse.c: make a function static
Message-ID: <20080225000711.GB2088@cs181133002.pp.htv.fi>
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

