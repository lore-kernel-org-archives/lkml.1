Return-Path: <linux-kernel-owner+w=401wt.eu-S1030476AbXDUIeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbXDUIeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030580AbXDUIeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:34:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030476AbXDUIeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:34:16 -0400
Date: Sat, 21 Apr 2007 10:33:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Nick Piggin <npiggin@suse.de>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely   Fair Scheduler [CFS]
Message-ID: <20070421083343.GB29800@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <1176782489.13059.15.camel@Homer.simpson.net> <20070417041420.GF25513@wotan.suse.de> <20070417095140.GB22626@elte.hu> <462926DF.1030404@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462926DF.1030404@tmr.com>
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


* Bill Davidsen <davidsen@tmr.com> wrote:

> All of my testing has been on desktop machines, although in most cases 
> they were really loaded desktops which had load avg 10..100 from time 
> to time, and none were low memory machines. Up to CFS v3 I thought 
> nicksched was my winner, now CFSv3 looks better, by not having 
> stumbles under stupid loads.

nice! I hope CFSv4 kept that good tradition too ;)

> I have not tested:
>   1 - server loads, nntp, smtp, etc
>   2 - low memory machines
>   3 - uniprocessor systems
> 
> I think this should be done before drawing conclusions. Or if someone 
> has tried this, perhaps they would report what they saw. People are 
> talking about smoothness, but not how many pages per second come out 
> of their overloaded web server.

i tested heavily swapping systems. (make -j50 workloads easily trigger 
that) I also tested UP systems and a handful of SMP systems. I have also 
tested massive_intr.c which i believe is an indicator of how fairly CPU 
time is distributed between partly sleeping partly running server 
threads. But i very much agree that diverse feedback is sought and 
welcome, both from those who are happy with the current scheduler and 
those who are unhappy about it.

	Ingo
