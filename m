Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbXKDTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbXKDTbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXKDTbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:31:11 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35240 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXKDTbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:31:10 -0500
Date: Sun, 4 Nov 2007 20:31:09 +0100
From: Andreas Mohr <andim2@users.sourceforge.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-user@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
Message-ID: <20071104193109.GA4033@rhlx01.hs-esslingen.de>
Reply-To: andi@lisas.de
References: <471527E5.1050407@s5r6.in-berlin.de> <m34pgpmszu.fsf@maximus.localdomain> <47166C83.2050207@s5r6.in-berlin.de> <m3fy09ffp9.fsf@maximus.localdomain> <4719A0C4.3050301@s5r6.in-berlin.de> <m3bqausztv.fsf@maximus.localdomain> <4719FF0F.3080504@s5r6.in-berlin.de> <m3ejfp4bg9.fsf@maximus.localdomain> <4724C9DA.7030900@s5r6.in-berlin.de> <m33avvdlbq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m33avvdlbq.fsf@maximus.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Oct 28, 2007 at 09:40:41PM +0100, Krzysztof Halasa wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> 
> >> Compile with the usual spell: gcc -Wall -O2 vt6307ohciver.c -o vt6307ohciver
> >
> > I also had to specify "-lpci" on Mandrake 10.1, "-lpci -lz" on Gentoo.
> 
> Of course you're right, just typed faster than thought.
> Actually I had to add these two on Fedora, too.

And in general the pciutils-dev package should be installed.

> Ok so it seems rev 80 is VT6307 and (at least) rev 46 is VT6306.
> I think my googling for lspci reports confirms that.

As does my card:

# lspci |grep 1394
00:09.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 46)
root@andi:/tmp# ./vt6307ohciver 00:09.0
I/O region #1 is at A000
It seems your VT6307 chip is connected to 93c46 EEPROM
Page size is 4096 (0x1000) bytes
GUID PROM register address is 0xdb140004
Mapping 8 (0x8) bytes of memory at 0xdb140000
Mapped mem region #0 at virtual address 0xb7ee5000
GUID PROM register is at virtual address 0xb7ee5004

EEPROM dump:
00: 00 11 06 66 45 55 56 E1 04 04 32 55 F8 00 A2 02
10: A1 00 40 63 06 11 44 30 03 DF 40 80 00 20 00 73
20: 3C 10 00 00 00 00 FF FF FF FF FF FF FF FF FF FF

Your VT6307 chip is in OHCI 1.0 mode


And viewing from a quite problematic angle (card is in running PC,
difficult to view) strongly seems to indicate a VT630_6_ (the "6" is
quite clearly visible).
This means that I currently cannot offer any mfct. date data however,
unfortunately.

Andreas Mohr
