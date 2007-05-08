Return-Path: <linux-kernel-owner+w=401wt.eu-S1032065AbXEHUVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032065AbXEHUVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968272AbXEHUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:21:18 -0400
Received: from assei1bl6.telenet-ops.be ([195.130.133.68]:32976 "EHLO
	assei1bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967147AbXEHUVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:21:17 -0400
Date: Tue, 8 May 2007 22:21:12 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: retry [PATCH] partition : add support for sysv68 partitions
In-Reply-To: <20070413135501.GA27439@ingate.macqel.be>
Message-ID: <Pine.LNX.4.64.0705082217340.12497@anakin>
References: <20070413135501.GA27439@ingate.macqel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Philippe,

On Fri, 13 Apr 2007, Philippe De Muyter wrote:
> Add support for the Motorola sysv68 disk partition table (slices in motorola
> doc).
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> 
> diff -r 1b54f1d81bc5 fs/partitions/Kconfig
> --- a/fs/partitions/Kconfig	Thu Apr 12 15:44:52 2007 -0700
> +++ b/fs/partitions/Kconfig	Fri Apr 13 15:51:58 2007 +0200
> @@ -236,3 +236,12 @@ config EFI_PARTITION
>  	help
>  	  Say Y here if you would like to use hard disks under Linux which
>  	  were partitioned using EFI GPT.
> +
> +config SYSV68_PARTITION
> +	bool "SYSV68 partition table support" if PARTITION_ADVANCED
> +	default y if M68K
        ^^^^^^^^^^^^^^^^^
> +	help
> +	  Say Y here if you would like to be able to read the hard disk
> +	  partition table format used by Motorola Delta machines (using
> +	  sysv68).
> +	  Otherwise, say N.

Bummer, I saw your patch before, but I never noticed the `default y if M68K'.

Can you please tell me on which platforms SYSV68 partition tables are commonly
used (I guess the Motorola MVME boards?), so we can enable it by default on a
more sensible subset of M68K?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
