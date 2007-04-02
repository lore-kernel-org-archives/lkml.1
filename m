Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbXDBLW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbXDBLW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXDBLW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:22:26 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:57519 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbXDBLWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:22:25 -0400
Date: Mon, 2 Apr 2007 13:22:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Jeff Dike <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       devzero@web.de, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel
 release ?
In-Reply-To: <4610D937.20002@nagafix.co.uk>
Message-ID: <Pine.LNX.4.64.0704021318410.1276@anakin>
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it>
 <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org>
 <4610D937.20002@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Antoine Martin wrote:
> Jeff Dike wrote:
> > On Sun, Apr 01, 2007 at 08:58:45PM +0100, Antoine Martin wrote:
> >> I reckon that one critical thing which could drastically increase the 
> >> user base would be to have a working virtual framebuffer implementation.
> > 
> > Why?  I've never understood what a framebuffer gives you that you
> > don't have now.
> Just like the network auto-configuration via dhcp, it would allow users 
> to download images+kernel and run them like appliances without 
> understanding anything about X or UML, just click and run.
> We are all capable of setting up Xvfb here, but most users are not, 
> which is why they download ready-made images.
> It would also make it a lot easier to focus on writing a management UI, 
> hell if there isn't one shortly after, I'll do one myself!
> Think of a UML browser image (running IE via wine in a limited image 
> with just X + wine + IE - I would much prefer that to having wine+IE 
> installed locally), testing framebuffer apps like gtk-fb/cairo-fb 
> without risking your dev environment, etc...

There are patches floating around for a UML frame buffer device.
Gerd Kraxel^H^H^H^H^H^HHoffmann did one using plain X11, which worked
great when I gave it a try.

A few years ago I tried doing one myself using gdk/gtk, but it didn't
work reliably on all systems. My main motivation was doing development for
different frame buffer memory organizations (think Amiga and Atari bitplanes)
on UML.

I suggest taking a look at Gerd's patches. IIRC, he posted them to lkml
last year.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
