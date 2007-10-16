Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbXJPFWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbXJPFWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759349AbXJPFWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:22:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:17448 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759040AbXJPFWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hlGGweLhwRdIrguVgP/brSMwykkiRZClmy+aE21X7zLUFogSJfHhw8WhULbq8+tIAtZqIQUSvgpdXHIW4caMroh6L3uFCvkWFw4Xt9fMefo/njcIpQfSYbXlNYb1HkzmEXnwO7/prQfrJFLdVrKWQzzlsJHE1g1ms2PZZHrnBNw=
Message-ID: <a8e1da0710152222t44de6c8at75d3dd874faf58be@mail.gmail.com>
Date: Tue, 16 Oct 2007 13:22:01 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
Cc: "Alan Stern" <stern@rowland.harvard.edu>, bbpetkov@yahoo.de,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20071016044844.GA8125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0710142257g628d3d1bq635a5deefb5fb4cc@mail.gmail.com>
	 <Pine.LNX.4.44L0.0710151435070.3466-100000@iolanthe.rowland.org>
	 <20071016044844.GA8125@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 10/16/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Oct 15, 2007 at 02:38:25PM -0400, Alan Stern wrote:
> > On Mon, 15 Oct 2007, Dave Young wrote:
> >
> > > On 10/14/07, Borislav Petkov <bbpetkov@yahoo.de> wrote:
> > > > Hi,
> > > >
> > > > i get the following warning on yesterday's git tree (v2.6.23-2840-g752097c):
> > > >
> > > > Oct 14 09:07:15 zmei kernel: [   49.368030] sysfs: duplicate filename 'bInterfaceNumber' can not be created
> > > > Oct 14 09:07:15 zmei kernel: [   49.368086] WARNING: at fs/sysfs/dir.c:425 sysfs_add_one()
> > > > Oct 14 09:07:15 zmei kernel: [   49.368134]  [<c010527c>] show_trace_log_lvl+0x1a/0x2f
> > > > Oct 14 09:07:15 zmei kernel: [   49.368220]  [<c0105da0>] show_trace+0x12/0x14
> > > > Oct 14 09:07:15 zmei kernel: [   49.368300]  [<c0105db8>] dump_stack+0x16/0x18
> > > > Oct 14 09:07:15 zmei kernel: [   49.368379]  [<c019f2ee>] sysfs_add_one+0x57/0xbc
> > > > Oct 14 09:07:15 zmei kernel: [   49.368461]  [<c019edeb>] sysfs_add_file+0x49/0x71
> > > > Oct 14 09:07:15 zmei kernel: [   49.368541]  [<c01a05c2>] sysfs_create_group+0x86/0xe8
> > > > Oct 14 09:07:15 zmei kernel: [   49.368621]  [<c024f5da>] usb_create_sysfs_intf_files+0x27/0x9b
> > > > Oct 14 09:07:15 zmei kernel: [   49.368704]  [<c024c28b>] usb_set_configuration+0x454/0x466
> > > > Oct 14 09:07:15 zmei kernel: [   49.368787]  [<c0252b97>] generic_probe+0x53/0x94
> > > > Oct 14 09:07:15 zmei kernel: [   49.368867]  [<c024d4f7>] usb_probe_device+0x35/0x3b
> > > > Oct 14 09:07:15 zmei kernel: [   49.368947]  [<c022a46c>] driver_probe_device+0xcb/0x14f
> > > > Oct 14 09:07:15 zmei kernel: [   49.369039]  [<c022a4f8>] __device_attach+0x8/0xa
> > > > Oct 14 09:07:15 zmei kernel: [   49.369119]  [<c02298d5>] bus_for_each_drv+0x3b/0x63
> > > > Oct 14 09:07:15 zmei kernel: [   49.369199]  [<c022a589>] device_attach+0x70/0x85
> > > > Oct 14 09:07:15 zmei kernel: [   49.369279]  [<c022984c>] bus_attach_device+0x29/0x77
> > > > Oct 14 09:07:15 zmei kernel: [   49.369359]  [<c0228abc>] device_add+0x28c/0x445
> > > > Oct 14 09:07:15 zmei kernel: [   49.369439]  [<c0247c7a>] usb_new_device+0x44/0x82
> > > > Oct 14 09:07:15 zmei kernel: [   49.369519]  [<c02486ec>] hub_thread+0x666/0x9c2
> > > > Oct 14 09:07:15 zmei kernel: [   49.369598]  [<c01370e9>] kthread+0x3b/0x62
> > > > Oct 14 09:07:15 zmei kernel: [   49.369679]  [<c0104eaf>] kernel_thread_helper+0x7/0x10
> > > > Oct 14 09:07:15 zmei kernel: [   49.369759]  =======================
> > > >
> > > > The usb hub in question is named 4-1:1.0 and it has an extension connected to it
> > > > which is used to activate the 2 usb connectors at the side of the pc's monitor.
> > > > Correct me if i'm wrong but from what i've understood so far from reading the code,
> > > > i think, it adds the bInterfaceNumber-file after calling usb_create_sysfs_intf_files(intf).
> > > > However, the currently active usbhost interface alternate setting is the only one active
> > > > so the bInterfaceNumber exists already and therefore the warning, but this is
> > > > just a guess since i'm not that fluent in the usb internals.
> > > Hi,
> > > I have encountered the same problem which was  reported in
> > > http://lkml.org/lkml/2007/9/29/45
> > >
> > > For the first one "usbcore duplicated sysfs filename" , I have submit
> > > a patch to fix it.
> > >
> > > For the "bInterfaceNumber" one, I have no idea, the same problem still
> > > exist in the latest 23-mm1 tree.
> >
> > I have tried several times to duplicate this, most recently under
> > 2.6.23-mm1.  But nothing goes wrong; the error messages don't appear.
> >
> > You may have to do your own debugging.  Try adding printk statements to
> > usb_create_sysfs_intf_files() and usb_remove_sysfs_intf_files() so you
> > can tell when they get called.
>
> I finally duplicated this on one of my machines here at boot time, with
> USB built into the kernel.  I'll work tomorrow on tracking this down
> further...
Hi,
I add some printk messages, dump_stack and some others, here is the
dmesg dump with debug info(lines begin with "hidave"):

