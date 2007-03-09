Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXCIJ0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXCIJ0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXCIJ0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:26:04 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34763 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbXCIJ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:26:01 -0500
Date: Fri, 9 Mar 2007 11:25:59 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: [PATCH] revoke: fix VM_REVOKED mask
Message-ID: <Pine.LNX.4.64.0703091123080.4510@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Fix VM_REVOKED mask which overlaps with VM_ALWAYSDUMP.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/mm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: uml-2.6/include/linux/mm.h
===================================================================
--- uml-2.6.orig/include/linux/mm.h	2007-03-09 11:14:06.000000000 +0200
+++ uml-2.6/include/linux/mm.h	2007-03-09 11:14:19.000000000 +0200
@@ -169,8 +169,7 @@ #define VM_NONLINEAR	0x00800000	/* Is no
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
-
-#define VM_REVOKED	0x04000000	/* Mapping has been revoked */
+#define VM_REVOKED	0x08000000	/* Mapping has been revoked */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
