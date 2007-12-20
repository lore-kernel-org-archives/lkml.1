Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXLTV7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXLTV7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXLTV64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:58:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:47150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbXLTV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:58:55 -0500
Date: Thu, 20 Dec 2007 13:57:19 -0800
From: Greg KH <gregkh@suse.de>
To: Tony Camuso <tcamuso@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220215719.GA8528@suse.de>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <476AB3B5.9080808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AB3B5.9080808@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 01:25:57PM -0500, Tony Camuso wrote:
> Appended below is a code snippet embedded in the RHEL version of 
> mmconfig.c,
> for both i386 and x86_64. It does not encompass all the systems that have
> (or will have) problems with mmconf. Only HP platforms are listed, but I
> believe there are others.
>
> The reason the HP platforms got caught is they put these devices beyond
> bus 16, where they would have been trapped, and the problem would have
> been avoided.

Any reason why these changes were never submitted to the upstream kernel
versions?  Or do you all just want to keep patching your newer releases
with this information forever?  :)

Please send these kinds of changes upstream...

>>> The one device we know about that throws exceptions is the 830M/MG
>>> graphics chip. This chip passes the read-compare test, so the code
>>> merrily advances to bus sizing. When the bus sizing code writes the
>>> BAR at offset 0x18 in this device, the system hangs.
>> So it doesn't work at all, with or without this patch?  Does the vendor
>> know about this?
>> thanks,
>> greg k-h
>
> I have talked to intel about this, but they haven't gotten back to me.

Try poking them harder, they are usually very responsive to Linux kernel
issues.

thanks,

greg k-h
