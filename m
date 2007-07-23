Return-Path: <linux-kernel-owner+w=401wt.eu-S934715AbXGWTi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715AbXGWTi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXGWTiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:38:07 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60605 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934614AbXGWTh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:37:59 -0400
X-Sasl-enc: M6kY+1VhaTi012KwoJPqRMUzbULCJtcFoZvNEkueuvNQ 1185219475
Message-ID: <46A504A3.3070205@imap.cc>
Date: Mon, 23 Jul 2007 21:42:27 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       nix.or.die@googlemail.com
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org>
In-Reply-To: <46A4C081.6070305@goop.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8254F14E4DFB218B68739CB3"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8254F14E4DFB218B68739CB3
Content-Type: multipart/mixed;
 boundary="------------060308090305030501030804"

This is a multi-part message in MIME format.
--------------060308090305030501030804
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 23.07.2007 16:51 schrieb Jeremy Fitzhardinge:
> Tilman Schmidt wrote:
>> Attached are .config and dmesg (as captured in SuSE's /var/log/boot.ms=
g)
>> of a CONFIG_XEN=3Dn git-current build.=20
>=20
> That's dmesg from a successful boot?

Yes.

>  What does it look like when its
> unsuccessful?  Where do they start to differ?

To answer that, I have reproduced the effect with kernel 2.6.23-rc1 with
netconsole compiled in. I'm attaching both captures, for CONFIG_XEN=3Dy
(unsuccessful) as well CONFIG_XEN=3Dn (successful).

The first noticeable difference is that the nonzero timestamps starting
after the line "Detected 3197.059 MHz processor" are much bigger with XEN=
 -
but perhaps that's expected.

More to the point, everything from:

  SCSI subsystem initialized

on is completely missing, including all the [S/P]ATA, SCSI, parport, AGP,=

USB, Firewire, RTC and of course ext3 messages. Only the "device-mapper"
line still appears.

Btw, the NULL pointer BUG at the end of the successful boot is new with
2.6.23-rc1. I'll report that separately but didn't want to edit anything.=


HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)

--------------060308090305030501030804
Content-Type: text/plain;
 name="netconsole-2.6.23-rc1-xen"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="netconsole-2.6.23-rc1-xen"

[    0.000000] Linux version 2.6.23-rc1-xentest (ts@xenon) (gcc version 4=
=2E1.2 20061115 (prerelease) (SUSE Linux)) #4 SMP PREEMPT Mon Jul 23 20:0=
2:38 CEST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 000000003e584000 (usable)
[    0.000000]  BIOS-e820: 000000003e584000 - 000000003e591000 (reserved)=

[    0.000000]  BIOS-e820: 000000003e591000 - 000000003e631000 (usable)
[    0.000000]  BIOS-e820: 000000003e631000 - 000000003e6a4000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000003e6a4000 - 000000003e6a9000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000003e6a9000 - 000000003e6f2000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000003e6f2000 - 000000003e6ff000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000003e6ff000 - 000000003e700000 (usable)
[    0.000000]  BIOS-e820: 000000003e700000 - 000000003f000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)=

[    0.000000] 103MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000fe200
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   255744
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   255744
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 3E6FD038, 0054 (r1 INTEL  DQ965GF      15DB    =
   1000013)
[    0.000000] ACPI: FACP 3E6FC000, 0074 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: DSDT 3E6F7000, 40E9 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: FACS 3E6AA000, 0040
[    0.000000] ACPI: APIC 3E6F6000, 0078 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: WDDT 3E6F5000, 0040 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: MCFG 3E6F4000, 003C (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: ASF! 3E6F3000, 00A6 (r32 INTEL  DQ965GF      15DB MS=
FT  1000013)
[    0.000000] ACPI: HPET 3E6F2000, 0038 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A8000, 01BC (r1 INTEL     CpuPm     15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A7000, 0175 (r1 INTEL   Cpu0Ist     15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A6000, 0175 (r1 INTEL   Cpu1Ist     15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A5000, 0175 (r1 INTEL   Cpu2Ist     15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A4000, 0175 (r1 INTEL   Cpu3Ist     15DB MSF=
T  1000013)
[    0.000000] ACPI: TCPA 3E6A9000, 0A3F (r1 INTEL  TIANO           2 MSF=
T  1000013)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f0000=
00:c0e00000)
[    0.000000] swsusp: Registered nosave memory region: 000000000008f000 =
- 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 =
- 00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 =
- 0000000000100000
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 252248
[    0.000000] Kernel command line: root=3D/dev/system/root video=3Dmatro=
xfb:vesa:0x31b resume=3D/dev/system/swap splash=3Dverbose netconsole=3D66=
65@192.168.59.102/eth0,6666@192.168.59.127/00:50:da:82:a0:46
[    0.000000] netconsole: local port 6665
[    0.000000] netconsole: local IP 192.168.59.102
[    0.000000] netconsole: interface eth0
[    0.000000] netconsole: remote port 6666
[    0.000000] netconsole: remote IP 192.168.59.127
[    0.000000] netconsole: remote ethernet address 00:50:da:82:a0:46
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc0463000 soft=3Dc045b000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 3197.106 MHz processor.
[  191.420290] Console: colour VGA+ 80x25
[  191.420297] console [tty0] enabled
[  191.426015] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[  191.426107] ... MAX_LOCKDEP_SUBCLASSES:    8
[  191.426177] ... MAX_LOCK_DEPTH:          30
[  191.426246] ... MAX_LOCKDEP_KEYS:        2048
[  191.426316] ... CLASSHASH_SIZE:           1024
[  191.426386] ... MAX_LOCKDEP_ENTRIES:     8192
[  191.426456] ... MAX_LOCKDEP_CHAINS:      16384
[  191.426526] ... CHAINHASH_SIZE:          8192
[  191.426597]  memory used by lock dependency info: 992 kB
[  191.426669]  per task-struct memory footprint: 1200 bytes
[  191.426741] ------------------------
[  191.426809] | Locking API testsuite:
[  191.426878] ----------------------------------------------------------=
------------------
[  191.426970]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[  191.427061]   --------------------------------------------------------=
------------------
[  191.427158]                      A-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.428041]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.428922]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.429815]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.430708]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.431619]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.432529]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.433441]                     double unlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.434301]                   initialize held:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.435160]                  bad unlock order:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[  191.436036]   --------------------------------------------------------=
------------------
[  191.436128]               recursive read-lock:             |  ok  |   =
          |  ok  |
[  191.436601]            recursive read-lock #2:             |  ok  |   =
          |  ok  |
[  191.437075]             mixed read-write-lock:             |  ok  |   =
          |  ok  |
[  191.437549]             mixed write-read-lock:             |  ok  |   =
          |  ok  |
