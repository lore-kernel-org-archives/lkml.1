Return-Path: <linux-kernel-owner+w=401wt.eu-S933357AbXGMGGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbXGMGGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbXGMGGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:06:01 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46561 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXGMGGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:06:00 -0400
Date: Thu, 12 Jul 2007 23:05:11 -0700
From: Greg KH <greg@kroah.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Move prototypes for EXPORT_SYMBOL functions to
	include/linux/pci.h
Message-ID: <20070713060511.GA23618@kroah.com>
References: <Pine.LNX.4.64.0707130015550.1975@blarg.am.freescale.net> <20070713053303.GB17039@kroah.com> <9A567C91-1DE7-46CC-91A0-58D498B8248B@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9A567C91-1DE7-46CC-91A0-58D498B8248B@kernel.crashing.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:55:39AM -0500, Kumar Gala wrote:
> 
>  On Jul 13, 2007, at 12:33 AM, Greg KH wrote:
> 
> > On Fri, Jul 13, 2007 at 12:16:29AM -0500, Kumar Gala wrote:
> >> pci_do_scan_bus() and pci_bus_find_capability() are marked EXPORT_SYMBOL
> >> and thus usable outside of the PCI drive core itself.  Make the prototypes
> >> for these functions accessible to everyone.
> >
> > Well, no, I'd like to only have the pci hotplug drivers use them if
> > possible.  So until we have proper namespaces on the exported symbols,
> > I'd really like to keep these as-is if possible.
> >
> > Or are you needing these symbols for some code outside of the
> > drivers/pci/ directory tree?
> 
>  I need pci_bus_find_capability() in arch/powerpc pci code.
> 
>  I'm using it as a way to tell if we are a PCIe PHB.

Ok, care to export only that function then?

thanks,

greg k-h
