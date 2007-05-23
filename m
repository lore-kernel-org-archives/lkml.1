Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbXEWFp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbXEWFp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 01:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbXEWFpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 01:45:50 -0400
Received: from d0618442.dreamhost.com ([208.97.132.66]:46511 "EHLO
	spaceymail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756592AbXEWFpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 01:45:50 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v13
Date: Wed, 23 May 2007 11:15:25 +0530
User-Agent: KMail/1.9.6
Cc: Bill Davidsen <davidsen@tmr.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070517174533.GA538@elte.hu> <200705180317.06014.kernel@prachanda.hub> <46536963.8040503@tmr.com>
In-Reply-To: <46536963.8040503@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231115.27123.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007 03:36:27 Bill Davidsen wrote:
> Anant Nitya wrote:
> > On Thursday 17 May 2007 23:15:33 Ingo Molnar wrote:
> >> i'm pleased to announce release -v13 of the CFS scheduler patchset.
> >>
> >> The CFS patch against v2.6.22-rc1, v2.6.21.1 or v2.6.20.10 can be
> >> downloaded from the usual place:
> >>
> >>      http://people.redhat.com/mingo/cfs-scheduler/
> >>
> >> -v13 is a fixes-only release. It fixes a smaller accounting bug, so if
> >> you saw small lags during desktop use under certain workloads then
> >> please re-check that workload under -v13 too. It also tweaks SMP
> >> load-balancing a bit. (Note: the load-balancing artifact reported by
> >> Peter Williams is not a CFS-specific problem and he reproduced it in
> >> v2.6.21 too. Nevertheless -v13 should be less prone to such artifacts.)
> >>
> >> I know about no open CFS regression at the moment, so please re-test
> >> -v13 and if you still see any problem please re-report it. Thanks!
> >>
> >> Changes since -v12:
> >>
> >>  - small tweak: made the "fork flow" of reniced tasks zero-sum
> >>
> >>  - debugging update: /proc/<PID>/sched is now seqfile based and echoing
> >>    0 to it clears the maximum-tracking counters.
> >>
> >>  - more debugging counters
> >>
> >>  - small rounding fix to make the statistical average of rounding errors
> >>    zero
> >>
> >>  - scale both the runtime limit and the granularity on SMP too, and make
> >>    it dependent on HZ
> >>
> >>  - misc cleanups
> >>
> >> As usual, any sort of feedback, bugreport, fix and suggestion is more
> >> than welcome,
> >>
> >> 	Ingo
> >> -
> >
> > Hi
> > Been testing this version of CFS from last an hour or so and still facing
> > same lag problems while browsing sites with heavy JS and or flash usage.
> > Mouse movement is pathetic and audio starts to skip. I haven't face this
> > behavior with CFS till v11.
>
> 'm not seeing this, do have a site or two as examples?

Please disregard the above post, lag problem I am experiencing got introduced 
in 2.6.22-rcX and is network QoS specific and its not related to CFS.

Regards
Ananitya


-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
