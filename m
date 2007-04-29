Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXD2MVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXD2MVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbXD2MVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:21:41 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52325 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbXD2MVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:21:40 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Kasper Sandberg <lkml@metanurb.dk>
To: tglx@linutronix.de
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177848810.5791.104.camel@localhost.localdomain>
References: <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu>
	 <1177842654.5791.85.camel@localhost.localdomain>
	 <20070429111159.GH23638@1wt.eu>  <1177848054.9756.30.camel@localhost>
	 <1177848810.5791.104.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 14:21:09 +0200
Message-Id: <1177849269.9756.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 14:13 +0200, Thomas Gleixner wrote:
> On Sun, 2007-04-29 at 14:00 +0200, Kasper Sandberg wrote:
> > On Sun, 2007-04-29 at 13:11 +0200, Willy Tarreau wrote:
> > > On Sun, Apr 29, 2007 at 12:30:54PM +0200, Thomas Gleixner wrote:
> > <snip>
> > > Contrarily to most people, I don't see them as competitors. I see SD as
> > > a first step with a low risk of regression, and CFS as an ultimate
> > > solution relying on a more solid framework.
> > > 
> > See this is the part i dont understand, what makes CFS the ultimate
> > solution compared to SD?
> 
> SD is a one to one replacement of the existing scheduler guts - with a
> different behaviour.
> 
> CFS is a huge step into a modular and hierarchical scheduler design,
> which allows more than just implementing a clever scheduler for a single
> purpose. In a hierarchical scheduler you can implement resource
> management and other fancy things, in the monolitic design of the
> current scheduler (and it's proposed replacement SD) you can't. But SD
> can be made one of the modular variants.
But all these things, arent they just in the modular scheduler policy
code? and not the actual sched_cfs one?

> 
> 	tglx
> 
> 
> 

