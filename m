Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZEURqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZEURqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZEURqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:46:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58807 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZEURqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:46:23 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+G5mHD6rWsSxig0YlursCh
Date: Thu, 21 May 2009 10:46:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UART regs: add OMAP wakeup-enable register
Message-ID: <20090521174620.GN8308@atomide.com>
References: <1242925798-29672-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242925798-29672-1-git-send-email-khilman@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@deeprootsystems.com> [090521 10:10]:
> Add the wakeup enable register to the list of OMAP-specific UART
> registers.  This is to support forthcoming OMAP PM enhancements which
> use the wakeup feature of the OMAP's 8250-based UART.
> 
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> ---
> The MAINTAINERS file lists the 8250 driver as orphaned, and posts to
> linux-serial go unanswered.  How should this go upstream?

I suggest you merge this into your omap PM queue and we'll merge it
with that.

Tony

 
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
