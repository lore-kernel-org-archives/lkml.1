Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbXGQIDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbXGQIDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXGQIDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:03:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39258 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbXGQIDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:03:14 -0400
Date: Tue, 17 Jul 2007 10:02:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070717080230.GC13539@elte.hu>
References: <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home> <20070716203117.GC11166@waste.org> <20070716211851.GB18661@elte.hu> <Pine.LNX.4.64.0707162351030.1817@scrub.home> <20070716222909.GA30906@elte.hu> <Pine.LNX.4.64.0707170047230.1817@scrub.home> <Pine.LNX.4.64.0707170437110.1818@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707170437110.1818@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Nice level 19 shows the largest artifacts, as that level only gets a 
> single tick, so the ratio is often 1:HZ/10 (except for 1000HZ where 
> it's 5:100). [...]

Roman, please do me a favor, and ask me the following question:

 " Ingo, you've been maintaining the scheduler for years. In fact you 
   wrote the old nice code we are talking about here. You changed it a
   number of times since then. So you really know what's going on here. 
   Why does the old nice code behave like that for nice +19 levels? "

I've been waiting for that obvious question, and i _might_ be able to 
answer it, but somehow it never occured to you ;-) Thanks,

	Ingo
