Return-Path: <linux-kernel-owner+w=401wt.eu-S1030704AbXAZCLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030704AbXAZCLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030705AbXAZCLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:11:40 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41776 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030704AbXAZCLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:11:40 -0500
Message-ID: <45B96354.7050401@pobox.com>
Date: Thu, 25 Jan 2007 21:11:32 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <dwmw2@infradead.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
References: <20070125150905.652f9ce2@localhost.localdomain>  <1169741658.3593.98.camel@shinybook.infradead.org>  <20070125172739.0c990a9a@localhost.localdomain>  <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org> <1169770985.3593.146.camel@shinybook.infradead.org> <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org> <45B95D3A.10108@pobox.com> <Pine.LNX.4.64.0701251751380.25027@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701251751380.25027@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So *if* you use the new "iomap" interfaces, and the new "pci_iomap()" 
> things, that should actually not just allow drivers (like the ATA layer) 
> to share much more code between the PIO and MMIO cases, but it hopefully 
> actually makes it easier for strange architectures to do it all.


Another aside:  Tejun took my libata iomap and came up with something 
I'm quite happy with, so libata will /finally/ switch over to using the 
new iomap interfaces for 98% of all drivers, as of 2.6.21.

Look at "[PATCHSET] Managed device resources, take #3" on LKML if you're 
interested.  Tejun's 'devres' stuff makes it a lot easier for drivers to 
reserve, map, unmap, and free various hardware resources.

	Jeff


