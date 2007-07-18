Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbXGRKlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbXGRKlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXGRKlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:41:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbXGRKlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:41:10 -0400
Date: Wed, 18 Jul 2007 12:40:01 +0200
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
Message-ID: <20070718104001.GA2801@elte.hu>
References: <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home> <20070716203117.GC11166@waste.org> <20070716211851.GB18661@elte.hu> <Pine.LNX.4.64.0707162351030.1817@scrub.home> <20070716222909.GA30906@elte.hu> <Pine.LNX.4.64.0707170047230.1817@scrub.home> <Pine.LNX.4.64.0707170437110.1818@scrub.home> <20070717080230.GC13539@elte.hu> <Pine.LNX.4.64.0707171324110.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707171324110.1817@scrub.home>
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

> On Tue, 17 Jul 2007, Ingo Molnar wrote:
> 
> > Roman, please do me a favor, and ask me the following question:
> > 
> >  " Ingo, you've been maintaining the scheduler for years. In fact you 
> >    wrote the old nice code we are talking about here. You changed it a
> >    number of times since then. So you really know what's going on here. 
> >    Why does the old nice code behave like that for nice +19 levels? "
> > 
> > I've been waiting for that obvious question, and i _might_ be able 
> > to answer it, but somehow it never occured to you ;-) Thanks,

[...]
> It's obvious that you have more experience with the scheduler code, 
> but does that make you unfailable? [...]

Roman, it is really not about 'experience', and yes, we all make 
frequent mistakes.

it's about the plain fact that i happened to write _both_ the old and 
the new code you were talking about all along. In this discussion about 
nice levels you were (very) agressively asserting things that were 
untrue, you were suggesting that i dont understand the code, instead of 
simply asking me why the code was written in such a way and what the 
motivation behind it was. I'd be glad to attempt to answer such a 
friendly question, if you are interested in asking it and if you are 
interested in my answer. Thanks,

	Ingo
