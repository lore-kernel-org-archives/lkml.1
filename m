Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYGEILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYGEILq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 04:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYGEIL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 04:11:28 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:34339 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYGEIL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 04:11:26 -0400
Date: Sat, 5 Jul 2008 10:11:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Johannes Weiner <hannes@saeurebad.de>, Greg Ungerer <gerg@uclinux.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH 16/20] m68knommu: use generic show_mem()
In-Reply-To: <20080704161457.056057813@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0807051010550.5733@anakin>
References: <20080704160737.750988999@saeurebad.de> <20080704161457.056057813@saeurebad.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008, Johannes Weiner wrote:
> Remove arch-specific show_mem() in favor of the generic version.
> 
> This also removes the following redundant information display:
> 
> 	- free pages, printed by show_free_areas()
> 	- pages in swapcache, printed by show_swap_cache_info()
> 
> where show_mem() calls show_free_areas(), which calls
> show_swap_cache_info().
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68knommu/mm/init.c |   27 ---------------------------

m68knommu is uClinux.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
