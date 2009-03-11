Return-Path: <linux-kernel-owner+w=401wt.eu-S1751995AbZCKQCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbZCKQCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZCKQCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:02:36 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19672 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZCKQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:02:35 -0400
Message-ID: <49B7E01C.9010403@caviumnetworks.com>
Date: Wed, 11 Mar 2009 09:00:28 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [patch 07/18] mips: convert obsolete irq_desc_t to struct irq_desc
References: <20090311003204.592133594@linutronix.de> <20090311003236.133903965@linutronix.de>
In-Reply-To: <20090311003236.133903965@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2009 16:00:28.0562 (UTC) FILETIME=[7F74B720:01C9A262]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Impact: cleanup
> 
> Convert the last remaining users to struct irq_desc.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> CC: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: David Daney <ddaney@caviumnetworks.com>

My boards still boot with this patch.

Thanks,
David Daney

> 
> ---
>  arch/mips/cavium-octeon/octeon-irq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/cavium-octeon/octeon-irq.c
> +++ linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
> @@ -31,7 +31,7 @@ static void octeon_irq_core_ack(unsigned
>  
>  static void octeon_irq_core_eoi(unsigned int irq)
>  {
> -	irq_desc_t *desc = irq_desc + irq;
> +	struct irq_desc *desc = irq_desc + irq;
>  	unsigned int bit = irq - OCTEON_IRQ_SW0;
>  	/*
>  	 * If an IRQ is being processed while we are disabling it the
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

