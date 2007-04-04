Return-Path: <linux-kernel-owner+w=401wt.eu-S2992626AbXDDG72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992626AbXDDG72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992690AbXDDG72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:59:28 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:39416 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992626AbXDDG71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:59:27 -0400
Date: Wed, 4 Apr 2007 08:58:31 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <20070403.165518.55726194.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0704040858130.20803@anakin>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
 <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <20070403.165518.55726194.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, David Miller wrote:
> From: Paul Mackerras <paulus@samba.org>
> Date: Wed, 4 Apr 2007 09:14:20 +1000
> 
> > David Woodhouse writes:
> > 
> > > There are proper device numbers registered for pmac_zilog now. Use them.
> > 
> > Sigh.  I guess this is inevitable, but IMNSHO this exposes a weakness
> > in our serial subsystem.
> > 
> > The problem is that this means that a user has to know "oh, the serial
> > port on my computer is implemented with a Z85C30 chip, therefore it's
> > /dev/ttyPZ0 not /dev/ttyS0, like it would be if the designers had used
> > a 16C550".
> ...
> > Why should a user know or care about that?  It really should be "it's
> > the built-in serial port on my computer therefore it's /dev/ttyS0".
> 
> I totally agree with Paul, the onboard serial device should get
> ttyS0 regardless of what hardare is used to drive it.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
