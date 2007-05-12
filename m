Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbXELLR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbXELLR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbXELLRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:17:21 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45439 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756112AbXELLRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:17:21 -0400
Date: Sat, 12 May 2007 13:17:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Richard Purdie <richard@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       torvalds@osdl.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Message-ID: <20070512111722.GJ7984@stusta.de>
References: <1178096183.5860.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1178096183.5860.25.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 09:56:23AM +0100, Richard Purdie wrote:
>...
> I've asked the LZO author about the comments on lzo_copyright function
> but the code is GPLv2 licensed so is suitable for inclusion in the
> kernel.

This sounds as if LZO is GPL incompatible similar to code under
the 4 clause BSD licence.

>...
> +/* If you use the LZO library in a product, you *must* keep this
> + * copyright string in the executable of your product.
> + */
> +
> +const char __lzo_copyright[] =
> +#if !defined(__LZO_IN_MINLZO)
> +    LZO_VERSION_STRING;
> +#else
> +    "\r\n\n"
> +    "LZO data compression library.\n"
> +    "$Copyright: LZO (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005 Markus Franz Xaver Johannes Oberhumer\n"
> +    "<markus@oberhumer.com>\n"
> +    "http://www.oberhumer.com $\n\n"
> +    "$Id: LZO version: v" LZO_VERSION_STRING ", " LZO_VERSION_DATE " $\n"
> +    "$Built: " __DATE__ " " __TIME__ " $\n"
> +#endif
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

