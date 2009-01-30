Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZA3OWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZA3OWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbZA3OWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:22:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41946 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbZA3OWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:22:37 -0500
Date: Fri, 30 Jan 2009 15:22:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: seperate
	default_send_IPI_mask_sequence/allbutself with logical
Message-ID: <20090130142222.GC22848@elte.hu>
References: <49827414.2020908@kernel.org> <498274A5.8010805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498274A5.8010805@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: 32bit should logical version
> 
> there are two version: for default_send_IPI_mask_sequence/allbutself
> one in ipi.h and one in ipi.c for 32bit
> 
> it seems .h version overwrite ipi.c for a while.
> 
> restore it so 32 bit could use it's old logical version.
> also remove dupicated functions in .c
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/ipi.h        |   71 ++++++++++++++++---
>  arch/x86/kernel/bigsmp_32.c       |    8 --
>  arch/x86/kernel/es7000_32.c       |    4 -
>  arch/x86/kernel/genapic_flat_64.c |    6 -
>  arch/x86/kernel/ipi.c             |  139 --------------------------------------
>  arch/x86/kernel/numaq_32.c        |    8 --
>  arch/x86/kernel/probe_32.c        |    4 -
>  arch/x86/kernel/summit_32.c       |    6 -
>  8 files changed, 77 insertions(+), 169 deletions(-)

Applied to tip/x86/apic, thanks!

	Ingo
