Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbXJAJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbXJAJXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXJAJXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:23:09 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:59541 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbXJAJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:23:08 -0400
Date: Mon, 1 Oct 2007 11:23:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: veerasena reddy <veerasena_b@yahoo.co.in>
cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux cache routines for Write-back cache policy on  MIPS24KE
In-Reply-To: <119374.35234.qm@web8401.mail.in.yahoo.com>
Message-ID: <Pine.LNX.4.64.0710011121300.20679@anakin>
References: <119374.35234.qm@web8401.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, veerasena reddy wrote:
> I have ported Linux-2.6.18 kernel on MIPS24KE
> processor. I am using write back cache policy.
> 
> Could you please guide me under what cases the below
> cache API's are being used:
> - dma_cache_wback_inv() : Could you explain  what
> exactly this function does

It does both write back and invalidate.

> - dma_cache_wback() : This function write back the
> cache data to memory
> - dma_cache_inv  : This function invalidate the cache
> tags. so subsequent access will fetch from memory.

Note that 2.6.18 is old. The above functions are intended to be removed.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
