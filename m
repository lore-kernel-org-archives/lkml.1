Return-Path: <linux-kernel-owner+w=401wt.eu-S934402AbYBMVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbYBMVnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763846AbYBMVau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:50 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55726 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761117AbYBMVas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:48 -0500
Date: Wed, 13 Feb 2008 23:30:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: clameter@sgi.com, penberg@cs.helsinki.fi
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make slub.c:slab_address() static
Message-ID: <20080213213032.GH3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slab_address() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
fdd710f00d8bed8413c160685bc5229ec15b4d9f diff --git a/mm/slub.c b/mm/slub.c
index e2989ae..af83daf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -308,7 +308,7 @@ static inline int is_end(void *addr)
 	return (unsigned long)addr & PAGE_MAPPING_ANON;
 }
 
-void *slab_address(struct page *page)
+static void *slab_address(struct page *page)
 {
 	return page->end - PAGE_MAPPING_ANON;
 }

