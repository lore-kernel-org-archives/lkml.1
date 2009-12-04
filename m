Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbZLDU2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbZLDU2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZLDU2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:28:47 -0500
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:59929 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757045AbZLDU2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:28:42 -0500
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2009 15:28:40 EST
Date: Fri, 4 Dec 2009 22:28:41 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: linux-kernel@vger.kernel.org
Subject: Boot problem
Message-ID: <Pine.LNX.4.64.0912042221220.4703@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="33734824-907845940-1259954921=:4703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--33734824-907845940-1259954921=:4703
Content-Type: TEXT/PLAIN; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Perhaps someone could sched some light on the rather weird boot
problems i'm seeing.

Linux fails to boot first time after a cold boot and after
/sbin/reboot.  I was able to capture the output via serial
console. Both successful and failed logs are included. This happens
with stock Slackware64 kernel as well as recently released 2.6.32.
Booting with 'nolapic' parameter works every time.

If there's anything else i can do to help resolving it please do tell.

Successful log:

  Linux version 2.6.29.6 (root@midas64) (gcc version 4.3.3 (GCC) ) #2 SMP M=
on Aug 17 11:58:18 CDT 2009
  Command line: BOOT_IMAGE=3D/boot/vmlinuz-huge-2.6.29.6 root=3D/dev/sda3 r=
o console=3DttyS0,9600
  KERNEL supported cpus:
    Intel GenuineIntel
    AMD AuthenticAMD
    Centaur CentaurHauls
  BIOS-provided physical RAM map:
   BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
   BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
   BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
   BIOS-e820: 0000000000100000 - 000000005fee0000 (usable)
   BIOS-e820: 000000005fee0000 - 000000005fee3000 (ACPI NVS)
   BIOS-e820: 000000005fee3000 - 000000005fef0000 (ACPI data)
   BIOS-e820: 000000005fef0000 - 000000005ff00000 (reserved)
   BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
   BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
  DMI 2.4 present.
  last_pfn =3D 0x5fee0 max_arch_pfn =3D 0x100000000
  init_memory_mapping: 0000000000000000-000000005fee0000
  last_map_addr: 5fee0000 end: 5fee0000
  ACPI: RSDP 000F6E70, 0014 (r0 GBT   )
  ACPI: RSDT 5FEE3040, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
  ACPI: FACP 5FEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
  FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
  ACPI: DSDT 5FEE3180, 4B35 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
  ACPI: FACS 5FEE0000, 0040
  ACPI: HPET 5FEE7E00, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
  ACPI: MCFG 5FEE7E80, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
  ACPI: APIC 5FEE7D00, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
  ACPI: SSDT 5FEE7F00, 015C (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
  ACPI: SSDT 5FEE8390, 0275 (r1  PmRef    CpuPm     3000 INTL 20040311)
  (5 early reservations) =3D=3D> bootmem [0000000000 - 005fee0000]
    #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 000=
0001000]
    #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [0000006000 - 000=
0008000]
    #2 [0000200000 - 0000d2a9ac]    TEXT DATA BSS =3D=3D> [0000200000 - 000=
0d2a9ac]
    #3 [000009f800 - 0000100000]    BIOS reserved =3D=3D> [000009f800 - 000=
0100000]
    #4 [0000008000 - 000000a000]          PGTABLE =3D=3D> [0000008000 - 000=
000a000]
  found SMP MP-table at [ffff8800000f54c0] 000f54c0
  Zone PFN ranges:
    DMA      0x00000000 -> 0x00001000
    DMA32    0x00001000 -> 0x00100000
    Normal   0x00100000 -> 0x00100000
  Movable zone start PFN for each node
  early_node_map[2] active PFN ranges
      0: 0x00000000 -> 0x0000009f
      0: 0x00000100 -> 0x0005fee0
  ACPI: PM-Timer IO Port: 0x408
  ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
  ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
  ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
  ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
  ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
  ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
  ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
  ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
  ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
  IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
  ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
  Using ACPI (MADT) for SMP configuration information
  ACPI: HPET id: 0x8086a201 base: 0xfed00000
  SMP: Allowing 4 CPUs, 2 hotplug CPUs
  PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
  PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
  PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
  Allocating PCI resources starting at 60000000 (gap: 5ff00000:90100000)
  NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
  PERCPU: Allocating 53248 bytes of per cpu data
  Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3844=
97
  Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-huge-2.6.29.6 root=3D/dev=
/sda3 ro console=3DttyS0,9600
  Initializing CPU#0
  PID hash table entries: 4096 (order: 12, 32768 bytes)
  Fast TSC calibration using PIT
  Detected 2133.162 MHz processor.
  Console: colour VGA+ 80x25
  console [ttyS0] enabled
  Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
  Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
  Checking aperture...
  No AGP bridge found
  Memory: 1533356k/1571712k available (7163k kernel code, 388k absent, 3746=
0k reserved, 2798k data, 436k init)
  SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4,=
 Nodes=3D1
  HPET: 3 timers in total, 0 timers will be used for per-cpu timer
  Calibrating delay loop (skipped), value calculated using timer frequency.=
=2E 4266.32 BogoMIPS (lpj=3D2133162)
  Security Framework initialized
  Mount-cache hash table entries: 256
  CPU: L1 I cache: 32K, L1 D cache: 32K
  CPU: L2 cache: 2048K
  CPU: Physical Processor ID: 0
  CPU: Processor Core ID: 0
  CPU0: Thermal monitoring enabled (TM2)
  using mwait in idle threads.
  ACPI: Core revision 20081204
  Setting APIC routing to flat
  ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
  CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
  Booting processor 1 APIC 0x1 ip 0x6000
  Initializing CPU#1
  Calibrating delay using timer specific routine.. 4266.55 BogoMIPS (lpj=3D=
2133278)
  CPU: L1 I cache: 32K, L1 D cache: 32K
  CPU: L2 cache: 2048K
  CPU: Physical Processor ID: 0
  CPU: Processor Core ID: 1
  CPU1: Thermal monitoring enabled (TM2)
  CPU1: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
  checking TSC synchronization [CPU#0 -> CPU#1]: passed.
  Brought up 2 CPUs
  Total of 2 processors activated (8532.88 BogoMIPS).
  net_namespace: 1736 bytes
  xor: automatically using best checksumming function: generic_sse
     generic_sse:  7812.000 MB/sec
  xor: using function: generic_sse (7812.000 MB/sec)
  NET: Registered protocol family 16
  ACPI: bus type pci registered
  PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
  PCI: MCFG area at f0000000 reserved in E820
  PCI: Using MMCONFIG at f0000000 - f3ffffff
  PCI: Using configuration type 1 for base access
  bio: create slab <bio-0> at 0
  ACPI: Interpreter enabled
  ACPI: (supports S0 S3 S4 S5)
  ACPI: Using IOAPIC for interrupt routing
  ACPI: No dock devices found.
  ACPI: PCI Root Bridge [PCI0] (0000:00)
  pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
  pci 0000:00:01.0: PME# disabled
  pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
  pci 0000:00:1b.0: PME# disabled
  pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
  pci 0000:00:1c.0: PME# disabled
  pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
  pci 0000:00:1c.1: PME# disabled
  pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
  pci 0000:00:1c.3: PME# disabled
  pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
  pci 0000:00:1c.4: PME# disabled
  pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
  pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
  pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 000f)
  pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 000f)
  pci 0000:00:1f.2: PME# supported from D3hot
  pci 0000:00:1f.2: PME# disabled
  pci 0000:00:1f.5: PME# supported from D3hot
  pci 0000:00:1f.5: PME# disabled
  pci 0000:05:00.0: PME# supported from D3hot
  pci 0000:05:00.0: PME# disabled
  pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
  pci 0000:06:00.0: PME# disabled
  pci 0000:00:1e.0: transparent bridge
  ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
  ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
  ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
  ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
  ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, dis=
abled.
  ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
  ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
  ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 *6 7 9 10 11 12 14 15)
  SCSI subsystem initialized
  usbcore: registered new interface driver usbfs
  usbcore: registered new interface driver hub
  usbcore: registered new device driver usb
  PCI: Using ACPI for IRQ routing
  pnp: PnP ACPI init
  ACPI: bus type pnp registered
  pnp: PnP ACPI: found 15 devices
  ACPI: ACPI bus type pnp unregistered
  system 00:01: ioport range 0x4d0-0x4d1 has been reserved
  system 00:01: ioport range 0x290-0x29f has been reserved
  system 00:01: ioport range 0x800-0x87f has been reserved
  system 00:01: ioport range 0x290-0x294 has been reserved
  system 00:01: ioport range 0x880-0x88f has been reserved
  system 00:0b: ioport range 0x400-0x4bf could not be reserved
  system 00:0c: iomem range 0xf0000000-0xf3ffffff has been reserved
  system 00:0d: iomem range 0xcde00-0xcffff has been reserved
  system 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
  system 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
  system 00:0d: iomem range 0xfc000-0xfffff could not be reserved
  system 00:0d: iomem range 0x5fee0000-0x5fefffff could not be reserved
  system 00:0d: iomem range 0x0-0x9ffff could not be reserved
  system 00:0d: iomem range 0x100000-0x5fedffff could not be reserved
  system 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
  system 00:0d: iomem range 0xfed10000-0xfed1dfff has been reserved
  system 00:0d: iomem range 0xfed20000-0xfed8ffff has been reserved
  system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
  system 00:0d: iomem range 0xffb00000-0xffb7ffff has been reserved
  system 00:0d: iomem range 0xfff00000-0xffffffff has been reserved
  system 00:0d: iomem range 0xe0000-0xeffff has been reserved
  pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
  pci 0000:00:01.0:   IO window: 0x8000-0x8fff
  pci 0000:00:01.0:   MEM window: 0xf4000000-0xf7ffffff
  pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
  pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
  pci 0000:00:1c.0:   IO window: 0x7000-0x7fff
  pci 0000:00:1c.0:   MEM window: disabled
  pci 0000:00:1c.0:   PREFETCH window: disabled
  pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
  pci 0000:03:00.0:   IO window: disabled
  pci 0000:03:00.0:   MEM window: 0xfa100000-0xfa1fffff
  pci 0000:03:00.0:   PREFETCH window: disabled
  pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
  pci 0000:00:1c.1:   IO window: disabled
  pci 0000:00:1c.1:   MEM window: 0xfa100000-0xfa1fffff
  pci 0000:00:1c.1:   PREFETCH window: disabled
  pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
  pci 0000:00:1c.3:   IO window: 0x9000-0xafff
  pci 0000:00:1c.3:   MEM window: 0xfa000000-0xfa0fffff
  pci 0000:00:1c.3:   PREFETCH window: disabled
  pci 0000:00:1c.4: PCI bridge, secondary bus 0000:06
  pci 0000:00:1c.4:   IO window: 0xb000-0xbfff
  pci 0000:00:1c.4:   MEM window: 0xf8000000-0xf9ffffff
  pci 0000:00:1c.4:   PREFETCH window: 0x00000060000000-0x000000600fffff
  pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
  pci 0000:00:1e.0:   IO window: 0x6000-0x6fff
  pci 0000:00:1e.0:   MEM window: disabled
  pci 0000:00:1e.0:   PREFETCH window: disabled
  pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
  pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
  pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  NET: Registered protocol family 2
  IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
  TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
  TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
  TCP: Hash tables configured (established 262144 bind 65536)
  TCP reno registered
  NET: Registered protocol family 1
  VFS: Disk quotas dquot_6.5.2
  Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
  NTFS driver 2.1.29 [Flags: R/W].
  JFS: nTxBlock =3D 8192, nTxLock =3D 65536
  SGI XFS with ACLs, security attributes, large block/inode numbers, no deb=
ug enabled
  SGI XFS Quota Management subsystem
  GFS2 (built Aug 17 2009 11:56:22) installed
  msgmni has been set to 2995
  alg: No test for cipher_null (cipher_null-generic)
  alg: No test for digest_null (digest_null-generic)
  alg: No test for compress_null (compress_null-generic)
  alg: No test for fcrypt (fcrypt-generic)
  alg: No test for stdrng (krng)
  async_tx: api initialized (async)
  Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
  io scheduler noop registered
  io scheduler anticipatory registered
  io scheduler deadline registered
  io scheduler cfq registered (default)
  pci_hotplug: PCI Hot Plug PCI Core version: 0.5
  Linux agpgart interface v0.103
  Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
  =FFserial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
  00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
  [..snip..]

Failed log:

  Linux version 2.6.29.6 (root@midas64) (gcc version 4.3.3 (GCC) ) #2 SMP M=
on Aug 17 11:58:18 CDT 2009
  Command line: BOOT_IMAGE=3D/boot/vmlinuz-huge-2.6.29.6 root=3D/dev/sda3 r=
o console=3DttyS0,9600
  KERNEL supported cpus:
    Intel GenuineIntel
    AMD AuthenticAMD
    Centaur CentaurHauls
  BIOS-provided physical RAM map:
   BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
   BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
   BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
   BIOS-e820: 0000000000100000 - 000000005fee0000 (usable)
   BIOS-e820: 000000005fee0000 - 000000005fee3000 (ACPI NVS)
   BIOS-e820: 000000005fee3000 - 000000005fef0000 (ACPI data)
   BIOS-e820: 000000005fef0000 - 000000005ff00000 (reserved)
   BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
   BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
  DMI 2.4 present.
  last_pfn =3D 0x5fee0 max_arch_pfn =3D 0x100000000
  init_memory_mapping: 0000000000000000-000000005fee0000
  last_map_addr: 5fee0000 end: 5fee0000
  ACPI: RSDP 000F6E70, 0014 (r0 GBT   )
  ACPI: RSDT 5FEE3040, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
  ACPI: FACP 5FEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
  FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
  ACPI: DSDT 5FEE3180, 4B35 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
  ACPI: FACS 5FEE0000, 0040
  ACPI: HPET 5FEE7E00, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
  ACPI: MCFG 5FEE7E80, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
  ACPI: APIC 5FEE7D00, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
  ACPI: SSDT 5FEE7F00, 015C (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
  ACPI: SSDT 5FEE8390, 0275 (r1  PmRef    CpuPm     3000 INTL 20040311)
  (5 early reservations) =3D=3D> bootmem [0000000000 - 005fee0000]
    #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 000=
0001000]
    #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [0000006000 - 000=
0008000]
    #2 [0000200000 - 0000d2a9ac]    TEXT DATA BSS =3D=3D> [0000200000 - 000=
0d2a9ac]
    #3 [000009f800 - 0000100000]    BIOS reserved =3D=3D> [000009f800 - 000=
0100000]
    #4 [0000008000 - 000000a000]          PGTABLE =3D=3D> [0000008000 - 000=
000a000]
  found SMP MP-table at [ffff8800000f54c0] 000f54c0
  Zone PFN ranges:
    DMA      0x00000000 -> 0x00001000
    DMA32    0x00001000 -> 0x00100000
    Normal   0x00100000 -> 0x00100000
  Movable zone start PFN for each node
  early_node_map[2] active PFN ranges
      0: 0x00000000 -> 0x0000009f
      0: 0x00000100 -> 0x0005fee0
  ACPI: PM-Timer IO Port: 0x408
  ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
  ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
  ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
  ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
  ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
  ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
  ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
  ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
  ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
  IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
  ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
  Using ACPI (MADT) for SMP configuration information
  ACPI: HPET id: 0x8086a201 base: 0xfed00000
  SMP: Allowing 4 CPUs, 2 hotplug CPUs
  PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
  PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
  PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
  Allocating PCI resources starting at 60000000 (gap: 5ff00000:90100000)
  NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
  PERCPU: Allocating 53248 bytes of per cpu data
  Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3844=
97
  Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-huge-2.6.29.6 root=3D/dev=
/sda3 ro console=3DttyS0,9600
  Initializing CPU#0
  PID hash table entries: 4096 (order: 12, 32768 bytes)
  Fast TSC calibration failed
  TSC: Unable to calibrate against PIT
  TSC: using PMTIMER reference calibration
  Detected 2133.285 MHz processor.
  Console: colour VGA+ 80x25
  console [ttyS0] enabled
  Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
  Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
  Checking aperture...
  No AGP bridge found
  Memory: 1533356k/1571712k available (7163k kernel code, 388k absent, 3746=
0k reserved, 2798k data, 436k init)
  SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4,=
 Nodes=3D1
  HPET: 3 timers in total, 0 timers will be used for per-cpu timer
  Calibrating delay loop (skipped), value calculated using timer frequency.=
=2E 4266.57 BogoMIPS (lpj=3D2133285)
  Security Framework initialized
  Mount-cache hash table entries: 256
  CPU: L1 I cache: 32K, L1 D cache: 32K
  CPU: L2 cache: 2048K
  CPU: Physical Processor ID: 0
  CPU: Processor Core ID: 0
  CPU0: Thermal monitoring enabled (TM2)
  using mwait in idle threads.
  ACPI: Core revision 20081204
  Setting APIC routing to flat
  ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
  CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
  Booting processor 1 APIC 0x1 ip 0x6000
  Not responding.
  Brought up 1 CPUs
  Total of 1 processors activated (4266.57 BogoMIPS).
  net_namespace: 1736 bytes
  xor: automatically using best checksumming function: generic_sse
     generic_sse:  7812.000 MB/sec
  xor: using function: generic_sse (7812.000 MB/sec)
  NET: Registered protocol family 16
  ACPI: bus type pci registered
  PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
  PCI: MCFG area at f0000000 reserved in E820
  PCI: Using MMCONFIG at f0000000 - f3ffffff
  PCI: Using configuration type 1 for base access
  bio: create slab <bio-0> at 0
  ACPI: Interpreter enabled
  ACPI: (supports S0 S3 S4 S5)
  ACPI: Using IOAPIC for interrupt routing
  ACPI: No dock devices found.
  ACPI: PCI Root Bridge [PCI0] (0000:00)
  pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
  pci 0000:00:01.0: PME# disabled
  pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
  pci 0000:00:1b.0: PME# disabled
  pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
  pci 0000:00:1c.0: PME# disabled
  pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
  pci 0000:00:1c.1: PME# disabled
  pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
  pci 0000:00:1c.3: PME# disabled
  pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
  pci 0000:00:1c.4: PME# disabled
  pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
  pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
  pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 000f)
  pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 000f)
  pci 0000:00:1f.2: PME# supported from D3hot
  pci 0000:00:1f.2: PME# disabled
  pci 0000:00:1f.5: PME# supported from D3hot
  pci 0000:00:1f.5: PME# disabled
  pci 0000:05:00.0: PME# supported from D3hot
  pci 0000:05:00.0: PME# disabled
  pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
  pci 0000:06:00.0: PME# disabled
  pci 0000:00:1e.0: transparent bridge
  ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
  ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
  ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
  ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
  ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, dis=
