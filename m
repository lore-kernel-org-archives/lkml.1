Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXFRPTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXFRPTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764127AbXFRPTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:19:38 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:52143 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764126AbXFRPTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:19:35 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Zoltan Boszormenyi <zboszor@dunaweb.hu>
Subject: Re: MCP55 NCQ problem?
Date: Mon, 18 Jun 2007 17:19:40 +0200
User-Agent: KMail/1.9.7
Cc: Peer Chen <pchen@nvidia.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Kuan Luo <kluo@nvidia.com>
References: <fa.g0ZgLrv0is9pYHXy6dxiSz+vSug@ifi.uio.no> <465F9765.7000100@dunaweb.hu> <467657C9.7000108@dunaweb.hu>
In-Reply-To: <467657C9.7000108@dunaweb.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1273389.fZv2MMV1JZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706181719.44810.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1273389.fZv2MMV1JZ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag 18 Juni 2007 schrieb Zoltan Boszormenyi:
> Zoltan Boszormenyi =EDrta:
> > Hi,
> >
> > Peer Chen =EDrta:
> >> Zoltan,
> >> What's your board's model number? Could you post the pci dump using
> >> 'lspci -xxx'? Thanks.
> >>
> >>
> >> BRs
> >> Peer Chen
> >>
> >> -----Original Message-----
> >> From: Robert Hancock [mailto:hancockr@shaw.ca] Sent: Thursday, May
> >> 31, 2007 10:31 PM
> >> To: Zoltan Boszormenyi
> >> Cc: linux-kernel; Peer Chen; Kuan Luo
> >> Subject: Re: MCP55 NCQ problem?
> >>
> >> CCing Peer Chen and Kuan Luo from NVIDIA..
> >>
> >> Looks like there were some unrecognized FIS errors from the
> >> controller in there?
> >>
> >> Zoltan Boszormenyi wrote:
> >>> Hi,
> >>>
> >>> I just got this with 2.6.22-rc2 + cfs-v13 + swncq patch:
> >>>
> >>> ata2.00: exception Emask 0x0 SAct 0x6 SErr 0x0 action 0x2 frozen
> >>> ata2.00: cmd 61/18:08:0f:b7:68/00:00:16:00:00/40 tag 1 cdb 0x0 data
> >>> 12288 out
> >>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata2.00: cmd 61/18:10:7f:b7:68/00:00:16:00:00/40 tag 2 cdb 0x0 data
> >>> 12288 out
> >>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata2: hard resetting port
> >>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >>> ata2.00: ata_hpa_resize 1: sectors =3D 625142448, hpa_sectors =3D 625=
142448
> >>> ata2.00: ata_hpa_resize 1: sectors =3D 625142448, hpa_sectors =3D 625=
142448
> >>> ata2.00: configured for UDMA/133
> >>> ata2: EH pending after completion, repeating EH (cnt=3D4)
> >>> ata2: EH complete
> >>> sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
> >>> sd 1:0:0:0: [sdb] Write Protect is off
> >>> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> >>> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> >>> support DPO or FUA



I am having a similar issue (see end of log) with MCP51 and Maxtor drive wh=
ich =20
I have flashed to latest bios. Currently I am using 2.6.22-rc5 with that=20
swncq patch. Previously I got that problems with 2.6.21 and original fw on=
=20
Maxtor drive.

Board is Asus M2NPV-VM.


hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
        Model Number:       Maxtor 7V300F0
        Serial Number:      V601J87G
        Firmware Revision:  VA111900
