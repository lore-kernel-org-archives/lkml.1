Return-Path: <linux-kernel-owner+w=401wt.eu-S934205AbXGMFrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbXGMFrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933696AbXGMFrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:47:19 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48137 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500AbXGMFrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:47:18 -0400
Date: Thu, 12 Jul 2007 22:33:03 -0700
From: Greg KH <greg@kroah.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Move prototypes for EXPORT_SYMBOL functions to
	include/linux/pci.h
Message-ID: <20070713053303.GB17039@kroah.com>
References: <Pine.LNX.4.64.0707130015550.1975@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707130015550.1975@blarg.am.freescale.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:16:29AM -0500, Kumar Gala wrote:
> pci_do_scan_bus() and pci_bus_find_capability() are marked EXPORT_SYMBOL
> and thus usable outside of the PCI drive core itself.  Make the prototypes
> for these functions accessible to everyone.

Well, no, I'd like to only have the pci hotplug drivers use them if
possible.  So until we have proper namespaces on the exported symbols,
I'd really like to keep these as-is if possible.

Or are you needing these symbols for some code outside of the
drivers/pci/ directory tree?

thanks,

greg k-h