abled.
  ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
  ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
  ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 *6 7 9 10 11 12 14 15)
  SCSI subsystem initialized
  usbcore: registered new interface driver usbfs
  usbcore: registered new interface driver hub
  usbcore: registered new device driver usb
  PCI: Using ACPI for IRQ routing
  pnp: PnP ACPI init
  ACPI: bus type pnp registered
  pnp: PnP ACPI: found 14 devices
  ACPI: ACPI bus type pnp unregistered
  system 00:01: ioport range 0x4d0-0x4d1 has been reserved
  system 00:01: ioport range 0x290-0x29f has been reserved
  system 00:01: ioport range 0x800-0x87f has been reserved
  system 00:01: ioport range 0x290-0x294 has been reserved
  system 00:01: ioport range 0x880-0x88f has been reserved
  system 00:0a: ioport range 0x400-0x4bf could not be reserved
  system 00:0b: iomem range 0xf0000000-0xf3ffffff has been reserved
  system 00:0c: iomem range 0xcde00-0xcffff has been reserved
  system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
  system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
  system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
  system 00:0c: iomem range 0x5fee0000-0x5fefffff could not be reserved
  system 00:0c: iomem range 0x0-0x9ffff could not be reserved
  system 00:0c: iomem range 0x100000-0x5fedffff could not be reserved
  system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
  system 00:0c: iomem range 0xfed10000-0xfed1dfff has been reserved
  system 00:0c: iomem range 0xfed20000-0xfed8ffff has been reserved
  system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
  system 00:0c: iomem range 0xffb00000-0xffb7ffff has been reserved
  system 00:0c: iomem range 0xfff00000-0xffffffff has been reserved
  system 00:0c: iomem range 0xe0000-0xeffff has been reserved
  pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
  pci 0000:00:01.0:   IO window: 0x8000-0x8fff
  pci 0000:00:01.0:   MEM window: 0xf4000000-0xf7ffffff
  pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
  pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
  pci 0000:00:1c.0:   IO window: 0x7000-0x7fff
  pci 0000:00:1c.0:   MEM window: disabled
  pci 0000:00:1c.0:   PREFETCH window: disabled
  pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
  pci 0000:03:00.0:   IO window: disabled
  pci 0000:03:00.0:   MEM window: 0xfa100000-0xfa1fffff
  pci 0000:03:00.0:   PREFETCH window: disabled
  pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
  pci 0000:00:1c.1:   IO window: disabled
  pci 0000:00:1c.1:   MEM window: 0xfa100000-0xfa1fffff
  pci 0000:00:1c.1:   PREFETCH window: disabled
  pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
  pci 0000:00:1c.3:   IO window: 0x9000-0xafff
  pci 0000:00:1c.3:   MEM window: 0xfa000000-0xfa0fffff
  pci 0000:00:1c.3:   PREFETCH window: disabled
  pci 0000:00:1c.4: PCI bridge, secondary bus 0000:06
  pci 0000:00:1c.4:   IO window: 0xb000-0xbfff
  pci 0000:00:1c.4:   MEM window: 0xf8000000-0xf9ffffff
  pci 0000:00:1c.4:   PREFETCH window: 0x00000060000000-0x000000600fffff
  pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
  pci 0000:00:1e.0:   IO window: 0x6000-0x6fff
  pci 0000:00:1e.0:   MEM window: disabled
  pci 0000:00:1e.0:   PREFETCH window: disabled
  pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
  pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
  pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  NET: Registered protocol family 2
  IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
  TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
  TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
  TCP: Hash tables configured (established 262144 bind 65536)
  TCP reno registered
  NET: Registered protocol family 1
  VFS: Disk quotas dquot_6.5.2
  Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
  NTFS driver 2.1.29 [Flags: R/W].
  JFS: nTxBlock =3D 8192, nTxLock =3D 65536
  SGI XFS with ACLs, security attributes, large block/inode numbers, no deb=
ug enabled
  SGI XFS Quota Management subsystem
  GFS2 (built Aug 17 2009 11:56:22) installed
  msgmni has been set to 2995
  alg: No test for cipher_null (cipher_null-generic)
  alg: No test for digest_null (digest_null-generic)
  alg: No test for compress_null (compress_null-generic)
  alg: No test for fcrypt (fcrypt-generic)
  alg: No test for stdrng (krng)
  async_tx: api initialized (async)
  Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
  io scheduler noop registered
  io scheduler anticipatory registered
  io scheduler deadline registered
  io scheduler cfq registered (default)
  pci_h

=2Econfig:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29.6
# Mon Aug 17 11:55:29 2009
#
CONFIG_64BIT=3Dy
# CONFIG_X86_32 is not set
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_FAST_CMPXCHG_LOCAL=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_GENERIC_GPIO=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_RWSEM_GENERIC_SPINLOCK=3Dy
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_DEFAULT_IDLE=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_X86_SMP=3Dy
CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_X86_BIOS_REBOOT=3Dy
CONFIG_X86_TRAMPOLINE=3Dy
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_LOCK_KERNEL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=3Dy
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=3Dy
CONFIG_IKCONFIG_PROC=3Dy
CONFIG_LOG_BUF_SHIFT=3D15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=3Dy
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_PCI_QUIRKS=3Dy
CONFIG_SLUB_DEBUG=3Dy
CONFIG_COMPAT_BRK=3Dy
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
CONFIG_PROFILING=3Dy
CONFIG_TRACEPOINTS=3Dy
CONFIG_MARKERS=3Dy
CONFIG_OPROFILE=3Dm
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=3Dy
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
CONFIG_MODULE_FORCE_LOAD=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_BLK_DEV_BSG=3Dy
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_AS=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"
CONFIG_PREEMPT_NOTIFIERS=3Dy
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_FIND_SMP_CONFIG=3Dy
CONFIG_X86_MPPARSE=3Dy
CONFIG_X86_PC=3Dy
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_MEMTEST=3Dy
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=3Dy
CONFIG_X86_CPU=3Dy
CONFIG_X86_L1_CACHE_BYTES=3D128
CONFIG_X86_INTERNODE_CACHE_BYTES=3D128
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D7
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
CONFIG_CPU_SUP_CENTAUR_64=3Dy
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=3D32
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
CONFIG_PREEMPT_NONE=3Dy
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=3Dy
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_INTEL=3Dy
CONFIG_X86_MCE_AMD=3Dy
CONFIG_I8K=3Dm
CONFIG_MICROCODE=3Dm
CONFIG_MICROCODE_INTEL=3Dy
CONFIG_MICROCODE_AMD=3Dy
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dm
CONFIG_X86_CPUID=3Dm
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_SELECT_MEMORY_MODEL=3Dy
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
CONFIG_UNEVICTABLE_LRU=3Dy
CONFIG_MMU_NOTIFIER=3Dy
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=3Dy
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=3Dy
CONFIG_HZ=3D1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=3D0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x200000
CONFIG_HOTPLUG_CPU=3Dy
CONFIG_COMPAT_VDSO=3Dy
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=3Dy
CONFIG_PM=3Dy
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=3Dy
CONFIG_PM_SLEEP=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_SUSPEND_FREEZER=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D"\"\""
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
CONFIG_ACPI_PROCFS_POWER=3Dy
CONFIG_ACPI_SYSFS_POWER=3Dy
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dm
CONFIG_ACPI_BATTERY=3Dm
CONFIG_ACPI_BUTTON=3Dm
CONFIG_ACPI_VIDEO=3Dm
CONFIG_ACPI_FAN=3Dm
CONFIG_ACPI_DOCK=3Dy
CONFIG_ACPI_PROCESSOR=3Dm
CONFIG_ACPI_HOTPLUG_CPU=3Dy
CONFIG_ACPI_THERMAL=3Dm
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=3Dm
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dm
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dm
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=3Dm
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dm
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=3Dm
CONFIG_X86_POWERNOW_K8=3Dm
CONFIG_X86_POWERNOW_K8_ACPI=3Dy
CONFIG_X86_SPEEDSTEP_CENTRINO=3Dm
CONFIG_X86_P4_CLOCKMOD=3Dm

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=3Dm
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=3Dy
CONFIG_I7300_IDLE=3Dm

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=3Dy
CONFIG_HOTPLUG_PCI_PCIE=3Dm
CONFIG_PCIEAER=3Dy
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
CONFIG_PCI_LEGACY=3Dy
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_K8_NB=3Dy
CONFIG_PCCARD=3Dm
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=3Dm
CONFIG_PCMCIA_LOAD_CIS=3Dy
CONFIG_PCMCIA_IOCTL=3Dy
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
CONFIG_YENTA=3Dm
CONFIG_YENTA_O2=3Dy
CONFIG_YENTA_RICOH=3Dy
CONFIG_YENTA_TI=3Dy
CONFIG_YENTA_ENE_TUNE=3Dy
CONFIG_YENTA_TOSHIBA=3Dy
CONFIG_PD6729=3Dm
CONFIG_I82092=3Dm
CONFIG_PCCARD_NONSTATIC=3Dm
CONFIG_HOTPLUG_PCI=3Dy
CONFIG_HOTPLUG_PCI_FAKE=3Dm
CONFIG_HOTPLUG_PCI_ACPI=3Dm
CONFIG_HOTPLUG_PCI_ACPI_IBM=3Dm
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=3Dm

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dm
CONFIG_IA32_EMULATION=3Dy
CONFIG_IA32_AOUT=3Dm
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=3Dy
CONFIG_PACKET=3Dy
CONFIG_PACKET_MMAP=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dy
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=3Dm
CONFIG_NET_KEY=3Dm
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
CONFIG_IP_ROUTE_VERBOSE=3Dy
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE=3Dm
CONFIG_NET_IPGRE_BROADCAST=3Dy
CONFIG_IP_MROUTE=3Dy
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
CONFIG_INET_AH=3Dm
CONFIG_INET_ESP=3Dm
CONFIG_INET_IPCOMP=3Dm
CONFIG_INET_XFRM_TUNNEL=3Dm
CONFIG_INET_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_BEET=3Dm
CONFIG_INET_LRO=3Dm
CONFIG_INET_DIAG=3Dm
CONFIG_INET_TCP_DIAG=3Dm
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=3Dm
CONFIG_IPV6_PRIVACY=3Dy
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=3Dm
CONFIG_INET6_ESP=3Dm
CONFIG_INET6_IPCOMP=3Dm
CONFIG_IPV6_MIP6=3Dm
CONFIG_INET6_XFRM_TUNNEL=3Dm
CONFIG_INET6_TUNNEL=3Dm
CONFIG_INET6_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET6_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET6_XFRM_MODE_BEET=3Dm
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=3Dm
CONFIG_IPV6_SIT=3Dm
CONFIG_IPV6_NDISC_NODETYPE=3Dy
CONFIG_IPV6_TUNNEL=3Dm
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dm
CONFIG_NETFILTER_NETLINK_QUEUE=3Dm
CONFIG_NETFILTER_NETLINK_LOG=3Dm
CONFIG_NF_CONNTRACK=3Dm
CONFIG_NF_CT_ACCT=3Dy
CONFIG_NF_CONNTRACK_MARK=3Dy
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_DCCP=3Dm
CONFIG_NF_CT_PROTO_GRE=3Dm
CONFIG_NF_CT_PROTO_SCTP=3Dm
CONFIG_NF_CT_PROTO_UDPLITE=3Dm
CONFIG_NF_CONNTRACK_AMANDA=3Dm
CONFIG_NF_CONNTRACK_FTP=3Dm
CONFIG_NF_CONNTRACK_H323=3Dm
CONFIG_NF_CONNTRACK_IRC=3Dm
CONFIG_NF_CONNTRACK_NETBIOS_NS=3Dm
CONFIG_NF_CONNTRACK_PPTP=3Dm
CONFIG_NF_CONNTRACK_SANE=3Dm
CONFIG_NF_CONNTRACK_SIP=3Dm
CONFIG_NF_CONNTRACK_TFTP=3Dm
CONFIG_NF_CT_NETLINK=3Dm
CONFIG_NETFILTER_TPROXY=3Dm
CONFIG_NETFILTER_XTABLES=3Dm
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dm
CONFIG_NETFILTER_XT_TARGET_MARK=3Dm
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dm
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dm
CONFIG_NETFILTER_XT_TARGET_NOTRACK=3Dm
CONFIG_NETFILTER_XT_TARGET_RATEEST=3Dm
CONFIG_NETFILTER_XT_TARGET_TPROXY=3Dm
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPMSS=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=3Dm
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNMARK=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=3Dm
CONFIG_NETFILTER_XT_MATCH_DCCP=3Dm
CONFIG_NETFILTER_XT_MATCH_DSCP=3Dm
CONFIG_NETFILTER_XT_MATCH_ESP=3Dm
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_HELPER=3Dm
CONFIG_NETFILTER_XT_MATCH_IPRANGE=3Dm
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_MAC=3Dm
CONFIG_NETFILTER_XT_MATCH_MARK=3Dm
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=3Dm
CONFIG_NETFILTER_XT_MATCH_OWNER=3Dm
CONFIG_NETFILTER_XT_MATCH_POLICY=3Dm
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dm
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dm
CONFIG_NETFILTER_XT_MATCH_QUOTA=3Dm
CONFIG_NETFILTER_XT_MATCH_RATEEST=3Dm
CONFIG_NETFILTER_XT_MATCH_REALM=3Dm
CONFIG_NETFILTER_XT_MATCH_RECENT=3Dm
CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT=3Dy
CONFIG_NETFILTER_XT_MATCH_SCTP=3Dm
CONFIG_NETFILTER_XT_MATCH_SOCKET=3Dm
CONFIG_NETFILTER_XT_MATCH_STATE=3Dm
CONFIG_NETFILTER_XT_MATCH_STATISTIC=3Dm
CONFIG_NETFILTER_XT_MATCH_STRING=3Dm
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dm
CONFIG_NETFILTER_XT_MATCH_TIME=3Dm
CONFIG_NETFILTER_XT_MATCH_U32=3Dm
CONFIG_IP_VS=3Dm
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=3D12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=3Dy
CONFIG_IP_VS_PROTO_UDP=3Dy
CONFIG_IP_VS_PROTO_AH_ESP=3Dy
CONFIG_IP_VS_PROTO_ESP=3Dy
CONFIG_IP_VS_PROTO_AH=3Dy

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=3Dm
CONFIG_IP_VS_WRR=3Dm
CONFIG_IP_VS_LC=3Dm
CONFIG_IP_VS_WLC=3Dm
CONFIG_IP_VS_LBLC=3Dm
CONFIG_IP_VS_LBLCR=3Dm
CONFIG_IP_VS_DH=3Dm
CONFIG_IP_VS_SH=3Dm
CONFIG_IP_VS_SED=3Dm
CONFIG_IP_VS_NQ=3Dm

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=3Dm

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=3Dm
CONFIG_NF_CONNTRACK_IPV4=3Dm
CONFIG_NF_CONNTRACK_PROC_COMPAT=3Dy
CONFIG_IP_NF_QUEUE=3Dm
CONFIG_IP_NF_IPTABLES=3Dm
CONFIG_IP_NF_MATCH_ADDRTYPE=3Dm
CONFIG_IP_NF_MATCH_AH=3Dm
CONFIG_IP_NF_MATCH_ECN=3Dm
CONFIG_IP_NF_MATCH_TTL=3Dm
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_TARGET_REJECT=3Dm
CONFIG_IP_NF_TARGET_LOG=3Dm
CONFIG_IP_NF_TARGET_ULOG=3Dm
CONFIG_NF_NAT=3Dm
CONFIG_NF_NAT_NEEDED=3Dy
CONFIG_IP_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP_NF_TARGET_NETMAP=3Dm
CONFIG_IP_NF_TARGET_REDIRECT=3Dm
CONFIG_NF_NAT_SNMP_BASIC=3Dm
CONFIG_NF_NAT_PROTO_DCCP=3Dm
CONFIG_NF_NAT_PROTO_GRE=3Dm
CONFIG_NF_NAT_PROTO_UDPLITE=3Dm
CONFIG_NF_NAT_PROTO_SCTP=3Dm
CONFIG_NF_NAT_FTP=3Dm
CONFIG_NF_NAT_IRC=3Dm
CONFIG_NF_NAT_TFTP=3Dm
CONFIG_NF_NAT_AMANDA=3Dm
CONFIG_NF_NAT_PPTP=3Dm
CONFIG_NF_NAT_H323=3Dm
CONFIG_NF_NAT_SIP=3Dm
CONFIG_IP_NF_MANGLE=3Dm
CONFIG_IP_NF_TARGET_CLUSTERIP=3Dm
CONFIG_IP_NF_TARGET_ECN=3Dm
CONFIG_IP_NF_TARGET_TTL=3Dm
CONFIG_IP_NF_RAW=3Dm
CONFIG_IP_NF_SECURITY=3Dm
CONFIG_IP_NF_ARPTABLES=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP_NF_ARP_MANGLE=3Dm

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=3Dm
CONFIG_IP6_NF_QUEUE=3Dm
CONFIG_IP6_NF_IPTABLES=3Dm
CONFIG_IP6_NF_MATCH_AH=3Dm
CONFIG_IP6_NF_MATCH_EUI64=3Dm
CONFIG_IP6_NF_MATCH_FRAG=3Dm
CONFIG_IP6_NF_MATCH_OPTS=3Dm
CONFIG_IP6_NF_MATCH_HL=3Dm
CONFIG_IP6_NF_MATCH_IPV6HEADER=3Dm
CONFIG_IP6_NF_MATCH_MH=3Dm
CONFIG_IP6_NF_MATCH_RT=3Dm
CONFIG_IP6_NF_TARGET_LOG=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_IP6_NF_TARGET_REJECT=3Dm
CONFIG_IP6_NF_MANGLE=3Dm
CONFIG_IP6_NF_TARGET_HL=3Dm
CONFIG_IP6_NF_RAW=3Dm
CONFIG_IP6_NF_SECURITY=3Dm

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
CONFIG_BRIDGE_NF_EBTABLES=3Dm
CONFIG_BRIDGE_EBT_BROUTE=3Dm
CONFIG_BRIDGE_EBT_T_FILTER=3Dm
CONFIG_BRIDGE_EBT_T_NAT=3Dm
CONFIG_BRIDGE_EBT_802_3=3Dm
CONFIG_BRIDGE_EBT_AMONG=3Dm
CONFIG_BRIDGE_EBT_ARP=3Dm
CONFIG_BRIDGE_EBT_IP=3Dm
CONFIG_BRIDGE_EBT_IP6=3Dm
CONFIG_BRIDGE_EBT_LIMIT=3Dm
CONFIG_BRIDGE_EBT_MARK=3Dm
CONFIG_BRIDGE_EBT_PKTTYPE=3Dm
CONFIG_BRIDGE_EBT_STP=3Dm
CONFIG_BRIDGE_EBT_VLAN=3Dm
CONFIG_BRIDGE_EBT_ARPREPLY=3Dm
CONFIG_BRIDGE_EBT_DNAT=3Dm
CONFIG_BRIDGE_EBT_MARK_T=3Dm
CONFIG_BRIDGE_EBT_REDIRECT=3Dm
CONFIG_BRIDGE_EBT_SNAT=3Dm
CONFIG_BRIDGE_EBT_LOG=3Dm
CONFIG_BRIDGE_EBT_ULOG=3Dm
CONFIG_BRIDGE_EBT_NFLOG=3Dm
CONFIG_IP_DCCP=3Dm
CONFIG_INET_DCCP_DIAG=3Dm

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set
CONFIG_IP_SCTP=3Dm
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=3Dy
CONFIG_TIPC=3Dm
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=3Dm
CONFIG_ATM_CLIP=3Dm
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=3Dm
CONFIG_ATM_MPOA=3Dm
CONFIG_ATM_BR2684=3Dm
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=3Dm
CONFIG_GARP=3Dm
CONFIG_BRIDGE=3Dm
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=3Dm
CONFIG_VLAN_8021Q_GVRP=3Dy
CONFIG_DECNET=3Dm
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=3Dy
CONFIG_LLC2=3Dm
CONFIG_IPX=3Dm
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=3Dm
CONFIG_DEV_APPLETALK=3Dm
CONFIG_IPDDP=3Dm
CONFIG_IPDDP_ENCAP=3Dy
CONFIG_IPDDP_DECAP=3Dy
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=3Dm
CONFIG_NET_SCHED=3Dy

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=3Dm
CONFIG_NET_SCH_HTB=3Dm
CONFIG_NET_SCH_HFSC=3Dm
CONFIG_NET_SCH_ATM=3Dm
CONFIG_NET_SCH_PRIO=3Dm
CONFIG_NET_SCH_MULTIQ=3Dm
CONFIG_NET_SCH_RED=3Dm
CONFIG_NET_SCH_SFQ=3Dm
CONFIG_NET_SCH_TEQL=3Dm
CONFIG_NET_SCH_TBF=3Dm
CONFIG_NET_SCH_GRED=3Dm
CONFIG_NET_SCH_DSMARK=3Dm
CONFIG_NET_SCH_NETEM=3Dm
CONFIG_NET_SCH_DRR=3Dm
CONFIG_NET_SCH_INGRESS=3Dm