Standards:
        Used: ATA/ATAPI-7 T13 1532D revision 0
        Supported: 7 6 5 4
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  268435455
        LBA48  user addressable sectors:  586114704
        device size with M =3D 1024*1024:      286188 MBytes
        device size with M =3D 1000*1000:      300090 MBytes (300 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max =3D 16  Current =3D 1
        Advanced power management level: unknown setting (0x0000)
        Recommended acoustic management value: 192, current value: 254
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
             Cycle time: min=3D120ns recommended=3D120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_VERIFY command
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    NOP cmd
           *    DOWNLOAD_MICROCODE
                Advanced Power Management feature set
                Power-Up In Standby feature set
                SET_FEATURES required to spinup after power up
                SET_MAX security extension
           *    Automatic Acoustic Management feature set
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
                Media Card Pass-Through
           *    General Purpose Logging feature set
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    64-bit World wide name
           *    URG for READ_STREAM[_DMA]_EXT
           *    URG for WRITE_STREAM[_DMA]_EXT
           *    SATA-I signaling speed (1.5Gb/s)
           *    SATA-II signaling speed (3.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Host-initiated interface power management
           *    Software settings preservation
           *    SMART Command Transport (SCT) feature set
           *    SCT Data Tables (AC5)
Security:
        Master password revision code =3D 65534
                supported
        not     enabled
        not     locked
        not     frozen
        not     expired: security count
        not     supported: enhanced erase
Checksum: correct


Jun 17 21:26:45 graviton syslog-ng[4040]: syslog-ng starting up;=20
version=3D'2.0.4'
Jun 17 21:26:45 graviton Linux version 2.6.22-rc5 (light@graviton) (gcc=20
version 4.1.2 (Gentoo 4.1.2)) #2 SMP Sun Jun 17 21:24:29 CEST 2007
Jun 17 21:26:45 graviton Command line: root=3D/dev/sda5 init=3D/sbin/init=20
sata_nv.ncq=3D1
Jun 17 21:26:45 graviton BIOS-provided physical RAM map:
Jun 17 21:26:45 graviton BIOS-e820: 0000000000000000 - 000000000009f000=20
(usable)
Jun 17 21:26:45 graviton BIOS-e820: 000000000009f000 - 00000000000a0000=20
(reserved)
Jun 17 21:26:45 graviton BIOS-e820: 00000000000f0000 - 0000000000100000=20
(reserved)
Jun 17 21:26:45 graviton BIOS-e820: 0000000000100000 - 0000000077ee0000=20
(usable)
Jun 17 21:26:45 graviton BIOS-e820: 0000000077ee0000 - 0000000077ee3000 (AC=
PI=20
NVS)
Jun 17 21:26:45 graviton BIOS-e820: 0000000077ee3000 - 0000000077ef0000 (AC=
PI=20
data)
Jun 17 21:26:45 graviton BIOS-e820: 0000000077ef0000 - 0000000077f00000=20
(reserved)
Jun 17 21:26:46 graviton BIOS-e820: 0000000078000000 - 0000000080000000=20
(reserved)
Jun 17 21:26:46 graviton BIOS-e820: 00000000e0000000 - 00000000f0000000=20
(reserved)
Jun 17 21:26:46 graviton BIOS-e820: 00000000fec00000 - 0000000100000000=20
(reserved)
Jun 17 21:26:46 graviton Entering add_active_range(0, 0, 159) 0 entries of =
256=20
used
Jun 17 21:26:46 graviton Entering add_active_range(0, 256, 491232) 1 entrie=
s=20
of 256 used
Jun 17 21:26:46 graviton end_pfn_map =3D 1048576
Jun 17 21:26:46 graviton DMI 2.4 present.
Jun 17 21:26:46 graviton ACPI: RSDP 000F7530, 0024 (r2 Nvidia)
Jun 17 21:26:46 graviton ACPI: XSDT 77EE30C0, 004C (r1 Nvidia ASUSACPI=20
42302E31 AWRD        0)
Jun 17 21:26:46 graviton ACPI: FACP 77EEB4C0, 00F4 (r3 Nvidia ASUSACPI=20
42302E31 AWRD        0)
Jun 17 21:26:46 graviton ACPI: DSDT 77EE3240, 821D (r1 NVIDIA ASUSACPI    =
=20
1000 MSFT  3000000)
Jun 17 21:26:46 graviton ACPI: FACS 77EE0000, 0040
Jun 17 21:26:46 graviton ACPI: SSDT 77EEB6C0, 01C4 (r1 PTLTD  POWERNOW     =
  =20
1  LTP        1)
Jun 17 21:26:46 graviton ACPI: HPET 77EEB900, 0038 (r1 Nvidia ASUSACPI=20
42302E31 AWRD       98)
Jun 17 21:26:46 graviton ACPI: MCFG 77EEB980, 003C (r1 Nvidia ASUSACPI=20
42302E31 AWRD        0)
Jun 17 21:26:46 graviton ACPI: APIC 77EEB600, 007C (r1 Nvidia ASUSACPI=20
42302E31 AWRD        0)
Jun 17 21:26:46 graviton Entering add_active_range(0, 0, 159) 0 entries of =
256=20
used
Jun 17 21:26:46 graviton Entering add_active_range(0, 256, 491232) 1 entrie=
s=20
of 256 used
Jun 17 21:26:46 graviton Zone PFN ranges:
Jun 17 21:26:46 graviton DMA             0 ->     4096
Jun 17 21:26:46 graviton DMA32        4096 ->  1048576
Jun 17 21:26:46 graviton Normal    1048576 ->  1048576
Jun 17 21:26:46 graviton early_node_map[2] active PFN ranges
Jun 17 21:26:46 graviton 0:        0 ->      159
Jun 17 21:26:46 graviton 0:      256 ->   491232
Jun 17 21:26:46 graviton On node 0 totalpages: 491135
Jun 17 21:26:46 graviton DMA zone: 56 pages used for memmap
Jun 17 21:26:46 graviton DMA zone: 1292 pages reserved
Jun 17 21:26:46 graviton DMA zone: 2651 pages, LIFO batch:0
Jun 17 21:26:46 graviton DMA32 zone: 6660 pages used for memmap
Jun 17 21:26:46 graviton DMA32 zone: 480476 pages, LIFO batch:31
Jun 17 21:26:46 graviton Normal zone: 0 pages used for memmap
Jun 17 21:26:46 graviton ACPI: PM-Timer IO Port: 0x4008
Jun 17 21:26:46 graviton ACPI: Local APIC address 0xfee00000
Jun 17 21:26:46 graviton ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jun 17 21:26:46 graviton Processor #0 (Bootup-CPU)
Jun 17 21:26:46 graviton ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jun 17 21:26:46 graviton Processor #1
Jun 17 21:26:46 graviton ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jun 17 21:26:46 graviton ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jun 17 21:26:46 graviton ACPI: IOAPIC (id[0x02] address[0xfec00000]=20
gsi_base[0])
Jun 17 21:26:46 graviton IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
Jun 17 21:26:46 graviton ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 df=
l=20
dfl)
Jun 17 21:26:46 graviton ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 hi=
gh=20
level)
Jun 17 21:26:46 graviton ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14=
=20
high edge)
Jun 17 21:26:46 graviton ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15=
=20
high edge)
Jun 17 21:26:46 graviton ACPI: IRQ0 used by override.
Jun 17 21:26:46 graviton ACPI: IRQ2 used by override.
Jun 17 21:26:46 graviton ACPI: IRQ9 used by override.
Jun 17 21:26:46 graviton ACPI: IRQ14 used by override.
Jun 17 21:26:46 graviton ACPI: IRQ15 used by override.
Jun 17 21:26:46 graviton Setting APIC routing to flat
Jun 17 21:26:46 graviton ACPI: HPET id: 0x10de8201 base: 0xfefff000
Jun 17 21:26:46 graviton Using ACPI (MADT) for SMP configuration information
Jun 17 21:26:46 graviton Allocating PCI resources starting at 88000000 (gap=
:=20
80000000:60000000)
Jun 17 21:26:46 graviton PERCPU: Allocating 32904 bytes of per cpu data
Jun 17 21:26:46 graviton Built 1 zonelists.  Total pages: 483127
Jun 17 21:26:46 graviton Kernel command line: root=3D/dev/sda5 init=3D/sbin=
/init=20
sata_nv.ncq=3D1
Jun 17 21:26:46 graviton Initializing CPU#0
Jun 17 21:26:46 graviton PID hash table entries: 4096 (order: 12, 32768 byt=
es)
Jun 17 21:26:46 graviton Extended CMOS year: 2000
Jun 17 21:26:46 graviton Marking TSC unstable due to TSCs unsynchronized
Jun 17 21:26:46 graviton time.c: Detected 2009.146 MHz processor.
Jun 17 21:26:46 graviton Console: colour VGA+ 80x25
Jun 17 21:26:46 graviton Dentry cache hash table entries: 262144 (order: 9,=
=20
2097152 bytes)
Jun 17 21:26:46 graviton Inode-cache hash table entries: 131072 (order: 8,=
=20
1048576 bytes)
Jun 17 21:26:46 graviton Checking aperture...
Jun 17 21:26:46 graviton CPU 0: aperture @ 97d4000000 size 32 MB
Jun 17 21:26:46 graviton Aperture too small (32 MB)
Jun 17 21:26:46 graviton No AGP bridge found
Jun 17 21:26:46 graviton Memory: 1929040k/1964928k available (3290k kernel=
=20
code, 35356k reserved, 1219k data, 228k init)
Jun 17 21:26:46 graviton Calibrating delay using timer specific routine..=20
4020.92 BogoMIPS (lpj=3D2010461)
Jun 17 21:26:46 graviton Mount-cache hash table entries: 256
Jun 17 21:26:46 graviton CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K =
(64=20
bytes/line)
Jun 17 21:26:46 graviton CPU: L2 Cache: 512K (64 bytes/line)
Jun 17 21:26:46 graviton CPU: Physical Processor ID: 0
Jun 17 21:26:46 graviton CPU: Processor Core ID: 0
Jun 17 21:26:46 graviton Freeing SMP alternatives: 32k freed
Jun 17 21:26:46 graviton ACPI: Core revision 20070126
Jun 17 21:26:46 graviton Using local APIC timer interrupts.
Jun 17 21:26:46 graviton result 12557157
Jun 17 21:26:46 graviton Detected 12.557 MHz APIC timer.
Jun 17 21:26:46 graviton Booting processor 1/2 APIC 0x1
Jun 17 21:26:46 graviton Initializing CPU#1
Jun 17 21:26:46 graviton Calibrating delay using timer specific routine..=20
4018.28 BogoMIPS (lpj=3D2009140)
Jun 17 21:26:46 graviton CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K =
(64=20
bytes/line)
Jun 17 21:26:46 graviton CPU: L2 Cache: 512K (64 bytes/line)
Jun 17 21:26:46 graviton CPU: Physical Processor ID: 0
Jun 17 21:26:46 graviton CPU: Processor Core ID: 1
Jun 17 21:26:46 graviton AMD Athlon(tm) 64 X2 Dual Core Processor 3800+=20
stepping 02
Jun 17 21:26:46 graviton Brought up 2 CPUs
Jun 17 21:26:46 graviton migration_cost=3D197
Jun 17 21:26:46 graviton NET: Registered protocol family 16
Jun 17 21:26:46 graviton ACPI: bus type pci registered
Jun 17 21:26:46 graviton PCI: Using MMCONFIG at e0000000 - efffffff
Jun 17 21:26:46 graviton PCI: No mmconfig possible on device 00:18
Jun 17 21:26:46 graviton ACPI: Interpreter enabled
Jun 17 21:26:46 graviton ACPI: Using IOAPIC for interrupt routing
Jun 17 21:26:46 graviton ACPI: PCI Root Bridge [PCI0] (0000:00)
Jun 17 21:26:46 graviton PCI: Probing PCI hardware (bus 00)
Jun 17 21:26:46 graviton PCI: Transparent bridge - 0000:00:10.0
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Routing Table=20
[\_SB_.PCI0.HUB0._PRT]
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LNK7] (IRQs *5 7 9 10 11=
 14=20
15)
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LUBB] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 *11=
 14=20
