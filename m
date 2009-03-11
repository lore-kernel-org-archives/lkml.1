Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZCKCWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZCKCWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZCKCWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:22:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:42996 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994AbZCKCWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:22:12 -0400
Subject: Re: [patch 16/18] powerpc: convert obsolete hw_interrupt_type to
 struct irq_chip
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20090311003237.169865866@linutronix.de>
References: <20090311003204.592133594@linutronix.de>
	 <20090311003237.169865866@linutronix.de>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 13:19:49 +1100
Message-Id: <1236737989.7086.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 00:46 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (powerpc-convert-obsolete-hw-interrupt-type.patch)
> Impact: cleanup
> 
> Convert the last remaining users to struct irq_chip.

Ack too, same comment, happy to have that one in powerpc.

Ben.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: linuxppc-dev@ozlabs.org
> ---
>  arch/powerpc/include/asm/hw_irq.h     |    2 +-
>  arch/powerpc/platforms/powermac/pic.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/powerpc/include/asm/hw_irq.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/include/asm/hw_irq.h
> +++ linux-2.6/arch/powerpc/include/asm/hw_irq.h
> @@ -129,7 +129,7 @@ static inline int irqs_disabled_flags(un
>   * interrupt-retrigger: should we handle this via lost interrupts and IPIs
>   * or should we not care like we do now ? --BenH.
>   */
> -struct hw_interrupt_type;
> +struct irq_chip;
>  
>  #endif	/* __KERNEL__ */
>  #endif	/* _ASM_POWERPC_HW_IRQ_H */
> Index: linux-2.6/arch/powerpc/platforms/powermac/pic.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/platforms/powermac/pic.h
> +++ linux-2.6/arch/powerpc/platforms/powermac/pic.h
> @@ -3,7 +3,7 @@
>  
>  #include <linux/irq.h>
>  
> -extern struct hw_interrupt_type pmac_pic;
> +extern struct irq_chip pmac_pic;
>  
>  extern void pmac_pic_init(void);
>  extern int pmac_get_irq(void);
> 

