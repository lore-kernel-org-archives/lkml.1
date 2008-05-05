Return-Path: <linux-kernel-owner+w=401wt.eu-S1762703AbYEESeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703AbYEESeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760925AbYEES15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:27:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:32960 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760917AbYEES14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:27:56 -0400
Date: Mon, 5 May 2008 21:26:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make mm/sparse.c: make a function static
Message-ID: <20080505182648.GE17139@cs181133002.pp.htv.fi>
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
- 22 Apr 2008
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


