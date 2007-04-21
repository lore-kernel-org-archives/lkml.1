Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXDUArQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXDUArQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXDUArQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:47:16 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:50790 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbXDUArO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YlhF5gif310SjOqmTUGnNfHNecjymOzmy3DrmgiQHP7z4Pw6POBxbUwpcfXAJj5JvtzjzMvlmf7KAAgHy3Nk1volNLlpcvkM1oB02bkQPipHHiZ+/NIO9gkhfujdBfDBlKKKI6S37MW0cJtjLE1MIJX0/49QI/w4mRU/LTqamws=
Message-ID: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com>
Date: Fri, 20 Apr 2007 19:47:13 -0500
From: "Marcos Pinto" <markybob@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20.7 locking up hard on boot
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not subscribed, so please personally CC me any answers/comments.
Thank you.

While booting, (AMD64 Turion x2) 2.6.20.7 kernel locks up hard.  The
last kernel that I tried, 2.6.18.8, worked perfectly without any
trickery.  2.6.20.7 only boots up with "acpi=off" being added to the
kernel line.  Note that 2.6.18.8 works perfectly with acpi on, which
is really the
only way I can run this box because with "acpi=off" it overheats and freezes.
Please let me know if there's anything else that I could do to help with this.


Here's what's on the screen when it happens:

Brought up 2 CPUs
testing NMI watchdog ... OK.
Disabling vsyscall due to  use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 1808.264 MHz processor.
migration_cost=281
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000
PCI: No mmconfig possible on device 00:18
PCI: No mmconfig possible on device 07:05
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
0000:00:0d.0: cannot adjust BAR0 (not I/O)
0000:00:0d.0: cannot adjust BAR1 (not I/O)

lspci -nn
00:00.0 RAM memory [0500]: nVidia Corporation C51 Host Bridge
[10de:02f7] (rev a2)
00:00.1 RAM memory [0500]: nVidia Corporation C51 Memory Controller 0
[10de:02fa] (rev a2)
00:00.2 RAM memory [0500]: nVidia Corporation C51 Memory Controller 1
[10de:02fe] (rev a2)
00:00.3 RAM memory [0500]: nVidia Corporation C51 Memory Controller 5
[10de:02f8] (rev a2)
00:00.4 RAM memory [0500]: nVidia Corporation C51 Memory Controller 4
[10de:02f9] (rev a2)
00:00.5 RAM memory [0500]: nVidia Corporation C51 Host Bridge
[10de:02ff] (rev a2)
00:00.6 RAM memory [0500]: nVidia Corporation C51 Memory Controller 3
[10de:027f] (rev a2)
00:00.7 RAM memory [0500]: nVidia Corporation C51 Memory Controller 2
[10de:027e] (rev a2)
00:02.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge
[10de:02fc] (rev a1)
00:03.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge
[10de:02fd] (rev a1)
00:04.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge
[10de:02fb] (rev a1)
00:09.0 RAM memory [0500]: nVidia Corporation MCP51 Host Bridge
[10de:0270] (rev a2)
00:0a.0 ISA bridge [0601]: nVidia Corporation MCP51 LPC Bridge
[10de:0260] (rev a3)
00:0a.1 SMBus [0c05]: nVidia Corporation MCP51 SMBus [10de:0264] (rev a3)
00:0a.3 Co-processor [0b40]: nVidia Corporation MCP51 PMU [10de:0271] (rev a3)
00:0b.0 USB Controller [0c03]: nVidia Corporation MCP51 USB Controller
[10de:026d] (rev a3)
00:0b.1 USB Controller [0c03]: nVidia Corporation MCP51 USB Controller
[10de:026e] (rev a3)
00:0d.0 IDE interface [0101]: nVidia Corporation MCP51 IDE [10de:0265] (rev f1)
00:0e.0 IDE interface [0101]: nVidia Corporation MCP51 Serial ATA
Controller [10de:0266] (rev f1)
00:10.0 PCI bridge [0604]: nVidia Corporation MCP51 PCI Bridge
[10de:026f] (rev a2)
00:10.1 Audio device [0403]: nVidia Corporation MCP51 High Definition
Audio [10de:026c] (rev a2)
00:14.0 Bridge [0680]: nVidia Corporation MCP51 Ethernet Controller
[10de:0269] (rev a3)
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control [1022:1103]
03:00.0 Network controller [0280]: Broadcom Corporation Dell Wireless
1390 WLAN Mini-PCI Card [14e4:4311] (rev 01)
05:00.0 VGA compatible controller [0300]: nVidia Corporation GeForce
Go 7200 [10de:01d6] (rev a1)
07:05.0 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394
Controller [1180:0832]
07:05.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822
SD/SDIO/MMC/MS/MSPro Host Adapter [1180:0822] (rev 19)
07:05.2 System peripheral [0880]: Ricoh Co Ltd Unknown device
[1180:0843] (rev 01)
07:05.3 System peripheral [0880]: Ricoh Co Ltd R5C592 Memory Stick Bus
Host Adapter [1180:0592] (rev 0a)
07:05.4 System peripheral [0880]: Ricoh Co Ltd xD-Picture Card
Controller [1180:0852] (rev 05)

