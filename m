Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbXHDWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbXHDWu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXHDWuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:50:16 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:27011 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764871AbXHDWuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=I7e1lkq8Lgsmc4lcBJSU5ppKc1vX0tbVhb5Be9QX3sty3t8jt3WkR/0irho3WOyXsGnpx3E24NVYlyrCCpHk5rRXMSmG/yr0KypZ8lWGfTGjvvUihvlBosPp8BrBDkJbHfMnt2xvaECM9oDiqowkCL3UAXOLm9NzlxDGJ0GaTXo=
Message-ID: <46B50298.4020303@gmail.com>
Date: Sat, 04 Aug 2007 17:50:00 -0500
From: Sol Jerome <soljer@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops in 2.6.21-gentoo-r4 during rsync
Content-Type: multipart/mixed;
 boundary="------------090409060207030403040904"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090409060207030403040904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi, I get the following error when doing an 'rsync -avz --progress.' Any 
help would be appreciated.

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
 [<ffffffff80262d9c>] __rmqueue+0x6c/0x140
PGD 7b24f067 PUD 71ab9067 PMD 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in: rfcomm snd_seq snd_seq_device bridge llc 
acpi_memhotplug pciehp pci_hotplug kvm saa7134_alsa saa7134_dvb dvb_pll 
tda826x mt352 tda10086 video_buf_dvb dvb_core nxt200x isl6421 tda1004x 
udf ext4dev jbd2 dm_bbr ntfs vfat msdos fat i2c_amd756 i2c_dev usblp 
usb_storage uhci_hcd quickcam_messenger usbvideo nbd snd_pcm_oss 
snd_mixer_oss ieee80211_crypt_tkip ieee80211_crypt_ccmp 
ieee80211_crypt_wep ieee80211 ieee80211_crypt fuse aes bfusb bcm203x 
bnep sco hidp l2cap pwc hci_usb usbhid tuner saa7134 video_buf 
compat_ioctl32 ir_kbd_i2c ir_common videodev v4l2_common v4l1_compat 
i2c_nforce2 i2c_core ehci_hcd ohci_hcd k8temp sg
Pid: 9731, comm: rsync Not tainted 2.6.21-gentoo-r4 #1
RIP: 0010:[<ffffffff80262d9c>]  [<ffffffff80262d9c>] __rmqueue+0x6c/0x140
RSP: 0018:ffff81007266d4d8  EFLAGS: 00010013
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff81000000c600
RBP: ffff81000000c698 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000929 R11: 0000000000000001 R12: 0000000000000000
R13: ffff81007e3a0d40 R14: ffff81000000c600 R15: 000000000000001f
FS:  00002b548bc18ae0(0000) GS:ffff81007e3a0cc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000702d4000 CR4: 00000000000006e0
Process rsync (pid: 9731, threadinfo ffff81007266c000, task 
ffff8100711a4a20)
Stack:  0000000000000082 ffff81007e3a0d50 0000000000000000 0000000000000000
 ffff81007e3a0d40 ffffffff802645f0 ffff81007266d558 0000000000000001
 ffff81000000d868 000000018022d104 ffff81000000d860 0000005000000000
