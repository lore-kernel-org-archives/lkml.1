Return-Path: <linux-kernel-owner+w=401wt.eu-S934832AbXGMFzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832AbXGMFzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbXGMFzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:55:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:43700 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXGMFzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:55:23 -0400
In-Reply-To: <20070713053303.GB17039@kroah.com>
References: <Pine.LNX.4.64.0707130015550.1975@blarg.am.freescale.net> <20070713053303.GB17039@kroah.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9A567C91-1DE7-46CC-91A0-58D498B8248B@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] PCI: Move prototypes for EXPORT_SYMBOL functions to include/linux/pci.h
Date: Fri, 13 Jul 2007 00:55:39 -0500
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 13, 2007, at 12:33 AM, Greg KH wrote:

> On Fri, Jul 13, 2007 at 12:16:29AM -0500, Kumar Gala wrote:
>> pci_do_scan_bus() and pci_bus_find_capability() are marked  
>> EXPORT_SYMBOL
>> and thus usable outside of the PCI drive core itself.  Make the  
>> prototypes
>> for these functions accessible to everyone.
>
> Well, no, I'd like to only have the pci hotplug drivers use them if
> possible.  So until we have proper namespaces on the exported symbols,
> I'd really like to keep these as-is if possible.
>
> Or are you needing these symbols for some code outside of the
> drivers/pci/ directory tree?

I need pci_bus_find_capability() in arch/powerpc pci code.

I'm using it as a way to tell if we are a PCIe PHB.

- k
