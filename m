Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbXEJNxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbXEJNxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbXEJNx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:53:28 -0400
Received: from mathups.math.u-psud.fr ([129.175.52.4]:45075 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754596AbXEJNx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:53:27 -0400
X-Greylist: delayed 2999 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 09:53:27 EDT
From: Duncan Sands <duncan.sands@free.fr>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [git patch] move USB net drivers to drivers/net
Date: Thu, 10 May 2007 14:27:26 +0200
User-Agent: KMail/1.9.6
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net
References: <20070510013855.GA3402@havoc.gtf.org> <1358.81.207.0.53.1178799167.squirrel@secure.samage.net>
In-Reply-To: <1358.81.207.0.53.1178799167.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101427.30990.duncan.sands@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007 14:12:47 Indan Zupancic wrote:
> Hello,
> 
> On Thu, May 10, 2007 03:38, Jeff Garzik wrote:
> >
> > This was ACK'd by Greg, as you see in the sign-offs.  See the commit
> > below for rationale.
> >
> > USB is now treated like other buses, for network drivers:
> > * USB network driver patches should go to me and netdev
> > * Just like in PCI or PCMCIA land, bus-specific code may
> >   originate from the USB side of the house (Greg's tree).
> >
> >
> >
> > Please pull from 'usb-move' branch of
> > master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git usb-move
> >
> > to receive the following update:
> >
> >
> > commit 5b2fc499917e5897a13add780e181b4cef197072
> > Author: Jeff Garzik <jeff@garzik.org>
> > Date:   Wed May 9 21:31:55 2007 -0400
> >
> >     Move USB network drivers to drivers/net/usb.
> >
> >     It is preferable to group drivers by usage (net, scsi, ATA, ...) than
> >     by bus.  When reviewing drivers, the [PCI|USB|PCMCIA|...] maintainer
> >     is probably less qualified on networking issues than a networking
> >     maintainer.  Also, from a practical standpoint, chips often
> >     appear on multiple buses, which is why we do not put drivers into
> >     drivers/pci/net.
> 
> What about drivers/usb/atm/?

I don't mind if it moves to drivers/atm/, though I don't see the point of it.

Best wishes,

Duncan.
