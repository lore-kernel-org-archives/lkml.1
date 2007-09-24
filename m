Return-Path: <linux-kernel-owner+w=401wt.eu-S1762763AbXIXSDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762763AbXIXSDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762575AbXIXSDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:03:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:62473 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373AbXIXSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type;
        b=QjBE7884rBmmQzTaq7z+nmdU9t9zDgkJdGmJBKR3W33Cr934ht2MjtDrKw1MfdVIerzBunryXHvxtKA0PYolJaEMUgyQN8o1Or02mo7J2gXz/Sh/8Vj7G8fdWUrtv/Q2cuiX4Kp5XzZ4uoeN4uC/nxPTWdaRzR/bgx4VUwYBwng=
Message-ID: <46F7FBCB.4030803@gmail.com>
Date: Mon, 24 Sep 2007 12:02:51 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------090205090900000102020404"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090205090900000102020404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Greetings,

I get a few million of these on boot-- the system never actually boots.
Works fine in 2.6.23-rc7.

[   50.456012] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.462484] ata2.00: irq_stat 0x40000001
[   50.466441] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0
cdb 0x0 data 0
[   50.466442]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask
0x1 (device error)
[   50.481914] ata2.00: status: {DRDY ERR }
[   50.485876] ata2.00: error: {ABRT }
[   50.489533] ata2.00: configured for UDMA/133
[   50.493839] ata2: EH complete

I've attached the entire dmesg and lspci.

Berck

--------------090205090900000102020404
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