15)
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11=
 14=20
15)
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LMCI] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LSID] (IRQs *5 7 9 10 11=
 14=20
15)
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 11 =
14=20
15) *0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0,=20
disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0,=20
disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0,=20
disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0,=20
disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0,=20
disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0,=20
disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0,=20
disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23)=
 *0
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23)=
 *0
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23)=
 *0
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23)=
=20
*0, disabled.
Jun 17 21:26:46 graviton Linux Plug and Play Support v0.97 (c) Adam Belay
Jun 17 21:26:46 graviton pnp: PnP ACPI init
Jun 17 21:26:46 graviton ACPI: bus type pnp registered
Jun 17 21:26:46 graviton pnp: PnP ACPI: found 17 devices
Jun 17 21:26:46 graviton ACPI: ACPI bus type pnp unregistered
Jun 17 21:26:46 graviton SCSI subsystem initialized
Jun 17 21:26:46 graviton libata version 2.21 loaded.
Jun 17 21:26:46 graviton PCI: Using ACPI for IRQ routing
Jun 17 21:26:46 graviton PCI: If a device doesn't work, try "pci=3Drouteirq=
". =20
If it helps, post a report
Jun 17 21:26:46 graviton hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
Jun 17 21:26:46 graviton hpet0: 3 32-bit timers, 25000000 Hz
Jun 17 21:26:46 graviton pnp: 00:01: ioport range 0x4000-0x407f has been=20
reserved
Jun 17 21:26:46 graviton pnp: 00:01: ioport range 0x4080-0x40ff has been=20
reserved
Jun 17 21:26:46 graviton pnp: 00:01: ioport range 0x4400-0x447f has been=20
reserved
Jun 17 21:26:46 graviton pnp: 00:01: ioport range 0x4480-0x44ff has been=20
reserved
Jun 17 21:26:46 graviton pnp: 00:01: ioport range 0x4800-0x487f has been=20
reserved
Jun 17 21:26:46 graviton pnp: 00:01: ioport range 0x4880-0x48ff has been=20
reserved
Jun 17 21:26:46 graviton Time: hpet clocksource has been installed.
Jun 17 21:26:46 graviton pnp: 00:01: ioport range 0x2000-0x207f has been=20
reserved
Jun 17 21:26:46 graviton pnp: 00:01: ioport range 0x2080-0x20ff has been=20
reserved
Jun 17 21:26:46 graviton pnp: 00:01: iomem range 0x78000000-0x7fffffff coul=
d=20
not be reserved
Jun 17 21:26:46 graviton pnp: 00:0f: iomem range 0xe0000000-0xefffffff coul=
d=20
not be reserved
Jun 17 21:26:46 graviton pnp: 00:10: iomem range 0xcec00-0xcffff has been=20
reserved
Jun 17 21:26:46 graviton pnp: 00:10: iomem range 0xf0000-0xf7fff could not =
be=20
reserved
Jun 17 21:26:46 graviton pnp: 00:10: iomem range 0xf8000-0xfbfff could not =
be=20
reserved
Jun 17 21:26:46 graviton pnp: 00:10: iomem range 0xfc000-0xfffff could not =
be=20
reserved
Jun 17 21:26:46 graviton PCI: Bridge: 0000:00:02.0
Jun 17 21:26:46 graviton IO window: c000-cfff
Jun 17 21:26:46 graviton MEM window: fd700000-fd7fffff
Jun 17 21:26:46 graviton PREFETCH window: fde00000-fdefffff
Jun 17 21:26:46 graviton PCI: Bridge: 0000:00:03.0
Jun 17 21:26:46 graviton IO window: b000-bfff
Jun 17 21:26:46 graviton MEM window: fdd00000-fddfffff
Jun 17 21:26:46 graviton PREFETCH window: fdc00000-fdcfffff
Jun 17 21:26:46 graviton PCI: Bridge: 0000:00:04.0
Jun 17 21:26:46 graviton IO window: 9000-9fff
Jun 17 21:26:46 graviton MEM window: fd900000-fd9fffff
Jun 17 21:26:46 graviton PREFETCH window: fd800000-fd8fffff
Jun 17 21:26:46 graviton PCI: Bridge: 0000:00:10.0
Jun 17 21:26:46 graviton IO window: a000-afff
Jun 17 21:26:46 graviton MEM window: fdb00000-fdbfffff
Jun 17 21:26:46 graviton PREFETCH window: fda00000-fdafffff
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:02.0 =
to=20
64
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:03.0 =
to=20
64
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:04.0 =
to=20
64
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:10.0 =
to=20
64
Jun 17 21:26:46 graviton NET: Registered protocol family 2
Jun 17 21:26:46 graviton IP route cache hash table entries: 65536 (order: 7=
,=20
524288 bytes)
Jun 17 21:26:46 graviton TCP established hash table entries: 131072 (order:=
 9,=20
3145728 bytes)
Jun 17 21:26:46 graviton TCP bind hash table entries: 65536 (order: 8, 1048=
576=20
bytes)
Jun 17 21:26:46 graviton TCP: Hash tables configured (established 131072 bi=
nd=20
65536)
Jun 17 21:26:46 graviton TCP reno registered
Jun 17 21:26:46 graviton Total HugeTLB memory allocated, 0
Jun 17 21:26:46 graviton Loading Reiser4. See www.namesys.com for a=20
description of Reiser4.
Jun 17 21:26:46 graviton Installing knfsd (copyright (C) 1996=20
okir@monad.swb.de).
Jun 17 21:26:46 graviton io scheduler noop registered
Jun 17 21:26:46 graviton io scheduler anticipatory registered
Jun 17 21:26:46 graviton io scheduler deadline registered (default)
Jun 17 21:26:46 graviton io scheduler cfq registered
Jun 17 21:26:46 graviton Boot video device is 0000:00:05.0
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:02.0 =
to=20
64
Jun 17 21:26:46 graviton assign_interrupt_mode Found MSI capability
Jun 17 21:26:46 graviton Allocate Port Service[0000:00:02.0:pcie00]
Jun 17 21:26:46 graviton Allocate Port Service[0000:00:02.0:pcie03]
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:03.0 =
to=20
64
Jun 17 21:26:46 graviton assign_interrupt_mode Found MSI capability
Jun 17 21:26:46 graviton Allocate Port Service[0000:00:03.0:pcie00]
Jun 17 21:26:46 graviton Allocate Port Service[0000:00:03.0:pcie03]
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:04.0 =
to=20
64
Jun 17 21:26:46 graviton assign_interrupt_mode Found MSI capability
Jun 17 21:26:46 graviton Allocate Port Service[0000:00:04.0:pcie00]
Jun 17 21:26:46 graviton Allocate Port Service[0000:00:04.0:pcie03]
Jun 17 21:26:46 graviton pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jun 17 21:26:46 graviton input: Power Button (FF) as /class/input/input0
Jun 17 21:26:46 graviton ACPI: Power Button (FF) [PWRF]
Jun 17 21:26:46 graviton input: Power Button (CM) as /class/input/input1
Jun 17 21:26:46 graviton ACPI: Power Button (CM) [PWRB]
Jun 17 21:26:46 graviton ACPI: Fan [FAN] (on)
Jun 17 21:26:46 graviton ACPI: Thermal Zone [THRM] (40 C)
Jun 17 21:26:46 graviton lp: driver loaded but no devices found
Jun 17 21:26:46 graviton Real Time Clock Driver v1.12ac
Jun 17 21:26:46 graviton hpet_resources: 0xfefff000 is busy
Jun 17 21:26:46 graviton Non-volatile memory driver v1.2
Jun 17 21:26:46 graviton Linux agpgart interface v0.102 (c) Dave Jones
Jun 17 21:26:46 graviton Serial: 8250/16550 driver $Revision: 1.90 $ 4 port=
s,=20
IRQ sharing disabled
Jun 17 21:26:46 graviton 00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Jun 17 21:26:46 graviton 00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
Jun 17 21:26:46 graviton parport_pc 00:0a: reported by Plug and Play ACPI
Jun 17 21:26:46 graviton parport0: PC-style at 0x378, irq 7=20
[PCSPP,TRISTATE,EPP]
Jun 17 21:26:46 graviton lp0: using parport0 (interrupt-driven).
Jun 17 21:26:46 graviton forcedeth.c: Reverse Engineered nForce ethernet=20
driver. Version 0.60.
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
Jun 17 21:26:46 graviton ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [APCH]=
 ->=20
