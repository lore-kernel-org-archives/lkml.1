Return-Path: <linux-kernel-owner+w=401wt.eu-S1750749AbXBMPam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750749AbXBMPam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXBMPam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:30:42 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4436 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXBMPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:30:41 -0500
Date: Tue, 13 Feb 2007 15:30:29 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Raphael Assenat <raph@8d.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add PCI device ID for IT8152 RISC-to-PCI chip
Message-ID: <20070213153029.GB15227@flint.arm.linux.org.uk>
Mail-Followup-To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Raphael Assenat <raph@8d.com>, linux-kernel@vger.kernel.org
References: <45CCD60D.5050001@8d.com> <20070209212856.GK7584@csclub.uwaterloo.ca> <45D1CF22.6010706@8d.com> <20070213151633.GL7584@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213151633.GL7584@csclub.uwaterloo.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 10:16:33AM -0500, Lennart Sorensen wrote:
> There doesn't seem to be very many
> arm systems with PCI, so it's hard to tell.

NetWinder, EBSA285 (which the NetWinder is a derivative of), the N2100,
etc are PCI based and are all well proven in the field.

However, I have come across issues with what I suspect are buggy
bridges - some southbridges require out of band cache control
signalling and don't behave properly if you don't provide this (despite
having modes to disable such signalling) and some PCMCIA bridges which
don't like delayed read responses from host bridges.

That said, I've an EBSA285 with Promise UDMA, 3com NIC, S3 VGA and a
plug-in southbridge card which has been running since about 1999 or so
and the only real data corruption problem I've heard of was when a track
on my Promise UDMA card was eaten by the sticky label resulting in silent
corruption of writes to the disks.

(I did consider replacing the Promise UDMA card, but the IT821x card
I bought to replace it didn't have all the pins on the chip soldered
down - to the extent that even a PC couldn't recognise the PCI card.
So I'm running on the assumption that the self-repaired Promise UDMA
card is all round going to be more reliable than the as yet unproven
IT821x card.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