[  191.438024]   --------------------------------------------------------=
------------------
[  191.438116]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  191.438597]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  191.439080]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  191.439563]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  191.440048]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[  191.440534]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[  191.441020]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  191.441504]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  191.441991]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  191.442476]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  191.442962]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  191.443455]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  191.443949]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  191.444441]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  191.444934]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  191.445426]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  191.445919]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  191.446410]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  191.446902]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  191.447390]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  191.447879]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  191.448370]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  191.448862]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  191.449355]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  191.449851]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  191.450343]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  191.450837]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  191.451329]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  191.451824]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  191.452314]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  191.452808]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  191.453300]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  191.453795]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  191.454286]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  191.454780]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  191.455273]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  191.455770]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  191.456263]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  191.456760]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  191.457253]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  191.457749]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  191.458242]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  191.458737]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  191.459231]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  191.461452]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  191.461944]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  191.462440]       hard-irq read-recursion/123:  ok  |
[  191.462684]       soft-irq read-recursion/123:  ok  |
[  191.462928]       hard-irq read-recursion/132:  ok  |
[  191.463170]       soft-irq read-recursion/132:  ok  |
[  191.463414]       hard-irq read-recursion/213:  ok  |
[  191.463657]       soft-irq read-recursion/213:  ok  |
[  191.463901]       hard-irq read-recursion/231:  ok  |
[  191.464143]       soft-irq read-recursion/231:  ok  |
[  191.464386]       hard-irq read-recursion/312:  ok  |
[  191.464629]       soft-irq read-recursion/312:  ok  |
[  191.464874]       hard-irq read-recursion/321:  ok  |
[  191.465117]       soft-irq read-recursion/321:  ok  |
[  191.465360] -------------------------------------------------------
[  191.465435] Good, all 218 testcases passed! |
[  191.465505] ---------------------------------
[  191.465808] Dentry cache hash table entries: 131072 (order: 7, 524288 =
bytes)
[  191.466266] Inode-cache hash table entries: 65536 (order: 6, 262144 by=
tes)
[  191.494322] Memory: 993204k/1022976k available (2079k kernel code, 280=
52k reserved, 1067k data, 256k init, 104596k highmem)
[  191.494428] virtual kernel memory layout:
[  191.494429]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[  191.494430]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[  191.494431]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[  191.494433]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[  191.494434]       .init : 0xc0417000 - 0xc0457000   ( 256 kB)
[  191.494435]       .data : 0xc0307f2a - 0xc0412e64   (1067 kB)
[  191.494436]       .text : 0xc0100000 - 0xc0307f2a   (2079 kB)
[  191.495000] Checking if this processor honours the WP bit even in supe=
rvisor mode... Ok.
[  191.495185] SLUB: Genslabs=3D22, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D2, Nodes=3D1
[  191.495363] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[  191.495624] hpet0: 3 64-bit timers, 14318180 Hz
[  191.556656] Calibrating delay using timer specific routine.. 6399.65 B=
ogoMIPS (lpj=3D3199828)
[  191.556827] Security Framework v1.0.0 initialized
[  191.556920] Mount-cache hash table entries: 512
[  191.557408] monitor/mwait feature present.
[  191.557478] using mwait in idle threads.
[  191.557553] CPU: Trace cache: 12K uops, L1 D cache: 16K
[  191.557684] CPU: L2 cache: 2048K
[  191.557754] CPU: Physical Processor ID: 0
[  191.557823] CPU: Processor Core ID: 0
[  191.557902] Intel machine check architecture supported.
[  191.557979] Intel machine check reporting enabled on CPU#0.
[  191.558053] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[  191.558128] CPU0: Thermal monitoring enabled
[  191.558202] Compat vDSO mapped to ffffe000.
[  191.558285] Checking 'hlt' instruction... OK.
[  191.561978] lockdep: not fixing up alternatives.
[  191.563203] ACPI: Core revision 20070126
[  191.566968] CPU0: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
[  191.567162] lockdep: not fixing up alternatives.
[  191.567234] Booting processor 1/1 eip 3000
[  191.567305] CPU 1 irqstacks, hard=3Dc0464000 soft=3Dc045c000
[  191.577916] Initializing CPU#1
[  191.637570] Calibrating delay using timer specific routine.. 6393.68 B=
ogoMIPS (lpj=3D3196843)
[  191.637586] monitor/mwait feature present.
[  191.637592] CPU: Trace cache: 12K uops, L1 D cache: 16K
[  191.637594] CPU: L2 cache: 2048K
[  191.637596] CPU: Physical Processor ID: 0
[  191.637598] CPU: Processor Core ID: 1
[  191.637605] Intel machine check architecture supported.
[  191.637612] Intel machine check reporting enabled on CPU#1.
[  191.637614] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[  191.637618] CPU1: Thermal monitoring enabled
[  191.638046] CPU1: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
[  191.639026] Total of 2 processors activated (12793.34 BogoMIPS).
[  191.639253] ENABLING IO-APIC IRQs
[  191.639517] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[  191.751654] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[  191.771793] Brought up 2 CPUs
[  191.772446] Booting paravirtualized kernel on bare hardware
[  191.772772] NET: Registered protocol family 16
[  191.773341] ACPI: bus type pci registered
[  191.773632] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[  191.773710] PCI: Not using MMCONFIG.
[  191.776230] PCI: Using configuration type 1
[  191.776301] Setting up standard PCI resources
[  191.787838] ACPI: Interpreter enabled
[  191.787911] ACPI: (supports S0 S3 S4 S5)
[  191.788241] ACPI: Using IOAPIC for interrupt routing
[  191.798830] ACPI: PCI Root Bridge [PCI0] (0000:00)
[  191.800144] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[  191.800222] PCI quirk: region 0500-053f claimed by ICH6 GPIO
[  191.802181] PCI: Transparent bridge - 0000:00:1e.0
[  191.812928] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *9 10 11 12)=

[  191.813621] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)=

[  191.814291] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)=

[  191.814961] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)=

[  191.815639] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)=

[  191.816309] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12)=

[  191.816980] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)=

[  191.817657] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)=