GSI 23 (level, low) -> IRQ 23
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:14.0 =
to=20
64
Jun 17 21:26:46 graviton forcedeth: using HIGHDMA
Jun 17 21:26:46 graviton eth0: forcedeth.c: subsystem: 01043:816a bound to=
=20
0000:00:14.0
Jun 17 21:26:46 graviton PPP generic driver version 2.4.2
Jun 17 21:26:46 graviton PPP Deflate Compression module registered
Jun 17 21:26:46 graviton PPP BSD Compression module registered
Jun 17 21:26:46 graviton tun: Universal TUN/TAP device driver, 1.6
Jun 17 21:26:46 graviton tun: (C) 1999-2004 Max Krasnyansky=20
<maxk@qualcomm.com>
Jun 17 21:26:46 graviton sata_nv 0000:00:0e.0: version 3.4
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
Jun 17 21:26:46 graviton ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [APSI]=
 ->=20
GSI 22 (level, low) -> IRQ 22
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:0e.0 =
to=20
64
Jun 17 21:26:46 graviton scsi0 : sata_nv
Jun 17 21:26:46 graviton scsi1 : sata_nv
Jun 17 21:26:46 graviton ata1: SATA max UDMA/133 cmd 0x00000000000109f0 ctl=
=20
0x0000000000010bf2 bmdma 0x000000000001e000 irq 0
Jun 17 21:26:46 graviton ata2: SATA max UDMA/133 cmd 0x0000000000010970 ctl=
=20
0x0000000000010b72 bmdma 0x000000000001e008 irq 0
Jun 17 21:26:46 graviton ata1: SATA link up 3.0 Gbps (SStatus 123 SControl=
=20
300)
Jun 17 21:26:46 graviton ata1.00: ata_hpa_resize 1: sectors =3D 586114704,=
=20
hpa_sectors =3D 586114704
Jun 17 21:26:46 graviton ata1.00: ATA-7: Maxtor 7V300F0, VA111900, max=20
UDMA/133
Jun 17 21:26:46 graviton ata1.00: 586114704 sectors, multi 1: LBA48 NCQ (de=
pth=20
31/32)
Jun 17 21:26:46 graviton ata1.00: ata_hpa_resize 1: sectors =3D 586114704,=
=20
hpa_sectors =3D 586114704
Jun 17 21:26:46 graviton ata1.00: configured for UDMA/133
Jun 17 21:26:46 graviton ata2: SATA link down (SStatus 0 SControl 300)
Jun 17 21:26:46 graviton ATA: abnormal status 0x7F on port 0x00000000000109=
77
Jun 17 21:26:46 graviton scsi 0:0:0:0: Direct-Access     ATA      Maxtor=20
7V300F0   VA11 PQ: 0 ANSI: 5
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] 586114704 512-byte hardware sect=
ors=20
(300091 MB)
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] Write Protect is off
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] 586114704 512-byte hardware sect=
ors=20
(300091 MB)
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] Write Protect is off
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA
Jun 17 21:26:46 graviton sda: sda1 sda2 < sda5 sda6 sda7 sda8 > sda3
Jun 17 21:26:46 graviton sd 0:0:0:0: [sda] Attached SCSI disk
Jun 17 21:26:46 graviton sd 0:0:0:0: Attached scsi generic sg0 type 0
Jun 17 21:26:46 graviton pata_amd 0000:00:0d.0: version 0.3.8
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:0d.0 =
to=20
64
Jun 17 21:26:46 graviton scsi2 : pata_amd
Jun 17 21:26:46 graviton scsi3 : pata_amd
Jun 17 21:26:46 graviton ata3: PATA max UDMA/133 cmd 0x00000000000101f0 ctl=
=20
0x00000000000103f6 bmdma 0x000000000001f400 irq 14
Jun 17 21:26:46 graviton ata4: PATA max UDMA/133 cmd 0x0000000000010170 ctl=
=20
0x0000000000010376 bmdma 0x000000000001f408 irq 15
Jun 17 21:26:46 graviton ata3.00: ATAPI: NU      DVDRW DDW-081, BX32, max=20
UDMA/33
Jun 17 21:26:46 graviton ata3.00: configured for UDMA/33
Jun 17 21:26:46 graviton ata4: port disabled. ignoring.
Jun 17 21:26:46 graviton scsi 2:0:0:0: CD-ROM            NU       DVDRW=20
DDW-081    BX32 PQ: 0 ANSI: 5
Jun 17 21:26:46 graviton sr0: scsi3-mmc drive: 12x/40x writer cd/rw xa/form=
2=20
cdda tray
Jun 17 21:26:46 graviton Uniform CD-ROM driver Revision: 3.20
Jun 17 21:26:46 graviton sr 2:0:0:0: Attached scsi CD-ROM sr0
Jun 17 21:26:46 graviton sr 2:0:0:0: Attached scsi generic sg1 type 5
Jun 17 21:26:46 graviton PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] a=
t=20
0x60,0x64 irq 1,12
Jun 17 21:26:46 graviton serio: i8042 KBD port at 0x60,0x64 irq 1
Jun 17 21:26:46 graviton serio: i8042 AUX port at 0x60,0x64 irq 12
Jun 17 21:26:46 graviton mice: PS/2 mouse device common for all mice
Jun 17 21:26:46 graviton input: AT Translated Set 2 keyboard=20
as /class/input/input2
Jun 17 21:26:46 graviton i2c /dev entries driver
Jun 17 21:26:46 graviton i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
Jun 17 21:26:46 graviton i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
Jun 17 21:26:46 graviton it87: Found IT8716F chip at 0x290, revision 0
Jun 17 21:26:46 graviton it87: in3 is VCC (+5V)
Jun 17 21:26:46 graviton it87: in7 is VCCH (+5V Stand-By)
Jun 17 21:26:46 graviton device-mapper: ioctl: 4.11.0-ioctl (2006-10-12)=20
initialised: dm-devel@redhat.com
Jun 17 21:26:46 graviton Netfilter messages via NETLINK v0.30.
Jun 17 21:26:46 graviton nf_conntrack version 0.5.0 (8192 buckets, 65536 ma=
x)
Jun 17 21:26:46 graviton ip_tables: (C) 2000-2006 Netfilter Core Team
Jun 17 21:26:46 graviton ClusterIP Version 0.8 loaded successfully
Jun 17 21:26:46 graviton arp_tables: (C) 2002 David S. Miller
Jun 17 21:26:46 graviton TCP cubic registered
Jun 17 21:26:46 graviton NET: Registered protocol family 1
Jun 17 21:26:46 graviton NET: Registered protocol family 17
Jun 17 21:26:46 graviton input: ImPS/2 Generic Wheel Mouse=20
as /class/input/input3
Jun 17 21:26:46 graviton kjournald starting.  Commit interval 5 seconds
Jun 17 21:26:46 graviton EXT3-fs: mounted filesystem with writeback data mo=
de.
Jun 17 21:26:46 graviton VFS: Mounted root (ext3 filesystem) readonly.
Jun 17 21:26:46 graviton Freeing unused kernel memory: 228k freed
Jun 17 21:26:46 graviton usbcore: registered new interface driver usbfs
Jun 17 21:26:46 graviton usbcore: registered new interface driver hub
Jun 17 21:26:46 graviton usbcore: registered new device driver usb
Jun 17 21:26:46 graviton ohci_hcd: 2006 August 04 USB 1.1 'Open' Host=20
Controller (OHCI) Driver
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
Jun 17 21:26:46 graviton ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [APCF]=
 ->=20