#
# Classification
#
CONFIG_NET_CLS=3Dy
CONFIG_NET_CLS_BASIC=3Dm
CONFIG_NET_CLS_TCINDEX=3Dm
CONFIG_NET_CLS_ROUTE4=3Dm
CONFIG_NET_CLS_ROUTE=3Dy
CONFIG_NET_CLS_FW=3Dm
CONFIG_NET_CLS_U32=3Dm
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=3Dy
CONFIG_NET_CLS_RSVP=3Dm
CONFIG_NET_CLS_RSVP6=3Dm
CONFIG_NET_CLS_FLOW=3Dm
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=3Dy
CONFIG_NET_ACT_POLICE=3Dy
CONFIG_NET_ACT_GACT=3Dm
CONFIG_GACT_PROB=3Dy
CONFIG_NET_ACT_MIRRED=3Dm
CONFIG_NET_ACT_IPT=3Dm
CONFIG_NET_ACT_NAT=3Dm
CONFIG_NET_ACT_PEDIT=3Dm
CONFIG_NET_ACT_SIMP=3Dm
CONFIG_NET_ACT_SKBEDIT=3Dm
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=3Dy
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=3Dy

#
# Packet Radio protocols
#
CONFIG_AX25=3Dm
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=3Dm
CONFIG_ROSE=3Dm

#
# AX.25 network device drivers
#
CONFIG_MKISS=3Dm
CONFIG_6PACK=3Dm
CONFIG_BPQETHER=3Dm
CONFIG_BAYCOM_SER_FDX=3Dm
CONFIG_BAYCOM_SER_HDX=3Dm
CONFIG_BAYCOM_PAR=3Dm
CONFIG_YAM=3Dm
CONFIG_CAN=3Dm
CONFIG_CAN_RAW=3Dm
CONFIG_CAN_BCM=3Dm

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=3Dm
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=3Dm

#
# IrDA protocols
#
CONFIG_IRLAN=3Dm
CONFIG_IRNET=3Dm
CONFIG_IRCOMM=3Dm
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
CONFIG_IRDA_FAST_RR=3Dy
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=3Dm

#
# Dongle support
#
CONFIG_DONGLE=3Dy
CONFIG_ESI_DONGLE=3Dm
CONFIG_ACTISYS_DONGLE=3Dm
CONFIG_TEKRAM_DONGLE=3Dm
CONFIG_TOIM3232_DONGLE=3Dm
CONFIG_LITELINK_DONGLE=3Dm
CONFIG_MA600_DONGLE=3Dm
CONFIG_GIRBIL_DONGLE=3Dm
CONFIG_MCP2120_DONGLE=3Dm
CONFIG_OLD_BELKIN_DONGLE=3Dm
CONFIG_ACT200L_DONGLE=3Dm
CONFIG_KINGSUN_DONGLE=3Dm
CONFIG_KSDAZZLE_DONGLE=3Dm
CONFIG_KS959_DONGLE=3Dm

#
# FIR device drivers
#
CONFIG_USB_IRDA=3Dm
CONFIG_SIGMATEL_FIR=3Dm
CONFIG_NSC_FIR=3Dm
CONFIG_WINBOND_FIR=3Dm
CONFIG_SMC_IRCC_FIR=3Dm
CONFIG_ALI_FIR=3Dm
CONFIG_VLSI_FIR=3Dm
CONFIG_VIA_FIR=3Dm
CONFIG_MCS_FIR=3Dm
CONFIG_BT=3Dm
CONFIG_BT_L2CAP=3Dm
CONFIG_BT_SCO=3Dm
CONFIG_BT_RFCOMM=3Dm
CONFIG_BT_RFCOMM_TTY=3Dy
CONFIG_BT_BNEP=3Dm
CONFIG_BT_BNEP_MC_FILTER=3Dy
CONFIG_BT_BNEP_PROTO_FILTER=3Dy
CONFIG_BT_CMTP=3Dm
CONFIG_BT_HIDP=3Dm

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=3Dm
CONFIG_BT_HCIBTSDIO=3Dm
CONFIG_BT_HCIUART=3Dm
CONFIG_BT_HCIUART_H4=3Dy
CONFIG_BT_HCIUART_BCSP=3Dy
CONFIG_BT_HCIUART_LL=3Dy
CONFIG_BT_HCIBCM203X=3Dm
CONFIG_BT_HCIBPA10X=3Dm
CONFIG_BT_HCIBFUSB=3Dm
CONFIG_BT_HCIDTL1=3Dm
CONFIG_BT_HCIBT3C=3Dm
CONFIG_BT_HCIBLUECARD=3Dm
CONFIG_BT_HCIBTUART=3Dm
CONFIG_BT_HCIVHCI=3Dm
CONFIG_AF_RXRPC=3Dm
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=3Dm
CONFIG_PHONET=3Dm
CONFIG_FIB_RULES=3Dy
CONFIG_WIRELESS=3Dy
CONFIG_CFG80211=3Dm
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_NL80211=3Dy
CONFIG_WIRELESS_OLD_REGULATORY=3Dy
CONFIG_WIRELESS_EXT=3Dy
CONFIG_WIRELESS_EXT_SYSFS=3Dy
CONFIG_LIB80211=3Dm
CONFIG_LIB80211_CRYPT_WEP=3Dm
CONFIG_LIB80211_CRYPT_CCMP=3Dm
CONFIG_LIB80211_CRYPT_TKIP=3Dm
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=3Dm

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=3Dy
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
CONFIG_MAC80211_RC_DEFAULT=3D"minstrel"
CONFIG_MAC80211_MESH=3Dy
CONFIG_MAC80211_LEDS=3Dy
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=3Dm
CONFIG_WIMAX_DEBUG_LEVEL=3D8
CONFIG_RFKILL=3Dm
CONFIG_RFKILL_INPUT=3Dm
CONFIG_RFKILL_LEDS=3Dy
CONFIG_NET_9P=3Dm
CONFIG_NET_9P_VIRTIO=3Dm
CONFIG_NET_9P_RDMA=3Dm
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=3D""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dm
CONFIG_MTD=3Dm
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=3Dm
CONFIG_MTD_PARTITIONS=3Dy
CONFIG_MTD_TESTS=3Dm
CONFIG_MTD_REDBOOT_PARTS=3Dm
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=3D-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_AR7_PARTS=3Dm

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=3Dm
CONFIG_HAVE_MTD_OTP=3Dy
CONFIG_MTD_BLKDEVS=3Dm
CONFIG_MTD_BLOCK=3Dm
CONFIG_MTD_BLOCK_RO=3Dm
CONFIG_FTL=3Dm
CONFIG_NFTL=3Dm
CONFIG_NFTL_RW=3Dy
CONFIG_INFTL=3Dm
CONFIG_RFD_FTL=3Dm
CONFIG_SSFDC=3Dm
CONFIG_MTD_OOPS=3Dm

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=3Dm
CONFIG_MTD_JEDECPROBE=3Dm
CONFIG_MTD_GEN_PROBE=3Dm
CONFIG_MTD_CFI_ADV_OPTIONS=3Dy
CONFIG_MTD_CFI_NOSWAP=3Dy
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_1=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_2=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_4=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_8=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_16=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_32=3Dy
CONFIG_MTD_CFI_I1=3Dy
CONFIG_MTD_CFI_I2=3Dy
CONFIG_MTD_CFI_I4=3Dy
CONFIG_MTD_CFI_I8=3Dy
CONFIG_MTD_OTP=3Dy
CONFIG_MTD_CFI_INTELEXT=3Dm
CONFIG_MTD_CFI_AMDSTD=3Dm
CONFIG_MTD_CFI_STAA=3Dm
CONFIG_MTD_CFI_UTIL=3Dm
CONFIG_MTD_RAM=3Dm
CONFIG_MTD_ROM=3Dm
CONFIG_MTD_ABSENT=3Dm

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=3Dy
CONFIG_MTD_PHYSMAP=3Dm
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=3Dm
CONFIG_MTD_NETSC520=3Dm
CONFIG_MTD_TS5500=3Dm
CONFIG_MTD_SBC_GXX=3Dm
CONFIG_MTD_AMD76XROM=3Dm
CONFIG_MTD_ICHXROM=3Dm
CONFIG_MTD_ESB2ROM=3Dm
CONFIG_MTD_CK804XROM=3Dm
CONFIG_MTD_SCB2_FLASH=3Dm
CONFIG_MTD_NETtel=3Dm
CONFIG_MTD_DILNETPC=3Dm
CONFIG_MTD_DILNETPC_BOOTSIZE=3D0x80000
CONFIG_MTD_L440GX=3Dm
CONFIG_MTD_PCI=3Dm
CONFIG_MTD_INTEL_VR_NOR=3Dm
CONFIG_MTD_PLATRAM=3Dm

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=3Dm
CONFIG_MTD_PMC551_BUGFIX=3Dy
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=3Dm
CONFIG_MTD_PHRAM=3Dm
CONFIG_MTD_MTDRAM=3Dm
CONFIG_MTDRAM_TOTAL_SIZE=3D4096
CONFIG_MTDRAM_ERASE_SIZE=3D128
CONFIG_MTD_BLOCK2MTD=3Dm

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
CONFIG_MTD_DOC2001PLUS=3Dm
CONFIG_MTD_DOCPROBE=3Dm
CONFIG_MTD_DOCECC=3Dm
CONFIG_MTD_DOCPROBE_ADVANCED=3Dy
CONFIG_MTD_DOCPROBE_ADDRESS=3D0x0000
CONFIG_MTD_DOCPROBE_HIGH=3Dy
CONFIG_MTD_DOCPROBE_55AA=3Dy
CONFIG_MTD_NAND=3Dm
CONFIG_MTD_NAND_VERIFY_WRITE=3Dy
CONFIG_MTD_NAND_ECC_SMC=3Dy
CONFIG_MTD_NAND_MUSEUM_IDS=3Dy
CONFIG_MTD_NAND_IDS=3Dm
CONFIG_MTD_NAND_DISKONCHIP=3Dm
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=3Dy
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=3D0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=3Dy
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=3Dy
CONFIG_MTD_NAND_CAFE=3Dm
CONFIG_MTD_NAND_NANDSIM=3Dm
CONFIG_MTD_NAND_PLATFORM=3Dm
CONFIG_MTD_ALAUDA=3Dm
CONFIG_MTD_ONENAND=3Dm
CONFIG_MTD_ONENAND_VERIFY_WRITE=3Dy
CONFIG_MTD_ONENAND_OTP=3Dy
CONFIG_MTD_ONENAND_2X_PROGRAM=3Dy
CONFIG_MTD_ONENAND_SIM=3Dm

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=3Dm
CONFIG_MTD_QINFO_PROBE=3Dm

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=3Dm
CONFIG_MTD_UBI_WL_THRESHOLD=3D4096
CONFIG_MTD_UBI_BEB_RESERVE=3D1
CONFIG_MTD_UBI_GLUEBI=3Dy

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=3Dm
CONFIG_PARPORT_PC=3Dm
CONFIG_PARPORT_SERIAL=3Dm
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=3Dm
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=3Dm
CONFIG_PARPORT_1284=3Dy
CONFIG_PARPORT_NOT_PC=3Dy
CONFIG_PNP=3Dy
CONFIG_PNP_DEBUG_MESSAGES=3Dy

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
CONFIG_BLK_DEV_FD=3Dy
CONFIG_PARIDE=3Dm

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=3Dm
CONFIG_PARIDE_PCD=3Dm
CONFIG_PARIDE_PF=3Dm
CONFIG_PARIDE_PT=3Dm
CONFIG_PARIDE_PG=3Dm

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=3Dm
CONFIG_PARIDE_BPCK=3Dm
CONFIG_PARIDE_COMM=3Dm
CONFIG_PARIDE_DSTR=3Dm
CONFIG_PARIDE_FIT2=3Dm
CONFIG_PARIDE_FIT3=3Dm
CONFIG_PARIDE_EPAT=3Dm
CONFIG_PARIDE_EPATC8=3Dy
CONFIG_PARIDE_EPIA=3Dm
CONFIG_PARIDE_FRIQ=3Dm
CONFIG_PARIDE_FRPW=3Dm
CONFIG_PARIDE_KBIC=3Dm
CONFIG_PARIDE_KTTI=3Dm
CONFIG_PARIDE_ON20=3Dm
CONFIG_PARIDE_ON26=3Dm
CONFIG_BLK_CPQ_DA=3Dy
CONFIG_BLK_CPQ_CISS_DA=3Dy
CONFIG_CISS_SCSI_TAPE=3Dy
CONFIG_BLK_DEV_DAC960=3Dy
CONFIG_BLK_DEV_UMEM=3Dm
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dy
CONFIG_BLK_DEV_CRYPTOLOOP=3Dm
CONFIG_BLK_DEV_NBD=3Dm
CONFIG_BLK_DEV_SX8=3Dy
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=3Dm
CONFIG_VIRTIO_BLK=3Dm
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=3Dy
CONFIG_IBM_ASM=3Dm
CONFIG_PHANTOM=3Dm
CONFIG_SGI_IOC4=3Dm
CONFIG_TIFM_CORE=3Dm
CONFIG_TIFM_7XX1=3Dm
CONFIG_ICS932S401=3Dm
CONFIG_ENCLOSURE_SERVICES=3Dm
CONFIG_SGI_XP=3Dm
CONFIG_HP_ILO=3Dm
CONFIG_SGI_GRU=3Dm
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_DELL_LAPTOP=3Dm
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=3Dm
CONFIG_EEPROM_LEGACY=3Dm
CONFIG_EEPROM_93CX6=3Dm
CONFIG_HAVE_IDE=3Dy
CONFIG_IDE=3Dy

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=3Dy
CONFIG_IDE_ATAPI=3Dy
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=3Dy
CONFIG_IDE_GD_ATA=3Dy
CONFIG_IDE_GD_ATAPI=3Dy
CONFIG_BLK_DEV_IDECS=3Dm
CONFIG_BLK_DEV_DELKIN=3Dm
CONFIG_BLK_DEV_IDECD=3Dy
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=3Dy
CONFIG_BLK_DEV_IDETAPE=3Dm
CONFIG_BLK_DEV_IDEACPI=3Dy
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=3Dy

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dm
CONFIG_BLK_DEV_PLATFORM=3Dm
CONFIG_BLK_DEV_CMD640=3Dy
CONFIG_BLK_DEV_CMD640_ENHANCED=3Dy
CONFIG_BLK_DEV_IDEPNP=3Dy
CONFIG_BLK_DEV_IDEDMA_SFF=3Dy

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=3Dy
CONFIG_IDEPCI_PCIBUS_ORDER=3Dy
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=3Dy
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=3Dy
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
CONFIG_BLK_DEV_AEC62XX=3Dy
CONFIG_BLK_DEV_ALI15X3=3Dy
CONFIG_BLK_DEV_AMD74XX=3Dy
CONFIG_BLK_DEV_ATIIXP=3Dy
CONFIG_BLK_DEV_CMD64X=3Dy
CONFIG_BLK_DEV_TRIFLEX=3Dy
CONFIG_BLK_DEV_CS5520=3Dy
CONFIG_BLK_DEV_CS5530=3Dy
CONFIG_BLK_DEV_HPT366=3Dy
CONFIG_BLK_DEV_JMICRON=3Dy
CONFIG_BLK_DEV_SC1200=3Dy
CONFIG_BLK_DEV_PIIX=3Dy
CONFIG_BLK_DEV_IT8172=3Dy
CONFIG_BLK_DEV_IT8213=3Dy
CONFIG_BLK_DEV_IT821X=3Dy
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=3Dy
CONFIG_BLK_DEV_PDC202XX_NEW=3Dy
CONFIG_BLK_DEV_SVWKS=3Dy
CONFIG_BLK_DEV_SIIMAGE=3Dy
CONFIG_BLK_DEV_SIS5513=3Dy
CONFIG_BLK_DEV_SLC90E66=3Dy
CONFIG_BLK_DEV_TRM290=3Dy
CONFIG_BLK_DEV_VIA82CXXX=3Dy
CONFIG_BLK_DEV_TC86C001=3Dy
CONFIG_BLK_DEV_IDEDMA=3Dy

