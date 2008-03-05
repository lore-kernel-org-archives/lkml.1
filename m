Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbYCEGCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbYCEGCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYCEGC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:02:29 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:17175 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYCEGC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:02:28 -0500
Date: Tue, 4 Mar 2008 22:00:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       Michael =?ISO-8859-1?Q?B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       linville@tuxdriver.com
Subject: Re: [Rt2400-devel] [PATCH] wireless: rt2x00: fix driver menu
 indenting
Message-Id: <20080304220029.1f152f00.randy.dunlap@oracle.com>
In-Reply-To: <200802102003.25392.IvDoorn@gmail.com>
References: <200802091623.06504.m.bueker@berlin.de>
	<20080210105252.e0a433ee.randy.dunlap@oracle.com>
	<200802102003.25392.IvDoorn@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 20:03:25 +0100 Ivo van Doorn wrote:

> On Sunday 10 February 2008, Randy Dunlap wrote:
> > On Sat, 9 Feb 2008 16:23:06 +0100 Michael Büker wrote:
> > 
> > > 2) When selecting "Ralink driver support" (CONFIG_RT2X00), the accompanying 
> > > drivers (CONFIG_RT2400PCI, CONFIG_RT61PC, ...) appear unindented. They should 
> > > be indented by four spaces.
> > 
> > Yes, patch is below.
> > 
> > ---
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Michael Büker <m.bueker@berlin.de> reports that the RT2x00 drivers
> > are not indented as they should be, so use proper dependencies to make
> > them be indented as expected.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Ack-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> ---
> John,
> Could you push this directly into wireless-2.6 and probably upstream as well.
> 
> Thanks.
> 
> Ivo

John, do you have this patch queued somewhere?


> > ---
> >  drivers/net/wireless/rt2x00/Kconfig |   16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > --- linux-2.6.24-git21.orig/drivers/net/wireless/rt2x00/Kconfig
> > +++ linux-2.6.24-git21/drivers/net/wireless/rt2x00/Kconfig
> > @@ -11,18 +11,17 @@ config RT2X00
> >  	  will also be created. That library (when the driver is built as
> >  	  a module) will be called "rt2x00lib.ko".
> >  
> > +if RT2X00
> > +
> >  config RT2X00_LIB
> >  	tristate
> > -	depends on RT2X00
> >  
> >  config RT2X00_LIB_PCI
> >  	tristate
> > -	depends on RT2X00
> >  	select RT2X00_LIB
> >  
> >  config RT2X00_LIB_USB
> >  	tristate
> > -	depends on RT2X00
> >  	select RT2X00_LIB
> >  
> >  config RT2X00_LIB_FIRMWARE
> > @@ -39,7 +38,7 @@ config RT2X00_LIB_RFKILL
> >  
> >  config RT2400PCI
> >  	tristate "Ralink rt2400 pci/pcmcia support"
> > -	depends on RT2X00 && PCI
> > +	depends on PCI
> >  	select RT2X00_LIB_PCI
> >  	select EEPROM_93CX6
> >  	---help---
> > @@ -58,7 +57,7 @@ config RT2400PCI_RFKILL
> >  
> >  config RT2500PCI
> >  	tristate "Ralink rt2500 pci/pcmcia support"
> > -	depends on RT2X00 && PCI
> > +	depends on PCI
> >  	select RT2X00_LIB_PCI
> >  	select EEPROM_93CX6
> >  	---help---
> > @@ -77,7 +76,7 @@ config RT2500PCI_RFKILL
> >  
> >  config RT61PCI
> >  	tristate "Ralink rt61 pci/pcmcia support"
> > -	depends on RT2X00 && PCI
> > +	depends on PCI
> >  	select RT2X00_LIB_PCI
> >  	select RT2X00_LIB_FIRMWARE
> >  	select EEPROM_93CX6
> > @@ -97,7 +96,7 @@ config RT61PCI_RFKILL
> >  
> >  config RT2500USB
> >  	tristate "Ralink rt2500 usb support"
> > -	depends on RT2X00 && USB
> > +	depends on USB
> >  	select RT2X00_LIB_USB
> >  	---help---
> >  	  This is an experimental driver for the Ralink rt2500 wireless chip.
> > @@ -106,7 +105,7 @@ config RT2500USB
> >  
> >  config RT73USB
> >  	tristate "Ralink rt73 usb support"
> > -	depends on RT2X00 && USB
> > +	depends on USB
> >  	select RT2X00_LIB_USB
> >  	select RT2X00_LIB_FIRMWARE
> >  	---help---
> > @@ -128,3 +127,4 @@ config RT2X00_DEBUG
> >  	---help---
> >  	  Enable debugging output for all rt2x00 modules
> >  
> > +endif


---
~Randy
