Return-Path: <linux-kernel-owner+w=401wt.eu-S1760421AbXI1IG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbXI1IG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXI1ICI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:02:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbXI1ICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:02:04 -0400
Message-Id: <20070928080042.298523000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/12] lockdep: increase MAX_LOCK_DEPTH
Content-Disposition: inline; filename=lockdep-depth.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

we can easily hold PAGE_VEC (and more in places) page locks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1246,7 +1246,7 @@ struct task_struct {
 	int softirq_context;
 #endif
 #ifdef CONFIG_LOCKDEP
-# define MAX_LOCK_DEPTH 30UL
+# define MAX_LOCK_DEPTH 48UL
 	u64 curr_chain_key;
 	int lockdep_depth;
 	struct held_lock held_locks[MAX_LOCK_DEPTH];

--