#
# SCSI device support
#
CONFIG_RAID_ATTRS=3Dy
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dy
CONFIG_SCSI_NETLINK=3Dy
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
CONFIG_CHR_DEV_ST=3Dy
CONFIG_CHR_DEV_OSST=3Dm
CONFIG_BLK_DEV_SR=3Dy
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dm
CONFIG_CHR_DEV_SCH=3Dm
CONFIG_SCSI_ENCLOSURE=3Dm

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dy
CONFIG_SCSI_FC_ATTRS=3Dy
CONFIG_SCSI_FC_TGT_ATTRS=3Dy
CONFIG_SCSI_ISCSI_ATTRS=3Dy
CONFIG_SCSI_SAS_ATTRS=3Dy
CONFIG_SCSI_SAS_LIBSAS=3Dy
CONFIG_SCSI_SAS_ATA=3Dy
CONFIG_SCSI_SAS_HOST_SMP=3Dy
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=3Dy
CONFIG_SCSI_SRP_TGT_ATTRS=3Dy
CONFIG_SCSI_LOWLEVEL=3Dy
CONFIG_ISCSI_TCP=3Dm
CONFIG_SCSI_CXGB3_ISCSI=3Dm
CONFIG_BLK_DEV_3W_XXXX_RAID=3Dy
CONFIG_SCSI_3W_9XXX=3Dy
CONFIG_SCSI_ACARD=3Dy
CONFIG_SCSI_AACRAID=3Dy
CONFIG_SCSI_AIC7XXX=3Dy
CONFIG_AIC7XXX_CMDS_PER_DEVICE=3D4
CONFIG_AIC7XXX_RESET_DELAY_MS=3D15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=3D0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=3Dy
CONFIG_SCSI_AIC79XX=3Dy
CONFIG_AIC79XX_CMDS_PER_DEVICE=3D4
CONFIG_AIC79XX_RESET_DELAY_MS=3D15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=3D0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=3Dm
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_DPT_I2O=3Dm
CONFIG_SCSI_ADVANSYS=3Dy
CONFIG_SCSI_ARCMSR=3Dy
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=3Dy
CONFIG_MEGARAID_MM=3Dy
CONFIG_MEGARAID_MAILBOX=3Dy
CONFIG_MEGARAID_LEGACY=3Dy
CONFIG_MEGARAID_SAS=3Dy
CONFIG_SCSI_HPTIOP=3Dy
CONFIG_SCSI_BUSLOGIC=3Dy
CONFIG_LIBFC=3Dy
CONFIG_FCOE=3Dy
CONFIG_SCSI_DMX3191D=3Dy
CONFIG_SCSI_EATA=3Dy
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=3D16
CONFIG_SCSI_FUTURE_DOMAIN=3Dy
CONFIG_SCSI_GDTH=3Dy
CONFIG_SCSI_IPS=3Dy
CONFIG_SCSI_INITIO=3Dy
CONFIG_SCSI_INIA100=3Dy
CONFIG_SCSI_PPA=3Dm
CONFIG_SCSI_IMM=3Dm
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_MVSAS=3Dy
CONFIG_SCSI_STEX=3Dy
CONFIG_SCSI_SYM53C8XX_2=3Dy
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=3D1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=3D16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=3D64
CONFIG_SCSI_SYM53C8XX_MMIO=3Dy
CONFIG_SCSI_IPR=3Dy
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=3Dy
CONFIG_SCSI_QLA_FC=3Dy
CONFIG_SCSI_QLA_ISCSI=3Dy
CONFIG_SCSI_LPFC=3Dy
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_DC395x=3Dy
CONFIG_SCSI_DC390T=3Dy
CONFIG_SCSI_DEBUG=3Dm
CONFIG_SCSI_SRP=3Dy
CONFIG_SCSI_LOWLEVEL_PCMCIA=3Dy
CONFIG_PCMCIA_FDOMAIN=3Dm
CONFIG_PCMCIA_QLOGIC=3Dm
CONFIG_PCMCIA_SYM53C500=3Dm
CONFIG_SCSI_DH=3Dy
CONFIG_SCSI_DH_RDAC=3Dy
CONFIG_SCSI_DH_HP_SW=3Dy
CONFIG_SCSI_DH_EMC=3Dy
CONFIG_SCSI_DH_ALUA=3Dy
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_PMP=3Dy
CONFIG_SATA_AHCI=3Dy
CONFIG_SATA_SIL24=3Dy
CONFIG_ATA_SFF=3Dy
CONFIG_SATA_SVW=3Dy
CONFIG_ATA_PIIX=3Dy
CONFIG_SATA_MV=3Dy
CONFIG_SATA_NV=3Dy
CONFIG_PDC_ADMA=3Dy
CONFIG_SATA_QSTOR=3Dy
CONFIG_SATA_PROMISE=3Dy
CONFIG_SATA_SX4=3Dy
CONFIG_SATA_SIL=3Dy
CONFIG_SATA_SIS=3Dy
CONFIG_SATA_ULI=3Dy
CONFIG_SATA_VIA=3Dy
CONFIG_SATA_VITESSE=3Dy
CONFIG_SATA_INIC162X=3Dy
CONFIG_PATA_ACPI=3Dy
CONFIG_PATA_ALI=3Dm
CONFIG_PATA_AMD=3Dm
CONFIG_PATA_ARTOP=3Dm
CONFIG_PATA_ATIIXP=3Dm
CONFIG_PATA_CMD640_PCI=3Dm
CONFIG_PATA_CMD64X=3Dm
CONFIG_PATA_CS5520=3Dm
CONFIG_PATA_CS5530=3Dm
CONFIG_PATA_CYPRESS=3Dm
CONFIG_PATA_EFAR=3Dm
CONFIG_ATA_GENERIC=3Dy
CONFIG_PATA_HPT366=3Dm
CONFIG_PATA_HPT37X=3Dm
CONFIG_PATA_HPT3X2N=3Dm
CONFIG_PATA_HPT3X3=3Dm
CONFIG_PATA_HPT3X3_DMA=3Dy
CONFIG_PATA_IT821X=3Dm
CONFIG_PATA_IT8213=3Dm
CONFIG_PATA_JMICRON=3Dm
CONFIG_PATA_TRIFLEX=3Dm
CONFIG_PATA_MARVELL=3Dy
CONFIG_PATA_MPIIX=3Dm
CONFIG_PATA_OLDPIIX=3Dm
CONFIG_PATA_NETCELL=3Dm
CONFIG_PATA_NINJA32=3Dm
CONFIG_PATA_NS87410=3Dm
CONFIG_PATA_NS87415=3Dm
CONFIG_PATA_OPTI=3Dm
CONFIG_PATA_OPTIDMA=3Dm
CONFIG_PATA_PCMCIA=3Dm
CONFIG_PATA_PDC_OLD=3Dm
CONFIG_PATA_RADISYS=3Dm
CONFIG_PATA_RZ1000=3Dm
CONFIG_PATA_SC1200=3Dm
CONFIG_PATA_SERVERWORKS=3Dm
CONFIG_PATA_PDC2027X=3Dm
CONFIG_PATA_SIL680=3Dm
CONFIG_PATA_SIS=3Dy
CONFIG_PATA_VIA=3Dm
CONFIG_PATA_WINBOND=3Dm
CONFIG_PATA_SCH=3Dm
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_AUTODETECT=3Dy
CONFIG_MD_LINEAR=3Dy
CONFIG_MD_RAID0=3Dy
CONFIG_MD_RAID1=3Dy
CONFIG_MD_RAID10=3Dy
CONFIG_MD_RAID456=3Dy
CONFIG_MD_RAID5_RESHAPE=3Dy
CONFIG_MD_MULTIPATH=3Dy
CONFIG_MD_FAULTY=3Dm
CONFIG_BLK_DEV_DM=3Dy
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=3Dy
CONFIG_DM_SNAPSHOT=3Dy
CONFIG_DM_MIRROR=3Dy
CONFIG_DM_ZERO=3Dm
CONFIG_DM_MULTIPATH=3Dm
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=3Dy
CONFIG_FUSION_SPI=3Dy
CONFIG_FUSION_FC=3Dy
CONFIG_FUSION_SAS=3Dy
CONFIG_FUSION_MAX_SGE=3D128
CONFIG_FUSION_CTL=3Dm
CONFIG_FUSION_LAN=3Dm
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=3Dy
CONFIG_IEEE1394_OHCI1394=3Dy
CONFIG_IEEE1394_PCILYNX=3Dy
CONFIG_IEEE1394_SBP2=3Dy
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=3Dy
CONFIG_IEEE1394_ETH1394=3Dm
CONFIG_IEEE1394_RAWIO=3Dm
CONFIG_IEEE1394_VIDEO1394=3Dm
CONFIG_IEEE1394_DV1394=3Dm
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=3Dy
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=3Dy
CONFIG_I2O_EXT_ADAPTEC=3Dy
CONFIG_I2O_EXT_ADAPTEC_DMA64=3Dy
CONFIG_I2O_CONFIG=3Dy
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=3Dy
CONFIG_I2O_BLOCK=3Dy
CONFIG_I2O_SCSI=3Dy
CONFIG_I2O_PROC=3Dy
CONFIG_MACINTOSH_DRIVERS=3Dy
CONFIG_MAC_EMUMOUSEBTN=3Dy
CONFIG_NETDEVICES=3Dy
CONFIG_IFB=3Dm
CONFIG_DUMMY=3Dm
CONFIG_BONDING=3Dm
CONFIG_MACVLAN=3Dm
CONFIG_EQUALIZER=3Dm
CONFIG_TUN=3Dm
CONFIG_VETH=3Dm
CONFIG_NET_SB1000=3Dm
CONFIG_ARCNET=3Dm
CONFIG_ARCNET_1201=3Dm
CONFIG_ARCNET_1051=3Dm
CONFIG_ARCNET_RAW=3Dm
CONFIG_ARCNET_CAP=3Dm
CONFIG_ARCNET_COM90xx=3Dm
CONFIG_ARCNET_COM90xxIO=3Dm
CONFIG_ARCNET_RIM_I=3Dm
CONFIG_ARCNET_COM20020=3Dm
CONFIG_ARCNET_COM20020_PCI=3Dm
CONFIG_PHYLIB=3Dm

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=3Dm
CONFIG_DAVICOM_PHY=3Dm
CONFIG_QSEMI_PHY=3Dm
CONFIG_LXT_PHY=3Dm
CONFIG_CICADA_PHY=3Dm
CONFIG_VITESSE_PHY=3Dm
CONFIG_SMSC_PHY=3Dm
CONFIG_BROADCOM_PHY=3Dm
CONFIG_ICPLUS_PHY=3Dm
CONFIG_REALTEK_PHY=3Dm
CONFIG_NATIONAL_PHY=3Dm
CONFIG_STE10XP=3Dm
CONFIG_LSI_ET1011C_PHY=3Dm
CONFIG_MDIO_BITBANG=3Dm
CONFIG_MDIO_GPIO=3Dm
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dm
CONFIG_HAPPYMEAL=3Dm
CONFIG_SUNGEM=3Dm
CONFIG_CASSINI=3Dm
CONFIG_NET_VENDOR_3COM=3Dy
CONFIG_VORTEX=3Dm
CONFIG_TYPHOON=3Dm
CONFIG_DNET=3Dm
CONFIG_NET_TULIP=3Dy
CONFIG_DE2104X=3Dm
CONFIG_TULIP=3Dm
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=3Dy
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=3Dm
CONFIG_WINBOND_840=3Dm
CONFIG_DM9102=3Dm
CONFIG_ULI526X=3Dm
CONFIG_PCMCIA_XIRCOM=3Dm
CONFIG_HP100=3Dm
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=3Dy
CONFIG_PCNET32=3Dm
CONFIG_AMD8111_ETH=3Dm
CONFIG_ADAPTEC_STARFIRE=3Dm
CONFIG_B44=3Dm
CONFIG_B44_PCI_AUTOSELECT=3Dy
CONFIG_B44_PCICORE_AUTOSELECT=3Dy
CONFIG_B44_PCI=3Dy
CONFIG_FORCEDETH=3Dm
CONFIG_FORCEDETH_NAPI=3Dy
CONFIG_E100=3Dm
CONFIG_FEALNX=3Dm
CONFIG_NATSEMI=3Dm
CONFIG_NE2K_PCI=3Dm
CONFIG_8139CP=3Dm
CONFIG_8139TOO=3Dm
CONFIG_8139TOO_PIO=3Dy
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=3Dy
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=3Dm
CONFIG_SIS900=3Dm
CONFIG_EPIC100=3Dm
CONFIG_SMSC9420=3Dm
CONFIG_SUNDANCE=3Dm
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=3Dm
CONFIG_VIA_RHINE=3Dm
CONFIG_VIA_RHINE_MMIO=3Dy
CONFIG_SC92031=3Dm
CONFIG_NET_POCKET=3Dy
CONFIG_ATP=3Dm
CONFIG_DE600=3Dm
CONFIG_DE620=3Dm
CONFIG_ATL2=3Dm
CONFIG_NETDEV_1000=3Dy
CONFIG_ACENIC=3Dm
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=3Dm
CONFIG_E1000=3Dm
CONFIG_E1000E=3Dm
CONFIG_IP1000=3Dm
CONFIG_IGB=3Dm
# CONFIG_IGB_LRO is not set
CONFIG_IGB_DCA=3Dy
CONFIG_NS83820=3Dm
CONFIG_HAMACHI=3Dm
CONFIG_YELLOWFIN=3Dm
CONFIG_R8169=3Dm
CONFIG_R8169_VLAN=3Dy
CONFIG_SIS190=3Dm
CONFIG_SKGE=3Dm
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=3Dm
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=3Dm
CONFIG_TIGON3=3Dm
CONFIG_BNX2=3Dm
CONFIG_QLA3XXX=3Dm
CONFIG_ATL1=3Dm
CONFIG_ATL1E=3Dm
CONFIG_ATL1C=3Dm
CONFIG_JME=3Dm
CONFIG_NETDEV_10000=3Dy
CONFIG_CHELSIO_T1=3Dm
CONFIG_CHELSIO_T1_1G=3Dy
CONFIG_CHELSIO_T3_DEPENDS=3Dy
CONFIG_CHELSIO_T3=3Dm
CONFIG_ENIC=3Dm
CONFIG_IXGBE=3Dm
CONFIG_IXGBE_DCA=3Dy
CONFIG_IXGB=3Dm
CONFIG_S2IO=3Dm
CONFIG_MYRI10GE=3Dm
CONFIG_MYRI10GE_DCA=3Dy
CONFIG_NETXEN_NIC=3Dm
CONFIG_NIU=3Dm
CONFIG_MLX4_EN=3Dm
CONFIG_MLX4_CORE=3Dm
CONFIG_MLX4_DEBUG=3Dy
CONFIG_TEHUTI=3Dm
CONFIG_BNX2X=3Dm
CONFIG_QLGE=3Dm
CONFIG_SFC=3Dm
CONFIG_SFC_MTD=3Dy
CONFIG_BE2NET=3Dm
CONFIG_TR=3Dy
CONFIG_IBMOL=3Dm
CONFIG_3C359=3Dm
CONFIG_TMS380TR=3Dm
CONFIG_TMSPCI=3Dm
CONFIG_ABYSS=3Dm

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=3Dy
CONFIG_PCMCIA_RAYCS=3Dm
CONFIG_LIBERTAS=3Dm
CONFIG_LIBERTAS_USB=3Dm
CONFIG_LIBERTAS_CS=3Dm
CONFIG_LIBERTAS_SDIO=3Dm
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM=3Dm
CONFIG_LIBERTAS_THINFIRM_USB=3Dm
CONFIG_AIRO=3Dm
CONFIG_HERMES=3Dm
CONFIG_HERMES_CACHE_FW_ON_INIT=3Dy
CONFIG_PLX_HERMES=3Dm
CONFIG_TMD_HERMES=3Dm
CONFIG_NORTEL_HERMES=3Dm
CONFIG_PCI_HERMES=3Dm
CONFIG_PCMCIA_HERMES=3Dm
CONFIG_PCMCIA_SPECTRUM=3Dm
CONFIG_ATMEL=3Dm
CONFIG_PCI_ATMEL=3Dm
CONFIG_PCMCIA_ATMEL=3Dm
CONFIG_AIRO_CS=3Dm
CONFIG_PCMCIA_WL3501=3Dm
CONFIG_PRISM54=3Dm
CONFIG_USB_ZD1201=3Dm
CONFIG_USB_NET_RNDIS_WLAN=3Dm
CONFIG_RTL8180=3Dm
CONFIG_RTL8187=3Dm
CONFIG_ADM8211=3Dm
# CONFIG_MAC80211_HWSIM is not set
CONFIG_P54_COMMON=3Dm
CONFIG_P54_USB=3Dm
CONFIG_P54_PCI=3Dm
CONFIG_ATH5K=3Dm
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K=3Dm
# CONFIG_ATH9K_DEBUG is not set
CONFIG_IPW2100=3Dm
CONFIG_IPW2100_MONITOR=3Dy
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=3Dm
CONFIG_IPW2200_MONITOR=3Dy
CONFIG_IPW2200_RADIOTAP=3Dy
CONFIG_IPW2200_PROMISCUOUS=3Dy
CONFIG_IPW2200_QOS=3Dy
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=3Dm
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=3Dm
CONFIG_IWLCORE=3Dm
CONFIG_IWLWIFI_LEDS=3Dy
# CONFIG_IWLWIFI_RFKILL is not set
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=3Dm
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=3Dy
CONFIG_IWLAGN_LEDS=3Dy
CONFIG_IWL4965=3Dy
CONFIG_IWL5000=3Dy
CONFIG_IWL3945=3Dm
# CONFIG_IWL3945_RFKILL is not set
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=3Dy
CONFIG_IWL3945_LEDS=3Dy
# CONFIG_IWL3945_DEBUG is not set
CONFIG_HOSTAP=3Dm
CONFIG_HOSTAP_FIRMWARE=3Dy
CONFIG_HOSTAP_FIRMWARE_NVRAM=3Dy
CONFIG_HOSTAP_PLX=3Dm
CONFIG_HOSTAP_PCI=3Dm
CONFIG_HOSTAP_CS=3Dm
CONFIG_B43=3Dm
CONFIG_B43_PCI_AUTOSELECT=3Dy
CONFIG_B43_PCICORE_AUTOSELECT=3Dy
CONFIG_B43_PCMCIA=3Dy
CONFIG_B43_PIO=3Dy
CONFIG_B43_LEDS=3Dy
CONFIG_B43_RFKILL=3Dy
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=3Dm
CONFIG_B43LEGACY_PCI_AUTOSELECT=3Dy
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=3Dy
CONFIG_B43LEGACY_LEDS=3Dy
CONFIG_B43LEGACY_RFKILL=3Dy
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=3Dy
CONFIG_B43LEGACY_PIO=3Dy
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=3Dy
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_ZD1211RW=3Dm
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_RT2X00=3Dm
CONFIG_RT2400PCI=3Dm
CONFIG_RT2500PCI=3Dm
CONFIG_RT61PCI=3Dm
CONFIG_RT2500USB=3Dm
CONFIG_RT73USB=3Dm
CONFIG_RT2X00_LIB_PCI=3Dm
CONFIG_RT2X00_LIB_USB=3Dm
CONFIG_RT2X00_LIB=3Dm
CONFIG_RT2X00_LIB_FIRMWARE=3Dy
CONFIG_RT2X00_LIB_CRYPTO=3Dy
CONFIG_RT2X00_LIB_RFKILL=3Dy
CONFIG_RT2X00_LIB_LEDS=3Dy
# CONFIG_RT2X00_DEBUG is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=3Dm
CONFIG_WIMAX_I2400M_USB=3Dm
CONFIG_WIMAX_I2400M_SDIO=3Dm
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=3D8

