Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYF2JRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYF2JRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbYF2JRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 05:17:10 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:53454 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYF2JRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 05:17:08 -0400
Date: Sun, 29 Jun 2008 11:17:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 09/20] m68k: use generic show_mem()
In-Reply-To: <20080627120049.118036361@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0806291116470.29339@anakin>
References: <20080627115349.743368154@saeurebad.de> <20080627120049.118036361@saeurebad.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Johannes Weiner wrote:
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

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
