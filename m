Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXDZFJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXDZFJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXDZFJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:09:35 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36147 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754718AbXDZFJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:09:34 -0400
Message-Id: <20070426050933.550103308@sgi.com>
References: <20070426050743.867613938@sgi.com>
User-Agent: quilt/0.45-1
Date: Wed, 25 Apr 2007 22:07:44 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/7] SLUB: Remove duplicate VM_BUG_ON
Content-Disposition: inline; filename=slub_duplicate
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow this artifact got in during merge with mm.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc7-mm1/mm/slub.c
===================================================================
--- linux-2.6.21-rc7-mm1.orig/mm/slub.c	2007-04-25 09:48:40.000000000 -0700
+++ linux-2.6.21-rc7-mm1/mm/slub.c	2007-04-25 09:48:47.000000000 -0700
@@ -633,8 +633,6 @@ static void add_full(struct kmem_cache *
 
 	VM_BUG_ON(!irqs_disabled());
 
-	VM_BUG_ON(!irqs_disabled());
-
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 

--