GSI 21 (level, low) -> IRQ 21
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:0b.0 =
to=20
64
Jun 17 21:26:46 graviton ohci_hcd 0000:00:0b.0: OHCI Host Controller
Jun 17 21:26:46 graviton ohci_hcd 0000:00:0b.0: new USB bus registered,=20
assigned bus number 1
Jun 17 21:26:46 graviton ohci_hcd 0000:00:0b.0: irq 21, io mem 0xfe02f000
Jun 17 21:26:46 graviton usb usb1: configuration #1 chosen from 1 choice
Jun 17 21:26:46 graviton hub 1-0:1.0: USB hub found
Jun 17 21:26:46 graviton hub 1-0:1.0: 8 ports detected
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
Jun 17 21:26:46 graviton ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [APCL]=
 ->=20
GSI 20 (level, low) -> IRQ 20
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:0b.1 =
to=20
64
Jun 17 21:26:46 graviton ehci_hcd 0000:00:0b.1: EHCI Host Controller
Jun 17 21:26:46 graviton ehci_hcd 0000:00:0b.1: new USB bus registered,=20
assigned bus number 2
Jun 17 21:26:46 graviton ehci_hcd 0000:00:0b.1: debug port 1
Jun 17 21:26:46 graviton PCI: cache line size of 64 is not supported by dev=
ice=20
0000:00:0b.1
Jun 17 21:26:46 graviton ehci_hcd 0000:00:0b.1: irq 20, io mem 0xfe02e000
Jun 17 21:26:46 graviton ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00,=
=20
driver 10 Dec 2004
Jun 17 21:26:46 graviton usb usb2: configuration #1 chosen from 1 choice
Jun 17 21:26:46 graviton hub 2-0:1.0: USB hub found
Jun 17 21:26:46 graviton hub 2-0:1.0: 8 ports detected
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
Jun 17 21:26:46 graviton ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA]=
 ->=20
