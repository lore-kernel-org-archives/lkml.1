Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXD2IL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXD2IL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXD2IL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:11:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:49353 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932837AbXD2ILY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:11:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+XtqchkcyXUmf8XvEhk5Me6r2ktJedOy3YctuZTL
	7zpn//MO6Zbkow
Subject: Re: [patch] CFS scheduler, -v6
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070429071627.GC23638@1wt.eu>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu>  <20070429071627.GC23638@1wt.eu>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 10:11:17 +0200
Message-Id: <1177834277.6264.44.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 09:16 +0200, Willy Tarreau wrote:

> In fact, what I'd like to see in 2.6.22 is something better for everybody
> and with *no* regression, even if it's not perfect. I had the feeling
> that SD matched that goal right now, except for Mike who has not tested
> recent versions. Don't get me wrong, I still think that CFS is a more
> interesting long-term target.

While I haven't tested recent SD versions, unless it's design has
radically changed recently, I know what to expect.  CFS is giving me a
very high quality experience already (it's at a whopping v7), while
RSDL/SD irritated me greatly at version v40.  As far as I'm concerned,
CFS is the superior target, short-term, long-term whatever-term.  For
the tree where I make the decisions, the hammer has fallen, and RSDL/SD
is history.  Heck, I'm _almost_ ready to rm -rf my own scheduler trees
as well... I could really use some free disk space.

	-Mike