[    0.000000] Linux version 2.6.23-rc7-mm1 (root@luna) (gcc version 4.2.1 (Debian 4.2.1-5)) #1 SMP Mon Sep 24 10:55:28 MDT 2007
[    0.000000] Command line: root=/dev/sde1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff80000 (usable)
[    0.000000]  BIOS-e820: 000000003ff80000 - 000000003ff8e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff8e000 - 000000003ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FAF20, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 3FF80100, 0064 (r1 NEC              3000707 MSFT       97)
[    0.000000] ACPI: FACP 3FF80290, 00F4 (r3 A_M_I_ OEMFACP   3000707 MSFT       97)
[    0.000000] ACPI: DSDT 3FF80590, 9560 (r1  A0543 A0543000        0 INTL 20060113)
[    0.000000] ACPI: FACS 3FF8E000, 0040
[    0.000000] ACPI: APIC 3FF80390, 0080 (r1 A_M_I_ OEMAPIC   3000707 MSFT       97)
[    0.000000] ACPI: SLIC 3FF80410, 0176 (r1 NEC              3000707 MSFT       97)
[    0.000000] ACPI: OEMB 3FF8E040, 0066 (r1 A_M_I_ AMI_OEM   3000707 MSFT       97)
[    0.000000] ACPI: HPET 3FF89AF0, 0038 (r1 A_M_I_ OEMHPET   3000707 MSFT       97)
[    0.000000] ACPI: MCFG 3FF89B30, 003C (r1 A_M_I_ OEMMCFG   3000707 MSFT       97)
[    0.000000] ACPI: SSDT 3FF8E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
[    0.000000] ACPI: SSDT 3FF8E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   262016
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bfb00000)
[    0.000000] .eh_frame_hdr for 'kernel' present but unusable
[    0.000000] PERCPU: Allocating 28272 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257189
[    0.000000] Kernel command line: root=/dev/sde1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against HPET
[    0.000000] time.c: Detected 2564.904 MHz processor.
[    0.006666] Console: colour VGA+ 80x25
[    0.006666] console [tty0] enabled
[    0.009999] console [ttyS0] enabled
[    0.013333] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.016666] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.019999] Checking aperture...
[    0.029999] Memory: 1026700k/1048064k available (2444k kernel code, 20788k reserved, 1587k data, 224k init)
[    0.116666] Calibrating delay using timer specific routine.. 5165.06 BogoMIPS (lpj=8606508)
[    0.123333] Mount-cache hash table entries: 256
[    0.126666] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.133333] CPU: L2 cache: 2048K
[    0.136666] using mwait in idle threads.
[    0.139999] CPU: Physical Processor ID: 0
[    0.143333] CPU: Processor Core ID: 0
[    0.146666] CPU0: Thermal monitoring enabled (TM2)
[    0.149999] Freeing SMP alternatives: 27k freed
[    0.153333] ACPI: Core revision 20070126
[    0.196666] Using local APIC timer interrupts.
[    0.203333] Detected 22.900 MHz APIC timer.
[    0.206666] Booting processor 1/2 APIC 0x1
[    0.219999] Initializing CPU#1
[    0.303333] Calibrating delay using timer specific routine.. 5131.59 BogoMIPS (lpj=8549752)
[    0.303333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.303333] CPU: L2 cache: 2048K
[    0.303333] CPU: Physical Processor ID: 0
[    0.303333] CPU: Processor Core ID: 1
[    0.303333] CPU1: Thermal monitoring enabled (TM2)
[    0.303333] Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[    0.303333] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.306666] Brought up 2 CPUs
[    0.309999] net_namespace: 112 bytes
[    0.313527] NET: Registered protocol family 16
[    0.318098] ACPI: bus type pci registered
[    0.322196] PCI: Using configuration type 1
[    0.337363] ACPI: Interpreter enabled
[    0.341064] ACPI: Using IOAPIC for interrupt routing
[    0.346103] PCI: MCFG configuration 0: base 4026531840 segment 0 buses 0 - 63
[    0.355324] PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
[    0.363684] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.374737] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.380224] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.386698] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.392990] PCI: Transparent bridge - 0000:00:1e.0
[    0.400502] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.408218] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.415907] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.423599] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.431292] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.438983] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.452232] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.459926] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.467612] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  1B, should be 12 [20070126]
[    0.477413] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.483126] pnp: PnP ACPI init
[    0.486224] ACPI: bus type pnp registered
[    0.492778] pnp: PnP ACPI: found 15 devices
[    0.496997] ACPI: ACPI bus type pnp unregistered
[    0.501785] SCSI subsystem initialized
[    0.505640] PCI: Using ACPI for IRQ routing
[    0.509868] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.531250] DMAR:No DMAR devices found
[    0.535042] PCI-GART: No AMD northbridge found.
[    0.539615] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.544701] hpet0: 3 64-bit timers, 14318180 Hz
[    0.551248] Time: tsc clocksource has been installed.
[    0.556341] Switched to high resolution mode on CPU 1
[    0.556343] Switched to high resolution mode on CPU 0
[    0.571333] pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.578331] pnp: 00:07: ioport range 0x290-0x297 has been reserved
[    0.584545] pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.591541] pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.598532] pnp: 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.605530] pnp: 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.612889] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.619883] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.627240] pnp: 00:0d: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.634542] pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.641015] pnp: 00:0e: iomem range 0xc0000-0xdffff has been reserved
[    0.647486] pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.654311] pnp: 00:0e: iomem range 0x100000-0x3fffffff could not be reserved
[    0.661663] PCI: Bridge: 0000:00:01.0
[    0.665362]   IO window: disabled.
[    0.668800]   MEM window: faa00000-feafffff
[    0.673018]   PREFETCH window: cff00000-efefffff
[    0.677669] PCI: Bridge: 0000:00:1c.0
[    0.681366]   IO window: disabled.
[    0.684806]   MEM window: disabled.
[    0.688331]   PREFETCH window: cfe00000-cfefffff
[    0.692984] PCI: Bridge: 0000:00:1c.3
[    0.696680]   IO window: c000-cfff
[    0.700121]   MEM window: fa900000-fa9fffff
[    0.704563]   PREFETCH window: disabled.
[    0.708522] PCI: Bridge: 0000:00:1c.5
[    0.712219]   IO window: b000-bfff
[    0.715658]   MEM window: fa800000-fa8fffff
[    0.719877]   PREFETCH window: disabled.
[    0.723836] PCI: Bridge: 0000:00:1e.0
[    0.727534]   IO window: a000-afff
[    0.730972]   MEM window: fa600000-fa7fffff
[    0.735191]   PREFETCH window: 50000000-500fffff
[    0.739848] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.747340] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.754836] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.762328] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
[    0.769846] NET: Registered protocol family 2
[    0.804543] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.811902] TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
[    0.820383] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.827598] TCP: Hash tables configured (established 131072 bind 65536)
[    0.834246] TCP reno registered
[    0.845316] audit: initializing netlink socket (disabled)
[    0.850764] audit(1190632860.800:1): initialized
[    0.855576] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    0.862927] io scheduler noop registered
[    0.866898] io scheduler cfq registered (default)
[    0.872541] assign_interrupt_mode Found MSI capability
[    0.877810] assign_interrupt_mode Found MSI capability
[    0.883115] assign_interrupt_mode Found MSI capability
[    0.888389] assign_interrupt_mode Found MSI capability
[    0.893748] input: Power Button (FF) as /class/input/input0
[    0.899356] ACPI: Power Button (FF) [PWRF]
[    0.903557] input: Power Button (CM) as /class/input/input1
[    0.909168] ACPI: Power Button (CM) [PWRB]
[    0.913523] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._OSC] (Node ffff810002057b30), AE_ALREADY_EXISTS
[    0.925353] ACPI: Marking method _OSC as Serialized
[    0.930391] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._PDC] (Node ffff810002057b50), AE_ALREADY_EXISTS
[    0.942224] ACPI: Marking method _PDC as Serialized
[    0.947450] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.953844] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._OSC] (Node ffff810002057a10), AE_ALREADY_EXISTS
[    0.965672] ACPI: Marking method _OSC as Serialized
[    0.970699] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._PDC] (Node ffff810002057a30), AE_ALREADY_EXISTS
[    0.982528] ACPI: Marking method _PDC as Serialized
[    0.987738] ACPI: Processor [CPU2] (supports 8 throttling states)
[    1.021932] Real Time Clock Driver v1.12ac
[    1.026559] intel_rng: FWH not detected
[    1.030787] Linux agpgart interface v0.102
[    1.034933] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    1.042917] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.049287] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.055149] ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[    1.272646] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[    1.272647]         <Adaptec 2940 Ultra2 SCSI adapter>
[    1.272648]         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[    1.272649] 
[    1.293548] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
[    1.553326] scsi 0:0:1:0: Direct-Access     IBM-PCCO ST39102LC     !# B219 PQ: 0 ANSI: 2
[    1.561460] scsi0:A:1:0: Tagged Queuing enabled.  Depth 8
[    1.566937]  target0:0:1: Beginning Domain Validation
[    1.578463]  target0:0:1: wide asynchronous
[    1.587385]  target0:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    1.598611]  target0:0:1: Domain Validation skipping write tests
[    1.604649]  target0:0:1: Ending Domain Validation
[    1.612484] scsi 0:0:2:0: Direct-Access     SGI      SEAGATE ST39102L 2702 PQ: 0 ANSI: 2
[    1.620618] scsi0:A:2:0: Tagged Queuing enabled.  Depth 8
[    1.626103]  target0:0:2: Beginning Domain Validation
[    1.636479]  target0:0:2: wide asynchronous
[    1.644583]  target0:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    1.654991]  target0:0:2: Domain Validation skipping write tests
[    1.661028]  target0:0:2: Ending Domain Validation
[    2.300362] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.308492] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    2.315416] scsi1 : ahci
[    2.318028] scsi2 : ahci
[    2.320642] scsi3 : ahci
[    2.323255] scsi4 : ahci
[    2.325856] ata1: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfb900 irq 315
[    2.333385] ata2: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfb980 irq 315
[    2.340912] ata3: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfba00 irq 315
[    2.348439] ata4: SATA max UDMA/133 abar m1024@0xfebfb800 port 0xfebfba80 irq 315
[    2.826801] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.833846] ata1.00: ATA-7: ST3250823AS, 3.03, max UDMA/133
[    2.839453] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.847130] ata1.00: configured for UDMA/133
[    3.323209] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.741554] sd 0:0:1:0: [sda] 17774160 512-byte hardware sectors (9100 MB)
[    4.750442] sd 0:0:1:0: [sda] Write Protect is off
[    4.756848] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.766232] sd 0:0:1:0: [sda] 17774160 512-byte hardware sectors (9100 MB)
[    4.775123] sd 0:0:1:0: [sda] Write Protect is off
[    4.781526] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.790092]  sda: sda1 sda2
[    4.802219] sd 0:0:1:0: [sda] Attached SCSI disk
[    4.806924] sd 0:0:1:0: Attached scsi generic sg0 type 0
[    4.813108] sd 0:0:2:0: [sdb] 17781520 512-byte hardware sectors (9104 MB)
[    4.823399] sd 0:0:2:0: [sdb] Write Protect is off
[    4.831988] sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.841348] sd 0:0:2:0: [sdb] 17781520 512-byte hardware sectors (9104 MB)
[    4.851630] sd 0:0:2:0: [sdb] Write Protect is off
[    4.860225] sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.868792]  sdb: sdb1
[    4.878122] sd 0:0:2:0: [sdb] Attached SCSI disk
[    4.882823] sd 0:0:2:0: Attached scsi generic sg1 type 0
[   33.310882] ata2.00: qc timeout (cmd 0xec)
[   33.315018] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   33.321147] ata2: failed to recover some devices, retrying in 5 secs
[   43.812075] ata2: port is slow to respond, please be patient (Status 0x80)
[   48.349713] ata2: COMRESET failed (errno=-16)
[   49.039358] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   49.045635] ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
[   49.051677] ata2.00: 640 sectors, multi 1: LBA 
[   49.056321] ata2.00: configured for UDMA/133
[   49.535758] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   49.545347] ata3.00: ATA-6: WDC WD360GD-00FLA2, 31.08F31, max UDMA/133
[   49.551912] ata3.00: 72303840 sectors, multi 16: LBA48 
[   49.561558] ata3.00: configured for UDMA/133
[   50.038845] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   50.195938] ata4.00: ATAPI: Optiarc DVD RW AD-7170S, 1.00, max UDMA/66
[   50.355837] ata4.00: configured for UDMA/66
[   50.360106] scsi 1:0:0:0: Direct-Access     ATA      ST3250823AS      3.03 PQ: 0 ANSI: 5
[   50.368458] sd 1:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[   50.375639] sd 1:0:0:0: [sdc] Write Protect is off
[   50.380477] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   50.394582] sd 1:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[   50.401757] sd 1:0:0:0: [sdc] Write Protect is off
[   50.406592] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   50.415679]  sdc: sdc1 sdc2
[   50.437711] sd 1:0:0:0: [sdc] Attached SCSI disk
[   50.442406] sd 1:0:0:0: Attached scsi generic sg2 type 0
[   50.447800] scsi 2:0:0:0: Direct-Access     ATA      Config  Disk     RGL1 PQ: 0 ANSI: 5
[   50.456012] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.462484] ata2.00: irq_stat 0x40000001
[   50.466441] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.466442]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.481914] ata2.00: status: {DRDY ERR }
[   50.485876] ata2.00: error: {ABRT }
[   50.489533] ata2.00: configured for UDMA/133
[   50.493839] ata2: EH complete
[   50.496875] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.503349] ata2.00: irq_stat 0x40000001
[   50.507306] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.507307]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.522778] ata2.00: status: {DRDY ERR }
[   50.526740] ata2.00: error: {ABRT }
[   50.530402] ata2.00: configured for UDMA/133
[   50.534713] ata2: EH complete
[   50.537730] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.544207] ata2.00: irq_stat 0x40000001
[   50.548170] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.548171]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.563644] ata2.00: status: {DRDY ERR }
[   50.567606] ata2.00: error: {ABRT }
[   50.571267] ata2.00: configured for UDMA/133
[   50.575576] ata2: EH complete
[   50.578597] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.585072] ata2.00: irq_stat 0x40000001
[   50.589035] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.589036]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.604509] ata2.00: status: {DRDY ERR }
[   50.608470] ata2.00: error: {ABRT }
[   50.612129] ata2.00: configured for UDMA/133
[   50.616435] ata2: EH complete
[   50.619461] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.625935] ata2.00: irq_stat 0x40000001
[   50.629892] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.629893]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.645365] ata2.00: status: {DRDY ERR }
[   50.649327] ata2.00: error: {ABRT }
[   50.652988] ata2.00: configured for UDMA/133
[   50.657300] ata2: EH complete
[   50.660327] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.666803] ata2.00: irq_stat 0x40000001
[   50.670767] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.670767]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.686239] ata2.00: status: {DRDY ERR }
[   50.690201] ata2.00: error: {ABRT }
[   50.693859] ata2.00: configured for UDMA/133
[   50.698166] ata2: EH complete
[   50.701200] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.707675] ata2.00: irq_stat 0x40000001
[   50.711632] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.711633]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.727104] ata2.00: status: {DRDY ERR }
[   50.731066] ata2.00: error: {ABRT }
[   50.734727] ata2.00: configured for UDMA/133
[   50.739039] ata2: EH complete
[   50.742076] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.748549] ata2.00: irq_stat 0x40000001
[   50.752506] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.752507]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.767979] ata2.00: status: {DRDY ERR }
[   50.771940] ata2.00: error: {ABRT }
[   50.775601] ata2.00: configured for UDMA/133
[   50.779911] ata2: EH complete
[   50.782940] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.789415] ata2.00: irq_stat 0x40000001
[   50.793371] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.793372]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.808843] ata2.00: status: {DRDY ERR }
[   50.812805] ata2.00: error: {ABRT }
[   50.816465] ata2.00: configured for UDMA/133
[   50.820777] ata2: EH complete
[   50.823806] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.830279] ata2.00: irq_stat 0x40000001
[   50.834236] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.834237]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.849709] ata2.00: status: {DRDY ERR }
[   50.853671] ata2.00: error: {ABRT }
[   50.857331] ata2.00: configured for UDMA/133
[   50.861643] ata2: EH complete
[   50.864669] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.871146] ata2.00: irq_stat 0x40000001
[   50.875111] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.875112]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.890593] ata2.00: status: {DRDY ERR }
[   50.894555] ata2.00: error: {ABRT }
[   50.898215] ata2.00: configured for UDMA/133
[   50.902525] ata2: EH complete
[   50.905552] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.912027] ata2.00: irq_stat 0x40000001
[   50.915984] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.915985]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.931456] ata2.00: status: {DRDY ERR }
[   50.935422] ata2.00: error: {ABRT }
[   50.939077] ata2.00: configured for UDMA/133
[   50.943383] ata2: EH complete
[   50.946419] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.952892] ata2.00: irq_stat 0x40000001
[   50.956849] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.956850]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   50.972324] ata2.00: status: {DRDY ERR }
[   50.976286] ata2.00: error: {ABRT }
[   50.979943] ata2.00: configured for UDMA/133
[   50.984250] ata2: EH complete
[   50.987274] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   50.993749] ata2.00: irq_stat 0x40000001
[   50.997706] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   50.997707]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.013178] ata2.00: status: {DRDY ERR }
[   51.017140] ata2.00: error: {ABRT }
[   51.020803] ata2.00: configured for UDMA/133
[   51.025114] ata2: EH complete
[   51.028138] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.034616] ata2.00: irq_stat 0x40000001
[   51.038579] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.038580]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.054055] ata2.00: status: {DRDY ERR }
[   51.058014] ata2.00: error: {ABRT }
[   51.061676] ata2.00: configured for UDMA/133
[   51.065986] ata2: EH complete
[   51.069003] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.075480] ata2.00: irq_stat 0x40000001
[   51.079436] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.079437]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.094911] ata2.00: status: {DRDY ERR }
[   51.098873] ata2.00: error: {ABRT }
[   51.107774] ata2.00: configured for UDMA/133
[   51.112083] ata2: EH complete
[   51.115110] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.121586] ata2.00: irq_stat 0x40000001
[   51.125542] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.125543]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.141014] ata2.00: status: {DRDY ERR }
[   51.144976] ata2.00: error: {ABRT }
[   51.148636] ata2.00: configured for UDMA/133
[   51.152948] ata2: EH complete
[   51.155975] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.162451] ata2.00: irq_stat 0x40000001
[   51.166408] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   51.166409]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.181880] ata2.00: status: {DRDYisk...<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.206841] ata2.00: irq_stat 0x40000001
[   51.210799]51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.226279] ata2.00: status: {DRDY ERR }
[   51.230243] ata2.te
[   51.241247] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   51.247725] ata2.00: irq_stat 0x40000001
[          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.267215] ata2.00: status: {DRDY ERR }
[   51.27rq_stat 0x40000001
[   51.292599] ata2.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 0 
[   51.292600]      {DRDY ERR }
[   51.312043] ata2.00: error: {ABRT }
[   51.315700] ata2.00: configured for UDMA/133
[   51.320005] ata2: EH cata2.00: irq_stat 0x40000001
[   51.333471] ata2.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 0 
[   51.3330: status: {DRDY ERR }
[   51.352906] ata2.00: error: {ABRT }
[   51.356564] ata2.00: configured for UDMA/133
[   51.360869]0x0 data 0 
[   51.374339]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.389818] ata2.00: status: {DRDY ERR }
[   51.393783] ata2.00: error: {ABRT }
[   51.397442] ata2.00: configured for UDMA/133
[   51.401752] at tag 0 cdb 0x0 data 0 
[   51.415213]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   51.430692igured for UDMA/133
[   51.442627] ata2: EH complete
[   52.444246] .<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.451137] ata2.00: irq_stat 0x40000001
[   52.455104] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.455105]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.470583] ata2.00: status: {DRDY ERR }
[   52.474545] ata2.00: error: {ABRT }
[   52.478205] ata2.00: configured for UDMA/133
[   52.482515] ata2: EH complete
[   52.485535] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.492011] ata2.00: irq_stat 0x40000001
[   52.495967] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.495968]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.511440] ata2.00: status: {DRDY ERR }
[   52.515401] ata2.00: error: {ABRT }
[   52.519059] ata2.00: configured for UDMA/133
[   52.523365] ata2: EH complete
[   52.526382] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.532859] ata2.00: irq_stat 0x40000001
[   52.536823] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.536824]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.552298] ata2.00: status: {DRDY ERR }
[   52.556259] ata2.00: error: {ABRT }
[   52.559916] ata2.00: configured for UDMA/133
[   52.564221] ata2: EH complete
[   52.567246] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.573724] ata2.00: irq_stat 0x40000001
[   52.577681] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.577682]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.593153] ata2.00: status: {DRDY ERR }
[   52.597114] ata2.00: error: {ABRT }
[   52.600772] ata2.00: configured for UDMA/133
[   52.605078] ata2: EH complete
[   52.608102] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.614580] ata2.00: irq_stat 0x40000001
[   52.618537] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.618538]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.634020] ata2.00: status: {DRDY ERR }
[   52.637982] ata2.00: error: {ABRT }
[   52.641636] ata2.00: configured for UDMA/133
[   52.645944] ata2: EH complete
[   52.648969] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.655449] ata2.00: irq_stat 0x40000001
[   52.659410] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.659411]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.674883] ata2.00: status: {DRDY ERR }
[   52.678848] ata2.00: error: {ABRT }
[   52.682504] ata2.00: configured for UDMA/133
[   52.686808] ata2: EH complete
[   52.689833] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.696311] ata2.00: irq_stat 0x40000001
[   52.700267] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.700268]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.715740] ata2.00: status: {DRDY ERR }
[   52.719702] ata2.00: error: {ABRT }
[   52.723361] ata2.00: configured for UDMA/133
[   52.727664] ata2: EH complete
[   52.730681] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.737158] ata2.00: irq_stat 0x40000001
[   52.741117] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.741118]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.756596] ata2.00: status: {DRDY ERR }
[   52.760558] ata2.00: error: {ABRT }
[   52.764216] ata2.00: configured for UDMA/133
[   52.768521] ata2: EH complete
[   52.771548] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.778023] ata2.00: irq_stat 0x40000001
[   52.781982] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.781983]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.797462] ata2.00: status: {DRDY ERR }
[   52.801426] ata2.00: error: {ABRT }
[   52.805082] ata2.00: configured for UDMA/133
[   52.809388] ata2: EH complete
[   52.812404] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.818881] ata2.00: irq_stat 0x40000001
[   52.822838] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.822838]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.838312] ata2.00: status: {DRDY ERR }
[   52.847525] ata2.00: error: {ABRT }
[   52.851178] ata2.00: configured for UDMA/133
[   52.855485] ata2: EH complete
[   52.858509] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   52.864987] ata2.00: irq_stat 0x40000001
[   52.868952] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[   52.868953]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   52.884425] ata2.00: status: {DRDY ERR }
[   52.888386] ata2.00: error: {ABRT }
[   53.407845] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[   53.414063] ata2.00: revalidation failed (errno=-5)
[   53.418979] ata2: failed to recover some devices, retrying in 5 secs
[   60.626658] ata2: soft resetting link
[   60.630361] ata2: SATA link down (SStatus 21 SControl 300)
[   60.635882] ata2: limiting SATA link speed to 1.5 Gbps
[   60.641058] ata2.00: limiting speed to UDMA/133:PIO3
[   60.646056] ata2: failed to recover some devices, retrying in 5 secs
[   65.650696] ata2: hard resetting link
[   66.340351] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   66.346707] ata2.00: configured for UDMA/133
[   66.351020] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0x3 t4
[   66.358104] ata2: irq_stat 0x00000040, connection status changed
[   66.364148] ata2: SError: {PHYRdyChg DevExch }
[   67.079963] ata2: soft resetting link
[   67.243206] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   97.230928] ata2.00: qc timeout (cmd 0xec)
[   97.235060] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   97.241183] ata2.00: revalidation failed (errno=-5)
[   97.246095] ata2: failed to recover some devices, retrying in 5 secs
[  102.251646] ata2: hard resetting link
[  107.738811] ata2: port is slow to respond, please be patient (Status 0x80)
[  112.276434] ata2: COMRESET failed (errno=-16)
[  112.280831] ata2: hard resetting link
[  112.969410] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  112.975769] ata2.00: configured for UDMA/133
[  112.980083] ata2: EH complete
[  112.983116] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  112.989592] ata2.00: irq_stat 0x40000001
[  112.993550] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  112.993551]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  113.009030] ata2.00: status: {DRDY ERR }
[  113.012991] ata2.00: error: {ABRT }
[  113.016656] ata2.00: configured for UDMA/133
[  113.020963] ata2: EH complete
[  113.023988] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  113.030465] ata2.00: irq_stat 0x40000001
[  113.034424] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  113.034425]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  113.049905] ata2.00: status: {DRDY ERR }
[  113.053868] ata2.00: error: {ABRT }
[  113.057528] ata2.00: configured for UDMA/133
[  113.061836] ata2: EH complete
[  113.064863] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  113.071341] ata2.00: irq_stat 0x40000001
[  113.075304] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  113.075305]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  113.090778] ata2.00: status: {DRDY ERR }
[  113.094739] ata2.00: error: {ABRT }
[  113.098402] ata2.00: configured for UDMA/133
[  113.102710] ata2: EH complete
[  113.105734] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  113.112205] ata2.00: irq_stat 0x40000001
[  113.116163] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  113.116164]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  113.131643] ata2.00: status: {DRDY ERR }
[  113.135604] ata2.00: error: {ABRT }
[  113.139267] ata2.00: configured for UDMA/133
[  113.143575] ata2: EH complete
[  113.146601] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  113.153080] ata2.00: irq_stat 0x40000001
[  113.157044] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  113.157044]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  113.172516] ata2.00: status: {DRDY ERR }
[  113.176481] ata2.00: error: {ABRT }
[  113.180143] ata2.00: configured for UDMA/133
[  113.184450] ata2: EH complete
[  113.187478] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  113.193953] ata2.00: irq_stat 0x40000001
[  113.197909] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  113.197910]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  113.213382] ata2.00: status: {DRDY ERR }
[  113.217346] ata2.00: error: {ABRT }
[  113.221007] ata2.00: configured for UDMA/133
[  113.225315] ata2: EH complete
[  113.228342] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  113.234819] ata2.00: irq_stat 0x40000001
[  113.238784] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  113.238785]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  113.254256] ata2.00: status: {DRDY ERR }
[  113.258218] ata2.00: error: {ABRT }
[  113.261881] ata2.00: configured for UDMA/133
[  113.266190] ata2: EH complete
[  114.265394] .<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.272286] ata2.00: irq_stat 0x40000001
[  114.276250] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.276251]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.291722] ata2.00: status: {DRDY ERR }
[  114.295684] ata2.00: error: {ABRT }
[  114.299348] ata2.00: configured for UDMA/133
[  114.303656] ata2: EH complete
[  114.306681] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.313159] ata2.00: irq_stat 0x40000001
[  114.317122] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.317123]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.332596] ata2.00: status: {DRDY ERR }
[  114.336558] ata2.00: error: {ABRT }
[  114.340222] ata2.00: configured for UDMA/133
[  114.344528] ata2: EH complete
[  114.347555] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.354033] ata2.00: irq_stat 0x40000001
[  114.357997] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.357998]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.373470] ata2.00: status: {DRDY ERR }
[  114.377431] ata2.00: error: {ABRT }
[  114.381094] ata2.00: configured for UDMA/133
[  114.385402] ata2: EH complete
[  114.388427] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.394897] ata2.00: irq_stat 0x40000001
[  114.398854] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.398855]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.414327] ata2.00: status: {DRDY ERR }
[  114.418288] ata2.00: error: {ABRT }
[  114.421951] ata2.00: configured for UDMA/133
[  114.426259] ata2: EH complete
[  114.429285] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.435762] ata2.00: irq_stat 0x40000001
[  114.439720] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.439721]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.455202] ata2.00: status: {DRDY ERR }
[  114.459164] ata2.00: error: {ABRT }
[  114.462827] ata2.00: configured for UDMA/133
[  114.467133] ata2: EH complete
[  114.470161] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.476636] ata2.00: irq_stat 0x40000001
[  114.480593] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.480594]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.496066] ata2.00: status: {DRDY ERR }
[  114.500028] ata2.00: error: {ABRT }
[  114.503691] ata2.00: configured for UDMA/133
[  114.508000] ata2: EH complete
[  114.511025] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.517502] ata2.00: irq_stat 0x40000001
[  114.521458] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.521459]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.536931] ata2.00: status: {DRDY ERR }
[  114.540892] ata2.00: error: {ABRT }
[  114.544557] ata2.00: configured for UDMA/133
[  114.548865] ata2: EH complete
[  114.551887] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.558358] ata2.00: irq_stat 0x40000001
[  114.567565] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.567566]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.583045] ata2.00: status: {DRDY ERR }
[  114.587008] ata2.00: error: {ABRT }
[  114.590669] ata2.00: configured for UDMA/133
[  114.594979] ata2: EH complete
[  114.598004] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.604482] ata2.00: irq_stat 0x40000001
[  114.608445] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.608446]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.623920] ata2.00: status: {DRDY ERR }
[  114.627882] ata2.00: error: {ABRT }
[  114.631544] ata2.00: configured for UDMA/133
[  114.635852] ata2: EH complete
[  114.638878] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.645354] ata2.00: irq_stat 0x40000001
[  114.649313] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.649314]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.664794] ata2.00: status: {DRDY ERR }
[  114.668756] ata2.00: error: {ABRT }
[  114.672418] ata2.00: configured for UDMA/133
[  114.676728] ata2: EH complete
[  114.679753] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.686228] ata2.00: irq_stat 0x40000001
[  114.690185] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.690186]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.705660] ata2.00: status: {DRDY ERR }
[  114.709621] ata2.00: error: {ABRT }
[  114.713282] ata2.00: configured for UDMA/133
[  114.717593] ata2: EH complete
[  114.720617] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.727094] ata2.00: irq_stat 0x40000001
[  114.731050] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.731051]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.746524] ata2.00: status: {DRDY ERR }
[  114.750485] ata2.00: error: {ABRT }
[  114.754148] ata2.00: configured for UDMA/133
[  114.758458] ata2: EH complete
[  114.761482] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.767959] ata2.00: irq_stat 0x40000001
[  114.771916] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.771917]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.787389] ata2.00: status: {DRDY ERR }
[  114.791350] ata2.00: error: {ABRT }
[  114.795013] ata2.00: configured for UDMA/133
[  114.799321] ata2: EH complete
[  114.802347] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.808825] ata2.00: irq_stat 0x40000001
[  114.812782] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.812782]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.828254] ata2.00: status: {DRDY ERR }
[  114.832216] ata2.00: error: {ABRT }
[  114.835881] ata2.00: configured for UDMA/133
[  114.840186] ata2: EH complete
[  114.843214] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.849691] ata2.00: irq_stat 0x40000001
[  114.853655] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.853656]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.869128] ata2.00: status: {DRDY ERR }
[  114.873090] ata2.00: error: {ABRT }
[  114.876753] ata2.00: configured for UDMA/133
[  114.881061] ata2: EH complete
[  114.884087] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.890563] ata2.00: irq_stat 0x40000001
[  114.894520] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.894521]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.909996] ata2.00: status: {DRDY ERR }
[  114.913956] ata2.00: error: {ABRT }
[  114.917619] ata2.00: configured for UDMA/133
[  114.921926] ata2: EH complete
[  114.924951] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.931430] ata2.00: irq_stat 0x40000001
[  114.935396] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.935397]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.950878] ata2.00: status: {DRDY ERR }
[  114.954837] ata2.00: error: {ABRT }
[  114.958502] ata2.00: configured for UDMA/133
[  114.962810] ata2: EH complete
[  114.965833] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  114.972311] ata2.00: irq_stat 0x40000001
[  114.976270] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  114.976271]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  114.991750] ata2.00: status: {DRDY ERR }
[  114.995712] ata2.00: error: {ABRT }
[  114.999374] ata2.00: configured for UDMA/133
[  115.003683] ata2: EH complete
[  116.004497] .<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.011400] ata2.00: irq_stat 0x40000001
[  116.015364] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.015365]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.030844] ata2.00: status: {DRDY ERR }
[  116.034808] ata2.00: error: {ABRT }
[  116.038467] ata2.00: configured for UDMA/133
[  116.042777] ata2: EH complete
[  116.045804] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.052280] ata2.00: irq_stat 0x40000001
[  116.056236] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.056237]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.071709] ata2.00: status: {DRDY ERR }
[  116.075672] ata2.00: error: {ABRT }
[  116.079334] ata2.00: configured for UDMA/133
[  116.083642] ata2: EH complete
[  116.086669] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.093146] ata2.00: irq_stat 0x40000001
[  116.097110] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.097111]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.112585] ata2.00: status: {DRDY ERR }
[  116.116547] ata2.00: error: {ABRT }
[  116.120208] ata2.00: configured for UDMA/133
[  116.124515] ata2: EH complete
[  116.127539] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.134011] ata2.00: irq_stat 0x40000001
[  116.137977] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.137978]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.153459] ata2.00: status: {DRDY ERR }
[  116.157420] ata2.00: error: {ABRT }
[  116.161082] ata2.00: configured for UDMA/133
[  116.165390] ata2: EH complete
[  116.168416] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.174894] ata2.00: irq_stat 0x40000001
[  116.178858] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.178859]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.194333] ata2.00: status: {DRDY ERR }
[  116.198294] ata2.00: error: {ABRT }
[  116.201957] ata2.00: configured for UDMA/133
[  116.206265] ata2: EH complete
[  116.209290] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.215768] ata2.00: irq_stat 0x40000001
[  116.219734] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.219734]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.235214] ata2.00: status: {DRDY ERR }
[  116.239175] ata2.00: error: {ABRT }
[  116.242839] ata2.00: configured for UDMA/133
[  116.247147] ata2: EH complete
[  116.250171] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.256651] ata2.00: irq_stat 0x40000001
[  116.260616] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.260617]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.276096] ata2.00: status: {DRDY ERR }
[  116.280058] ata2.00: error: {ABRT }
[  116.283720] ata2.00: configured for UDMA/133
[  116.288031] ata2: EH complete
[  116.291055] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.297531] ata2.00: irq_stat 0x40000001
[  116.306735] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.306736]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.322212] ata2.00: status: {DRDY ERR }
[  116.326172] ata2.00: error: {ABRT }
[  116.329835] ata2.00: configured for UDMA/133
[  116.334145] ata2: EH complete
[  116.337165] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.343637] ata2.00: irq_stat 0x40000001
[  116.347596] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.347597]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.363077] ata2.00: status: {DRDY ERR }
[  116.367039] ata2.00: error: {ABRT }
[  116.370700] ata2.00: configured for UDMA/133
[  116.375008] ata2: EH complete
[  116.378036] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.384511] ata2.00: irq_stat 0x40000001
[  116.388468] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.388469]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.403941] ata2.00: status: {DRDY ERR }
[  116.407903] ata2.00: error: {ABRT }
[  116.411568] ata2.00: configured for UDMA/133
[  116.415874] ata2: EH complete
[  116.418902] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.425377] ata2.00: irq_stat 0x40000001
[  116.429334] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.429334]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.444806] ata2.00: status: {DRDY ERR }
[  116.448770] ata2.00: error: {ABRT }
[  116.452431] ata2.00: configured for UDMA/133
[  116.456739] ata2: EH complete
[  116.459766] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  116.466245] ata2.00: irq_stat 0x40000001
[  116.470208] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  116.470209]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  116.485681] ata2.00: status: {DRDY ERR }
[  116.489642] ata2.00: error: {ABRT }
[  117.009101] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[  117.015318] ata2.00: revalidation failed (errno=-5)
[  117.020235] ata2: failed to recover some devices, retrying in 5 secs
[  124.226882] ata2: soft resetting link
[  124.230588] ata2: SATA link down (SStatus 11 SControl 310)
[  124.236116] ata2.00: limiting speed to UDMA/133:PIO2
[  124.241118] ata2: failed to recover some devices, retrying in 5 secs
[  129.247593] ata2: hard resetting link
[  129.937244] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  129.943597] ata2.00: configured for UDMA/133
[  129.947910] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0x3 t4
[  129.954993] ata2: irq_stat 0x00000040, connection status changed
[  129.961030] ata2: SError: {PHYRdyChg DevExch }
[  130.676856] ata2: soft resetting link
[  130.840099] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  160.827820] ata2.00: qc timeout (cmd 0xec)
[  160.831960] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  160.838083] ata2.00: revalidation failed (errno=-5)
[  160.842992] ata2: failed to recover some devices, retrying in 5 secs
[  165.848538] ata2: hard resetting link
[  171.335704] ata2: port is slow to respond, please be patient (Status 0x80)
[  175.873327] ata2: COMRESET failed (errno=-16)
[  175.877722] ata2: hard resetting link
[  176.566303] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  176.572661] ata2.00: configured for UDMA/133
[  176.576975] ata2: EH complete
[  176.580007] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  176.586484] ata2.00: irq_stat 0x40000001
[  176.590448] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  176.590449]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  176.605920] ata2.00: status: {DRDY ERR }
[  176.609882] ata2.00: error: {ABRT }
[  176.613546] ata2.00: configured for UDMA/133
[  176.617853] ata2: EH complete
[  176.620880] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  176.627355] ata2.00: irq_stat 0x40000001
[  176.631312] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  176.631313]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  176.646785] ata2.00: status: {DRDY ERR }
[  176.650747] ata2.00: error: {ABRT }
[  176.654413] ata2.00: configured for UDMA/133
[  176.658718] ata2: EH complete
[  176.661746] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  176.668221] ata2.00: irq_stat 0x40000001
[  176.672178] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  176.672179]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  176.687659] ata2.00: status: {DRDY ERR }
[  176.691621] ata2.00: error: {ABRT }
[  176.695285] ata2.00: configured for UDMA/133
[  176.699592] ata2: EH complete
[  176.702616] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  176.709087] ata2.00: irq_stat 0x40000001
[  176.713043] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  176.713044]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  176.728518] ata2.00: status: {DRDY ERR }
[  176.732480] ata2.00: error: {ABRT }
[  176.736140] ata2.00: configured for UDMA/133
[  176.740451] ata2: EH complete
[  176.743474] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  176.749952] ata2.00: irq_stat 0x40000001
[  176.753909] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  176.753910]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  176.769381] ata2.00: status: {DRDY ERR }
[  176.773343] ata2.00: error: {ABRT }
[  176.777010] ata2.00: configured for UDMA/133
[  176.781315] ata2: EH complete
[  176.784342] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  176.790817] ata2.00: irq_stat 0x40000001
[  176.794774] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  176.794775]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  176.810247] ata2.00: status: {DRDY ERR }
[  176.814208] ata2.00: error: {ABRT }
[  176.817872] ata2.00: configured for UDMA/133
[  176.822181] ata2: EH complete
[  177.822305] .not responding...
[  177.825454] sd 2:0:0:0: [sdd] 640 512-byte hardware sectors (0 MB)
[  177.831678] sd 2:0:0:0: [sdd] Write Protect is off
[  177.836514] sd 2:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  177.845727] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  177.852200] ata2.00: irq_stat 0x40000001
[  177.856164] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  177.856164]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  177.871636] ata2.00: status: {DRDY ERR }
[  177.875598] ata2.00: error: {ABRT }
[  177.879263] ata2.00: configured for UDMA/133
[  177.883569] ata2: EH complete
[  177.886594] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  177.893071] ata2.00: irq_stat 0x40000001
[  177.897028] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  177.897028]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  177.912501] ata2.00: status: {DRDY ERR }
[  177.916464] ata2.00: error: {ABRT }
[  177.920125] ata2.00: configured for UDMA/133
[  177.924433] ata2: EH complete
[  177.927460] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  177.933938] ata2.00: irq_stat 0x40000001
[  177.937904] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  177.937905]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  177.953431] ata2.00: status: {DRDY ERR }
[  177.957388] ata2.00: error: {ABRT }
[  177.961052] ata2.00: configured for UDMA/133
[  177.965360] ata2: EH complete
[  177.968386] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  177.974864] ata2.00: irq_stat 0x40000001
[  177.978830] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  177.978830]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  177.994309] ata2.00: status: {DRDY ERR }
[  177.998273] ata2.00: error: {ABRT }
[  178.001933] ata2.00: configured for UDMA/133
[  178.006242] ata2: EH complete
[  178.009270] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.015747] ata2.00: irq_stat 0x40000001
[  178.019710] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.019711]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.040433] ata2.00: status: {DRDY ERR }
[  178.044395] ata2.00: error: {ABRT }
[  178.048058] ata2.00: configured for UDMA/133
[  178.052365] ata2: EH complete
[  178.055390] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.061870] ata2.00: irq_stat 0x40000001
[  178.065833] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.065834]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.081306] ata2.00: status: {DRDY ERR }
[  178.085270] ata2.00: error: {ABRT }
[  178.088932] ata2.00: configured for UDMA/133
[  178.093241] ata2: EH complete
[  178.096265] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.102745] ata2.00: irq_stat 0x40000001
[  178.106708] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.106709]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.122182] ata2.00: status: {DRDY ERR }
[  178.126144] ata2.00: error: {ABRT }
[  178.129804] ata2.00: configured for UDMA/133
[  178.134115] ata2: EH complete
[  178.137139] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.143616] ata2.00: irq_stat 0x40000001
[  178.147573] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.147574]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.163046] ata2.00: status: {DRDY ERR }
[  178.167007] ata2.00: error: {ABRT }
[  178.170670] ata2.00: configured for UDMA/133
[  178.174978] ata2: EH complete
[  178.178005] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.184481] ata2.00: irq_stat 0x40000001
[  178.188438] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.188439]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.203911] ata2.00: status: {DRDY ERR }
[  178.207872] ata2.00: error: {ABRT }
[  178.211535] ata2.00: configured for UDMA/133
[  178.215844] ata2: EH complete
[  178.218871] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.225347] ata2.00: irq_stat 0x40000001
[  178.229303] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.229304]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.244787] ata2.00: status: {DRDY ERR }
[  178.248748] ata2.00: error: {ABRT }
[  178.252410] ata2.00: configured for UDMA/133
[  178.256718] ata2: EH complete
[  178.259743] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.266221] ata2.00: irq_stat 0x40000001
[  178.270177] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.270178]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.285651] ata2.00: status: {DRDY ERR }
[  178.289612] ata2.00: error: {ABRT }
[  178.293275] ata2.00: configured for UDMA/133
[  178.297583] ata2: EH complete
[  178.300608] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.307086] ata2.00: irq_stat 0x40000001
[  178.311043] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.311044]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.326515] ata2.00: status: {DRDY ERR }
[  178.330477] ata2.00: error: {ABRT }
[  178.334144] ata2.00: configured for UDMA/133
[  178.338450] ata2: EH complete
[  178.341484] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.347959] ata2.00: irq_stat 0x40000001
[  178.351916] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.351917]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.367399] ata2.00: status: {DRDY ERR }
[  178.371361] ata2.00: error: {ABRT }
[  178.375022] ata2.00: configured for UDMA/133
[  178.379332] ata2: EH complete
[  178.382357] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.388835] ata2.00: irq_stat 0x40000001
[  178.392799] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.392799]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.408272] ata2.00: status: {DRDY ERR }
[  178.412234] ata2.00: error: {ABRT }
[  178.415899] ata2.00: configured for UDMA/133
[  178.420205] ata2: EH complete
[  178.423233] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.429708] ata2.00: irq_stat 0x40000001
[  178.433665] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.433665]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.449137] ata2.00: status: {DRDY ERR }
[  178.453099] ata2.00: error: {ABRT }
[  178.456762] ata2.00: configured for UDMA/133
[  178.461070] ata2: EH complete
[  178.464090] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.470564] ata2.00: irq_stat 0x40000001
[  178.474521] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.474522]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.490004] ata2.00: status: {DRDY ERR }
[  178.493966] ata2.00: error: {ABRT }
[  178.497626] ata2.00: configured for UDMA/133
[  178.501937] ata2: EH complete
[  178.504961] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.511439] ata2.00: irq_stat 0x40000001
[  178.515395] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.515396]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.530868] ata2.00: status: {DRDY ERR }
[  178.534829] ata2.00: error: {ABRT }
[  178.538493] ata2.00: configured for UDMA/133
[  178.542801] ata2: EH complete
[  178.545827] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.552304] ata2.00: irq_stat 0x40000001
[  178.556261] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  178.556262]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.571: {ABRT }
[  178.579359] ata2.00: configured for UDMA/133
[  178.583668] ata2: EH complete
[  178.583670] sd 2:0:0:0: [sdd] a2.00: irq_stat 0x40000001
[  178.600661] ata2.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 0 
[  178.60066status: {DRDY ERR }
[  178.620095] ata2.00: error: {ABRT }
[  178.623756] ata2.00: configured for UDMA/133
[  178.628067] at0 data 0 
[  178.641526]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.656999] ata2.00: stMA/133
[  178.668930] ata2: EH complete
[  178.671958] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  178.6784 0 cdb 0x0 data 0 
[  178.682391]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.697873] atred for UDMA/133
[  178.709805] ata2: EH complete
[  178.712832] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[rror)
[  178.738745] ata2.00: status: {DRDY ERR }
[  178.742709] ata2.00: error: {ABRT }
[  178.746370] ata2.00: configured 0 SErr 0x0 action 0x0
[  178.760182] ata2.00: irq_stat 0x40000001
[  178.769394] ata2.00: cmd 40/00:01:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 0 
[  178.769395]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.78 ERR }
[  178.788831] ata2.00: error: {ABRT }
[  178.792495] ata2.00: configured for UDMA/133
[  178.796801] ata2: EH comple 178.810263]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  178.825742] ata2.00: status: {DRDY E8.837676] ata2: EH complete
[  179.837924] .<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  179.844821] ata2.00: irq_stat 0x40000001
[  179.848785] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  179.848786]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  179.864265] ata2.00: status: {DRDY ERR }
[  179.868226] ata2.00: error: {ABRT }
[  179.871891] ata2.00: configured for UDMA/133
[  179.876197] ata2: EH complete
[  179.879224] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  179.885700] ata2.00: irq_stat 0x40000001
[  179.889659] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  179.889660]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  179.905138] ata2.00: status: {DRDY ERR }
[  179.909102] ata2.00: error: {ABRT }
[  179.912763] ata2.00: configured for UDMA/133
[  179.917071] ata2: EH complete
[  179.920098] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  179.926576] ata2.00: irq_stat 0x40000001
[  179.930539] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  179.930540]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  179.946012] ata2.00: status: {DRDY ERR }
[  179.949976] ata2.00: error: {ABRT }
[  179.953637] ata2.00: configured for UDMA/133
[  179.957945] ata2: EH complete
[  179.960969] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  179.967440] ata2.00: irq_stat 0x40000001
[  179.971396] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  179.971397]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  179.986869] ata2.00: status: {DRDY ERR }
[  179.990831] ata2.00: error: {ABRT }
[  179.994494] ata2.00: configured for UDMA/133
[  179.998802] ata2: EH complete
[  180.001828] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.008306] ata2.00: irq_stat 0x40000001
[  180.012272] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.012272]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.027743] ata2.00: status: {DRDY ERR }
[  180.031705] ata2.00: error: {ABRT }
[  180.035369] ata2.00: configured for UDMA/133
[  180.039677] ata2: EH complete
[  180.042702] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.049180] ata2.00: irq_stat 0x40000001
[  180.053146] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.053147]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.068636] ata2.00: status: {DRDY ERR }
[  180.072598] ata2.00: error: {ABRT }
[  180.076258] ata2.00: configured for UDMA/133
[  180.080569] ata2: EH complete
[  180.083594] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.090070] ata2.00: irq_stat 0x40000001
[  180.094028] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.094029]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.109508] ata2.00: status: {DRDY ERR }
[  180.113472] ata2.00: error: {ABRT }
[  180.117132] ata2.00: configured for UDMA/133
[  180.121442] ata2: EH complete
[  180.124469] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.130945] ata2.00: irq_stat 0x40000001
[  180.134901] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.134902]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.150374] ata2.00: status: {DRDY ERR }
[  180.154336] ata2.00: error: {ABRT }
[  180.158000] ata2.00: configured for UDMA/133
[  180.162307] ata2: EH complete
[  180.165332] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.171809] ata2.00: irq_stat 0x40000001
[  180.175766] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.175766]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.191239] ata2.00: status: {DRDY ERR }
[  180.195202] ata2.00: error: {ABRT }
[  180.198863] ata2.00: configured for UDMA/133
[  180.203173] ata2: EH complete
[  180.206197] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.212675] ata2.00: irq_stat 0x40000001
[  180.216631] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.216632]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.232104] ata2.00: status: {DRDY ERR }
[  180.236066] ata2.00: error: {ABRT }
[  180.239729] ata2.00: configured for UDMA/133
[  180.244037] ata2: EH complete
[  180.247064] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.253542] ata2.00: irq_stat 0x40000001
[  180.257505] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.257506]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.272978] ata2.00: status: {DRDY ERR }
[  180.276940] ata2.00: error: {ABRT }
[  180.280603] ata2.00: configured for UDMA/133
[  180.284911] ata2: EH complete
[  180.287938] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.294414] ata2.00: irq_stat 0x40000001
[  180.298370] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.298371]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.313854] ata2.00: status: {DRDY ERR }
[  180.317816] ata2.00: error: {ABRT }
[  180.321479] ata2.00: configured for UDMA/133
[  180.325787] ata2: EH complete
[  180.328821] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.335296] ata2.00: irq_stat 0x40000001
[  180.339253] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.339254]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.354728] ata2.00: status: {DRDY ERR }
[  180.358690] ata2.00: error: {ABRT }
[  180.362351] ata2.00: configured for UDMA/133
[  180.366659] ata2: EH complete
[  180.369686] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.376165] ata2.00: irq_stat 0x40000001
[  180.380128] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.380129]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.395600] ata2.00: status: {DRDY ERR }
[  180.399564] ata2.00: error: {ABRT }
[  180.403224] ata2.00: configured for UDMA/133
[  180.407535] ata2: EH complete
[  180.410567] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.417045] ata2.00: irq_stat 0x40000001
[  180.421001] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.421002]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.436474] ata2.00: status: {DRDY ERR }
[  180.440436] ata2.00: error: {ABRT }
[  180.444099] ata2.00: configured for UDMA/133
[  180.448407] ata2: EH complete
[  180.451435] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.457909] ata2.00: irq_stat 0x40000001
[  180.461868] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.461869]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.477350] ata2.00: status: {DRDY ERR }
[  180.481312] ata2.00: error: {ABRT }
[  180.484975] ata2.00: configured for UDMA/133
[  180.489281] ata2: EH complete
[  180.492308] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.498785] ata2.00: irq_stat 0x40000001
[  180.508004] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.508005]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.523481] ata2.00: status: {DRDY ERR }
[  180.527443] ata2.00: error: {ABRT }
[  180.531105] ata2.00: configured for UDMA/133
[  180.535415] ata2: EH complete
[  180.538449] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  180.544924] ata2.00: irq_stat 0x40000001
[  180.548880] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  180.548881]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  180.564353] ata2.00: status: {DRDY ERR }
[  180.568317] ata2.00: error: {ABRT }
[  180.571977] ata2.00: configured for UDMA/133
[  180.576289] ata2: EH complete
[  181.577019] .<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  181.583908] ata2.00: irq_stat 0x40000001
[  181.587872] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  181.587873]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  181.603363] ata2.00: status: {DRDY ERR }
[  181.607325] ata2.00: error: {ABRT }
[  181.610988] ata2.00: configured for UDMA/133
[  181.615294] ata2: EH complete
[  181.618321] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  181.624797] ata2.00: irq_stat 0x40000001
[  181.628753] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  181.628754]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  181.644226] ata2.00: status: {DRDY ERR }
[  181.648188] ata2.00: error: {ABRT }
[  181.651850] ata2.00: configured for UDMA/133
[  181.656158] ata2: EH complete
[  181.659185] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  181.665663] ata2.00: irq_stat 0x40000001
[  181.669627] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  181.669628]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  181.685102] ata2.00: status: {DRDY ERR }
[  181.689064] ata2.00: error: {ABRT }
[  181.692724] ata2.00: configured for UDMA/133
[  181.697034] ata2: EH complete
[  181.700056] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  181.706528] ata2.00: irq_stat 0x40000001
[  181.710484] ata2.00: cmd e5/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
[  181.710485]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[  181.725957] ata2.00: status: {DRDY ERR }
[  181.729920] ata2.00: error: {ABRT }
[  182.249375] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[  182.255595] ata2.00: revalidation failed (errno=-5)
[  182.260511] ata2: failed to recover some devices, retrying in 5 secs
[  189.469586] ata2: soft resetting link
[  189.473287] ata2: SATA link down (SStatus 11 SControl 310)
[  189.478809] ata2.00: limiting speed to UDMA/133:PIO1
[  189.483812] ata2: failed to recover some devices, retrying in 5 secs
[  194.490292] ata2: hard resetting link
[  195.179947] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  195.186298] ata2.00: configured for UDMA/133
[  195.190611] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0x3 t4
[  195.197695] ata2: irq_stat 0x00000040, connection status changed
[  195.203741] ata2: SError: {PHYRdyChg DevExch }
[  195.919559] ata2: soft resetting link
[  196.082802] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)

