Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbZAWNvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbZAWNvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZAWNvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:51:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbZAWNvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:51:44 -0500
Date: Fri, 23 Jan 2009 14:51:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] fix section mismatch warning in
	perf_counter.c::perf_counters_lapic_init()
Message-ID: <20090123135138.GB3102@elte.hu>
References: <1232716613.8750.15.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232716613.8750.15.camel@marge.simson.net>
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

> Fix section mismatch in perf_counter.c::perf_counters_lapic_init()
> 
> WARNING: arch/x86/kernel/built-in.o(.text+0xdd0f): Section mismatch in reference from the function pmc_generic_enable() to the function .cpuinit.text:perf_counters_lapic_init()
> The function pmc_generic_enable() references
> the function __cpuinit perf_counters_lapic_init().
> This is often because pmc_generic_enable lacks a __cpuinit
> annotation or the annotation of perf_counters_lapic_init is wrong.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> ---
>  arch/x86/kernel/cpu/perf_counter.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied tip/perfcounters/core, thanks Mike!

	Ingo
