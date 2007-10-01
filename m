Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbXJAVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbXJAVf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbXJAVfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:35:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:45421 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbXJAVfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TU/v909OZ2bogpOaHT7/HqIpiXTfVdKmUG8i1V+6x6NbNNxpRhT04wQTLy08QbMaKbgYHFBFqYZu10e4LR0AV8jcABuh5KIh3Pvh9m4119OTFmfNO20Y/+7IgLXjQxzMYgwN4kGI8hCk5WtDy6vWnDg4dc740ZVjBdGe/KKf9jg=
Message-ID: <ee8d22b80710011435k9c62712v125935b1e2b8e8c1@mail.gmail.com>
Date: Mon, 1 Oct 2007 16:35:11 -0500
From: "Luis Garcia-Vega" <luis.garciavega@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel panics when SMP-booting on a Nexcom Peak 7220VL2G
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

 I'm getting kernel panics when I boot a pair of  Xeon 2.8GHz on a
Nexcom PEAK 7220VL2G board (one of those system on a board setups).
I'm running the stock Red Hat Enterprise 4.5 kernel.  I mentioned a
pair, because the system boots fine with the Uniprocessor kernel.  I
thought it could be a ACPI issue, but after a few days of trying
different boot options, i was still getting errors.
And without further ado, here's the serial port capture.

