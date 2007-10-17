Return-Path: <linux-kernel-owner+w=401wt.eu-S1764329AbXJQGsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764329AbXJQGsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbXJQGsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:48:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33825 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756642AbXJQGsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:48:35 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Lameter <clameter@sgi.com>,
       Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Oct 2007 23:48:34 -0700
Message-Id: <20071017064834.31240.30857.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] hotplug cpu: migrate a task within its cpuset whitespace fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Fix indentation and spacing.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>

---

This fix applies to and follows the other patches:
    hotplug-cpu-migrate-a-task-within-its-cpuset*.patch

 kernel/sched.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- 2.6.23-mm1.orig/kernel/sched.c	2007-10-16 21:59:36.035170738 -0700
+++ 2.6.23-mm1/kernel/sched.c	2007-10-16 22:05:23.624506696 -0700
@@ -5034,16 +5034,16 @@ static void move_task_off_dead_cpu(int d
 
 		/* No more Mr. Nice Guy. */
 		if (dest_cpu == NR_CPUS) {
-		cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
-		/*
-		 * Try to stay on the same cpuset, where the current cpuset
-		 * may be a subset of all cpus.
-		 * The cpuset_cpus_allowed_locked() variant of
-		 * cpuset_cpus_allowed() will not block
-		 * It must be called within calls to cpuset_lock/cpuset_unlock.
-		 */
+			cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
+			/*
+			 * Try to stay on the same cpuset, where the
+			 * current cpuset may be a subset of all cpus.
+			 * The cpuset_cpus_allowed_locked() variant of
+			 * cpuset_cpus_allowed() will not block.  It must be
+			 * called within calls to cpuset_lock/cpuset_unlock.
+			 */
 			rq = task_rq_lock(p, &flags);
-		p->cpus_allowed = cpus_allowed;
+			p->cpus_allowed = cpus_allowed;
 			dest_cpu = any_online_cpu(p->cpus_allowed);
 			task_rq_unlock(rq, &flags);
 

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
