Return-Path: <linux-kernel-owner+w=401wt.eu-S965229AbXG0URl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965229AbXG0URl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965179AbXG0UQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:16:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41994 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965313AbXG0UQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:16:27 -0400
Date: Fri, 27 Jul 2007 12:31:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, mingo@elte.hu
Subject: [PATCH] sched: fix kernel-doc warnings
Message-Id: <20070727123126.7fc35002.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in sched.c:

Warning(linux-2623-rc1g4//kernel/sched.c:1685): No description found for parameter 'notifier'
Warning(linux-2623-rc1g4//kernel/sched.c:1696): No description found for parameter 'notifier'
Warning(linux-2623-rc1g4//kernel/sched.c:1750): No description found for parameter 'prev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/sched.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2623-rc1g4.orig/kernel/sched.c
+++ linux-2623-rc1g4/kernel/sched.c
@@ -1678,8 +1678,8 @@ void fastcall wake_up_new_task(struct ta
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 /**
- * preempt_notifier_register - tell me when current is being being preempted
- *                         and rescheduled
+ * preempt_notifier_register - tell me when current is being being preempted & rescheduled
+ * @notifier: notifier struct to register
  */
 void preempt_notifier_register(struct preempt_notifier *notifier)
 {
@@ -1689,6 +1689,7 @@ EXPORT_SYMBOL_GPL(preempt_notifier_regis
 
 /**
  * preempt_notifier_unregister - no longer interested in preemption notifications
+ * @notifier: notifier struct to unregister
  *
  * This is safe to call from within a preemption notifier.
  */
@@ -1735,6 +1736,7 @@ fire_sched_out_preempt_notifiers(struct 
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
+ * @prev: the current task that is being switched out
  * @next: the task we are going to switch to.
  *
  * This is called with the rq lock held and interrupts off. It must
