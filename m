Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbXHBOQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbXHBOQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbXHBOQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:16:32 -0400
Received: from web52508.mail.re2.yahoo.com ([206.190.48.191]:40282 "HELO
	web52508.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753033AbXHBOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:16:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=sdtfU9b9Q6Fl+FC2Qbt+G0e+zBcYtsqNW+/ii0NFlpxF2n4Bc9dhSZ6w9Is9r02dK/Ve18ASSAlxPXKuDnO+2JKBqABZqX4C5Ho5UjqKaIReA1M33HUMc6zw8wH7aUslDRTm+SkxUI9RqTyXRSfQweiBtT1ULZjib/yEjUtmtx0=;
X-YMail-OSG: yNV81u8VM1m_x2XEpNeUq3qO.lhaPrlo8KYq0KQOxfU9AKGY8tTqz3DSr1hYofsphaGZS.oIVgG8Yt4AYHfld_hcGxUNmwNgVuv8DGkBOH7bZcMBHdHuE1ER3bx7czN_d1q9D3UIh41g5G5olH9uZk3yfA--
Date: Thu, 2 Aug 2007 07:16:28 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Woke up to a crashed kernet this morning
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <759418.99133.qm@web52508.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Found this in the log. Running 2.6.22,1,41,fc7 - I had
just upgraded the kernel last night using yum. And - I
was running a lot of backups using rsync and was
backing up to a usb connected drive. I'm not sure
which event triggered it but I'm guessing the latter
in that it's something I rarely do using usb.



Aug  2 01:54:09 bigdog kernel: ------------[ cut here
]------------
Aug  2 01:54:10 bigdog kernel: kernel BUG at
fs/jbd/journal.c:568!
Aug  2 01:54:10 bigdog kernel: invalid opcode: 0000
[1] SMP 
Aug  2 01:54:10 bigdog kernel: last sysfs file:
/block/sde/size
Aug  2 01:54:10 bigdog kernel: CPU 0 
Aug  2 01:54:10 bigdog kernel: Modules linked in:
iptable_filter ip_tables x_tables nvidia(P)(U) autofs4
ipv6 cpufreq_ondemand dm_mirror dm_mod raid0 video sbs
button dock battery ac lp loop sr_mod cdrom
snd_hda_intel snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_mixer_oss snd_pcm snd_timer firewire_ohci snd
soundcore snd_page_alloc k8temp firewire_core
crc_itu_t hwmon rtc_cmos parport_pc forcedeth
i2c_nforce2 shpchp serio_raw pata_amd floppy parport
i2c_core sg usb_storage sata_nv ata_generic libata
sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd
uhci_hcd
Aug  2 01:54:10 bigdog kernel: Pid: 10240, comm:
kjournald Tainted: P       2.6.22.1-41.fc7 #1
Aug  2 01:54:10 bigdog kernel: RIP:
0010:[<ffffffff8802cd3a>]  [<ffffffff8802cd3a>]
:jbd:journal_next_log_block+0x47/0x91
Aug  2 01:54:10 bigdog kernel: RSP:
0018:ffff8100bfe53e20  EFLAGS: 00010286
Aug  2 01:54:10 bigdog kernel: RAX: 0000000000000060
RBX: ffff8100bf841c00 RCX: ffffffff8136c308
Aug  2 01:54:10 bigdog kernel: RDX: 0000000100000000
RSI: 0000000000000082 RDI: 0000000000000000
Aug  2 01:54:10 bigdog kernel: RBP: ffff8100bfe53e90
R08: ffffffff8136c308 R09: 0000000000000000
Aug  2 01:54:10 bigdog kernel: R10: 0000000000000046
R11: ffffffff8101b6c2 R12: ffff81000fd5ad80
Aug  2 01:54:10 bigdog kernel: R13: ffff810007bc6e40
R14: 00000000000001fb R15: ffff81008ebadf94
Aug  2 01:54:11 bigdog kernel: FS: 
00002aaaaaac8f20(0000) GS:ffffffff813ad000(0000)
knlGS:00000000f7fe26c0
Aug  2 01:54:11 bigdog kernel: CS:  0010 DS: 0018 ES:
0018 CR0: 000000008005003b
Aug  2 01:54:11 bigdog kernel: CR2: 00002aaaaaac6000
CR3: 0000000127dda000 CR4: 00000000000006e0
Aug  2 01:54:11 bigdog kernel: Process kjournald (pid:
10240, threadinfo ffff8100bfe52000, task
ffff810107262000)
Aug  2 01:54:11 bigdog kernel: Stack: 
ffff810007bc6e40 ffff81006d89dde0 ffff8100bf841c00
ffffffff88029977
Aug  2 01:54:11 bigdog kernel:  ffff8100bfe50000
000001f0bfe53e98 0000006c00000000 0000008f00000000
Aug  2 01:54:11 bigdog kernel:  0000000000000000
ffff810107262000 ffffffff810443fd ffff8100bfe53e78
Aug  2 01:54:11 bigdog kernel: Call Trace:
Aug  2 01:54:11 bigdog kernel:  [<ffffffff88029977>]
:jbd:journal_commit_transaction+0x77d/0x106e
Aug  2 01:54:11 bigdog kernel:  [<ffffffff810443fd>]
autoremove_wake_function+0x0/0x2e
Aug  2 01:54:11 bigdog kernel:  [<ffffffff8802d0e3>]
:jbd:kjournald+0xb9/0x212
Aug  2 01:54:11 bigdog kernel:  [<ffffffff810443fd>]
autoremove_wake_function+0x0/0x2e
Aug  2 01:54:11 bigdog kernel:  [<ffffffff8802d02a>]
:jbd:kjournald+0x0/0x212
Aug  2 01:54:11 bigdog kernel:  [<ffffffff810442a8>]
kthread+0x47/0x73
Aug  2 01:54:11 bigdog kernel:  [<ffffffff8100a978>]
child_rip+0xa/0x12
Aug  2 01:54:11 bigdog kernel:  [<ffffffff81044261>]
kthread+0x0/0x73
Aug  2 01:54:11 bigdog kernel:  [<ffffffff8100a96e>]
child_rip+0x0/0x12
Aug  2 01:54:11 bigdog kernel: 
Aug  2 01:54:11 bigdog kernel: 
Aug  2 01:54:11 bigdog kernel: Code: 0f 0b eb fe 48 8b
b3 08 01 00 00 48 ff 8b 18 01 00 00 48 8d 
Aug  2 01:54:11 bigdog kernel: RIP 
[<ffffffff8802cd3a>]
:jbd:journal_next_log_block+0x47/0x91
Aug  2 01:54:11 bigdog kernel:  RSP <ffff8100bfe53e20>


And the hardware config:

Aug  2 06:36:12 bigdog syslogd 1.4.2: restart.
Aug  2 06:36:12 bigdog kernel: klogd 1.4.2, log source
= /proc/kmsg started.
Aug  2 06:36:12 bigdog kernel: Linux version
2.6.22.1-41.fc7
(kojibuilder@xenbuilder1.fedora.redhat.com) (gcc
version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP Fri
Jul 27 18:21:43 EDT 2007
Aug  2 06:36:12 bigdog kernel: Command line: ro
root=LABEL=/ pci=nommconf vga=794 iommu=soft
Aug  2 06:36:12 bigdog kernel: BIOS-provided physical
RAM map:
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
0000000000000000 - 000000000009f000 (usable)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
000000000009f000 - 00000000000a0000 (reserved)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
00000000000f0000 - 0000000000100000 (reserved)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
0000000000100000 - 00000000bfee0000 (usable)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
00000000bfee0000 - 00000000bfee3000 (ACPI NVS)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
00000000bfee3000 - 00000000bfef0000 (ACPI data)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
00000000bfef0000 - 00000000bff00000 (reserved)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
00000000c0000000 - 00000000d0000000 (reserved)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
00000000e0000000 - 00000000f0000000 (reserved)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
00000000fec00000 - 0000000100000000 (reserved)
Aug  2 06:36:12 bigdog kernel:  BIOS-e820:
0000000100000000 - 0000000130000000 (usable)
Aug  2 06:36:12 bigdog kernel: end_pfn_map = 1245184
Aug  2 06:36:12 bigdog kernel: DMI 2.4 present.
Aug  2 06:36:12 bigdog kernel: ACPI: RSDP 000F74B0,
0024 (r2 Nvidia)
Aug  2 06:36:12 bigdog kernel: ACPI: XSDT BFEE30C0,
004C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
Aug  2 06:36:12 bigdog kernel: ACPI: FACP BFEEB4C0,
00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        0)
Aug  2 06:36:12 bigdog kernel: ACPI: DSDT BFEE3240,
821E (r1 NVIDIA ASUSACPI     1000 MSFT  3000000)
Aug  2 06:36:12 bigdog kernel: ACPI: FACS BFEE0000,
0040
Aug  2 06:36:12 bigdog kernel: ACPI: SSDT BFEEB6C0,
01C4 (r1 PTLTD  POWERNOW        1  LTP        1)
Aug  2 06:36:12 bigdog kernel: ACPI: HPET BFEEB900,
0038 (r1 Nvidia ASUSACPI 42302E31 AWRD       98)
Aug  2 06:36:12 bigdog kernel: ACPI: MCFG BFEEB980,
003C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
Aug  2 06:36:12 bigdog kernel: ACPI: APIC BFEEB600,
007C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
Aug  2 06:36:12 bigdog kernel: Scanning NUMA topology
in Northbridge 24
Aug  2 06:36:12 bigdog kernel: No NUMA configuration
found
Aug  2 06:36:12 bigdog kernel: Faking a node at
0000000000000000-0000000130000000
Aug  2 06:36:12 bigdog kernel: Bootmem setup node 0
0000000000000000-0000000130000000
Aug  2 06:36:12 bigdog kernel: Zone PFN ranges:
Aug  2 06:36:12 bigdog kernel:   DMA             0 -> 
   4096
Aug  2 06:36:12 bigdog kernel:   DMA32        4096 -> 
1048576
Aug  2 06:36:12 bigdog kernel:   Normal    1048576 -> 
1245184
Aug  2 06:36:12 bigdog kernel: early_node_map[3]
active PFN ranges
Aug  2 06:36:12 bigdog kernel:     0:        0 ->     
159
Aug  2 06:36:12 bigdog kernel:     0:      256 ->  
786144
Aug  2 06:36:12 bigdog kernel:     0:  1048576 -> 
1245184
Aug  2 06:36:12 bigdog kernel: ACPI: PM-Timer IO Port:
0x4008
Aug  2 06:36:12 bigdog kernel: ACPI: LAPIC
(acpi_id[0x00] lapic_id[0x00] enabled)
Aug  2 06:36:12 bigdog kernel: Processor #0
(Bootup-CPU)
Aug  2 06:36:12 bigdog kernel: ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x01] enabled)
Aug  2 06:36:12 bigdog kernel: Processor #1
Aug  2 06:36:12 bigdog kernel: ACPI: LAPIC_NMI
(acpi_id[0x00] high edge lint[0x1])
Aug  2 06:36:12 bigdog kernel: ACPI: LAPIC_NMI
(acpi_id[0x01] high edge lint[0x1])
Aug  2 06:36:12 bigdog kernel: ACPI: IOAPIC (id[0x02]
address[0xfec00000] gsi_base[0])
Aug  2 06:36:12 bigdog kernel: IOAPIC[0]: apic_id 2,
address 0xfec00000, GSI 0-23
Aug  2 06:36:12 bigdog kernel: ACPI: INT_SRC_OVR (bus
0 bus_irq 0 global_irq 2 dfl dfl)
Aug  2 06:36:12 bigdog kernel: ACPI: INT_SRC_OVR (bus
0 bus_irq 9 global_irq 9 high level)
Aug  2 06:36:12 bigdog kernel: ACPI: INT_SRC_OVR (bus
0 bus_irq 14 global_irq 14 high edge)
Aug  2 06:36:12 bigdog kernel: ACPI: INT_SRC_OVR (bus
0 bus_irq 15 global_irq 15 high edge)
Aug  2 06:36:12 bigdog kernel: Setting APIC routing to
flat
Aug  2 06:36:12 bigdog kernel: ACPI: HPET id:
0x10de8201 base: 0xfefff000
Aug  2 06:36:12 bigdog kernel: Using ACPI (MADT) for
SMP configuration information
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 000000000009f000 -
00000000000a0000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000000a0000 -
00000000000f0000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000000f0000 -
0000000000100000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000bfee0000 -
00000000bfee3000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000bfee3000 -
00000000bfef0000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000bfef0000 -
00000000bff00000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000bff00000 -
00000000c0000000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000c0000000 -
00000000d0000000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000d0000000 -
00000000e0000000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000e0000000 -
00000000f0000000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000f0000000 -
00000000fec00000
Aug  2 06:36:12 bigdog kernel: swsusp: Registered
nosave memory region: 00000000fec00000 -
0000000100000000
Aug  2 06:36:12 bigdog kernel: Allocating PCI
resources starting at d1000000 (gap:
d0000000:10000000)
Aug  2 06:36:12 bigdog kernel: SMP: Allowing 2 CPUs, 0
hotplug CPUs
Aug  2 06:36:12 bigdog kernel: PERCPU: Allocating
40968 bytes of per cpu data
Aug  2 06:36:12 bigdog kernel: Built 1 zonelists. 
Total pages: 964329
Aug  2 06:36:12 bigdog kernel: Kernel command line: ro
root=LABEL=/ pci=nommconf vga=794 iommu=soft
Aug  2 06:36:12 bigdog kernel: Initializing CPU#0
Aug  2 06:36:12 bigdog kernel: PID hash table entries:
4096 (order: 12, 32768 bytes)
Aug  2 06:36:12 bigdog kernel: Extended CMOS year:
2000
Aug  2 06:36:12 bigdog kernel: Marking TSC unstable
due to TSCs unsynchronized
Aug  2 06:36:12 bigdog kernel: time.c: Detected
2004.179 MHz processor.
Aug  2 06:36:12 bigdog kernel: Console: colour dummy
device 80x25
Aug  2 06:36:12 bigdog kernel: Checking aperture...
Aug  2 06:36:12 bigdog kernel: CPU 0: aperture @ 0
size 32 MB
Aug  2 06:36:12 bigdog kernel: No AGP bridge found
Aug  2 06:36:12 bigdog kernel: PCI-DMA: Using software
bounce buffering for IO (SWIOTLB)
Aug  2 06:36:12 bigdog kernel: Placing software IO TLB
between 0x1021000 - 0x5021000
Aug  2 06:36:12 bigdog kernel: Memory:
3802288k/4980736k available (2362k kernel code,
128332k reserved, 1401k data, 312k init)
Aug  2 06:36:12 bigdog kernel: SLUB: Genslabs=23,
HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Aug  2 06:36:12 bigdog kernel: Calibrating delay using
timer specific routine.. 4011.03 BogoMIPS
(lpj=2005517)
Aug  2 06:36:12 bigdog kernel: Security Framework
v1.0.0 initialized
Aug  2 06:36:12 bigdog kernel: SELinux:  Initializing.
Aug  2 06:36:12 bigdog kernel:
selinux_register_security:  Registering secondary
module capability
Aug  2 06:36:12 bigdog kernel: Capability LSM
initialized as secondary
Aug  2 06:36:12 bigdog kernel: Dentry cache hash table
entries: 524288 (order: 10, 4194304 bytes)
Aug  2 06:36:12 bigdog kernel: Inode-cache hash table
entries: 262144 (order: 9, 2097152 bytes)
Aug  2 06:36:12 bigdog kernel: Mount-cache hash table
entries: 256
Aug  2 06:36:12 bigdog kernel: CPU: L1 I Cache: 64K
(64 bytes/line), D cache 64K (64 bytes/line)
Aug  2 06:36:12 bigdog kernel: CPU: L2 Cache: 512K (64
bytes/line)
Aug  2 06:36:12 bigdog kernel: CPU 0/0 -> Node 0
Aug  2 06:36:12 bigdog kernel: CPU: Physical Processor
ID: 0
Aug  2 06:36:12 bigdog kernel: CPU: Processor Core ID:
0
Aug  2 06:36:12 bigdog kernel: SMP alternatives:
switching to UP code
Aug  2 06:36:12 bigdog kernel: ACPI: Core revision
20070126
Aug  2 06:36:12 bigdog kernel: Using local APIC timer
interrupts.
Aug  2 06:36:12 bigdog kernel: result 12526118
Aug  2 06:36:12 bigdog kernel: Detected 12.526 MHz
APIC timer.
Aug  2 06:36:12 bigdog kernel: SMP alternatives:
switching to SMP code
Aug  2 06:36:12 bigdog kernel: Booting processor 1/2
APIC 0x1
Aug  2 06:36:12 bigdog kernel: Initializing CPU#1
Aug  2 06:36:12 bigdog kernel: Calibrating delay using
timer specific routine.. 4008.32 BogoMIPS
(lpj=2004164)
Aug  2 06:36:12 bigdog kernel: CPU: L1 I Cache: 64K
(64 bytes/line), D cache 64K (64 bytes/line)
Aug  2 06:36:12 bigdog kernel: CPU: L2 Cache: 512K (64
bytes/line)
Aug  2 06:36:12 bigdog kernel: CPU 1/1 -> Node 0
Aug  2 06:36:12 bigdog kernel: CPU: Physical Processor
ID: 0
Aug  2 06:36:12 bigdog kernel: CPU: Processor Core ID:
1
Aug  2 06:36:12 bigdog kernel: AMD Athlon(tm) 64 X2
Dual Core Processor 3800+ stepping 02
Aug  2 06:36:12 bigdog kernel: Brought up 2 CPUs
Aug  2 06:36:12 bigdog kernel: NET: Registered
protocol family 16
Aug  2 06:36:12 bigdog kernel: ACPI: bus type pci
registered
Aug  2 06:36:12 bigdog kernel: PCI: Using
configuration type 1
Aug  2 06:36:12 bigdog kernel: ACPI: Interpreter
enabled
Aug  2 06:36:12 bigdog kernel: ACPI: (supports S0 S1
S3 S4 S5)
Aug  2 06:36:12 bigdog kernel: ACPI: Using IOAPIC for
interrupt routing
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Root Bridge
[PCI0] (0000:00)
Aug  2 06:36:12 bigdog kernel: PCI: Transparent bridge
- 0000:00:10.0
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LNK7] (IRQs *5 7 9 10 11 14 15)
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LUBB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LMAC] (IRQs 5 7 9 10 *11 14 15)
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LACI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LMCI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LSID] (IRQs *5 7 9 10 11 14 15)
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [LFID] (IRQs *5 7 9 10 11 14 15)
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APC1] (IRQs 16) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APC2] (IRQs 17) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APC3] (IRQs 18) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APC4] (IRQs 19) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APC5] (IRQs 16) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APC6] (IRQs 16) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APC7] (IRQs 16) *0
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APC8] (IRQs 16) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCF] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCG] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCH] (IRQs 20 21 22 23) *0
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APMU] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [AAZA] (IRQs 20 21 22 23) *0
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCK] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCS] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCL] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCM] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APSI] (IRQs 20 21 22 23) *0
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APSJ] (IRQs 20 21 22 23) *0
Aug  2 06:36:12 bigdog kernel: Linux Plug and Play
Support v0.97 (c) Adam Belay
Aug  2 06:36:12 bigdog kernel: pnp: PnP ACPI init
Aug  2 06:36:12 bigdog kernel: ACPI: bus type pnp
registered
Aug  2 06:36:12 bigdog kernel: pnp: PnP ACPI: found 16
devices
Aug  2 06:36:12 bigdog kernel: ACPI: ACPI bus type pnp
unregistered
Aug  2 06:36:12 bigdog kernel: usbcore: registered new
interface driver usbfs
Aug  2 06:36:12 bigdog kernel: usbcore: registered new
interface driver hub
Aug  2 06:36:12 bigdog kernel: usbcore: registered new
device driver usb
Aug  2 06:36:12 bigdog kernel: PCI: Using ACPI for IRQ
routing
Aug  2 06:36:12 bigdog kernel: PCI: If a device
doesn't work, try "pci=routeirq".  If it helps, post a
report
Aug  2 06:36:12 bigdog kernel: NetLabel: Initializing
Aug  2 06:36:12 bigdog kernel: NetLabel:  domain hash
size = 128
Aug  2 06:36:12 bigdog kernel: NetLabel:  protocols =
UNLABELED CIPSOv4
Aug  2 06:36:12 bigdog kernel: NetLabel:  unlabeled
traffic allowed by default
Aug  2 06:36:12 bigdog kernel: hpet0: at MMIO
0xfefff000, IRQs 2, 8, 31
Aug  2 06:36:12 bigdog kernel: hpet0: 3 32-bit timers,
25000000 Hz
Aug  2 06:36:12 bigdog kernel: ACPI: RTC can wake from
S4
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: ioport
range 0x4000-0x407f has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: ioport
range 0x4080-0x40ff has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: ioport
range 0x4400-0x447f has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: ioport
range 0x4480-0x44ff has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: ioport
range 0x4800-0x487f has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: ioport
range 0x4880-0x48ff has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: ioport
range 0x2000-0x207f has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: ioport
range 0x2080-0x20ff has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:01: iomem range
0xc0000000-0xcfffffff could not be reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:0e: iomem range
0xe0000000-0xefffffff could not be reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:0f: iomem range
0xcec00-0xcffff has been reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:0f: iomem range
0xf0000-0xf7fff could not be reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:0f: iomem range
0xf8000-0xfbfff could not be reserved
Aug  2 06:36:12 bigdog kernel: pnp: 00:0f: iomem range
0xfc000-0xfffff could not be reserved
Aug  2 06:36:12 bigdog kernel: Time: hpet clocksource
has been installed.
Aug  2 06:36:12 bigdog kernel: PCI: Bridge:
0000:00:02.0
Aug  2 06:36:12 bigdog kernel:   IO window: a000-afff
Aug  2 06:36:12 bigdog kernel:   MEM window:
fd800000-fd8fffff
Aug  2 06:36:12 bigdog kernel:   PREFETCH window:
fd700000-fd7fffff
Aug  2 06:36:12 bigdog kernel: PCI: Bridge:
0000:00:03.0
Aug  2 06:36:12 bigdog kernel:   IO window: 8000-8fff
Aug  2 06:36:12 bigdog kernel:   MEM window:
fde00000-fdefffff
Aug  2 06:36:12 bigdog kernel:   PREFETCH window:
fdd00000-fddfffff
Aug  2 06:36:12 bigdog kernel: PCI: Bridge:
0000:00:04.0
Aug  2 06:36:12 bigdog kernel:   IO window: b000-bfff
Aug  2 06:36:12 bigdog kernel:   MEM window:
fdc00000-fdcfffff
Aug  2 06:36:12 bigdog kernel:   PREFETCH window:
fd900000-fd9fffff
Aug  2 06:36:12 bigdog kernel: PCI: Bridge:
0000:00:10.0
Aug  2 06:36:12 bigdog kernel:   IO window: 9000-9fff
Aug  2 06:36:12 bigdog kernel:   MEM window:
fdb00000-fdbfffff
Aug  2 06:36:12 bigdog kernel:   PREFETCH window:
fda00000-fdafffff
Aug  2 06:36:12 bigdog kernel: NET: Registered
protocol family 2
Aug  2 06:36:12 bigdog kernel: IP route cache hash
table entries: 131072 (order: 8, 1048576 bytes)
Aug  2 06:36:12 bigdog kernel: TCP established hash
table entries: 524288 (order: 11, 12582912 bytes)
Aug  2 06:36:12 bigdog kernel: TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Aug  2 06:36:12 bigdog kernel: TCP: Hash tables
configured (established 524288 bind 65536)
Aug  2 06:36:12 bigdog kernel: TCP reno registered
Aug  2 06:36:12 bigdog kernel: checking if image is
initramfs... it is
Aug  2 06:36:12 bigdog kernel: Freeing initrd memory:
3125k freed
Aug  2 06:36:12 bigdog kernel: audit: initializing
netlink socket (disabled)
Aug  2 06:36:12 bigdog kernel:
audit(1186036525.604:1): initialized
Aug  2 06:36:12 bigdog kernel: Total HugeTLB memory
allocated, 0
Aug  2 06:36:12 bigdog kernel: VFS: Disk quotas
dquot_6.5.1
Aug  2 06:36:12 bigdog kernel: Dquot-cache hash table
entries: 512 (order 0, 4096 bytes)
Aug  2 06:36:12 bigdog kernel: ksign: Installing
public key data
Aug  2 06:36:12 bigdog kernel: Loading keyring
Aug  2 06:36:12 bigdog kernel: - Added public key
8321A2A758C22C88
Aug  2 06:36:12 bigdog kernel: - User ID: Red Hat,
Inc. (Kernel Module GPG key)
Aug  2 06:36:12 bigdog kernel: io scheduler noop
registered
Aug  2 06:36:12 bigdog kernel: io scheduler
anticipatory registered
Aug  2 06:36:12 bigdog kernel: io scheduler deadline
registered
Aug  2 06:36:12 bigdog kernel: io scheduler cfq
registered (default)
Aug  2 06:36:12 bigdog kernel: assign_interrupt_mode
Found MSI capability
Aug  2 06:36:12 bigdog last message repeated 2 times
Aug  2 06:36:12 bigdog kernel: pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Aug  2 06:36:12 bigdog kernel: vesafb: framebuffer at
0xd0000000, mapped to 0xffffc20001480000, using 5120k,
total 262144k
Aug  2 06:36:12 bigdog kernel: vesafb: mode is
1280x1024x16, linelength=2560, pages=1
Aug  2 06:36:12 bigdog kernel: vesafb: scrolling:
redraw
Aug  2 06:36:12 bigdog kernel: vesafb: Truecolor:
size=0:5:6:5, shift=0:11:5:0
Aug  2 06:36:12 bigdog kernel: Console: switching to
colour frame buffer device 160x64
Aug  2 06:36:12 bigdog kernel: fb0: VESA VGA frame
buffer device
Aug  2 06:36:12 bigdog kernel: ACPI: Fan [FAN] (on)
Aug  2 06:36:12 bigdog kernel: ACPI: Thermal Zone
[THRM] (40 C)
Aug  2 06:36:12 bigdog kernel: Generic RTC Driver
v1.07
Aug  2 06:36:12 bigdog kernel: Non-volatile memory
driver v1.2
Aug  2 06:36:12 bigdog kernel: Linux agpgart interface
v0.102 (c) Dave Jones
Aug  2 06:36:12 bigdog kernel: Serial: 8250/16550
driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Aug  2 06:36:12 bigdog kernel: 00:09: ttyS0 at I/O
0x3f8 (irq = 4) is a 16550A
Aug  2 06:36:12 bigdog kernel: 00:0a: ttyS1 at I/O
0x2f8 (irq = 3) is a 16550A
Aug  2 06:36:12 bigdog kernel: RAMDISK driver
initialized: 16 RAM disks of 16384K size 4096
blocksize
Aug  2 06:36:12 bigdog kernel: input: Macintosh mouse
button emulation as /class/input/input0
Aug  2 06:36:12 bigdog kernel: PNP: PS/2 Controller
[PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Aug  2 06:36:12 bigdog kernel: serio: i8042 KBD port
at 0x60,0x64 irq 1
Aug  2 06:36:12 bigdog kernel: serio: i8042 AUX port
at 0x60,0x64 irq 12
Aug  2 06:36:12 bigdog kernel: mice: PS/2 mouse device
common for all mice
Aug  2 06:36:12 bigdog kernel: input: AT Translated
Set 2 keyboard as /class/input/input1
Aug  2 06:36:12 bigdog kernel: usbcore: registered new
interface driver hiddev
Aug  2 06:36:12 bigdog kernel: usbcore: registered new
interface driver usbhid
Aug  2 06:36:12 bigdog kernel:
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core
driver
Aug  2 06:36:12 bigdog kernel: TCP cubic registered
Aug  2 06:36:12 bigdog kernel: Initializing XFRM
netlink socket
Aug  2 06:36:12 bigdog kernel: NET: Registered
protocol family 1
Aug  2 06:36:12 bigdog kernel: NET: Registered
protocol family 17
Aug  2 06:36:12 bigdog kernel: powernow-k8: Found 2
AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
processors (version 2.00.00)
Aug  2 06:36:12 bigdog kernel: powernow-k8:    0 : fid
0xc (2000 MHz), vid 0xe
Aug  2 06:36:12 bigdog kernel: powernow-k8:    1 : fid
0xa (1800 MHz), vid 0x10
Aug  2 06:36:12 bigdog kernel: powernow-k8:    2 : fid
0x2 (1000 MHz), vid 0x12
Aug  2 06:36:12 bigdog kernel: drivers/rtc/hctosys.c:
unable to open rtc device (rtc0)
Aug  2 06:36:12 bigdog kernel: Freeing unused kernel
memory: 312k freed
Aug  2 06:36:12 bigdog kernel: Write protecting the
kernel read-only data: 1060k
Aug  2 06:36:12 bigdog kernel: USB Universal Host
Controller Interface driver v3.0
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCF] enabled at IRQ 23
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
0000:00:0b.0[A] -> Link [APCF] -> GSI 23 (level, low)
-> IRQ 23
Aug  2 06:36:12 bigdog kernel: ohci_hcd 0000:00:0b.0:
OHCI Host Controller
Aug  2 06:36:12 bigdog kernel: ohci_hcd 0000:00:0b.0:
new USB bus registered, assigned bus number 1
Aug  2 06:36:12 bigdog kernel: ohci_hcd 0000:00:0b.0:
irq 23, io mem 0xfe02f000
Aug  2 06:36:12 bigdog kernel: usb usb1: configuration
#1 chosen from 1 choice
Aug  2 06:36:12 bigdog kernel: hub 1-0:1.0: USB hub
found
Aug  2 06:36:12 bigdog kernel: hub 1-0:1.0: 8 ports
detected
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APCL] enabled at IRQ 22
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
0000:00:0b.1[B] -> Link [APCL] -> GSI 22 (level, low)
-> IRQ 22
Aug  2 06:36:12 bigdog kernel: ehci_hcd 0000:00:0b.1:
EHCI Host Controller
Aug  2 06:36:12 bigdog kernel: ehci_hcd 0000:00:0b.1:
new USB bus registered, assigned bus number 2
Aug  2 06:36:12 bigdog kernel: ehci_hcd 0000:00:0b.1:
debug port 1
Aug  2 06:36:12 bigdog kernel: ehci_hcd 0000:00:0b.1:
irq 22, io mem 0xfe02e000
Aug  2 06:36:12 bigdog kernel: ehci_hcd 0000:00:0b.1:
USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Aug  2 06:36:12 bigdog kernel: usb usb2: configuration
#1 chosen from 1 choice
Aug  2 06:36:12 bigdog kernel: hub 2-0:1.0: USB hub
found
Aug  2 06:36:12 bigdog kernel: input: PS/2 Generic
Mouse as /class/input/input2
Aug  2 06:36:12 bigdog kernel: hub 2-0:1.0: 8 ports
detected
Aug  2 06:36:12 bigdog kernel: SCSI subsystem
initialized
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
Link [APSI] enabled at IRQ 21
Aug  2 06:36:12 bigdog kernel: ACPI: PCI Interrupt
0000:00:0e.0[A] -> Link [APSI] -> GSI 21 (level, low)
-> IRQ 21
Aug  2 06:36:12 bigdog kernel: scsi0 : sata_nv
Aug  2 06:36:12 bigdog kernel: scsi1 : sata_nv
Aug  2 06:36:12 bigdog kernel: ata1: SATA max UDMA/133
cmd 0x00000000000109f0 ctl 0x0000000000010bf2 bmdma
0x000000000001e000 irq 21
Aug  2 06:36:12 bigdog kernel: ata2: SATA max UDMA/133
cmd 0x0000000000010970 ctl 0x0000000000010b72 bmdma
0x000000000001e008 irq 21
Aug  2 06:36:12 bigdog kernel: usb 2-3: new high speed
USB device using ehci_hcd and address 2
Aug  2 06:36:12 bigdog kernel: usb 2-3: configuration
#1 chosen from 1 choice
Aug  2 06:36:12 bigdog kernel: ata1: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Aug  2 06:36:12 bigdog kernel: ata1.00: Host Protected
Area detected:
Aug  2 06:36:12 bigdog kernel: 	current size:
586112591 sectors
Aug  2 06:36:12 bigdog kernel: 	native size: 586114704
sectors
Aug  2 06:36:12 bigdog kernel: ata1.00: ATA-7: Maxtor
7L300S0, BANC1G10, max UDMA/133
Aug  2 06:36:12 bigdog kernel: ata1.00: 586112591
sectors, multi 1: LBA48 NCQ (depth 0/32)
Aug  2 06:36:12 bigdog kernel: ata1.00: Host Protected
Area detected:
Aug  2 06:36:12 bigdog kernel: 	current size:
586112591 sectors
Aug  2 06:36:12 bigdog kernel: 	native size: 586114704
sectors
Aug  2 06:36:12 bigdog kernel: ata1.00: configured for
UDMA/133
Aug  2 06:36:12 bigdog kernel: usb 1-7: new full speed
USB device using ohci_hcd and address 2
Aug  2 06:36:12 bigdog kernel: usb 1-7: device
descriptor read/64, error -62
Aug  2 06:36:12 bigdog kernel: ata2: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Aug  2 06:36:12 bigdog kernel: ata2.00: ATA-7: Maxtor
7L300S0, BANC1G10, max UDMA/133
Aug  2 06:36:12 bigdog kernel: ata2.00: 586114704
sectors, multi 1: LBA48 NCQ (depth 0/32)
Aug  2 06:36:12 bigdog kernel: ata2.00: configured for
UDMA/133
Aug  2 06:36:12 bigdog kernel: scsi 0:0:0:0:
Direct-Access     ATA      Maxtor 7L300S0   BANC PQ: 0
ANSI: 5
Aug  2 06:36:12 bigdog kernel: sd 0:0:0:0: [sda]
586112591 512-byte hardware sectors (300090 MB)
Aug  2 06:36:12 bigdog kernel: sd 0:0:0:0: [sda] Write
Protect is off
Aug  2 06:36:12 bigdog kernel: sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support
DPO or FUA
Aug  2 06:36:12 bigdog kernel: sd 0:0:0:0: [sda]
586112591 512-byte hardware sectors (300090 MB)
Aug  2 06:36:12 bigdog kernel: sd 0:0:0:0: [sda] Write
Protect is off
Aug  2 06:36:12 bigdog kernel: sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support
DPO or FUA
Aug  2 06:36:12 bigdog kernel: usb 1-7: device
descriptor read/64, error -62
Aug  2 06:36:12 bigdog kernel:  sda: sda1 sda2 sda3
Aug  2 06:36:12 bigdog kernel: sd 0:0:0:0: [sda]
Attached SCSI disk
Aug  2 06:36:13 bigdog kernel: scsi 1:0:0:0:
Direct-Access     ATA      Maxtor 7L300S0   BANC PQ: 0
ANSI: 5
Aug  2 06:36:13 bigdog kernel: sd 1:0:0:0: [sdb]
586114704 512-byte hardware sectors (300091 MB)
Aug  2 06:36:13 bigdog kernel: sd 1:0:0:0: [sdb] Write
Protect is off
Aug  2 06:36:13 bigdog kernel: sd 1:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support
DPO or FUA
Aug  2 06:36:14 bigdog kernel: sd 1:0:0:0: [sdb]
586114704 512-byte hardware sectors (300091 MB)
Aug  2 06:36:14 bigdog kernel: sd 1:0:0:0: [sdb] Write
Protect is off
Aug  2 06:36:14 bigdog kernel: sd 1:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support
DPO or FUA
Aug  2 06:36:14 bigdog kernel:  sdb: sdb1 sdb2 sdb3
Aug  2 06:36:14 bigdog kernel: sd 1:0:0:0: [sdb]
Attached SCSI disk
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
Link [APSJ] enabled at IRQ 20
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
0000:00:0f.0[A] -> Link [APSJ] -> GSI 20 (level, low)
-> IRQ 20
Aug  2 06:36:14 bigdog kernel: scsi2 : sata_nv
Aug  2 06:36:14 bigdog kernel: scsi3 : sata_nv
Aug  2 06:36:14 bigdog kernel: ata3: SATA max UDMA/133
cmd 0x00000000000109e0 ctl 0x0000000000010be2 bmdma
0x000000000001cc00 irq 20
Aug  2 06:36:14 bigdog kernel: ata4: SATA max UDMA/133
cmd 0x0000000000010960 ctl 0x0000000000010b62 bmdma
0x000000000001cc08 irq 20
Aug  2 06:36:14 bigdog kernel: usb 1-7: new full speed
USB device using ohci_hcd and address 3
Aug  2 06:36:14 bigdog kernel: usb 1-7: device
descriptor read/64, error -62
Aug  2 06:36:14 bigdog kernel: usb 1-7: device
descriptor read/64, error -62
Aug  2 06:36:14 bigdog kernel: ata3: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Aug  2 06:36:14 bigdog kernel: ata3.00: ATA-7: Maxtor
7L300S0, BANC1G10, max UDMA/133
Aug  2 06:36:14 bigdog kernel: ata3.00: 586114704
sectors, multi 1: LBA48 NCQ (depth 0/32)
Aug  2 06:36:14 bigdog kernel: ata3.00: configured for
UDMA/133
Aug  2 06:36:14 bigdog kernel: usb 1-7: new full speed
USB device using ohci_hcd and address 4
Aug  2 06:36:14 bigdog kernel: ata4: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Aug  2 06:36:14 bigdog kernel: ata4.00: ATA-7: Maxtor
7L300S0, BANC1G10, max UDMA/133
Aug  2 06:36:14 bigdog kernel: ata4.00: 586114704
sectors, multi 1: LBA48 NCQ (depth 0/32)
Aug  2 06:36:14 bigdog kernel: ata4.00: configured for
UDMA/133
Aug  2 06:36:14 bigdog kernel: scsi 2:0:0:0:
Direct-Access     ATA      Maxtor 7L300S0   BANC PQ: 0
ANSI: 5
Aug  2 06:36:14 bigdog kernel: sd 2:0:0:0: [sdc]
586114704 512-byte hardware sectors (300091 MB)
Aug  2 06:36:14 bigdog kernel: sd 2:0:0:0: [sdc] Write
Protect is off
Aug  2 06:36:14 bigdog kernel: sd 2:0:0:0: [sdc] Write
cache: enabled, read cache: enabled, doesn't support
DPO or FUA
Aug  2 06:36:14 bigdog kernel: sd 2:0:0:0: [sdc]
586114704 512-byte hardware sectors (300091 MB)
Aug  2 06:36:14 bigdog kernel: sd 2:0:0:0: [sdc] Write
Protect is off
Aug  2 06:36:14 bigdog kernel: sd 2:0:0:0: [sdc] Write
cache: enabled, read cache: enabled, doesn't support
DPO or FUA
Aug  2 06:36:14 bigdog kernel: usb 1-7: device not
accepting address 4, error -62
Aug  2 06:36:14 bigdog kernel:  sdc: sdc1
Aug  2 06:36:14 bigdog kernel: sd 2:0:0:0: [sdc]
Attached SCSI disk
Aug  2 06:36:14 bigdog kernel: scsi 3:0:0:0:
Direct-Access     ATA      Maxtor 7L300S0   BANC PQ: 0
ANSI: 5
Aug  2 06:36:14 bigdog kernel: sd 3:0:0:0: [sdd]
586114704 512-byte hardware sectors (300091 MB)
Aug  2 06:36:14 bigdog kernel: sd 3:0:0:0: [sdd] Write
Protect is off
Aug  2 06:36:14 bigdog kernel: sd 3:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support
DPO or FUA
Aug  2 06:36:14 bigdog kernel: sd 3:0:0:0: [sdd]
586114704 512-byte hardware sectors (300091 MB)
Aug  2 06:36:14 bigdog kernel: sd 3:0:0:0: [sdd] Write
Protect is off
Aug  2 06:36:14 bigdog kernel: sd 3:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support
DPO or FUA
Aug  2 06:36:14 bigdog kernel: usb 1-7: new full speed
USB device using ohci_hcd and address 5
Aug  2 06:36:14 bigdog kernel:  sdd: sdd1
Aug  2 06:36:14 bigdog kernel: sd 3:0:0:0: [sdd]
Attached SCSI disk
Aug  2 06:36:14 bigdog kernel: usb 1-7: device not
accepting address 5, error -62
Aug  2 06:36:14 bigdog kernel: Initializing USB Mass
Storage driver...
Aug  2 06:36:14 bigdog kernel: scsi4 : SCSI emulation
for USB Mass Storage devices
Aug  2 06:36:14 bigdog kernel: usbcore: registered new
interface driver usb-storage
Aug  2 06:36:14 bigdog kernel: USB Mass Storage
support registered.
Aug  2 06:36:14 bigdog kernel: scsi 4:0:0:0:
Direct-Access     Maxtor   OneTouch II      023g PQ: 0
ANSI: 4
Aug  2 06:36:14 bigdog kernel: sd 4:0:0:0: [sde]
586114704 512-byte hardware sectors (300091 MB)
Aug  2 06:36:14 bigdog kernel: sd 4:0:0:0: [sde] Write
Protect is off
Aug  2 06:36:14 bigdog kernel: sd 4:0:0:0: [sde]
Assuming drive cache: write through
Aug  2 06:36:14 bigdog kernel: sd 4:0:0:0: [sde]
586114704 512-byte hardware sectors (300091 MB)
Aug  2 06:36:14 bigdog kernel: sd 4:0:0:0: [sde] Write
Protect is off
Aug  2 06:36:14 bigdog kernel: sd 4:0:0:0: [sde]
Assuming drive cache: write through
Aug  2 06:36:14 bigdog kernel:  sde: sde1
Aug  2 06:36:14 bigdog kernel: sd 4:0:0:0: [sde]
Attached SCSI disk
Aug  2 06:36:14 bigdog kernel: EXT3-fs: INFO: recovery
required on readonly filesystem.
Aug  2 06:36:14 bigdog kernel: EXT3-fs: write access
will be enabled during recovery.
Aug  2 06:36:14 bigdog kernel: kjournald starting. 
Commit interval 5 seconds
Aug  2 06:36:14 bigdog kernel: EXT3-fs: sda3: orphan
cleanup on readonly fs
Aug  2 06:36:14 bigdog kernel: EXT3-fs: sda3: 28
orphan inodes deleted
Aug  2 06:36:14 bigdog kernel: EXT3-fs: recovery
complete.
Aug  2 06:36:14 bigdog kernel: EXT3-fs: mounted
filesystem with ordered data mode.
Aug  2 06:36:14 bigdog kernel: SELinux:  Disabled at
runtime.
Aug  2 06:36:14 bigdog kernel:
audit(1186036541.534:2): selinux=0 auid=4294967295
Aug  2 06:36:14 bigdog kernel: sd 0:0:0:0: Attached
scsi generic sg0 type 0
Aug  2 06:36:14 bigdog kernel: sd 1:0:0:0: Attached
scsi generic sg1 type 0
Aug  2 06:36:14 bigdog kernel: sd 2:0:0:0: Attached
scsi generic sg2 type 0
Aug  2 06:36:14 bigdog kernel: sd 3:0:0:0: Attached
scsi generic sg3 type 0
Aug  2 06:36:14 bigdog kernel: sd 4:0:0:0: Attached
scsi generic sg4 type 0
Aug  2 06:36:14 bigdog kernel: parport_pc 00:0b:
reported by Plug and Play ACPI
Aug  2 06:36:14 bigdog kernel: parport0: PC-style at
0x378, irq 7 [PCSPP,TRISTATE,EPP]
Aug  2 06:36:14 bigdog kernel: forcedeth.c: Reverse
Engineered nForce ethernet driver. Version 0.60.
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
Link [APCH] enabled at IRQ 23
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
0000:00:14.0[A] -> Link [APCH] -> GSI 23 (level, low)
-> IRQ 23
Aug  2 06:36:14 bigdog kernel: forcedeth: using
HIGHDMA
Aug  2 06:36:14 bigdog kernel: Floppy drive(s): fd0 is
1.44M
Aug  2 06:36:14 bigdog kernel: FDC 0 is a post-1991
82077
Aug  2 06:36:14 bigdog kernel: rtc_cmos 00:05: rtc
core: registered rtc_cmos as rtc0
Aug  2 06:36:14 bigdog kernel: rtc0: alarms up to one
year, y3k
Aug  2 06:36:14 bigdog kernel: nvidia: module license
'NVIDIA' taints kernel.
Aug  2 06:36:14 bigdog kernel: eth0: forcedeth.c:
subsystem: 01043:816a bound to 0000:00:14.0
Aug  2 06:36:14 bigdog kernel: i2c-adapter i2c-0:
nForce2 SMBus adapter at 0x4c00
Aug  2 06:36:14 bigdog kernel: i2c-adapter i2c-1:
nForce2 SMBus adapter at 0x4c40
Aug  2 06:36:14 bigdog kernel: scsi5 : pata_amd
Aug  2 06:36:14 bigdog kernel: scsi6 : pata_amd
Aug  2 06:36:14 bigdog kernel: ata5: PATA max UDMA/133
cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma
0x000000000001f400 irq 14
Aug  2 06:36:14 bigdog kernel: ata6: PATA max UDMA/133
cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma
0x000000000001f408 irq 15
Aug  2 06:36:14 bigdog kernel: ata5.01: ATAPI: LITE-ON
DVD SOHD-16P9S, FS09, max UDMA/33
Aug  2 06:36:14 bigdog kernel: ata5.01: configured for
UDMA/33
Aug  2 06:36:14 bigdog kernel: scsi 5:0:1:0: CD-ROM   
        LITE-ON  DVD SOHD-16P9S   FS09 PQ: 0 ANSI: 5
