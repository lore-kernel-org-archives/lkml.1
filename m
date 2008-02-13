Return-Path: <linux-kernel-owner+w=401wt.eu-S1765492AbYBMIKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765492AbYBMIKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbYBMIJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:09:54 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:54799
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbYBMIJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:09:53 -0500
X-Greylist: delayed 818 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 03:09:52 EST
X-DKIM: Sendmail DKIM Filter v2.4.0 alice.et.bocholt.fh-gelsenkirchen.de m1D7sweI010889
To: Greg KH <greg@kroah.com>
cc: bzolnier@gmail.com, muli@il.ibm.com, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jdmason@kudzu.us, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [discuss] "ide=reverse" do we still need this? 
In-reply-to: <20080213001506.GA13933@kroah.com> 
References: <20080213001506.GA13933@kroah.com>
Comments: In-reply-to Greg KH <greg@kroah.com>
   message dated "Tue, 12 Feb 2008 16:15:07 -0800."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.1.1
Date: Wed, 13 Feb 2008 08:54:55 +0100
Message-ID: <1237.1202889295@sora.hank.home>
From: Dirk GOUDERS <hank@et.bocholt.fh-gelsenkirchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I'm reworking the pci device list logic (we currently keep all PCI
> devices in 2 lists, which isn't the nicest, we should be able to get
> away with only 1 list.)
> 
> The only bother I've found so far is the pci_get_device_reverse()
> function, it's used in 2 places, IDE and the calgary driver.
> 
> I'm curious if we really still support the ide=reverse option?  It's a
> config option that I don't think the distros still enable (SuSE does
> not).  Is this still needed these days?
> 
> In digging, we changed this option in 2.2.x from being called
> "pci=reverse" and no one else seems to miss it.
> 
> Any thoughts?

I remember vaguely that some years ago, we set up a box with four IDE
disks as a RAID set.  For that purpose, we added a PCI ATA100 controller
so that each disk could act as a primary IDE device and we were only able
to boot the system with the option ide=reverse.
That box has been replaced by some other so I cannot verify it but as
far as I remember it was a problem with disk numbering between BIOS,
bootloader and/or kernel.  Also, at that time we used lilo and I am not
sure if grub would have done better.

Dirk
