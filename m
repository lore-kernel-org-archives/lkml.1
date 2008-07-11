Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYGKBAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYGKBAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbYGKA7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005950.548327382@goodmis.org>
References: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/8] ftrace: trace schedule
Content-Disposition: inline; filename=ftrace-trace-sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the sched_clock code has been removed from sched.c we can now trace
the scheduler. The scheduler has a lot of functions that would be worth
tracing.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/kernel/Makefile
===================================================================
--- linux-tip.git.orig/kernel/Makefile	2008-07-07 15:22:21.000000000 -0400
+++ linux-tip.git/kernel/Makefile	2008-07-07 16:32:48.000000000 -0400
@@ -11,7 +11,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
-CFLAGS_REMOVE_sched.o = -pg -mno-spe
+CFLAGS_REMOVE_sched.o = -mno-spe
 
 ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files

-- 
