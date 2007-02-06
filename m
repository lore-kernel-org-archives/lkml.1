Return-Path: <linux-kernel-owner+w=401wt.eu-S1750887AbXBFGZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887AbXBFGZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 01:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbXBFGZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 01:25:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:51852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbXBFGZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 01:25:25 -0500
Date: Mon, 5 Feb 2007 22:24:14 -0800
From: Greg KH <greg@kroah.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Message-ID: <20070206062414.GA8295@kroah.com>
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com> <20070206045528.GA4228@colo.lackof.org> <20070206050331.GB4228@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206050331.GB4228@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 10:03:31PM -0700, Grant Grundler wrote:
> On Mon, Feb 05, 2007 at 09:55:28PM -0700, Grant Grundler wrote:
> ...
> > > 	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> > > 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR+ <PERR+
> > > 	Latency: 0, Cache Line Size 0c
> > > 	BIST is running
> > 
> > BIST is required to complete in 2 seconds. Either with success or failure.
> > I expect BIOS to have complained before launching grub/lilo.
> 
> Gregkh,
> I just realized linux-pci bus scan should ignore devices (print a warning)
> which have BIST set.  Want a patch for this?

Yes, that would be good.

> Slight risk some previously "working" device which violates the
> spec might get ignored...but I hope there aren't too many of those.

Odds are there are probably _way_ too many devices, but it can't hurt to
at least flag them as a broken card so that they can be fixed in the
future...

thanks,

greg k-h
