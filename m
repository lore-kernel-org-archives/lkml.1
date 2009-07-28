Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZG1QpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZG1QpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZG1QpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:45:23 -0400
Received: from atreides.gradator.net ([212.85.155.42]:47117 "EHLO
	atreides.gradator.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZG1QpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:45:22 -0400
Date: Tue, 28 Jul 2009 18:45:20 +0200
From: Sylvain Rochet <gradator@gradator.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <20090728164520.GB13662@gradator.net>
References: <ct4xS-63o-27@gated-at.bofh.it> <ba6a8e0d-946b-4d69-9f70-991e93c18f90@o15g2000yqm.googlegroups.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <ba6a8e0d-946b-4d69-9f70-991e93c18f90@o15g2000yqm.googlegroups.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: gradator@atreides.gradator.net
Subject: Re: 2.6.28.9: EXT3/NFS inodes corruption
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on atreides.gradator.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: multipart/mixed; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


On Tue, Jul 28, 2009 at 09:40:42AM -0700, Daniel J Blueman wrote:
> On Apr 20, 5:30=A0pm, Sylvain Rochet <grada...@gradator.net> wrote:
> > Hi,
> >
> > We(TuxFamily) are having some inodes corruptions on a NFS server.
> >
> > So, let's start with the facts.
> >
> > =3D=3D=3D=3D NFS Server
> >
> > Linux bazooka 2.6.28.9 #1 SMP Mon Mar 30 12:58:22 CEST 2009 x86_64 GNU/=
Linux
> [snip]
>=20
> Can you do a 'lspci -v' on the server please?

Of course yes.

I attached the 'lspci -v' of the previous and the current storage=20
server.


Sylvain

--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename=currentserver

00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 123
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
	Memory behind bridge: fc900000-fdffffff
	Prefetchable memory behind bridge: fc400000-fc4fffff
	Capabilities: [c0] HyperTransport: Slave or Primary Interface
	Capabilities: [f0] HyperTransport: Interrupt Discovery and Configuration

00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, 66MHz, medium devsel, latency 0

00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, medium devsel, latency 64
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at 1000 [size=16]

00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: medium devsel

00:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fe000000-fe0fffff
	Prefetchable memory behind bridge: 00000000fc500000-00000000fc5fffff
	Capabilities: [a0] PCI-X bridge device
	Capabilities: [b8] HyperTransport: Interrupt Discovery and Configuration
	Capabilities: [c0] HyperTransport: Slave or Primary Interface

00:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01) (prog-if 10 [IO-APIC])
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, medium devsel, latency 0
	Memory at fc800000 (64-bit, non-prefetchable) [size=4K]

00:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=03, subordinate=04, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: fe100000-fe1fffff
	Capabilities: [a0] PCI-X bridge device
	Capabilities: [b8] HyperTransport: Interrupt Discovery and Configuration

00:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01) (prog-if 10 [IO-APIC])
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, medium devsel, latency 0
	Memory at fc801000 (64-bit, non-prefetchable) [size=4K]

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
	Capabilities: [c0] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel

00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
	Capabilities: [c0] HyperTransport: Host or Secondary Interface

00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel

00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel

00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel

01:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b) (prog-if 10 [OHCI])
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at fc900000 (32-bit, non-prefetchable) [size=4K]

01:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b) (prog-if 10 [OHCI])
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at fc901000 (32-bit, non-prefetchable) [size=4K]

01:05.0 VGA compatible controller: Trident Microsystems Blade 3D PCI/AGP (rev 3a) (prog-if 00 [VGA])
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 10
	Memory at fd800000 (32-bit, non-prefetchable) [size=8M]
	Memory at fc920000 (32-bit, non-prefetchable) [size=128K]
	Memory at fd000000 (32-bit, non-prefetchable) [size=8M]
	[virtual] Expansion ROM at fc400000 [disabled] [size=64K]
	Capabilities: [80] AGP version 1.0
	Capabilities: [90] Power Management version 1

02:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5703X Gigabit Ethernet (rev 02)
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 25
	Memory at fe000000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [40] PCI-X non-bridge device
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-

