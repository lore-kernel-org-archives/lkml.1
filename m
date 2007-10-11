Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbXJKHQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbXJKHQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXJKHQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:16:06 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:50232 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbXJKHQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:16:04 -0400
Date: Thu, 11 Oct 2007 09:16:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: m68k Kconfig undefined symbol in 2.6.23.
In-Reply-To: <200710101719.52423.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0710110915390.23818@anakin>
References: <200710101719.52423.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Rob Landley wrote:
> The m68k Kconfig tries to select a symbol (APM_EMULATION) that doesn't exist.
> 
> I did this to fix it, without really understanding the larger problem.  (Did 
> APM go away?)  Just FYI...
> 
> Rob
> 
> diff -r 79f0ea1e0e70 drivers/macintosh/Kconfig
> --- a/drivers/macintosh/Kconfig	Tue Oct 09 21:00:40 2007 +0000
> +++ b/drivers/macintosh/Kconfig	Wed Oct 10 17:17:07 2007 -0500
> @@ -116,11 +116,6 @@ config PMAC_SMU
>  	  on the "SMU" system control chip which replaces the old PMU.
>  	  If you don't know, say Y.
>  
> -config PMAC_APM_EMU
> -	tristate "APM emulation"
> -	select APM_EMULATION
> -	depends on ADB_PMU && PM && PPC32
                                    ^^^^^
I.e. PPC, not m68k.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
