Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbXKCATB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbXKCATB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762491AbXKCAEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:04:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49499 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762479AbXKCAEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:04:22 -0400
Date: Sat, 3 Nov 2007 01:03:58 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make __vmalloc_area_node() static
Message-ID: <20071103000358.GB4594@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__vmalloc_area_node() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b3249772621c0e8a7210f5a4d451ceaf73d28984 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index af77e17..8c6c0dd 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -423,8 +423,8 @@ void *vmap(struct page **pages, unsigned int count,
 }
 EXPORT_SYMBOL(vmap);
 
-void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
-				pgprot_t prot, int node)
+static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
+				 pgprot_t prot, int node)
 {
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;