[  191.818524] Linux Plug and Play Support v0.97 (c) Adam Belay
[  191.818682] pnp: PnP ACPI init
[  191.818776] ACPI: bus type pnp registered
[  191.823159] pnp: PnP ACPI: found 13 devices
[  191.823231] ACPI: ACPI bus type pnp unregistered
[  191.823844] PCI: Using ACPI for IRQ routing
[  191.823920] PCI: If a device doesn't work, try "pci=3Drouteirq".  If i=
t helps, post a report
[  191.829531] NetLabel: Initializing
[  191.829606] NetLabel:  domain hash size =3D 128
[  191.829676] NetLabel:  protocols =3D UNLABELED CIPSOv4
[  191.829779] NetLabel:  unlabeled traffic allowed by default
[  191.829912] ACPI: RTC can wake from S4
[  191.830496] Time: tsc clocksource has been installed.
[  191.832598] pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been res=
erved
[  191.832675] pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been res=
erved
[  191.832752] pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been res=
erved
[  191.832828] pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been res=
erved
[  191.832916] pnp: 00:06: ioport range 0x500-0x53f has been reserved
[  191.832992] pnp: 00:06: ioport range 0x400-0x47f has been reserved
[  191.833067] pnp: 00:06: ioport range 0x680-0x6ff has been reserved
[  191.833150] pnp: 00:07: iomem range 0xfed40000-0xfed44fff has been res=
erved
[  191.864063] PCI: Bridge: 0000:00:1c.0
[  191.864133]   IO window: disabled.
[  191.864206]   MEM window: 52d00000-52dfffff
[  191.864279]   PREFETCH window: disabled.
[  191.864353] PCI: Bridge: 0000:00:1c.1
[  191.864423]   IO window: 2000-2fff
[  191.864496]   MEM window: 52a00000-52afffff
[  191.864574]   PREFETCH window: disabled.
[  191.864648] PCI: Bridge: 0000:00:1c.2
[  191.864716]   IO window: disabled.
[  191.864789]   MEM window: 52e00000-52efffff
[  191.864862]   PREFETCH window: disabled.
[  191.864938] PCI: Bridge: 0000:04:00.0
[  191.865007]   IO window: disabled.
[  191.865082]   MEM window: 52000000-528fffff
[  191.865156]   PREFETCH window: 50000000-51ffffff
[  191.865234] PCI: Bridge: 0000:00:1c.3
[  191.865302]   IO window: disabled.
[  191.865375]   MEM window: 52000000-528fffff
[  191.865447]   PREFETCH window: 50000000-51ffffff
[  191.865527] PCI: Bridge: 0000:00:1c.4
[  191.865596]   IO window: disabled.
[  191.865669]   MEM window: 52f00000-52ffffff
[  191.865741]   PREFETCH window: disabled.
[  191.865816] PCI: Bridge: 0000:00:1e.0
[  191.865887]   IO window: 1000-1fff
[  191.865959]   MEM window: 52900000-529fffff
[  191.866032]   PREFETCH window: 53000000-530fffff
[  191.866135] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low)=
 -> IRQ 16
[  191.866305] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low)=
 -> IRQ 17
[  191.866472] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low)=
 -> IRQ 18
[  191.866646] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low)=
 -> IRQ 19
[  191.866836] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low)=
 -> IRQ 16
[  191.867003] NET: Registered protocol family 2
[  191.876576] IP route cache hash table entries: 32768 (order: 5, 131072=
 bytes)
[  191.876955] TCP established hash table entries: 65536 (order: 9, 26214=
40 bytes)
[  191.883752] TCP bind hash table entries: 65536 (order: 9, 2359296 byte=
s)
[  191.890300] TCP: Hash tables configured (established 65536 bind 65536)=

[  191.890403] TCP reno registered
[  191.892756] checking if image is initramfs...<6>Switched to high resol=
ution mode on CPU 1
[  192.120271] Switched to high resolution mode on CPU 0
[  192.161400]  it is
[  192.459162] Freeing initrd memory: 7233k freed
[  192.460119] Machine check exception polling timer started.
[  192.460230] apm: BIOS not found.
[  192.461117] audit: initializing netlink socket (disabled)
[  192.461209] audit(1185214888.711:1): initialized
[  192.461553] highmem bounce pool size: 64 pages
[  192.461631] Total HugeTLB memory allocated, 0
[  192.468607] VFS: Disk quotas dquot_6.5.1
[  192.468814] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[  192.469840] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 254)
[  192.469941] io scheduler noop registered
[  192.471750] io scheduler anticipatory registered
[  192.471822] io scheduler deadline registered (default)
[  192.471910] io scheduler cfq registered
[  192.472669] assign_interrupt_mode Found MSI capability
[  192.473137] assign_interrupt_mode Found MSI capability
[  192.473599] assign_interrupt_mode Found MSI capability
[  192.474072] assign_interrupt_mode Found MSI capability
[  192.474523] assign_interrupt_mode Found MSI capability
[  192.475278] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low)=
 -> IRQ 19
[  192.475420] matroxfb: Matrox G550 detected
[  192.476537] PInS memtype =3D 5
[  192.477532] matroxfb: MTRR's turned on
[  192.477650] matroxfb: 1280x1024x32bpp (virtual: 1280x3276)
[  192.477724] matroxfb: framebuffer at 0x50000000, mapped to 0xf8880000,=
 size 33554432
[  192.478005] fbcon: MATROX (fb0) is primary device
[  192.498714] Console: switching to colour frame buffer device 160x64
[  192.506429] fb0: MATROX frame buffer device
[  192.506642] matroxfb_crtc2: secondary head of fb0 was registered as fb=
1
[  192.564340] Real Time Clock Driver v1.12ac
[  192.564673] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ s=
haring enabled
[  192.565889] 00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  195.574683] floppy0: no floppy controllers found
[  195.576446] RAMDISK driver initialized: 16 RAM disks of 64000K size 10=
24 blocksize
[  195.576543] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[  195.576619] Copyright (c) 1999-2006 Intel Corporation.
[  195.576808] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low)=
 -> IRQ 20
[  195.594347] e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Wid=
th x1) 00:19:d1:03:d8:ff
[  195.669735] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connec=
tion
[  195.670032] netconsole: device eth0 not up yet, forcing it
[  197.300737] e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full =
Duplex, Flow Control: RX
[  197.300834] e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
[  197.315401] console [netcon0] enabled
[  198.446668] netconsole: network logging started
[  198.451575] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[  198.456213] PNP: PS/2 appears to have AUX port disabled, if this is in=
correct please boot with i8042.nopnp
[  198.461647] serio: i8042 KBD port at 0x60,0x64 irq 1
[  198.466767] mice: PS/2 mouse device common for all mice
[  198.498362] input: AT Translated Set 2 keyboard as /class/input/input0=

[  198.503705] input: PC Speaker as /class/input/input1
[  198.508785] NET: Registered protocol family 1
[  198.513594] Starting balanced_irq
[  198.518421] Using IPI No-Shortcut mode
[  198.523888] Freeing unused kernel memory: 256k freed
[  198.528639] Write protecting the kernel text: 2080k
[  198.533323] Write protecting the kernel read-only data: 835k
[  199.088098] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialise=
d: dm-devel@redhat.com
>>> system on emergency shell prompt
>>> pressed ctrl/alt/del
[  270.487595] md: stopping all md devices.

--------------060308090305030501030804
Content-Type: text/plain;
 name="netconsole-2.6.23-rc1-noxen"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="netconsole-2.6.23-rc1-noxen"

[    0.000000] Linux version 2.6.23-rc1-testing (ts@xenon) (gcc version 4=
=2E1.2 20061115 (prerelease) (SUSE Linux)) #5 SMP PREEMPT Mon Jul 23 20:3=
2:38 CEST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 000000003e584000 (usable)
[    0.000000]  BIOS-e820: 000000003e584000 - 000000003e591000 (reserved)=

