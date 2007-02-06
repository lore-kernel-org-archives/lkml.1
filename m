Return-Path: <linux-kernel-owner+w=401wt.eu-S965242AbXBFFeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242AbXBFFeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965260AbXBFFeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:34:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49709 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242AbXBFFeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:34:09 -0500
Date: Mon, 5 Feb 2007 21:33:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Message-Id: <20070205213339.80239a22.akpm@linux-foundation.org>
In-Reply-To: <20070206050331.GB4228@colo.lackof.org>
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	<20070206045528.GA4228@colo.lackof.org>
	<20070206050331.GB4228@colo.lackof.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007 22:03:31 -0700 Grant Grundler <grundler@parisc-linux.org> wrote:

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
> 
> Slight risk some previously "working" device which violates the
> spec might get ignored...but I hope there aren't too many of those.

Should we wait two seconds before declaring the device dead?  To see whether
it will come back?
