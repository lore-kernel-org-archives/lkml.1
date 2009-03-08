Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZCHVAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZCHVAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZCHVAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:00:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:35527 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbZCHVAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:00:06 -0400
Subject: Re: [tip:perfcounters/core] x86: perf_counter cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e255357764f92afcafafbd4879b222b8c752065a@git.kernel.org>
References: <tip-e255357764f92afcafafbd4879b222b8c752065a@git.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 08 Mar 2009 21:59:08 +0100
Message-Id: <1236545948.22914.3648.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 15:52 +0000, Jaswinder Singh Rajput wrote:
> Commit-ID:  e255357764f92afcafafbd4879b222b8c752065a
> Gitweb:     http://git.kernel.org/tip/e255357764f92afcafafbd4879b222b8c752065a
> Author:     "Jaswinder Singh Rajput" <jaswinder@kernel.org>
> AuthorDate: Sun, 8 Mar 2009 17:09:49 +0530
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 8 Mar 2009 16:26:50 +0100
> 
> x86: perf_counter cleanup
> 
> Remove unused variables and duplicate header file.

Why did you commit this?

Until someone from AMD steps up and either tells us they're going to be
48bits _ALWAYS_ or that it's impossible to detect dynamically, I'd
rather try and get the dynamic thing working.

> Signed-off-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/cpu/perf_counter.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 1df4210..155bc3c 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -17,7 +17,6 @@
>  #include <linux/kdebug.h>
>  #include <linux/sched.h>
>  
> -#include <asm/perf_counter.h>
>  #include <asm/apic.h>
>  
>  static bool perf_counters_initialized __read_mostly;
> @@ -954,9 +953,6 @@ static struct pmc_x86_ops *pmc_intel_init(void)
>  
>  static struct pmc_x86_ops *pmc_amd_init(void)
>  {
> -	u64 old;
> -	int bits;
> -
>  	nr_counters_generic = 4;
>  	nr_counters_fixed = 0;
>  	counter_value_mask = 0x0000FFFFFFFFFFFFULL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
