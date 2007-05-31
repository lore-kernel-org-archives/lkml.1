Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbXEaPKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbXEaPKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXEaPKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:10:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXEaPKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:10:10 -0400
Date: Thu, 31 May 2007 17:09:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [patch] CFS scheduler, -v15
Message-ID: <20070531150908.GA23538@elte.hu>
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


i'm pleased to announce release -v15 of the CFS scheduler patchset.
 
The CFS rolled-up patch against v2.6.22-rc3, v2.6.22-rc3-mm1, 
v2.6.21.1/3 or v2.6.20.10 can be downloaded from the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/
 
-v15 includes smaller fixes only. More precise sched_info statistics 
from Balbir Singh, interactivity tweaks from Mike Galbraith and a number 
of corner-cases fixed/cleaned up by Dmitry Adamushko.

Changes since -v14:

 - more precise sched_info statistics (Balbir Singh)

 - call update_curr() when preempting to an RT task (Dmitry Adamushko)

 - smaller interactivity tweaks (Mike Galbraith)

 - apply runtime-limit to yield_to() as well (Dmitry Adamushko)

 - load-balancing iterator cleanup/simplification (Dmitry Adamushko)

 - fix code duplication (noticed by Li Yu)

 - cleanups (Mike Galbraith)

 - fix CPU usage accounting of threadeded apps in 'top'

 - more cleanups
 
As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome!

	Ingo
