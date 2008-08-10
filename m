Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYHJSQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYHJSQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 14:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYHJSQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 14:16:14 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:34232 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYHJSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 14:16:13 -0400
Date: Sun, 10 Aug 2008 20:16:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] ide: remove M68K_IDE_SWAPW define from <asm-m68k/ide.h>
In-Reply-To: <200808101746.12697.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0808102015580.10672@anakin>
References: <200808101746.12697.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008, Bartlomiej Zolnierkiewicz wrote:
> Since we solved this by overriding default ->{in,out}put_data
> methods in {q40,falcon}ide M68K_IDE_SWAP define can go away.
> 
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  include/asm-m68k/ide.h |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> Index: b/include/asm-m68k/ide.h
> ===================================================================
> --- a/include/asm-m68k/ide.h
> +++ b/include/asm-m68k/ide.h
> @@ -92,15 +92,6 @@
>  #define outsw_swapw(port, addr, n)	raw_outsw_swapw((u16 *)port, addr, n)
>  #endif
>  
> -
> -/* Q40 and Atari have byteswapped IDE busses and since many interesting
> - * values in the identification string are text, chars and words they
> - * happened to be almost correct without swapping.. However *_capacity
> - * is needed for drives over 8 GB. RZ */
> -#if defined(CONFIG_Q40) || defined(CONFIG_ATARI)
> -#define M68K_IDE_SWAPW  (MACH_IS_Q40 || MACH_IS_ATARI)
> -#endif
> -
>  #ifdef CONFIG_BLK_DEV_FALCON_IDE
>  #define IDE_ARCH_LOCK

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
