Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbXBELQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbXBELQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932085AbXBELQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:16:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbXBELQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:16:35 -0500
Date: Mon, 5 Feb 2007 11:22:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sunil Naidu <akula2.shark@gmail.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
Message-ID: <20070205102249.GA16652@elte.hu>
References: <20070205065636.GA1652@elte.hu> <8355959a0702050236k14aa8c98g29fdbac2c1370def@mail.gmail.com> <1170672153.4672.1.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170672153.4672.1.camel@twins>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4984]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > But here is an interesting dmesg:
> > 
> > rcu_boost_dat: idx=1 b=0 ul=0 ub=0 boost: a=0 b=0
> > rcu_boost_dat block:    0  0  0  0?
> > rcu_boost_dat boost:    0! 0  0  0?
> > rcu_boost_dat unlock:   0? 0  0  0?
> > 
> > I didn'tunderstand this with ? Am I missing anything here or please
> > give some inputs.
> 
> That is Paul McKenney's RCU priority boosting stuff.

yeah, those messages are diagnostic. You can turn them off by disabling 
CONFIG_PREEMPT_RCU_BOOST_STATS.

	Ingo
