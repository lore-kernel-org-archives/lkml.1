Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXDFQl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXDFQl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbXDFQl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:41:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbXDFQlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:41:24 -0400
Date: Fri, 6 Apr 2007 18:39:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] hrtimers debug patch
Message-ID: <20070406163927.GA27031@elte.hu>
References: <46020385.50301@yahoo.com.au> <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org> <1174612132.16068.114.camel@localhost.localdomain> <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org> <20070323021115.GA11147@wotan.suse.de> <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com> <20070323120148.GA27505@elte.hu> <4607BDD9.1010002@googlemail.com> <20070326170225.GA951@elte.hu> <6bffcb0e0704060827l73aeb8ehf35d80f7630f2ac5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0704060827l73aeb8ehf35d80f7630f2ac5@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
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


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> > thanks! I have stared at hrtimer.c a few more hours and the good 
> > news is that i found a narrow SMP race. The bad news is that i dont 
> > think it could explain your bug symptoms: the worst-case effect of 
> > the race should be an incorrect timeout on the current CPU - not a 
> > KTIME_MAX thing like your logs show.
> >
> > But maybe i didnt think through the effects of the bug well enough, 
> > and your box has a HT CPU, with HT CPUs being pretty good at 
> > triggering narrow SMP races - so maybe we are lucky? Fix attached 
> > below. Patch is build and boot-tested.
> 
> I didn't see this weird hang for 12 days. I think that this patch 
> solves this issue.

cool :)

> Huge thans!

huge thanks to you for testing it!

	Ingo