lspci -vnn
00:00.0 RAM memory [0500]: nVidia Corporation C51 Host Bridge
[10de:02f7] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
        Capabilities: [e0] HyperTransport: MSI Mapping

00:00.1 RAM memory [0500]: nVidia Corporation C51 Memory Controller 0
[10de:02fa] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: 66MHz, fast devsel

00:00.2 RAM memory [0500]: nVidia Corporation C51 Memory Controller 1
[10de:02fe] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: 66MHz, fast devsel

00:00.3 RAM memory [0500]: nVidia Corporation C51 Memory Controller 5
[10de:02f8] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: 66MHz, fast devsel

00:00.4 RAM memory [0500]: nVidia Corporation C51 Memory Controller 4
[10de:02f9] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0

00:00.5 RAM memory [0500]: nVidia Corporation C51 Host Bridge
[10de:02ff] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0
        Capabilities: [44] #00 [00fe]
        Capabilities: [fc] #00 [0000]

00:00.6 RAM memory [0500]: nVidia Corporation C51 Memory Controller 3
[10de:027f] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: 66MHz, fast devsel

00:00.7 RAM memory [0500]: nVidia Corporation C51 Memory Controller 2
[10de:027e] (rev a2)
        Flags: 66MHz, fast devsel

00:02.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge
[10de:02fc] (rev a1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: c0200000-c03fffff
        Prefetchable memory behind bridge: 00000000c3200000-00000000c33fffff
        Capabilities: [40] Subsystem: nVidia Corporation Unknown
device [10de:0000]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
        Capabilities: [100] Virtual Channel

00:03.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge
[10de:02fd] (rev a1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Memory behind bridge: c0400000-c05fffff
        Capabilities: [40] Subsystem: nVidia Corporation Unknown
device [10de:0000]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
        Capabilities: [100] Virtual Channel

00:04.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge
[10de:02fb] (rev a1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        Memory behind bridge: c1000000-c2ffffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Capabilities: [40] Subsystem: nVidia Corporation Unknown
device [10de:0000]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
        Capabilities: [100] Virtual Channel

00:09.0 RAM memory [0500]: nVidia Corporation MCP51 Host Bridge
[10de:0270] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
        Capabilities: [e0] HyperTransport: MSI Mapping

00:0a.0 ISA bridge [0601]: nVidia Corporation MCP51 LPC Bridge
[10de:0260] (rev a3)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0
        I/O ports at 1d00 [size=128]

00:0a.1 SMBus [0c05]: nVidia Corporation MCP51 SMBus [10de:0264] (rev a3)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: 66MHz, fast devsel, IRQ 10
        I/O ports at 3040 [size=64]
        I/O ports at 3000 [size=64]
        Capabilities: [44] Power Management version 2

00:0a.3 Co-processor [0b40]: nVidia Corporation MCP51 PMU [10de:0271] (rev a3)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
        Memory at c0040000 (32-bit, non-prefetchable) [size=256K]

00:0b.0 USB Controller [0c03]: nVidia Corporation MCP51 USB Controller
[10de:026d] (rev a3) (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 209
        Memory at c0004000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2

00:0b.1 USB Controller [0c03]: nVidia Corporation MCP51 USB Controller
[10de:026e] (rev a3) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 217
        Memory at c0005000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [44] Debug port
        Capabilities: [80] Power Management version 2

00:0d.0 IDE interface [0101]: nVidia Corporation MCP51 IDE [10de:0265]
(rev f1) (prog-if 8a [Master SecP PriP])
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0
        I/O ports at 3080 [size=16]
        Capabilities: [44] Power Management version 2

00:0e.0 IDE interface [0101]: nVidia Corporation MCP51 Serial ATA
Controller [10de:0266] (rev f1) (prog-if 85 [Master SecO PriO])
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 233
        I/O ports at 30c0 [size=8]
        I/O ports at 30b4 [size=4]
        I/O ports at 30b8 [size=8]
        I/O ports at 30b0 [size=4]
        I/O ports at 3090 [size=16]
        Memory at c0006000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
        Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/2 Enable-
        Capabilities: [cc] HyperTransport: MSI Mapping

00:10.0 PCI bridge [0604]: nVidia Corporation MCP51 PCI Bridge
[10de:026f] (rev a2) (prog-if 01 [Subtractive decode])
        Flags: bus master, 66MHz, fast devsel, latency 0
        Bus: primary=00, secondary=07, subordinate=07, sec-latency=64
        Memory behind bridge: c3000000-c30fffff
        Capabilities: [b8] Subsystem: Gammagraphx, Inc. Unknown device
[0000:0000]
        Capabilities: [8c] HyperTransport: MSI Mapping

00:10.1 Audio device [0403]: nVidia Corporation MCP51 High Definition
Audio [10de:026c] (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 58
        Memory at c0000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+
Queue=0/0 Enable-
        Capabilities: [6c] HyperTransport: MSI Mapping

00:14.0 Bridge [0680]: nVidia Corporation MCP51 Ethernet Controller
[10de:0269] (rev a3)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 225
        Memory at c0008000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at 30e0 [size=8]
        Capabilities: [44] Power Management version 2

00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
        Flags: fast devsel
        Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map [1022:1101]
        Flags: fast devsel

00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller [1022:1102]
        Flags: fast devsel

00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control [1022:1103]
        Flags: fast devsel
        Capabilities: [f0] #0f [0010]

03:00.0 Network controller [0280]: Broadcom Corporation Dell Wireless
1390 WLAN Mini-PCI Card [14e4:4311] (rev 01)
        Subsystem: Hewlett-Packard Company Unknown device [103c:1363]
        Flags: bus master, fast devsel, latency 0, IRQ 50
        Memory at c0400000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 2
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
        Capabilities: [d0] Express Legacy Endpoint IRQ 0
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel

05:00.0 VGA compatible controller [0300]: nVidia Corporation GeForce
Go 7200 [10de:01d6] (rev a1) (prog-if 00 [VGA])
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, fast devsel, latency 0, IRQ 50
        Memory at c2000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at c1000000 (64-bit, non-prefetchable) [size=16M]
        Capabilities: [60] Power Management version 2
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
        Capabilities: [78] Express Endpoint IRQ 0
        Capabilities: [100] Virtual Channel
        Capabilities: [128] Power Budgeting

07:05.0 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394
Controller [1180:0832] (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at c3000000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [dc] Power Management version 2

07:05.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822
SD/SDIO/MMC/MS/MSPro Host Adapter [1180:0822] (rev 19)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, medium devsel, latency 64, IRQ 10
        Memory at c3000800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2

07:05.2 System peripheral [0880]: Ricoh Co Ltd Unknown device
[1180:0843] (rev 01)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: bus master, medium devsel, latency 0, IRQ 11
        Memory at c3000c00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2

07:05.3 System peripheral [0880]: Ricoh Co Ltd R5C592 Memory Stick Bus
Host Adapter [1180:0592] (rev 0a)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: medium devsel, IRQ 11
        Memory at c3001000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2

07:05.4 System peripheral [0880]: Ricoh Co Ltd xD-Picture Card
Controller [1180:0852] (rev 05)
        Subsystem: Hewlett-Packard Company Unknown device [103c:30b7]
        Flags: medium devsel, IRQ 11
        Memory at c3001400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
