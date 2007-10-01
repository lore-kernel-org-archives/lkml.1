Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXJAPDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXJAPDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXJAPC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:02:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:37494 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751806AbXJAPCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:02:55 -0400
Date: Mon, 1 Oct 2007 17:01:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for wrong
 class
In-Reply-To: <47010A34.9000709@pobox.com>
Message-ID: <Pine.LNX.4.64.0710011656090.7567@jikos.suse.cz>
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz> <47010832.8010401@pobox.com>
 <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz> <47010A34.9000709@pobox.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Jeff Garzik wrote:

> There are other network devices that do not claim 
> PCI_CLASS_NETWORK_ETHERNET either.  

Nor any other PCI_CLASS_NETWORK subclass?

> Since this is a purely cosmetic issue -- said userland tools would need 
> to support weird cases _anyway_ -- I am not inclined to apply the patch.

What would you recommend as a method for userspace to detect whether given 
hardware is a network card, supposing that there is no driver bound to it 
yet?

> The kernel could do a lot to make things "prettier," but that would lead 
> to lots of additional code bloat.  It's easier to export the world as it 
> is, and let the chips fall where they may.

OK, I don't seem to agree with you on this matter, let's wait for Greg's 
oppinion.

Thanks,

-- 
Jiri Kosina
SUSE Labs