#
# USB Network Adapters
#
CONFIG_USB_CATC=3Dm
CONFIG_USB_KAWETH=3Dm
CONFIG_USB_PEGASUS=3Dm
CONFIG_USB_RTL8150=3Dm
CONFIG_USB_USBNET=3Dm
CONFIG_USB_NET_AX8817X=3Dm
CONFIG_USB_NET_CDCETHER=3Dm
CONFIG_USB_NET_DM9601=3Dm
CONFIG_USB_NET_SMSC95XX=3Dm
CONFIG_USB_NET_GL620A=3Dm
CONFIG_USB_NET_NET1080=3Dm
CONFIG_USB_NET_PLUSB=3Dm
CONFIG_USB_NET_MCS7830=3Dm
CONFIG_USB_NET_RNDIS_HOST=3Dm
CONFIG_USB_NET_CDC_SUBSET=3Dm
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_ARMLINUX=3Dy
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=3Dm
CONFIG_USB_HSO=3Dm
CONFIG_NET_PCMCIA=3Dy
CONFIG_PCMCIA_3C589=3Dm
CONFIG_PCMCIA_3C574=3Dm
CONFIG_PCMCIA_FMVJ18X=3Dm
CONFIG_PCMCIA_PCNET=3Dm
CONFIG_PCMCIA_NMCLAN=3Dm
CONFIG_PCMCIA_SMC91C92=3Dm
CONFIG_PCMCIA_XIRC2PS=3Dm
CONFIG_PCMCIA_AXNET=3Dm
CONFIG_ARCNET_COM20020_CS=3Dm
CONFIG_PCMCIA_IBMTR=3Dm
CONFIG_WAN=3Dy
CONFIG_LANMEDIA=3Dm
CONFIG_HDLC=3Dm
CONFIG_HDLC_RAW=3Dm
CONFIG_HDLC_RAW_ETH=3Dm
CONFIG_HDLC_CISCO=3Dm
CONFIG_HDLC_FR=3Dm
CONFIG_HDLC_PPP=3Dm

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=3Dm
CONFIG_WANXL=3Dm
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=3Dm
CONFIG_DSCC4=3Dm
# CONFIG_DSCC4_PCISYNC is not set
# CONFIG_DSCC4_PCI_RST is not set
CONFIG_DLCI=3Dm
CONFIG_DLCI_MAX=3D8
CONFIG_WAN_ROUTER_DRIVERS=3Dm
CONFIG_CYCLADES_SYNC=3Dm
CONFIG_CYCLOMX_X25=3Dy
CONFIG_SBNI=3Dm
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ATM_DRIVERS=3Dy
CONFIG_ATM_DUMMY=3Dm
CONFIG_ATM_TCP=3Dm
CONFIG_ATM_LANAI=3Dm
CONFIG_ATM_ENI=3Dm
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=3Dm
CONFIG_ATM_ZATM=3Dm
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_IDT77252=3Dm
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=3Dy
CONFIG_ATM_AMBASSADOR=3Dm
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=3Dm
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=3Dm
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=3Dm
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=3D16
CONFIG_ATM_FORE200E_DEBUG=3D0
CONFIG_ATM_HE=3Dm
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=3Dm
CONFIG_FDDI=3Dy
CONFIG_DEFXX=3Dm
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=3Dm
CONFIG_HIPPI=3Dy
CONFIG_ROADRUNNER=3Dm
# CONFIG_ROADRUNNER_LARGE_RINGS is not set
CONFIG_PLIP=3Dm
CONFIG_PPP=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_MPPE=3Dm
CONFIG_PPPOE=3Dm
CONFIG_PPPOATM=3Dm
CONFIG_PPPOL2TP=3Dm
CONFIG_SLIP=3Dm
CONFIG_SLIP_COMPRESSED=3Dy
CONFIG_SLHC=3Dm
CONFIG_SLIP_SMART=3Dy
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=3Dy
CONFIG_NETCONSOLE=3Dm
CONFIG_NETCONSOLE_DYNAMIC=3Dy
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy
CONFIG_VIRTIO_NET=3Dm
CONFIG_ISDN=3Dy
CONFIG_MISDN=3Dm
CONFIG_MISDN_DSP=3Dm
CONFIG_MISDN_L1OIP=3Dm

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=3Dm
CONFIG_MISDN_HFCMULTI=3Dm
CONFIG_MISDN_HFCUSB=3Dm
CONFIG_ISDN_I4L=3Dm
CONFIG_ISDN_PPP=3Dy
CONFIG_ISDN_PPP_VJ=3Dy
CONFIG_ISDN_MPP=3Dy
CONFIG_IPPP_FILTER=3Dy
CONFIG_ISDN_PPP_BSDCOMP=3Dm
CONFIG_ISDN_AUDIO=3Dy
CONFIG_ISDN_TTY_FAX=3Dy

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=3Dm

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=3Dm

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=3Dy
CONFIG_DE_AOC=3Dy
CONFIG_HISAX_NO_SENDCOMPLETE=3Dy
CONFIG_HISAX_NO_LLC=3Dy
CONFIG_HISAX_NO_KEYPAD=3Dy
CONFIG_HISAX_1TR6=3Dy
CONFIG_HISAX_NI1=3Dy
CONFIG_HISAX_MAX_CARDS=3D8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=3Dy
CONFIG_HISAX_TELESPCI=3Dy
CONFIG_HISAX_S0BOX=3Dy
CONFIG_HISAX_FRITZPCI=3Dy
CONFIG_HISAX_AVM_A1_PCMCIA=3Dy
CONFIG_HISAX_ELSA=3Dy
CONFIG_HISAX_DIEHLDIVA=3Dy
CONFIG_HISAX_SEDLBAUER=3Dy
CONFIG_HISAX_NETJET=3Dy
CONFIG_HISAX_NETJET_U=3Dy
CONFIG_HISAX_NICCY=3Dy
CONFIG_HISAX_BKM_A4T=3Dy
CONFIG_HISAX_SCT_QUADRO=3Dy
CONFIG_HISAX_GAZEL=3Dy
CONFIG_HISAX_HFC_PCI=3Dy
CONFIG_HISAX_W6692=3Dy
CONFIG_HISAX_HFC_SX=3Dy
CONFIG_HISAX_ENTERNOW_PCI=3Dy
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=3Dm
CONFIG_HISAX_ELSA_CS=3Dm
CONFIG_HISAX_AVM_A1_CS=3Dm
CONFIG_HISAX_TELES_CS=3Dm

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=3Dm
CONFIG_HISAX_HFCUSB=3Dm
CONFIG_HISAX_HFC4S8S=3Dm
CONFIG_HISAX_FRITZ_PCIPNP=3Dm
CONFIG_HISAX_HDLC=3Dy

#
# Active cards
#
CONFIG_HYSDN=3Dm
CONFIG_HYSDN_CAPI=3Dy
CONFIG_ISDN_DRV_GIGASET=3Dm
CONFIG_GIGASET_BASE=3Dm
CONFIG_GIGASET_M105=3Dm
# CONFIG_GIGASET_M101 is not set
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_GIGASET_UNDOCREQ is not set
CONFIG_ISDN_CAPI=3Dm
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=3Dy
CONFIG_CAPI_TRACE=3Dy
CONFIG_ISDN_CAPI_MIDDLEWARE=3Dy
CONFIG_ISDN_CAPI_CAPI20=3Dm
CONFIG_ISDN_CAPI_CAPIFS_BOOL=3Dy
CONFIG_ISDN_CAPI_CAPIFS=3Dm
CONFIG_ISDN_CAPI_CAPIDRV=3Dm

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=3Dy
CONFIG_ISDN_DRV_AVMB1_B1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=3Dy
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=3Dm
CONFIG_ISDN_DRV_AVMB1_AVM_CS=3Dm
CONFIG_ISDN_DRV_AVMB1_T1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_C4=3Dm
CONFIG_CAPI_EICON=3Dy
CONFIG_ISDN_DIVAS=3Dm
CONFIG_ISDN_DIVAS_BRIPCI=3Dy
CONFIG_ISDN_DIVAS_PRIPCI=3Dy
CONFIG_ISDN_DIVAS_DIVACAPI=3Dm
CONFIG_ISDN_DIVAS_USERIDI=3Dm
CONFIG_ISDN_DIVAS_MAINT=3Dm
CONFIG_PHONE=3Dm
CONFIG_PHONE_IXJ=3Dm
CONFIG_PHONE_IXJ_PCMCIA=3Dm

#
# Input device support
#
CONFIG_INPUT=3Dy
CONFIG_INPUT_FF_MEMLESS=3Dy
CONFIG_INPUT_POLLDEV=3Dm

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
CONFIG_INPUT_EVDEV=3Dm
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_STOWAWAY=3Dm
CONFIG_KEYBOARD_GPIO=3Dm
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dm
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_TOUCHKIT=3Dy
CONFIG_MOUSE_SERIAL=3Dm
CONFIG_MOUSE_APPLETOUCH=3Dm
CONFIG_MOUSE_BCM5974=3Dm
CONFIG_MOUSE_VSXXXAA=3Dm
CONFIG_MOUSE_GPIO=3Dm
CONFIG_INPUT_JOYSTICK=3Dy
CONFIG_JOYSTICK_ANALOG=3Dm
CONFIG_JOYSTICK_A3D=3Dm
CONFIG_JOYSTICK_ADI=3Dm
CONFIG_JOYSTICK_COBRA=3Dm
CONFIG_JOYSTICK_GF2K=3Dm
CONFIG_JOYSTICK_GRIP=3Dm
CONFIG_JOYSTICK_GRIP_MP=3Dm
CONFIG_JOYSTICK_GUILLEMOT=3Dm
CONFIG_JOYSTICK_INTERACT=3Dm
CONFIG_JOYSTICK_SIDEWINDER=3Dm
CONFIG_JOYSTICK_TMDC=3Dm
CONFIG_JOYSTICK_IFORCE=3Dm
CONFIG_JOYSTICK_IFORCE_USB=3Dy
CONFIG_JOYSTICK_IFORCE_232=3Dy
CONFIG_JOYSTICK_WARRIOR=3Dm
CONFIG_JOYSTICK_MAGELLAN=3Dm
CONFIG_JOYSTICK_SPACEORB=3Dm
CONFIG_JOYSTICK_SPACEBALL=3Dm
CONFIG_JOYSTICK_STINGER=3Dm
CONFIG_JOYSTICK_TWIDJOY=3Dm
CONFIG_JOYSTICK_ZHENHUA=3Dm
CONFIG_JOYSTICK_DB9=3Dm
CONFIG_JOYSTICK_GAMECON=3Dm
CONFIG_JOYSTICK_TURBOGRAFX=3Dm
CONFIG_JOYSTICK_JOYDUMP=3Dm
CONFIG_JOYSTICK_XPAD=3Dm
CONFIG_JOYSTICK_XPAD_FF=3Dy
CONFIG_JOYSTICK_XPAD_LEDS=3Dy
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=3Dy
CONFIG_TOUCHSCREEN_FUJITSU=3Dm
CONFIG_TOUCHSCREEN_GUNZE=3Dm
CONFIG_TOUCHSCREEN_ELO=3Dm
CONFIG_TOUCHSCREEN_WACOM_W8001=3Dm
CONFIG_TOUCHSCREEN_MTOUCH=3Dm
CONFIG_TOUCHSCREEN_INEXIO=3Dm
CONFIG_TOUCHSCREEN_MK712=3Dm
CONFIG_TOUCHSCREEN_PENMOUNT=3Dm
CONFIG_TOUCHSCREEN_TOUCHRIGHT=3Dm
CONFIG_TOUCHSCREEN_TOUCHWIN=3Dm
CONFIG_TOUCHSCREEN_UCB1400=3Dm
CONFIG_TOUCHSCREEN_WM97XX=3Dm
CONFIG_TOUCHSCREEN_WM9705=3Dy
CONFIG_TOUCHSCREEN_WM9712=3Dy
CONFIG_TOUCHSCREEN_WM9713=3Dy
CONFIG_TOUCHSCREEN_USB_COMPOSITE=3Dm
CONFIG_TOUCHSCREEN_USB_EGALAX=3Dy
CONFIG_TOUCHSCREEN_USB_PANJIT=3Dy
CONFIG_TOUCHSCREEN_USB_3M=3Dy
CONFIG_TOUCHSCREEN_USB_ITM=3Dy
CONFIG_TOUCHSCREEN_USB_ETURBO=3Dy
CONFIG_TOUCHSCREEN_USB_GUNZE=3Dy
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=3Dy
CONFIG_TOUCHSCREEN_USB_IRTOUCH=3Dy
CONFIG_TOUCHSCREEN_USB_IDEALTEK=3Dy
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=3Dy
CONFIG_TOUCHSCREEN_USB_GOTOP=3Dy
CONFIG_TOUCHSCREEN_TOUCHIT213=3Dm
CONFIG_TOUCHSCREEN_TSC2007=3Dm
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dm
CONFIG_INPUT_APANEL=3Dm
CONFIG_INPUT_ATLAS_BTNS=3Dm
CONFIG_INPUT_ATI_REMOTE=3Dm
CONFIG_INPUT_ATI_REMOTE2=3Dm
CONFIG_INPUT_KEYSPAN_REMOTE=3Dm
CONFIG_INPUT_POWERMATE=3Dm
CONFIG_INPUT_YEALINK=3Dm
CONFIG_INPUT_CM109=3Dm
CONFIG_INPUT_UINPUT=3Dm
CONFIG_INPUT_PCF50633_PMU=3Dm

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dm
CONFIG_SERIO_CT82C710=3Dm
CONFIG_SERIO_PARKBD=3Dm
CONFIG_SERIO_PCIPS2=3Dm
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
CONFIG_GAMEPORT=3Dm
CONFIG_GAMEPORT_NS558=3Dm
CONFIG_GAMEPORT_L4=3Dm
CONFIG_GAMEPORT_EMU10K1=3Dm
CONFIG_GAMEPORT_FM801=3Dm

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
CONFIG_DEVKMEM=3Dy
CONFIG_SERIAL_NONSTANDARD=3Dy
CONFIG_COMPUTONE=3Dm
CONFIG_ROCKETPORT=3Dm
CONFIG_CYCLADES=3Dm
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=3Dm
CONFIG_MOXA_INTELLIO=3Dm
CONFIG_MOXA_SMARTIO=3Dm
CONFIG_ISI=3Dm
CONFIG_SYNCLINK=3Dm
CONFIG_SYNCLINKMP=3Dm
CONFIG_SYNCLINK_GT=3Dm
CONFIG_N_HDLC=3Dm
CONFIG_RISCOM8=3Dm
CONFIG_SPECIALIX=3Dm
CONFIG_SX=3Dm
CONFIG_RIO=3Dm
# CONFIG_RIO_OLDPCI is not set
CONFIG_STALDRV=3Dy
CONFIG_STALLION=3Dm
CONFIG_ISTALLION=3Dm
CONFIG_NOZOMI=3Dm

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
CONFIG_SERIAL_8250_CONSOLE=3Dy
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_CS=3Dm
CONFIG_SERIAL_8250_NR_UARTS=3D4
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_MANY_PORTS=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
CONFIG_SERIAL_8250_DETECT_IRQ=3Dy
CONFIG_SERIAL_8250_RSA=3Dy

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_CORE_CONSOLE=3Dy
CONFIG_SERIAL_JSM=3Dm
CONFIG_UNIX98_PTYS=3Dy
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256
CONFIG_PRINTER=3Dm
CONFIG_LP_CONSOLE=3Dy
CONFIG_PPDEV=3Dm
CONFIG_HVC_DRIVER=3Dy
CONFIG_VIRTIO_CONSOLE=3Dm
CONFIG_IPMI_HANDLER=3Dm
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=3Dm
CONFIG_IPMI_SI=3Dm
CONFIG_IPMI_WATCHDOG=3Dm
CONFIG_IPMI_POWEROFF=3Dm
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dm
CONFIG_HW_RANDOM_AMD=3Dm
CONFIG_HW_RANDOM_VIRTIO=3Dm
CONFIG_NVRAM=3Dm
CONFIG_R3964=3Dm
CONFIG_APPLICOM=3Dm

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=3Dm
CONFIG_CARDMAN_4000=3Dm
CONFIG_CARDMAN_4040=3Dm
CONFIG_IPWIRELESS=3Dm
CONFIG_MWAVE=3Dm
CONFIG_PC8736x_GPIO=3Dm
CONFIG_NSC_GPIO=3Dm
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=3Dm
CONFIG_TCG_TPM=3Dm
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=3Dm
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=3Dm
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dy
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_CHARDEV=3Dy
CONFIG_I2C_HELPER_AUTO=3Dy
CONFIG_I2C_ALGOBIT=3Dy
CONFIG_I2C_ALGOPCA=3Dm

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=3Dm
CONFIG_I2C_ALI1563=3Dm
CONFIG_I2C_ALI15X3=3Dm
CONFIG_I2C_AMD756=3Dm
CONFIG_I2C_AMD756_S4882=3Dm
CONFIG_I2C_AMD8111=3Dm
CONFIG_I2C_I801=3Dm
CONFIG_I2C_ISCH=3Dm
CONFIG_I2C_PIIX4=3Dm
CONFIG_I2C_NFORCE2=3Dm
CONFIG_I2C_NFORCE2_S4985=3Dm
CONFIG_I2C_SIS5595=3Dm
CONFIG_I2C_SIS630=3Dm
CONFIG_I2C_SIS96X=3Dm
CONFIG_I2C_VIA=3Dm
CONFIG_I2C_VIAPRO=3Dm

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=3Dm
CONFIG_I2C_OCORES=3Dm
CONFIG_I2C_SIMTEC=3Dm

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=3Dm
CONFIG_I2C_PARPORT_LIGHT=3Dm
CONFIG_I2C_TAOS_EVM=3Dm
CONFIG_I2C_TINY_USB=3Dm

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=3Dm

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=3Dm
CONFIG_I2C_STUB=3Dm

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=3Dm
CONFIG_SENSORS_PCF8591=3Dm
CONFIG_SENSORS_MAX6875=3Dm
CONFIG_SENSORS_TSL2550=3Dm
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
CONFIG_GPIOLIB=3Dy
CONFIG_GPIO_SYSFS=3Dy

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=3Dm
CONFIG_GPIO_PCA953X=3Dm
CONFIG_GPIO_PCF857X=3Dm

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
CONFIG_W1=3Dm
CONFIG_W1_CON=3Dy

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=3Dm
CONFIG_W1_MASTER_DS2490=3Dm
CONFIG_W1_MASTER_DS2482=3Dm
CONFIG_W1_MASTER_GPIO=3Dm

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=3Dm
CONFIG_W1_SLAVE_SMEM=3Dm
CONFIG_W1_SLAVE_DS2431=3Dm
CONFIG_W1_SLAVE_DS2433=3Dm
CONFIG_W1_SLAVE_DS2433_CRC=3Dy
CONFIG_W1_SLAVE_DS2760=3Dm
CONFIG_W1_SLAVE_BQ27000=3Dm
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=3Dm
CONFIG_WM8350_POWER=3Dm
CONFIG_BATTERY_DS2760=3Dm
CONFIG_BATTERY_BQ27x00=3Dm
CONFIG_CHARGER_PCF50633=3Dm
CONFIG_HWMON=3Dm
CONFIG_HWMON_VID=3Dm
CONFIG_SENSORS_ABITUGURU=3Dm
CONFIG_SENSORS_ABITUGURU3=3Dm
CONFIG_SENSORS_AD7414=3Dm
CONFIG_SENSORS_AD7418=3Dm
CONFIG_SENSORS_ADM1021=3Dm
CONFIG_SENSORS_ADM1025=3Dm
CONFIG_SENSORS_ADM1026=3Dm
CONFIG_SENSORS_ADM1029=3Dm
CONFIG_SENSORS_ADM1031=3Dm
CONFIG_SENSORS_ADM9240=3Dm
CONFIG_SENSORS_ADT7462=3Dm
CONFIG_SENSORS_ADT7470=3Dm
CONFIG_SENSORS_ADT7473=3Dm
CONFIG_SENSORS_ADT7475=3Dm
CONFIG_SENSORS_K8TEMP=3Dm
CONFIG_SENSORS_ASB100=3Dm
CONFIG_SENSORS_ATXP1=3Dm
CONFIG_SENSORS_DS1621=3Dm
CONFIG_SENSORS_I5K_AMB=3Dm
CONFIG_SENSORS_F71805F=3Dm
CONFIG_SENSORS_F71882FG=3Dm
CONFIG_SENSORS_F75375S=3Dm
CONFIG_SENSORS_FSCHER=3Dm
CONFIG_SENSORS_FSCPOS=3Dm
CONFIG_SENSORS_FSCHMD=3Dm
CONFIG_SENSORS_GL518SM=3Dm
CONFIG_SENSORS_GL520SM=3Dm
CONFIG_SENSORS_CORETEMP=3Dm
CONFIG_SENSORS_IBMAEM=3Dm
CONFIG_SENSORS_IBMPEX=3Dm
CONFIG_SENSORS_IT87=3Dm
CONFIG_SENSORS_LM63=3Dm
CONFIG_SENSORS_LM75=3Dm
CONFIG_SENSORS_LM77=3Dm
CONFIG_SENSORS_LM78=3Dm
CONFIG_SENSORS_LM80=3Dm
CONFIG_SENSORS_LM83=3Dm
CONFIG_SENSORS_LM85=3Dm
CONFIG_SENSORS_LM87=3Dm
CONFIG_SENSORS_LM90=3Dm
CONFIG_SENSORS_LM92=3Dm
CONFIG_SENSORS_LM93=3Dm
CONFIG_SENSORS_LTC4245=3Dm
CONFIG_SENSORS_MAX1619=3Dm
CONFIG_SENSORS_MAX6650=3Dm
CONFIG_SENSORS_PC87360=3Dm
CONFIG_SENSORS_PC87427=3Dm
CONFIG_SENSORS_SIS5595=3Dm
CONFIG_SENSORS_DME1737=3Dm
CONFIG_SENSORS_SMSC47M1=3Dm
CONFIG_SENSORS_SMSC47M192=3Dm
CONFIG_SENSORS_SMSC47B397=3Dm
CONFIG_SENSORS_ADS7828=3Dm
CONFIG_SENSORS_THMC50=3Dm
CONFIG_SENSORS_VIA686A=3Dm
CONFIG_SENSORS_VT1211=3Dm
CONFIG_SENSORS_VT8231=3Dm
CONFIG_SENSORS_W83781D=3Dm
CONFIG_SENSORS_W83791D=3Dm
CONFIG_SENSORS_W83792D=3Dm
CONFIG_SENSORS_W83793=3Dm
CONFIG_SENSORS_W83L785TS=3Dm
CONFIG_SENSORS_W83L786NG=3Dm
CONFIG_SENSORS_W83627HF=3Dm
CONFIG_SENSORS_W83627EHF=3Dm
CONFIG_SENSORS_HDAPS=3Dm
CONFIG_SENSORS_LIS3LV02D=3Dm
CONFIG_SENSORS_APPLESMC=3Dm
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=3Dm
CONFIG_THERMAL_HWMON=3Dy
CONFIG_WATCHDOG=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=3Dm
CONFIG_WM8350_WATCHDOG=3Dm
CONFIG_ACQUIRE_WDT=3Dm
CONFIG_ADVANTECH_WDT=3Dm
CONFIG_ALIM1535_WDT=3Dm
CONFIG_ALIM7101_WDT=3Dm
CONFIG_SC520_WDT=3Dm
CONFIG_EUROTECH_WDT=3Dm
CONFIG_IB700_WDT=3Dm
CONFIG_IBMASR=3Dm
CONFIG_WAFER_WDT=3Dm
CONFIG_I6300ESB_WDT=3Dm
CONFIG_ITCO_WDT=3Dm
CONFIG_ITCO_VENDOR_SUPPORT=3Dy
CONFIG_IT8712F_WDT=3Dm
CONFIG_IT87_WDT=3Dm
CONFIG_HP_WATCHDOG=3Dm
CONFIG_SC1200_WDT=3Dm
CONFIG_PC87413_WDT=3Dm
CONFIG_60XX_WDT=3Dm
CONFIG_SBC8360_WDT=3Dm
CONFIG_CPU5_WDT=3Dm
CONFIG_SMSC_SCH311X_WDT=3Dm
CONFIG_SMSC37B787_WDT=3Dm
CONFIG_W83627HF_WDT=3Dm
CONFIG_W83697HF_WDT=3Dm
CONFIG_W83697UG_WDT=3Dm
CONFIG_W83877F_WDT=3Dm
CONFIG_W83977F_WDT=3Dm
CONFIG_MACHZ_WDT=3Dm
CONFIG_SBC_EPX_C3_WATCHDOG=3Dm

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=3Dm
CONFIG_WDTPCI=3Dm
CONFIG_WDT_501_PCI=3Dy

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=3Dm
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
CONFIG_SSB=3Dm
CONFIG_SSB_SPROM=3Dy
CONFIG_SSB_BLOCKIO=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
CONFIG_SSB_B43_PCI_BRIDGE=3Dy
CONFIG_SSB_PCMCIAHOST_POSSIBLE=3Dy
CONFIG_SSB_PCMCIAHOST=3Dy
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=3Dm
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=3Dm
CONFIG_UCB1400_CORE=3Dm
CONFIG_TPS65010=3Dm
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_MFD_WM8400=3Dm
CONFIG_MFD_WM8350=3Dm
CONFIG_MFD_WM8350_I2C=3Dm
CONFIG_MFD_PCF50633=3Dm
CONFIG_PCF50633_ADC=3Dm
CONFIG_PCF50633_GPIO=3Dm
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=3Dm
CONFIG_VIDEO_V4L2_COMMON=3Dm
CONFIG_VIDEO_ALLOW_V4L1=3Dy
CONFIG_VIDEO_V4L1_COMPAT=3Dy
CONFIG_DVB_CORE=3Dm
CONFIG_VIDEO_MEDIA=3Dm

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=3Dm
CONFIG_VIDEO_SAA7146_VV=3Dm
CONFIG_MEDIA_ATTACH=3Dy
CONFIG_MEDIA_TUNER=3Dm
CONFIG_MEDIA_TUNER_CUSTOMIZE=3Dy
CONFIG_MEDIA_TUNER_SIMPLE=3Dm
CONFIG_MEDIA_TUNER_TDA8290=3Dm
CONFIG_MEDIA_TUNER_TDA827X=3Dm
CONFIG_MEDIA_TUNER_TDA18271=3Dm
CONFIG_MEDIA_TUNER_TDA9887=3Dm
CONFIG_MEDIA_TUNER_TEA5761=3Dm
CONFIG_MEDIA_TUNER_TEA5767=3Dm
CONFIG_MEDIA_TUNER_MT20XX=3Dm
CONFIG_MEDIA_TUNER_MT2060=3Dm
CONFIG_MEDIA_TUNER_MT2266=3Dm
CONFIG_MEDIA_TUNER_MT2131=3Dm
CONFIG_MEDIA_TUNER_QT1010=3Dm
CONFIG_MEDIA_TUNER_XC2028=3Dm
CONFIG_MEDIA_TUNER_XC5000=3Dm
CONFIG_MEDIA_TUNER_MXL5005S=3Dm
CONFIG_MEDIA_TUNER_MXL5007T=3Dm
CONFIG_VIDEO_V4L2=3Dm
CONFIG_VIDEO_V4L1=3Dm
CONFIG_VIDEOBUF_GEN=3Dm
CONFIG_VIDEOBUF_DMA_SG=3Dm
CONFIG_VIDEOBUF_VMALLOC=3Dm
CONFIG_VIDEOBUF_DVB=3Dm
CONFIG_VIDEO_BTCX=3Dm
CONFIG_VIDEO_IR=3Dm
CONFIG_VIDEO_TVEEPROM=3Dm
CONFIG_VIDEO_TUNER=3Dm
CONFIG_VIDEO_CAPTURE_DRIVERS=3Dy
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
CONFIG_VIDEO_IR_I2C=3Dm

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
CONFIG_VIDEO_TVAUDIO=3Dm
CONFIG_VIDEO_TDA7432=3Dm
CONFIG_VIDEO_TDA9840=3Dm
CONFIG_VIDEO_TDA9875=3Dm
CONFIG_VIDEO_TEA6415C=3Dm
CONFIG_VIDEO_TEA6420=3Dm
CONFIG_VIDEO_MSP3400=3Dm
CONFIG_VIDEO_CS5345=3Dm
CONFIG_VIDEO_CS53L32A=3Dm
CONFIG_VIDEO_M52790=3Dm
CONFIG_VIDEO_TLV320AIC23B=3Dm
CONFIG_VIDEO_WM8775=3Dm
CONFIG_VIDEO_WM8739=3Dm
CONFIG_VIDEO_VP27SMPX=3Dm

