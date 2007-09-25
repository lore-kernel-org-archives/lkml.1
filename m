Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXIYXqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXIYXqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXIYXnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57663 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753178AbXIYXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:53 -0400
Message-Id: <20070925234253.138607147@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:21 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [17/17] Allow virtual fallback for dentries
Content-Disposition: inline; filename=vcompound_dentry
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/dcache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2007-09-24 16:47:43.000000000 -0700
+++ linux-2.6/fs/dcache.c	2007-09-24 17:03:15.000000000 -0700
@@ -2118,7 +2118,8 @@ static void __init dcache_init(unsigned 
 	 * of the dcache. 
 	 */
 	dentry_cache = KMEM_CACHE(dentry,
-		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
+		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|
+		SLAB_VFALLBACK);
 	
 	register_shrinker(&dcache_shrinker);
 

-- 
