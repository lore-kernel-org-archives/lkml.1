Return-Path: <linux-kernel-owner+w=401wt.eu-S1765700AbYBMGCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765700AbYBMGCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765027AbYBMGCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:02:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60059 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764861AbYBMGCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:02:09 -0500
Date: Tue, 12 Feb 2008 20:44:36 -0800
From: Greg KH <greg@kroah.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: bzolnier@gmail.com, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: "ide=reverse" do we still need this?
Message-ID: <20080213044436.GB10101@kroah.com>
References: <20080213001506.GA13933@kroah.com> <47B24AB3.3040009@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B24AB3.3040009@keyaccess.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:41:07AM +0100, Rene Herman wrote:
> On 13-02-08 01:15, Greg KH wrote:
>
>> I'm reworking the pci device list logic (we currently keep all PCI
>> devices in 2 lists, which isn't the nicest, we should be able to get
>> away with only 1 list.)
>> The only bother I've found so far is the pci_get_device_reverse()
>> function, it's used in 2 places, IDE and the calgary driver.
>> I'm curious if we really still support the ide=reverse option?  It's a
>> config option that I don't think the distros still enable (SuSE does
>> not).  Is this still needed these days?
>> In digging, we changed this option in 2.2.x from being called
>> "pci=reverse" and no one else seems to miss it.
>> Any thoughts?
>
> While details escape me somewhat again at the monment, a few months ago I 
> was playing around with a PCI Promise IDE controller and needed ide=reverse 
> to save me from having to switch disks around to still have a bootable 
> system.
>
> Or some such. Not too clear anymore, but I remember it saved the day.

You couldn't just change the boot disk in grub?

Or use an initramfs and /dev/disk/by-id/ to keep any future moves
stable?

thanks,

greg k-h
