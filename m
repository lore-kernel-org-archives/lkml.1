Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXD0NrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXD0NrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbXD0NrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:47:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXD0NrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:47:01 -0400
Date: Fri, 27 Apr 2007 15:45:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070427134541.GA26550@elte.hu>
References: <20070425214704.GA32572@elte.hu> <4631F854.20207@rtr.ca> <4631F924.4080207@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4631F924.4080207@rtr.ca>
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


* Mark Lord <lkml@rtr.ca> wrote:

> > You've really outdone yourself this time!
> >
> > 2.6.21 + CFS-v6, plus the futex PI fix patch posted later, just 
> > absolutely rocks here!
> >
> > I'm having a very difficult time finding any fault with it,
> > and it has now displaced the stock scheduler as my default
> > and personal favourite.
> >
> > The KDE (Dapper Drake) desktop is smooth under 100% CPU load, mp3's 
> > play without glitches, and everything is just *so* responsive.
> 
> Oh, and all of this is *without* renicing X11, even with "make -j2" 
> happening on the kernel tree.

cool! :) Regarding renicing: all people so far who tried reniced and 
non-reniced X say both work fine under CFS, so i've disabled the option 
by default in the Kconfig.

	Ingo