GSI 23 (level, low) -> IRQ 23
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:10.1 =
to=20
64
Jun 17 21:26:46 graviton usb 2-1: new high speed USB device using ehci_hcd =
and=20
address 2
Jun 17 21:26:46 graviton usb 2-1: configuration #1 chosen from 1 choice
Jun 17 21:26:46 graviton hub 2-1:1.0: USB hub found
Jun 17 21:26:46 graviton hub 2-1:1.0: 3 ports detected
Jun 17 21:26:46 graviton nvidia: module license 'NVIDIA' taints kernel.
Jun 17 21:26:46 graviton usb 2-1.3: new full speed USB device using ehci_hc=
d=20
and address 3
Jun 17 21:26:46 graviton ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
Jun 17 21:26:46 graviton ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APC7]=
 ->=20
GSI 16 (level, low) -> IRQ 16
Jun 17 21:26:46 graviton PCI: Setting latency timer of device 0000:00:05.0 =
to=20
64
Jun 17 21:26:46 graviton NVRM: loading NVIDIA UNIX x86_64 Kernel Module =20
100.14.09  Sat May 26 00:43:07 PDT 2007
Jun 17 21:26:46 graviton usb 2-1.3: configuration #1 chosen from 1 choice
Jun 17 21:26:46 graviton usbcore: registered new interface driver hiddev
Jun 17 21:26:46 graviton EXT3 FS on sda5, internal journal
Jun 17 21:26:46 graviton powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Cor=
e=20
Processor 3800+ processors (version 2.00.00)
Jun 17 21:26:46 graviton powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xa
Jun 17 21:26:46 graviton powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xc
Jun 17 21:26:46 graviton powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
Jun 17 21:26:46 graviton loop: loaded (max 8 devices)
Jun 17 21:26:46 graviton kjournald starting.  Commit interval 5 seconds
Jun 17 21:26:46 graviton EXT3 FS on sda6, internal journal
Jun 17 21:26:46 graviton EXT3-fs: mounted filesystem with writeback data mo=
de.
Jun 17 21:26:46 graviton reiser4: sda7: found disk format 4.0.0.
Jun 17 21:26:46 graviton fuse init (API version 7.8)
Jun 17 21:26:46 graviton Adding 2097144k swap on /swapfile.  Priority:1000=
=20
extents:571 across:2152760k
Jun 17 21:26:46 graviton drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl=
)=20
failed
Jun 17 21:26:46 graviton drivers/hid/usbhid/hid-core.c: timeout initializin=
g=20
reports
Jun 17 21:26:46 graviton hiddev96: USB HID v1.10 Device [EIZO EIZO USB HID=
=20
Monitor] on usb-0000:00:0b.1-1.3
Jun 17 21:26:46 graviton usbcore: registered new interface driver usbhid
Jun 17 21:26:46 graviton drivers/hid/usbhid/hid-core.c: v2.6:USB HID core=20
driver
Jun 17 21:26:50 graviton dhcpd: WARNING: Host declarations are global.  The=
y=20
are not limited to the scope you declared them in.
Jun 17 21:26:50 graviton dhcpd: Wrote 0 deleted host decls to leases file.
Jun 17 21:26:50 graviton dhcpd: Wrote 0 new dynamic host decls to leases fi=
le.
Jun 17 21:26:50 graviton dhcpd: Wrote 0 leases to leases file.
Jun 17 21:26:50 graviton sshd[4520]: Server listening on 0.0.0.0 port 22.
Jun 17 21:26:51 graviton rpc.statd[4576]: Version 1.1.0 Starting
Jun 17 21:26:59 graviton kdm: :0[4778]: pam_unix(kde-np:session): session=20
opened for user light by (uid=3D0)
Jun 17 21:30:10 graviton ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x20000=
00=20
action 0x2 frozen
Jun 17 21:30:10 graviton ata1.00: cmd 61/18:00:d1:52:f2/00:00:06:00:00/40 t=
ag=20
0 cdb 0x0 data 12288 out
Jun 17 21:30:10 graviton res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4=
=20
(timeout)
Jun 17 21:30:10 graviton ata1.00: cmd 61/10:08:f1:52:f2/00:00:06:00:00/40 t=
ag=20
1 cdb 0x0 data 8192 out
Jun 17 21:30:10 graviton res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4=
=20
(timeout)
Jun 17 21:30:10 graviton ata1: hard resetting port
Jun 17 21:30:10 graviton ata1: SATA link up 3.0 Gbps (SStatus 123 SControl=
=20
300)
Jun 17 21:30:10 graviton ata1.00: ata_hpa_resize 1: sectors =3D 586114704,=
=20
hpa_sectors =3D 586114704
Jun 17 21:30:10 graviton ata1.00: ata_hpa_resize 1: sectors =3D 586114704,=
=20
hpa_sectors =3D 586114704
Jun 17 21:30:10 graviton ata1.00: configured for UDMA/133
Jun 17 21:30:10 graviton ata1: EH complete
Jun 17 21:30:10 graviton sd 0:0:0:0: [sda] 586114704 512-byte hardware sect=
ors=20
(300091 MB)
Jun 17 21:30:10 graviton sd 0:0:0:0: [sda] Write Protect is off
Jun 17 21:30:10 graviton sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jun 17 21:30:10 graviton sd 0:0:0:0: [sda] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA



lspci -xxx
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00: de 10 f0 02 06 00 b0 00 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00
40: 43 10 c0 81 08 e0 e0 01 22 00 11 11 22 20 11 00
50: 23 06 7f 80 03 05 7f 80 00 00 03 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 06 15 05 00
70: 44 44 41 00 d0 09 00 00 11 00 00 00 11 11 88 00
80: 23 99 88 00 1f 00 64 0c 03 00 00 00 7f 00 00 00
90: 70 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 01 01 01 01 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 61 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 08 00 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 10
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00: de 10 fa 02 00 01 20 40 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 10 00 21 21 14 00 11 11 00 00 03 00 00 00
60: 21 88 13 02 de 8f e1 1f 08 72 4e 10 02 3f 00 20
70: 10 32 54 0a 10 00 00 00 a0 00 00 00 20 00 01 01
80: 00 00 00 00 00 00 00 00 00 00 50 3f 90 3f 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 01 00 00 00 80 f9 fd 00
e0: 00 00 c9 fe 00 00 00 00 00 fc ff ff 00 00 00 00
f0: 00 00 00 00 c7 02 32 00 00 00 00 00 00 00 00 00

