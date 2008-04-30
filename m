Return-Path: <linux-kernel-owner+w=401wt.eu-S933804AbYD3Xkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbYD3Xkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbYD3Xki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:40:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43466 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757574AbYD3Xkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:40:37 -0400
Date: Thu, 1 May 2008 00:32:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] drivers: atm, char fix integer as NULL pointer
 warnings
Message-ID: <20080501003251.022fec3d@core>
In-Reply-To: <1209417200.14173.103.camel@brick>
References: <1209417200.14173.103.camel@brick>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index 4d3c701..98b65a2 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -1180,7 +1180,7 @@ struct tty_driver *tty_find_polling_driver(char *name, int *line)
>  		if (*str == ',')
>  			str++;
>  		if (*str == '\0')
> -			str = 0;
> +			str = NULL;
>  
>  		if (tty_line >= 0 && tty_line <= p->num && p->poll_init &&
>  				!p->poll_init(p, tty_line, str)) {

Acked-by: Alan Cox <alan@redhat.com>
