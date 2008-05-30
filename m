Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYE3Hit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYE3Hit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYE3Hh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:37:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756011AbYE3Hh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:37:57 -0400
Message-ID: <483FAD74.5040702@cn.fujitsu.com>
Date: Fri, 30 May 2008 15:32:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>
Subject: [PATCH 1/3] cpusets: cleanup kernel-doc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Use '/*' instead of '/**' for static functions.
2. Remove redundant blank line.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 kernel/cpuset.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 86ea9e3..f063368 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -731,7 +731,7 @@ static inline int started_after(void *p1, void *p2)
 	return started_after_time(t1, &t2->start_time, t2);
 }
 
-/**
+/*
  * cpuset_test_cpumask - test a task's cpus_allowed versus its cpuset's
  * @tsk: task to test
  * @scan: struct cgroup_scanner contained in its struct cpuset_hotplug_scanner
@@ -748,7 +748,7 @@ static int cpuset_test_cpumask(struct task_struct *tsk,
 			(cgroup_cs(scan->cg))->cpus_allowed);
 }
 
-/**
+/*
  * cpuset_change_cpumask - make a task's cpus_allowed the same as its cpuset's
  * @tsk: task to test
  * @scan: struct cgroup_scanner containing the cgroup of the task
@@ -765,7 +765,7 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
 	set_cpus_allowed_ptr(tsk, &((cgroup_cs(scan->cg))->cpus_allowed));
 }
 
-/**
+/*
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
  * @buf: buffer of cpu numbers written to this cpuset
@@ -1736,7 +1736,7 @@ int __init cpuset_init(void)
 	return 0;
 }
 
-/**
+/*
  * cpuset_do_move_task - move a given task to another cpuset
  * @tsk: pointer to task_struct the task to move
  * @scan: struct cgroup_scanner contained in its struct cpuset_hotplug_scanner
@@ -1753,7 +1753,7 @@ static void cpuset_do_move_task(struct task_struct *tsk,
 	cgroup_attach_task(chsp->to, tsk);
 }
 
-/**
+/*
  * move_member_tasks_to_cpuset - move tasks from one cpuset to another
  * @from: cpuset in which the tasks currently reside
  * @to: cpuset to which the tasks will be moved
@@ -1938,7 +1938,6 @@ void __init cpuset_init_smp(void)
 }
 
 /**
-
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
  * @pmask: pointer to cpumask_t variable to receive cpus_allowed set.
-- 
1.5.4.rc3



