Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXD2M1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXD2M1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbXD2M1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:27:35 -0400
Received: from 1wt.eu ([62.212.114.60]:2419 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106AbXD2M1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:27:35 -0400
Date: Sun, 29 Apr 2007 14:25:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429122551.GI23638@1wt.eu>
References: <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain> <20070429111159.GH23638@1wt.eu> <1177847954.5791.98.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177847954.5791.98.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 01:59:13PM +0200, Thomas Gleixner wrote:
> On Sun, 2007-04-29 at 13:11 +0200, Willy Tarreau wrote:
> > > As a sidenote: I really wonder if anybody noticed yet, that the whole
> > > CFS / SD comparison is so ridiculous, that it is not even funny anymore.
> > 
> > Contrarily to most people, I don't see them as competitors. I see SD as
> > a first step with a low risk of regression, and CFS as an ultimate
> > solution relying on a more solid framework.
> 
> That's the whole reason why I don't see any usefulness in merging SD
> now. When we merge SD now, then we need to care of both - the real
> solution and the fixup of regressions. Right now we have a not perfect
> scheduler with known weak points. Ripping it out and replacing it is
> going to introduce regressions, what ever low risk you see.

Of course, but that's also the purpose of -rc. And given its small
footprint, it will be as easy to revert it as to apply it, should any
big problem appear.

> And I still do not see a benefit of an intermediate step with a in my
> opinion medium to high risk of regressions, instead of going the full
> way, when we agree that this is the correct solution.

The only difference is the time to get it in the right shape. If it
requires 3 versions (6 months), it may be worth "upgrading" the current
scheduler to make users happy. I'm not kidding, I've switched the default
boot to 2.6 on my notebook after trying SD and CFS. It was the first time
I got my system in 2.6 at least as usable as in 2.4. And I know I'm not
the only one.

Willy