[    0.000000]  BIOS-e820: 000000003e591000 - 000000003e631000 (usable)
[    0.000000]  BIOS-e820: 000000003e631000 - 000000003e6a4000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000003e6a4000 - 000000003e6a9000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000003e6a9000 - 000000003e6f2000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000003e6f2000 - 000000003e6ff000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000003e6ff000 - 000000003e700000 (usable)
[    0.000000]  BIOS-e820: 000000003e700000 - 000000003f000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)=

[    0.000000] 103MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000fe200
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   255744
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   255744
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 3E6FD038, 0054 (r1 INTEL  DQ965GF      15DB    =
   1000013)
[    0.000000] ACPI: FACP 3E6FC000, 0074 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: DSDT 3E6F7000, 40E9 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: FACS 3E6AA000, 0040
[    0.000000] ACPI: APIC 3E6F6000, 0078 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: WDDT 3E6F5000, 0040 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: MCFG 3E6F4000, 003C (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: ASF! 3E6F3000, 00A6 (r32 INTEL  DQ965GF      15DB MS=
FT  1000013)
[    0.000000] ACPI: HPET 3E6F2000, 0038 (r1 INTEL  DQ965GF      15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A8000, 01BC (r1 INTEL     CpuPm     15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A7000, 0175 (r1 INTEL   Cpu0Ist     15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A6000, 0175 (r1 INTEL   Cpu1Ist     15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A5000, 0175 (r1 INTEL   Cpu2Ist     15DB MSF=
T  1000013)
[    0.000000] ACPI: SSDT 3E6A4000, 0175 (r1 INTEL   Cpu3Ist     15DB MSF=
T  1000013)
[    0.000000] ACPI: TCPA 3E6A9000, 0A3F (r1 INTEL  TIANO           2 MSF=
T  1000013)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f0000=
00:c0e00000)
[    0.000000] swsusp: Registered nosave memory region: 000000000008f000 =
- 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 =
- 00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 =
- 0000000000100000
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 252248
[    0.000000] Kernel command line: root=3D/dev/system/root video=3Dmatro=
xfb:vesa:0x31b resume=3D/dev/system/swap splash=3Dverbose netconsole=3D66=
65@192.168.59.102/eth0,6666@192.168.59.127/00:50:da:82:a0:46
[    0.000000] netconsole: local port 6665
[    0.000000] netconsole: local IP 192.168.59.102
[    0.000000] netconsole: interface eth0
[    0.000000] netconsole: remote port 6666
[    0.000000] netconsole: remote IP 192.168.59.127
[    0.000000] netconsole: remote ethernet address 00:50:da:82:a0:46
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc044f000 soft=3Dc0447000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 3197.038 MHz processor.
[   58.886774] Console: colour VGA+ 80x25
[   58.886780] console [tty0] enabled
[   58.892484] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[   58.892575] ... MAX_LOCKDEP_SUBCLASSES:    8
[   58.892645] ... MAX_LOCK_DEPTH:          30
[   58.892715] ... MAX_LOCKDEP_KEYS:        2048
[   58.892784] ... CLASSHASH_SIZE:           1024
[   58.892855] ... MAX_LOCKDEP_ENTRIES:     8192
[   58.892925] ... MAX_LOCKDEP_CHAINS:      16384
[   58.892995] ... CHAINHASH_SIZE:          8192
[   58.893065]  memory used by lock dependency info: 992 kB
[   58.893137]  per task-struct memory footprint: 1200 bytes
[   58.893209] ------------------------
[   58.893277] | Locking API testsuite:
[   58.893346] ----------------------------------------------------------=
------------------
[   58.893437]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[   58.893529]   --------------------------------------------------------=
------------------
[   58.893626]                      A-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.894493]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.895353]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.896217]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.897078]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.897959]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.898836]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.899715]                     double unlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.900554]                   initialize held:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.901393]                  bad unlock order:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[   58.902235]   --------------------------------------------------------=
------------------
[   58.902327]               recursive read-lock:             |  ok  |   =
          |  ok  |
[   58.902793]            recursive read-lock #2:             |  ok  |   =
          |  ok  |
[   58.903260]             mixed read-write-lock:             |  ok  |   =
          |  ok  |
[   58.903728]             mixed write-read-lock:             |  ok  |   =
          |  ok  |