Aug  2 06:36:14 bigdog kernel: scsi 5:0:1:0: Attached
scsi generic sg5 type 5
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
Link [APC4] enabled at IRQ 19
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
0000:04:05.0[A] -> Link [APC4] -> GSI 19 (level, low)
-> IRQ 19
Aug  2 06:36:14 bigdog kernel: firewire_ohci: Added
fw-ohci device 0000:04:05.0, OHCI version 1.10
Aug  2 06:36:14 bigdog kernel: shpchp: Standard Hot
Plug PCI Controller Driver version: 0.4
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
Link [AAZA] enabled at IRQ 22
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
0000:00:10.1[B] -> Link [AAZA] -> GSI 22 (level, low)
-> IRQ 22
Aug  2 06:36:14 bigdog kernel: sr0: scsi3-mmc drive:
4x/48x cd/rw xa/form2 cdda tray
Aug  2 06:36:14 bigdog kernel: Uniform CD-ROM driver
Revision: 3.20
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
Link [APC7] enabled at IRQ 16
Aug  2 06:36:14 bigdog kernel: ACPI: PCI Interrupt
0000:00:05.0[A] -> Link [APC7] -> GSI 16 (level, low)
-> IRQ 16
Aug  2 06:36:14 bigdog kernel: NVRM: loading NVIDIA
UNIX x86_64 Kernel Module  100.14.11  Wed Jun 13
16:33:22 PDT 2007
Aug  2 06:36:14 bigdog kernel: firewire_core: created
new fw device fw0 (0 config rom retries)
Aug  2 06:36:14 bigdog kernel: loop: module loaded
Aug  2 06:36:14 bigdog kernel: lp0: using parport0
(interrupt-driven).
Aug  2 06:36:14 bigdog kernel: lp0: console ready
Aug  2 06:36:14 bigdog kernel: No dock devices found.
Aug  2 06:36:14 bigdog kernel: input: Power Button
(FF) as /class/input/input3
Aug  2 06:36:14 bigdog kernel: ACPI: Power Button (FF)
[PWRF]
Aug  2 06:36:14 bigdog kernel: input: Power Button
(CM) as /class/input/input4
Aug  2 06:36:14 bigdog kernel: ACPI: Power Button (CM)
[PWRB]
Aug  2 06:36:14 bigdog kernel: md: md0 stopped.
Aug  2 06:36:14 bigdog kernel: md: bind<sdd1>
Aug  2 06:36:14 bigdog kernel: md: bind<sdc1>
Aug  2 06:36:14 bigdog kernel: md: raid0 personality
registered for level 0
Aug  2 06:36:14 bigdog kernel: md0: setting
max_sectors to 128, segment boundary to 32767
Aug  2 06:36:14 bigdog kernel: raid0: looking at sdc1
Aug  2 06:36:14 bigdog kernel: raid0:   comparing
sdc1(293049600) with sdc1(293049600)
Aug  2 06:36:14 bigdog kernel: raid0:   END
Aug  2 06:36:14 bigdog kernel: raid0:   ==> UNIQUE
Aug  2 06:36:14 bigdog kernel: raid0: 1 zones
Aug  2 06:36:14 bigdog kernel: raid0: looking at sdd1
Aug  2 06:36:14 bigdog kernel: raid0:   comparing
sdd1(293049600) with sdc1(293049600)
Aug  2 06:36:14 bigdog kernel: raid0:   EQUAL
Aug  2 06:36:14 bigdog kernel: raid0: FINAL 1 zones
Aug  2 06:36:14 bigdog kernel: raid0: done.
Aug  2 06:36:14 bigdog kernel: raid0 : md_size is
586099200 blocks.
Aug  2 06:36:14 bigdog kernel: raid0 :
conf->hash_spacing is 586099200 blocks.
Aug  2 06:36:14 bigdog kernel: raid0 : nb_zone is 1.
Aug  2 06:36:14 bigdog kernel: raid0 : Allocating 8
bytes for hash.
Aug  2 06:36:14 bigdog kernel: device-mapper: ioctl:
4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.com
Aug  2 06:36:14 bigdog kernel: EXT3 FS on sda3,
internal journal
Aug  2 06:36:14 bigdog kernel: kjournald starting. 
Commit interval 5 seconds
Aug  2 06:36:14 bigdog kernel: EXT3 FS on sda1,
internal journal
Aug  2 06:36:14 bigdog kernel: EXT3-fs: mounted
filesystem with ordered data mode.
Aug  2 06:36:14 bigdog kernel: kjournald starting. 
Commit interval 5 seconds
Aug  2 06:36:14 bigdog kernel: EXT3 FS on md0,
internal journal
Aug  2 06:36:14 bigdog kernel: EXT3-fs: recovery
complete.
Aug  2 06:36:14 bigdog kernel: EXT3-fs: mounted
filesystem with writeback data mode.
Aug  2 06:36:14 bigdog kernel: kjournald starting. 
Commit interval 5 seconds
Aug  2 06:36:14 bigdog kernel: EXT3 FS on sdb3,
internal journal
Aug  2 06:36:14 bigdog kernel: EXT3-fs: recovery
complete.
Aug  2 06:36:14 bigdog kernel: EXT3-fs: mounted
filesystem with ordered data mode.
Aug  2 06:36:14 bigdog kernel: Adding 3068404k swap on
/dev/sdb2.  Priority:-1 extents:1 across:3068404k
Aug  2 06:36:14 bigdog kernel: Adding 3068404k swap on
/dev/sda2.  Priority:-2 extents:1 across:3068404k
Aug  2 06:36:14 bigdog kernel: NET: Registered
protocol family 10
Aug  2 06:36:14 bigdog kernel: lo: Disabled Privacy
Extensions
Aug  2 06:36:14 bigdog kernel: Mobile IPv6



       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433
