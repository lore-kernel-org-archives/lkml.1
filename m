Return-Path: <linux-kernel-owner+w=401wt.eu-S967008AbXFGXj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967008AbXFGXj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935265AbXFGXjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:39:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57155 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765493AbXFGXjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:39:20 -0400
Date: Fri, 8 Jun 2007 00:41:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: jcm@jonmasters.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070608004117.57868755@the-village.bc.nu>
In-Reply-To: <20070607232152.GU5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	<9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	<Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
	<20070607193413.GR5500@stusta.de>
	<20070607232248.332edee8@the-village.bc.nu>
	<20070607232152.GU5500@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I added a MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>") into the "raw" 
> module:
> 
> # echo $LANG
> C
> # modinfo --version
> module-init-tools version 3.3-pre11
> # modinfo raw
> filename:       /lib/modules/2.6.21.2/kernel/drivers/char/raw.ko
> author:         J. Ã
>                     ^ the cursor hangs here

"Mummy if I deliberately shoot myself in the head it hurts"

Distro's don't ship in C locale and haven't for years. And the worst case
effect you can engineer by trying is to display some slightly odd symbols

(And incidentially since the Linux fs has been defined to be utf-8 for
naming for many years you'll find the same problem using "ls")

> - get module-init-tools fixed and
> - document that 2.6.23 (or whichever will be the first kernel to support 
>   UTF-8 in MODULE_AUTHOR) will require updated module-init-tools.

"Require" is a rather strong word for a print formatting issue specific
to obscure setups.

Alan
