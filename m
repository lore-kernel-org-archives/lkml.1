Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbXKAPg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbXKAPg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbXKAPgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:36:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45388 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600AbXKAPgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:36:19 -0400
Date: Thu, 1 Nov 2007 16:36:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: aim7 -30% regression in 2.6.24-rc1
Message-ID: <20071101153607.GA9988@elte.hu>
References: <1193650626.3019.198.camel@ymzhang> <1193710325.3019.203.camel@ymzhang> <20071030072658.GB20372@elte.hu> <1193733390.3019.210.camel@ymzhang> <1193824668.3019.236.camel@ymzhang> <1193826639.27652.113.camel@twins> <20071101085824.GA12721@elte.hu> <1193922687.27652.279.camel@twins> <20071101150049.GB4044@elte.hu> <1193930983.27652.300.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193930983.27652.300.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > We don't have min_granularity anymore.
> > 
> > i think we should reintroduce it in the SCHED_DEBUG case and make it 
> > the main tunable item - sched_nr is a nice performance optimization 
> > but quite unintuitive as a tuning knob.
> 
> ok, I don't particularly care either way, could be because I wrote the 
> stuff :-)

heh :-) I've applied your patch, it looks good to me.

	Ingo
