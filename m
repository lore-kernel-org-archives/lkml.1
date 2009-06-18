Return-Path: <linux-kernel-owner+w=401wt.eu-S1751436AbZFREFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbZFREFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 00:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbZFREFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 00:05:43 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:55425 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZFREFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 00:05:41 -0400
Message-ID: <4A39BD13.2050206@nodomain.org>
Date: Thu, 18 Jun 2009 05:05:39 +0100
From: Tony Hoyle <tmh@nodomain.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Bug(?) in linux kernel EFI support
References: <4A39AD4C.6020807@nodomain.org>
In-Reply-To: <4A39AD4C.6020807@nodomain.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 3:58 am, Tony Hoyle <t...@nodomain.org> wrote:
 > Hi,
 >
 > I'm building kernels on an embedded system which uses an odd version of
 > EFI (elilo/egrub don't run for example, only its own shipped boot.efi
 > that loads a raw vmlinux).  I've been unable to get it to boot with any
 > kernel > 2.6.24.7 - as in it doesn't start up far enough to get 
netconsole.
 >
More info - this is the boot from a 'correct' build (the one just before 
the breaking commit.. lots of warnings but it does boot:

Tony

[    0.000000] Linux version 2.6.24-19-lpia (root@sisko) (gcc version 
4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #36 SMP Thu Jun 18 03:42:56 UTC 2009
[    0.000000] EFI: EFI v0.00 by American Megatrends
[    0.000000]  ACPI 2.0=0x1fa08f90
[    0.000000] 506MB LOWMEM available.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   129776
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   129776
[    0.000000] DMI not present or invalid.
[    0.000000] ACPI: RSDP 1FA08F90, 0024 (r2 ALASKA)
[    0.000000] ACPI: XSDT 1FA07F10, 005C (r1 ALASKA CRNBEACH  6222004 
MSFT    10013)
[    0.000000] ACPI: FACP 1F9E0D90, 00F4 (r4 ALASKA CRNBEACH  6222004 
MSFT    10013)
[    0.000000] ACPI Warning (tbfadt-0442): Optional field 
"Pm2ControlBlock" has zero address or length: 00000000000009F4/0 [20070126]
[    0.000000] ACPI: DSDT 1FA01010, 4112 (r1 ALASKA CRNBEACH        0 
INTL 20051117)
[    0.000000] ACPI: FACS 1FA0BD40, 0040
[    0.000000] ACPI: APIC 1FA08E90, 005C (r2 ALASKA CRNBEACH  6222004 
MSFT    10013)
[    0.000000] ACPI: MCFG 1FA0FD10, 003C (r1 A M I  OEMMCFG   6222004 
MSFT       97)
[    0.000000] ACPI: HPET 1FA0FC90, 0038 (r1 A M I  OEMHPET   6222004 
AMI.        3)
[    0.000000] ACPI: SSDT 1F9FC510, 04CE (r2  PmRef    CpuPm     3000 
INTL 20051117)
[    0.000000] ACPI: SSDT 1F9E2A10, 0232 (r2  PmRef  Cpu0Tst     3000 
INTL 20051117)
[    0.000000] ACPI: SSDT 1FA0BA10, 00A0 (r2  PmRef  Cpu1Tst     3000 
INTL 20051117)
[    0.000000] ACPI: no DMI BIOS year, acpi=force is required to enable ACPI
[    0.000000] ACPI: acpi=force override
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 7:12 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 7:12 APIC version 20
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 10100000 (gap: 
10000000:00400000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 128763
[    0.000000] Kernel command line: acpi=force vga=0301 
netconsole=6665@192.168.44.112/eth0,6666@192.168.44.111/00:50:56:3f:58:50 
root=/dev/mmcblk0p2 rootdelay=2
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1330.055 MHz processor.
[    0.004000] Console: colour dummy device 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 
bytes)
[    0.004000] Memory: 508684k/519104k available (2775k kernel code, 
9268k reserved, 1213k data, 256k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[    0.004000]     vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xdfaf0000   ( 506 MB)
[    0.004000]       .init : 0xc04ec000 - 0xc052c000   ( 256 kB)
[    0.004000]       .data : 0xc03b5d5d - 0xc04e5378   (1213 kB)
[    0.004000]       .text : 0xc0100000 - 0xc03b5d5d   (2775 kB)
[    0.004000] Checking if this processor honours the WP bit even in 
supervisor mode... Ok.
[    0.004000] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, 
CPUs=2, Nodes=1
[    0.080008] Calibrating delay using timer specific routine.. 2662.40 
BogoMIPS (lpj=5324808)
[    0.080053] allocation failed: out of vmalloc space - use 
vmalloc=<size> to increase size.
[    0.080069] EFI: ioremap of 0x1FB00000 failed
[    0.081015] Mount-cache hash table entries: 512
[    0.081235] monitor/mwait feature present.
[    0.081247] using mwait in idle threads.
[    0.081259] CPU: L1 I cache: 32K, L1 D cache: 24K
[    0.081269] CPU: L2 cache: 512K
[    0.081278] CPU: Physical Processor ID: 0
[    0.081303] Compat vDSO mapped to ffffe000.
[    0.081325] Checking 'hlt' instruction... OK.
[    0.096483] SMP alternatives: switching to UP code
[    0.097189] ACPI: Core revision 20070126
[    0.103527] CPU0: Intel(R) Atom(TM) CPU Z520   @ 1.33GHz stepping 02
[    0.103573] SMP alternatives: switching to SMP code
[    0.104017] Booting processor 1/1 ip 3000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 2659.97 
BogoMIPS (lpj=5319948)
[    0.004000] monitor/mwait feature present.
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 24K
[    0.004000] CPU: L2 cache: 512K
[    0.004000] CPU: Physical Processor ID: 0
[    0.192321] CPU1: Intel(R) Atom(TM) CPU Z520   @ 1.33GHz stepping 02
[    0.192413] Total of 2 processors activated (5322.37 BogoMIPS).
[    0.192519] ENABLING IO-APIC IRQs
[    0.192764] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
[    0.236014] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.236034] Brought up 2 CPUs
[    0.004006] net_namespace: 164 bytes
[    0.004006] Time:  1:38:44  Date: 01/01/05
[    0.004006] NET: Registered protocol family 16
[    0.004006] ACPI: bus type pci registered
[    0.004006] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.004006] PCI: Not using MMCONFIG.
[    0.089426] PCI: Using configuration type 1
[    0.089437] Setting up standard PCI resources
[    0.102218] ACPI: BIOS _OSI(Linux) query ignored
[    0.102235] ACPI: [please extract dmidecode output]
[    0.102246] ACPI: Please send DMI info above to 
linux-acpi@vger.kernel.org
[    0.102258] ACPI: If "acpi_osi=Linux" works better, please notify 
linux-acpi@vger.kernel.org
[    0.102934] ACPI: Interpreter enabled
[    0.102946] ACPI: (supports S0 S3 S4 S5)
[    0.102987] ACPI: Using IOAPIC for interrupt routing
[    0.103730] ACPI: BIOS _OSI(Linux) query ignored
[    0.103745] ACPI: [please extract dmidecode output]
[    0.103755] ACPI: Please send DMI info above to 
linux-acpi@vger.kernel.org
[    0.103767] ACPI: If "acpi_osi=Linux" works better, please notify 
linux-acpi@vger.kernel.org
[    0.352195] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.133742] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.134084] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.134418] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.134751] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.135089] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.135420] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.135753] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.136103] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.136439] ACPI: Power Resource [FN00] (off)
[    0.136563] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.136654] pnp: PnP ACPI init
[    0.136677] ACPI: bus type pnp registered
[    0.142856] pnp: PnP ACPI: found 12 devices
[    0.142872] ACPI: ACPI bus type pnp unregistered
[    0.143302] SCSI subsystem initialized
[    0.143683] usbcore: registered new interface driver usbfs
[    0.143791] usbcore: registered new interface driver hub
[    0.143916] usbcore: registered new device driver usb
[    0.144612] PCI: Using ACPI for IRQ routing
[    0.144627] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[    0.416076] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.416097] hpet0: 3 64-bit timers, 14318180 Hz
[    0.420029] Time: tsc clocksource has been installed.
[    0.432072] system 00:01: iomem range 0xe0000000-0xefffffff could not 
be reserved
[    0.432092] system 00:01: iomem range 0x1fb00000-0x1fbfffff could not 
be reserved
[    0.432109] system 00:01: iomem range 0x1fc00000-0x1fffffff could not 
be reserved
[    0.432126] system 00:01: iomem range 0x20000000-0x7fffffff could not 
be reserved
[    0.432149] system 00:02: ioport range 0xa20-0xa3f has been reserved
[    0.432162] system 00:02: ioport range 0xa00-0xa3f could not be reserved
[    0.432175] system 00:02: ioport range 0xa10-0xa1f has been reserved
[    0.432188] system 00:02: ioport range 0xa40-0xa4f has been reserved
[    0.432211] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.432231] system 00:08: ioport range 0x810-0x810 has been reserved
[    0.432244] system 00:08: ioport range 0x800-0x80f has been reserved
[    0.432257] system 00:08: ioport range 0xffff-0xffff has been reserved
[    0.432276] system 00:09: ioport range 0x900-0x97f has been reserved
[    0.432289] system 00:09: ioport range 0x400-0x40f has been reserved
[    0.432302] system 00:09: ioport range 0x480-0x4bf has been reserved
[    0.432317] system 00:09: iomem range 0xfec00000-0xfec85fff could not 
be reserved
[    0.432339] system 00:09: iomem range 0xfed1c000-0xfed1ffff could not 
be reserved
[    0.432355] system 00:09: iomem range 0xc0000-0xdffff has been reserved
[    0.432368] system 00:09: iomem range 0xe0000-0xeffff has been reserved
[    0.432381] system 00:09: iomem range 0xf0000-0xfffff has been reserved
[    0.432395] system 00:09: iomem range 0xffc00000-0xffffffff could not 
be reserved
[    0.432420] system 00:0b: iomem range 0x1faf0000-0x1fafffff could not 
be reserved
[    0.227304] PCI: Bridge: 0000:00:1c.0
[    0.227319]   IO window: e000-efff
[    0.227332]   MEM window: d0000000-d00fffff
[    0.227344]   PREFETCH window: fef00000-feffffff
[    0.227382] PCI: Enabling device 0000:00:1c.0 (0000 -> 0003)
[    0.227405] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.227452] NET: Registered protocol family 2
[    0.276135] IP route cache hash table entries: 4096 (order: 2, 16384 
bytes)
[    0.276563] TCP established hash table entries: 16384 (order: 5, 
131072 bytes)
[    0.276736] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    0.276910] TCP: Hash tables configured (established 16384 bind 16384)
[    0.276923] TCP reno registered
[    0.290088] audit: initializing netlink socket (disabled)
[    0.290121] audit(3071822179.520:1): initialized
[    0.295970] fuse init (API version 7.9)
[    0.296660] io scheduler noop registered
[    0.296674] io scheduler anticipatory registered
[    0.296684] io scheduler deadline registered
[    0.296832] io scheduler cfq registered (default)
[    0.380097] Real Time Clock Driver v1.12ac
[    0.380516] Linux agpgart interface v0.102
[    0.380720] intelfb: Framebuffer driver for Intel(R) 
830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
[    0.380739] intelfb: Version 0.9.4
[    0.380845] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.380876] intelfb: Cannot reserve MMIO region.
[    0.381002] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
[    0.383960] RAMDISK driver initialized: 16 RAM disks of 65536K size 
1024 blocksize
[    0.384015] r8169 Gigabit Ethernet driver 2.2LK loaded
[    0.384116] PCI: Enabling device 0000:01:00.0 (0000 -> 0003)
[    0.384136] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.384194] r8169 0000:01:00.0: no MSI. Back to INTx.
[    0.384682] eth0: RTL8168c/8111c at 0xe086a000, 00:0e:8e:22:ab:5f, 
XID 3c4000c0 IRQ 16
[    0.386500] netconsole: local port 6665
[    0.386512] netconsole: local IP 192.168.44.112
[    0.386521] netconsole: interface eth0
[    0.386530] netconsole: remote port 6666
[    0.386539] netconsole: remote IP 192.168.44.111
[    0.386552] netconsole: remote ethernet address 00:50:56:3f:58:50
[    0.386565] netconsole: device eth0 not up yet, forcing it
[    0.386835] r8169: eth0: link down
[    0.619876] r8169: eth0: link down
[    3.670232] r8169: eth0: link up
[    3.456239] console [netcon0] enabled
[    3.458016] netconsole: network logging started
[    3.458027] Linux video capture interface: v2.00
[    3.691267] Driver 'sd' needs updating - please use bus_type methods
[    3.691668] PCI: Enabling device 0000:00:1f.1 (0000 -> 0001)
[    3.692192] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, 
low) -> IRQ 19
[    3.692257] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.692499] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    3.696445] ehci_hcd 0000:00:1d.7: debug port 1
[    3.696484] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xd01c4000
[    3.712250] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[    3.712670] usb usb1: configuration #1 chosen from 1 choice
[    3.712791] hub 1-0:1.0: USB hub found
[    3.712816] hub 1-0:1.0: 8 ports detected
[    3.728605] USB Universal Host Controller Interface driver v3.0
[    3.728676] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    3.728713] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.728933] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    3.728982] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000f040
[    3.729338] usb usb2: configuration #1 chosen from 1 choice
[    3.729461] hub 2-0:1.0: USB hub found
[    3.729486] hub 2-0:1.0: 2 ports detected
[    3.744428] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, 
low) -> IRQ 17
[    3.744466] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.744688] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    3.744739] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000f020
[    3.745095] usb usb3: configuration #1 chosen from 1 choice
[    3.745215] hub 3-0:1.0: USB hub found
[    3.745239] hub 3-0:1.0: 2 ports detected
[    3.760422] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, 
low) -> IRQ 18
[    3.760464] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.760684] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    3.760734] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f000
[    3.761094] usb usb4: configuration #1 chosen from 1 choice
[    3.761232] hub 4-0:1.0: USB hub found
[    3.761256] hub 4-0:1.0: 2 ports detected
[    3.540227] usb 1-4: new high speed USB device using ehci_hcd and 
address 2
[    3.792508] Initializing USB Mass Storage driver...
[    3.820938] usb 1-4: configuration #1 chosen from 1 choice
[    3.821153] hub 1-4:1.0: USB hub found
[    3.821299] hub 1-4:1.0: 4 ports detected
[    3.856277] usb 1-5: new high speed USB device using ehci_hcd and 
address 3
[    3.893947] usb 1-5: configuration #1 chosen from 1 choice
[    3.992270] usb 4-2: new full speed USB device using uhci_hcd and 
address 2
[    4.014273] usb 4-2: configuration #1 chosen from 1 choice
[    4.096262] usb 1-4.2: new high speed USB device using ehci_hcd and 
address 5
[    4.134764] usb 1-4.2: configuration #1 chosen from 1 choice
[    4.208370] usb 1-4.3: new full speed USB device using ehci_hcd and 
address 6
[    4.243755] usb 1-4.3: configuration #1 chosen from 1 choice
[    4.244091] hub 1-4.3:1.0: USB hub found
[    4.244485] hub 1-4.3:1.0: 3 ports detected
[    3.760241] scsi0 : SCSI emulation for USB Mass Storage devices
[    4.348608] usb 1-4.3.3: new full speed USB device using ehci_hcd and 
address 7
[    4.391626] usb 1-4.3.3: configuration #1 chosen from 1 choice
[    3.808244] usbcore: registered new interface driver usb-storage
[    3.808244] USB Mass Storage support registered.
[    3.808244] mice: PS/2 mouse device common for all mice
[    3.808244] i2c /dev entries driver
[    3.808244] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 
soft_margin=60 sec (nowayout= 0)
[    3.808244] cpuidle: using governor ladder
[    3.808244] cpuidle: using governor menu
[    3.808244] sdhci: Secure Digital Host Controller Interface driver
[    3.808244] sdhci: Copyright(c) Pierre Ossman
[    3.808244] sdhci: SDHCI controller found at 0000:00:1e.0 [8086:811c] 
(rev 7)
[    3.808244] ACPI: PCI Interrupt 0000:00:1e.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    3.808397] mmc0: SDHCI at 0xd01c4600 irq 16 DMA
[    3.808428] sdhci: SDHCI controller found at 0000:00:1e.1 [8086:811d] 
(rev 7)
[    3.808454] ACPI: PCI Interrupt 0000:00:1e.1[B] -> GSI 17 (level, 
low) -> IRQ 17
[    3.812319] mmc1: SDHCI at 0xd01c4500 irq 17 DMA
[    3.812350] sdhci: SDHCI controller found at 0000:00:1e.2 [8086:811e] 
(rev 7)
[    3.812376] ACPI: PCI Interrupt 0000:00:1e.2[C] -> GSI 18 (level, 
low) -> IRQ 18
[    3.812539] mmc2: SDHCI at 0xd01c4400 irq 18 DMA
[    3.812661] ricoh-mmc: Ricoh MMC Controller disabling driver
[    3.812681] ricoh-mmc: Copyright(c) Philip Langdale
[    3.812999] usbcore: registered new interface driver hiddev
[    3.819697] input: AmSC OpenPeak Touchscreen Hyup02 as 
/devices/pci0000:00/0000:00:1d.2/usb4/4-2/4-2:1.0/input/input0
[    4.437476] input,hidraw0: USB HID v1.11 Mouse [AmSC OpenPeak 
Touchscreen Hyup02] on usb-0000:00:1d.2-2
[    4.441102] input: Mitsumi Electric Apple Extended USB Keyboard as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4.3/1-4.3.3/1-4.3.3:1.0/input/input1
[    4.476474] input,hidraw1: USB HID v1.10 Keyboard [Mitsumi Electric 
Apple Extended USB Keyboard] on usb-0000:00:1d.7-4.3.3
[    4.480059] mmc2: new MMC card at address 0001
[    4.480239] mmcblk0: mmc2:0001  1004032KiB
[    4.480657]  mmcblk0:<6>input: Mitsumi Electric Apple Extended USB 
Keyboard as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4.3/1-4.3.3/1-4.3.3:1.1/input/input2
[    3.892727]  p1 p2 p3 p4
[    4.516482] input,hidraw2: USB HID v1.10 Device [Mitsumi Electric 
Apple Extended USB Keyboard] on usb-0000:00:1d.7-4.3.3
[    4.516616] usbcore: registered new interface driver usbhid
[    4.516637] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    4.516753] Advanced Linux Sound Architecture Driver Version 1.0.15 
(Tue Nov 20 19:16:42 2007 UTC).
[    4.517109] usbcore: registered new interface driver snd-usb-audio
[    4.517130] ALSA device list:
[    4.517140]   No soundcards found.
[    4.517991] TCP cubic registered
[    4.518041] NET: Registered protocol family 1
[    4.518073] NET: Registered protocol family 17
[    4.518102] Starting balanced_irq
[    4.518153] Using IPI No-Shortcut mode
[    4.518382]   Magic number: 5:724:608
[    4.518504]   hash matches device ptyaf
[    4.518629] Waiting 2sec before mounting root device...
