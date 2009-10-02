Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZJBMip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZJBMip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZJBMip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:38:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51546 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646AbZJBMio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:38:44 -0400
Date: Fri, 2 Oct 2009 14:38:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] timer fix
Message-ID: <20091002123839.GA19831@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Roland Dreier (1):
      hrtimer: Remove overly verbose "switch to high res mode" message


 kernel/hrtimer.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e5d98ce..4267279 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -720,8 +720,6 @@ static int hrtimer_switch_to_hres(void)
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
 	local_irq_restore(flags);
-	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
-	       smp_processor_id());
 	return 1;
 }
 
