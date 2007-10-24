Return-Path: <linux-kernel-owner+w=401wt.eu-S1763197AbXJXQjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197AbXJXQjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbXJXQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60943 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759823AbXJXQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:47 -0400
Date: Wed, 24 Oct 2007 18:25:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>, Avi Kivity <avi@qumranet.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make kernel/sched.c:account_guest_time() static
Message-ID: <20071024162517.GW30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

account_guest_time() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2779ceb45e015ce32451d20c3724a8ad2cd26462 
diff --git a/kernel/sched.c b/kernel/sched.c
index 2810e56..c306a4a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3336,7 +3336,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime)
  * @p: the process that the cpu time gets accounted to
  * @cputime: the cpu time spent in virtual machine since the last update
  */
-void account_guest_time(struct task_struct *p, cputime_t cputime)
+static void account_guest_time(struct task_struct *p, cputime_t cputime)
 {
 	cputime64_t tmp;
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;

