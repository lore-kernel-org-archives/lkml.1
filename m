Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYGIOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYGIOtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYGIOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:48:59 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35240 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930AbYGIOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:48:58 -0400
Date: Wed, 9 Jul 2008 10:48:58 -0400
To: Robert Hancock <hancockr@shaw.ca>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
Message-ID: <20080709144858.GE31126@csclub.uwaterloo.ca>
References: <fa.Rv78KGguIBjNqcR6d0heXxceZEM@ifi.uio.no> <486DA89F.9010505@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486DA89F.9010505@shaw.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 10:35:43PM -0600, Robert Hancock wrote:
> Justin Piszcz wrote:
> >On the motherboard itself (all drives configured for AHCI)
> >
> >[    2.360648] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >[    2.678244] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> >UDMA/133
> >[    2.678594] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> >[    2.684566] ata1.00: configured for UDMA/133
> >
> >On the PCI-e cards:
> >
> >[   16.136568] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> >[   16.155682] ata11.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> >UDMA/133
> >[   16.156545] ata11.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 
> >31/32)
> >[   16.162949] ata11.00: configured for UDMA/100
> >
> >How come the PCI-e card configured the drive for UDMA/100 and not UDMA/133?
> >
> >Perhaps the PCI-e card/driver does not configure/have AHCI 
> >functionality, or?
> >
> >The mobo: Intel DG965WH
> >The card: 03:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 
> >Serial ATA Raid II Controller (rev 01)
> >
> >The hard drives are the same make/model.
> 
> Not sure exactly why that is (could be an artificial driver difference), 
> but for SATA I don't think the UDMA mode selection matters at all as far 
> as throughput. SATA uses its own flow control mechanism, and the UDMA 
> rate has no real meaning.
> 
> And no, the card is not AHCI, it's Silicon Image's own interface, which 
> has most of the same features. (I'm not aware of any AHCI add-in cards, 
> though they may exist..)

JMB363 cards.  Cute little 2 port SATA + 1 PATA in a PCIEx1.  Seems to
be detected as AHCI.

-- 
Len Sorensen
