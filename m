Return-Path: <linux-kernel-owner+w=401wt.eu-S934739AbXGQPmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934739AbXGQPmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934564AbXGQPk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:40:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934471AbXGQPk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:40:58 -0400
Message-Id: <20070717173758.778235000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:37 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 09/12] lockdep: increase MAX_LOCK_DEPTH
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

