Return-Path: <linux-kernel-owner+w=401wt.eu-S1031335AbXDRDp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031335AbXDRDp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031336AbXDRDp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:45:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:52609 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1031335AbXDRDp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:45:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+DtmsbrTCDRo/9OBU66iF8Iq7V53Z1our+sG/RSl
	ShDNE/wMsoungx
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Matt Mackall <mpm@selenic.com>, William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070418031511.GA18452@wotan.suse.de>
References: <46240F98.3020800@bigpond.net.au>
	 <1176776941.6222.21.camel@Homer.simpson.net>
	 <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au>
	 <20070417042954.GG25513@wotan.suse.de>
	 <20070417060955.GO8915@holomorphy.com>
	 <20070417061503.GC1057@wotan.suse.de>
	 <20070417062621.GL2986@holomorphy.com>
	 <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org>
	 <20070418031511.GA18452@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 05:45:20 +0200
Message-Id: <1176867920.6478.14.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 05:15 +0200, Nick Piggin wrote:
> On Tue, Apr 17, 2007 at 04:39:54PM -0500, Matt Mackall wrote:
> > 
> > I'm a big fan of fairness, but I think it's a bit early to declare it
> > a mandatory feature. Bounded unfairness is probably something we can
> > agree on, ie "if we decide to be unfair, no process suffers more than
> > a factor of x".
> 
> I don't know why this would be a useful feature (of course I'm talking
> about processes at the same nice level). One of the big problems with
> the current scheduler is that it is unfair in some corner cases. It
> works OK for most people, but when it breaks down it really hurts. At
> least if you start with a fair scheduler, you can alter priorities
> until it satisfies your need... with an unfair one your guess is as
> good as mine.
> 
> So on what basis would you allow unfairness? On the basis that it doesn't
> seem to harm anyone? It doesn't seem to harm testers?

Well, there's short term fair and long term fair.  Seems to me a burst
load having to always merge with a steady stream load using a short term
fairness yardstick absolutely must 'starve' relative to the steady load,
so to be long term fair, you have to add some short term unfairness.
The mainline scheduler is more long term fair (discounting the rather
obnoxious corner cases).

	-Mike

