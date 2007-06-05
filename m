Return-Path: <linux-kernel-owner+w=401wt.eu-S1763957AbXFEHoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763957AbXFEHoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763842AbXFEHoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:44:00 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:49986 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759762AbXFEHn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:43:59 -0400
Date: Tue, 5 Jun 2007 09:43:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] potential parse error in ifdef part 3
In-Reply-To: <87bqfvr2t9.fsf@wanadoo.fr>
Message-ID: <Pine.LNX.4.64.0706050943370.27590@anakin>
References: <87bqfvr2t9.fsf@wanadoo.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Yoann Padioleau wrote:
> parse errors in ifdefs
> 
> Fix various bits of obviously-busted code which we're not happening to
> compile, due to ifdefs.

> --- a/arch/m68k/mac/debug.c
> +++ b/arch/m68k/mac/debug.c
> @@ -71,7 +71,7 @@ #ifdef DEBUG_SCREEN
>  
>  	/* calculate current offset */
>  	pengoffset = (unsigned char *)mac_videobase +
> -		(150+line*2) * mac_rowbytes) + 80 * peng;
> +		(150+line*2) * mac_rowbytes + 80 * peng;
>  
>  	pptr = pengoffset;

Already fixed in 4eb527a0ca83de28e773371f42abad2ab1ed7fdf

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
