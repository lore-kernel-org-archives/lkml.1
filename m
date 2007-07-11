Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXGKTie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXGKTie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758452AbXGKTi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:38:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262AbXGKTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:38:25 -0400
Date: Wed, 11 Jul 2007 21:38:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull request] scheduler updates
Message-ID: <20070711193820.GA24491@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest sched.git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

It includes 5 small fixes from the CFS merge fallout: Mike noticed a 
typo in the prio_to_wmult[] lookup table (the visible effects of this 
bug were minor), plus allow the scheduler to default to larger than 10 
msecs granularity - this should help larger boxes (without changing any 
of the tunings on smaller boxes), then there are also show_tasks() 
output fixes and some small cleanups.

Thanks,

	Ingo

----------------------->
Mike Galbraith (1):
      sched: fix prio_to_wmult[] for nice 1

Ingo Molnar (4):
      sched: allow larger granularity
      sched: remove stale version info from kernel/sched_debug.c
      sched: fix show_task()/show_tasks() output
      sched: small topology.h cleanup

 include/linux/topology.h |    2 +-
 kernel/sched.c           |   30 ++++++++++++------------------
 kernel/sched_debug.c     |    2 +-
 3 files changed, 14 insertions(+), 20 deletions(-)