[   58.904195]   --------------------------------------------------------=
------------------
[   58.904287]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   58.904754]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   58.905230]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   58.905704]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   58.906179]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[   58.906646]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[   58.907121]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   58.907594]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   58.908070]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   58.908543]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   58.909018]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   58.909500]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   58.909980]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   58.910461]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   58.910935]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   58.911413]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   58.911889]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   58.912369]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   58.912850]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   58.913326]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   58.913804]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   58.914285]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   58.914766]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   58.915249]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   58.915726]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   58.916204]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   58.916684]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   58.917166]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   58.917642]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   58.918125]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   58.918602]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   58.919077]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   58.919562]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   58.920045]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   58.920529]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   58.921009]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   58.921496]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   58.921973]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   58.922449]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   58.922923]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   58.923399]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   58.923873]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   58.924357]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   58.924840]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   58.927029]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   58.927502]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   58.927977]       hard-irq read-recursion/123:  ok  |
[   58.928217]       soft-irq read-recursion/123:  ok  |
[   58.928456]       hard-irq read-recursion/132:  ok  |
[   58.928695]       soft-irq read-recursion/132:  ok  |
[   58.928940]       hard-irq read-recursion/213:  ok  |
[   58.929183]       soft-irq read-recursion/213:  ok  |
[   58.929422]       hard-irq read-recursion/231:  ok  |
[   58.929661]       soft-irq read-recursion/231:  ok  |
[   58.929900]       hard-irq read-recursion/312:  ok  |
[   58.930138]       soft-irq read-recursion/312:  ok  |
[   58.930378]       hard-irq read-recursion/321:  ok  |
[   58.930616]       soft-irq read-recursion/321:  ok  |
[   58.930856] -------------------------------------------------------
[   58.930930] Good, all 218 testcases passed! |
[   58.931000] ---------------------------------
[   58.931301] Dentry cache hash table entries: 131072 (order: 7, 524288 =
bytes)
[   58.931755] Inode-cache hash table entries: 65536 (order: 6, 262144 by=
tes)
[   58.959609] Memory: 993164k/1022976k available (2037k kernel code, 280=
96k reserved, 1041k data, 248k init, 104596k highmem)
[   58.959715] virtual kernel memory layout:
[   58.959716]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[   58.959717]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   58.959718]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   58.959719]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   58.959721]       .init : 0xc0406000 - 0xc0444000   ( 248 kB)
[   58.959722]       .data : 0xc02fd5b9 - 0xc0401ce4   (1041 kB)
[   58.959723]       .text : 0xc0100000 - 0xc02fd5b9   (2037 kB)
[   58.960285] Checking if this processor honours the WP bit even in supe=
rvisor mode... Ok.
[   58.960467] SLUB: Genslabs=3D22, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D2, Nodes=3D1
[   58.960645] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   58.960905] hpet0: 3 64-bit timers, 14318180 Hz
[   59.021938] Calibrating delay using timer specific routine.. 6399.59 B=
ogoMIPS (lpj=3D3199798)
[   59.022109] Security Framework v1.0.0 initialized
[   59.022202] Mount-cache hash table entries: 512
[   59.022675] monitor/mwait feature present.
[   59.022745] using mwait in idle threads.
[   59.022819] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   59.022950] CPU: L2 cache: 2048K
[   59.023019] CPU: Physical Processor ID: 0
[   59.023088] CPU: Processor Core ID: 0
[   59.023166] Intel machine check architecture supported.
[   59.023243] Intel machine check reporting enabled on CPU#0.
[   59.023316] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[   59.023391] CPU0: Thermal monitoring enabled
[   59.023465] Compat vDSO mapped to ffffe000.
[   59.023547] Checking 'hlt' instruction... OK.
[   59.027250] lockdep: not fixing up alternatives.
[   59.028437] ACPI: Core revision 20070126
[   59.032167] CPU0: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
[   59.032361] lockdep: not fixing up alternatives.
[   59.032433] Booting processor 1/1 eip 3000
[   59.032504] CPU 1 irqstacks, hard=3Dc0450000 soft=3Dc0448000
[   59.043084] Initializing CPU#1
[   59.102852] Calibrating delay using timer specific routine.. 6393.65 B=
ogoMIPS (lpj=3D3196828)
[   59.102867] monitor/mwait feature present.
[   59.102873] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   59.102875] CPU: L2 cache: 2048K
[   59.102877] CPU: Physical Processor ID: 0
[   59.102879] CPU: Processor Core ID: 1
[   59.102887] Intel machine check architecture supported.
[   59.102894] Intel machine check reporting enabled on CPU#1.
[   59.102896] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[   59.102900] CPU1: Thermal monitoring enabled
[   59.103339] CPU1: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
[   59.104317] Total of 2 processors activated (12793.25 BogoMIPS).
[   59.104543] ENABLING IO-APIC IRQs
[   59.104806] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[   59.216935] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   59.237073] Brought up 2 CPUs
[   59.237701] Booting paravirtualized kernel on bare hardware
[   59.238018] NET: Registered protocol family 16
[   59.238587] ACPI: bus type pci registered
[   59.238880] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[   59.238958] PCI: Not using MMCONFIG.
[   59.241469] PCI: Using configuration type 1
[   59.241539] Setting up standard PCI resources
[   59.253054] ACPI: Interpreter enabled
[   59.253132] ACPI: (supports S0 S3 S4 S5)
[   59.253460] ACPI: Using IOAPIC for interrupt routing
[   59.263806] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   59.265110] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[   59.265188] PCI quirk: region 0500-053f claimed by ICH6 GPIO
[   59.267114] PCI: Transparent bridge - 0000:00:1e.0
[   59.277888] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *9 10 11 12)=

[   59.278561] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)=

[   59.279230] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)=

[   59.279907] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)=

[   59.280574] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)=

[   59.281243] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12)=

[   59.281917] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)=

[   59.282586] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)=

[   59.283463] Linux Plug and Play Support v0.97 (c) Adam Belay
[   59.283627] pnp: PnP ACPI init
[   59.283718] ACPI: bus type pnp registered
[   59.288107] pnp: PnP ACPI: found 13 devices
[   59.288179] ACPI: ACPI bus type pnp unregistered
[   59.288764] PCI: Using ACPI for IRQ routing
[   59.288850] PCI: If a device doesn't work, try "pci=3Drouteirq".  If i=
t helps, post a report
[   59.293883] NetLabel: Initializing
[   59.293958] NetLabel:  domain hash size =3D 128
[   59.294028] NetLabel:  protocols =3D UNLABELED CIPSOv4
[   59.294132] NetLabel:  unlabeled traffic allowed by default
[   59.294261] ACPI: RTC can wake from S4
[   59.294835] Time: tsc clocksource has been installed.
[   59.296936] pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been res=
erved
[   59.297013] pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been res=
erved
[   59.297089] pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been res=
erved
[   59.297165] pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been res=
erved
[   59.297253] pnp: 00:06: ioport range 0x500-0x53f has been reserved
[   59.297329] pnp: 00:06: ioport range 0x400-0x47f has been reserved
[   59.297404] pnp: 00:06: ioport range 0x680-0x6ff has been reserved
[   59.297487] pnp: 00:07: iomem range 0xfed40000-0xfed44fff has been res=
erved
[   59.328405] PCI: Bridge: 0000:00:1c.0
[   59.328475]   IO window: disabled.
[   59.328548]   MEM window: 52d00000-52dfffff
[   59.328620]   PREFETCH window: disabled.
[   59.328695] PCI: Bridge: 0000:00:1c.1
[   59.328766]   IO window: 2000-2fff
[   59.328839]   MEM window: 52a00000-52afffff
[   59.328917]   PREFETCH window: disabled.
[   59.328991] PCI: Bridge: 0000:00:1c.2
[   59.329059]   IO window: disabled.
[   59.329132]   MEM window: 52e00000-52efffff
[   59.329204]   PREFETCH window: disabled.
[   59.329279] PCI: Bridge: 0000:04:00.0
[   59.329348]   IO window: disabled.
[   59.329422]   MEM window: 52000000-528fffff
[   59.329496]   PREFETCH window: 50000000-51ffffff
[   59.329573] PCI: Bridge: 0000:00:1c.3
[   59.329641]   IO window: disabled.
[   59.329713]   MEM window: 52000000-528fffff
[   59.329786]   PREFETCH window: 50000000-51ffffff
[   59.329865] PCI: Bridge: 0000:00:1c.4
[   59.329934]   IO window: disabled.
[   59.330006]   MEM window: 52f00000-52ffffff
[   59.330078]   PREFETCH window: disabled.
[   59.330153] PCI: Bridge: 0000:00:1e.0
[   59.330224]   IO window: 1000-1fff
[   59.330296]   MEM window: 52900000-529fffff
[   59.330369]   PREFETCH window: 53000000-530fffff
[   59.330472] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low)=
 -> IRQ 16
[   59.330639] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low)=
 -> IRQ 17
[   59.330806] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low)=
 -> IRQ 18
[   59.330979] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low)=
 -> IRQ 19
[   59.331167] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low)=
 -> IRQ 16
[   59.331334] NET: Registered protocol family 2
[   59.340916] IP route cache hash table entries: 32768 (order: 5, 131072=
 bytes)
[   59.341287] TCP established hash table entries: 65536 (order: 9, 26214=
40 bytes)
[   59.348077] TCP bind hash table entries: 65536 (order: 9, 2359296 byte=
s)
[   59.354625] TCP: Hash tables configured (established 65536 bind 65536)=

