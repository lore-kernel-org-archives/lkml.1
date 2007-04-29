Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbXD2FcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbXD2FcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 01:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbXD2FcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 01:32:10 -0400
Received: from 1wt.eu ([62.212.114.60]:2326 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbXD2FcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 01:32:09 -0400
Date: Sun, 29 Apr 2007 07:30:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429053022.GB23638@1wt.eu>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177809512.9756.10.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Apr 29, 2007 at 03:18:32AM +0200, Kasper Sandberg wrote:
> Okay so i've tried with cfs 7 now, and the completely broken audio
> behavior is fixed.
> 
> The only things i really notice now is that gtk apps seems to redraw
> somewhat slower, and renicing X doesent seem to be able to bring it on
> par with SD or vanilla.
> 
> And smoothness just doesent match SD, it may be abit better than
> vanilla/staircase, i cant really definitively say, but SD just has the
> smoothness factor which is extremely attractive.

(...)

I don't know if Mike still has problems with SD, but there are now several
interesting reports of SD giving better feedback than CFS on real work. In
my experience, CFS seems smoother on *technical* tests, which I agree that
they do not really simulate real work.

I really think that if we merged SD in 2.6.22, at least we could focus
more on differences between it (which will become mainline) and CFS in
order to improve CFS for later inclusion when mature enough. Or maybe
only relevant parts of CFS will be merged into mainline later. But at
least, testers will not have to patch anymore to report feedback with
SD during -rc, and above all they would not compare anymore against
old-vanilla, thus reducing the number of tests.

Just my 2 cents,
Willy

