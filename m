Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXHBQNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXHBQNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXHBQNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:13:00 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:56832 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXHBQM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:12:59 -0400
Date: Thu, 2 Aug 2007 18:12:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
In-Reply-To: <200708021624.59701.mb@bu3sch.de>
Message-ID: <Pine.LNX.4.64.0708021812260.5150@anakin>
References: <200707271857.24162.mb@bu3sch.de> <Pine.LNX.4.64.0708021557280.5150@anakin>
 <200708021624.59701.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Michael Buesch wrote:
> On Thursday 02 August 2007, Geert Uytterhoeven wrote:
> > On Fri, 27 Jul 2007, Michael Buesch wrote:
> > > The Sonics Silicon Backplane is a mini-bus used on
> > > various Broadcom chips and embedded devices.
> > > Devices using the SSB include b44, bcm43xx and various
> > > Broadcom based wireless routers.
> > > A b44 and bcm43xx port and a SSB based OHCI driver is available.
> > 
> > > --- a/drivers/Kconfig
> > > +++ b/drivers/Kconfig
> > > @@ -58,6 +58,8 @@ source "drivers/power/Kconfig"
> > >  
> > >  source "drivers/hwmon/Kconfig"
> > >  
> > > +source "drivers/ssb/Kconfig"
> > > +
> > >  source "drivers/mfd/Kconfig"
> > >  
> > >  source "drivers/media/Kconfig"
> > 
> > > --- /dev/null
> > > +++ b/drivers/ssb/Kconfig
> > > @@ -0,0 +1,92 @@
> > > +menu "Sonics Silicon Backplane"
> > > +
> > > +config SSB
> > > +	tristate "Sonics Silicon Backplane support"
> > > +	depends on EXPERIMENTAL
> > 
> > Hence this will show up on all platforms?
> 
> So?

Shouldn't you add a dependency for platforms where it make sense to have SSB?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
