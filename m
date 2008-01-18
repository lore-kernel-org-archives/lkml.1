Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbYARMFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbYARMFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYARMFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:05:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56622 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbYARMFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:05:01 -0500
Date: Fri, 18 Jan 2008 13:04:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: only call early_init_amd one time
Message-ID: <20080118120447.GC11044@elte.hu>
References: <200801180105.53434.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801180105.53434.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: only call early_init_amd one time
> 
> Andi's patch
> "
>     x86: move X86_FEATURE_CONSTANT_TSC into early cpu feature detection
> 
>     Need this in the next patch in time_init and that happens early.
> 
>     This includes a minor fix on i386 where early_intel_workarounds()
>     [which is now called early_init_intel] really executes early as
>     the comments say.
> "
> calling early_init_amd in early_identify_cpu and identify_cpu two times.
> 
> this patch remove the one in identify_cpu

thanks, applied.

	Ingo
