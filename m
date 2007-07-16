Return-Path: <linux-kernel-owner+w=401wt.eu-S1764323AbXGPL7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764323AbXGPL7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbXGPL6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:58:53 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1440 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbXGPL6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:58:52 -0400
Date: Mon, 16 Jul 2007 13:58:36 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: James Bruce <bruce@andrew.cmu.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070716112037.GA6895@elte.hu>
Message-ID: <Pine.LNX.4.64.0707161331570.1817@scrub.home>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos>
 <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu>
 <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> > As soon as you add another loop the difference changes again, while 
> > it's always correct to say it gets 25% more cpu time [...]
> 
> yep, and i'll add the relative effect to the comment too.

Why did you cut off the rest of the sentence?
To illustrate the problem a little different: a task with a nice level -20 
got around 700% more cpu time (or 8 times more), now it gets 8500% more 
cpu time (or 86.7 times more).
You don't think that change to the nice levels is a little drastic?

bye, Roman
