Return-Path: <linux-kernel-owner+w=401wt.eu-S1764804AbXHDNDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764804AbXHDNDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbXHDNDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:03:38 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:42872 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760832AbXHDNDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:03:36 -0400
Date: Sat, 4 Aug 2007 15:03:34 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 72] drivers/mmc/core/sdio_bus.c: kmalloc + memset
 conversion to kzalloc
Message-ID: <20070804150334.75faf362@poseidon.drzeus.cx>
In-Reply-To: <200708010005.25352.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200708010005.25352.m.kozlowski@tuxland.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 00:05:24 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/mmc/core/sdio_bus.c | 5528 -> 5483 (-45 bytes)
>  drivers/mmc/core/sdio_bus.o | 70044 -> 69876 (-168 bytes)
> 
>  drivers/mmc/core/sdio_bus.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

Although this is code that only lives in my -mm tree. Should I carry
this patch instead, perhaps?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
