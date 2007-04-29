Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbXD2HjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbXD2HjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbXD2HjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:39:22 -0400
Received: from 1wt.eu ([62.212.114.60]:2360 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbXD2HjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:39:21 -0400
Date: Sun, 29 Apr 2007 09:38:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429073819.GD23638@1wt.eu>
References: <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <20070429073030.GA5253@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429073030.GA5253@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 09:30:30AM +0200, Ingo Molnar wrote:
> > In fact, what I'd like to see in 2.6.22 is something better for 
> > everybody and with *no* regression, even if it's not perfect.
> >
> > I had the feeling that SD matched that goal right now, [...]
> 
> curious, which are the reports where in your opinion CFS behaves worse 
> than vanilla?

see below :-)

> There were two audio skipping reports against CFS, the 
> most serious one got resolved and i hope the other one has been resolved 
> by the same fix as well. (i'm still waiting for feedback on that one)

your answer to your question above ;-)
Yes, we're all waiting for feedback. And I said I did not track the
versions involved, so it is possible that all previously encountered
regressions are fixed by now.

> > [...] except for Mike who has not tested recent versions. [...]
> 
> actually, dont discount Mark Lord's test results either. And it might be 
> a good idea for Mike to re-test SD 0.46?

In any case, it might be a good idea because Mike encountered a problem
that nobody could reproduce. It may come from hardware, scheduler design,
scheduler bug, or any other bug, but whatever the cause, it would be
interesting to conclude on it.

> 	Ingo

Willy

