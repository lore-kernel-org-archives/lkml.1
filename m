Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXFDJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXFDJrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbXFDJrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:47:14 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:52035 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbXFDJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:47:13 -0400
Date: Mon, 4 Jun 2007 09:54:40 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
In-Reply-To: <20070603.174010.41894721.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0706040953270.30435@anakin>
References: <Pine.SOC.4.64.0706032314590.20033@math>
 <20070603.174010.41894721.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Your email has `m68k' in the body, so I read it :-]

On Sun, 3 Jun 2007, David Miller wrote:
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index b4a8d60..7d893a6 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -8,6 +8,7 @@ menuconfig ATA
>  	depends on BLOCK
>  	depends on !(M32R || M68K) || BROKEN
>  	depends on !SUN4 || BROKEN
> +	depends on !(SPARC64 && !PCI)
>  	select SCSI

Isn't `!SPARC64 || PCI' more readable?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