#
# Video decoders
#
CONFIG_VIDEO_BT819=3Dm
CONFIG_VIDEO_BT856=3Dm
CONFIG_VIDEO_BT866=3Dm
CONFIG_VIDEO_KS0127=3Dm
CONFIG_VIDEO_OV7670=3Dm
CONFIG_VIDEO_TCM825X=3Dm
CONFIG_VIDEO_SAA7110=3Dm
CONFIG_VIDEO_SAA7111=3Dm
CONFIG_VIDEO_SAA7114=3Dm
CONFIG_VIDEO_SAA711X=3Dm
CONFIG_VIDEO_SAA717X=3Dm
CONFIG_VIDEO_SAA7191=3Dm
CONFIG_VIDEO_TVP514X=3Dm
CONFIG_VIDEO_TVP5150=3Dm
CONFIG_VIDEO_VPX3220=3Dm

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=3Dm

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=3Dm

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=3Dm
CONFIG_VIDEO_SAA7185=3Dm
CONFIG_VIDEO_ADV7170=3Dm
CONFIG_VIDEO_ADV7175=3Dm

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=3Dm
CONFIG_VIDEO_UPD64083=3Dm
CONFIG_VIDEO_VIVI=3Dm
CONFIG_VIDEO_BT848=3Dm
CONFIG_VIDEO_BT848_DVB=3Dy
CONFIG_VIDEO_SAA6588=3Dm
CONFIG_VIDEO_BWQCAM=3Dm
CONFIG_VIDEO_CQCAM=3Dm
CONFIG_VIDEO_W9966=3Dm
CONFIG_VIDEO_CPIA=3Dm
CONFIG_VIDEO_CPIA_PP=3Dm
CONFIG_VIDEO_CPIA_USB=3Dm
CONFIG_VIDEO_CPIA2=3Dm
CONFIG_VIDEO_SAA5246A=3Dm
CONFIG_VIDEO_SAA5249=3Dm
CONFIG_VIDEO_STRADIS=3Dm
CONFIG_VIDEO_ZORAN=3Dm
CONFIG_VIDEO_ZORAN_DC30=3Dm
CONFIG_VIDEO_ZORAN_ZR36060=3Dm
CONFIG_VIDEO_ZORAN_BUZ=3Dm
CONFIG_VIDEO_ZORAN_DC10=3Dm
CONFIG_VIDEO_ZORAN_LML33=3Dm
CONFIG_VIDEO_ZORAN_LML33R10=3Dm
CONFIG_VIDEO_ZORAN_AVS6EYES=3Dm
CONFIG_VIDEO_MEYE=3Dm
CONFIG_VIDEO_SAA7134=3Dm
CONFIG_VIDEO_SAA7134_ALSA=3Dm
CONFIG_VIDEO_SAA7134_DVB=3Dm
CONFIG_VIDEO_MXB=3Dm
CONFIG_VIDEO_HEXIUM_ORION=3Dm
CONFIG_VIDEO_HEXIUM_GEMINI=3Dm
CONFIG_VIDEO_CX88=3Dm
CONFIG_VIDEO_CX88_ALSA=3Dm
CONFIG_VIDEO_CX88_BLACKBIRD=3Dm
CONFIG_VIDEO_CX88_DVB=3Dm
CONFIG_VIDEO_CX88_MPEG=3Dm
CONFIG_VIDEO_CX88_VP3054=3Dm
CONFIG_VIDEO_CX23885=3Dm
CONFIG_VIDEO_AU0828=3Dm
CONFIG_VIDEO_IVTV=3Dm
CONFIG_VIDEO_FB_IVTV=3Dm
CONFIG_VIDEO_CX18=3Dm
CONFIG_VIDEO_CAFE_CCIC=3Dm
CONFIG_SOC_CAMERA=3Dm
CONFIG_SOC_CAMERA_MT9M001=3Dm
CONFIG_MT9M001_PCA9536_SWITCH=3Dy
CONFIG_SOC_CAMERA_MT9M111=3Dm
CONFIG_SOC_CAMERA_MT9T031=3Dm
CONFIG_SOC_CAMERA_MT9V022=3Dm
CONFIG_MT9V022_PCA9536_SWITCH=3Dy
CONFIG_SOC_CAMERA_TW9910=3Dm
CONFIG_SOC_CAMERA_PLATFORM=3Dm
CONFIG_SOC_CAMERA_OV772X=3Dm
CONFIG_V4L_USB_DRIVERS=3Dy
CONFIG_USB_VIDEO_CLASS=3Dm
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=3Dy
CONFIG_USB_GSPCA=3Dm
CONFIG_USB_M5602=3Dm
CONFIG_USB_STV06XX=3Dm
CONFIG_USB_GSPCA_CONEX=3Dm
CONFIG_USB_GSPCA_ETOMS=3Dm
CONFIG_USB_GSPCA_FINEPIX=3Dm
CONFIG_USB_GSPCA_MARS=3Dm
CONFIG_USB_GSPCA_OV519=3Dm
CONFIG_USB_GSPCA_OV534=3Dm
CONFIG_USB_GSPCA_PAC207=3Dm
CONFIG_USB_GSPCA_PAC7311=3Dm
CONFIG_USB_GSPCA_SONIXB=3Dm
CONFIG_USB_GSPCA_SONIXJ=3Dm
CONFIG_USB_GSPCA_SPCA500=3Dm
CONFIG_USB_GSPCA_SPCA501=3Dm
CONFIG_USB_GSPCA_SPCA505=3Dm
CONFIG_USB_GSPCA_SPCA506=3Dm
CONFIG_USB_GSPCA_SPCA508=3Dm
CONFIG_USB_GSPCA_SPCA561=3Dm
CONFIG_USB_GSPCA_STK014=3Dm
CONFIG_USB_GSPCA_SUNPLUS=3Dm
CONFIG_USB_GSPCA_T613=3Dm
CONFIG_USB_GSPCA_TV8532=3Dm
CONFIG_USB_GSPCA_VC032X=3Dm
CONFIG_USB_GSPCA_ZC3XX=3Dm
CONFIG_VIDEO_PVRUSB2=3Dm
CONFIG_VIDEO_PVRUSB2_SYSFS=3Dy
CONFIG_VIDEO_PVRUSB2_DVB=3Dy
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_EM28XX=3Dm
CONFIG_VIDEO_EM28XX_ALSA=3Dm
CONFIG_VIDEO_EM28XX_DVB=3Dm
CONFIG_VIDEO_USBVISION=3Dm
CONFIG_VIDEO_USBVIDEO=3Dm
CONFIG_USB_VICAM=3Dm
CONFIG_USB_IBMCAM=3Dm
CONFIG_USB_KONICAWC=3Dm
CONFIG_USB_QUICKCAM_MESSENGER=3Dm
CONFIG_USB_ET61X251=3Dm
CONFIG_VIDEO_OVCAMCHIP=3Dm
CONFIG_USB_W9968CF=3Dm
CONFIG_USB_OV511=3Dm
CONFIG_USB_SE401=3Dm
CONFIG_USB_SN9C102=3Dm
CONFIG_USB_STV680=3Dm
CONFIG_USB_ZC0301=3Dm
CONFIG_USB_PWC=3Dm
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_ZR364XX=3Dm
CONFIG_USB_STKWEBCAM=3Dm
CONFIG_USB_S2255=3Dm
CONFIG_RADIO_ADAPTERS=3Dy
CONFIG_RADIO_GEMTEK_PCI=3Dm
CONFIG_RADIO_MAXIRADIO=3Dm
CONFIG_RADIO_MAESTRO=3Dm
CONFIG_USB_DSBR=3Dm
CONFIG_USB_SI470X=3Dm
CONFIG_USB_MR800=3Dm
CONFIG_RADIO_TEA5764=3Dm
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_CAPTURE_DRIVERS=3Dy

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=3Dm
CONFIG_DVB_AV7110=3Dm
CONFIG_DVB_AV7110_OSD=3Dy
CONFIG_DVB_BUDGET_CORE=3Dm
CONFIG_DVB_BUDGET=3Dm
CONFIG_DVB_BUDGET_CI=3Dm
CONFIG_DVB_BUDGET_AV=3Dm
CONFIG_DVB_BUDGET_PATCH=3Dm

