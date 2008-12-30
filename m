Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYL3HWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYL3HWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYL3HVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:21:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYL3HVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:21:48 -0500
Date: Tue, 30 Dec 2008 08:21:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, a.p.zijlstra@chello.nl,
       emil.s.tantilov@intel.com, jeffrey.t.kirsher@intel.com,
       netdev@vger.kernel.org, peter.p.waskiewicz.jr@intel.com,
       alexander.h.duyck@intel.com, dada1@cosmosbay.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] locking, percpu counters: introduce separate lock
	classes
Message-ID: <20081230072125.GB20225@elte.hu>
References: <20081230060536.GG11037@elte.hu> <20081229.223945.149941966.davem@davemloft.net> <20081230065650.GD30975@elte.hu> <20081229.230438.90548187.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229.230438.90548187.davem@davemloft.net>
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
> Date: Tue, 30 Dec 2008 07:56:50 +0100
> 
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> > > From: Ingo Molnar <mingo@elte.hu>
> > > Date: Tue, 30 Dec 2008 07:05:36 +0100
> > > 
> > > > One small nit: could you please add the Reported-by line for Jeff Kirscher 
> > > > who reported the problem originally:
> > > > 
> > > >  Reported-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > > 
> > > I'll make sure to add that to the commit message after
> > > you successfully test Herbert's patch.
> > > 
> > > Thanks.
> > 
> > early indications are good: after about 15 random bootup tests the lockdep 
> > warning has not triggered. (it would trigger on every 2nd kernel before 
> > that - there's a 66% chance for lockdep to be enabled in my randconfig 
> > tests)
> 
> Sounds good.  I'll toss this into my net-2.6 tree, with Jeff's 
> reported-by and your Tested-by, and send this off to Linus tonight.

cool. If by tonight you dont get a followup mail from me then you can 
assume that the patch passed hundreds of tests here.

	Ingo
