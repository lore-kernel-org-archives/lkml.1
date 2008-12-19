Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbYLSVjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbYLSVjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbYLSViq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:38:46 -0500
Received: from www.tglx.de ([62.245.132.106]:55754 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYLSVip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:38:45 -0500
Message-Id: <20081219211946.191787054@linutronix.de>
References: <20081219211656.875192771@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 21:22:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: [patch 2/7] sched: remove useless nointeractive state
Content-Disposition: inline;
	filename=sched-remove-useless-nointeractive-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gone task state reintroduced by rtmutex patches.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.24/include/linux/sched.h
===================================================================
--- linux-2.6.24.orig/include/linux/sched.h
+++ linux-2.6.24/include/linux/sched.h
@@ -202,8 +202,7 @@ extern struct semaphore kernel_sem;
 #define EXIT_ZOMBIE		32
 #define EXIT_DEAD		64
 /* in tsk->state again */
-#define TASK_NONINTERACTIVE	128
-#define TASK_DEAD		256
+#define TASK_DEAD		128
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)

-- 

