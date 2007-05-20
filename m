Return-Path: <linux-kernel-owner+w=401wt.eu-S1764966AbXETKYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764966AbXETKYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbXETKYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:24:15 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:60649 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbXETKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:24:14 -0400
Date: Sun, 20 May 2007 12:24:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/block/z2ram: Remove TRUE/FALSE defines
In-Reply-To: <20070519234338.27317.98027.sendpatchset@thinktank.campus.ltu.se>
Message-ID: <Pine.LNX.4.64.0705201223490.20754@anakin>
References: <20070519234338.27317.98027.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Richard Knutsson wrote:
> Remove defines of TRUE and FALSE
>   * not used in the file
>   * the file is not included somewhere else
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
> Not compile-tested (don't have an Amiga-crosscompiler), but it is trivial.
> Diffed against Linus' git-tree.
> 
> 
> diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
> index 7cc2685..2abf94c 100644
> --- a/drivers/block/z2ram.c
> +++ b/drivers/block/z2ram.c
> @@ -44,9 +44,6 @@
>  extern int m68k_realnum_memory;
>  extern struct mem_info m68k_memory[NUM_MEMINFO];
>  
> -#define TRUE                  (1)
> -#define FALSE                 (0)
> -
>  #define Z2MINOR_COMBINED      (0)
>  #define Z2MINOR_Z2ONLY        (1)
>  #define Z2MINOR_CHIPONLY      (2)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