[   59.354727] TCP reno registered
[   59.357096] checking if image is initramfs...<6>Switched to high resol=
ution mode on CPU 1
[   59.585609] Switched to high resolution mode on CPU 0
[   59.628967]  it is
[   59.928624] Freeing initrd memory: 7373k freed
[   59.929585] Machine check exception polling timer started.
[   59.929696] apm: BIOS not found.
[   59.930565] audit: initializing netlink socket (disabled)
[   59.930661] audit(1185216142.710:1): initialized
[   59.931029] highmem bounce pool size: 64 pages
[   59.931111] Total HugeTLB memory allocated, 0
[   59.937880] VFS: Disk quotas dquot_6.5.1
[   59.938091] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[   59.939124] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 254)
[   59.939226] io scheduler noop registered
[   59.941044] io scheduler anticipatory registered
[   59.941116] io scheduler deadline registered (default)
[   59.941204] io scheduler cfq registered
[   59.941967] assign_interrupt_mode Found MSI capability
[   59.942438] assign_interrupt_mode Found MSI capability
[   59.942892] assign_interrupt_mode Found MSI capability
[   59.943350] assign_interrupt_mode Found MSI capability
[   59.943824] assign_interrupt_mode Found MSI capability
[   59.944583] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low)=
 -> IRQ 19
[   59.944724] matroxfb: Matrox G550 detected
[   59.945840] PInS memtype =3D 5
[   59.946834] matroxfb: MTRR's turned on
[   59.946948] matroxfb: 1280x1024x32bpp (virtual: 1280x3276)
[   59.947022] matroxfb: framebuffer at 0x50000000, mapped to 0xf8880000,=
 size 33554432
[   59.947304] fbcon: MATROX (fb0) is primary device
[   59.971891] Console: switching to colour frame buffer device 160x64
[   59.979633] fb0: MATROX frame buffer device
[   59.979845] matroxfb_crtc2: secondary head of fb0 was registered as fb=
1
[   60.035897] Real Time Clock Driver v1.12ac
[   60.036249] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ s=
haring enabled
[   60.037532] 00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   63.045936] floppy0: no floppy controllers found
[   63.047683] RAMDISK driver initialized: 16 RAM disks of 64000K size 10=
24 blocksize
[   63.047778] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[   63.047861] Copyright (c) 1999-2006 Intel Corporation.
[   63.048043] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low)=
 -> IRQ 20
[   63.065610] e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Wid=
th x1) 00:19:d1:03:d8:ff
[   63.139979] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connec=
tion
[   63.140312] netconsole: device eth0 not up yet, forcing it
[   64.701024] e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full =
Duplex, Flow Control: RX
[   64.701123] e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
[   64.715671] console [netcon0] enabled
[   65.844897] netconsole: network logging started
[   65.849710] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   65.854303] PNP: PS/2 appears to have AUX port disabled, if this is in=
correct please boot with i8042.nopnp
[   65.859544] serio: i8042 KBD port at 0x60,0x64 irq 1
[   65.864533] mice: PS/2 mouse device common for all mice
[   65.894752] input: AT Translated Set 2 keyboard as /class/input/input0=

[   65.900014] input: PC Speaker as /class/input/input1
[   65.905053] NET: Registered protocol family 1
[   65.909826] Starting balanced_irq
[   65.914596] Using IPI No-Shortcut mode
[   65.920046] Freeing unused kernel memory: 248k freed
[   65.924785] Write protecting the kernel text: 2040k
[   65.929445] Write protecting the kernel read-only data: 813k
[   66.488621] SCSI subsystem initialized
[   66.512301] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, =
Evaluating _PTC [20070126]
[   66.516877] ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, =
Evaluating _TSS [20070126]
[   66.521498] ACPI: Processor [CPU0] (supports 8 throttling states)
[   66.526081] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, =
Evaluating _PTC [20070126]
[   66.530683] ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, =
Evaluating _TSS [20070126]
[   66.535265] ACPI: Processor [CPU1] (supports 8 throttling states)
[   66.539799] ACPI Exception (processor_core-0784): AE_NOT_FOUND, Proces=
sor Device is not present [20070126]
[   66.544419] ACPI Exception (processor_core-0784): AE_NOT_FOUND, Proces=
sor Device is not present [20070126]
[   66.582744] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low)=
 -> IRQ 19
[   67.587416] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps =
0x3f impl SATA mode
[   67.592174] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum =
part=20
[   67.597500] scsi0 : ahci
[   67.602563] scsi1 : ahci
[   67.607434] scsi2 : ahci
[   67.612231] scsi3 : ahci
[   67.617004] scsi4 : ahci
[   67.621764] scsi5 : ahci
[   67.626401] ata1: SATA max UDMA/133 cmd 0xf883e100 ctl 0x00000000 bmdm=
a 0x00000000 irq 217
[   67.631085] ata2: SATA max UDMA/133 cmd 0xf883e180 ctl 0x00000000 bmdm=
a 0x00000000 irq 217
[   67.635754] ata3: SATA max UDMA/133 cmd 0xf883e200 ctl 0x00000000 bmdm=
a 0x00000000 irq 217
[   67.640370] ata4: SATA max UDMA/133 cmd 0xf883e280 ctl 0x00000000 bmdm=
a 0x00000000 irq 217
[   67.644910] ata5: SATA max UDMA/133 cmd 0xf883e300 ctl 0x00000000 bmdm=
a 0x00000000 irq 217
[   67.649357] ata6: SATA max UDMA/133 cmd 0xf883e380 ctl 0x00000000 bmdm=
a 0x00000000 irq 217
[   68.108991] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   68.162613] ata1.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
[   68.166915] ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/3=
2)
[   68.220857] ata1.00: configured for UDMA/133
[   68.680548] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   68.740538] ata2.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
[   68.744780] ata2.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/3=
2)
[   68.798782] ata2.00: configured for UDMA/133
[   69.105219] ata3: SATA link down (SStatus 0 SControl 300)
[   69.411980] ata4: SATA link down (SStatus 0 SControl 300)
[   69.718743] ata5: SATA link down (SStatus 0 SControl 300)
[   70.025505] ata6: SATA link down (SStatus 0 SControl 300)
[   70.029683] scsi 0:0:0:0: Direct-Access     ATA      ST380811AS       =
3.AA PQ: 0 ANSI: 5
[   70.033909] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (800=
26 MB)
[   70.037977] sd 0:0:0:0: [sda] Write Protect is off
[   70.041979] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   70.046078] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (800=
26 MB)
[   70.050095] sd 0:0:0:0: [sda] Write Protect is off
[   70.054086] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   70.058143]  sda: sda1 sda2
[   70.087076] sd 0:0:0:0: [sda] Attached SCSI disk
[   70.091432] scsi 1:0:0:0: Direct-Access     ATA      ST380811AS       =
3.AA PQ: 0 ANSI: 5
[   70.102899] sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors (800=
26 MB)
[   70.107233] sd 1:0:0:0: [sdb] Write Protect is off
[   70.111529] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   70.111653] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   70.120327] sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors (800=
26 MB)
[   70.124695] sd 1:0:0:0: [sdb] Write Protect is off
[   70.129127] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   70.133612]  sdb: sdb1
[   70.166129] sd 1:0:0:0: [sdb] Attached SCSI disk
[   70.170765] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   70.186723] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low)=
 -> IRQ 16
