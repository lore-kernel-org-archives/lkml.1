Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXIYQSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXIYQSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXIYQSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:18:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35761 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbXIYQR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:17:59 -0400
Date: Tue, 25 Sep 2007 21:58:07 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com
Subject: [PATCH 1/3] Fix coding style
Message-ID: <20070925162807.GB3231@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070925144443.GA17858@elte.hu> <20070925162502.GA3231@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925162502.GA3231@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issues reported by Randy Dunlap and others

Signed-off-by : Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 init/Kconfig         |   14 +++++++-------
 kernel/sched_debug.c |    8 ++------
 2 files changed, 9 insertions(+), 13 deletions(-)

Index: current/init/Kconfig
===================================================================
--- current.orig/init/Kconfig
+++ current/init/Kconfig
@@ -282,11 +282,11 @@ config CPUSETS
 	  Say N if unsure.
 
 config FAIR_GROUP_SCHED
-	bool "Fair group cpu scheduler"
+	bool "Fair group CPU scheduler"
 	default y
 	depends on EXPERIMENTAL
 	help
-	  This feature lets cpu scheduler recognize task groups and control cpu
+	  This feature lets CPU scheduler recognize task groups and control CPU
 	  bandwidth allocation to such task groups.
 
 choice
@@ -294,11 +294,11 @@ choice
 	prompt "Basis for grouping tasks"
 	default FAIR_USER_SCHED
 
-	config FAIR_USER_SCHED
-		bool "user id"
-		help
-		  This option will choose userid as the basis for grouping
-		  tasks, thus providing equal cpu bandwidth to each user.
+config FAIR_USER_SCHED
+	bool "user id"
+	help
+	  This option will choose userid as the basis for grouping
+	  tasks, thus providing equal CPU bandwidth to each user.
 
 endchoice
 
Index: current/kernel/sched_debug.c
===================================================================
--- current.orig/kernel/sched_debug.c
+++ current/kernel/sched_debug.c
@@ -239,11 +239,7 @@ static int
 root_user_share_read_proc(char *page, char **start, off_t off, int count,
 				 int *eof, void *data)
 {
-	int len;
-
-	len = sprintf(page, "%d\n", init_task_grp_load);
-
-	return len;
+	return sprintf(page, "%d\n", init_task_grp_load);
 }
 
 static int
@@ -297,7 +293,7 @@ static int __init init_sched_debug_procf
 	pe->proc_fops = &sched_debug_fops;
 
 #ifdef CONFIG_FAIR_USER_SCHED
-	pe = create_proc_entry("root_user_share", 0644, NULL);
+	pe = create_proc_entry("root_user_cpu_share", 0644, NULL);
 	if (!pe)
 		return -ENOMEM;
 


-- 
Regards,
vatsa
