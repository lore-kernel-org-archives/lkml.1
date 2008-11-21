Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYKULdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYKULdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYKULdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:33:39 -0500
Received: from lucidpixels.com ([75.144.35.66]:43351 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbYKULdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:33:38 -0500
Date: Fri, 21 Nov 2008 06:33:37 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Peter Rabbitson <rabbit+list@rabbit.us>
cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, smartmontools-support@lists.sourceforge.net,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: Ninth(?) Velociraptor replacement or md(RAID)/smartmontools(?)
 bug?
In-Reply-To: <49269BCF.8060300@rabbit.us>
Message-ID: <alpine.DEB.1.10.0811210632130.5577@p34.internal.lan>
References: <alpine.DEB.1.10.0811210600310.5577@p34.internal.lan> <49269BCF.8060300@rabbit.us>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Nov 2008, Peter Rabbitson wrote:

> It might very well be a WD bug. I had three (3) identical WDC
> WD2500AAJS-08B4A0 drives fail on me with the same _identical_ error
> (same sector number to the last digit):
>
> Oct 27 11:33:41 Arzamas kernel: ata6.00: exception Emask 0x10 SAct 0x0
> SErr 0x80000 action 0xe frozen
> Oct 27 11:33:41 Arzamas kernel: ata6.00: irq_stat 0x01100010, PHY RDY
> changed
> Oct 27 11:33:41 Arzamas kernel: ata6: SError: { 10B8B }
> Oct 27 11:33:41 Arzamas kernel: ata6.00: cmd
> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Oct 27 11:33:41 Arzamas kernel: res 06/37:00:00:00:00/00:00:00:00:06/00
> Emask 0x12 (ATA bus error)
> Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }
> Oct 27 11:33:41 Arzamas kernel: ata6: hard resetting link
> Oct 27 11:33:46 Arzamas kernel: ata6: SATA link up 3.0 Gbps (SStatus 123
> SControl 0)
> Oct 27 11:33:46 Arzamas kernel: ata6.00: configured for UDMA/100
> Oct 27 11:33:46 Arzamas kernel: ata6: EH complete
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] 488397168 512-byte
> hardware sectors (250059 MB)
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write Protect is off
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Oct 27 11:33:46 Arzamas kernel: end_request: I/O error, dev sde, sector
> 488166955
> Oct 27 11:33:46 Arzamas kernel: md: super_written gets error=-5, uptodate=0
>
>
> All 3 drives endured the same multiple rewriting of the sector in
> question, as they did multiple smart self-tests. I am currently in the
> process of replacing these two drives with Seagates, (the other 2 in the
> 4 member array are Maxtors). Will see what happens.
>
> Peter
>
> P.S. See threads http://marc.info/?l=linux-raid&m=122523835815697 and
> http://marc.info/?l=linux-raid&m=122669103213041 for more info on my

Pete,

Are these -new- 250GiB drives, recently purchased?

# hdparm -iv /dev/sda
  Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

What does yours conform to, just curious?

Justin.

