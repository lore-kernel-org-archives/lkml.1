Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbXGRNAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbXGRNAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbXGRNAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:00:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbXGRNAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:00:36 -0400
Date: Wed, 18 Jul 2007 14:59:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070718125937.GA4099@elte.hu>
References: <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home> <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org> <1184754430.20032.130.camel@twins> <Pine.LNX.4.64.0707181442340.1817@scrub.home> <1184763148.20032.135.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184763148.20032.135.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2007-07-18 at 14:45 +0200, Roman Zippel wrote:
> > Hi,
> > 
> > On Wed, 18 Jul 2007, Peter Zijlstra wrote:
> > 
> > > I actually like the extra range, it allows for a much softer punch of
> > > background tasks even on somewhat slower boxen.
> > 
> > The extra range is not really a problem, in 
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0707.2/0850.html
> > 
> > I suggested how we can have both.
> 
> By breaking the UNIX model of nice levels. Not an option in my book.

yeah, that's pretty much out of question.

	Ingo
