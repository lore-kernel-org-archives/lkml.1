Return-Path: <linux-kernel-owner+w=401wt.eu-S1765062AbXEUXF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765062AbXEUXF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXEUXFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:05:49 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:60808 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757476AbXEUXFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:05:48 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705212305.l4LN5irk008924@turbo.physics.adelaide.edu.au>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
To: hancockr@shaw.ca (Robert Hancock)
Date: Tue, 22 May 2007 08:35:43 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org
In-Reply-To: <465150C2.4080006@shaw.ca> from "Robert Hancock" at May 21, 2007 01:56:50 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jonathan Woithe wrote:
> > I've just tried a quick test after enabling most of the PATA drivers under
> > the libata section including the Jmicron driver (basically everything except
> > those labelled "highly experimental").  As far as I can tell the
> > CDROM/DVDROM is still not detected even with all these built into the
> > kernel.  Maybe I do need one of those "highly experimental" drivers.
> 
> Can you post the entire lspci -v for this board?

Sure.  Here it is:

00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 02)
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82G965 Integrated Graphics Controller (rev 02) (prog-if 00 [VGA])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at 90200000 (32-bit, non-prefetchable) [size=1M]
	Memory at 80000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 2140 [size=8]
	Capabilities: [90] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
	Capabilities: [d0] Power Management version 2

00:03.0 Communication controller: Intel Corporation 82P965/G965 HECI Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at 90325900 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
	Capabilities: [8c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-

00:19.0 Ethernet controller: Intel Corporation 82566DC Gigabit Network Connection (rev 02)
	Subsystem: Intel Corporation Unknown device 0001
	Flags: bus master, fast devsel, latency 0, IRQ 218
	Memory at 90300000 (32-bit, non-prefetchable) [size=128K]
	Memory at 90324000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at 20c0 [size=32]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 0, IRQ 17
	I/O ports at 20a0 [size=32]

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #5 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at 2080 [size=32]

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #2 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 0, IRQ 18
	Memory at 90325400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 2503
	Flags: bus master, fast devsel, latency 0, IRQ 23
	Memory at 90320000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
	Capabilities: [70] Express Unknown type IRQ 0

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	Memory behind bridge: 90400000-904fffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 90100000-901fffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: 90500000-905fffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Memory behind bridge: 90600000-906fffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Memory behind bridge: 90700000-907fffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 2060 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 2040 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 2020 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #1 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 0, IRQ 21
	Memory at 90325000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
	Memory behind bridge: 90000000-900fffff
	Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 82801HH (ICH8DH) LPC Interface Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port SATA IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 2138 [size=8]
	I/O ports at 2154 [size=4]
	I/O ports at 2130 [size=8]
	I/O ports at 2150 [size=4]
	I/O ports at 2110 [size=16]
	I/O ports at 2100 [size=16]
	Capabilities: [70] Power Management version 3

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 514d
	Flags: medium devsel, IRQ 20
	Memory at 90325800 (32-bit, non-prefetchable) [size=256]
	I/O ports at 2000 [size=32]

00:1f.5 IDE interface: Intel Corporation 82801H (ICH8 Family) 2 port SATA IDE Controller (rev 02) (prog-if 85 [Master SecO PriO])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 2128 [size=8]
	I/O ports at 214c [size=4]
	I/O ports at 2120 [size=8]
	I/O ports at 2148 [size=4]
	I/O ports at 20f0 [size=16]
	I/O ports at 20e0 [size=16]
	Capabilities: [70] Power Management version 3

02:00.0 IDE interface: Marvell Technology Group Ltd. Unknown device 6101 (rev b1) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Marvell Technology Group Ltd. Unknown device 6101
	Flags: bus master, fast devsel, latency 0, IRQ 10
	I/O ports at 1018 [size=8]
	I/O ports at 1024 [size=4]
	I/O ports at 1010 [size=8]
	I/O ports at 1020 [size=4]
	I/O ports at 1000 [size=16]
	Memory at 90100000 (32-bit, non-prefetchable) [size=512]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
	Capabilities: [e0] Express Legacy Endpoint IRQ 0

06:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: Intel Corporation Unknown device 514d
	Flags: bus master, medium devsel, latency 32, IRQ 19
	Memory at 90004000 (32-bit, non-prefetchable) [size=2K]
	Memory at 90000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2

> > How can you tell from the Linux boot messages that the controller is in
> > AHCI mode - is it as simple as looking for AHCI driver messages?  In
> > this case the
> > 
> >   scsi0 : ata_piix
> >   scsi1 : ata_piix
> > 
> > indicate that things are suboptimal I assume.
> 
> Right, you should see that showing up as ahci.

Does this apply to *all* SATA controllers or just these ICHx ones from
Intel?  In other words, should all optimally configured SATA controllers
be in AHCI mode?

Regards
  jonathan
--
"Time is an illusion; lunchtime doubly so"
