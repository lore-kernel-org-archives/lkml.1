Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZAFM2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZAFM2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZAFM2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:28:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57075 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZAFM2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:28:32 -0500
Date: Tue, 6 Jan 2009 13:28:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix x86_32 builds for summit and es7000 arch's
Message-ID: <20090106122820.GA10319@elte.hu>
References: <49629225.1030104@sun.com> <4962A756.2070507@sgi.com> <4962AF55.9060704@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4962AF55.9060704@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Mike Travis wrote:
> > Yinghai Lu wrote:
> >> In file included from arch/x86/mach-generic/summit.c:16:
> >> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:
> >> In function Ã¢â‚¬Ëœcpu_mask_to_apicid_andÃ¢â‚¬â„¢:
> >> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
> >> error: Ã¢â‚¬ËœGFP_ATOMICÃ¢â‚¬â„¢ undeclared (first use in this function)
> >> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
> >> error: (Each undeclared identifier is reported only once
> >> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
> >> error: for each function it appears in.)
> >>
> >> YH
> >>
> > 
> > Hi Yinghai,
> > 
> > Thanks for catching this, I'm looking at it now.  We had a bit of a power
> > problem here and have been down for a while.
> > 
> > Thanks,
> > Mike
> 
> Subject: x86: fix x86_32 builds for summit and es7000 arch's
> 
> Impact: fix build errors on x86_32
>
> Fix the following build errors reported by Yinghai Lu:

applied to tip/cpus4096, thanks guys!

	Ingo
