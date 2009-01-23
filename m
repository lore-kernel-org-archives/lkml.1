Return-Path: <linux-kernel-owner+w=401wt.eu-S1760361AbZAWNvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361AbZAWNvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZAWNux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:50:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZAWNux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:50:53 -0500
Date: Fri, 23 Jan 2009 14:50:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] ratelimit performance counter interrupts
Message-ID: <20090123135040.GA3102@elte.hu>
References: <1232716030.8750.11.camel@marge.simson.net> <b9df5fa10901230532v57acec78qe949c44c4be2fbd9@mail.gmail.com> <1232717776.8978.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232717776.8978.2.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2009-01-23 at 19:32 +0600, Rakib Mullick wrote:
> > On 1/23/09, Mike Galbraith <efault@gmx.de> wrote:
> > 
> > >  + * Mamimum interrupt frequency of 100KHz per CPU
> > >  + */
> > 
> > Hi Mike, I think you misspelled the word Maximum here.
> 
> Yup, thanks.
> 
> Ratelimit performance counter interrupts to 100KHz per CPU.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> ---
>  arch/x86/kernel/apic.c             |    2 +
>  arch/x86/kernel/cpu/perf_counter.c |   43 ++++++++++++++++++++++++++++++-------
>  include/linux/perf_counter.h       |    2 +
>  3 files changed, 40 insertions(+), 7 deletions(-)

Applied to tip/perfcounters/core, thanks Mike!

	Ingo
