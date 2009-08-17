Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbZHQV2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbZHQV2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZHQV2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:28:05 -0400
Received: from www.tglx.de ([62.245.132.106]:55794 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZHQV2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:28:04 -0400
Date: Mon, 17 Aug 2009 23:27:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [patch] clockevents_notify() need to be called with irq's
 enabled
In-Reply-To: <1250544150.2709.197.camel@sbs-t61.sc.intel.com>
Message-ID: <alpine.LFD.2.00.0908172325380.2782@localhost.localdomain>
References: <1250203681.27006.10842.camel@localhost.localdomain>  <alpine.LFD.2.00.0908140753370.1283@localhost.localdomain>  <1250234778.2965.8.camel@sbs-t61>  <alpine.LFD.2.00.0908141025290.1283@localhost.localdomain>  <1250271593.3077.8.camel@sbs-t61.sc.intel.com>
  <alpine.LFD.2.00.0908142159480.1283@localhost.localdomain> <1250544150.2709.197.camel@sbs-t61.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh,

On Mon, 17 Aug 2009, Suresh Siddha wrote:

> --- tip.orig/arch/x86/kernel/process.c
> +++ tip/arch/x86/kernel/process.c
> @@ -508,17 +508,10 @@ static void c1e_idle(void)
>  
>  		if (!cpumask_test_cpu(cpu, c1e_mask)) {
>  			cpumask_set_cpu(cpu, c1e_mask);
> -			/*
> -			 * Force broadcast so ACPI can not interfere. Needs
> -			 * to run with interrupts enabled as it uses
> -			 * smp_function_call.
> -			 */

Please keep the first sentence of the comment intact. Everything else
looks fine.

Thanks,

	tglx

