Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbXEXSxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbXEXSxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXEXSxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:53:10 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:40359 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXEXSxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:53:09 -0400
Date: Thu, 24 May 2007 20:53:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: parenthesis balance
In-Reply-To: <200705241951.58142.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.64.0705242052570.18838@anakin>
References: <200705241951.58142.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Mariusz Kozlowski wrote:
> 	Balance parenthesis in m68k mac debug code.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

>  arch/m68k/mac/debug.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -upr linux-2.6.22-rc2-mm1-a/arch/m68k/mac/debug.c linux-2.6.22-rc2-mm1-b/arch/m68k/mac/debug.c
> --- linux-2.6.22-rc2-mm1-a/arch/m68k/mac/debug.c    2007-05-19 06:06:17.000000000 +0200
> +++ linux-2.6.22-rc2-mm1-b/arch/m68k/mac/debug.c    2007-05-23 12:15:59.000000000 +0200
> @@ -71,7 +71,7 @@ void mac_debugging_short(int pos, short 
>  
>     /* calculate current offset */
>     pengoffset = (unsigned char *)mac_videobase +
> -       (150+line*2) * mac_rowbytes) + 80 * peng;
> +       (150+line*2) * mac_rowbytes + 80 * peng;
>  
>     pptr = pengoffset;
>  
> 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
