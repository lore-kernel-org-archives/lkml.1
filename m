Return-Path: <linux-kernel-owner+w=401wt.eu-S1750962AbXBULKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbXBULKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXBULKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:10:47 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57507 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXBULKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:10:46 -0500
Date: Wed, 21 Feb 2007 13:10:44 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: apkm@linux-foundation.org
cc: arjan@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] slab: add __must_check to krealloc
Message-ID: <Pine.LNX.4.64.0702211310120.17065@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As suggested by Arjan, make GCC warn about classic misuse of the realloc API.

Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6/include/linux/slab.h
===================================================================
--- 2.6.orig/include/linux/slab.h	2007-02-21 13:06:47.000000000 +0200
+++ 2.6/include/linux/slab.h	2007-02-21 13:07:06.000000000 +0200
@@ -72,7 +72,7 @@
  */
 void *__kmalloc(size_t, gfp_t);
 void *__kzalloc(size_t, gfp_t);
-void *krealloc(const void *, size_t, gfp_t);
+void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
 unsigned int ksize(const void *);
 
