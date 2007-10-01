Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbXJAOqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbXJAOqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXJAOq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:46:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34853 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXJAOq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:46:26 -0400
Message-ID: <47010832.8010401@pobox.com>
Date: Mon, 01 Oct 2007 10:46:10 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for wrong
 class
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> 
> PCI: nVidia's MCP61 ethernet card needs quirk for wrong class
> 
> The MCP61 ethernet controller from nVidia (NVENET_19) contains wrong
> PCI class:
> 
> 	00:07.0 Bridge [0680]: nVidia Corporation MCP61 Ethernet [10de:03ef] (rev a2)
> 
> i.e. it identifies itself as a bridge. Fix this.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

What is the problem that is present without this patch?

	Jeff



