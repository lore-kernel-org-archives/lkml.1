Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbYFFPX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbYFFPX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758160AbYFFPXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:23:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677AbYFFPXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:23:49 -0400
Date: Fri, 6 Jun 2008 17:23:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606152326.GA18359@elte.hu>
References: <20080606115759.GA29321@elte.hu> <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com> <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com> <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com> <484947A9.5050804@sgi.com> <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com> <20080606145717.GA5300@elte.hu> <20080606150102.GA14141@elte.hu> <19f34abd0806060813t10d422fel10dcb25c71f3b032@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806060813t10d422fel10dcb25c71f3b032@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >> AFAICS this is not yet required for v2.6.26, as the requirement to 
> >> never iterate to MAX_NUMNODES and call nr_cpus_node() with the 
> >> index only got introduced by Mike's patch.
> >
> > the one below is needed as well i think.
> 
> Yeah. I think you had better take Mike's patches, I don't trust even 
> that my patch and your fixlet does everything correctly.

yep, just discovered that we had them already ;-)

Thomas has just scripted up a new "detect if a commit is not in 
linux-next yet" script that should avoid such problems in the future.

your second patch is still wanted, it would have detected the problem 
earlier.

	Ingo
