Return-Path: <linux-kernel-owner+w=401wt.eu-S1750809AbXBMQVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750809AbXBMQVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXBMQVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:21:07 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2943 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbXBMQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:21:06 -0500
Date: Tue, 13 Feb 2007 16:20:57 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Raphael Assenat <raph@8d.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add PCI device ID for IT8152 RISC-to-PCI chip
Message-ID: <20070213162057.GC15227@flint.arm.linux.org.uk>
Mail-Followup-To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Raphael Assenat <raph@8d.com>, linux-kernel@vger.kernel.org
References: <45CCD60D.5050001@8d.com> <20070209212856.GK7584@csclub.uwaterloo.ca> <45D1CF22.6010706@8d.com> <20070213151633.GL7584@csclub.uwaterloo.ca> <20070213153029.GB15227@flint.arm.linux.org.uk> <20070213154728.GM7584@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213154728.GM7584@csclub.uwaterloo.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 10:47:28AM -0500, Lennart Sorensen wrote:
> On Tue, Feb 13, 2007 at 03:30:29PM +0000, Russell King wrote:
> > On Tue, Feb 13, 2007 at 10:16:33AM -0500, Lennart Sorensen wrote:
> > > There doesn't seem to be very many
> > > arm systems with PCI, so it's hard to tell.
> > 
> > NetWinder, EBSA285 (which the NetWinder is a derivative of), the N2100,
> > etc are PCI based and are all well proven in the field.
> 
> Which PCI controller do they use?

NetWinder and EBSA285 are DC21285 (footbridge).  The N2100 is IOP32x
based.  As for gluing a PCI bridge to something not designed for PCI
(eg, a PXA255) I can't comment.

> > (I did consider replacing the Promise UDMA card, but the IT821x card
> > I bought to replace it didn't have all the pins on the chip soldered
> > down - to the extent that even a PC couldn't recognise the PCI card.
> > So I'm running on the assumption that the self-repaired Promise UDMA
> > card is all round going to be more reliable than the as yet unproven
> > IT821x card.)
> 
> And they shipped a card in that state?

Indeed. :(

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
