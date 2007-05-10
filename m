Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbXEJUFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbXEJUFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXEJUFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:05:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbXEJUFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:05:08 -0400
Date: Thu, 10 May 2007 22:05:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian <christiand59@web.de>
Cc: linux-kernel@vger.kernel.org, Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: [patch] CFS scheduler, -v11
Message-ID: <20070510200500.GB18741@elte.hu>
References: <20070508150431.GA26977@elte.hu> <200705101859.11696.christiand59@web.de> <1178817044.25266.8.camel@localhost> <200705102051.09432.christiand59@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705102051.09432.christiand59@web.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian <christiand59@web.de> wrote:

> > > Desktop performance without any manual renicing is excellent, even 
> > > with make -j20. Gaming performance is at least on par with SD now! 
> > > I've tried to
> >
> > Which games are you trying? and have you tried other workloads then 
> > make -j20?
> >
> > try have a window with some 3d game open, and a browser besides it, 
> > and press a link. i cant seem to get smooth results with CFS.
[...]
> 
> I've tried many different workloads, kernel compile (normal -j4), 
> extreme kernel compile (-j20) and Browsing/Open Office. GLXGears, 
> Briquolo and enemy-territory work relly well under these loads.

do you have CONFIG_PREEMPT enabled - while perhaps Kasper has it 
disabled? Kasper, if so, could you try a quick test with CONFIG_PREEMPT 
enabled, does that make any difference to your gaming-smoothness 
results? [it's not a real solution, but this would help us narrow down 
the smoothness problem you are seeing.]

	Ingo
