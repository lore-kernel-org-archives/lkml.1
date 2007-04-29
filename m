Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbXD2L5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbXD2L5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbXD2L5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:57:10 -0400
Received: from www.osadl.org ([213.239.205.134]:51144 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756389AbXD2L5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 07:57:06 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070429111159.GH23638@1wt.eu>
References: <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu>
	 <1177842654.5791.85.camel@localhost.localdomain>
	 <20070429111159.GH23638@1wt.eu>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 13:59:13 +0200
Message-Id: <1177847954.5791.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 13:11 +0200, Willy Tarreau wrote:
> > As a sidenote: I really wonder if anybody noticed yet, that the whole
> > CFS / SD comparison is so ridiculous, that it is not even funny anymore.
> 
> Contrarily to most people, I don't see them as competitors. I see SD as
> a first step with a low risk of regression, and CFS as an ultimate
> solution relying on a more solid framework.

That's the whole reason why I don't see any usefulness in merging SD
now. When we merge SD now, then we need to care of both - the real
solution and the fixup of regressions. Right now we have a not perfect
scheduler with known weak points. Ripping it out and replacing it is
going to introduce regressions, what ever low risk you see.

And I still do not see a benefit of an intermediate step with a in my
opinion medium to high risk of regressions, instead of going the full
way, when we agree that this is the correct solution.

	tglx