Call Trace:
 [<ffffffff802645f0>] get_page_from_freelist+0x1e0/0x4e0
 [<ffffffff80264be0>] __alloc_pages+0x180/0x300
 [<ffffffff802829a0>] kmem_getpages+0x70/0x140
 [<ffffffff80282fd4>] fallback_alloc+0x104/0x1c0
 [<ffffffff802836d7>] kmem_cache_alloc+0x97/0xb0
 [<ffffffff80323927>] journal_add_journal_head+0x27/0x170
 [<ffffffff8031fbc7>] journal_dirty_data+0x37/0x210
 [<ffffffff8030f34d>] ext3_journal_dirty_data+0x1d/0x50
 [<ffffffff8030e678>] walk_page_buffers+0x68/0xb0
 [<ffffffff8030f380>] journal_dirty_data_fn+0x0/0x20
 [<ffffffff80311978>] ext3_ordered_writepage+0x108/0x190
 [<ffffffff80268cc2>] shrink_inactive_list+0x442/0x8a0
 [<ffffffff8051506c>] __split_bio+0x3cc/0x3f0
 [<ffffffff803c85f1>] __up_read+0x21/0xb0
 [<ffffffff80515469>] dm_request+0x119/0x120
 [<ffffffff803ba9d9>] generic_make_request+0x159/0x170
 [<ffffffff80269216>] shrink_zone+0xf6/0x130
 [<ffffffff80269bf3>] try_to_free_pages+0x183/0x280
 [<ffffffff80264c3f>] __alloc_pages+0x1df/0x300
 [<ffffffff802666d4>] __do_page_cache_readahead+0xe4/0x290
 [<ffffffff80297f30>] __pollwait+0x0/0x120
 [<ffffffff80282662>] transfer_objects+0x52/0x80
 [<ffffffff8022d3a3>] __activate_task+0x33/0x50
 [<ffffffff802303ac>] try_to_wake_up+0x3dc/0x400
 [<ffffffff80516e95>] dm_table_any_congested+0x15/0x70
 [<ffffffff802668ed>] blockable_page_cache_readahead+0x6d/0xe0
 [<ffffffff802669e6>] make_ahead_window+0x86/0xb0
 [<ffffffff80266ba5>] page_cache_readahead+0x195/0x1e0
 [<ffffffff8025f647>] do_generic_mapping_read+0x127/0x410
 [<ffffffff8025ec50>] file_read_actor+0x0/0x140
 [<ffffffff8026169c>] generic_file_aio_read+0x16c/0x1b0
 [<ffffffff8028956f>] do_sync_read+0xcf/0x120
 [<ffffffff8024c110>] autoremove_wake_function+0x0/0x30
 [<ffffffff80289efb>] vfs_read+0xdb/0x180
 [<ffffffff8028a3c3>] sys_read+0x53/0x90
 [<ffffffff80209a5e>] system_call+0x7e/0x83


Code: 48 8b 08 48 8b 50 08 4c 8d 68 d8 48 89 51 08 48 89 0a 48 c7
RIP  [<ffffffff80262d9c>] __rmqueue+0x6c/0x140
 RSP <ffff81007266d4d8>
CR2: 0000000000000000

--------------090409060207030403040904
Content-Type: text/plain;
 name="blah"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blah"

Linux version 2.6.21-gentoo-r4 (root@minisol) (gcc version 4.1.2 20070214 ( (gdc 0.23, using dmd 1.007)) (Gentoo 4.1.2)) #1 SMP Sat Aug 4 16:09:51 CDT 2007
Command line: ro root=/dev/sda3 vga=0x31A splash=verbose,fadein,theme:livecd-2007.0 video=vesafb:ywrap,mtrr vga=0x31A fbcon=scrollback:128K quiet CONSOLE=/dev/tty1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F7D70, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FFF3180, 6677 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 7FFF0000, 0040
ACPI: SRAT 7FFF9900, 00A0 (r1 AMD    HAMMER          1 AMD         1)
ACPI: MCFG 7FFF9A00, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FFF9840, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering push_node_boundaries(0, 0, 160)
SRAT: Node 0 PXM 0 0-80000000
Entering add_active_range(0, 0, 159) 1 entries of 3200 used
Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
Entering push_node_boundaries(0, 0, 524288)
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-000000007fff0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524272
Entering account_node_boundary(0, 0, 524272)
Entering account_node_boundary(0, 0, 524272)
Entering account_node_boundary(0, 0, 524272)
Entering account_node_boundary(0, 0, 524272)
Entering account_node_boundary(0, 0, 524272)
Entering account_node_boundary(0, 0, 524272)
On node 0 totalpages: 1048463
Entering account_node_boundary(0, 0, 524272)
Entering account_node_boundary(0, 0, 524272)
  DMA zone: 56 pages used for memmap
  DMA zone: 1710 pages reserved
  DMA zone: 2233 pages, LIFO batch:0
Entering account_node_boundary(0, 0, 524272)
Entering account_node_boundary(0, 0, 524272)
  DMA32 zone: 7112 pages used for memmap
  DMA32 zone: 513064 pages, LIFO batch:31
Entering account_node_boundary(0, 0, 524272)
Entering account_node_boundary(0, 0, 524272)
  Normal zone: 0 pages used for memmap
  Normal zone: 524288 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000f0000
