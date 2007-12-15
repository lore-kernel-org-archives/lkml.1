Return-Path: <linux-kernel-owner+w=401wt.eu-S1763655AbXLOUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763655AbXLOUAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 15:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbXLOUAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 15:00:32 -0500
Received: from softmonsters.com ([213.239.220.73]:49497 "EHLO
	mail.softmonsters.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbXLOUAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 15:00:31 -0500
X-Greylist: delayed 1207 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Dec 2007 15:00:31 EST
Message-ID: <47642D9A.4080600@softmonsters.com>
Date: Sat, 15 Dec 2007 20:40:10 +0100
From: Zsolt Barat <zsolt@softmonsters.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: ATA bus error with external hd on esata
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi list,
i just bought a "MyBook" called external HD with a fixed enclosure, from
WD. Connected to the SATA port i constantly get "ATA bus error" messages
in the kernel log. Is this a known issue?

/var/log/messages:
Dec 15 18:37:53 proto1 ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0
action 0x2
Dec 15 18:37:53 proto1 ata2.00: irq_stat 0x40000001
Dec 15 18:37:53 proto1 ata2.00: cmd 35/00:e0:a7:d2:01/00:01:33:00:00/e0
tag 0 cdb 0x0 data 245760 out
Dec 15 18:37:53 proto1 res 51/84:00:86:d4:01/00:00:33:00:00/e0 Emask
0x10 (ATA bus error)
Dec 15 18:37:54 proto1 ata2: soft resetting port
Dec 15 18:37:54 proto1 ata2: SATA link up 1.5 Gbps (SStatus 113 SControl
310)
Dec 15 18:37:54 proto1 ata2.00: configured for UDMA/33
Dec 15 18:37:54 proto1 ata2: EH complete
Dec 15 18:37:54 proto1 sd 1:0:0:0: [sdb] 976773168 512-byte hardware
sectors (500108 MB)
Dec 15 18:37:54 proto1 sd 1:0:0:0: [sdb] Write Protect is off
Dec 15 18:37:54 proto1 sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Dec 15 18:37:54 proto1 sd 1:0:0:0: [sdb] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Dec 15 18:38:15 proto1 ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0
action 0x2
Dec 15 18:38:15 proto1 ata2.00: irq_stat 0x40000001
Dec 15 18:38:15 proto1 ata2.00: cmd 35/00:80:bf:09:14/00:01:33:00:00/e0
tag 0 cdb 0x0 data 196608 out
Dec 15 18:38:15 proto1 res 51/84:00:3e:0b:14/00:00:33:00:00/e0 Emask
0x10 (ATA bus error)
Dec 15 18:38:15 proto1 ata2: soft resetting port
Dec 15 18:38:15 proto1 ata2: SATA link up 1.5 Gbps (SStatus 113 SControl
310)
Dec 15 18:38:15 proto1 ata2.00: configured for UDMA/33
Dec 15 18:38:15 proto1 ata2: EH complete
Dec 15 18:38:15 proto1 sd 1:0:0:0: [sdb] 976773168 512-byte hardware
sectors (500108 MB)
Dec 15 18:38:15 proto1 sd 1:0:0:0: [sdb] Write Protect is off
Dec 15 18:38:15 proto1 sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Dec 15 18:38:15 proto1 sd 1:0:0:0: [sdb] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA

lspci:
00:00.0 Host bridge: ATI Technologies Inc Unknown device 7910
00:01.0 PCI bridge: ATI Technologies Inc Unknown device 7912
00:07.0 PCI bridge: ATI Technologies Inc Unknown device 7917
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 13)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SB600 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon X1200 Series
01:05.2 Audio device: ATI Technologies Inc Radeon X1200 Series Audio
Controller
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
03:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev c0)

thanks and best regards

zsolt

