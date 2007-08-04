Return-Path: <linux-kernel-owner+w=401wt.eu-S1765286AbXHDQrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765286AbXHDQrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764384AbXHDQr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:47:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763866AbXHDQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:47:25 -0400
Date: Sat, 4 Aug 2007 09:47:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 72] drivers/mmc/core/sdio_bus.c: kmalloc + memset
 conversion to kzalloc
Message-Id: <20070804094702.9f968b27.akpm@linux-foundation.org>
In-Reply-To: <20070804150334.75faf362@poseidon.drzeus.cx>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200708010005.25352.m.kozlowski@tuxland.pl>
	<20070804150334.75faf362@poseidon.drzeus.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007 15:03:34 +0200 Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> On Wed, 1 Aug 2007 00:05:24 +0200
> Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> 
> > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> > 
> >  drivers/mmc/core/sdio_bus.c | 5528 -> 5483 (-45 bytes)
> >  drivers/mmc/core/sdio_bus.o | 70044 -> 69876 (-168 bytes)
> > 
> >  drivers/mmc/core/sdio_bus.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> 
> Acked-by: Pierre Ossman <drzeus@drzeus.cx>
> 
> Although this is code that only lives in my -mm tree. Should I carry
> this patch instead, perhaps?
> 

Yes please.  I always get confused when a git-tree maintainer says
"Acked-by" rather than "applied, thanks".

But I have these queued in my to-send-to-Pierre-regularly queue,
so things will sort themselves out.
