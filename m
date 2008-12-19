Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYLSVjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYLSVjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYLSViv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:38:51 -0500
Received: from www.tglx.de ([62.245.132.106]:55771 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbYLSVit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:38:49 -0500
Message-Id: <20081219211946.740657176@linutronix.de>
References: <20081219211656.875192771@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 21:22:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: [patch 3/7] rtmutex: remove unused variable
Content-Disposition: inline; filename=rtmutex-remove-unused-variable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the leftover of the rwlock fixes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rtmutex.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.24/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.orig/kernel/rtmutex.c
+++ linux-2.6.24/kernel/rtmutex.c
@@ -1950,9 +1950,6 @@ rt_write_fastunlock(struct rw_mutex *rwm
 					    int mtx),
 		    int mtx)
 {
-	struct task_struct *val = (void *)((unsigned long)current |
-					   RT_RWLOCK_WRITER);
-
 	WARN_ON(rt_rwlock_owner(rwm) != current);
 	slowfn(rwm, mtx);
 }

-- 

