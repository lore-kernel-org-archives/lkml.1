Return-Path: <linux-kernel-owner+w=401wt.eu-S1761668AbXKDDU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668AbXKDDU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 23:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXKDDUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 23:20:18 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:56586 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXKDDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 23:20:17 -0400
Date: Sat, 3 Nov 2007 22:20:06 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Elimar Riesebieter <riesebie@lxtec.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.24-rc1 freezes on powerbook at first boot stage
Message-ID: <20071104032006.GG9695@localdomain>
References: <20071024120739.GA4897@aragorn.home.lxtec.de> <20071024124109.GA9442@frodo.home.lxtec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024124109.GA9442@frodo.home.lxtec.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing linuxppc-dev, see
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg221770.html
for original post and .config)

Elimar Riesebieter wrote:
> On Wed, 24 Oct 2007 the mental interface of
> Elimar Riesebieter told:
> 
> [...]
> > The kernel is loaded from firmware but freezes at the moment to load
> > the radeon framebuffer. I can't get any debug info (don't know
> > how?).
> 
> Screen dump till freeze:
> 
> Using PowerMac machine description
> Total memory = 1024MB; using 2048kB for hash table (at cfe00000)
> Linux version 2.6.24-rc1-aragorn (riesebie@aragorn) (gcc version 4.2.3 20071014 (prelelease) (Debian 4.2.2-3)) #1 Wed Oct 24 12:48:27 CEST 2007
> Found UniNorth memory controller & host bridge @ 0xf8000000 revision: 0xd2
> Mapped at 0xfdfc0000
> Found a Intrepid mac-io controller, rev: 0, mapped at 0xfdf40000
> PowerMac motherboard: PowerBook G4 15"
> console [udbg0] enabled
> setup_arch: bootmem
> Found UniNorth PCI host bridge at 0x00000000f0000000. Firmware bus number: 0->1
> Found UniNorth PCI host bridge at 0x00000000f2000000. Firmware bus number: 0->1
> Found UniNorth PCI host bridge at 0x00000000f4000000. Firmware bus number: 0->1
> via-pmu: Server Mode is disabled
> PMU driver v2 initialized for Core99, firmware: 0c
> nvram: Checking bank 0...
> nvram: gen0=741, gen1=740
> nvram: Active bank is: 0
> nvram: OF partition at 0x410
> nvram: XP partition at 0x1020
> nvram: NR partition at 0x1120
> arch: exit
> Zone PFN ranges:
>   DMA             0 ->   196608
>   Normal     196608 ->   196608
>   HighMem    196608 ->   262144
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   262144
> Built 1 zonelists in Zone order.  Total pages: 260096
> Kernel command line: root=/pci@f4000000/ata-6@d/disk@0:5 root=/dev/hda5
> mpic: Setting up MPIC " MPIC 1   " version 1.2 at 80040000, max 4 CPUs
> mpic: ISU size: 64, shift: 6, mask: 3f
> mpic: Initializing for 64 sources
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> GMT Delta read from XPRAM: 0 minutes, DST: off
> clocksource: timebase mult[d9038e4] shift [22] registered
> clockevent: decremeter mult[4b7] shift[16] cpu[0]
> Console: colour dummy device 80x25
> console handover: boot [udbg0] -> real [tty0]

Does 2.6.23 (or any earlier kernel) work?

