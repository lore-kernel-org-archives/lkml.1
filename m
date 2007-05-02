Return-Path: <linux-kernel-owner+w=401wt.eu-S1766906AbXEBUIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766906AbXEBUIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766909AbXEBUIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:08:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46699 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766906AbXEBUIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:08:10 -0400
Date: Wed, 2 May 2007 23:08:08 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH] slub: remove duplicate VM_BUG_ON
Message-ID: <Pine.LNX.4.64.0705022307310.16215@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes a duplicate VM_BUG_ON from add_full().

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    2 --
 1 file changed, 2 deletions(-)

Index: 26-mm/mm/slub.c
===================================================================
--- 26-mm.orig/mm/slub.c	2007-05-02 23:00:58.000000000 +0300
+++ 26-mm/mm/slub.c	2007-05-02 23:01:15.000000000 +0300
@@ -633,8 +633,6 @@ static void add_full(struct kmem_cache *
 
 	VM_BUG_ON(!irqs_disabled());
 
-	VM_BUG_ON(!irqs_disabled());
-
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
