Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbYJ3XcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbYJ3XcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbYJ3XcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:32:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32993 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbYJ3XcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:32:03 -0400
Date: Fri, 31 Oct 2008 00:31:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20081030233150.GA15278@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Li Zefan (2):
      sched: change sched_debug's mode to 0444
      sched: remove sched-design.txt from 00-INDEX


 Documentation/scheduler/00-INDEX |    2 --
 kernel/sched_debug.c             |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Documentation/scheduler/00-INDEX b/Documentation/scheduler/00-INDEX
index fc234d0..aabcc3a 100644
--- a/Documentation/scheduler/00-INDEX
+++ b/Documentation/scheduler/00-INDEX
@@ -4,8 +4,6 @@ sched-arch.txt
 	- CPU Scheduler implementation hints for architecture specific code.
 sched-coding.txt
 	- reference for various scheduler-related methods in the O(1) scheduler.
-sched-design.txt
-	- goals, design and implementation of the Linux O(1) scheduler.
 sched-design-CFS.txt
 	- goals, design and implementation of the Complete Fair Scheduler.
 sched-domains.txt
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index ad958c1..5ae1776 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -319,7 +319,7 @@ static int __init init_sched_debug_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("sched_debug", 0644, NULL, &sched_debug_fops);
+	pe = proc_create("sched_debug", 0444, NULL, &sched_debug_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
