Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYLLLFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYLLLFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYLLLF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:05:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbYLLLF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:05:28 -0500
Date: Fri, 12 Dec 2008 12:05:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: hardirq: introduce inc_irq_stat()
Message-ID: <20081212110519.GD32640@elte.hu>
References: <493DE3BE.9070202@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493DE3BE.9070202@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> Introduce inc_irq_stat() macro and unify irq_stat accounting code.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/include/asm/hardirq_32.h  |    2 ++
>  arch/x86/include/asm/hardirq_64.h  |    2 ++
>  arch/x86/kernel/apic.c             |   13 +++----------
>  arch/x86/kernel/cpu/perf_counter.c |    6 +-----
>  arch/x86/kernel/smp.c              |   18 +++---------------
>  arch/x86/kernel/traps.c            |    6 +-----
>  6 files changed, 12 insertions(+), 35 deletions(-)

applied to tip/x86/irq, thanks!

This is a very nice cleanup - those #ifdefs were very ugly.

	Ingo
