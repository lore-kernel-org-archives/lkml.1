Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbYHPJez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbYHPJez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 05:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYHPJes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 05:34:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYHPJer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 05:34:47 -0400
Date: Sat, 16 Aug 2008 05:34:42 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200808160934.m7G9YgWs028953@hs20-bc2-1.build.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] VMA comment fixes
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These seem to be two tiny problems in comments related to VMA data
structures.  Am I correct?


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 386edbe..5ceb830 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -113,7 +113,7 @@ struct vm_area_struct {
 	struct vm_area_struct *vm_next;
 
 	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long vm_flags;		/* Flags, listed below. */
+	unsigned long vm_flags;		/* Flags, see vmalloc.h. */
 
 	struct rb_node vm_rb;
 
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 364789a..39fc8d7 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -6,7 +6,7 @@
 
 struct vm_area_struct;
 
-/* bits in vm_struct->flags */
+/* bits in vm_area_struct->flags */
 #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
 #define VM_ALLOC	0x00000002	/* vmalloc() */
 #define VM_MAP		0x00000004	/* vmap()ed pages */
