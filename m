Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbXKMW5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbXKMW5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759981AbXKMW5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:57:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:34563 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759828AbXKMW5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:57:39 -0500
Date: Tue, 13 Nov 2007 14:56:05 -0800
From: Greg KH <gregkh@suse.de>
To: Rick Jones <rick.jones2@hp.com>
Cc: Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>,
       kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113225605.GA2589@suse.de>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113202154.GA22812@ldl.fc.hp.com> <20071113202632.GA3227@kroah.com> <473A2A61.7030303@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473A2A61.7030303@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 02:51:13PM -0800, Rick Jones wrote:
> Greg KH wrote:
>> Doesn't /sys/firmware/acpi give you raw access to the correct tables
>> already?
>> And isn't there some other tool that dumps the raw ACPI tables?  I
>> thought the acpi developers used it all the time when debugging things
>> with users.
>
> I'm neither an acpi developer (well I don't think that I am :) nor an
> end-user, but here are the two things for which I was going to use the
> information being presented by Alex's patch:
>
> 1) a not-yet, but on track to be released tool to be used by end-users
> to diagnose I/O bottlenecks - the information in
> /sys/bus/pci/slot/<foo>/address would be used to associated interfaces
> and/or pci busses etc with something the end user would grok - the
> number next to the slot.
>
> 2) I was also going to get the folks doing installers to make use of the
> "end-user" slot ID. Even without going to the extreme of the
> aforementioned 192 slot system, an 8 slot system with a bunch of
> dual-port NICs in it (for example) is going to present this huge list of
> otherwise identical entries. Even if the installers show the MAC for a
> NIC (or I guess a WWN for an HBA or whatnot) that still doesn't tell one
> without prior knowledge of what MACs were installed in which slot, which
> slot is associated with a given ethN. Having the end-user slot ID
> visible is then going to be a great help to that poor admin who is doing
> the install.

Why not just use the code in the linux firmware kit that does this
already today from userspace (thanks to Kristen for pointing this out to
me on irc.)?

No kernel changes needed, and you can get started on your userspace
application today, will work on all distros, no problems at all :)

thanks,

greg k-h
