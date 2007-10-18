Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbXJRTiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbXJRTiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXJRThx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:37:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34826 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbXJRThx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:37:53 -0400
Date: Thu, 18 Oct 2007 21:37:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20071018193741.GA19722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

five commits - the most important item is the fix for the 
wait_for_completion_interruptible() bug found by Geert Uytterhoeven. The 
rest is cleanups only.

Thanks!

	Ingo

------------------>
Andi Kleen (1):
      sched: fix return value of wait_for_completion_interruptible()

Ingo Molnar (3):
      sched: cleanup, fix spacing
      sched: cleanup, make struct rq comments more consistent
      sched: add KERN_CONT annotation

Ken Chen (1):
      sched: reduce schedstat variable overhead a bit

 include/linux/sched.h |   42 ++++++++++++++--------------
 kernel/sched.c        |   73 +++++++++++++++++++++++++++-----------------------
 kernel/sched_debug.c  |    2 -
 kernel/sched_stats.h  |    8 ++---
 4 files changed, 65 insertions(+), 60 deletions(-)