#
# Supported USB Adapters
#
CONFIG_DVB_USB=3Dm
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=3Dm
CONFIG_DVB_USB_DIBUSB_MB=3Dm
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=3Dm
CONFIG_DVB_USB_DIB0700=3Dm
CONFIG_DVB_USB_UMT_010=3Dm
CONFIG_DVB_USB_CXUSB=3Dm
CONFIG_DVB_USB_M920X=3Dm
CONFIG_DVB_USB_GL861=3Dm
CONFIG_DVB_USB_AU6610=3Dm
CONFIG_DVB_USB_DIGITV=3Dm
CONFIG_DVB_USB_VP7045=3Dm
CONFIG_DVB_USB_VP702X=3Dm
CONFIG_DVB_USB_GP8PSK=3Dm
CONFIG_DVB_USB_NOVA_T_USB2=3Dm
CONFIG_DVB_USB_TTUSB2=3Dm
CONFIG_DVB_USB_DTT200U=3Dm
CONFIG_DVB_USB_OPERA1=3Dm
CONFIG_DVB_USB_AF9005=3Dm
CONFIG_DVB_USB_AF9005_REMOTE=3Dm
CONFIG_DVB_USB_DW2102=3Dm
CONFIG_DVB_USB_CINERGY_T2=3Dm
CONFIG_DVB_USB_ANYSEE=3Dm
CONFIG_DVB_USB_DTV5100=3Dm
CONFIG_DVB_USB_AF9015=3Dm
CONFIG_DVB_TTUSB_BUDGET=3Dm
CONFIG_DVB_TTUSB_DEC=3Dm
CONFIG_DVB_SIANO_SMS1XXX=3Dm
CONFIG_DVB_SIANO_SMS1XXX_SMS_IDS=3Dy

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=3Dm
CONFIG_DVB_B2C2_FLEXCOP_PCI=3Dm
CONFIG_DVB_B2C2_FLEXCOP_USB=3Dm
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=3Dm

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=3Dm

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=3Dm

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=3Dm
CONFIG_DVB_FIREDTV_IEEE1394=3Dy
CONFIG_DVB_FIREDTV_INPUT=3Dy

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=3Dy

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=3Dm
CONFIG_DVB_STB6100=3Dm

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=3Dm
CONFIG_DVB_CX24123=3Dm
CONFIG_DVB_MT312=3Dm
CONFIG_DVB_S5H1420=3Dm
CONFIG_DVB_STV0288=3Dm
CONFIG_DVB_STB6000=3Dm
CONFIG_DVB_STV0299=3Dm
CONFIG_DVB_TDA8083=3Dm
CONFIG_DVB_TDA10086=3Dm
CONFIG_DVB_TDA8261=3Dm
CONFIG_DVB_VES1X93=3Dm
CONFIG_DVB_TUNER_ITD1000=3Dm
CONFIG_DVB_TUNER_CX24113=3Dm
CONFIG_DVB_TDA826X=3Dm
CONFIG_DVB_TUA6100=3Dm
CONFIG_DVB_CX24116=3Dm
CONFIG_DVB_SI21XX=3Dm

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=3Dm
CONFIG_DVB_SP887X=3Dm
CONFIG_DVB_CX22700=3Dm
CONFIG_DVB_CX22702=3Dm
CONFIG_DVB_DRX397XD=3Dm
CONFIG_DVB_L64781=3Dm
CONFIG_DVB_TDA1004X=3Dm
CONFIG_DVB_NXT6000=3Dm
CONFIG_DVB_MT352=3Dm
CONFIG_DVB_ZL10353=3Dm
CONFIG_DVB_DIB3000MB=3Dm
CONFIG_DVB_DIB3000MC=3Dm
CONFIG_DVB_DIB7000M=3Dm
CONFIG_DVB_DIB7000P=3Dm
CONFIG_DVB_TDA10048=3Dm

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=3Dm
CONFIG_DVB_TDA10021=3Dm
CONFIG_DVB_TDA10023=3Dm
CONFIG_DVB_STV0297=3Dm

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=3Dm
CONFIG_DVB_OR51211=3Dm
CONFIG_DVB_OR51132=3Dm
CONFIG_DVB_BCM3510=3Dm
CONFIG_DVB_LGDT330X=3Dm
CONFIG_DVB_LGDT3304=3Dm
CONFIG_DVB_S5H1409=3Dm
CONFIG_DVB_AU8522=3Dm
CONFIG_DVB_S5H1411=3Dm

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=3Dm

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=3Dm
CONFIG_DVB_TUNER_DIB0070=3Dm

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=3Dm
CONFIG_DVB_ISL6405=3Dm
CONFIG_DVB_ISL6421=3Dm
CONFIG_DVB_LGS8GL5=3Dm

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
CONFIG_DVB_AF9013=3Dm
CONFIG_DAB=3Dy
CONFIG_USB_DABUSB=3Dm

#
# Graphics support
#
CONFIG_AGP=3Dy
CONFIG_AGP_AMD64=3Dy
CONFIG_AGP_INTEL=3Dm
CONFIG_AGP_SIS=3Dm
CONFIG_AGP_VIA=3Dm
CONFIG_DRM=3Dm
CONFIG_DRM_TDFX=3Dm
CONFIG_DRM_R128=3Dm
CONFIG_DRM_RADEON=3Dm
CONFIG_DRM_I810=3Dm
CONFIG_DRM_I830=3Dm
CONFIG_DRM_I915=3Dm
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_MGA=3Dm
CONFIG_DRM_SIS=3Dm
CONFIG_DRM_VIA=3Dm
CONFIG_DRM_SAVAGE=3Dm
CONFIG_VGASTATE=3Dm
CONFIG_VIDEO_OUTPUT_CONTROL=3Dm
CONFIG_FB=3Dy
CONFIG_FIRMWARE_EDID=3Dy
CONFIG_FB_DDC=3Dm
CONFIG_FB_BOOT_VESA_SUPPORT=3Dy
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=3Dm
CONFIG_FB_SYS_COPYAREA=3Dm
CONFIG_FB_SYS_IMAGEBLIT=3Dm
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=3Dm
CONFIG_FB_DEFERRED_IO=3Dy
CONFIG_FB_HECUBA=3Dm
CONFIG_FB_SVGALIB=3Dm
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=3Dy
CONFIG_FB_MODE_HELPERS=3Dy
CONFIG_FB_TILEBLITTING=3Dy

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=3Dm
CONFIG_FB_PM2=3Dm
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=3Dm
CONFIG_FB_ARC=3Dm
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=3Dm
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=3Dy
CONFIG_FB_N411=3Dm
CONFIG_FB_HGA=3Dm
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=3Dm
CONFIG_FB_NVIDIA=3Dm
CONFIG_FB_NVIDIA_I2C=3Dy
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=3Dy
CONFIG_FB_RIVA=3Dm
CONFIG_FB_RIVA_I2C=3Dy
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=3Dy
CONFIG_FB_LE80578=3Dm
CONFIG_FB_CARILLO_RANCH=3Dm
CONFIG_FB_INTEL=3Dm
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=3Dy
CONFIG_FB_MATROX=3Dm
CONFIG_FB_MATROX_MILLENIUM=3Dy
CONFIG_FB_MATROX_MYSTIQUE=3Dy
CONFIG_FB_MATROX_G=3Dy
CONFIG_FB_MATROX_I2C=3Dm
CONFIG_FB_MATROX_MAVEN=3Dm
CONFIG_FB_MATROX_MULTIHEAD=3Dy
CONFIG_FB_RADEON=3Dm
CONFIG_FB_RADEON_I2C=3Dy
CONFIG_FB_RADEON_BACKLIGHT=3Dy
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=3Dm
CONFIG_FB_ATY128_BACKLIGHT=3Dy
CONFIG_FB_ATY=3Dm
CONFIG_FB_ATY_CT=3Dy
CONFIG_FB_ATY_GENERIC_LCD=3Dy
CONFIG_FB_ATY_GX=3Dy
CONFIG_FB_ATY_BACKLIGHT=3Dy
CONFIG_FB_S3=3Dm
CONFIG_FB_SAVAGE=3Dm
CONFIG_FB_SAVAGE_I2C=3Dy
CONFIG_FB_SAVAGE_ACCEL=3Dy
CONFIG_FB_SIS=3Dm
CONFIG_FB_SIS_300=3Dy
CONFIG_FB_SIS_315=3Dy
CONFIG_FB_VIA=3Dm
CONFIG_FB_NEOMAGIC=3Dm
CONFIG_FB_KYRO=3Dm
CONFIG_FB_3DFX=3Dm
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_VOODOO1=3Dm
CONFIG_FB_VT8623=3Dm
CONFIG_FB_TRIDENT=3Dm
# CONFIG_FB_TRIDENT_ACCEL is not set
CONFIG_FB_ARK=3Dm
CONFIG_FB_PM3=3Dm
CONFIG_FB_CARMINE=3Dm
CONFIG_FB_CARMINE_DRAM_EVAL=3Dy
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=3Dy
CONFIG_FB_GEODE_LX=3Dm
CONFIG_FB_GEODE_GX=3Dm
CONFIG_FB_GEODE_GX1=3Dm
CONFIG_FB_TMIO=3Dm
CONFIG_FB_TMIO_ACCELL=3Dy
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=3Dm
CONFIG_FB_MB862XX=3Dm
CONFIG_FB_MB862XX_PCI_GDC=3Dy
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
CONFIG_LCD_CLASS_DEVICE=3Dm
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=3Dm
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
CONFIG_BACKLIGHT_GENERIC=3Dm
CONFIG_BACKLIGHT_PROGEAR=3Dm
CONFIG_BACKLIGHT_CARILLO_RANCH=3Dm
CONFIG_BACKLIGHT_MBP_NVIDIA=3Dm
CONFIG_BACKLIGHT_SAHARA=3Dm

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=3Dm

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=3D64
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=3Dy
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=3Dy
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=3Dy
CONFIG_SOUND=3Dm
CONFIG_SOUND_OSS_CORE=3Dy
CONFIG_SND=3Dm
CONFIG_SND_TIMER=3Dm
CONFIG_SND_PCM=3Dm
CONFIG_SND_HWDEP=3Dm
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_JACK=3Dy
CONFIG_SND_SEQUENCER=3Dm
CONFIG_SND_SEQ_DUMMY=3Dm
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dm
CONFIG_SND_PCM_OSS=3Dm
CONFIG_SND_PCM_OSS_PLUGINS=3Dy
CONFIG_SND_SEQUENCER_OSS=3Dy
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=3Dy
CONFIG_SND_VERBOSE_PROCFS=3Dy
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=3Dy
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_OPL3_LIB=3Dm
CONFIG_SND_VX_LIB=3Dm
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_SND_DRIVERS=3Dy
CONFIG_SND_DUMMY=3Dm
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
CONFIG_SND_MTS64=3Dm
CONFIG_SND_SERIAL_U16550=3Dm
CONFIG_SND_MPU401=3Dm
CONFIG_SND_PORTMAN2X4=3Dm
CONFIG_SND_AC97_POWER_SAVE=3Dy
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=3D0
CONFIG_SND_SB_COMMON=3Dm
CONFIG_SND_SB16_DSP=3Dm
CONFIG_SND_PCI=3Dy
CONFIG_SND_AD1889=3Dm
CONFIG_SND_ALS300=3Dm
CONFIG_SND_ALS4000=3Dm
CONFIG_SND_ALI5451=3Dm
CONFIG_SND_ATIIXP=3Dm
CONFIG_SND_ATIIXP_MODEM=3Dm
CONFIG_SND_AU8810=3Dm
CONFIG_SND_AU8820=3Dm
CONFIG_SND_AU8830=3Dm
CONFIG_SND_AW2=3Dm
CONFIG_SND_AZT3328=3Dm
CONFIG_SND_BT87X=3Dm
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=3Dm
CONFIG_SND_CMIPCI=3Dm
CONFIG_SND_OXYGEN_LIB=3Dm
CONFIG_SND_OXYGEN=3Dm
CONFIG_SND_CS4281=3Dm
CONFIG_SND_CS46XX=3Dm
CONFIG_SND_CS46XX_NEW_DSP=3Dy
CONFIG_SND_CS5530=3Dm
CONFIG_SND_DARLA20=3Dm
CONFIG_SND_GINA20=3Dm
CONFIG_SND_LAYLA20=3Dm
CONFIG_SND_DARLA24=3Dm
CONFIG_SND_GINA24=3Dm
CONFIG_SND_LAYLA24=3Dm
CONFIG_SND_MONA=3Dm
CONFIG_SND_MIA=3Dm
CONFIG_SND_ECHO3G=3Dm
CONFIG_SND_INDIGO=3Dm
CONFIG_SND_INDIGOIO=3Dm
CONFIG_SND_INDIGODJ=3Dm
CONFIG_SND_EMU10K1=3Dm
CONFIG_SND_EMU10K1X=3Dm
CONFIG_SND_ENS1370=3Dm
CONFIG_SND_ENS1371=3Dm
CONFIG_SND_ES1938=3Dm
CONFIG_SND_ES1968=3Dm
CONFIG_SND_FM801=3Dm
CONFIG_SND_FM801_TEA575X_BOOL=3Dy
CONFIG_SND_FM801_TEA575X=3Dm
CONFIG_SND_HDA_INTEL=3Dm
CONFIG_SND_HDA_HWDEP=3Dy
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=3Dy
CONFIG_SND_HDA_CODEC_ANALOG=3Dy
CONFIG_SND_HDA_CODEC_SIGMATEL=3Dy
CONFIG_SND_HDA_CODEC_VIA=3Dy
CONFIG_SND_HDA_CODEC_ATIHDMI=3Dy
CONFIG_SND_HDA_CODEC_NVHDMI=3Dy
CONFIG_SND_HDA_CODEC_INTELHDMI=3Dy
CONFIG_SND_HDA_ELD=3Dy
CONFIG_SND_HDA_CODEC_CONEXANT=3Dy
CONFIG_SND_HDA_CODEC_CMEDIA=3Dy
CONFIG_SND_HDA_CODEC_SI3054=3Dy
CONFIG_SND_HDA_GENERIC=3Dy
# CONFIG_SND_HDA_POWER_SAVE is not set
CONFIG_SND_HDSP=3Dm
CONFIG_SND_HDSPM=3Dm
CONFIG_SND_HIFIER=3Dm
CONFIG_SND_ICE1712=3Dm
CONFIG_SND_ICE1724=3Dm
CONFIG_SND_INTEL8X0=3Dm
CONFIG_SND_INTEL8X0M=3Dm
CONFIG_SND_KORG1212=3Dm
CONFIG_SND_MAESTRO3=3Dm
CONFIG_SND_MIXART=3Dm
CONFIG_SND_NM256=3Dm
CONFIG_SND_PCXHR=3Dm
CONFIG_SND_RIPTIDE=3Dm
CONFIG_SND_RME32=3Dm
CONFIG_SND_RME96=3Dm
CONFIG_SND_RME9652=3Dm
CONFIG_SND_SONICVIBES=3Dm
CONFIG_SND_TRIDENT=3Dm
CONFIG_SND_VIA82XX=3Dm
CONFIG_SND_VIA82XX_MODEM=3Dm
CONFIG_SND_VIRTUOSO=3Dm
CONFIG_SND_VX222=3Dm
CONFIG_SND_YMFPCI=3Dm
CONFIG_SND_USB=3Dy
CONFIG_SND_USB_AUDIO=3Dm
CONFIG_SND_USB_USX2Y=3Dm
CONFIG_SND_USB_CAIAQ=3Dm
CONFIG_SND_USB_CAIAQ_INPUT=3Dy
CONFIG_SND_USB_US122L=3Dm
CONFIG_SND_PCMCIA=3Dy
CONFIG_SND_VXPOCKET=3Dm
CONFIG_SND_PDAUDIOCF=3Dm
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dm
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dy
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=3Dy

#
# USB Input Devices
#
CONFIG_USB_HID=3Dy
CONFIG_HID_PID=3Dy
CONFIG_USB_HIDDEV=3Dy

#
# Special HID drivers
#
CONFIG_HID_COMPAT=3Dy
CONFIG_HID_A4TECH=3Dy
CONFIG_HID_APPLE=3Dy
CONFIG_HID_BELKIN=3Dy
CONFIG_HID_CHERRY=3Dy
CONFIG_HID_CHICONY=3Dy
CONFIG_HID_CYPRESS=3Dy
CONFIG_HID_EZKEY=3Dy
CONFIG_HID_GYRATION=3Dy
CONFIG_HID_LOGITECH=3Dy
CONFIG_LOGITECH_FF=3Dy
CONFIG_LOGIRUMBLEPAD2_FF=3Dy
CONFIG_HID_MICROSOFT=3Dy
CONFIG_HID_MONTEREY=3Dy
CONFIG_HID_NTRIG=3Dy
CONFIG_HID_PANTHERLORD=3Dy
CONFIG_PANTHERLORD_FF=3Dy
CONFIG_HID_PETALYNX=3Dy
CONFIG_HID_SAMSUNG=3Dy
CONFIG_HID_SONY=3Dy
CONFIG_HID_SUNPLUS=3Dy
CONFIG_GREENASIA_FF=3Dm
CONFIG_HID_TOPSEED=3Dy
CONFIG_THRUSTMASTER_FF=3Dm
CONFIG_ZEROPLUS_FF=3Dm
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dy
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=3Dy

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
CONFIG_USB_DEVICE_CLASS=3Dy
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=3Dy
CONFIG_USB_WUSB=3Dm
CONFIG_USB_WUSB_CBAF=3Dm
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=3Dy
CONFIG_USB_EHCI_HCD=3Dy
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
CONFIG_USB_EHCI_TT_NEWSCHED=3Dy
CONFIG_USB_OXU210HP_HCD=3Dy
CONFIG_USB_ISP116X_HCD=3Dy
CONFIG_USB_ISP1760_HCD=3Dy
CONFIG_USB_OHCI_HCD=3Dy
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_UHCI_HCD=3Dy
CONFIG_USB_U132_HCD=3Dm
CONFIG_USB_SL811_HCD=3Dy
CONFIG_USB_SL811_CS=3Dm
CONFIG_USB_R8A66597_HCD=3Dy
CONFIG_USB_WHCI_HCD=3Dm
CONFIG_USB_HWA_HCD=3Dm

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm
CONFIG_USB_WDM=3Dm
CONFIG_USB_TMC=3Dm

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=3Dy
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=3Dy
CONFIG_USB_STORAGE_FREECOM=3Dy
CONFIG_USB_STORAGE_ISD200=3Dy
CONFIG_USB_STORAGE_USBAT=3Dy
CONFIG_USB_STORAGE_SDDR09=3Dy
CONFIG_USB_STORAGE_SDDR55=3Dy
CONFIG_USB_STORAGE_JUMPSHOT=3Dy
CONFIG_USB_STORAGE_ALAUDA=3Dy
CONFIG_USB_STORAGE_ONETOUCH=3Dy
CONFIG_USB_STORAGE_KARMA=3Dy
CONFIG_USB_STORAGE_CYPRESS_ATACB=3Dy
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=3Dm
CONFIG_USB_MICROTEK=3Dm

