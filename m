Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZHDLOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZHDLOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZHDLOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:14:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34181 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZHDLOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:14:24 -0400
Date: Tue, 4 Aug 2009 13:14:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Markus Metzger <markus.t.metzger@intel.com>, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
Message-ID: <20090804111412.GA20942@elte.hu>
References: <20090721155648.A17047@sedona.ch.intel.com> <1249381489.7924.186.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249381489.7924.186.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-07-21 at 15:56 +0200, Markus Metzger wrote:
> > Implement a performance counter with:
> >     attr.type           = PERF_TYPE_HARDWARE
> >     attr.config         = PERF_COUNT_HW_BRANCH_INSTRUCTIONS
> >     attr.sample_period  = 1
> > 
> > using branch trace store (BTS) on x86 hardware, if available.
> > 
> > The from and to address for each branch can be sampled using:
> >     PERF_SAMPLE_IP      for the from address
> >     PERF_SAMPLE_ADDR    for the to address
> > 
> 
> Over all looks very nice, some comments below (could be addressed 
> in a delta patch).

ok - thanks guys - i'll test this some and push it out into the 
perfcounters tree. Will apply the delta patch too once it's done.

Thanks,

	Ingo