Linux version 2.6.23-mm1 (dave@darkstar) (gcc version 3.4.6) #4 SMP
PREEMPT Tue Oct 16 11:14:10 CST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fe88c00 (usable)
 BIOS-e820: 000000003fe88c00 - 000000003fe8ac00 (ACPI NVS)
 BIOS-e820: 000000003fe8ac00 - 000000003fe8cc00 (ACPI data)
 BIOS-e820: 000000003fe8cc00 - 0000000040000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
126MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 261768) 0 entries of 256 used
sizeof(struct page) = 32
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   261768
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   261768
On node 0 totalpages: 261768
Node 0 memmap at 0xc1000000 size 8388608 first pfn 0xc1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 253 pages used for memmap
  HighMem zone: 32139 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000FEB00, 0024 (r2 DELL  )
ACPI: XSDT 000FD267, 005C (r1 DELL    DM051          7 ASL        61)
ACPI: FACP 000FD35F, 00F4 (r3 DELL    DM051          7 ASL        61)
ACPI: DSDT FFFC755F, 2D0E (r1   DELL    dt_ex     1000 INTL 20050309)
ACPI: FACS 3FE88C00, 0040
ACPI: SSDT FFFCA38E, 00AC (r1   DELL    st_ex     1000 INTL 20050309)
ACPI: APIC 000FD453, 0072 (r1 DELL    DM051          7 ASL        61)
ACPI: BOOT 000FD4C5, 0028 (r1 DELL    DM051          7 ASL        61)
ACPI: ASF! 000FD4ED, 0067 (r16 DELL    DM051          7 ASL        61)
ACPI: MCFG 000FD554, 003E (r1 DELL    DM051          7 ASL        61)
ACPI: HPET 000FD592, 0038 (r1 DELL    DM051          7 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259723
Kernel command line: BOOT_IMAGE=test ro root=805
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2793.166 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1032480k/1047072k available (3129k kernel code, 13984k
reserved, 1108k data, 252k init, 129568k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc052a000 - 0xc0569000   ( 252 kB)
      .data : 0xc040e517 - 0xc0523560   (1108 kB)
      .text : 0xc0100000 - 0xc040e517   (3129 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 5592.00 BogoMIPS (lpj=9316807)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000641d 00000000 00000001 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 0000b180
0000641d 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) D CPU 2.80GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5588.88 BogoMIPS (lpj=9310208)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000641d 00000000 00000001 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 0000b180
0000641d 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Intel(R) Pentium(R) D CPU 2.80GHz stepping 07
Total of 2 processors activated (11180.88 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb93e, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=Linux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller
Hub without MMCONFIG support.
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 7 9 10 11 12 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:01: ioport range 0x800-0x85f has been reserved
system 00:01: ioport range 0xc00-0xc7f has been reserved
system 00:01: ioport range 0x860-0x8ff could not be reserved
system 00:06: iomem range 0x0-0x9ffff could not be reserved
system 00:06: iomem range 0x100000-0xffffff could not be reserved
system 00:06: iomem range 0x1000000-0x3fe88bff could not be reserved
system 00:06: iomem range 0xf0000-0xfffff could not be reserved
system 00:07: ioport range 0x100-0x1fe could not be reserved
system 00:07: ioport range 0x200-0x277 has been reserved
system 00:07: ioport range 0x280-0x2e7 has been reserved
system 00:07: ioport range 0x2e8-0x2ef has been reserved
system 00:07: ioport range 0x2f0-0x2f7 has been reserved
system 00:07: ioport range 0x2f8-0x2ff has been reserved
system 00:07: ioport range 0x300-0x377 could not be reserved
system 00:07: ioport range 0x380-0x3bb has been reserved
system 00:07: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:07: iomem range 0xfeda0000-0xfedacfff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: efd00000-efefffff
  PREFETCH window: e0000000-e7ffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: efc00000-efcfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: efb00000-efbfffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x7a set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NTFS driver 2.1.28 [Flags: R/W].
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0081
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0081
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0081
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0081
pci 0000:00:1d.3: Performing full reset
Boot video device is 0000:01:00.0
PCI: Firmware left 0000:03:08.0 e100 interrupts enabled, disabling
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Real Time Clock Driver v1.12ac
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH7: IDE controller (0x8086:0x27df rev 0x01) at  PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
ICH7: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
ICH7: IDE port disabled
Probing IDE interface ide0...
hda: TSSTcorp CD-RW/DVD-ROM TS-H492C, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 48X DVD-ROM CD-R/RW drive, 1536kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[C] -> GSI 20 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfea0 irq 17
ata2: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfea8 irq 17
ata1.00: ATA-7: SAMSUNG HD160JJ/P, ZM100-34, max UDMA7
ata1.00: 312500000 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD160JJ/ ZM10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312500000 512-byte hardware sectors (160000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 312500000 512-byte hardware sectors (160000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
ehci_hcd: block sizes: qh 128 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2
ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 000002 (park)=0 ithresh=0
period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 18, io mem 0xffa80800
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8
period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 1-0:1.0 (config #1, interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033ee4f>] usb_get_device_descriptor+0x7f/0xa0
 [<c033c04f>] register_root_hub+0xcf/0x160
 [<c033d03c>] usb_add_hcd+0x16c/0x420
 [<c03480f3>] usb_hcd_pci_probe+0x233/0x3a0
 [<c01c5414>] sysfs_create_link+0xa4/0x170
 [<c025ca2a>] pci_call_probe+0xa/0x10
 [<c025ca7e>] __pci_device_probe+0x4e/0x60
 [<c025cab6>] pci_device_probe+0x26/0x60
 [<c02b8454>] really_probe+0xa4/0x160
 [<c025ca08>] pci_match_device+0xa8/0xc0
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b8690>] __driver_attach+0x80/0x90
 [<c02b74fa>] bus_for_each_dev+0x3a/0x60
 [<c02b86b6>] driver_attach+0x16/0x20
 [<c02b8610>] __driver_attach+0x0/0x90
 [<c02b7c5a>] bus_add_driver+0x7a/0x160
 [<c025ce0c>] __pci_register_driver+0x5c/0x90
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c0549a8d>] ehci_hcd_init+0x4d/0x60
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.23-mm1 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: irq 18, io base 0x0000ff80
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 2-0:1.0 (config #1, interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033ee4f>] usb_get_device_descriptor+0x7f/0xa0
 [<c033c04f>] register_root_hub+0xcf/0x160
 [<c035d580>] uhci_start+0x1d0/0x330
 [<c033d03c>] usb_add_hcd+0x16c/0x420
 [<c03480f3>] usb_hcd_pci_probe+0x233/0x3a0
 [<c01c5414>] sysfs_create_link+0xa4/0x170
 [<c025ca2a>] pci_call_probe+0xa/0x10
 [<c025ca7e>] __pci_device_probe+0x4e/0x60
 [<c025cab6>] pci_device_probe+0x26/0x60
 [<c02b8454>] really_probe+0xa4/0x160
 [<c025ca08>] pci_match_device+0xa8/0xc0
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b8690>] __driver_attach+0x80/0x90
 [<c02b74fa>] bus_for_each_dev+0x3a/0x60
 [<c02b86b6>] driver_attach+0x16/0x20
 [<c02b8610>] __driver_attach+0x0/0x90
 [<c02b7c5a>] bus_add_driver+0x7a/0x160
 [<c025ce0c>] __pci_register_driver+0x5c/0x90
 [<c0549bba>] uhci_hcd_init+0xaa/0xe0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '001'
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.23-mm1 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ff60
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 3-0:1.0 (config #1, interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033ee4f>] usb_get_device_descriptor+0x7f/0xa0
 [<c033c04f>] register_root_hub+0xcf/0x160
 [<c035d580>] uhci_start+0x1d0/0x330
 [<c033d03c>] usb_add_hcd+0x16c/0x420
 [<c03480f3>] usb_hcd_pci_probe+0x233/0x3a0
 [<c01c5414>] sysfs_create_link+0xa4/0x170
 [<c025ca2a>] pci_call_probe+0xa/0x10
 [<c025ca7e>] __pci_device_probe+0x4e/0x60
 [<c025cab6>] pci_device_probe+0x26/0x60
 [<c02b8454>] really_probe+0xa4/0x160
 [<c025ca08>] pci_match_device+0xa8/0xc0
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b8690>] __driver_attach+0x80/0x90
 [<c02b74fa>] bus_for_each_dev+0x3a/0x60
 [<c02b86b6>] driver_attach+0x16/0x20
 [<c02b8610>] __driver_attach+0x0/0x90
 [<c02b7c5a>] bus_add_driver+0x7a/0x160
 [<c025ce0c>] __pci_register_driver+0x5c/0x90
 [<c0549bba>] uhci_hcd_init+0xaa/0xe0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '001'
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.23-mm1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000ff40
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
usb 1-1: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 4-0:1.0 (config #1, interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033ee4f>] usb_get_device_descriptor+0x7f/0xa0
 [<c033c04f>] register_root_hub+0xcf/0x160
 [<c035d580>] uhci_start+0x1d0/0x330
 [<c033d03c>] usb_add_hcd+0x16c/0x420
 [<c03480f3>] usb_hcd_pci_probe+0x233/0x3a0
 [<c01c5414>] sysfs_create_link+0xa4/0x170
 [<c025ca2a>] pci_call_probe+0xa/0x10
 [<c025ca7e>] __pci_device_probe+0x4e/0x60
 [<c025cab6>] pci_device_probe+0x26/0x60
 [<c02b8454>] really_probe+0xa4/0x160
 [<c025ca08>] pci_match_device+0xa8/0xc0
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b8690>] __driver_attach+0x80/0x90
 [<c02b74fa>] bus_for_each_dev+0x3a/0x60
 [<c02b86b6>] driver_attach+0x16/0x20
 [<c02b8610>] __driver_attach+0x0/0x90
 [<c02b7c5a>] bus_add_driver+0x7a/0x160
 [<c025ce0c>] __pci_register_driver+0x5c/0x90
 [<c0549bba>] uhci_hcd_init+0xaa/0xe0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '001'
usb usb4: new device found, idVendor=0000, idProduct=0000
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.23-mm1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: irq 21, io base 0x0000ff20
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
usb 1-1: uevent
usb 1-1: usb_probe_device
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: adding 1-1:1.0 (config #1, interface 0)
usb 1-1:1.0: uevent
usb 1-1:1.0: uevent
hub 1-1:1.0: usb_probe_interface
hub 1-1:1.0: usb_probe_interface - got id
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
hub 1-1:1.0: standalone hub
hub 1-1:1.0: individual port power switching
hub 1-1:1.0: individual port over-current protection
hidave: #################################
hidave: called from usb_set_interface
hidave: about to adding 1-1:1.0 (interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033f499>] usb_set_interface+0x1e9/0x250
 [<c0337e03>] hub_configure+0x8c3/0x9b0
 [<c033807e>] hub_probe+0xbe/0x190
 [<c024e85f>] kobject_get+0xf/0x20
 [<c0338106>] hub_probe+0x146/0x190
 [<c03402c4>] usb_probe_interface+0x114/0x1b0
 [<c02b8454>] really_probe+0xa4/0x160
 [<c0340749>] usb_match_id+0x19/0x50
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c033fcc5>] usb_set_configuration+0x425/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033a244>] hub_port_connect_change+0x224/0x490
 [<c033a783>] hub_events+0x2d3/0x620
 [<c033aaf1>] hub_thread+0x21/0x190
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c012586d>] complete+0x3d/0x60
 [<c033aad0>] hub_thread+0x0/0x190
 [<c013fef9>] kthread+0x59/0xa0
 [<c013fea0>] kthread+0x0/0xa0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
hub 1-1:1.0: TT per port
hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-1:1.0: power on to power good time: 100ms
hub 1-1:1.0: local power source is good
hub 1-1:1.0: enabling power on all ports
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 5-0:1.0 (config #1, interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033ee4f>] usb_get_device_descriptor+0x7f/0xa0
 [<c033c04f>] register_root_hub+0xcf/0x160
 [<c035d580>] uhci_start+0x1d0/0x330
 [<c033d03c>] usb_add_hcd+0x16c/0x420
 [<c03480f3>] usb_hcd_pci_probe+0x233/0x3a0
 [<c01c5414>] sysfs_create_link+0xa4/0x170
 [<c025ca2a>] pci_call_probe+0xa/0x10
 [<c025ca7e>] __pci_device_probe+0x4e/0x60
 [<c025cab6>] pci_device_probe+0x26/0x60
 [<c02b8454>] really_probe+0xa4/0x160
 [<c025ca08>] pci_match_device+0xa8/0xc0
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b8690>] __driver_attach+0x80/0x90
 [<c02b74fa>] bus_for_each_dev+0x3a/0x60
 [<c02b86b6>] driver_attach+0x16/0x20
 [<c02b8610>] __driver_attach+0x0/0x90
 [<c02b7c5a>] bus_add_driver+0x7a/0x160
 [<c025ce0c>] __pci_register_driver+0x5c/0x90
 [<c0549bba>] uhci_hcd_init+0xaa/0xe0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '001'
usb usb5: new device found, idVendor=0000, idProduct=0000
usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.23-mm1 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb 1-1: link qh256-0001/c24d0100 start 255 [1/0 us]
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 1-1:1.0 (config #1, interface 0)
sysfs: duplicate filename 'bInterfaceNumber' can not be created
WARNING: at fs/sysfs/dir.c:416 sysfs_add_one()
 [<c01c4750>] sysfs_add_one+0xa0/0xe0
 [<c01c3d6e>] sysfs_add_file+0x4e/0xb0
 [<c01c5d31>] create_files+0x31/0x60
 [<c01c5d94>] sysfs_create_group+0x34/0xf0
 [<c040b3e6>] klist_node_init+0x46/0x60
 [<c040b373>] add_tail+0x13/0x40
 [<c0343fff>] usb_create_sysfs_intf_files+0x2f/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033a244>] hub_port_connect_change+0x224/0x490
 [<c033a783>] hub_events+0x2d3/0x620
 [<c033aaf1>] hub_thread+0x21/0x190
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c012586d>] complete+0x3d/0x60
 [<c033aad0>] hub_thread+0x0/0x190
 [<c013fef9>] kthread+0x59/0xa0
 [<c013fea0>] kthread+0x0/0xa0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033a244>] hub_port_connect_change+0x224/0x490
 [<c033a783>] hub_events+0x2d3/0x620
 [<c033aaf1>] hub_thread+0x21/0x190
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c012586d>] complete+0x3d/0x60
 [<c033aad0>] hub_thread+0x0/0x190
 [<c013fef9>] kthread+0x59/0xa0
 [<c013fea0>] kthread+0x0/0xa0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '002'
