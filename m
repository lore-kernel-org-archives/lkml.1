Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbXC2Msy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbXC2Msy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 08:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXC2Msy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 08:48:54 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:34590 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbXC2Msx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 08:48:53 -0400
Date: Thu, 29 Mar 2007 21:45:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin arch fix stamp537 ISP1716 IRQ setting bug
Message-ID: <20070329124535.GA20019@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Wu, Bryan" <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1175164857.15391.34.camel@roc-desktop> <1175165252.15391.40.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175165252.15391.40.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 06:47:32PM +0800, Wu, Bryan wrote:
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index 0f90ff9..a4219df 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -68,7 +68,7 @@ static struct resource bfin_isp1761_resources[] = {
>  	[1] = {
>  		.start  = ISP1761_IRQ,
>  		.end    = ISP1761_IRQ,
> -		.flags  = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
> +		.flags  = IORESOURCE_IRQ,
>  	},
>  };
>  
So you've left the logic for set_irq_type(), yes? In that case, this
looks fine.

I'd add an Acked-by, but it probably doesn't matter :-)
