Return-Path: <linux-kernel-owner+w=401wt.eu-S1765590AbXEWMHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765590AbXEWMHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbXEWMHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:07:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758994AbXEWMHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:07:00 -0400
Date: Wed, 23 May 2007 14:06:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com
Subject: [patch] CFS scheduler, -v14
Message-ID: <20070523120616.GA23407@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce release -v14 of the CFS scheduler patchset.

The CFS patch against v2.6.22-rc2, v2.6.21.1 or v2.6.20.10 can be 
downloaded from the usual place:
   
      http://people.redhat.com/mingo/cfs-scheduler/

In -v14 the biggest user-visible change is increased sleeper fairness 
(done by Mike Galbraith and myself), which results in better 
interactivity under load. In particular 3D apps such as compiz/Beryl or 
games benefit from it and should be less sensitive to other apps running 
in parallel to them - but plain X benefits from it too.

CFS is converging nicely, with no regressions reported against -v13. 
Changes since -v13:

 - increase sleeper-fairness (Mike Galbraith, me)

 - kernel/sched_debug.c printk argument fixes for ia64 (Andrew Morton)

 - CFS documentation fixes (Pranith Kumar D)

 - increased the default rescheduling granularity to 3msecs on UP,
   6 msecs on 2-way systems

 - small update_curr() precision fix

 - added an overview section to Documentation/sched-design-CFS.txt

 - misc cleanups

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome!

	Ingo