--------------090205090900000102020404
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci"

00:00.0 Host bridge: Intel Corporation 82975X Memory Controller Hub (rev c0)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8178
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: <access denied>

00:01.0 PCI bridge: Intel Corporation 82975X PCI Express Root Port (rev c0) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Memory behind bridge: faa00000-feafffff
	Prefetchable memory behind bridge: 00000000cff00000-00000000efefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
	Subsystem: ASUSTeK Computer Inc. Unknown device 81d8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at febfc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Prefetchable memory behind bridge: 00000000cfe00000-00000000cfefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fa900000-fa9fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express Port 6 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fa800000-fa8fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at e800 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at e880 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at ec00 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at febfbc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fa600000-fa7fffff
	Prefetchable memory behind bridge: 0000000050000000-00000000500fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: <access denied>

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ffa0 [size=16]

00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI (rev 01) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Unknown device 2606
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 315
	Region 0: I/O ports at e480 [size=8]
	Region 1: I/O ports at e400 [size=4]
	Region 2: I/O ports at e080 [size=8]
	Region 3: I/O ports at e000 [size=4]
	Region 4: I/O ports at dc00 [size=16]
	Region 5: Memory at febfb800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 23
	Region 4: I/O ports at 0400 [size=32]

01:00.0 RAID bus controller: Silicon Image, Inc. PCI0680 Ultra ATA-133 Host Controller (rev 02)
	Subsystem: Silicon Image, Inc. Winic W-680 (Silicon Image 680 based)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at ac00 [size=8]
	Region 1: I/O ports at a880 [size=4]
	Region 2: I/O ports at a800 [size=8]
	Region 3: I/O ports at a480 [size=4]
	Region 4: I/O ports at a400 [size=16]
	Region 5: Memory at fa7ffc00 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at 50000000 [disabled] [size=512K]
	Capabilities: <access denied>

