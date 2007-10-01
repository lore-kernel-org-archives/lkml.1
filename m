Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbXJALm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbXJALm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXJALmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:42:38 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:60418 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbXJALmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:42:36 -0400
Date: Mon, 1 Oct 2007 13:42:34 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: veerasena reddy <veerasena_b@yahoo.co.in>
cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux cache routines for Write-back cache policy on  MIPS24KE
In-Reply-To: <302271.86305.qm@web8404.mail.in.yahoo.com>
Message-ID: <Pine.LNX.4.64.0710011341320.20679@anakin>
References: <302271.86305.qm@web8404.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, veerasena reddy wrote:
> In linux-2.6.18 (for MIPS24KE processor):
> suppose if i want to do flush only then which API i
> should use?

`flush' is fuzzy terminology: some people mean invalidate, others mean
write back, others mean both.

> Similarly, if i want to do invalidation only which API
> i should use?

dma_cache_inv().

> --- Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > On Mon, 1 Oct 2007, veerasena reddy wrote:
> > > I have ported Linux-2.6.18 kernel on MIPS24KE
> > > processor. I am using write back cache policy.
> > > 
> > > Could you please guide me under what cases the
> > below
> > > cache API's are being used:
> > > - dma_cache_wback_inv() : Could you explain  what
> > > exactly this function does
> > 
> > It does both write back and invalidate.
> > 
> > > - dma_cache_wback() : This function write back the
> > > cache data to memory
> > > - dma_cache_inv  : This function invalidate the
> > cache
> > > tags. so subsequent access will fetch from memory.
> > 
> > Note that 2.6.18 is old. The above functions are
> > intended to be removed.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
