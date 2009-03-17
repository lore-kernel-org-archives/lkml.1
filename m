Return-Path: <linux-kernel-owner+w=401wt.eu-S1762946AbZCQIaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946AbZCQIaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZCQIaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:30:01 -0400
Received: from www.tglx.de ([62.245.132.106]:34154 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbZCQIaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:30:00 -0400
Date: Tue, 17 Mar 2009 09:29:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       ltt-dev@lists.casi.polymtl.ca, danymadden@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/irq/handle.c fix kstat_irqs_cpu and irq_to_desc
 symbols v2
In-Reply-To: <20090317000859.GB19848@Krystal>
Message-ID: <alpine.LFD.2.00.0903170919310.29264@localhost.localdomain>
References: <20090316182227.GA2444@yoda.jdub.homelinux.org> <20090316194459.GD11878@Krystal> <20090316200115.GA22538@yoda.jdub.homelinux.org> <20090316202500.GA13872@Krystal> <20090316205829.GB22538@yoda.jdub.homelinux.org> <20090316215337.GB15119@Krystal>
 <20090316220518.GD22538@yoda.jdub.homelinux.org> <20090316231122.GA18113@Krystal> <alpine.LFD.2.00.0903170048120.29264@localhost.localdomain> <20090317000859.GB19848@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mathieu Desnoyers wrote:

> * Thomas Gleixner (tglx@linutronix.de) wrote:
> > Is this a contribution to the "most useless patch of the week"
> > contest ?
> > 
> > You have my vote.
> > 
> 
> Count mine too ! :) Actually, this was not what it should look like.
> Here is my version. I am not totally convinced that the struct irq_desc
> is absolutely required, but in some include orders, it might matter.

I have not seen a compile failure report yet.

> However, the #endif around the EXPORT_SYMBOL is definitely needed.

Right.

>  	struct irq_desc *desc = irq_to_desc(irq);
>  	return desc ? desc->kstat_irqs[cpu] : 0;
>  }
> -#endif
>  EXPORT_SYMBOL(kstat_irqs_cpu);
> +#endif

Thanks,

	tglx
