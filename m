Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbZCPUAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbZCPUAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZCPUAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:00:35 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:56336 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751835AbZCPUAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:00:34 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Mon, 16 Mar 2009 19:58:09 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 -tip] sched: Fixed typos in documentation.
Message-ID: <20090316195809.GA6073@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed typos in functions documentation.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cbfa5ab..0a5d929 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2114,7 +2114,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * it must be off the runqueue _entirely_, and not
 		 * preempted!
 		 *
-		 * So if it wa still runnable (but just not actively
+		 * So if it was still runnable (but just not actively
 		 * running right now), it's preempted, and we should
 		 * yield - it could be a while.
 		 */
@@ -2628,7 +2628,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 /**
- * preempt_notifier_register - tell me when current is being being preempted & rescheduled
+ * preempt_notifier_register - tell me when current is being preempted & rescheduled
  * @notifier: notifier struct to register
  */
 void preempt_notifier_register(struct preempt_notifier *notifier)
-- 
1.6.2

