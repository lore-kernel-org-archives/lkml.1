Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbXJAPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbXJAPLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXJAPLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:11:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44270 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbXJAPLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:11:08 -0400
Message-ID: <47010E01.2010001@pobox.com>
Date: Mon, 01 Oct 2007 11:10:57 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for wrong
 class
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz> <47010832.8010401@pobox.com> <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz> <47010A34.9000709@pobox.com> <Pine.LNX.4.64.0710011656090.7567@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0710011656090.7567@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 1 Oct 2007, Jeff Garzik wrote:
> 
>> There are other network devices that do not claim 
>> PCI_CLASS_NETWORK_ETHERNET either.  
> 
> Nor any other PCI_CLASS_NETWORK subclass?

Correct.


>> Since this is a purely cosmetic issue -- said userland tools would need 
>> to support weird cases _anyway_ -- I am not inclined to apply the patch.
> 
> What would you recommend as a method for userspace to detect whether given 
> hardware is a network card, supposing that there is no driver bound to it 
> yet?

Note the mention of "weird cases"

You come up with a general method, then you have to deal with exceptions 
to that general method.

Another example:  8139too and 8139cp both claim to support 
(0x10EC,0x8139) PCI IDs.  The distro installer needs additional 
information to know to read the PCI revision, which is what determines 
whether or not to use 8139cp driver.

Sometimes life is just not as simple as you would like it to be :)

	Jeff

