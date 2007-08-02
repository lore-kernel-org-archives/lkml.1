Return-Path: <linux-kernel-owner+w=401wt.eu-S1759119AbXHBQTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbXHBQTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXHBQTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:19:08 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38948
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbXHBQTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:19:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
Date: Thu, 2 Aug 2007 18:18:57 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>
References: <200707271857.24162.mb@bu3sch.de> <200708021624.59701.mb@bu3sch.de> <Pine.LNX.4.64.0708021812260.5150@anakin>
In-Reply-To: <Pine.LNX.4.64.0708021812260.5150@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021818.58319.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007, Geert Uytterhoeven wrote:
> On Thu, 2 Aug 2007, Michael Buesch wrote:
> > On Thursday 02 August 2007, Geert Uytterhoeven wrote:
> > > On Fri, 27 Jul 2007, Michael Buesch wrote:
> > > > The Sonics Silicon Backplane is a mini-bus used on
> > > > various Broadcom chips and embedded devices.
> > > > Devices using the SSB include b44, bcm43xx and various
> > > > Broadcom based wireless routers.
> > > > A b44 and bcm43xx port and a SSB based OHCI driver is available.
> > > 
> > > > --- a/drivers/Kconfig
> > > > +++ b/drivers/Kconfig
> > > > @@ -58,6 +58,8 @@ source "drivers/power/Kconfig"
> > > >  
> > > >  source "drivers/hwmon/Kconfig"
> > > >  
> > > > +source "drivers/ssb/Kconfig"
> > > > +
> > > >  source "drivers/mfd/Kconfig"
> > > >  
> > > >  source "drivers/media/Kconfig"
> > > 
> > > > --- /dev/null
> > > > +++ b/drivers/ssb/Kconfig
> > > > @@ -0,0 +1,92 @@
> > > > +menu "Sonics Silicon Backplane"
> > > > +
> > > > +config SSB
> > > > +	tristate "Sonics Silicon Backplane support"
> > > > +	depends on EXPERIMENTAL
> > > 
> > > Hence this will show up on all platforms?
> > 
> > So?
> 
> Shouldn't you add a dependency for platforms where it make sense to have SSB?

Well, that's everything where you can stick a PCI, PCMCIA, PC-Card or CF-Card
into, plus the MIPS platform, where we have the embedded SSB.
That's basically everything, no? Except these strange !HAS_IOMEM platforms,
which we already take care of in a followup patch.
