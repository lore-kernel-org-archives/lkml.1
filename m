Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbXHJFuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbXHJFuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 01:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXHJFtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 01:49:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41596 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbXHJFty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 01:49:54 -0400
Date: Fri, 10 Aug 2007 07:49:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070810054948.GA5908@elte.hu>
References: <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu> <Pine.LNX.4.64.0708011511530.1817@scrub.home> <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de> <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org> <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home> <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708100037460.1817@scrub.home>
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


* Roman Zippel <zippel@linux-m68k.org> wrote:

> >  4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
> >  4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
> >  4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
> >  4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l
> > 
> > and i'm still wondering how that output was possible.
> 
> I disabled the jiffies logic and the result is still the same, so this 
> problem isn't related to resolution at all.

how did you disable the jiffies logic? Also, could you please send me 
the cfs-debug-info.sh:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

captured _while_ the above workload is running. This is the third time 
i've asked for that :-)

to establish that the basic sched_clock() behavior is sound on that box, 
could you please also run this tool:

   http://people.redhat.com/mingo/cfs-scheduler/tools/tsc-dump.c

please run it both while the system is idle, and while there's a CPU hog 
running:

  while :; do :; done &

and send me that output too? (it's 2x 60 lines only) Thanks!

	Ingo
