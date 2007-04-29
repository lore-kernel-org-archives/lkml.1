Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbXD2Nf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbXD2Nf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 09:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbXD2Nf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 09:35:58 -0400
Received: from www.osadl.org ([213.239.205.134]:33469 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756471AbXD2Nfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 09:35:42 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070429125522.GB31925@holomorphy.com>
References: <20070427115526.GA7699@elte.hu>
	 <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost>
	 <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu>
	 <20070429071627.GC23638@1wt.eu>
	 <1177842654.5791.85.camel@localhost.localdomain>
	 <20070429111159.GH23638@1wt.eu> <1177848054.9756.30.camel@localhost>
	 <1177848810.5791.104.camel@localhost.localdomain>
	 <20070429125522.GB31925@holomorphy.com>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 15:37:47 +0200
Message-Id: <1177853867.5791.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 05:55 -0700, William Lee Irwin III wrote:
> You'll also hit the same holes should you attempt to write such a
> modularity patch for mainline as opposed to porting current mainline to
> the driver API as-given. It takes a bit more work to get something that
> actually works for all this, and it borders on disingenuity to
> suggest that the scheduler class/driver API as it now stands is
> capable of any such thing as porting current mainline, nicksched, or SD
> to it without significant code impact to the core scheduler code.

I never said, that the current implementation of CFS fits the criteria
of modularity, but it is a step in that direction. I'm well aware that
there is a bunch of things missing and it has hard coded leftovers,
which are related to the current two hard coded policy classes.

> So on both these points, I don't see cfs as being adequate as it now
> stands for a modular, hierarchical scheduler design. If we want a truly
> modular and hierarchical scheduler design, I'd suggest pursuing it
> directly and independently of policy, and furthermore considering the
> representability of various policies in the scheduling class/driver API
> as a test of its adequacy.

Ack. I don't worry much whether the CFS policy is better than the SD
one. I'm all for a truly modular design. SD and SCHED_FAIR are good
proofs for it.

	tglx


