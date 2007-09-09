Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbXIIUF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbXIIUF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbXIIUEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:04:24 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51471 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbXIIUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:04:23 -0400
Date: Sun, 9 Sep 2007 10:50:59 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/pci/: possible cleanups
Message-ID: <20070909175059.GA32447@kroah.com>
References: <20070827212822.GX4121@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827212822.GX4121@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 11:28:22PM +0200, Adrian Bunk wrote:
> This patch contains the following possible cleanups:
> - make the following needlessly global function static:
>   - pci.c: pci_restore_bars()
> - #if 0 the following unused global functions:
>   - rom.c: pci_map_rom_copy()
>   - rom.c: pci_remove_rom()
> - remove the following unused EXPORT_SYMBOL's:
>  - pci-acpi.c: pci_osc_support_set
>  - proc.c: pci_proc_detach_bus
> - remove the following unused EXPORT_SYMBOL_GPL's:
>   - bus.c: pci_walk_bus
>   - probe.c: pci_create_bus
>   - setup-res.c: pci_claim_resource

Care to split this up into 4 different patches so as to make it easier
for people in case they cause problems in the future?

thanks,

greg k-h
