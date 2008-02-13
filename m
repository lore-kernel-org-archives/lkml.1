Return-Path: <linux-kernel-owner+w=401wt.eu-S1764884AbYBMIXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764884AbYBMIXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYBMIXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:23:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50896 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYBMIXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:23:10 -0500
Date: Wed, 13 Feb 2008 00:26:43 -0800
From: Greg KH <greg@kroah.com>
To: Dirk GOUDERS <hank@et.bocholt.fh-gelsenkirchen.de>
Cc: bzolnier@gmail.com, muli@il.ibm.com, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jdmason@kudzu.us, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [discuss] "ide=reverse" do we still need this?
Message-ID: <20080213082643.GB14098@kroah.com>
References: <20080213001506.GA13933@kroah.com> <1237.1202889295@sora.hank.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237.1202889295@sora.hank.home>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 08:54:55AM +0100, Dirk GOUDERS wrote:
> Hi,
> 
> > I'm reworking the pci device list logic (we currently keep all PCI
> > devices in 2 lists, which isn't the nicest, we should be able to get
> > away with only 1 list.)
> > 
> > The only bother I've found so far is the pci_get_device_reverse()
> > function, it's used in 2 places, IDE and the calgary driver.
> > 
> > I'm curious if we really still support the ide=reverse option?  It's a
> > config option that I don't think the distros still enable (SuSE does
> > not).  Is this still needed these days?
> > 
> > In digging, we changed this option in 2.2.x from being called
> > "pci=reverse" and no one else seems to miss it.
> > 
> > Any thoughts?
> 
> I remember vaguely that some years ago, we set up a box with four IDE
> disks as a RAID set.  For that purpose, we added a PCI ATA100 controller
> so that each disk could act as a primary IDE device and we were only able
> to boot the system with the option ide=reverse.
> That box has been replaced by some other so I cannot verify it but as
> far as I remember it was a problem with disk numbering between BIOS,
> bootloader and/or kernel.  Also, at that time we used lilo and I am not
> sure if grub would have done better.

Hm, so, to summarize:
  - you needed this option many years ago to get a box to work properly
  - you don't need this today

So, if the option went away, you would not be inconvenienced?

thanks,

greg k-h
