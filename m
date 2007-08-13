Return-Path: <linux-kernel-owner+w=401wt.eu-S969177AbXHMPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969177AbXHMPxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031016AbXHMOOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:14:08 -0400
Received: from relais.videotron.ca ([24.201.245.36]:59316 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946509AbXHMOOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:14:05 -0400
Date: Mon, 13 Aug 2007 10:14:02 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] [394/2many] MAINTAINERS - PXA2xx SUPPORT
In-reply-to: <46bffb75.pNKePQf1hTn1GZ01%joe@perches.com>
X-X-Sender: nico@xanadu.home
To: joe@perches.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Message-id: <alpine.LFD.0.999.0708131009480.5415@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <46bffb75.pNKePQf1hTn1GZ01%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3889034..6e99107 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3768,6 +3768,11 @@ P:	Nicolas Pitre
>  M:	nico@cam.org
>  L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
>  S:	Maintained
> +F:	Documentation/spi/pxa2xx
> +F:	drivers/pcmcia/pxa2xx*
> +F:	drivers/spi/pxa2xx*
> +F:	drivers/usb/gadget/pxa2xx*
> +F:	sound/soc/pxa/pxa2xx*

Please don't apply this one as is.  The spi and usb bits weren't written 
by me, and given that I don't have access to the corresponding hardware 
at the moment, I'd have a really hard time maintaining those bits.


Nicolas
