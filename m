Return-Path: <linux-kernel-owner+w=401wt.eu-S1765613AbXHWVcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765613AbXHWVcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761474AbXHWVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:32:16 -0400
Received: from gw.goop.org ([64.81.55.164]:33588 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760074AbXHWVcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:32:15 -0400
Message-ID: <46CDFCE1.6080203@goop.org>
Date: Thu, 23 Aug 2007 14:32:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mxser: Remove commented crap
References: <20070822230257.4008820a@the-village.bc.nu>
In-Reply-To: <20070822230257.4008820a@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> This is years dead code and it keeps turning up in confusing ways when
> grepping for stuff
>
> Signed-off-by: Alan Cox <alan@redhat.com>
>
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc3-mm1/drivers/char/mxser.c linux-2.6.23rc3-mm1/drivers/char/mxser.c
> --- linux.vanilla-2.6.23rc3-mm1/drivers/char/mxser.c	2007-08-13 13:27:52.000000000 +0100
> +++ linux-2.6.23rc3-mm1/drivers/char/mxser.c	2007-08-22 17:47:05.000000000 +0100
> @@ -1938,14 +1938,6 @@
>  				inb(info->base + UART_MSR);
>  				continue;
>  			}
> -			/* above add by Victor Yu. 09-13-2002 */
> -			/*
> -			   if (info->tty->flip.count < TTY_FLIPBUF_SIZE / 4) {
> -			   info->IER |= MOXA_MUST_RECV_ISR;
> -			   outb(info->IER, info->base + UART_IER);
> -			   }
> -			 */
> -
>  
>  			/* mask by Victor Yu. 09-13-2002
>  			   if ( !info->tty ||
>   

Looks like another block of commented code starting here...

    J
