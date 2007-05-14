Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXENHHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXENHHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 03:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXENHHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 03:07:34 -0400
Received: from ozlabs.org ([203.10.76.45]:53327 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbXENHHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 03:07:34 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 14 May 2007 17:07:03 +1000
Subject: [PATCH] Add __vunmap prototype
Message-Id: <20070514070732.B3796DDE44@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__vunmap is not static but I couldn't find a prototype for it, so this
adds it. I need to use it in some powerpc patch to come.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

 include/linux/vmalloc.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-cell/include/linux/vmalloc.h
===================================================================
--- linux-cell.orig/include/linux/vmalloc.h	2007-05-14 16:03:42.000000000 +1000
+++ linux-cell/include/linux/vmalloc.h	2007-05-14 16:03:47.000000000 +1000
@@ -50,6 +50,7 @@ extern void vfree(void *addr);
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
 extern void vunmap(void *addr);
+extern void __vunmap(void *addr, int deallocate_pages);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
