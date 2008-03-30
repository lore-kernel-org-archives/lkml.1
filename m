Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYC3WtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYC3WtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYC3Wsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:48:45 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53249 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbYC3Wso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:48:44 -0400
Date: Mon, 31 Mar 2008 01:48:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mm/sparse.c: make a function static
Message-ID: <20080330224832.GQ28445@cs181133002.pp.htv.fi>
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


