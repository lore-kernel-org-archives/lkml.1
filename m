Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXJYTvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXJYTvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXJYTvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:51:06 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:57158 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbXJYTvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:51:03 -0400
Date: Thu, 25 Oct 2007 21:50:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, bzolnier@gmail.com, kkeil@suse.de,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-m68k@vger.kernel.org,
       linux-ide@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC on APUS development 
	<linux-apus-devel@lists.sourceforge.net>
Subject: Re: [2.6 patch] cleanup after APUS removal
In-Reply-To: <20071024162610.GG30533@stusta.de>
Message-ID: <Pine.LNX.4.64.0710252150250.12012@anakin>
References: <20071024162610.GG30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Adrian Bunk wrote:
> After the APUS removal, some code can be removed.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
> 
>  arch/m68k/amiga/chipram.c           |    2 
>  drivers/ide/ide-probe.c             |    8 +--
>  drivers/isdn/hisax/avm_pci.c        |    8 ---
>  drivers/scsi/a2091.c                |    3 -
>  drivers/scsi/a3000.c                |    3 -
>  drivers/scsi/gvp11.c                |    3 -
>  drivers/scsi/oktagon_esp.c          |    2 
>  drivers/scsi/oktagon_io.S           |   72 ----------------------------
>  drivers/video/console/fbcon.c       |    2 
>  drivers/video/console/fonts.c       |    4 -
>  include/asm-m68k/pgtable.h          |    2 
>  sound/oss/dmasound/Kconfig          |    2 
>  sound/oss/dmasound/dmasound_paula.c |    4 -
>  13 files changed, 12 insertions(+), 103 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
