Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYGJCyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYGJCyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYGJCyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:54:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50446 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYGJCyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KCcefAGCnEZlZIcqIOGwGSFMaFGhNslnz/nAq5ZWhKZlvT9FBIBDnZjZoXdEXKGNO7
         MMNVbIoraJLI+qC5c2Td0gV2gkmcVUkNeEtCbcZmalkdoYWDBY0Pf2WMUXxYqGhiBVMB
         c0A4m6MtKz62RSX42CzrYQfB89LUfyioT/C7E=
Date: Thu, 10 Jul 2008 06:51:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Quel Qun <kelk1@comcast.net>, LKML <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: No console on Riva TNT since 2.6.26-0.rc4
Message-ID: <20080710025149.GA4817@martell.zuzino.mipt.ru>
References: <062620082004.6012.4863F668000CEA0D0000177C2200751090CE05040A05@comcast.net> <20080709194108.f18226e8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709194108.f18226e8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 07:41:08PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2008 20:04:56 +0000 kelk1@comcast.net (Quel Qun) wrote:
> 
> > Hi,
> > 
> > The system boots fine with 2.6.26-0.rc3.1mnb (Mandriva Cooker), but since rc4, I see a few squares of color, then a black screen and the console never comes back. This is independent of the resolution chosen when using vga=ask. The machine does boot and I can start X if I log in blindly. Only the F1 to F6 consoles are gone.
> > 
> > Bug originally reported and ignored on Cooker: https://qa.mandriva.com/show_bug.cgi?id=41302
> > 
> > My card is an old STB NVidia Riva TNT, monitor is a flat panel Dell 2007FP, system is a Dell Dimension XPS T600 (82371AB/EB/MB PIIX4 with PIII 600).
> > 
> > I cannot see anything different in /var/log/messages between rc3 and rc4 (vga=837)
> > 
> > vesafb: framebuffer at 0xfc000000, mapped to 0xd8880000, using 7500k, total
> > 16320k
> > vesafb: mode is 1600x1200x8, linelength=1600, pages=6
> > vesafb: protected mode interface info at c000:02d2
> > vesafb: pmi: set display start = c00c030b, set palette = c00c0381
> > vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf
> > 3d0 3d1 3d2 3d3 3d4 3d5 3da
> > vesafb: scrolling: redraw
> > vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
> > Console: switching to colour frame buffer device 200x75
> > fb0: VESA VGA frame buffer device
> > 
> > This is still true with a vanilla 2.6.26-rc8.
> > 
> > $ grep FB_RIVA /boot/config
> > CONFIG_FB_RIVA=m
> > # CONFIG_FB_RIVA_I2C is not set
> > # CONFIG_FB_RIVA_DEBUG is not set
> > CONFIG_FB_RIVA_BACKLIGHT=y
> > 
> 
> Let's cc the fbdev list.
> 
> Is this a regression?  Was 2.6.25 OK?

2.6.26-rc3 was OK. -rc4 wasn't.

