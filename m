Return-Path: <linux-kernel-owner+w=401wt.eu-S1764738AbXEWTSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764738AbXEWTSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762603AbXEWTSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:18:36 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:55407 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761993AbXEWTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:18:35 -0400
Date: Wed, 23 May 2007 21:18:33 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Enable arbitary speed tty support
In-Reply-To: <20070523174446.37abfa7a@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0705232117260.10610@anakin>
References: <20070523174446.37abfa7a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Alan Cox wrote:
> Add the needed constants and defines to activate the existing code. 
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-m68k/ioctls.h linux-2.6.22-rc1-mm1/include/asm-m68k/ioctls.h
> --- linux.vanilla-2.6.22-rc1-mm1/include/asm-m68k/ioctls.h	2007-04-30 10:48:17.000000000 +0100
> +++ linux-2.6.22-rc1-mm1/include/asm-m68k/ioctls.h	2007-05-23 16:35:06.212417496 +0100
> @@ -46,6 +46,10 @@
>  #define TIOCSBRK	0x5427  /* BSD compatibility */
>  #define TIOCCBRK	0x5428  /* BSD compatibility */
>  #define TIOCGSID	0x5429  /* Return the session ID of FD */
> +#define TCGETS2		_IOR('T',0x2A, struct termios2)
> +#define TCSETS2		_IOW('T',0x2B, struct termios2)
> +#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> +#define TCSETSF2	_IOW('T',0x2D, struct termios2)

Where is `struct termios2' defined? Right now it doesn't compile because
of that.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
