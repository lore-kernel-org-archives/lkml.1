Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbZGIJuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbZGIJuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbZGIJt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:49:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45946 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbZGIJt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:49:58 -0400
Date: Thu, 9 Jul 2009 11:48:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, swetland@google.com
Subject: Re: Framebuffer support for HTC Dream
Message-ID: <20090709094755.GA10937@elf.ucw.cz>
References: <20090629111029.GA15514@elf.ucw.cz> <20090629123840.1e20f17d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629123840.1e20f17d.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > index fb19803..4a7873b 100644
> > --- a/drivers/video/Kconfig
> > +++ b/drivers/video/Kconfig
> > @@ -2119,6 +2119,14 @@ config FB_PRE_INIT_FB
> >  	  Select this option if display contents should be inherited as set by
> >  	  the bootloader.
> >  
> > +config FB_MSM
> > +	tristate
> > +	depends on FB && ARCH_MSM
> > +	select FB_CFB_FILLRECT
> > +	select FB_CFB_COPYAREA
> > +	select FB_CFB_IMAGEBLIT
> > +	default y
> 
> I'm seeing gpio calls in there.  Do we need a gpio dependency, or did
> ARCH_MSM give us gpio anyway?

AFAICT, ARCH_MSM needs GENERIC_GPIO, so we are ok.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
