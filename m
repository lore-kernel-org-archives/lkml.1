Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbZJAOG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbZJAOG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932509AbZJAOGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:06:55 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35080 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435AbZJAOGx (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Thu, 1 Oct 2009 10:06:53 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no,
       Jeff Mahoney <jeffm@suse.com>, Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH 17/31] Fix initialization of ipv4_route_lock
Date: Thu,  1 Oct 2009 19:38:00 +0530
Message-Id: <1254406080-16264-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

 It's CONFIG_PROC_FS, not CONFIG_PROCFS.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm/net/ipv4/route.c
===================================================================
--- mmotm.orig/net/ipv4/route.c
+++ mmotm/net/ipv4/route.c
@@ -3483,7 +3483,7 @@ int __init ip_rt_init(void)
 	ipv4_dst_ops.gc_thresh = (rt_hash_mask + 1);
 	ip_rt_max_size = (rt_hash_mask + 1) * 16;
 
-#ifdef CONFIG_PROCFS
+#ifdef CONFIG_PROC_FS
 	mutex_init(&ipv4_route_lock);
 #endif
 
