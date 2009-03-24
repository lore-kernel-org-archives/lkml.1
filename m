Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbZCXUzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbZCXUzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZCXUzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:55:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZCXUzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:55:15 -0400
Date: Tue, 24 Mar 2009 21:54:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324205444.GA11693@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au> <20090324153616.GA31143@elte.hu> <20090324154717.GA7506@elte.hu> <20090324155911.GA30824@gondor.apana.org.au> <20090324160241.GA11060@elte.hu> <20090324191900.GA24595@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324191900.GA24595@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Same forcedeth box i reported before. Config below. (note: if 
> > you want to use it you need to run it through 'make oldconfig', 
> > with all defaults accepted)
> 
> Hm, i just had a test failure (hung interface) with this too.
> 
> I'll go back to the original straight revert of "303c6a0: gro: Fix 
> legacy path napi_complete crash", and will test it overnight - to 
> establish a baseline of stability again. (to make sure there are 
> no other bugs interacting)

FYI, this plain revert is holding up fine in my tests so far - 50 
random iterations - the previous one failed after 5 iterations.

	Ingo
