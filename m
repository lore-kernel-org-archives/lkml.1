Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZHYIsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZHYIsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZHYIsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:48:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47355 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZHYIsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:48:16 -0400
Date: Tue, 25 Aug 2009 10:48:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory (f6f6e1a4), by kmemleak's scan_block()
Message-ID: <20090825084808.GA14003@elte.hu>
References: <20090825071959.GA25877@elte.hu> <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com> <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251189914.7261.11.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, 2009-08-25 at 10:32 +0200, Ingo Molnar wrote:
> > > In any case, I don't think it is very productive to run them both 
> > > at the same time, simply because kmemcheck slows every memory 
> > > access down so much and scanning memory doesn't exactly help that. 
> > > It _could_ be useful to have them compiled into the same kernel, 
> > > though, e.g. a distro "-debug" kernel.
> > > 
> > > Maybe you can just add the "depends on !KMEMLEAK" to 
> > > CONFIG_KMEMCHECK in tip/out-of-tree for now?
> > 
> > i think it would be far more intelligent to annotate those accesses 
> > by kmemleak as 'trust me, dont check'. Willing to test such a patch.
> 
> I guess something like this totally untested patch should do it. 
> Vegard, Catalin?

Looks good - but doesnt apply cleanly to -tip because i picked up a 
number of kmemleak patches into tip:out-of-tree for testing - so 
i'll leave it up for Vegard/Catalin to do a blessed version of it 
against the kmemleak tree - which i hope will apply fine to tip too
:)

	Ingo
