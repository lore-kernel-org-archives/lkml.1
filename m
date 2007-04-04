Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbXDDGfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbXDDGfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbXDDGfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:35:52 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:58935 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXDDGfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:35:51 -0400
Date: Wed, 4 Apr 2007 08:35:26 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Jeff Dike <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       devzero@web.de,
       User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, kraxel@suse.de
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel
 release ?
In-Reply-To: <4612E802.7000302@nagafix.co.uk>
Message-ID: <Pine.LNX.4.64.0704040834450.20803@anakin>
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it>
 <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org>
 <4610D937.20002@nagafix.co.uk> <Pine.LNX.4.64.0704021318410.1276@anakin>
 <20070402145300.GA6179@c2.user-mode-linux.org> <461124A9.7080609@nagafix.co.uk>
 <4612E802.7000302@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Antoine Martin wrote:
> and this one:
> http://www.suse.de/~kraxel/uml/patches/2.6.18-rc4/uml-x11-fb
> which applied cleanly, but is not letting me set the option - Kconfig is
> beyond me:
> 
> arch/um/Kconfig:144:warning: 'select' used by config symbol 'X11_FB' refer to
> undefined symbol 'FB_CFB_FILLRECT'
> arch/um/Kconfig:145:warning: 'select' used by config symbol 'X11_FB' refer to
> undefined symbol 'FB_CFB_COPYAREA'
> arch/um/Kconfig:146:warning: 'select' used by config symbol 'X11_FB' refer to
> undefined symbol 'FB_CFB_IMAGEBLIT'

Try adding

    source "drivers/video/Kconfig"

to arch/um/Kconfig.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
