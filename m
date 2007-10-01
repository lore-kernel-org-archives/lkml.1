Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbXJAPYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbXJAPYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXJAPYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:24:47 -0400
Received: from styx.suse.cz ([82.119.242.94]:40225 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751781AbXJAPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:24:46 -0400
Date: Mon, 1 Oct 2007 17:24:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for wrong
 class
In-Reply-To: <47010E01.2010001@pobox.com>
Message-ID: <Pine.LNX.4.64.0710011720210.7567@jikos.suse.cz>
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz> <47010832.8010401@pobox.com>
 <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz> <47010A34.9000709@pobox.com>
 <Pine.LNX.4.64.0710011656090.7567@jikos.suse.cz> <47010E01.2010001@pobox.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Jeff Garzik wrote:

> > > There are other network devices that do not claim 
> > > PCI_CLASS_NETWORK_ETHERNET either.
> > Nor any other PCI_CLASS_NETWORK subclass?
> Correct.

BTW do you have some examples off the top of your head?

> > What would you recommend as a method for userspace to detect whether 
> > given hardware is a network card, supposing that there is no driver 
> > bound to it yet?
> Note the mention of "weird cases" You come up with a general method, 
> then you have to deal with exceptions to that general method.

Sure. Still don't see why to do it in kernel, when it is hardware-related 
though.

> Another example:  8139too and 8139cp both claim to support 
> (0x10EC,0x8139) PCI IDs.  The distro installer needs additional 
> information to know to read the PCI revision, which is what determines 
> whether or not to use 8139cp driver.

That's also pretty ugly, sure.

> Sometimes life is just not as simple as you would like it to be :)

You tell me :) There is a load of quirks for individual devices that claim 
themselves to be HID-compliant, but break the specs in various different 
creative ways :)

-- 
Jiri Kosina
SUSE Labs
