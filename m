Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbXJAOuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbXJAOuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXJAOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:50:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:35088 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751904AbXJAOul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:50:41 -0400
Date: Mon, 1 Oct 2007 16:50:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for wrong
 class
In-Reply-To: <47010832.8010401@pobox.com>
Message-ID: <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz>
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz> <47010832.8010401@pobox.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Jeff Garzik wrote:

> > PCI: nVidia's MCP61 ethernet card needs quirk for wrong class
> > The MCP61 ethernet controller from nVidia (NVENET_19) contains wrong
> > PCI class:
> >  00:07.0 Bridge [0680]: nVidia Corporation MCP61 Ethernet [10de:03ef] (rev
> >  a2)
> > i.e. it identifies itself as a bridge. Fix this.
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> What is the problem that is present without this patch?

Userspace tools that are used to configure network are probable not to 
detect this device as a network card and therefore not provide means to 
configure the device (this is a case at least with yast, I don't know what 
is the situation with other configurators).

There might be also other situations, I don't know. Userspace really 
should know the proper class of the device, shouldn't it?

Thanks,

-- 
Jiri Kosina
SUSE Labs