00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
00: de 10 fe 02 00 00 20 00 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 43 10 c0 81 1f 20 1c 20 1f 20 c0 21 00 00 00 00
50: 51 30 54 c9 01 00 00 00 4f 30 52 c9 02 1f 1c 80
60: 02 1f 1c 00 00 00 00 00 02 10 1c a0 02 0c 1c 90
70: 02 10 1c 90 02 14 1c 90 02 0c 1c 80 02 10 1c 80
80: 02 14 1c 80 02 18 1c 80 02 1c 1c 80 01 10 1c 80
90: 02 14 1c 80 11 00 11 00 32 01 00 00 00 00 00 00
a0: c2 00 40 61 10 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 41 23 05 08
c0: fd ff ff ff ff ff ff ff 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
00: de 10 f8 02 00 00 a0 00 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
40: 43 10 c0 81 00 00 00 00 02 10 1c 80 02 10 1c a0
50: 02 0c 1c 90 02 10 1c 90 02 14 1c 90 02 0c 1c 80
60: 02 10 1c 80 02 14 1c 80 02 18 1c 80 02 1c 1c 80
70: 01 10 1c 80 1f 20 c0 81 00 00 00 00 3e 30 40 c9
80: 01 00 00 00 46 30 48 c9 02 1f 1c 80 70 20 00 40
90: 89 da 01 09 00 00 00 00 11 00 10 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 08 00 00 00 24 1c 00 00 10 00 02 00 40 00 40 00
c0: 00 00 00 00 00 00 00 00 01 01 00 05 00 00 00 00
d0: 00 00 f0 03 00 04 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 60 ea 10 10 18 00 00 20 00 00 00 00 00 00 00 00

00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
00: de 10 f9 02 06 00 a0 00 a2 00 00 05 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
40: ef dd 7b 2f f7 de 7b 2f f7 de 7b 2f f7 02 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 03 00 00 00 00 00 00 00
70: 0a 00 00 00 03 00 00 00 25 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 05 00 00 00 04 00 00 00
90: 03 04 00 00 01 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: ff 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00: de 10 ff 02 06 00 b0 00 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00
40: 17 00 00 00 00 fe fe 00 00 fe fe 00 00 fe fe 00
50: 00 fe fe 00 00 fe fe 00 00 fe fe 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
00: de 10 7f 02 02 01 20 00 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 08 00 00 00 00 00 00 00 00 80 cb fe 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
00: de 10 7e 02 00 00 20 00 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 43 10 c0 81 11 00 00 00 64 08 00 00 11 00 00 00
50: 63 07 00 00 00 00 00 00 40 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 04
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 04
b0: ff ff 03 00 10 11 00 00 ac 10 20 00 30 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00: de 10 fc 02 07 04 10 00 a1 00 04 06 08 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 c1 c1 00 00
20: 70 fd 70 fd e1 fd e1 fd 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 00 04 00
40: 0d 48 00 00 de 10 00 00 01 50 02 f8 00 00 00 00
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 49 41 00 00
60: 08 80 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 c0 04 00 00 1f 28 00 00 11 3c 11 02
90: 00 00 11 10 00 00 00 00 c0 01 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00: de 10 fd 02 07 04 10 00 a1 00 04 06 08 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 b1 b1 00 00
20: d0 fd d0 fd c1 fd c1 fd 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 00 04 00
40: 0d 48 00 00 de 10 00 00 01 50 02 f8 00 00 00 00
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 51 41 00 00
60: 08 80 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 c0 04 00 00 1f 28 00 00 11 3c 11 01
90: 00 00 11 10 00 00 00 00 c0 01 00 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00: de 10 fb 02 07 04 10 00 a1 00 04 06 08 00 01 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 91 91 00 00
20: 90 fd 90 fd 81 fd 81 fd 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 00 04 00
40: 0d 48 00 00 de 10 00 00 01 50 02 f8 00 00 00 00
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 59 41 00 00
60: 08 80 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 c0 04 00 00 1f 28 00 00 01 3d 11 00
90: 00 00 01 11 00 00 00 00 c0 01 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:05.0 VGA compatible controller: nVidia Corporation C51PV [GeForce 6150]=
=20
(rev a2)
00: de 10 40 02 07 00 b0 00 a2 00 00 03 00 00 00 00
10: 00 00 00 fb 0c 00 00 d0 00 00 00 00 04 00 00 fc
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 cd 81
30: 00 00 00 00 48 00 00 00 00 00 00 00 05 01 00 00
40: 43 10 cd 81 00 00 00 00 01 50 02 00 00 00 00 00
50: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 00 00 00 04 00 00 00 00 00 00 00 01 00 00 00
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
a0: 00 00 f0 00 00 00 00 08 00 00 00 00 ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
00: de 10 70 02 06 00 b0 00 a2 00 00 05 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00
40: 43 10 c0 81 08 e0 e9 01 22 20 00 00 d0 00 00 00
50: 23 05 7f 80 03 00 00 00 00 00 03 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 06 15 05 00
70: 44 44 44 00 d0 09 00 00 11 00 00 00 11 11 55 00
80: 23 55 55 00 fa 00 64 0c 03 00 00 00 7f 00 00 00
90: 70 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 01 01 01 01 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 08 00 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
00: de 10 60 02 0f 00 a0 00 a3 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
40: 43 10 c0 81 00 f0 ff fe fa 3e ff 00 fa 3e ff 00
50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 ff ff
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f9 ff
70: 10 00 ff ff c5 00 00 00 00 00 45 19 00 00 00 03
80: 09 80 00 20 0d 11 00 00 c0 00 00 01 00 00 00 00
90: 00 00 00 00 00 00 00 00 21 47 65 b7 ef cd 00 00
a0: 03 80 30 c1 02 00 00 00 00 00 00 00 00 00 00 00
b0: 90 02 ef 02 00 08 5f 08 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
00: de 10 64 02 01 00 b0 00 a3 00 05 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 4c 00 00 41 4c 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 01 00 00
40: 43 10 c0 81 01 00 02 c0 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 40 00 00 01 44 00 00 01 48 00 00 00 00 00 00
70: 01 00 00 00 00 00 c8 fe 00 00 fe fe 01 20 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: d4 30 80 01 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 10 10 04 00 00 a0 00 00 80 30 04 00 41 44 44 11
f0: 5a ff 5f bf 00 00 00 c0 10 00 00 00 00 00 00 00

