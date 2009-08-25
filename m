Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZHYI0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZHYI0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZHYI0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:26:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46191 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZHYI0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:26:30 -0400
Date: Tue, 25 Aug 2009 10:26:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090825082612.GA17692@elte.hu>
References: <20090814134811.013873340@de.ibm.com> <tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org> <20090822103252.GA32369@elte.hu> <20090822171540.1220f50d@skybase> <20090822153346.GA3313@elte.hu> <19088.47213.327897.703458@cargo.ozlabs.ibm.com> <20090823084740.GA7651@elte.hu> <19090.1800.521794.839576@cargo.ozlabs.ibm.com> <20090824082318.GD2424@elte.hu> <19091.24374.210127.155521@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19091.24374.210127.155521@drongo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> > I actually start regretting that i do rebases too frequently - 
> > some people (not you really, but you gave me the perfect example 
> > to reply to) want more and seem to think they are _entitled_ to 
> > rebases and are entitled to backmerges. The thing is, rebases 
> > are not free. They are risky and error-prone, and they destroy 
> > Git history.
> 
> To be honest, I didn't think I was asking for a rebase of 
> something which was already cast in stone, since I didn't think 
> you would have cast a commit in stone before doing a build test on 
> powerpc.

I think there's a fundamental disconnect with reality here.

The thing is, as the maintainer of certain core kernel subsystems i 
_have to_ mirror and honor the system usage and hardware preferences 
of developers, testers and users. Those are predominantly x86 based 
currently. I cross-test to a lot of architectures because i'm nice 
but in practice it rarely matters.

(It goes beyond that btw: i try to test more common drivers within 
x86 too, etc.)

If you want to change that reality you can do it the old fashioned, 
fair way: build cool hardware, send more SDVs to kernel developers, 
make PowerPC more widely used, etc.

If i put more effort into testing what nobody uses i'd be doing a 
disservice to Linux - i'd disproportionately favor PowerPC just 
because you are a squeakier wheel.

I.e. please _earn_ your usage share, dont try to dicate it 
artificially ... It does not work the other way, you cannot force in 
the kernel space what PowerPC did not manage to achieve in the 
marketplace.

If you suggest that each and every subsystem maintainer who touches 
code that can be built on non-x86 architectures has to cross-build 
to 20+ architectures to be able to push out a tree, all the time, 
and has to rebase if this ever gets omitted, you are really defying 
reality and are hurting Linux.

	Ingo
