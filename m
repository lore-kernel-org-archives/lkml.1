Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbYDOV1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbYDOV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbYDOV0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:26:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46928 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759516AbYDOV0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:26:51 -0400
Date: Tue, 15 Apr 2008 22:26:16 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Message-ID: <20080415212616.GD5676@flint.arm.linux.org.uk>
Mail-Followup-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pcmcia@lists.infradead.org
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080414175344.GA15028@uranus.ravnborg.org> <200804152215.34904.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804152215.34904.bzolnier@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 10:15:34PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Monday 14 April 2008, Sam Ravnborg wrote:
> > On Mon, Apr 14, 2008 at 05:16:59PM +0300, Adrian Bunk wrote:
> > > It's plain wrong for PCMCIA to select HAVE_IDE that implies e.g. the 
> > > availability of an asm/ide.h
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > 
> > > ---
> > > 9cdb66112488bc0c6e1d528444d3ba30d5b0487f diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> > > index 8b22281..519b4ff 100644
> > > --- a/drivers/pcmcia/Kconfig
> > > +++ b/drivers/pcmcia/Kconfig
> > > @@ -38,7 +38,6 @@ config PCMCIA_DEBUG
> > >  config PCMCIA
> > >  	tristate "16-bit PCMCIA support"
> > >  	select CRC32
> > > -	select HAVE_IDE
> > >  	default y
> > 
> > I did this when introducing HAVE_IDE.
> > But I do not recall why and the rationale for removing it
> > seems fine to me.
> 
> IIRC it was needed for some arm platforms which don't select HAVE_IDE
> explicetely but I don't know if this is still the case, pinging Russell.

If that is so then it is so - the only way to find out is work out
why we ended up with HAVE_IDE and what it was transformed from.

To just ask me whether it's still the case, I've absolutely no idea -
there's no way in hell for me to be able to track these kinds of
dependencies.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
