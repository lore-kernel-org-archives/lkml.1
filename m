Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbXD2MLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbXD2MLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbXD2MLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:11:24 -0400
Received: from www.osadl.org ([213.239.205.134]:38000 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756418AbXD2MLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:11:23 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177848054.9756.30.camel@localhost>
References: <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu>
	 <1177842654.5791.85.camel@localhost.localdomain>
	 <20070429111159.GH23638@1wt.eu>  <1177848054.9756.30.camel@localhost>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 14:13:30 +0200
Message-Id: <1177848810.5791.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 14:00 +0200, Kasper Sandberg wrote:
> On Sun, 2007-04-29 at 13:11 +0200, Willy Tarreau wrote:
> > On Sun, Apr 29, 2007 at 12:30:54PM +0200, Thomas Gleixner wrote:
> <snip>
> > Contrarily to most people, I don't see them as competitors. I see SD as
> > a first step with a low risk of regression, and CFS as an ultimate
> > solution relying on a more solid framework.
> > 
> See this is the part i dont understand, what makes CFS the ultimate
> solution compared to SD?

SD is a one to one replacement of the existing scheduler guts - with a
different behaviour.

CFS is a huge step into a modular and hierarchical scheduler design,
which allows more than just implementing a clever scheduler for a single
purpose. In a hierarchical scheduler you can implement resource
management and other fancy things, in the monolitic design of the
current scheduler (and it's proposed replacement SD) you can't. But SD
can be made one of the modular variants.

	tglx