Linux version 2.6.9-55.ELsmp (brewbuilder@ls20-bc2-14.build.redhat.com)
(gcc version 3.4.6 20060404 (Red Hat 3.4.6-3)) #1 SMP Fri Apr 20
17:03:35 EDT 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f4a10
Using x86 segment limits to approximate NX protection
DMI 2.2 present.
Using APIC driver default
ACPI: PM-Timer IO Port: 0x408
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
Enabling APIC mode:  Flat.  Using 0 I/O APICs
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfec82000] gsi_base[24])
IOAPIC[1]: apic_id 5, version 32, address 0xfec82000, GSI 24-47
ACPI: IOAPIC (id[0x06] address[0xfec82400] gsi_base[48])
IOAPIC[2]: apic_id 6, version 32, address 0xfec82400, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists
Kernel command line: ro root=/dev/vg01/lv01 console=ttyS0 1
Initializing CPU#0
CPU 0 irqstacks, hard=c03f1000 soft=c03d1000
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 2801.037 MHz processor.
Using pmtmr for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1032804k/1048512k available (1882k kernel code, 15060k reserved,
761k data, 188k init, 131008k highmem)
Calibrating delay using timer specific routine.. 5606.12 BogoMIPS
(lpj=2803064)
Security Scaffold v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
There is already a security framework initialized, register_security
failed.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU0: Initial APIC ID: 0, Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
CPU0: Intel(R) Xeon(TM) CPU 2.80GHz stepping 05
per-CPU timeslice cutoff: 1461.72 usecs.
task migration cache decay timeout: 1 msecs.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c03f2000 soft=c03d2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5599.44 BogoMIPS
(lpj=2799722)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU1: Initial APIC ID: 1, Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.80GHz stepping 05
Booting processor 2/6 eip 3000
CPU 2 irqstacks, hard=c03f3000 soft=c03d3000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5599.57 BogoMIPS
(lpj=2799786)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU2: Initial APIC ID: 6, Physical Processor ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 2.80GHz stepping 05
Booting processor 3/7 eip 3000
CPU 3 irqstacks, hard=c03f4000 soft=c03d4000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5599.46 BogoMIPS
(lpj=2799730)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU3: Initial APIC ID: 7, Physical Processor ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 2.80GHz stepping 05
Total of 4 processors activated (22404.60 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=2 pin2=-1
checking TSC synchronization across 4 CPUs: passed.
Brought up 4 CPUs
zapping low mappings.
checking if image is initramfs... it is
Freeing initrd memory: 1330k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb270, last bus=4
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20040816
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0,
disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 177
ACPI: PCI Interrupt 0000:02:0c.0[A] -> GSI 48 (level, low) -> IRQ 185
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 24 (level, low) -> IRQ 193
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 28 (level, low) -> IRQ 201
ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 17 (level, low) -> IRQ 177
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
audit(1191231674.862:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Initializing Cryptographic API
ksign: Installing public key data
Loading keyring
- Added public key 3629C5F482105A7
- User ID: Red Hat, Inc. (Kernel Module GPG key)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Fan [FAN] (on)
ACPI: Processor [CPU0] (supports C1)
ACPI: Processor [CPU1] (supports C1)
ACPI: Processor [CPU2] (supports C1)
ACPI: Processor [CPU3] (supports C1)
ACPI: Thermal Zone [THRM] (40 C)
Real Time Clock Driver v1.12
Linux agpgart interface v0.100 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 68 ports, IRQ sharing
enabled
ÿttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
ICH3: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 169
ICH3: chipset revision 2
ICH3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:pio
hda: HDS728080PLAT20, ATA DISK drive
Using cfq io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: SONY CD-ROM CDU5225, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 1024KiB
hda: 160836480 sectors (82348 MB) w/1719KiB Cache, CHS=16383/255/63,
UDMA(100)
 hda: hda1 hda2 hda3
hdc: ATAPI 52X CD-ROM drive, 96kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard on isa0060/serio0
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 262144 (order: 9, 3145728 bytes)
TCP: Hash tables configured (established 262144 bind 262144)
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI wakeup devices:
PCI0 HUB0 UAR1 USB0 USB1 MODM
ACPI: (supports S0 S1)
Freeing unused kernel memory: 188k freed
Red Hat nash version 4.2.1.10 starting
Mounted SCSI subsystem initialized
/proc filesystem
Mounting sysfsdevice-mapper: 4.5.5-ioctl (2006-12-01) initialised:
dm-devel@redhat.com
Creating /dev
Starting udev
Loading scsi_mod.ko module
Loading sd_mod.ko mocdrom: open failed.
dule
Loading libata.ko module
Loading ata_piix.ko module
Loading dm-mod.ko module
Loading jbd.ko module
Loading ext3.ko module
Loading dm-mirror.ko module
Loading dm-zero.ko module
Loading dm-snapshot.ko module
Making device-mapper control node
Scanning logical volumes
  Reading all physical volumes.  This may take a while...
  Found volume group "vg01" using metadata tkjournald starting.  Commit
interval 5 seconds
ype lvm2
ActivaEXT3-fs: mounted filesystem with ordered data mode.
ting logical volumes
  11 logical volume(s) in volume group "vg01" now active
Creating root device
Mounting root filesystem
Switching to new root
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
INIT: version 2.85 booting
------------[ cut here ]------------
Debug: sleeping function called from invalid context at mm/rmap.c:85
in_atomic():0[expected: 0], irqs_disabled():1
 [<c012025e>] __might_sleep+0x7d/0x87
 [<c0152708>] anon_vma_prepare+0x1c/0xc0
 [<c014daed>] do_wp_page+0x119/0x371
 [<c014e9d0>] handle_mm_fault+0x139/0x193
 [<c011b01b>] do_page_fault+0x1ae/0x5c6
 [<c012dd08>] sys_rt_sigaction+0xdd/0xf2
 [<c012cfe5>] sys_rt_sigprocmask+0x135/0x145
 [<c011ae6d>] do_page_fault+0x0/0x5c6
 [<c02d69db>] error_code+0x2f/0x38
Unable to handle kernel NULL pointer dereference at virtual address
00000010
 printing eip:
c011d3b4
*pde = 3712f001
kernel BUG at mm/filemap.c:470!
invalid operand: 0000 [#1]
SMP
Modules linked in: dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
ata_piix libata sd_mod scsi_mod
CPU:    2
EIP:    0060:[<c0140840>]    Not tainted VLI
EFLAGS: 00010246   (2.6.9-55.ELsmp)
EIP is at unlock_page+0xd/0x1c
eax: 00000000   ebx: c180bb18   ecx: 00000019   edx: c17fba80
esi: fff8b3f0   edi: f7395260   ebp: c17fba80   esp: f734fe6c
ds: 007b   es: 007b   ss: 0068
Process hotplug (pid: 593, threadinfo=f734f000 task=f709e3b0)
Stack: c014da68 3f924067 00000000 00000000 00000000 ffffffff ffffffff
7fffffff
       00000163 80000000 00000000 00000000 0987e9b0 f718c9bc f738e980
f738e980
       f7395260 00000000 fff8b3f0 f7395260 0987e9b0 c014e9d0 fff8b3f0
f7395260
Call Trace:
 [<c014da68>] do_wp_page+0x94/0x371
 [<c014e9d0>] handle_mm_fault+0x139/0x193
 [<c011b01b>] do_page_fault+0x1ae/0x5c6
 [<c02d3d56>] schedule+0x84e/0x8ec
 [<c02d3d86>] schedule+0x87e/0x8ec
 [<c012ce96>] sigprocmask+0xb0/0xca
 [<c012cf48>] sys_rt_sigprocmask+0x98/0x145
 [<c011ae6d>] do_page_fault+0x0/0x5c6
 [<c02d69db>] error_code+0x2f/0x38
Code: 3c 19 00 0f a3 33 19 c0 85 c0 75 a5 8d 54 24 28 89 f8 e8 b1 fc fd
ff 83 c4 40 5b 5e 5f c3 89 c2 f0 0f ba 30 00 19 c0 85 c0 75 08 <0f> 0b
d6 01 3b 94 2e c0 89 d0 e9 fd fe ff ff 53 89 c3 f0 0f ba
 <1>Oops: 0000 [#2]
SMP
Modules linked in: dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
ata_piix libata sd_mod scsi_mod
CPU:    3
EIP:    0060:[<c011d3b4>]    Not tainted VLI
EFLAGS: 00010082   (2.6.9-55.ELsmp)
Fatal exception: panic in 5 seconds
bad: scheduling while atomic!
 [<c02d3535>]EIP is at wake_up_new_task+0x1d/0x22f
eax: 00000000   ebx: f7175e80   ecx: f7e97d80   edx: 01200011
esi: c03c2e80   edi: c03c2e80   ebp: f73f6f74   esp: f73f6f54
ds: 007b   es: 007b   ss: 0068
Process default.hotplug (pid: 602, threadinfo=f73f6000 task=f6c030b0)
Stack: 01200011 f73f6fc4 01200011 01200011 00000282 f7175e80 01200011
00000000
       00000260 c0121ce0 bff28254 00000246 00000000 bff28370 f73f6fa8
f73f6f98
       f73f6fa8 bff282f0 c012cfe5 01200011 00000000 b7fcd708 f73f6000
c010498a
Call Trace:
 [<c0121ce0>] do_fork+0x108/0x175
 [<c012cfe5>] sys_rt_sigprocmask+0x135/0x145
 [<c010498a>] sys_clone+0x22/0x26
 [<c02d5ee3>] schedule+0x2d/0x8ec
 [<c01c33e1>] syscall_call+0x7/0xb
Code: c0 e8 57 10 00 00 fb eb 01 fb 5b 5e 5d c3 55 89 e5 57 56 53 83 ec
14 89 c3 89 55 ec 9c 8f 45 f0 fa 8b 43 04 bf 80 2e 3c c0 89 fe <8b> 40
10 03 34 85 20 e1 3c c0 89 f0 e8 56 76 1b 00 8b 43 04 8b
 <0>Fatal exception: panic in 5 seconds
 vsnprintf+0x448/0x488
 [<c0129e95>] __mod_timer+0x101/0x10b
 [<c02d4662>] schedule_timeout+0x139/0x154
 [<c012a73a>] process_timeout+0x0/0x5
 [<c0122900>] printk+0xe/0x11
 [<c01060c2>] die+0x15a/0x16b
 [<c0106425>] do_invalid_op+0xcf/0xf2
 [<c0140840>] unlock_page+0xd/0x1c
 [<c0166ba3>] do_lookup+0x23/0xb1
 [<c016f730>] dput+0x34/0x1a7
 [<c016779e>] __link_path_walk+0xb6d/0xc25
 [<c0143d1f>] __rmqueue+0xc1/0x10c
 [<c02d69db>] error_code+0x2f/0x38
 [<c0140840>] unlock_page+0xd/0x1c
 [<c014da68>] do_wp_page+0x94/0x371
 [<c014e9d0>] handle_mm_fault+0x139/0x193
 [<c011b01b>] do_page_fault+0x1ae/0x5c6
 [<c02d3d56>] schedule+0x84e/0x8ec
 [<c02d3d86>] schedule+0x87e/0x8ec
 [<c012ce96>] sigprocmask+0xb0/0xca
 [<c012cf48>] sys_rt_sigprocmask+0x98/0x145
 [<c011ae6d>] do_page_fault+0x0/0x5c6
 [<c02d69db>] error_code+0x2f/0x38
------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:42
!invalid operand: 0000 [#3]
SMP
Modules linked in: dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
ata_piix libata sd_mod scsi_mod
CPU:    2
EIP:    0060:[<c011c8ea>]    Not tainted VLI
EFLAGS: 00010206   (2.6.9-55.ELsmp)
EIP is at kmap_atomic+0x73/0x178
eax: c000ac58   ebx: 00000000   ecx: 3f3bf163   edx: 0000005e
esi: 00000000   edi: c1bceff8   ebp: c000af48   esp: f7117d58
ds: 007b   es: 007b   ss: 0068
Process hotplug (pid: 631, threadinfo=f7117000 task=f7186cb0)
Stack: 80000000 00000000 00000000 fff8f000 c17f24c0 c17f24c0 c17f24c0
00000000
       00000000 fff8b000 c17f24c0 3f926067 00000000 c1bceff8 000008c0
c014c42a
       3f926067 00000000 f7c634b0 f72f36a4 f72f36fc c1bbc380 c0163b8a
f72f36fc
Call Trace:
 [<c014c42a>] pte_alloc_map+0xd9/0xe2
 [<c0163b8a>] install_arg_page+0x75/0x169
 [<c0163e5f>] setup_arg_pages+0x1e1/0x20b
 [<c017fd11>] load_elf_binary+0x622/0xc10
 [<c017f6ef>] load_elf_binary+0x0/0xc10
 [<c0164beb>] search_binary_handler+0xb7/0x22a
 [<c017ed70>] load_script+0x1e8/0x1f8
 [<c017f6ef>] load_elf_binary+0x0/0xc10
 [<c0180254>] load_elf_binary+0xb65/0xc10
 [<c0144230>] __alloc_pages+0xb4/0x2a6
 [<c014b953>] kunmap_high+0x63/0x80
 [<c0163aed>] copy_strings+0x22b/0x235
 [<c017eb88>] load_script+0x0/0x1f8
 [<c0164beb>] search_binary_handler+0xb7/0x22a

Sometimes I wont even get an error message. It will hang right after
starting the init.d processes.

I'm stumped on this one. I'm no entirely sure what's wrong. Any advice
would be most appreciated.

Thanks in advance.
~Luis
