Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYBAIsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYBAIsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYBAIsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:48:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55389 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbYBAIsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:48:15 -0500
Date: Fri, 1 Feb 2008 09:48:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: platform setup for 520x ColdFire parts
Message-ID: <20080201084817.GB10969@uranus.ravnborg.org>
References: <200802010734.m117YAx4022578@goober>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802010734.m117YAx4022578@goober>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 05:34:10PM +1000, Greg Ungerer wrote:
> Switch to platform style configuration for 520x ColdFire parts.
> Initial support is for the UARTs. DMA support moved to common code
> for all ColdFire parts.
> 
> +static struct mcf_platform_uart m520x_uart_platform[] = {
> +	{
> +		.mapbase	= MCF_MBAR + MCFUART_BASE1,
> +		.irq		= MCFINT_VECBASE + MCFINT_UART0,
> +	},
> +	{
> +		.mapbase 	= MCF_MBAR + MCFUART_BASE2,
> +		.irq		= MCFINT_VECBASE + MCFINT_UART1,
> +	},
> +	{
> +		.mapbase 	= MCF_MBAR + MCFUART_BASE3,
> +		.irq		= MCFINT_VECBASE + MCFINT_UART2,
> +	},
> +	{ },
> +};
const?
Same comments for the rest of the patch and the other similar patches.

Note: Use __initdataconst for const data as replacement for __initdata.

	Sam