Nosave address range: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 33408 bytes of per cpu data
Built 1 zonelists.  Total pages: 1039585
Kernel command line: ro root=/dev/sda3 vga=0x31A splash=verbose,fadein,theme:livecd-2007.0 video=vesafb:ywrap,mtrr vga=0x31A fbcon=scrollback:128K quiet CONSOLE=/dev/tty1
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2211.352 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
CPU 0: aperture @ ce64000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 2054200k/2097088k available (3951k kernel code, 42500k reserved, 1559k data, 332k init)
Calibrating delay using timer specific routine.. 4423.94 BogoMIPS (lpj=2211972)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12564522
Detected 12.564 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4421.96 BogoMIPS (lpj=2210980)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Brought up 2 CPUs
migration_cost=166
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
pnp: 00:01: ioport range 0x4000-0x407f has been reserved
pnp: 00:01: ioport range 0x4080-0x40ff has been reserved
pnp: 00:01: ioport range 0x4400-0x447f has been reserved
pnp: 00:01: ioport range 0x4480-0x44ff has been reserved
pnp: 00:01: ioport range 0x4800-0x487f has been reserved
pnp: 00:01: ioport range 0x4880-0x48ff has been reserved
pnp: 00:01: iomem range 0x0-0x0 could not be reserved
pnp: 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0c: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:0c: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0c: iomem range 0xfc000-0xfffff could not be reserved
ieee1394: Initialized config rom entry `ip1394'
PCI: Bridge: 0000:00:09.0
  IO window: 9000-afff
  MEM window: d6000000-d7ffffff
  PREFETCH window: 88000000-880fffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: d0000000-d2ffffff
  PREFETCH window: c0000000-cfffffff
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: d3000000-d5ffffff
  PREFETCH window: b0000000-bfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 521k freed
Total HugeTLB memory allocated, 0
DLM (built Aug  4 2007 16:02:15) installed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
GFS2 (built Aug  4 2007 16:02:47) installed
Lock_DLM (built Aug  4 2007 16:02:54) installed
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Linking AER extended capability on 0000:00:0e.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102 (c) Dave Jones
vesafb: framebuffer at 0xb0000000, mapped to 0xffffc20010100000, using 5120k, total 262144k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fbsplash: console 0 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 0
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Thermal Zone [THRM] (40 C)
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:05:0c.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
skge 1.10 addr 0xd7014000 irq 17 chip Yukon-Lite rev 9
skge eth0: addr 00:15:f2:52:87:75
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
eth1: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:0a.0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 243
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev f3) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hdb: ATAPI CD-RW 52XMax, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
hdb: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
sata_sil 0000:05:0a.0: version 2.1
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:05:0a.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
sata_sil 0000:05:0a.0: Applying R_ERR on DMA activate FIS errata fix
ata1: SATA max UDMA/100 cmd 0xffffc2000002e080 ctl 0xffffc2000002e08a bmdma 0xffffc2000002e000 irq 19
ata2: SATA max UDMA/100 cmd 0xffffc2000002e0c0 ctl 0xffffc2000002e0ca bmdma 0xffffc2000002e008 irq 19
ata3: SATA max UDMA/100 cmd 0xffffc2000002e280 ctl 0xffffc2000002e28a bmdma 0xffffc2000002e200 irq 19
ata4: SATA max UDMA/100 cmd 0xffffc2000002e2c0 ctl 0xffffc2000002e2ca bmdma 0xffffc2000002e208 irq 19
scsi0 : sata_sil
ata1: SATA link down (SStatus 0 SControl 310)
scsi1 : sata_sil
ata2: SATA link down (SStatus 0 SControl 310)
scsi2 : sata_sil
ata3: SATA link down (SStatus 0 SControl 310)
scsi3 : sata_sil
ata4: SATA link down (SStatus 0 SControl 310)
sata_nv 0000:00:07.0: version 3.3
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
ata5: SATA max UDMA/133 cmd 0xffffc20000030480 ctl 0xffffc200000304a0 bmdma 0x000000000001d800 irq 22
ata6: SATA max UDMA/133 cmd 0xffffc20000030580 ctl 0xffffc200000305a0 bmdma 0x000000000001d808 irq 22
scsi4 : sata_nv
ata5: SATA link down (SStatus 0 SControl 300)
scsi5 : sata_nv
ata6: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata7: SATA max UDMA/133 cmd 0xffffc20000032480 ctl 0xffffc200000324a0 bmdma 0x000000000001c400 irq 21
ata8: SATA max UDMA/133 cmd 0xffffc20000032580 ctl 0xffffc200000325a0 bmdma 0x000000000001c408 irq 21
scsi6 : sata_nv
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata7.00: ATA-6: ST380013AS, 3.18, max UDMA/133
ata7.00: 156301488 sectors, multi 1: LBA48 
ata7.00: configured for UDMA/133
scsi7 : sata_nv
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata8.00: 625142448 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata8.00: configured for UDMA/133
scsi 6:0:0:0: Direct-Access     ATA      ST380013AS       3.18 PQ: 0 ANSI: 5
ata7: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 6:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 6:0:0:0: [sda] Write Protect is off
sd 6:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 6:0:0:0: [sda] Write Protect is off
sd 6:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 6:0:0:0: [sda] Attached SCSI disk
scsi 7:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
ata8: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 7:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 7:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 7:0:0:0: [sdb] Attached SCSI disk
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.0.1 Aug  4 2007
Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 51745 usecs
intel8x0: clocking to 46863
ALSA device list:
  #0: NVidia CK804 with ALC850 at irq 20
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ReiserFS: sda3: found reiserfs format "3.6" with standard journal
ReiserFS: sda3: using ordered data mode
ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda3: checking transaction log (sda3)
ReiserFS: sda3: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 332k freed
sd 6:0:0:0: Attached scsi generic sg0 type 0
sd 7:0:0:0: Attached scsi generic sg1 type 0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 23, io mem 0xd8004000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 22, io mem 0xd8005000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
i2c_adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x4c40
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
saa7133[0]: found at 0000:05:08.0, rev: 240, irq: 18, latency: 32, mmio: 0xd701a000
saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110 [card=90,insmod option]
saa7133[0]: board init: gpio is 100
saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 2-0061: chip found @ 0xc2 (saa7133[0])
tuner 2-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
tuner 2-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usb 1-2: new low speed USB device using ohci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
usb 1-9: new full speed USB device using ohci_hcd and address 4
usb 1-9: configuration #1 chosen from 1 choice
Bluetooth: HCI USB driver ver 2.9
usb 1-10: new full speed USB device using ohci_hcd and address 5
usb 1-10: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:02.0-1
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-1
pwc: Philips webcam module version 10.0.12 loaded.
pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
pwc: Trace options: 0x0001
hiddev96: USB HID v1.10 Device [American Power Conversion Back-UPS LS 500 FW:16.b3 .D USB FW:b3 ] on usb-0000:00:02.0-2
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver hci_usb
pwc: Logitech QuickCam Zoom USB webcam detected.
pwc: Registered as /dev/video1.
usbcore: registered new interface driver Philips webcam
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: SCO (Voice Link) ver 0.5
Bluetooth: SCO socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bluetooth: Broadcom Blutonium firmware driver ver 1.1
usbcore: registered new interface driver bcm203x
Bluetooth: BlueFRITZ! USB driver ver 1.1
usbcore: registered new interface driver bfusb
fuse init (API version 7.8)
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
nbd: registered device at major 43
drivers/media/video/usbvideo/quickcam_messenger.c: Logitech Quickcam Messenger USB v0.01
usbcore: registered new interface driver QCM
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
i2c /dev entries driver
NTFS driver 2.1.28 [Flags: R/W MODULE].
nxt200x: NXT2004 Detected
DVB: registering new adapter (saa7133[0]).
DVB: registering frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xd701a000 irq 18 registered as card -1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1959920k swap on /dev/sda2.  Priority:-1 extents:1 across:1959920k
skge eth0: enabling interface
skge eth0: Link is up at 100 Mbps, full duplex, flow control both
eth1: no link during initialization.
fbsplash: console 1 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 1
fbsplash: console 2 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 2
fbsplash: console 3 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 3
fbsplash: console 4 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 4
fbsplash: console 5 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 5
fbsplash: console 6 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 6
fbsplash: console 7 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 7
fbsplash: console 8 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 8
fbsplash: console 9 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 9
fbsplash: console 10 using theme 'livecd-2007.0'
fbsplash: switched splash state to 'on' on console 10
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
skge eth0: disabling interface
skge eth0: enabling interface
skge eth0: Link is up at 100 Mbps, full duplex, flow control both
eth1: no link during initialization.
ata5: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2 frozen
ata5: hard resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata5.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/133
ata5: EH complete
scsi 4:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
ata5: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg2 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-6, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<ffffffff80262d9c>] __rmqueue+0x6c/0x140
PGD 7b24f067 PUD 71ab9067 PMD 0 
Oops: 0000 [1] SMP 
CPU 1 
Modules linked in: rfcomm snd_seq snd_seq_device bridge llc acpi_memhotplug pciehp pci_hotplug kvm saa7134_alsa saa7134_dvb dvb_pll tda826x mt352 tda10086 video_buf_dvb dvb_core nxt200x isl6421 tda1004x udf ext4dev jbd2 dm_bbr ntfs vfat msdos fat i2c_amd756 i2c_dev usblp usb_storage uhci_hcd quickcam_messenger usbvideo nbd snd_pcm_oss snd_mixer_oss ieee80211_crypt_tkip ieee80211_crypt_ccmp ieee80211_crypt_wep ieee80211 ieee80211_crypt fuse aes bfusb bcm203x bnep sco hidp l2cap pwc hci_usb usbhid tuner saa7134 video_buf compat_ioctl32 ir_kbd_i2c ir_common videodev v4l2_common v4l1_compat i2c_nforce2 i2c_core ehci_hcd ohci_hcd k8temp sg
Pid: 9731, comm: rsync Not tainted 2.6.21-gentoo-r4 #1
RIP: 0010:[<ffffffff80262d9c>]  [<ffffffff80262d9c>] __rmqueue+0x6c/0x140
RSP: 0018:ffff81007266d4d8  EFLAGS: 00010013
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff81000000c600
RBP: ffff81000000c698 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000929 R11: 0000000000000001 R12: 0000000000000000
R13: ffff81007e3a0d40 R14: ffff81000000c600 R15: 000000000000001f
FS:  00002b548bc18ae0(0000) GS:ffff81007e3a0cc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000702d4000 CR4: 00000000000006e0
Process rsync (pid: 9731, threadinfo ffff81007266c000, task ffff8100711a4a20)
Stack:  0000000000000082 ffff81007e3a0d50 0000000000000000 0000000000000000
 ffff81007e3a0d40 ffffffff802645f0 ffff81007266d558 0000000000000001
 ffff81000000d868 000000018022d104 ffff81000000d860 0000005000000000
Call Trace:
 [<ffffffff802645f0>] get_page_from_freelist+0x1e0/0x4e0
 [<ffffffff80264be0>] __alloc_pages+0x180/0x300
 [<ffffffff802829a0>] kmem_getpages+0x70/0x140
 [<ffffffff80282fd4>] fallback_alloc+0x104/0x1c0
 [<ffffffff802836d7>] kmem_cache_alloc+0x97/0xb0
 [<ffffffff80323927>] journal_add_journal_head+0x27/0x170
 [<ffffffff8031fbc7>] journal_dirty_data+0x37/0x210
 [<ffffffff8030f34d>] ext3_journal_dirty_data+0x1d/0x50
 [<ffffffff8030e678>] walk_page_buffers+0x68/0xb0
 [<ffffffff8030f380>] journal_dirty_data_fn+0x0/0x20
 [<ffffffff80311978>] ext3_ordered_writepage+0x108/0x190
 [<ffffffff80268cc2>] shrink_inactive_list+0x442/0x8a0
 [<ffffffff8051506c>] __split_bio+0x3cc/0x3f0
 [<ffffffff803c85f1>] __up_read+0x21/0xb0
 [<ffffffff80515469>] dm_request+0x119/0x120
 [<ffffffff803ba9d9>] generic_make_request+0x159/0x170
 [<ffffffff80269216>] shrink_zone+0xf6/0x130
 [<ffffffff80269bf3>] try_to_free_pages+0x183/0x280
 [<ffffffff80264c3f>] __alloc_pages+0x1df/0x300
 [<ffffffff802666d4>] __do_page_cache_readahead+0xe4/0x290
 [<ffffffff80297f30>] __pollwait+0x0/0x120
 [<ffffffff80282662>] transfer_objects+0x52/0x80
 [<ffffffff8022d3a3>] __activate_task+0x33/0x50
 [<ffffffff802303ac>] try_to_wake_up+0x3dc/0x400
 [<ffffffff80516e95>] dm_table_any_congested+0x15/0x70
 [<ffffffff802668ed>] blockable_page_cache_readahead+0x6d/0xe0
 [<ffffffff802669e6>] make_ahead_window+0x86/0xb0
 [<ffffffff80266ba5>] page_cache_readahead+0x195/0x1e0
 [<ffffffff8025f647>] do_generic_mapping_read+0x127/0x410
 [<ffffffff8025ec50>] file_read_actor+0x0/0x140
 [<ffffffff8026169c>] generic_file_aio_read+0x16c/0x1b0
 [<ffffffff8028956f>] do_sync_read+0xcf/0x120
 [<ffffffff8024c110>] autoremove_wake_function+0x0/0x30
 [<ffffffff80289efb>] vfs_read+0xdb/0x180
 [<ffffffff8028a3c3>] sys_read+0x53/0x90
 [<ffffffff80209a5e>] system_call+0x7e/0x83


Code: 48 8b 08 48 8b 50 08 4c 8d 68 d8 48 89 51 08 48 89 0a 48 c7 
RIP  [<ffffffff80262d9c>] __rmqueue+0x6c/0x140
 RSP <ffff81007266d4d8>
CR2: 0000000000000000

--------------090409060207030403040904--
