Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbZDBD1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbZDBD1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZDBD1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:27:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59179 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZDBD1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:27:32 -0400
Date: Thu, 2 Apr 2009 05:25:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, grundler@parisc-linux.org,
       takata@linux-m32r.org, benh@kernel.crashing.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090402032506.GC21545@elte.hu>
References: <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <20090401225754.GN8014@parisc-linux.org> <20090402021024.GA26446@elte.hu> <alpine.DEB.1.10.0904012219300.32656@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904012219300.32656@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> > A sub-sub argument was that perhaps we should not split .data 
> > and .bss variables into separate sections - it doubles the 
> > chance of false cacheline sharing and spreads the cacheline 
> > footprint.
> 
> False cacheline sharing is something normal that comes with the 
> cpu caching schemes. As long as there is no significant impact on 
> performance we are fine with it. Extensive measures to avoid false 
> cacheline sharing on unimportant variables increases the cache 
> footprint of code.

You didnt really answer to my suggestion(s) though. You only stated 
that:

   "problem XYZ is something normal that comes with the cpu caching 
    schemes. As long as there is no significant impact on 
    performance weare fine with it."

Which i'd proffer is true for any given value of XYZ ;-)

	Ingo
