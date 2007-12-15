Return-Path: <linux-kernel-owner+w=401wt.eu-S1763141AbXLOGtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763141AbXLOGtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbXLOGtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:49:40 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:44980 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbXLOGtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:49:40 -0500
Date: Sat, 15 Dec 2007 01:49:26 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: New question on that sata controller
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200712150149.27625.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

When I asked about a sata controller earlier this week, I gave a link to it.  
Unforch (maybe) when it actually arrived, the cards box showed a silicon 
image chip, and the card had a via.  So much for getting what I ordered...

The required module then was sata_via, not sata_uli, and it seems to be 
working ok.  However, this one claims its a raid controller according to an 
lspci -v:

01:0a.0 RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID Controller 
(rev 50)
        Subsystem: VIA Technologies, Inc. VT6421 IDE RAID Controller
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at 9400 [size=16]
        I/O ports at 9800 [size=16]
        I/O ports at 9c00 [size=16]
        I/O ports at a000 [size=16]
        I/O ports at a400 [size=32]
        I/O ports at a800 [size=256]
        [virtual] Expansion ROM at e9000000 [disabled] [size=64K]
        Capabilities: [e0] Power Management version 2

I just noted that the Expansion ROM is disabled, but I didn't see any jumpers 
to enable it on the card prior to installing it.  Does anyone know how this 
is supposed to work?  I would like to make it directly bootable but I believe 
this has to be 'enabled' for that.

I cannot find any references to this particular chip in a 'make xconfig' for 
2.6.24-rc5.

Should this be a concern, or is this one a 'Just Works(TM)' chipset?  This 
card has 3 sata port connectors and one ide fitted.

Two rather pleasant side effects of going to the Biostar.tw site and finding a 
newer bios and installing it on an M7NCD Pro mobo are:

1: FSB now running at 400MHZ, was 333 before as it was not at all stable at 
400 and I have been told the XP-2800 Athlon only supports 333 and AMD's site 
agrees.

2: CPU temps are down around 13F.  CPU speed still the same at 2079MHZ 
according to dmesg.

The reduced temps at a higher FSB indicates better interface timing, and if it 
runs the rest of the night at 400 without a self reboot or crash, I'll leave 
it there.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Q:	Why is it that Mexico isn't sending anyone to the '84 summer games?
A:	Anyone in Mexico who can run, swim or jump is already in LA.
