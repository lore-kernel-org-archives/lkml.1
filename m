Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXFNWtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXFNWtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXFNWtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:49:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52777 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXFNWtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:49:39 -0400
Date: Fri, 15 Jun 2007 00:49:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [patch] CFS scheduler, -v17
Message-ID: <20070614224908.GA9412@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce release -v17 of the CFS scheduler patchset.
 
The rolled-up CFS patch against v2.6.22-rc4, v2.6.22-rc4-mm2, v2.6.21.5 
or v2.6.20.13 can be downloaded from the usual place:

   http://people.redhat.com/mingo/cfs-scheduler/
 
-v17 includes a bigger change: the CFS-core changes in preparation of 
the group-scheduling feature, written Srivatsa Vaddagiri. Dmitry 
Adamushko provided cleanups and further generalizations to this code and 
the modularization of CFS has been further enhanced as a result. To 
users, these changes are mostly invisible.

Changes since -v16:

 - lots of core updates to support group scheduling, and related 
   cleanups. (Srivatsa Vaddagiri, Dmitry Adamushko)

 - tuned the runtime-limit up a bit, based on relentless testing done by
   Tobias Gerschner.

 - the new, precise load-calculation method for SMP balancing has been
   further enhanced, and is now active by default. (Dmitry Adamushko)

 - fix SCHED_IDLEPRIO support (based on feedback from Thomas Sattler)

 - further updates to /proc/sched_debug and /proc/PID/sched

 - more cleanups

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome!
  
	Ingo
