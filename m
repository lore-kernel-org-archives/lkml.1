Return-Path: <linux-kernel-owner+w=401wt.eu-S934192AbYBMRr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbYBMRr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764700AbYBMRrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:47:42 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:15203 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbYBMRrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:47:40 -0500
Date: Wed, 13 Feb 2008 19:47:11 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: jdmason@kudzu.us, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080213174711.GB22274@rhun.haifa.ibm.com>
References: <20080213001506.GA13933@kroah.com> <20080213001638.GB13933@kroah.com> <20080213093225.GA16985@rhun.haifa.ibm.com> <20080213173203.GC10733@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213173203.GC10733@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 09:32:03AM -0800, Greg KH wrote:

> Is there some reason you aren't using the "real" PCI driver api here
> and registering a pci driver for these devices?  That would take the
> whole "loop over all pci devices" logic out of the code entirely.

I recall we had a reason, but I no longer recall what it was. Some
reason the "real" PCI driver API didn't fit at the time. If someone
were to whip up a working patch, I'd happily apply it.

> > Feel free to nuke it and walk the list forward.
> 
> So something like the patch below would be fine?

Yep, looks good. 

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
