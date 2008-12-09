Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYLILX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYLILX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYLILXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:23:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbYLILXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:23:00 -0500
Date: Tue, 9 Dec 2008 12:22:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       dada1@cosmosbay.com, robert.richter@amd.com, arjan@infradead.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       paulus@samba.org
Subject: Re: [patch] Performance Counters for Linux, v2
Message-ID: <20081209112225.GD21618@elte.hu>
References: <20081208012211.GA23106@elte.hu> <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com> <20081209110246.GC21618@elte.hu> <20081209.031120.90683825.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209.031120.90683825.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 9 Dec 2008 12:02:46 +0100
> 
> > 
> > * stephane eranian <eranian@googlemail.com> wrote:
> > 
> > > > There's also more generic x86 support: all 4 generic PMCs of Nehalem 
> > > > / Core i7 are supported - i've run 4 instances of KernelTop and they 
> > > > used up four separate PMCs.
> > >
> > > Core/Atom have 5 counters, Nehalem has 7. Why are you not using all of 
> > > them already?
> > 
> > no, Nehalem has 4 generic purpose PMCs and 3 fixed-purpose PMCs (7 
> > total),
>  ...
> > Saying that it has 7 is misleading.
> 
> Even you just did.

which portion of my point stressing the general purpose attribute was 
unclear to you?

Saying it has 7 is misleading in the same way as if i told you now: 
"look, i have four eyes!". (they are: left eye looking right, left eye 
looking left, right eye looking left and right eye looking right)

Nehalem has 4 general purpose PMCs, not 7. Yes, it has 7 counters but 
they are not all general purpose. The P4 has 18.

	Ingo