#
# USB port drivers
#
CONFIG_USB_USS720=3Dm
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_EZUSB=3Dy
CONFIG_USB_SERIAL_GENERIC=3Dy
CONFIG_USB_SERIAL_AIRCABLE=3Dm
CONFIG_USB_SERIAL_ARK3116=3Dm
CONFIG_USB_SERIAL_BELKIN=3Dm
CONFIG_USB_SERIAL_CH341=3Dm
CONFIG_USB_SERIAL_WHITEHEAT=3Dm
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
CONFIG_USB_SERIAL_CP2101=3Dm
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
CONFIG_USB_SERIAL_FUNSOFT=3Dm
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
CONFIG_USB_SERIAL_IUU=3Dm
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
CONFIG_USB_SERIAL_KEYSPAN=3Dm
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
CONFIG_USB_SERIAL_MOS7720=3Dm
CONFIG_USB_SERIAL_MOS7840=3Dm
CONFIG_USB_SERIAL_MOTOROLA=3Dm
CONFIG_USB_SERIAL_NAVMAN=3Dm
CONFIG_USB_SERIAL_PL2303=3Dm
CONFIG_USB_SERIAL_OTI6858=3Dm
CONFIG_USB_SERIAL_SPCP8X5=3Dm
CONFIG_USB_SERIAL_HP4X=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
CONFIG_USB_SERIAL_SAFE_PADDED=3Dy
CONFIG_USB_SERIAL_SIEMENS_MPI=3Dm
CONFIG_USB_SERIAL_SIERRAWIRELESS=3Dm
CONFIG_USB_SERIAL_TI=3Dm
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
CONFIG_USB_SERIAL_OPTION=3Dm
CONFIG_USB_SERIAL_OMNINET=3Dm
CONFIG_USB_SERIAL_OPTICON=3Dm
CONFIG_USB_SERIAL_DEBUG=3Dm

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=3Dm
CONFIG_USB_EMI26=3Dm
CONFIG_USB_ADUTUX=3Dm
CONFIG_USB_SEVSEG=3Dm
CONFIG_USB_RIO500=3Dm
CONFIG_USB_LEGOTOWER=3Dm
CONFIG_USB_LCD=3Dm
CONFIG_USB_BERRY_CHARGE=3Dm
CONFIG_USB_LED=3Dm
CONFIG_USB_CYPRESS_CY7C63=3Dm
CONFIG_USB_CYTHERM=3Dm
CONFIG_USB_PHIDGET=3Dm
CONFIG_USB_PHIDGETKIT=3Dm
CONFIG_USB_PHIDGETMOTORCONTROL=3Dm
CONFIG_USB_PHIDGETSERVO=3Dm
CONFIG_USB_IDMOUSE=3Dm
CONFIG_USB_FTDI_ELAN=3Dm
CONFIG_USB_APPLEDISPLAY=3Dm
CONFIG_USB_SISUSBVGA=3Dm
CONFIG_USB_SISUSBVGA_CON=3Dy
CONFIG_USB_LD=3Dm
CONFIG_USB_TRANCEVIBRATOR=3Dm
CONFIG_USB_IOWARRIOR=3Dm
CONFIG_USB_TEST=3Dm
CONFIG_USB_ISIGHTFW=3Dm
CONFIG_USB_VST=3Dm
CONFIG_USB_ATM=3Dm
CONFIG_USB_SPEEDTOUCH=3Dm
CONFIG_USB_CXACRU=3Dm
CONFIG_USB_UEAGLEATM=3Dm
CONFIG_USB_XUSBATM=3Dm
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=3Dy
CONFIG_USB_GPIO_VBUS=3Dm
CONFIG_UWB=3Dm
CONFIG_UWB_HWA=3Dm
CONFIG_UWB_WHCI=3Dm
CONFIG_UWB_WLP=3Dm
CONFIG_UWB_I1480U=3Dm
CONFIG_UWB_I1480U_WLP=3Dm
CONFIG_MMC=3Dm
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=3Dm
CONFIG_MMC_BLOCK_BOUNCE=3Dy
CONFIG_SDIO_UART=3Dm
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=3Dm
CONFIG_MMC_SDHCI_PCI=3Dm
CONFIG_MMC_RICOH_MMC=3Dm
CONFIG_MMC_WBSD=3Dm
CONFIG_MMC_TIFM_SD=3Dm
CONFIG_MMC_SDRICOH_CS=3Dm
CONFIG_MEMSTICK=3Dm
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=3Dm

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=3Dm
CONFIG_MEMSTICK_JMICRON_38X=3Dm
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dm

#
# LED drivers
#
CONFIG_LEDS_ALIX2=3Dm
CONFIG_LEDS_PCA9532=3Dm
CONFIG_LEDS_GPIO=3Dm
CONFIG_LEDS_CLEVO_MAIL=3Dm
CONFIG_LEDS_PCA955X=3Dm
CONFIG_LEDS_WM8350=3Dm

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=3Dy
CONFIG_LEDS_TRIGGER_TIMER=3Dm
CONFIG_LEDS_TRIGGER_IDE_DISK=3Dy
CONFIG_LEDS_TRIGGER_HEARTBEAT=3Dm
CONFIG_LEDS_TRIGGER_BACKLIGHT=3Dm
CONFIG_LEDS_TRIGGER_DEFAULT_ON=3Dm
CONFIG_ACCESSIBILITY=3Dy
CONFIG_A11Y_BRAILLE_CONSOLE=3Dy
CONFIG_INFINIBAND=3Dm
CONFIG_INFINIBAND_USER_MAD=3Dm
CONFIG_INFINIBAND_USER_ACCESS=3Dm
CONFIG_INFINIBAND_USER_MEM=3Dy
CONFIG_INFINIBAND_ADDR_TRANS=3Dy
CONFIG_INFINIBAND_MTHCA=3Dm
CONFIG_INFINIBAND_MTHCA_DEBUG=3Dy
CONFIG_INFINIBAND_IPATH=3Dm
CONFIG_INFINIBAND_AMSO1100=3Dm
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
# CONFIG_INFINIBAND_CXGB3 is not set
CONFIG_MLX4_INFINIBAND=3Dm
CONFIG_INFINIBAND_NES=3Dm
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=3Dm
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=3Dy
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=3Dm
CONFIG_INFINIBAND_ISER=3Dm
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=3Dm
CONFIG_RTC_CLASS=3Dm

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=3Dy
CONFIG_RTC_INTF_PROC=3Dy
CONFIG_RTC_INTF_DEV=3Dy
CONFIG_RTC_INTF_DEV_UIE_EMUL=3Dy
CONFIG_RTC_DRV_TEST=3Dm

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=3Dm
CONFIG_RTC_DRV_DS1374=3Dm
CONFIG_RTC_DRV_DS1672=3Dm
CONFIG_RTC_DRV_MAX6900=3Dm
CONFIG_RTC_DRV_RS5C372=3Dm
CONFIG_RTC_DRV_ISL1208=3Dm
CONFIG_RTC_DRV_X1205=3Dm
CONFIG_RTC_DRV_PCF8563=3Dm
CONFIG_RTC_DRV_PCF8583=3Dm
CONFIG_RTC_DRV_M41T80=3Dm
CONFIG_RTC_DRV_M41T80_WDT=3Dy
CONFIG_RTC_DRV_S35390A=3Dm
CONFIG_RTC_DRV_FM3130=3Dm
CONFIG_RTC_DRV_RX8581=3Dm

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=3Dm
CONFIG_RTC_DRV_DS1286=3Dm
CONFIG_RTC_DRV_DS1511=3Dm
CONFIG_RTC_DRV_DS1553=3Dm
CONFIG_RTC_DRV_DS1742=3Dm
CONFIG_RTC_DRV_STK17TA8=3Dm
CONFIG_RTC_DRV_M48T86=3Dm
CONFIG_RTC_DRV_M48T35=3Dm
CONFIG_RTC_DRV_M48T59=3Dm
CONFIG_RTC_DRV_BQ4802=3Dm
CONFIG_RTC_DRV_V3020=3Dm
CONFIG_RTC_DRV_WM8350=3Dm
CONFIG_RTC_DRV_PCF50633=3Dm

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=3Dy

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=3Dm
CONFIG_DMA_ENGINE=3Dy

#
# DMA Clients
#
CONFIG_NET_DMA=3Dy
CONFIG_DMATEST=3Dm
CONFIG_DCA=3Dm
CONFIG_AUXDISPLAY=3Dy
# CONFIG_KS0108 is not set
CONFIG_UIO=3Dm
CONFIG_UIO_CIF=3Dm
CONFIG_UIO_PDRV=3Dm
CONFIG_UIO_PDRV_GENIRQ=3Dm
CONFIG_UIO_SMX=3Dm
CONFIG_UIO_SERCOS3=3Dm
CONFIG_STAGING=3Dy
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_SXG is not set
# CONFIG_ME4000 is not set
# CONFIG_MEILHAUS is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_USB_ATMEL is not set
# CONFIG_POCH is not set
# CONFIG_AGNX is not set
# CONFIG_OTUS is not set
CONFIG_RT2860=3Dm
CONFIG_RT2870=3Dm
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
# CONFIG_ALTERA_PCIE_CHDMA is not set
CONFIG_RTL8187SE=3Dm
# CONFIG_INPUT_MIMIO is not set
# CONFIG_TRANZPORT is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_RAM_CONSOLE is not set
# CONFIG_ANDROID_TIMED_GPIO is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
CONFIG_X86_PLATFORM_DEVICES=3Dy
CONFIG_ACER_WMI=3Dm
CONFIG_ASUS_LAPTOP=3Dm
CONFIG_FUJITSU_LAPTOP=3Dm
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_HP_WMI=3Dm
CONFIG_MSI_LAPTOP=3Dm
CONFIG_PANASONIC_LAPTOP=3Dm
CONFIG_COMPAL_LAPTOP=3Dm
CONFIG_SONY_LAPTOP=3Dm
CONFIG_SONYPI_COMPAT=3Dy
CONFIG_THINKPAD_ACPI=3Dm
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=3Dy
CONFIG_THINKPAD_ACPI_VIDEO=3Dy
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=3Dy
CONFIG_INTEL_MENLOW=3Dm
CONFIG_EEEPC_LAPTOP=3Dm
CONFIG_ACPI_WMI=3Dm
CONFIG_ACPI_ASUS=3Dm
CONFIG_ACPI_TOSHIBA=3Dm

#
# Firmware Drivers
#
CONFIG_EDD=3Dm
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
CONFIG_DELL_RBU=3Dm
CONFIG_DCDBAS=3Dm
CONFIG_DMIID=3Dy
CONFIG_ISCSI_IBFT_FIND=3Dy
CONFIG_ISCSI_IBFT=3Dm

#
# File systems
#
CONFIG_EXT2_FS=3Dy
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dy
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
CONFIG_EXT4_FS=3Dy
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
CONFIG_EXT4_FS_SECURITY=3Dy
CONFIG_JBD=3Dy
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=3Dy
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=3Dy
CONFIG_REISERFS_FS=3Dy
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
CONFIG_JFS_FS=3Dy
CONFIG_JFS_POSIX_ACL=3Dy
CONFIG_JFS_SECURITY=3Dy
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_FILE_LOCKING=3Dy
CONFIG_XFS_FS=3Dy
CONFIG_XFS_QUOTA=3Dy
CONFIG_XFS_POSIX_ACL=3Dy
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=3Dy
CONFIG_GFS2_FS_LOCKING_DLM=3Dm
CONFIG_OCFS2_FS=3Dm
CONFIG_OCFS2_FS_O2CB=3Dm
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=3Dm
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=3Dy
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_OCFS2_FS_POSIX_ACL=3Dy
CONFIG_BTRFS_FS=3Dm
CONFIG_BTRFS_FS_POSIX_ACL=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_QUOTA=3Dy
CONFIG_QUOTA_NETLINK_INTERFACE=3Dy
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=3Dm
CONFIG_QFMT_V1=3Dm
CONFIG_QFMT_V2=3Dm
CONFIG_QUOTACTL=3Dy
CONFIG_AUTOFS_FS=3Dm
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm
CONFIG_GENERIC_ACL=3Dy

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dy
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dy
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dy
CONFIG_MSDOS_FS=3Dy
CONFIG_VFAT_FS=3Dy
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dy
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=3Dy

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=3Dy
CONFIG_MISC_FILESYSTEMS=3Dy
CONFIG_ADFS_FS=3Dm
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=3Dm
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=3Dm
CONFIG_HFSPLUS_FS=3Dm
CONFIG_BEFS_FS=3Dm
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=3Dm
CONFIG_EFS_FS=3Dm
CONFIG_JFFS2_FS=3Dm
CONFIG_JFFS2_FS_DEBUG=3D0
CONFIG_JFFS2_FS_WRITEBUFFER=3Dy
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=3Dy
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=3Dy
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=3Dm
CONFIG_UBIFS_FS_XATTR=3Dy
CONFIG_UBIFS_FS_ADVANCED_COMPR=3Dy
CONFIG_UBIFS_FS_LZO=3Dy
CONFIG_UBIFS_FS_ZLIB=3Dy
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_CRAMFS=3Dm
CONFIG_SQUASHFS=3Dm
CONFIG_SQUASHFS_EMBEDDED=3Dy
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3D3
CONFIG_VXFS_FS=3Dm
CONFIG_MINIX_FS=3Dm
CONFIG_OMFS_FS=3Dm
CONFIG_HPFS_FS=3Dm
CONFIG_QNX4FS_FS=3Dm
CONFIG_ROMFS_FS=3Dy
CONFIG_SYSV_FS=3Dm
CONFIG_UFS_FS=3Dm
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dy
CONFIG_NFS_V3=3Dy
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=3Dm
CONFIG_NFSD_V3=3Dy
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=3Dy
CONFIG_LOCKD=3Dy
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dy
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dy
CONFIG_SUNRPC_GSS=3Dm
CONFIG_SUNRPC_XPRT_RDMA=3Dm
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=3Dm
CONFIG_RPCSEC_GSS_SPKM3=3Dm
CONFIG_SMB_FS=3Dm
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=3Dm
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=3Dy
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=3Dm
CONFIG_NCPFS_PACKET_SIGNING=3Dy
CONFIG_NCPFS_IOCTL_LOCKING=3Dy
CONFIG_NCPFS_STRONG=3Dy
CONFIG_NCPFS_NFS_NS=3Dy
CONFIG_NCPFS_OS2_NS=3Dy
CONFIG_NCPFS_SMALLDOS=3Dy
CONFIG_NCPFS_NLS=3Dy
CONFIG_NCPFS_EXTRAS=3Dy
CONFIG_CODA_FS=3Dm
CONFIG_AFS_FS=3Dm
# CONFIG_AFS_DEBUG is not set
CONFIG_9P_FS=3Dm

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=3Dy
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=3Dy
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=3Dy
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dy
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dy
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_UTF8=3Dy
CONFIG_DLM=3Dm
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_FRAME_WARN=3D0
CONFIG_MAGIC_SYSRQ=3Dy
CONFIG_UNUSED_SYMBOLS=3Dy
CONFIG_DEBUG_FS=3Dy
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_STACKTRACE=3Dy
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_MEMORY_INIT=3Dy
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
# CONFIG_FRAME_POINTER is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_NOP_TRACER=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_RING_BUFFER=3Dy
CONFIG_TRACING=3Dy

#
# Tracers
#
CONFIG_SYSPROF_TRACER=3Dy
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
CONFIG_STRICT_DEVMEM=3Dy
CONFIG_X86_VERBOSE_BOOTUP=3Dy
CONFIG_EARLY_PRINTK=3Dy
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
CONFIG_SECURITY=3Dy
CONFIG_SECURITYFS=3Dy
CONFIG_SECURITY_NETWORK=3Dy
CONFIG_SECURITY_NETWORK_XFRM=3Dy
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=3Dy
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=3D4096
CONFIG_XOR_BLOCKS=3Dy
CONFIG_ASYNC_CORE=3Dy
CONFIG_ASYNC_MEMCPY=3Dy
CONFIG_ASYNC_XOR=3Dy
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD=3Dy
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG=3Dm
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
CONFIG_CRYPTO_GF128MUL=3Dy
CONFIG_CRYPTO_NULL=3Dy
CONFIG_CRYPTO_CRYPTD=3Dm
CONFIG_CRYPTO_AUTHENC=3Dy
CONFIG_CRYPTO_TEST=3Dm

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=3Dm
CONFIG_CRYPTO_GCM=3Dm
CONFIG_CRYPTO_SEQIV=3Dm

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dy
CONFIG_CRYPTO_CTR=3Dm
CONFIG_CRYPTO_CTS=3Dm
CONFIG_CRYPTO_ECB=3Dy
CONFIG_CRYPTO_LRW=3Dy
CONFIG_CRYPTO_PCBC=3Dy
CONFIG_CRYPTO_XTS=3Dy

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=3Dy
CONFIG_CRYPTO_XCBC=3Dy

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dy
CONFIG_CRYPTO_CRC32C_INTEL=3Dm
CONFIG_CRYPTO_MD4=3Dy
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_MICHAEL_MIC=3Dy
CONFIG_CRYPTO_RMD128=3Dm
CONFIG_CRYPTO_RMD160=3Dm
CONFIG_CRYPTO_RMD256=3Dm
CONFIG_CRYPTO_RMD320=3Dm
CONFIG_CRYPTO_SHA1=3Dy
CONFIG_CRYPTO_SHA256=3Dy
CONFIG_CRYPTO_SHA512=3Dy
CONFIG_CRYPTO_TGR192=3Dy
CONFIG_CRYPTO_WP512=3Dy

#
# Ciphers
#
CONFIG_CRYPTO_AES=3Dy
CONFIG_CRYPTO_AES_X86_64=3Dy
CONFIG_CRYPTO_ANUBIS=3Dy
CONFIG_CRYPTO_ARC4=3Dy
CONFIG_CRYPTO_BLOWFISH=3Dy
CONFIG_CRYPTO_CAMELLIA=3Dy
CONFIG_CRYPTO_CAST5=3Dy
CONFIG_CRYPTO_CAST6=3Dy
CONFIG_CRYPTO_DES=3Dy
CONFIG_CRYPTO_FCRYPT=3Dy
CONFIG_CRYPTO_KHAZAD=3Dy
CONFIG_CRYPTO_SALSA20=3Dm
CONFIG_CRYPTO_SALSA20_X86_64=3Dm
CONFIG_CRYPTO_SEED=3Dy
CONFIG_CRYPTO_SERPENT=3Dy
CONFIG_CRYPTO_TEA=3Dy
CONFIG_CRYPTO_TWOFISH=3Dy
CONFIG_CRYPTO_TWOFISH_COMMON=3Dy
CONFIG_CRYPTO_TWOFISH_X86_64=3Dy

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=3Dy
CONFIG_CRYPTO_LZO=3Dm

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=3Dm
CONFIG_CRYPTO_HW=3Dy
CONFIG_CRYPTO_DEV_HIFN_795X=3Dm
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=3Dy
CONFIG_HAVE_KVM=3Dy
CONFIG_HAVE_KVM_IRQCHIP=3Dy
CONFIG_VIRTUALIZATION=3Dy
CONFIG_KVM=3Dm
CONFIG_KVM_INTEL=3Dm
CONFIG_KVM_AMD=3Dm
# CONFIG_KVM_TRACE is not set
CONFIG_VIRTIO=3Dm
CONFIG_VIRTIO_RING=3Dm
CONFIG_VIRTIO_PCI=3Dm
CONFIG_VIRTIO_BALLOON=3Dm

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_GENERIC_FIND_NEXT_BIT=3Dy
CONFIG_GENERIC_FIND_LAST_BIT=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dy
CONFIG_CRC_T10DIF=3Dm
CONFIG_CRC_ITU_T=3Dy
CONFIG_CRC32=3Dy
CONFIG_CRC7=3Dm
CONFIG_LIBCRC32C=3Dy
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
CONFIG_LZO_COMPRESS=3Dm
CONFIG_LZO_DECOMPRESS=3Dm
CONFIG_REED_SOLOMON=3Dm
CONFIG_REED_SOLOMON_DEC16=3Dy
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dm
CONFIG_TEXTSEARCH_BM=3Dm
CONFIG_TEXTSEARCH_FSM=3Dm
CONFIG_PLIST=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CHECK_SIGNATURE=3Dy

--=20
mailto:av1474@comtv.ru
--33734824-907845940-1259954921=:4703--
