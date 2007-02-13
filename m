Return-Path: <linux-kernel-owner+w=401wt.eu-S1750730AbXBMPrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750730AbXBMPrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXBMPra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:47:30 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:36804 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730AbXBMPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:47:30 -0500
Date: Tue, 13 Feb 2007 10:47:28 -0500
To: Raphael Assenat <raph@8d.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add PCI device ID for IT8152 RISC-to-PCI chip
Message-ID: <20070213154728.GM7584@csclub.uwaterloo.ca>
References: <45CCD60D.5050001@8d.com> <20070209212856.GK7584@csclub.uwaterloo.ca> <45D1CF22.6010706@8d.com> <20070213151633.GL7584@csclub.uwaterloo.ca> <20070213153029.GB15227@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213153029.GB15227@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 03:30:29PM +0000, Russell King wrote:
> On Tue, Feb 13, 2007 at 10:16:33AM -0500, Lennart Sorensen wrote:
> > There doesn't seem to be very many
> > arm systems with PCI, so it's hard to tell.
> 
> NetWinder, EBSA285 (which the NetWinder is a derivative of), the N2100,
> etc are PCI based and are all well proven in the field.

Which PCI controller do they use?

> However, I have come across issues with what I suspect are buggy
> bridges - some southbridges require out of band cache control
> signalling and don't behave properly if you don't provide this (despite
> having modes to disable such signalling) and some PCMCIA bridges which
> don't like delayed read responses from host bridges.

Well certainly on the cpu board we were trying out, it didn't work,
whether it was a buggy PCI bridge, or a bad design I am not sure.  I
suspect the chip.

> That said, I've an EBSA285 with Promise UDMA, 3com NIC, S3 VGA and a
> plug-in southbridge card which has been running since about 1999 or so
> and the only real data corruption problem I've heard of was when a track
> on my Promise UDMA card was eaten by the sticky label resulting in silent
> corruption of writes to the disks.

Ouch.

> (I did consider replacing the Promise UDMA card, but the IT821x card
> I bought to replace it didn't have all the pins on the chip soldered
> down - to the extent that even a PC couldn't recognise the PCI card.
> So I'm running on the assumption that the self-repaired Promise UDMA
> card is all round going to be more reliable than the as yet unproven
> IT821x card.)

And they shipped a card in that state?

--
Len Sorensen
