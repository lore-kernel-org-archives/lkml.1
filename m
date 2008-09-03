Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYICLR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYICLR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYICLRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:17:49 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:46254 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYICLRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:17:48 -0400
Date: Wed, 3 Sep 2008 13:17:47 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Roman Zippel <zippel@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] m68k: Add missing dma_sync_single_range_for_{cpu,
 device}()
In-Reply-To: <Pine.LNX.4.64.0809031257080.25157@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0809031316450.11672@anakin>
References: <20080903071542.615137611@mail.of.borg> <20080903071742.932797091@mail.of.borg>
 <Pine.LNX.4.64.0809031257080.25157@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Roman Zippel wrote:
> On Wed, 3 Sep 2008, Geert Uytterhoeven wrote:
> 
> > Add the missing dma_sync_single_range_for_{cpu,device}(), and remove the bogus
> > `inline' for the non-static function dma_sync_single_for_device().
> 
> It's not bogus, it's a hint to gcc to inline the function into the callers 
> in the same file, but also to provide an external version.

IIRC, gcc actually complained about it. I'll check again...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