usb 1-1: new device found, idVendor=0424, idProduct=2504
usb 1-1: new device strings: Mfr=0, Product=0, SerialNumber=0
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 5, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 5: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 5 low speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 6 low speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 7, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 7 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
hub 2-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:1d.2: port 1 portsc 01ab,00
hub 4-0:1.0: port 1, status 0301, change 0003, 1.5 Mb/s
hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb usb3: suspend_rh (auto-stop)
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: skipped 1 descriptor after interface
usb 4-1: default language 0x0409
usb 4-1: uevent
usb 4-1: usb_probe_device
usb 4-1: configuration #1 chosen from 1 choice
usb 4-1: adding 4-1:1.0 (config #1, interface 0)
usb 4-1:1.0: uevent
usb 4-1:1.0: uevent
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 4-1:1.0 (config #1, interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033a244>] hub_port_connect_change+0x224/0x490
 [<c033a783>] hub_events+0x2d3/0x620
 [<c033aaf1>] hub_thread+0x21/0x190
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c012586d>] complete+0x3d/0x60
 [<c033aad0>] hub_thread+0x0/0x190
 [<c013fef9>] kthread+0x59/0xa0
 [<c013fea0>] kthread+0x0/0xa0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '002'
usb 4-1: new device found, idVendor=0461, idProduct=4d15
usb 4-1: new device strings: Mfr=0, Product=2, SerialNumber=0
usb 4-1: Product: USB Optical Mouse
uhci_hcd 0000:00:1d.2: port 2 portsc 01ab,00
hub 4-0:1.0: port 2, status 0301, change 0003, 1.5 Mb/s
hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
usb 4-2: new low speed USB device using uhci_hcd and address 3
usb 4-2: skipped 1 descriptor after interface
usb 4-2: default language 0x0409
usb 4-2: uevent
usb 4-2: usb_probe_device
usb 4-2: configuration #1 chosen from 1 choice
usb 4-2: adding 4-2:1.0 (config #1, interface 0)
usb 4-2:1.0: uevent
usb 4-2:1.0: uevent
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 4-2:1.0 (config #1, interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033a244>] hub_port_connect_change+0x224/0x490
 [<c033a783>] hub_events+0x2d3/0x620
 [<c033aaf1>] hub_thread+0x21/0x190
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c012586d>] complete+0x3d/0x60
 [<c033aad0>] hub_thread+0x0/0x190
 [<c013fef9>] kthread+0x59/0xa0
 [<c013fea0>] kthread+0x0/0xa0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '003'
usb 4-2: new device found, idVendor=413c, idProduct=2003
usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: Dell USB Keyboard
usb 4-2: Manufacturer: Dell
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.3: port 1 portsc 009b,00
hub 5-0:1.0: port 1, status 0101, change 0003, 12 Mb/s
hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
usb usb2: suspend_rh (auto-stop)
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb 5-1: default language 0x0409
usb 5-1: uevent
usb 5-1: usb_probe_device
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: adding 5-1:1.0 (config #1, interface 0)
usb 5-1:1.0: uevent
usb 5-1:1.0: uevent
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 5-1:1.0 (config #1, interface 0)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033a244>] hub_port_connect_change+0x224/0x490
 [<c033a783>] hub_events+0x2d3/0x620
 [<c033aaf1>] hub_thread+0x21/0x190
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c012586d>] complete+0x3d/0x60
 [<c033aad0>] hub_thread+0x0/0x190
 [<c013fef9>] kthread+0x59/0xa0
 [<c013fea0>] kthread+0x0/0xa0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
usb 5-1: adding 5-1:1.1 (config #1, interface 1)
usb 5-1:1.1: uevent
usb 5-1:1.1: uevent
hidave: #################################
hidave: called from usb_set_configuration
hidave: about to adding 5-1:1.1 (config #1, interface 1)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033fd12>] usb_set_configuration+0x472/0x580
 [<c0347d06>] generic_probe+0x76/0xb0
 [<c0340178>] usb_probe_device+0x78/0x90
 [<c02b8454>] really_probe+0xa4/0x160
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b75ea>] bus_for_each_drv+0x3a/0x60
 [<c02b85dc>] device_attach+0x4c/0x80
 [<c02b8580>] __device_attach+0x0/0x10
 [<c02b78b5>] bus_attach_device+0x75/0xb0
 [<c02b5d66>] device_add+0x136/0x350
 [<c0338700>] usb_new_device+0x50/0x160
 [<c033a244>] hub_port_connect_change+0x224/0x490
 [<c033a783>] hub_events+0x2d3/0x620
 [<c033aaf1>] hub_thread+0x21/0x190
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c01404f0>] autoremove_wake_function+0x0/0x50
 [<c012586d>] complete+0x3d/0x60
 [<c033aad0>] hub_thread+0x0/0x190
 [<c013fef9>] kthread+0x59/0xa0
 [<c013fea0>] kthread+0x0/0xa0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
drivers/usb/core/inode.c: creating file '002'
usb 5-1: new device found, idVendor=0c10, idProduct=0000
usb 5-1: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 5-1: Product: SiW
usb 5-1: Manufacturer: SiW
usb 5-1: SerialNumber: AD5A00000000
hub 1-1:1.0: state 7 ports 4 chg 0000 evt 0000
hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbhid 4-1:1.0: usb_probe_interface
usbhid 4-1:1.0: usb_probe_interface - got id
input: USB Optical Mouse as /class/input/input0
input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.2-1
usbhid 4-2:1.0: usb_probe_interface
usbhid 4-2:1.0: usb_probe_interface - got id
input: Dell Dell USB Keyboard as /class/input/input1
uhci_hcd 0000:00:1d.2: reserve dev 3 ep81-INT, period 16, phase 8, 118 us
input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.2-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 252k freed
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
EXT3 FS on sda5, internal journal
hub 1-1:1.0: hub_suspend
usb 1-1: unlink qh256-0001/c24d0100 start 255 [1/0 us]
usb 1-1: usb auto-suspend
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb 5-0:1.0: uevent
usb 1-1: uevent
usb 1-1:1.0: uevent
usb 1-1:1.0: uevent
usb 4-1: uevent
usb 4-1:1.0: uevent
usb 4-1:1.0: uevent
usb 4-2: uevent
usb 4-2:1.0: uevent
usb 4-2:1.0: uevent
usb 5-1: uevent
usb 5-1:1.0: uevent
usb 5-1:1.0: uevent
usb 5-1:1.1: uevent
usb 5-1:1.1: uevent
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
input: PC Speaker as /class/input/input2
Linux agpgart interface v0.102
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 22
ACPI Exception (processor_core-0813): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0813): AE_NOT_FOUND, Processor Device
is not present [20070126]
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [VBTN]
rtc_cmos: probe of 00:05 failed with error -16
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
sd 0:0:0:0: Attached scsi generic sg0 type 0
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
hci_usb 5-1:1.0: usb_probe_interface
hci_usb 5-1:1.0: usb_probe_interface - got id
hidave: #################################
hidave: called from usb_set_interface
hidave: about to adding 5-1:1.1 (interface 1)
 [<c0344006>] usb_create_sysfs_intf_files+0x36/0xc0
 [<c033f499>] usb_set_interface+0x1e9/0x250
 [<f88a154a>] hci_usb_probe+0x55a/0x5d0 [hci_usb]
 [<c0193406>] ifind+0x46/0xa0
 [<c03402c4>] usb_probe_interface+0x114/0x1b0
 [<c02b8454>] really_probe+0xa4/0x160
 [<c0340749>] usb_match_id+0x19/0x50
 [<c02b8562>] driver_probe_device+0x42/0x60
 [<c02b8690>] __driver_attach+0x80/0x90
 [<c02b74fa>] bus_for_each_dev+0x3a/0x60
 [<c02b86b6>] driver_attach+0x16/0x20
 [<c02b8610>] __driver_attach+0x0/0x90
 [<c02b7c5a>] bus_add_driver+0x7a/0x160
 [<c0340adc>] usb_register_driver+0x7c/0xf0
 [<f882f02d>] hci_usb_init+0x2d/0x5c [hci_usb]
 [<c0152033>] sys_init_module+0xd3/0x160
 [<c01043ca>] syscall_call+0x7/0xb
 =======================
usbcore: registered new interface driver hci_usb
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:03:08.0[A] -> GSI 20 (level, low) -> IRQ 17
e100: eth0: e100_probe: addr 0xefbff000, irq 17, MAC addr 00:13:72:e7:4d:66
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent
usb 4-1:1.0: uevent
usb 4-1:1.0: uevent
usb 4-2:1.0: uevent
usb 4-2:1.0: uevent
usb 5-0:1.0: uevent
usb 5-0:1.0: uevent
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
usb 1-1:1.0: uevent
usb 1-1:1.0: uevent

>
> thanks,
>
> greg k-h
>