00:0a.2 RAM memory: nVidia Corporation MCP51 Memory Controller 0 (rev a3)
00: de 10 72 02 00 04 a0 00 a3 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 10 00 00 10 00 00 10 10
50: 10 10 10 10 00 00 00 00 00 00 00 00 00 00 00 00
60: 02 03 00 00 12 00 00 00 02 00 00 00 10 01 12 00
70: 32 33 00 00 03 00 00 00 00 00 00 00 12 01 00 00
80: 10 00 00 00 00 00 00 00 00 00 00 00 30 02 00 00
90: 00 00 00 00 01 20 00 00 01 00 00 00 00 09 00 00
a0: 01 02 00 00 00 10 00 00 05 00 00 00 01 00 00 00
b0: 00 10 00 80 01 00 00 80 00 00 00 00 02 00 00 00
c0: 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00: de 10 6d 02 07 00 b0 00 a3 10 03 0c 00 00 80 00
10: 00 f0 02 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 01 03 01
40: 43 10 c0 81 01 00 02 fe 00 00 00 00 00 00 00 00
50: 00 00 00 00 1d 47 40 00 10 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00: de 10 6e 02 06 00 b0 00 a3 20 03 0c 00 00 80 00
10: 00 e0 02 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 02 03 01
40: 43 10 c0 81 0a 80 98 20 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 01 00 00 60 18 85 03 3c 0a 01 00 00 00 00
70: 00 00 08 05 00 10 20 80 89 3d b6 22 77 25 64 00
80: 01 00 02 fe 00 00 00 00 00 00 00 00 15 16 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 00 00 00 08 c0 00 00 00 00 00 00 00 00
b0: 00 11 22 33 00 00 00 00 ff 00 00 00 00 00 00 00
c0: 10 10 2d 0d 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
00: de 10 65 02 05 00 b0 00 a1 8a 01 01 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 f4 00 00 00 00 00 00 00 00 00 00 43 f0 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 03 01
40: 43 f0 c0 81 01 00 02 00 00 00 00 00 00 00 00 00
50: 02 f0 01 00 00 00 00 00 a8 a8 a8 20 2a 00 99 20
60: 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 70 db 76 00 00 02 24 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev =
a1)
00: de 10 66 02 07 00 b0 00 a1 85 01 01 00 00 00 00
10: f1 09 00 00 f1 0b 00 00 71 09 00 00 71 0b 00 00
20: 01 e0 00 00 00 d0 02 fe 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 05 01 03 01
40: 43 10 c0 81 01 b0 02 00 00 00 00 00 00 00 00 00
50: 07 00 00 00 00 00 00 00 a8 a8 a8 20 6a 00 99 20
60: 00 00 00 c0 51 0c 00 00 00 0f 06 42 00 00 00 00
70: 2c 78 c4 40 01 10 00 00 01 10 00 00 20 00 20 00
80: 00 00 00 40 00 90 80 2e 00 00 10 b0 3b e0 9f 2f
90: 00 00 fb 3f 00 00 00 00 06 00 06 10 00 00 01 01
a0: 14 10 00 2d 00 00 00 00 00 00 00 00 33 33 00 02
b0: 05 cc 84 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 0a 00 0a 00 08 00 02 a8
d0: 01 00 02 6b 42 00 00 00 00 00 00 00 00 00 40 e0
e0: 01 00 02 6b 42 00 00 00 00 00 00 00 00 00 d0 07
f0: 00 00 00 00 00 00 00 00 00 00 0c 00 00 00 00 00

00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
00: de 10 6f 02 07 00 b0 00 a2 01 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 04 04 80 a0 a0 80 02
20: b0 fd b0 fd a0 fd a0 fd 00 00 00 00 00 00 00 00
30: 00 00 00 00 b8 00 00 00 00 00 00 00 ff 00 04 02
40: 00 00 03 00 01 00 02 00 07 00 00 00 00 00 44 00
50: 00 00 fe 7f 00 00 00 00 ff 1f ff 1f 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 00 a8
90: 00 00 e0 fe 00 00 00 00 00 00 00 00 00 00 00 00
a0: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 ff ff 00 00 0d 8c 00 00 00 00 00 00
c0: 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a=
2)
00: de 10 6c 02 06 00 b0 00 a2 00 03 04 00 00 80 00
10: 00 80 02 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 cb 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 02 02 05
40: 43 10 cb 81 01 50 02 c0 00 00 00 00 01 01 0f 00
50: 05 6c 80 01 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 0f 00 00 00 08 00 02 a8
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 46 00 29 00 00 00 00 00 00

00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
00: de 10 69 02 07 00 b0 00 a3 00 80 06 00 00 00 00
10: 00 c0 02 fe 01 dc 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 6a 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 01 14
40: 43 10 6a 81 01 00 02 fe 00 01 00 00 0b 00 00 10
50: 05 6c 84 01 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 0f 00 00 00 08 00 02 a8
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 11 00 00 00 42 01 00 00 00 00 00 00

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
HyperTransport Technology Configuration
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 00 00 01 00 e4 00 00 00 20 c8 00 0f 0c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 00 01 21 20 00 11 11 22 06 75 80 02 00 00 00
90: 69 01 61 01 00 00 04 00 07 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
Address Map
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 7f 00 00 00 00 00 01 00 00 00
50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
80: 03 0a 00 00 00 0b 00 00 00 00 00 00 00 00 00 00
90: 03 00 80 00 00 ff df 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 03 00 f0 00 00 02 fe 00
b0: 03 00 e0 00 80 4f e0 00 00 00 00 00 00 00 00 00
c0: 13 90 00 00 00 f0 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M=20
Controller
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 01 00 00 00 01 01 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 e0 3e 78 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 46 00 00 00 00 00 00 00
80: 20 00 00 00 00 00 00 00 24 c2 6a 0c 20 13 82 00
90: 10 0c 01 00 5a 80 10 a7 24 00 00 80 20 22 2b 00
a0: ef 02 00 0c 00 00 00 00 00 00 00 00 00 00 00 00
b0: ab ef 81 82 04 00 00 00 09 3b 83 c9 20 28 58 06
c0: 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 5e 3a 0a 42 a0 64 b8 a1 69 4e 87 59 a2 67 12 14
e0: 8a 1e 65 41 60 60 54 29 29 87 4e 0b 9c 37 c4 0e
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
Miscellaneous Control
00: 22 10 03 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 04 00 40 00 10 0a 00 00 00 00 00 00 00 00
50: e0 35 76 07 30 00 00 00 00 00 00 00 00 80 60 00
60: 64 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 32 51 21 40 70 50 00 2a 00 08 17 21 00 00
80: 00 00 07 23 13 21 13 21 00 00 00 00 00 00 00 00
90: 00 00 00 00 ea 5b 00 00 40 80 03 20 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 01 a7 0d 00 00 00 80 08 26 26 26 00
e0: 00 00 00 00 24 1b 55 00 19 17 00 00 00 00 00 00
f0: 0f 00 10 00 00 00 00 00 00 00 00 00 b2 0f 04 00

04:05.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000=
=20
Controller (PHY/Link)
00: 4c 10 23 80 06 00 10 02 00 10 00 0c 08 20 00 00
10: 00 f0 bf fd 00 80 bf fd 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 8b 80
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 01 02 04
40: 00 00 00 00 01 00 02 7e 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 88 00 00 00
f0: 10 00 00 00 82 10 00 00 43 10 8b 80 00 00 01 01


=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1273389.fZv2MMV1JZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGdqKQxU2n/+9+t5gRAvJoAJwPO0HU1chpPYVp/cpIH55rXD2NZACfX1E2
Bl95ZV2iy1XOeWvbziyCupM=
=47KE
-----END PGP SIGNATURE-----

--nextPart1273389.fZv2MMV1JZ--
