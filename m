Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYJ1TCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYJ1TCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJ1TCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:02:36 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:7208 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYJ1TCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rZr3xhfyaIjeSe8OrooS+7w/+xqVYxsmuU3Lnd/2kWFjyA5Grtn0yTvQfSOXcbF4Gf
         x4GpYRPmVQQy28ajCFvb7WCHqhor1nkdWQraEptVNIVkxQNmt9KXKle16DwQqanhkx54
         QX8vCDzvAV7ynEID2UUYAHg8yZ5rDeOSGPKxY=
Date: Tue, 28 Oct 2008 22:02:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] slub - fix get_object_page comment
Message-ID: <20081028190226.GE7357@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'slab page' instead of 'slab object'.
---

Not a big deal but anyway :)

Index: linux-2.6.git/mm/slub.c
===================================================================
--- linux-2.6.git.orig/mm/slub.c	2008-10-27 21:35:50.000000000 +0300
+++ linux-2.6.git/mm/slub.c	2008-10-28 21:57:51.000000000 +0300
@@ -1748,7 +1748,7 @@ void kmem_cache_free(struct kmem_cache *
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
-/* Figure out on which slab object the object resides */
+/* Figure out on which slab page the object resides */
 static struct page *get_object_page(const void *x)
 {
 	struct page *page = virt_to_head_page(x);