01:01.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
	Subsystem: Adaptec AHA-2940U2W SCSI Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (9750ns min, 6250ns max)
	Interrupt: pin A routed to IRQ 22
	BIST result: 00
	Region 0: I/O ports at a000 [disabled] [size=256]
	Region 1: Memory at fa7fe000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at 50080000 [disabled] [size=128K]
	Capabilities: <access denied>

02:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81e4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 17
	Region 5: Memory at fa8fe000 (32-bit, non-prefetchable) [size=8K]
	Expansion ROM at fa8e0000 [disabled] [size=64K]
	Capabilities: <access denied>

02:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81e4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 0
	Region 0: I/O ports at bc00 [size=8]
	Region 1: I/O ports at b880 [size=4]
	Region 2: I/O ports at b800 [size=8]
	Region 3: I/O ports at b480 [size=4]
	Region 4: I/O ports at b400 [size=16]
	Capabilities: <access denied>

03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller (rev 20)
	Subsystem: ASUSTeK Computer Inc. Marvell 88E8053 Gigabit Ethernet controller PCIe (Asus)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 314
	Region 0: Memory at fa9fc000 (64-bit, non-prefetchable) [size=16K]
	Region 2: I/O ports at c800 [size=256]
	Expansion ROM at fa9c0000 [disabled] [size=128K]
	Capabilities: <access denied>

05:00.0 VGA compatible controller: nVidia Corporation GeForce 7300 GS (rev a1) (prog-if 00 [VGA])
	Subsystem: Unknown device 19f1:1fe2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at fc000000 (64-bit, non-prefetchable) [size=16M]
	[virtual] Expansion ROM at feae0000 [disabled] [size=128K]
	Capabilities: <access denied>


--------------090205090900000102020404--
