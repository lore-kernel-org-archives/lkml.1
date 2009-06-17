Return-Path: <linux-kernel-owner+w=401wt.eu-S1764720AbZFQIXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764720AbZFQIXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZFQIW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:22:59 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50294 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZFQIW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:22:57 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/69+9ihjT0nmT3p7UrWiKQ
Date: Wed, 17 Jun 2009 01:22:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Alan Cox <alan@linux.intel.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend v3] UART regs: add OMAP wakeup-enable register
Message-ID: <20090617082256.GE6605@atomide.com>
References: <1244828486-13666-1-git-send-email-khilman@ti.deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244828486-13666-1-git-send-email-khilman@ti.deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@deeprootsystems.com> [090612 10:42]:
> From: Kevin Hilman <khilman@deeprootsystems.com>
> 
> Add the wakeup enable register to the list of OMAP-specific UART
> registers.

Acked-by: Tony Lindgren <tony@atomide.com>

Ping.. Alan, could you please queue this too?

Regards,

Tony

> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> ---
>  include/linux/serial_reg.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
> index 96c0d93..850db2e 100644
> --- a/include/linux/serial_reg.h
> +++ b/include/linux/serial_reg.h
> @@ -323,6 +323,7 @@
>  #define UART_OMAP_MVER		0x14	/* Module version register */
>  #define UART_OMAP_SYSC		0x15	/* System configuration register */
>  #define UART_OMAP_SYSS		0x16	/* System status register */
> +#define UART_OMAP_WER		0x17	/* Wake-up enable register */
>  
>  #endif /* _LINUX_SERIAL_REG_H */
>  
> -- 
> 1.6.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
