Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYIWTf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYIWTf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYIWTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:35:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYIWTfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:35:11 -0400
Date: Tue, 23 Sep 2008 21:35:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080923193505.GA25898@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Rakib Mullick (1):
      sched: fix init_hrtick() section mismatch warning


 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9889080..13dd2db 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1087,7 +1087,7 @@ hotplug_hrtick(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_DONE;
 }
 
-static void init_hrtick(void)
+static __init void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