[   70.194084] scsi6 : pata_marvell
[   70.198917] scsi7 : pata_marvell
[   70.203605] ata7: PATA max UDMA/100 cmd 0x00012018 ctl 0x00012026 bmdm=
a 0x00012000 irq 16
[   70.208337] ata8: DUMMY
[   70.213091] BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00=
 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00=20
[   70.677390] ata7.00: ATAPI: HL-DT-STDVD-ROM GDR8164B, 0L06, max UDMA/3=
3
[   70.682326] ata7.01: ATAPI: TSSTcorpCD/DVDW SH-S182M, SB03, max UDMA/3=
3
[   70.844255] ata7.00: configured for UDMA/33
[   71.006128] ata7.01: configured for UDMA/33
[   71.014456] scsi 6:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8164B =
0L06 PQ: 0 ANSI: 5
[   71.019580] scsi 6:0:0:0: Attached scsi generic sg2 type 5
[   71.025657] scsi 6:0:1:0: CD-ROM            TSSTcorp CD/DVDW SH-S182M =
SB03 PQ: 0 ANSI: 5
[   71.030760] scsi 6:0:1:0: Attached scsi generic sg3 type 5
[   71.066861] ACPI: PCI Interrupt 0000:07:01.0[A] -> GSI 22 (level, low)=
 -> IRQ 21
[   71.067621] sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
[   71.067626] Uniform CD-ROM driver Revision: 3.20
[   71.090192] sr1: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form=
2 cdda tray
[   76.289672] scsi8 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev =
7.0
[   76.289675]         <Adaptec 29160B Ultra160 SCSI adapter>
[   76.289677]         aic7892: Ultra160 Wide Channel A, SCSI Id=3D7, 32/=
253 SCBs
[   76.289679]=20
[   76.333504] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialise=
d: dm-devel@redhat.com
[   76.348013] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   77.294697] kjournald starting.  Commit interval 5 seconds
[   77.300080] EXT3 FS on dm-1, internal journal
[   77.305452] EXT3-fs: mounted filesystem with ordered data mode.
[   79.132122] scsi 8:0:12:0: Sequential-Access HP       C5683A          =
 C111 PQ: 0 ANSI: 2
[   79.137150]  target8:0:12: Beginning Domain Validation
[   79.145556]  target8:0:12: wide asynchronous
[   79.152886]  target8:0:12: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offs=
et 32)
[   79.159843]  target8:0:12: Domain Validation skipping write tests
[   79.164731]  target8:0:12: Ending Domain Validation
[   79.727519] parport_pc 00:08: reported by Plug and Play ACPI
[   79.732367] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[   79.819598] lp0: using parport0 (interrupt-driven).
[   79.940015] scsi 8:0:12:0: Attached scsi generic sg4 type 1
[   81.327007] st: Version 20070203, fixed bufsize 32768, s/g segs 256
[   81.332109] st 8:0:12:0: Attached scsi tape st0
[   81.337308] st 8:0:12:0: st0: try direct i/o: yes (alignment 512 B)
[   81.393965] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 21 (level, low)=
 -> IRQ 22
[   81.486117] Linux agpgart interface v0.102
[   81.542816] agpgart: Detected an Intel 965Q Chipset.
[   81.548267] agpgart: Unknown page table size, assuming 512KB
[   81.552923] agpgart: Detected 7676K stolen memory.
[   81.614210] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   81.621657] rtc_cmos: probe of 00:03 failed with error -16
[   81.629964] agpgart: AGP aperture is 256M @ 0x40000000
[   81.696822] usbcore: registered new interface driver usbfs
[   81.701493] usbcore: registered new interface driver hub
[   81.706052] usbcore: registered new device driver usb
[   81.855339] USB Universal Host Controller Interface driver v3.0
[   81.859771] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low)=
 -> IRQ 17
[   81.864175] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   81.869059] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bu=
s number 1
[   81.873409] uhci_hcd 0000:00:1a.0: irq 17, io base 0x000030c0
[   81.878080] usb usb1: configuration #1 chosen from 1 choice
[   81.882524] hub 1-0:1.0: USB hub found
[   81.886983] hub 1-0:1.0: 2 ports detected
[   81.992580] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low)=
 -> IRQ 22
[   81.997018] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   82.001418] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bu=
s number 2
[   82.005847] uhci_hcd 0000:00:1a.1: irq 22, io base 0x000030a0
[   82.010452] usb usb2: configuration #1 chosen from 1 choice
[   82.014880] hub 2-0:1.0: USB hub found
[   82.019319] hub 2-0:1.0: 2 ports detected
[   82.124344] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low)=
 -> IRQ 18
[   82.128962] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   82.133622] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bu=
s number 3
[   82.138243] ehci_hcd 0000:00:1a.7: debug port 1
[   82.142791] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x52c25c00
[   82.151154] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver =
10 Dec 2004
[   82.155858] usb usb3: configuration #1 chosen from 1 choice
[   82.160461] hub 3-0:1.0: USB hub found
[   82.164990] hub 3-0:1.0: 4 ports detected
[   82.270225] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low)=
 -> IRQ 23
[   82.274873] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   82.279496] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bu=
s number 4
[   82.284190] ehci_hcd 0000:00:1d.7: debug port 1
[   82.288807] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x52c25800
[   82.297274] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver =
10 Dec 2004
[   82.302178] usb usb4: configuration #1 chosen from 1 choice
[   82.306964] hub 4-0:1.0: USB hub found
[   82.311719] hub 4-0:1.0: 6 ports detected
[   82.417384] ACPI: PCI Interrupt 0000:07:03.0[A] -> <6>ACPI: PCI Interr=
upt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
[   82.418020] GSI 19 (level, low) -> IRQ 19
[   82.473878] firewire_ohci: Added fw-ohci device 0000:07:03.0, OHCI ver=
sion 1.10
[   82.478945] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low)=
 -> IRQ 23
[   82.484032] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   82.489088] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bu=
s number 5
[   82.494101] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[   82.499312] usb usb5: configuration #1 chosen from 1 choice
[   82.504312] hub 5-0:1.0: USB hub found
[   82.509334] hub 5-0:1.0: 2 ports detected
[   82.614954] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low)=
 -> IRQ 19
[   82.620007] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   82.625021] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bu=
s number 6
[   82.630055] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[   82.635296] usb usb6: configuration #1 chosen from 1 choice
[   82.640286] hub 6-0:1.0: USB hub found
[   82.645193] hub 6-0:1.0: 2 ports detected
[   82.750809] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low)=
 -> IRQ 18
