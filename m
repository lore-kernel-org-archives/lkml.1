Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYHUPr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYHUPr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYHUPrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:47:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYHUPrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:47:16 -0400
Date: Thu, 21 Aug 2008 08:43:31 -0700
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: New subsystems: Ultra-Wideband radio, Wireless USB and WiMedia
	LLC Protocol
Message-ID: <20080821154330.GB1365@kroah.com>
References: <48AD6AF0.3050504@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD6AF0.3050504@csr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 02:17:36PM +0100, David Vrabel wrote:
> I'm the maintainer of the Ultra-Wideband (UWB) radio, Certified Wireless
> USB (WUSB) and WiMedia LLC Protocol (WLP) subsystems.  These are now in
> a state were I consider them suitable for inclusion into the kernel.
> 
> UWB is a new high speed, short range radio technology (480 Mbit/s at 1
> m, 53.3 Mbit/s at 10 m).  The specifications are freely available and
> are managed by the WiMedia Alliance.   For more information see
> http://www.wimedia.org/.
> 
> Various protocols run on top of the UWB radio: Certified Wireless USB
> (WUSB); WiMedia LLC Protocol (WLP), for IP (etc) networks; and (in the
> future) high speed Bluetooth.
> 
> The code is some 35,000 lines so I won't be posting it to this list but
> you can view the patch set here:
> 
> http://www.davidvrabel.org.uk/~david/linux/uwb/
> 
> Or you can pull the changes from the uwb branch of
> 
> git://pear.davidvrabel.org.uk/git/uwb.git
> 
> (Please don't clone the entire tree from here as I have very limited
> bandwidth.)

If this is an issue, I think you can use the --reference option to
git-clone when creating the tree to reference an external tree (like
Linus's).  That way you don't have the whole tree on your server for
stuff like this.

> Or you can view the patches in the linux-usb archive here:
> 
> http://thread.gmane.org/gmane.linux.usb.general/8715
> 
> The vast majority of the code forms part of the new UWB, WUSB, and WLP
> subsystem with no impact on the rest of the kernel.  It has all been
> posted to the linux-usb list and has been reviewed there.

Well, it's been reviewed in parts, I didn't review this last version as
I stopped after the first two patches :)

> For a wider review, I will follow up with the 2 minor patches that add
> some simple infrastructure.

These are the ones that need to be approved by the wider lkml audience
before we get the rest of the tree in.

thanks,

greg k-h
