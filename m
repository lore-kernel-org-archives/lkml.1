Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYF0L6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYF0L6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYF0L5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:57:53 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:37394 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYF0L5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:52 -0400
Message-Id: <20080627115211.010995594@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/30] sched: clean up some unused variables
Content-Disposition: inline; filename=sched-rt-cleanup-unused-variable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from /mnt/build/linux-2.6/kernel/sched.c:1496:
/mnt/build/linux-2.6/kernel/sched_rt.c: In function '__enable_runtime':
/mnt/build/linux-2.6/kernel/sched_rt.c:339: warning: unused variable 'rd'
/mnt/build/linux-2.6/kernel/sched_rt.c: In function 'requeue_rt_entity':
/mnt/build/linux-2.6/kernel/sched_rt.c:692: warning: unused variable 'queue'

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_rt.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -336,7 +336,6 @@ static void disable_runtime(struct rq *r
 
 static void __enable_runtime(struct rq *rq)
 {
-	struct root_domain *rd = rq->rd;
 	struct rt_rq *rt_rq;
 
 	if (unlikely(!scheduler_running))
@@ -689,7 +688,6 @@ static
 void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 {
 	struct rt_prio_array *array = &rt_rq->active;
-	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
 	if (on_rt_rq(rt_se)) {
 		list_del_init(&rt_se->run_list);

-- 

