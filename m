Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXKZEtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXKZEtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 23:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXKZEtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 23:49:47 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37239 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXKZEtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 23:49:46 -0500
Date: Mon, 26 Nov 2007 10:32:36 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [PATCH 1/4] sched: code cleanup
Message-ID: <20071126050236.GB5304@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126050044.GA5304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Minor cleanups:

- Fix coding style
- remove obsolete comment

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kernel/sched.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -191,12 +191,12 @@ struct task_group init_task_group = {
 };
 
 #ifdef CONFIG_FAIR_USER_SCHED
-# define INIT_TASK_GRP_LOAD	2*NICE_0_LOAD
+# define INIT_TASK_GROUP_LOAD	2*NICE_0_LOAD
 #else
-# define INIT_TASK_GRP_LOAD	NICE_0_LOAD
+# define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 #endif
 
-static int init_task_group_load = INIT_TASK_GRP_LOAD;
+static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 
 /* return group to which a task belongs */
 static inline struct task_group *task_group(struct task_struct *p)
@@ -864,21 +864,6 @@ iter_move_one_task(struct rq *this_rq, i
 
 #define sched_class_highest (&rt_sched_class)
 
-/*
- * Update delta_exec, delta_fair fields for rq.
- *
- * delta_fair clock advances at a rate inversely proportional to
- * total load (rq->load.weight) on the runqueue, while
- * delta_exec advances at the same rate as wall-clock (provided
- * cpu is not idle).
- *
- * delta_exec / delta_fair is a measure of the (smoothened) load on this
- * runqueue over any given interval. This (smoothened) load is used
- * during load balance.
- *
- * This function is called /before/ updating rq->load
- * and when switching tasks.
- */
 static inline void inc_load(struct rq *rq, const struct task_struct *p)
 {
 	update_load_add(&rq->load, p->se.load.weight);

-- 
Regards,
vatsa
