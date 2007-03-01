Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXCAS0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXCAS0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965484AbXCAS0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:26:25 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:58804 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965483AbXCAS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:26:24 -0500
Date: Thu, 1 Mar 2007 18:26:09 +0000
From: Ben Dooks <ben@fluff.org.uk>
To: Jan Altenberg <jan.altenberg@linutronix.de>
Cc: andrew@sanpeople.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc2] AT91SAM9261: Enable second and third UART
Message-ID: <20070301182609.GB21140@fluff.org.uk>
References: <1172762693.13036.5.camel@bender.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172762693.13036.5.camel@bender.tec.linutronix.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:24:53PM +0100, Jan Altenberg wrote:
> - Enable ttyS1 and ttyS2 for the AT91SAM9261EK
> 
> Signed-off-by: Jan Altenberg <jan@linutronix.de>

These should go to Russell King's patch queue at
http://www.arm.linux.org.uk/developer/patches
 
> ---
>  arch/arm/mach-at91/board-sam9261ek.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/arm/mach-at91/board-sam9261ek.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-at91/board-sam9261ek.c
> +++ linux-2.6/arch/arm/mach-at91/board-sam9261ek.c
> @@ -50,8 +50,8 @@
>   */
>  static struct at91_uart_config __initdata ek_uart_config = {
>  	.console_tty	= 0,				/* ttyS0 */
> -	.nr_tty		= 1,
> -	.tty_map	= { 3, -1, -1, -1 }		/* ttyS0, ..., ttyS3 */
> +	.nr_tty		= 3,
> +	.tty_map	= { 3, 0, 1, -1 }		/* ttyS0, ..., ttyS3 */
>  };
>  
>  static void __init ek_map_io(void)
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
