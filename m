Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbXISDl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbXISDl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbXISDhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:37:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53636 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752228AbXISDgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:44 -0400
Message-Id: <20070919033644.227615559@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:22 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [17/17] Allow virtual fallback for dentries
Content-Disposition: inline; filename=vcompound_dentry
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/dcache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2007-09-18 18:42:19.000000000 -0700
+++ linux-2.6/fs/dcache.c	2007-09-18 18:42:55.000000000 -0700
@@ -2118,7 +2118,8 @@ static void __init dcache_init(unsigned 
 	 * of the dcache. 
 	 */
 	dentry_cache = KMEM_CACHE(dentry,
-		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
+		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|
+		SLAB_VFALLBACK);
 	
 	register_shrinker(&dcache_shrinker);
 

-- 
