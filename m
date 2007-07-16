Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbXGPRsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbXGPRsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXGPRsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:48:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbXGPRsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:48:21 -0400
Date: Mon, 16 Jul 2007 10:47:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Ingo Molnar <mingo@elte.hu>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <Pine.LNX.4.64.0707161331570.1817@scrub.home>
Message-ID: <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos>
 <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu>
 <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Jul 2007, Roman Zippel wrote:
>
> To illustrate the problem a little different: a task with a nice level -20 
> got around 700% more cpu time (or 8 times more), now it gets 8500% more 
> cpu time (or 86.7 times more).

Ingo, that _does_ sound excessive. 

How about trying a much less aggressive nice-level (and preferably linear, 
not exponential)?

		Linus
