Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZFTKc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZFTKc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 06:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZFTKcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 06:32:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZFTKcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 06:32:19 -0400
Date: Sat, 20 Jun 2009 12:32:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software
	counters on 32-bit powerpc
Message-ID: <20090620103206.GA13814@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <20090617142151.GB6846@elte.hu> <8C6954A9-BE4C-47F5-AD87-A1D0EAF43F8A@kernel.crashing.org> <20090617142719.GC6846@elte.hu> <1245366204.8693.11.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245366204.8693.11.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2009-06-17 at 16:27 +0200, Ingo Molnar wrote:
> > I think it would be nice to have more platform support in .31. 
> > Perfcounters is a brand-new feature so there's no risk of 
> > regression. In the end it will depend on Linus to pull of course, 
> > and BenH can veto it too if he'd like no more PowerPC changes in 
> > this cycle. Worst-case it's all .32 material.
> 
> There have been little PowerPC changes in this cycle and I agree 
> with you on that it's a nice feature to have with little risk of 
> regression.

Ok - thanks - i'll push it to Linus probably later today.

> In fact, I also have an up-to-date (and hopefully working) 
> irqtrace/lockdep patch for 32-bit powerpc (we only do 64-bit right 
> now) that I'm considering merging this time around, the benefit it 
> brings is worth the risk I believe.

Nice :-)

	Ingo