02:03.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5703X Gigabit Ethernet (rev 02)
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 26
	Memory at fe010000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] PCI-X non-bridge device
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-

02:04.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
	Subsystem: Newisys, Inc. Unknown device 0010
	Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 27
	I/O ports at 2000 [size=256]
	Memory at fe030000 (64-bit, non-prefetchable) [size=64K]
	Memory at fe020000 (64-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at fc500000 [disabled] [size=1M]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [68] PCI-X non-bridge device

03:01.0 PCI bridge: IBM PCI-X to PCI-X Bridge (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=03, secondary=04, subordinate=04, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: fe100000-fe1fffff
	Capabilities: [80] PCI-X bridge device
	Capabilities: [90] Power Management version 2

04:04.0 Fibre Channel: Emulex Corporation LP9802 Fibre Channel Host Adapter (rev 01)
	Subsystem: Emulex Corporation LP9802 Fibre Channel Host Adapter
	Flags: bus master, 66MHz, medium devsel, latency 248, IRQ 28
	Memory at fe100000 (64-bit, non-prefetchable) [size=4K]
	Memory at fe102000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 3000 [size=256]
	Capabilities: [4c] Power Management version 2
	Capabilities: [54] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [64] Vital Product Data
	Capabilities: [44] PCI-X non-bridge device

04:05.0 Fibre Channel: Emulex Corporation LP9802 Fibre Channel Host Adapter (rev 01)
	Subsystem: Emulex Corporation LP9802 Fibre Channel Host Adapter
	Flags: bus master, 66MHz, medium devsel, latency 248, IRQ 29
	Memory at fe101000 (64-bit, non-prefetchable) [size=4K]
	Memory at fe102400 (64-bit, non-prefetchable) [size=256]
	I/O ports at 3400 [size=256]
	Capabilities: [4c] Power Management version 2
	Capabilities: [54] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [64] Vital Product Data
	Capabilities: [44] PCI-X non-bridge device


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename=previousserver

00:00.0 Host bridge: Intel Corporation Unknown device 29f0 (rev 01)
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation Unknown device 29f1 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=03, sec-latency=0
	Memory behind bridge: d0100000-d01fffff
	Prefetchable memory behind bridge: 00000000d4000000-00000000d7ffffff
	Capabilities: [88] Subsystem: Super Micro Computer Inc Unknown device d280
	Capabilities: [80] Power Management version 3
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [a0] Express Root Port (Slot+) IRQ 0

00:1a.0 USB Controller: Intel Corporation Unknown device 2937 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0, IRQ 5
	I/O ports at 1820 [size=32]
	Capabilities: [50] #13 [0306]

00:1a.1 USB Controller: Intel Corporation Unknown device 2938 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0, IRQ 10
	I/O ports at 1840 [size=32]
	Capabilities: [50] #13 [0306]

00:1a.2 USB Controller: Intel Corporation Unknown device 2939 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0, IRQ 11
	I/O ports at 1860 [size=32]
	Capabilities: [50] #13 [0306]

00:1a.7 USB Controller: Intel Corporation Unknown device 293c (rev 02) (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0, IRQ 11
	Memory at d0000000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port
	Capabilities: [98] #13 [0306]

00:1c.0 PCI bridge: Intel Corporation Unknown device 2940 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [90] Subsystem: Super Micro Computer Inc Unknown device d280
	Capabilities: [a0] Power Management version 2

00:1c.4 PCI bridge: Intel Corporation Unknown device 2948 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d0200000-d02fffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [90] Subsystem: Super Micro Computer Inc Unknown device d280
	Capabilities: [a0] Power Management version 2

00:1c.5 PCI bridge: Intel Corporation Unknown device 294a (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0f, subordinate=0f, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: d0300000-d03fffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [90] Subsystem: Super Micro Computer Inc Unknown device d280
	Capabilities: [a0] Power Management version 2

00:1d.0 USB Controller: Intel Corporation Unknown device 2934 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0, IRQ 7
	I/O ports at 1880 [size=32]
	Capabilities: [50] #13 [0306]

00:1d.1 USB Controller: Intel Corporation Unknown device 2935 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0, IRQ 10
	I/O ports at 18a0 [size=32]
	Capabilities: [50] #13 [0306]

00:1d.2 USB Controller: Intel Corporation Unknown device 2936 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0, IRQ 11
	I/O ports at 18c0 [size=32]
	Capabilities: [50] #13 [0306]

00:1d.7 USB Controller: Intel Corporation Unknown device 293a (rev 02) (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0, IRQ 7
	Memory at d0000400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port
	Capabilities: [98] #13 [0306]

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=11, subordinate=11, sec-latency=32
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: d0400000-d04fffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000dfffffff
	Capabilities: [50] Subsystem: Super Micro Computer Inc Unknown device d280

00:1f.0 ISA bridge: Intel Corporation Unknown device 2916 (rev 02)
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:1f.2 SATA controller: Intel Corporation Unknown device 2922 (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 76
	I/O ports at 1c50 [size=8]
	I/O ports at 1c44 [size=4]
	I/O ports at 1c48 [size=8]
	I/O ports at 1c40 [size=4]
	I/O ports at 18e0 [size=32]
	Memory at d0000800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/4 Enable+
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] #12 [0010]
	Capabilities: [b0] #13 [0306]

00:1f.3 SMBus: Intel Corporation Unknown device 2930 (rev 02)
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: medium devsel, IRQ 10
	Memory at d0001000 (64-bit, non-prefetchable) [disabled] [size=256]
	I/O ports at 1100 [size=32]

00:1f.6 Signal processing controller: Intel Corporation Unknown device 2932 (rev 02)
	Subsystem: Super Micro Computer Inc Unknown device 0000
	Flags: fast devsel, IRQ 5
	Memory at d0002000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 3

01:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge A (rev 09) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=01, secondary=02, subordinate=02, sec-latency=64
	Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [6c] Power Management version 2
	Capabilities: [d8] PCI-X bridge device

01:00.1 PIC: Intel Corporation 6700/6702PXH I/OxAPIC Interrupt Controller A (rev 09) (prog-if 20 [IO(X)-APIC])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, fast devsel, latency 0
	Memory at d0100000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Express Endpoint IRQ 0
	Capabilities: [6c] Power Management version 2

01:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge B (rev 09) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=01, secondary=03, subordinate=03, sec-latency=48
	Prefetchable memory behind bridge: 00000000d4000000-00000000d7ffffff
	Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [6c] Power Management version 2
	Capabilities: [d8] PCI-X bridge device

01:00.3 PIC: Intel Corporation 6700PXH I/OxAPIC Interrupt Controller B (rev 09) (prog-if 20 [IO(X)-APIC])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, fast devsel, latency 0
	Memory at d0101000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Express Endpoint IRQ 0
	Capabilities: [6c] Power Management version 2

03:02.0 RAID bus controller: Mylex Corporation AcceleRAID 352/170/160 support Device (rev 02)
	Subsystem: Mylex Corporation AcceleRAID 352 support Device
	Flags: bus master, fast Back2Back, medium devsel, latency 32, IRQ 52
	Memory at d4000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [80] Power Management version 2

0d:00.0 Ethernet controller: Intel Corporation 82573E Gigabit Ethernet Controller (Copper) (rev 03)
	Subsystem: Super Micro Computer Inc Unknown device 108c
	Flags: bus master, fast devsel, latency 0, IRQ 77
	Memory at d0200000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at 2000 [size=32]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
	Capabilities: [e0] Express Endpoint IRQ 0

0f:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
	Subsystem: Super Micro Computer Inc Unknown device 109a
	Flags: bus master, fast devsel, latency 0, IRQ 78
	Memory at d0300000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at 3000 [size=32]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
	Capabilities: [e0] Express Endpoint IRQ 0

11:04.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02) (prog-if 00 [VGA])
	Subsystem: Super Micro Computer Inc Unknown device d280
	Flags: bus master, stepping, fast Back2Back, medium devsel, latency 66, IRQ 10
	Memory at d8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at 4000 [size=256]
	Memory at d0400000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d0420000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2


--BwCQnh7xodEAoBMC--

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKbysgDFub3qtEsS8RAmmfAKC448ZUVnVo0/fw80YIMv/WLu6jWwCfeUS2
OTBV5MmPuUDL+roCW8YGOWo=
=T4WC
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