[   82.755796] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   82.760823] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bu=
s number 7
[   82.765845] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
[   82.771136] usb usb7: configuration #1 chosen from 1 choice
[   82.776178] hub 7-0:1.0: USB hub found
[   82.781192] hub 7-0:1.0: 2 ports detected
[   82.960588] usb 6-2: new low speed USB device using uhci_hcd and addre=
ss 2
[   82.973657] firewire_core: created new fw device fw0 (0 config rom ret=
ries, S400)
[   83.107819] usb 6-2: configuration #1 chosen from 1 choice
[   83.153137] Adding 2097144k swap on /dev/system/swap.  Priority:-1 ext=
ents:1 across:2097144k
[   83.212703] usbcore: registered new interface driver hiddev
[   83.230753] input: HID 413c:3010 as /class/input/input2
[   83.236114] input: USB HID v1.00 Mouse [HID 413c:3010] on usb-0000:00:=
1d.1-2
[   83.241418] usbcore: registered new interface driver usbhid
[   83.246605] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   85.723579] loop: module loaded
[   85.758246] kjournald starting.  Commit interval 5 seconds
[   85.762515] EXT3 FS on sda1, internal journal
[   85.766811] EXT3-fs: mounted filesystem with ordered data mode.
[   85.796700] kjournald starting.  Commit interval 5 seconds
[   85.801007] EXT3 FS on dm-0, internal journal
[   85.805281] EXT3-fs: mounted filesystem with ordered data mode.
[   85.841373] kjournald starting.  Commit interval 5 seconds
[   85.845612] EXT3 FS on dm-3, internal journal
[   85.849868] EXT3-fs: mounted filesystem with ordered data mode.
[   85.884307] kjournald starting.  Commit interval 5 seconds
[   85.888492] EXT3 FS on dm-4, internal journal
[   85.892656] EXT3-fs: mounted filesystem with ordered data mode.
[   92.713025] NET: Registered protocol family 10
[   92.717020] lo: Disabled Privacy Extensions
[   92.763977] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   92.907350] ip_tables: (C) 2000-2006 Netfilter Core Team
[   92.951804] Netfilter messages via NETLINK v0.30.
[   92.985157] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   94.287332] input: Power Button (FF) as /class/input/input3
[   94.291527] ACPI: Power Button (FF) [PWRF]
[   94.300217] input: Sleep Button (CM) as /class/input/input4
[   94.308606] ACPI: Sleep Button (CM) [SLPB]
[   95.829804] powernow: This module only works with AMD K7 CPUs
[   97.574723] audit(1185216181.484:2): audit_pid=3D5086 old=3D0 by auid=3D=
4294967295
[   98.316460] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsn=
et.co.uk>
[   99.133241] BUG: unable to handle kernel NULL pointer dereference at v=
irtual address 00000000
[   99.133456]  printing eip:
[   99.133581] f886ab15
[   99.133699] *pde =3D 00000000
[   99.133822] Oops: 0000 [#1]
[   99.133944] PREEMPT SMP=20
[   99.134111] Modules linked in: snd_mixer_oss snd_seq snd_seq_device cp=
ufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave a=
cpi_cpufreq speedstep_lib freq_table button battery ac ip6t_REJECT xt_tcp=
udp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter =
ip6table_mangle nf_conntrack_ipv4 nf_conntrack nfnetlink ip_tables ip6tab=
le_filter ip6_tables x_tables ipv6 loop usbhid snd_hda_intel firewire_ohc=
i ehci_hcd uhci_hcd firewire_core snd_pcm usbcore rtc_cmos crc_itu_t inte=
l_agp rtc_core agpgart snd_timer i2c_i801 st snd i2c_core rtc_lib soundco=
re snd_page_alloc parport_pc lp parport ext3 mbcache jbd dm_snapshot edd =
dm_mod fan aic7xxx sr_mod cdrom scsi_transport_spi pata_marvell sg ahci l=
ibata thermal processor sd_mod scsi_mod
[   99.136884] CPU:    1
[   99.136885] EIP:    0060:[<f886ab15>]    Not tainted VLI
[   99.136886] EFLAGS: 00010293   (2.6.23-rc1-testing #5)
[   99.137307] EIP is at acpi_processor_throttling_seq_show+0x98/0xe4 [pr=
ocessor]
[   99.137466] eax: 00000000   ebx: fffffffb   ecx: 00000000   edx: 00000=
000
[   99.137618] esi: f7a97c00   edi: 00000000   ebp: f71b1f0c   esp: f71b1=
ee0
[   99.137777] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[   99.137929] Process powersaved (pid: 5162, ti=3Df71b1000 task=3Df71b00=
00 task.ti=3Df71b1000)
[   99.138025] Stack: f7275900 f886d5aa 00000008 00000000 00000000 000000=
07 00000000 f7275900=20
[   99.138402]        fffffffb f7275900 00000001 f71b1f4c c0194865 000004=
00 b7f58000 f71d2600=20
[   99.138785]        f7275920 00000000 dfe9f898 00000001 00000246 dfe9f8=
98 00000000 00000000=20
[   99.139177] Call Trace:
[   99.139378]  [<c0105244>] show_trace_log_lvl+0x1a/0x2f
[   99.139553]  [<c01052f6>] show_stack_log_lvl+0x9d/0xa5
[   99.139717]  [<c01054ef>] show_registers+0x1f1/0x332
[   99.139877]  [<c010574b>] die+0x11b/0x250
[   99.140037]  [<c02fba0e>] do_page_fault+0x512/0x5e3
[   99.140200]  [<c02fa07a>] error_code+0x72/0x78
[   99.140356]  [<c0194865>] seq_read+0xef/0x266
[   99.140522]  [<c01abf29>] proc_reg_read+0x63/0x76
[   99.140682]  [<c017dc34>] vfs_read+0xad/0x136
[   99.140838]  [<c017e065>] sys_read+0x3d/0x61
[   99.141002]  [<c010411a>] sysenter_past_esp+0x6b/0xb5
[   99.141176]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   99.141301] Code: 45 f0 89 04 24 e8 8a 98 92 c7 ba 00 d6 86 f8 8b 45 f=
0 e8 60 96 92 c7 31 ff c7 45 ec 00 00 00 00 eb 43 8b 86 04 03 00 00 8b 55=
 ec <8b> 0c 02 ba 2a 00 00 00 3b be d8 02 00 00 b8 20 00 00 00 0f 45=20
[   99.143171] EIP: [<f886ab15>] acpi_processor_throttling_seq_show+0x98/=
0xe4 [processor] SS:ESP 0068:f71b1ee0
>>> system up

--------------060308090305030501030804--

--------------enig8254F14E4DFB218B68739CB3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGpQSzMdB4Whm86/kRAov3AJ4o9ZtkqWIfcj68Yhop78lOVPGNNACfTAcP
s9YfSBQzJGrOW/7uiCXToGs=
=ZpKI
-----END PGP SIGNATURE-----

--------------enig8254F14E4DFB218B68739CB3--
