Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZBPVSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZBPVSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbZBPVSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:18:40 -0500
Received: from smtp-7.star.net.uk ([212.125.75.76]:50692 "HELO
	smtp-7.star.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750718AbZBPVSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:18:35 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Feb 2009 16:18:33 EST
Date: Mon, 16 Feb 2009 21:10:12 +0000
From: Bob Wilkinson <bob@fourtheye.org>
To: linux-kernel@vger.kernel.org
Subject: [PROBLEM] Multiple BUG: unable to handle kernel paging request
Message-ID: <20090216211012.GA31416@fourtheye.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
X-Operating-System: Linux spain 2.6.26-1-sparc64
X-Debian-Version: 5.0
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello

     I have been having many problems with the stability of one of
my machines. It does have a lot of attached peripherals, and
regularly crashes. It does not always boot. I have attached as much
information as I know to.

There are multiple 

BUG: unable to handle kernel paging request 

lines in the kernel log.

I would appreciate being cc:ed on replies since I do not subscribe.

Bob

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ver_linux.op"
Content-Transfer-Encoding: quoted-printable

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
=20
Linux italy 2.6.26-1-686 #1 SMP Sat Jan 10 18:29:31 UTC 2009 i686 GNU/Linux
=20
Gnu C                  4.3.3-3)
Gnu make               3.81
binutils               Binutils
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.41.3
PPP                    2.4.4
Linux C Library        > libc.2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
wireless-tools         29
Modules Loaded         nls_utf8 isofs zlib_inflate udf nls_base crc_itu_t x=
t_multiport iptable_filter ip_tables x_tables binfmt_misc ppdev lp ipv6 rad=
eon drm loop snd_bt87x snd_ens1371 gameport snd_ac97_codec ac97_bus snd_pcm=
_oss snd_mixer_oss snd_pcm parport_pc parport serio_raw psmouse via_ircc ir=
da snd_seq_dummy crc_ccitt i2c_viapro pcspkr tuner_simple tuner_types snd_s=
eq_oss snd_seq_midi snd_rawmidi tuner snd_seq_midi_event snd_seq tvaudio bu=
tton snd_timer snd_seq_device snd bttv videodev v4l1_compat firmware_class =
ir_common compat_ioctl32 soundcore i2c_algo_bit snd_page_alloc v4l2_common =
videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_core shpchp pci_hotplu=
g via_agp agpgart evdev ext3 jbd mbcache sha256_generic aes_i586 aes_generi=
c cbc sd_mod usb_storage dm_crypt crypto_blkcipher dm_mirror dm_log dm_snap=
shot dm_mod ide_cd_mod cdrom ide_disk ata_generic libata scsi_mod dock via8=
2cxxx ide_pci_generic ide_core uhci_hcd ehci_hcd ohci_hcd usbcore 8139too 8=
139cp mii thermal processor fan thermal_sys

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kern.log.0"

Feb 10 22:50:58 italy kernel: klogd 1.5.0#5, log source = /proc/kmsg started.
Feb 10 22:50:58 italy kernel: [    0.000000] Initializing cgroup subsys cpuset
Feb 10 22:50:58 italy kernel: [    0.000000] Initializing cgroup subsys cpu
Feb 10 22:50:58 italy kernel: [    0.000000] Linux version 2.6.26-1-686 (Debian 2.6.26-13) (waldi@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-24)) #1 SMP Sat Jan 10 18:29:31 UTC 2009
Feb 10 22:50:58 italy kernel: [    0.000000] BIOS-provided physical RAM map:
Feb 10 22:50:58 italy kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Feb 10 22:50:58 italy kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Feb 10 22:50:58 italy kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Feb 10 22:50:58 italy kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000002fff0000 (usable)
Feb 10 22:50:58 italy kernel: [    0.000000]  BIOS-e820: 000000002fff0000 - 000000002fff3000 (ACPI NVS)
Feb 10 22:50:58 italy kernel: [    0.000000]  BIOS-e820: 000000002fff3000 - 0000000030000000 (ACPI data)
Feb 10 22:50:58 italy kernel: [    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Feb 10 22:50:58 italy kernel: [    0.000000] 0MB HIGHMEM available.
Feb 10 22:50:58 italy kernel: [    0.000000] 767MB LOWMEM available.
Feb 10 22:50:58 italy kernel: [    0.000000] Entering add_active_range(0, 0, 196592) 0 entries of 256 used
Feb 10 22:50:59 italy kernel: [    0.000000] Zone PFN ranges:
Feb 10 22:50:59 italy kernel: [    0.000000]   DMA             0 ->     4096
Feb 10 22:50:59 italy kernel: [    0.000000]   Normal       4096 ->   196592
Feb 10 22:50:59 italy kernel: [    0.000000]   HighMem    196592 ->   196592
Feb 10 22:50:59 italy kernel: [    0.000000] Movable zone start PFN for each node
Feb 10 22:50:59 italy kernel: [    0.000000] early_node_map[1] active PFN ranges
Feb 10 22:50:59 italy kernel: [    0.000000]     0:        0 ->   196592
Feb 10 22:50:59 italy kernel: [    0.000000] On node 0 totalpages: 196592
Feb 10 22:50:59 italy kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Feb 10 22:50:59 italy kernel: [    0.000000]   DMA zone: 0 pages reserved
Feb 10 22:50:59 italy kernel: [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
Feb 10 22:50:59 italy kernel: [    0.000000]   Normal zone: 1504 pages used for memmap
Feb 10 22:50:59 italy kernel: [    0.000000]   Normal zone: 190992 pages, LIFO batch:31
Feb 10 22:50:59 italy kernel: [    0.000000]   HighMem zone: 0 pages used for memmap
Feb 10 22:50:59 italy kernel: [    0.000000]   Movable zone: 0 pages used for memmap
Feb 10 22:50:59 italy kernel: [    0.000000] DMI 2.2 present.
Feb 10 22:50:59 italy kernel: [    0.000000] ACPI: RSDP 000F62E0, 0014 (r0 VIA694)
Feb 10 22:50:59 italy kernel: [    0.000000] ACPI: RSDT 2FFF3000, 0028 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
Feb 10 22:50:59 italy kernel: [    0.000000] ACPI: FACP 2FFF3040, 0074 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
Feb 10 22:50:59 italy kernel: [    0.000000] ACPI: DSDT 2FFF30C0, 3316 (r1 VIA694 AWRDACPI     1000 MSFT  100000E)
Feb 10 22:50:59 italy kernel: [    0.000000] ACPI: FACS 2FFF0000, 0040
Feb 10 22:50:59 italy kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Feb 10 22:50:59 italy kernel: [    0.000000] Allocating PCI resources starting at 40000000 (gap: 30000000:cfff0000)
Feb 10 22:50:59 italy kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Feb 10 22:50:59 italy kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
Feb 10 22:50:59 italy kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Feb 10 22:50:59 italy kernel: [    0.000000] SMP: Allowing 0 CPUs, 0 hotplug CPUs
Feb 10 22:50:59 italy kernel: [    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
Feb 10 22:50:59 italy kernel: [    0.000000] NR_CPUS: 8, nr_cpu_ids: 1
Feb 10 22:50:59 italy kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195056
Feb 10 22:50:59 italy kernel: [    0.000000] Kernel command line: root=/dev/mapper/italy-root ro 
Feb 10 22:50:59 italy kernel: [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
Feb 10 22:50:59 italy kernel: [    0.000000] mapped APIC to ffffb000 (0160f000)
Feb 10 22:50:59 italy kernel: [    0.000000] Enabling fast FPU save and restore... done.
Feb 10 22:50:59 italy kernel: [    0.000000] Initializing CPU#0
Feb 10 22:50:59 italy kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
Feb 10 22:50:59 italy kernel: [    0.000000] Detected 930.687 MHz processor.
Feb 10 22:50:59 italy kernel: [    0.004000] Console: colour VGA+ 80x25
Feb 10 22:50:59 italy kernel: [    0.004000] console [tty0] enabled
Feb 10 22:50:59 italy kernel: [    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Feb 10 22:50:59 italy kernel: [    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Feb 10 22:50:59 italy kernel: [    0.004000] Memory: 768324k/786368k available (1769k kernel code, 17452k reserved, 752k data, 244k init, 0k highmem)
Feb 10 22:50:59 italy kernel: [    0.004000] virtual kernel memory layout:
Feb 10 22:50:59 italy kernel: [    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
Feb 10 22:50:59 italy kernel: [    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Feb 10 22:50:59 italy kernel: [    0.004000]     vmalloc : 0xf0800000 - 0xff7fe000   ( 239 MB)
Feb 10 22:50:59 italy kernel: [    0.004000]     lowmem  : 0xc0000000 - 0xefff0000   ( 767 MB)
Feb 10 22:50:59 italy kernel: [    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
Feb 10 22:50:59 italy kernel: [    0.004000]       .data : 0xc02ba4ab - 0xc0376620   ( 752 kB)
Feb 10 22:50:59 italy kernel: [    0.004000]       .text : 0xc0100000 - 0xc02ba4ab   (1769 kB)
Feb 10 22:50:59 italy kernel: [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Feb 10 22:50:59 italy kernel: [    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
Feb 10 22:50:59 italy kernel: [    0.084276] Calibrating delay using timer specific routine.. 1863.87 BogoMIPS (lpj=3727757)
Feb 10 22:50:59 italy kernel: [    0.084444] Security Framework initialized
Feb 10 22:50:59 italy kernel: [    0.084501] SELinux:  Disabled at boot.
Feb 10 22:50:59 italy kernel: [    0.084551] Capability LSM initialized
Feb 10 22:50:59 italy kernel: [    0.084628] Mount-cache hash table entries: 512
Feb 10 22:50:59 italy kernel: [    0.084979] Initializing cgroup subsys ns
Feb 10 22:50:59 italy kernel: [    0.085032] Initializing cgroup subsys cpuacct
Feb 10 22:50:59 italy kernel: [    0.085081] Initializing cgroup subsys devices
Feb 10 22:50:59 italy kernel: [    0.085163] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Feb 10 22:50:59 italy kernel: [    0.085219] CPU: L2 Cache: 256K (64 bytes/line)
Feb 10 22:50:59 italy kernel: [    0.085269] Intel machine check architecture supported.
Feb 10 22:50:59 italy kernel: [    0.085320] Intel machine check reporting enabled on CPU#0.
Feb 10 22:50:59 italy kernel: [    0.085393] Checking 'hlt' instruction... OK.
Feb 10 22:50:59 italy kernel: [    0.100368] SMP alternatives: switching to UP code
Feb 10 22:50:59 italy kernel: [    0.114488] Freeing SMP alternatives: 16k freed
Feb 10 22:50:59 italy kernel: [    0.114546] ACPI: Core revision 20080321
Feb 10 22:50:59 italy kernel: [    0.123945] ACPI: setting ELCR to 0200 (from 0e00)
Feb 10 22:50:59 italy kernel: [    0.128008] weird, boot CPU (#0) not listedby the BIOS.
Feb 10 22:50:59 italy kernel: [    0.128008] SMP motherboard not detected.
Feb 10 22:50:59 italy kernel: [    0.128008] Local APIC not detected. Using dummy APIC emulation.
Feb 10 22:50:59 italy kernel: [    0.128008] SMP disabled
Feb 10 22:50:59 italy kernel: [    0.128008] Brought up 1 CPUs
Feb 10 22:50:59 italy kernel: [    0.128008] Total of 1 processors activated (1863.87 BogoMIPS).
Feb 10 22:50:59 italy kernel: [    0.128008] CPU0 attaching sched-domain:
Feb 10 22:50:59 italy kernel: [    0.128008]  domain 0: span 0
Feb 10 22:50:59 italy kernel: [    0.128008]   groups: 0
Feb 10 22:50:59 italy kernel: [    0.128274] net_namespace: 660 bytes
Feb 10 22:50:59 italy kernel: [    0.128335] Booting paravirtualized kernel on bare hardware
Feb 10 22:50:59 italy kernel: [    0.128886] NET: Registered protocol family 16
Feb 10 22:50:59 italy kernel: [    0.129456] ACPI: bus type pci registered
Feb 10 22:50:59 italy kernel: [    0.132008] PCI: PCI BIOS revision 2.10 entry at 0xfb3e0, last bus=1
Feb 10 22:50:59 italy kernel: [    0.132081] PCI: Using configuration type 1 for base access
Feb 10 22:50:59 italy kernel: [    0.132152] Setting up standard PCI resources
Feb 10 22:50:59 italy kernel: [    0.138306] ACPI: EC: Look up EC in DSDT
Feb 10 22:50:59 italy kernel: [    0.146645] ACPI: Interpreter enabled
Feb 10 22:50:59 italy kernel: [    0.146703] ACPI: (supports S0 S1 S4 S5)
Feb 10 22:50:59 italy kernel: [    0.146890] ACPI: Using PIC for interrupt routing
Feb 10 22:50:59 italy kernel: [    0.155718] ACPI: PCI Root Bridge [PCI0] (0000:00)
Feb 10 22:50:59 italy kernel: [    0.156864] pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
Feb 10 22:50:59 italy kernel: [    0.156922] pci 0000:00:11.0: quirk: region 5000-500f claimed by vt8235 SMB
Feb 10 22:50:59 italy kernel: [    0.157241] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb 10 22:50:59 italy kernel: [    0.201419] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Feb 10 22:50:59 italy kernel: [    0.202182] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Feb 10 22:50:59 italy kernel: [    0.202941] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Feb 10 22:50:59 italy kernel: [    0.203698] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Feb 10 22:50:59 italy kernel: [    0.204454] Linux Plug and Play Support v0.97 (c) Adam Belay
Feb 10 22:50:59 italy kernel: [    0.204581] pnp: PnP ACPI init
Feb 10 22:50:59 italy kernel: [    0.204643] ACPI: bus type pnp registered
Feb 10 22:50:59 italy kernel: [    0.211408] pnp: PnP ACPI: found 13 devices
Feb 10 22:50:59 italy kernel: [    0.211465] ACPI: ACPI bus type pnp unregistered
Feb 10 22:50:59 italy kernel: [    0.211518] PnPBIOS: Disabled by ACPI PNP
Feb 10 22:50:59 italy kernel: [    0.212261] PCI: Using ACPI for IRQ routing
Feb 10 22:50:59 italy kernel: [    0.212771] ACPI: RTC can wake from S4
Feb 10 22:50:59 italy kernel: [    0.212882] system 00:00: iomem range 0xcd000-0xcffff has been reserved
Feb 10 22:50:59 italy kernel: [    0.212938] system 00:00: iomem range 0xf0000-0xf7fff could not be reserved
Feb 10 22:50:59 italy kernel: [    0.212993] system 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Feb 10 22:50:59 italy kernel: [    0.213047] system 00:00: iomem range 0xfc000-0xfffff could not be reserved
Feb 10 22:50:59 italy kernel: [    0.213102] system 00:00: iomem range 0x2fff0000-0x2fffffff could not be reserved
Feb 10 22:50:59 italy kernel: [    0.213164] system 00:00: iomem range 0xffff0000-0xffffffff could not be reserved
Feb 10 22:50:59 italy kernel: [    0.213225] system 00:00: iomem range 0x0-0x9ffff could not be reserved
Feb 10 22:50:59 italy kernel: [    0.213279] system 00:00: iomem range 0x100000-0x2ffeffff could not be reserved
Feb 10 22:50:59 italy kernel: [    0.213340] system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
Feb 10 22:50:59 italy kernel: [    0.213395] system 00:00: iomem range 0xfff80000-0xfffeffff has been reserved
Feb 10 22:50:59 italy kernel: [    0.213461] system 00:02: ioport range 0x4000-0x407f has been reserved
Feb 10 22:50:59 italy kernel: [    0.213515] system 00:02: ioport range 0x5000-0x500f has been reserved
Feb 10 22:50:59 italy kernel: [    0.213590] system 00:03: ioport range 0x4d0-0x4d1 has been reserved
Feb 10 22:50:59 italy kernel: [    0.213643] system 00:03: ioport range 0x800-0x805 has been reserved
Feb 10 22:50:59 italy kernel: [    0.213696] system 00:03: ioport range 0x290-0x297 has been reserved
Feb 10 22:50:59 italy kernel: [    0.244722] PCI: Bridge: 0000:00:01.0
Feb 10 22:50:59 italy kernel: [    0.244771]   IO window: c000-cfff
Feb 10 22:50:59 italy kernel: [    0.244820]   MEM window: 0xe8000000-0xe9ffffff
Feb 10 22:50:59 italy kernel: [    0.244870]   PREFETCH window: 0x00000000d8000000-0x00000000e7ffffff
Feb 10 22:50:59 italy kernel: [    0.244944] PCI: Setting latency timer of device 0000:00:01.0 to 64
Feb 10 22:50:59 italy kernel: [    0.244991] NET: Registered protocol family 2
Feb 10 22:50:59 italy kernel: [    0.245242] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Feb 10 22:50:59 italy kernel: [    0.246088] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Feb 10 22:50:59 italy kernel: [    0.251038] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Feb 10 22:50:59 italy kernel: [    0.253620] TCP: Hash tables configured (established 131072 bind 65536)
Feb 10 22:50:59 italy kernel: [    0.253679] TCP reno registered
Feb 10 22:50:59 italy kernel: [    0.254018] NET: Registered protocol family 1
Feb 10 22:50:59 italy kernel: [    0.254353] checking if image is initramfs...<7>Switched to high resolution mode on CPU 0
Feb 10 22:50:59 italy kernel: [    0.830175]  it is
Feb 10 22:50:59 italy kernel: [    1.517166] Freeing initrd memory: 7199k freed
Feb 10 22:50:59 italy kernel: [    1.518813] audit: initializing netlink socket (disabled)
Feb 10 22:50:59 italy kernel: [    1.518898] type=2000 audit(1234306193.516:1): initialized
Feb 10 22:50:59 italy kernel: [    1.519228] Total HugeTLB memory allocated, 0
Feb 10 22:50:59 italy kernel: [    1.519445] VFS: Disk quotas dquot_6.5.1
Feb 10 22:50:59 italy kernel: [    1.519557] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Feb 10 22:50:59 italy kernel: [    1.519687] msgmni has been set to 1515
Feb 10 22:50:59 italy kernel: [    1.519970] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Feb 10 22:50:59 italy kernel: [    1.520074] io scheduler noop registered
Feb 10 22:50:59 italy kernel: [    1.520122] io scheduler anticipatory registered
Feb 10 22:50:59 italy kernel: [    1.520169] io scheduler deadline registered
Feb 10 22:50:59 italy kernel: [    1.520229] io scheduler cfq registered (default)
Feb 10 22:50:59 italy kernel: [    1.520298] PCI: VIA PCI bridge detected.Disabling DAC.
Feb 10 22:50:59 italy kernel: [    1.520522] pci 0000:01:00.0: Boot video device
Feb 10 22:50:59 italy kernel: [    1.521344] isapnp: Scanning for PnP cards...
Feb 10 22:50:59 italy kernel: [    1.875419] isapnp: No Plug & Play device found
Feb 10 22:50:59 italy kernel: [    1.882523] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Feb 10 22:50:59 italy kernel: [    1.882792] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 10 22:50:59 italy kernel: [    1.883004] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 10 22:50:59 italy kernel: [    1.883743] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 10 22:50:59 italy kernel: [    1.884102] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 10 22:50:59 italy kernel: [    1.887787] brd: module loaded
Feb 10 22:50:59 italy kernel: [    1.888125] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Feb 10 22:50:59 italy kernel: [    1.888647] serio: i8042 KBD port at 0x60,0x64 irq 1
Feb 10 22:50:59 italy kernel: [    1.888706] serio: i8042 AUX port at 0x60,0x64 irq 12
Feb 10 22:50:59 italy kernel: [    1.889118] mice: PS/2 mouse device common for all mice
Feb 10 22:50:59 italy kernel: [    1.889487] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
Feb 10 22:50:59 italy kernel: [    1.889563] rtc0: alarms up to one year, y3k
Feb 10 22:50:59 italy kernel: [    1.889690] cpuidle: using governor ladder
Feb 10 22:50:59 italy kernel: [    1.889739] cpuidle: using governor menu
Feb 10 22:50:59 italy kernel: [    1.889793] No iBFT detected.
Feb 10 22:50:59 italy kernel: [    1.890886] TCP cubic registered
Feb 10 22:50:59 italy kernel: [    1.890936] NET: Registered protocol family 17
Feb 10 22:50:59 italy kernel: [    1.890994] Using IPI No-Shortcut mode
Feb 10 22:50:59 italy kernel: [    1.891332] registered taskstats version 1
Feb 10 22:50:59 italy kernel: [    1.891741] rtc_cmos 00:05: setting system clock to 2009-02-10 22:49:54 UTC (1234306194)
Feb 10 22:50:59 italy kernel: [    1.892450] Freeing unused kernel memory: 244k freed
Feb 10 22:50:59 italy kernel: [    1.911548] input: AT Translated Set 2 keyboard as /class/input/input0
Feb 10 22:50:59 italy kernel: [    2.143596] ACPI: PNP0C0B:00 is registered as cooling_device0
Feb 10 22:50:59 italy kernel: [    2.143674] ACPI: Fan [FAN] (on)
Feb 10 22:50:59 italy kernel: [    2.157591] ACPI: CPU0 (power states: C1[C1] C2[C2])
Feb 10 22:50:59 italy kernel: [    2.157849] ACPI: ACPI0007:00 is registered as cooling_device1
Feb 10 22:50:59 italy kernel: [    2.162006] ACPI: LNXTHERM:01 is registered as thermal_zone0
Feb 10 22:50:59 italy kernel: [    2.162336] ACPI: Thermal Zone [THRM] (40 C)
Feb 10 22:50:59 italy kernel: [    3.075010] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
Feb 10 22:50:59 italy kernel: [    3.075112] 8139cp 0000:00:0b.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
Feb 10 22:50:59 italy kernel: [    3.075175] 8139cp 0000:00:0b.0: Try the "8139too" driver instead.
Feb 10 22:50:59 italy kernel: [    3.101972] 8139too Fast Ethernet driver 0.9.28
Feb 10 22:50:59 italy kernel: [    3.102944] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
Feb 10 22:50:59 italy kernel: [    3.102999] PCI: setting IRQ 11 as level-triggered
Feb 10 22:50:59 italy kernel: [    3.103007] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 10 22:50:59 italy kernel: [    3.104058] eth0: RealTek RTL8139 at 0xd400, 00:02:44:14:3f:2c, IRQ 11
Feb 10 22:50:59 italy kernel: [    3.104112] eth0:  Identified 8139 chip type 'RTL-8139B'
Feb 10 22:50:59 italy kernel: [    3.440227] usbcore: registered new interface driver usbfs
Feb 10 22:50:59 italy kernel: [    3.440358] usbcore: registered new interface driver hub
Feb 10 22:50:59 italy kernel: [    3.440492] usbcore: registered new device driver usb
Feb 10 22:50:59 italy kernel: [    3.459731] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Feb 10 22:50:59 italy kernel: [    3.460648] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
Feb 10 22:50:59 italy kernel: [    3.460710] PCI: setting IRQ 10 as level-triggered
Feb 10 22:50:59 italy kernel: [    3.460718] ACPI: PCI Interrupt 0000:00:0c.0[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 10 22:50:59 italy kernel: [    3.460862] ohci_hcd 0000:00:0c.0: OHCI Host Controller
Feb 10 22:50:59 italy kernel: [    3.461167] ohci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 1
Feb 10 22:50:59 italy kernel: [    3.461256] ohci_hcd 0000:00:0c.0: irq 10, io mem 0xea003000
Feb 10 22:50:59 italy kernel: [    3.518332] usb usb1: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    3.518461] hub 1-0:1.0: USB hub found
Feb 10 22:50:59 italy kernel: [    3.518529] hub 1-0:1.0: 2 ports detected
Feb 10 22:50:59 italy kernel: [    3.620420] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Feb 10 22:50:59 italy kernel: [    3.620487] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 22:50:59 italy kernel: [    3.620547] usb usb1: Product: OHCI Host Controller
Feb 10 22:50:59 italy kernel: [    3.620595] usb usb1: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 10 22:50:59 italy kernel: [    3.620645] usb usb1: SerialNumber: 0000:00:0c.0
Feb 10 22:50:59 italy kernel: [    3.621579] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
Feb 10 22:50:59 italy kernel: [    3.621633] ACPI: PCI Interrupt 0000:00:0c.1[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 10 22:50:59 italy kernel: [    3.621779] ohci_hcd 0000:00:0c.1: OHCI Host Controller
Feb 10 22:50:59 italy kernel: [    3.621890] ohci_hcd 0000:00:0c.1: new USB bus registered, assigned bus number 2
Feb 10 22:50:59 italy kernel: [    3.621980] ohci_hcd 0000:00:0c.1: irq 11, io mem 0xea004000
Feb 10 22:50:59 italy kernel: [    3.678346] usb usb2: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    3.678473] hub 2-0:1.0: USB hub found
Feb 10 22:50:59 italy kernel: [    3.678544] hub 2-0:1.0: 2 ports detected
Feb 10 22:50:59 italy kernel: [    3.745261] modprobe[631]: segfault at 19 ip b7e5b0b3 sp bf84b9e4 error 4 in libc.so.6[b7df0000+138000]
Feb 10 22:50:59 italy kernel: [    3.780363] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Feb 10 22:50:59 italy kernel: [    3.780429] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 22:50:59 italy kernel: [    3.780489] usb usb2: Product: OHCI Host Controller
Feb 10 22:50:59 italy kernel: [    3.780538] usb usb2: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 10 22:50:59 italy kernel: [    3.780589] usb usb2: SerialNumber: 0000:00:0c.1
Feb 10 22:50:59 italy kernel: [    3.780695] ACPI: PCI Interrupt 0000:00:0c.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 10 22:50:59 italy kernel: [    3.780845] ohci_hcd 0000:00:0c.2: OHCI Host Controller
Feb 10 22:50:59 italy kernel: [    3.780947] ohci_hcd 0000:00:0c.2: new USB bus registered, assigned bus number 3
Feb 10 22:50:59 italy kernel: [    3.781034] ohci_hcd 0000:00:0c.2: irq 11, io mem 0xea005000
Feb 10 22:50:59 italy kernel: [    3.838278] usb usb3: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    3.838407] hub 3-0:1.0: USB hub found
Feb 10 22:50:59 italy kernel: [    3.838476] hub 3-0:1.0: 2 ports detected
Feb 10 22:50:59 italy kernel: [    3.912341] USB Universal Host Controller Interface driver v3.0
Feb 10 22:50:59 italy kernel: [    3.924105] usb 1-1: new full speed USB device using ohci_hcd and address 2
Feb 10 22:50:59 italy kernel: [    3.940352] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Feb 10 22:50:59 italy kernel: [    3.940418] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 22:50:59 italy kernel: [    3.940478] usb usb3: Product: OHCI Host Controller
Feb 10 22:50:59 italy kernel: [    3.940526] usb usb3: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 10 22:50:59 italy kernel: [    3.940576] usb usb3: SerialNumber: 0000:00:0c.2
Feb 10 22:50:59 italy kernel: [    3.943578] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
Feb 10 22:50:59 italy kernel: [    3.943645] ACPI: PCI Interrupt 0000:00:0c.3[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 10 22:50:59 italy kernel: [    3.943795] ehci_hcd 0000:00:0c.3: EHCI Host Controller
Feb 10 22:50:59 italy kernel: [    3.943947] ehci_hcd 0000:00:0c.3: new USB bus registered, assigned bus number 4
Feb 10 22:50:59 italy kernel: [    3.968145] ehci_hcd 0000:00:0c.3: debug port 1
Feb 10 22:50:59 italy kernel: [    3.968231] ehci_hcd 0000:00:0c.3: irq 10, io mem 0xea006000
Feb 10 22:50:59 italy kernel: [    4.040569] Uniform Multi-Platform E-IDE driver
Feb 10 22:50:59 italy kernel: [    4.040634] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb 10 22:50:59 italy kernel: [    4.116117] ehci_hcd 0000:00:0c.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 10 22:50:59 italy kernel: [    4.116382] usb usb4: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    4.116505] hub 4-0:1.0: USB hub found
Feb 10 22:50:59 italy kernel: [    4.116572] hub 4-0:1.0: 6 ports detected
Feb 10 22:50:59 italy kernel: [    4.220362] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
Feb 10 22:50:59 italy kernel: [    4.220429] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 22:50:59 italy kernel: [    4.220489] usb usb4: Product: EHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.220537] usb usb4: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
Feb 10 22:50:59 italy kernel: [    4.220587] usb usb4: SerialNumber: 0000:00:0c.3
Feb 10 22:50:59 italy kernel: [    4.220734] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 10 22:50:59 italy kernel: [    4.220874] uhci_hcd 0000:00:10.0: UHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.220981] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 5
Feb 10 22:50:59 italy kernel: [    4.221078] uhci_hcd 0000:00:10.0: irq 10, io base 0x0000d800
Feb 10 22:50:59 italy kernel: [    4.221316] usb usb5: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    4.221429] hub 5-0:1.0: USB hub found
Feb 10 22:50:59 italy kernel: [    4.221495] hub 5-0:1.0: 2 ports detected
Feb 10 22:50:59 italy kernel: [    4.324369] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Feb 10 22:50:59 italy kernel: [    4.324435] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 22:50:59 italy kernel: [    4.324495] usb usb5: Product: UHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.324544] usb usb5: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 10 22:50:59 italy kernel: [    4.324594] usb usb5: SerialNumber: 0000:00:10.0
Feb 10 22:50:59 italy kernel: [    4.324754] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 10 22:50:59 italy kernel: [    4.324894] uhci_hcd 0000:00:10.1: UHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.324998] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 6
Feb 10 22:50:59 italy kernel: [    4.325093] uhci_hcd 0000:00:10.1: irq 10, io base 0x0000dc00
Feb 10 22:50:59 italy kernel: [    4.325349] usb usb6: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    4.325463] hub 6-0:1.0: USB hub found
Feb 10 22:50:59 italy kernel: [    4.325526] hub 6-0:1.0: 2 ports detected
Feb 10 22:50:59 italy kernel: [    4.428371] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Feb 10 22:50:59 italy kernel: [    4.428438] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 22:50:59 italy kernel: [    4.428498] usb usb6: Product: UHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.428546] usb usb6: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 10 22:50:59 italy kernel: [    4.428596] usb usb6: SerialNumber: 0000:00:10.1
Feb 10 22:50:59 italy kernel: [    4.428758] ACPI: PCI Interrupt 0000:00:10.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 10 22:50:59 italy kernel: [    4.428898] uhci_hcd 0000:00:10.2: UHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.429005] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 7
Feb 10 22:50:59 italy kernel: [    4.429101] uhci_hcd 0000:00:10.2: irq 11, io base 0x0000e000
Feb 10 22:50:59 italy kernel: [    4.429350] usb usb7: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    4.429466] hub 7-0:1.0: USB hub found
Feb 10 22:50:59 italy kernel: [    4.429530] hub 7-0:1.0: 2 ports detected
Feb 10 22:50:59 italy kernel: [    4.512089] usb 1-1: device not accepting address 2, error -62
Feb 10 22:50:59 italy kernel: [    4.532361] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Feb 10 22:50:59 italy kernel: [    4.532428] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 22:50:59 italy kernel: [    4.532488] usb usb7: Product: UHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.532536] usb usb7: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 10 22:50:59 italy kernel: [    4.532586] usb usb7: SerialNumber: 0000:00:10.2
Feb 10 22:50:59 italy kernel: [    4.532732] ACPI: PCI Interrupt 0000:00:10.3[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 10 22:50:59 italy kernel: [    4.532884] ehci_hcd 0000:00:10.3: EHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.532989] ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 8
Feb 10 22:50:59 italy kernel: [    4.533130] ehci_hcd 0000:00:10.3: irq 11, io mem 0xea007000
Feb 10 22:50:59 italy kernel: [    4.568100] hub 1-0:1.0: unable to enumerate USB device on port 1
Feb 10 22:50:59 italy kernel: [    4.572022] Marking TSC unstable due to: TSC halts in idle.
Feb 10 22:50:59 italy kernel: [    4.583815] ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 10 22:50:59 italy kernel: [    4.584068] usb usb8: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    4.584074] hub 8-0:1.0: USB hub found
Feb 10 22:50:59 italy kernel: [    4.584074] hub 8-0:1.0: 6 ports detected
Feb 10 22:50:59 italy kernel: [    4.684582] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
Feb 10 22:50:59 italy kernel: [    4.684648] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 22:50:59 italy kernel: [    4.684708] usb usb8: Product: EHCI Host Controller
Feb 10 22:50:59 italy kernel: [    4.684757] usb usb8: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
Feb 10 22:50:59 italy kernel: [    4.684806] usb usb8: SerialNumber: 0000:00:10.3
Feb 10 22:50:59 italy kernel: [    4.690618] VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:11.1
Feb 10 22:50:59 italy kernel: [    4.690734] ACPI: PCI Interrupt 0000:00:11.1[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 10 22:50:59 italy kernel: [    4.690861] VIA_IDE 0000:00:11.1: VIA VLink IRQ fixup, from 255 to 10
Feb 10 22:50:59 italy kernel: [    4.690942] VP_IDE: not 100% native mode: will probe irqs later
Feb 10 22:50:59 italy kernel: [    4.691028] VP_IDE: VIA vt8235 (rev 00) IDE UDMA133 controller on pci0000:00:11.1
Feb 10 22:50:59 italy kernel: [    4.691102]     ide0: BM-DMA at 0xe400-0xe407
Feb 10 22:50:59 italy kernel: [    4.691160]     ide1: BM-DMA at 0xe408-0xe40f
Feb 10 22:50:59 italy kernel: [    4.691211] Probing IDE interface ide0...
Feb 10 22:50:59 italy kernel: [    5.064095] usb 4-1: new high speed USB device using ehci_hcd and address 2
Feb 10 22:50:59 italy kernel: [    5.104156] hda: Maxtor 6B200P0, ATA DISK drive
Feb 10 22:50:59 italy kernel: [    5.120244] hub 4-0:1.0: unable to enumerate USB device on port 1
Feb 10 22:50:59 italy kernel: [    5.372048] usb 4-5: new high speed USB device using ehci_hcd and address 3
Feb 10 22:50:59 italy kernel: [    5.506700] usb 4-5: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    5.508089] usb 4-5: New USB device found, idVendor=059f, idProduct=0951
Feb 10 22:50:59 italy kernel: [    5.508168] usb 4-5: New USB device strings: Mfr=10, Product=11, SerialNumber=5
Feb 10 22:50:59 italy kernel: [    5.508229] usb 4-5: Product: LaCie Hard Drive USB
Feb 10 22:50:59 italy kernel: [    5.508277] usb 4-5: Manufacturer: LaCie SA
Feb 10 22:50:59 italy kernel: [    5.508958] usb 4-5: SerialNumber: 031D703971FF
Feb 10 22:50:59 italy kernel: [    5.583164] SCSI subsystem initialized
Feb 10 22:50:59 italy kernel: [    5.592250] Initializing USB Mass Storage driver...
Feb 10 22:50:59 italy kernel: [    5.776136] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Feb 10 22:50:59 italy kernel: [    5.777637] hda: UDMA/133 mode selected
Feb 10 22:50:59 italy kernel: [    5.779191] Probing IDE interface ide1...
Feb 10 22:50:59 italy kernel: [    6.284296] scsi0 : SCSI emulation for USB Mass Storage devices
Feb 10 22:50:59 italy kernel: [    6.284952] usb-storage: device found at 3
Feb 10 22:50:59 italy kernel: [    6.284959] usb-storage: waiting for device to settle before scanning
Feb 10 22:50:59 italy kernel: [    6.412108] usbcore: registered new interface driver usb-storage
Feb 10 22:50:59 italy kernel: [    6.412167] USB Mass Storage support registered.
Feb 10 22:50:59 italy kernel: [    6.716047] usb 1-1: new full speed USB device using ohci_hcd and address 4
Feb 10 22:50:59 italy kernel: [    6.924146] hdd: SONY DVD RW DW-D22A, ATAPI CD/DVD-ROM drive
Feb 10 22:50:59 italy kernel: [    6.941305] usb 1-1: not running at top speed; connect to a high speed hub
Feb 10 22:50:59 italy kernel: [    6.980146] hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Feb 10 22:50:59 italy kernel: [    6.980432] hdd: UDMA/66 mode selected
Feb 10 22:50:59 italy kernel: [    6.980774] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb 10 22:50:59 italy kernel: [    7.003270] ide1 at 0x170-0x177,0x376 on irq 15
Feb 10 22:50:59 italy kernel: [    7.009072] No dock devices found.
Feb 10 22:50:59 italy kernel: [    7.032144] libata version 3.00 loaded.
Feb 10 22:50:59 italy kernel: [    7.058652] usb 1-1: configuration #1 chosen from 1 choice
Feb 10 22:50:59 italy kernel: [    7.062755] scsi1 : SCSI emulation for USB Mass Storage devices
Feb 10 22:50:59 italy kernel: [    7.063186] usb 1-1: New USB device found, idVendor=07ab, idProduct=fcfe
Feb 10 22:50:59 italy kernel: [    7.063242] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb 10 22:50:59 italy kernel: [    7.063296] usb 1-1: Product: Freecom Hard Drive
Feb 10 22:50:59 italy kernel: [    7.063344] usb 1-1: Manufacturer: Freecom
Feb 10 22:50:59 italy kernel: [    7.063389] usb 1-1: SerialNumber: 01860D8900920
Feb 10 22:50:59 italy kernel: [    7.063485] usb-storage: device found at 4
Feb 10 22:50:59 italy kernel: [    7.063490] usb-storage: waiting for device to settle before scanning
Feb 10 22:50:59 italy kernel: [    7.120644] hda: max request size: 512KiB
Feb 10 22:50:59 italy kernel: [    7.126099] hda: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63
Feb 10 22:50:59 italy kernel: [    7.130662] hda: cache flushes supported
Feb 10 22:50:59 italy kernel: [    7.130819]  hda: hda1 hda2 < hda5 >
Feb 10 22:50:59 italy kernel: [    7.151410] hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Feb 10 22:50:59 italy kernel: [    7.151654] Uniform CD-ROM driver Revision: 3.20
Feb 10 22:50:59 italy kernel: [    7.460100] device-mapper: uevent: version 1.0.3
Feb 10 22:50:59 italy kernel: [    7.462909] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Feb 10 22:50:59 italy kernel: [   11.284977] usb-storage: device scan complete
Feb 10 22:50:59 italy kernel: [   11.354670] scsi 0:0:0:0: Direct-Access     SAMSUNG  HD500LJ               PQ: 0 ANSI: 2 CCS
Feb 10 22:50:59 italy kernel: [   11.394518] Driver 'sd' needs updating - please use bus_type methods
Feb 10 22:50:59 italy kernel: [   11.396179] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Feb 10 22:50:59 italy kernel: [   11.397454] sd 0:0:0:0: [sda] Write Protect is off
Feb 10 22:50:59 italy kernel: [   11.397467] sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
Feb 10 22:50:59 italy kernel: [   11.397474] sd 0:0:0:0: [sda] Assuming drive cache: write through
Feb 10 22:50:59 italy kernel: [   11.399707] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Feb 10 22:50:59 italy kernel: [   11.401075] sd 0:0:0:0: [sda] Write Protect is off
Feb 10 22:50:59 italy kernel: [   11.401088] sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
Feb 10 22:50:59 italy kernel: [   11.401094] sd 0:0:0:0: [sda] Assuming drive cache: write through
Feb 10 22:50:59 italy kernel: [   11.401104]  sda: sda1
Feb 10 22:50:59 italy kernel: [   11.420796] sd 0:0:0:0: [sda] Attached SCSI disk
Feb 10 22:50:59 italy kernel: [   11.616055] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 10 22:50:59 italy kernel: [   11.952054] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 10 22:50:59 italy kernel: [   12.063881] usb-storage: device scan complete
Feb 10 22:50:59 italy kernel: [   12.099676] scsi 1:0:0:0: Direct-Access     SAMSUNG  HD400LD          WQ10 PQ: 0 ANSI: 0
Feb 10 22:50:59 italy kernel: [   12.110883] sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Feb 10 22:50:59 italy kernel: [   12.124872] sd 1:0:0:0: [sdb] Write Protect is off
Feb 10 22:50:59 italy kernel: [   12.124884] sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 10 22:50:59 italy kernel: [   12.124890] sd 1:0:0:0: [sdb] Assuming drive cache: write through
Feb 10 22:50:59 italy kernel: [   12.135834] sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Feb 10 22:50:59 italy kernel: [   12.149707] sd 1:0:0:0: [sdb] Write Protect is off
Feb 10 22:50:59 italy kernel: [   12.149707] sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 10 22:50:59 italy kernel: [   12.149707] sd 1:0:0:0: [sdb] Assuming drive cache: write through
Feb 10 22:50:59 italy kernel: [   12.149707]  sdb:<6>PM: Starting manual resume from disk
Feb 10 22:50:59 italy kernel: [   19.451235] EXT3-fs: INFO: recovery required on readonly filesystem.
Feb 10 22:50:59 italy kernel: [   19.451304] EXT3-fs: write access will be enabled during recovery.
Feb 10 22:50:59 italy kernel: [   19.698506]  sdb1
Feb 10 22:50:59 italy kernel: [   19.698934] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb 10 22:50:59 italy kernel: [   20.650651] kjournald starting.  Commit interval 5 seconds
Feb 10 22:50:59 italy kernel: [   20.650757] EXT3-fs: dm-1: orphan cleanup on readonly fs
Feb 10 22:50:59 italy kernel: [   20.740546] ext3_orphan_cleanup: deleting unreferenced inode 325007
Feb 10 22:50:59 italy kernel: [   20.901377] ext3_orphan_cleanup: deleting unreferenced inode 827792
Feb 10 22:50:59 italy kernel: [   20.921760] ext3_orphan_cleanup: deleting unreferenced inode 421916
Feb 10 22:50:59 italy kernel: [   20.921815] ext3_orphan_cleanup: deleting unreferenced inode 327786
Feb 10 22:50:59 italy kernel: [   20.936875] ext3_orphan_cleanup: deleting unreferenced inode 326509
Feb 10 22:50:59 italy kernel: [   21.010351] ext3_orphan_cleanup: deleting unreferenced inode 326342
Feb 10 22:50:59 italy kernel: [   21.575729] ext3_orphan_cleanup: deleting unreferenced inode 325864
Feb 10 22:50:59 italy kernel: [   21.639900] ext3_orphan_cleanup: deleting unreferenced inode 667495
Feb 10 22:50:59 italy kernel: [   21.778122] ext3_orphan_cleanup: deleting unreferenced inode 600291
Feb 10 22:50:59 italy kernel: [   21.862170] ext3_orphan_cleanup: deleting unreferenced inode 811547
Feb 10 22:50:59 italy kernel: [   21.862170] ext3_orphan_cleanup: deleting unreferenced inode 325932
Feb 10 22:50:59 italy kernel: [   21.913891] ext3_orphan_cleanup: deleting unreferenced inode 324692
Feb 10 22:50:59 italy kernel: [   21.935409] ext3_orphan_cleanup: deleting unreferenced inode 162928
Feb 10 22:50:59 italy kernel: [   21.962446] ext3_orphan_cleanup: deleting unreferenced inode 65913
Feb 10 22:50:59 italy kernel: [   22.006505] ext3_orphan_cleanup: deleting unreferenced inode 827434
Feb 10 22:50:59 italy kernel: [   22.006505] ext3_orphan_cleanup: deleting unreferenced inode 827433
Feb 10 22:50:59 italy kernel: [   22.006505] ext3_orphan_cleanup: deleting unreferenced inode 827432
Feb 10 22:50:59 italy kernel: [   22.006505] ext3_orphan_cleanup: deleting unreferenced inode 827431
Feb 10 22:50:59 italy kernel: [   22.006505] ext3_orphan_cleanup: deleting unreferenced inode 827430
Feb 10 22:50:59 italy kernel: [   22.006505] EXT3-fs: dm-1: 19 orphan inodes deleted
Feb 10 22:50:59 italy kernel: [   22.006505] EXT3-fs: recovery complete.
Feb 10 22:50:59 italy kernel: [   22.045418] EXT3-fs: mounted filesystem with ordered data mode.
Feb 10 22:50:59 italy kernel: [   24.564130] udevd version 125 started
Feb 10 22:50:59 italy kernel: [   25.574620] hda: UDMA/133 mode selected
Feb 10 22:50:59 italy kernel: [   25.580248] hdd: UDMA/66 mode selected
Feb 10 22:50:59 italy kernel: [   25.760116] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 10 22:50:59 italy kernel: [   27.844335] Linux agpgart interface v0.103
Feb 10 22:50:59 italy kernel: [   27.855730] agpgart: Detected VIA KT266/KY266x/KT333 chipset
Feb 10 22:50:59 italy kernel: [   27.866605] agpgart: AGP aperture is 128M @ 0xd0000000
Feb 10 22:50:59 italy kernel: [   27.884599] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Feb 10 22:50:59 italy kernel: [   27.890061] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Feb 10 22:50:59 italy kernel: [   28.387759] Linux video capture interface: v2.00
Feb 10 22:50:59 italy kernel: [   28.585002] bttv: driver version 0.9.17 loaded
Feb 10 22:50:59 italy kernel: [   28.585064] bttv: using 8 buffers with 2080k (520 pages) each for capture
Feb 10 22:50:59 italy kernel: [   28.585205] bttv: Bt8xx card found (0).
Feb 10 22:50:59 italy kernel: [   28.585289] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 10 22:50:59 italy kernel: [   28.585424] bttv0: Bt878 (rev 17) at 0000:00:0a.0, irq: 11, latency: 32, mmio: 0xea000000
Feb 10 22:50:59 italy kernel: [   28.599833] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
Feb 10 22:50:59 italy kernel: [   28.599902] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
Feb 10 22:50:59 italy kernel: [   28.600004] bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
Feb 10 22:50:59 italy kernel: [   28.602497] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
Feb 10 22:50:59 italy kernel: [   28.630108] tveeprom 0-0050: Hauppauge model 44801, rev D182, serial# 2772248
Feb 10 22:50:59 italy kernel: [   28.630165] tveeprom 0-0050: tuner model is LG TAPC H791F (idx 82, type 39)
Feb 10 22:50:59 italy kernel: [   28.630221] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
Feb 10 22:50:59 italy kernel: [   28.630273] tveeprom 0-0050: audio processor is None (idx 0)
Feb 10 22:50:59 italy kernel: [   28.630324] tveeprom 0-0050: has no radio
Feb 10 22:50:59 italy kernel: [   28.630371] bttv0: Hauppauge eeprom indicates model#44801
Feb 10 22:50:59 italy kernel: [   28.630421] bttv0: tuner type=39
Feb 10 22:50:59 italy kernel: [   28.630469] bttv0: i2c: checking for MSP34xx @ 0x80... not found
Feb 10 22:50:59 italy kernel: [   29.212516] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
Feb 10 22:50:59 italy kernel: [   29.225996] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
Feb 10 22:50:59 italy kernel: [   29.287448] input: Power Button (FF) as /class/input/input1
Feb 10 22:50:59 italy kernel: [   29.319895] ACPI: Power Button (FF) [PWRF]
Feb 10 22:50:59 italy kernel: [   29.320144] input: Power Button (CM) as /class/input/input2
Feb 10 22:50:59 italy kernel: [   29.348576] ACPI: Power Button (CM) [PWRB]
Feb 10 22:50:59 italy kernel: [   29.348791] input: Sleep Button (CM) as /class/input/input3
Feb 10 22:50:59 italy kernel: [   29.379545] ACPI: Sleep Button (CM) [SLPB]
Feb 10 22:50:59 italy kernel: [   29.867618] tuner' 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
Feb 10 22:50:59 italy kernel: [   30.473113] tuner-simple 0-0061: creating new instance
Feb 10 22:50:59 italy kernel: [   30.473179] tuner-simple 0-0061: type set to 39 (LG NTSC (newer TAPC series))
Feb 10 22:50:59 italy kernel: [   30.482362] bttv0: registered device video0
Feb 10 22:50:59 italy kernel: [   30.482452] bttv0: registered device vbi0
Feb 10 22:50:59 italy kernel: [   30.482523] bttv0: PLL: 28636363 => 35468950 .. ok
Feb 10 22:50:59 italy kernel: [   31.314879] input: PC Speaker as /class/input/input4
Feb 10 22:50:59 italy kernel: [   31.595168] BUG: unable to handle kernel paging request at bb0380cc
Feb 10 22:50:59 italy kernel: [   31.595299] IP: [<c0163afb>] handle_mm_fault+0x7f/0x690
Feb 10 22:50:59 italy kernel: [   31.595396] *pde = 00000000 
Feb 10 22:50:59 italy kernel: [   31.595473] Oops: 0000 [#1] SMP 
Feb 10 22:50:59 italy kernel: [   31.595575] Modules linked in: i2c_viapro pcspkr tuner_simple tuner_types snd_seq_oss(+) snd_seq_midi snd_rawmidi tuner snd_seq_midi_event snd_seq tvaudio button snd_timer snd_seq_device snd bttv videodev v4l1_compat firmware_class ir_common compat_ioctl32 soundcore i2c_algo_bit snd_page_alloc v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_core shpchp pci_hotplug via_agp agpgart evdev ext3 jbd mbcache sha256_generic aes_i586 aes_generic cbc sd_mod dm_crypt crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_disk ata_generic libata dock usb_storage scsi_mod via82cxxx ide_pci_generic ide_core uhci_hcd ehci_hcd ohci_hcd usbcore 8139too 8139cp mii thermal processor fan thermal_sys
Feb 10 22:50:59 italy kernel: [   31.596017] 
Feb 10 22:50:59 italy kernel: [   31.596017] Pid: 1769, comm: vol_id Not tainted (2.6.26-1-686 #1)
Feb 10 22:50:59 italy kernel: [   31.596017] EIP: 0060:[<c0163afb>] EFLAGS: 00010287 CPU: 0
Feb 10 22:50:59 italy kernel: [   31.596017] EIP is at handle_mm_fault+0x7f/0x690
Feb 10 22:50:59 italy kernel: [   31.596017] EAX: bb0380cc EBX: edca6b00 ECX: edca6b00 EDX: cccccccc
Feb 10 22:50:59 italy kernel: [   31.596017] ESI: ee36b458 EDI: b7e35030 EBP: ee457340 ESP: ee455f6c
Feb 10 22:50:59 italy kernel: [   31.596017]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb 10 22:50:59 italy kernel: [   31.596017] Process vol_id (pid: 1769, ti=ee454000 task=ee457340 task.ti=ee454000)
Feb 10 22:50:59 italy kernel: [   31.596017] Stack: edca6b00 ee36b458 b7e35030 ee457340 c0115b4f 00000000 00000004 bb0380cc 
Feb 10 22:50:59 italy kernel: [   31.596017]        ee36b420 00000000 c0174d85 00000839 00000000 00000000 b7d97ff4 0854d130 
Feb 10 22:50:59 italy kernel: [   31.596017]        c01158b4 bf841934 c02b980a b7d97ff4 b7ec0aa0 b7ef29bc 0854d130 0854d52f 
Feb 10 22:50:59 italy kernel: [   31.596017] Call Trace:
Feb 10 22:50:59 italy kernel: [   31.596017]  [<c0115b4f>] do_page_fault+0x29b/0x5b8
Feb 10 22:50:59 italy kernel: [   31.596017]  [<c0174d85>] sys_llseek+0x60/0x82
Feb 10 22:50:59 italy kernel: [   31.596017]  [<c01158b4>] do_page_fault+0x0/0x5b8
Feb 10 22:50:59 italy kernel: [   31.596017]  [<c02b980a>] error_code+0x72/0x78
Feb 10 22:50:59 italy kernel: [   31.596017]  =======================
Feb 10 22:50:59 italy kernel: [   31.596017] Code: 8b 44 24 14 83 c4 5c 5b 5e 5f 5d e9 44 9e 00 00 8b 44 24 0c 8b 54 24 14 c1 e8 16 c1 e0 02 89 44 24 1c 8b 52 24 01 d0 89 44 24 1c <8b> 00 e8 56 12 fb ff 90 a8 01 75 19 8b 4c 24 0c 8b 54 24 1c 8b 
Feb 10 22:50:59 italy kernel: [   31.596017] EIP: [<c0163afb>] handle_mm_fault+0x7f/0x690 SS:ESP 0068:ee455f6c
Feb 10 22:50:59 italy kernel: [   31.601873] ---[ end trace b2d924e398047fbb ]---
Feb 10 22:50:59 italy kernel: [   31.735348] BUG: unable to handle kernel paging request at 63207d49
Feb 10 22:50:59 italy kernel: [   31.735476] IP: [<c011795c>] huge_pte_alloc+0xe/0x29
Feb 10 22:50:59 italy kernel: [   31.735569] *pde = 00000000 
Feb 10 22:50:59 italy kernel: [   31.735645] Oops: 0000 [#2] SMP 
Feb 10 22:50:59 italy kernel: [   31.735747] Modules linked in: crc_ccitt i2c_viapro pcspkr tuner_simple tuner_types snd_seq_oss(+) snd_seq_midi snd_rawmidi tuner snd_seq_midi_event snd_seq tvaudio button snd_timer snd_seq_device snd bttv videodev v4l1_compat firmware_class ir_common compat_ioctl32 soundcore i2c_algo_bit snd_page_alloc v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_core shpchp pci_hotplug via_agp agpgart evdev ext3 jbd mbcache sha256_generic aes_i586 aes_generic cbc sd_mod dm_crypt crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_disk ata_generic libata dock usb_storage scsi_mod via82cxxx ide_pci_generic ide_core uhci_hcd ehci_hcd ohci_hcd usbcore 8139too 8139cp mii thermal processor fan thermal_sys
Feb 10 22:50:59 italy kernel: [   31.736027] 
Feb 10 22:50:59 italy kernel: [   31.736027] Pid: 1778, comm: udevd Tainted: G      D   (2.6.26-1-686 #1)
Feb 10 22:50:59 italy kernel: [   31.736027] EIP: 0060:[<c011795c>] EFLAGS: 00010202 CPU: 0
Feb 10 22:50:59 italy kernel: [   31.736027] EIP is at huge_pte_alloc+0xe/0x29
Feb 10 22:50:59 italy kernel: [   31.736027] EAX: eebcd700 EBX: 00000000 ECX: ee2a8d4c EDX: 63207d49
Feb 10 22:50:59 italy kernel: [   31.736027] ESI: eebcd7b8 EDI: b7f09bb0 EBP: ef710300 ESP: ee365f74
Feb 10 22:50:59 italy kernel: [   31.736027]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb 10 22:50:59 italy kernel: [   31.736027] Process udevd (pid: 1778, ti=ee364000 task=ef710300 task.ti=ee364000)
Feb 10 22:50:59 italy kernel: [   31.736027] Stack: ee2a8d4c c016d941 c0115b4f ee2a8d4c 00000004 ee365fb8 eebcd780 00000000 
Feb 10 22:50:59 italy kernel: [   31.736027]        499204b0 13915d63 499204b0 13915d63 bfeec6ac bfeec4ac c01158b4 bfeec8b8 
Feb 10 22:50:59 italy kernel: [   31.736027]        c02b980a bfeec6ac bfeec8f7 00000000 bfeec4ac bfeec8dc bfeec8b8 0000001e 
Feb 10 22:50:59 italy kernel: [   31.736027] Call Trace:
Feb 10 22:50:59 italy kernel: [   31.736027]  [<c016d941>] hugetlb_fault+0x1d/0x2c7
Feb 10 22:50:59 italy kernel: [   31.736027]  [<c0115b4f>] do_page_fault+0x29b/0x5b8
Feb 10 22:50:59 italy kernel: [   31.736027]  [<c01158b4>] do_page_fault+0x0/0x5b8
Feb 10 22:50:59 italy kernel: [   31.736027]  [<c02b980a>] error_code+0x72/0x78
Feb 10 22:50:59 italy kernel: [   31.736027]  =======================
Feb 10 22:50:59 italy kernel: [   31.736027] Code: ff ff ff 89 46 20 59 5b eb 09 89 df eb 05 bf ea ff ff ff 83 c4 18 89 f8 5b 5e 5f 5d c3 c1 ea 16 53 31 db c1 e2 02 03 50 24 74 17 <83> 3a 00 89 d3 74 10 8b 02 e8 f0 d3 ff ff 90 84 c0 78 04 0f 0b 
Feb 10 22:50:59 italy kernel: [   31.736027] EIP: [<c011795c>] huge_pte_alloc+0xe/0x29 SS:ESP 0068:ee365f74
Feb 10 22:50:59 italy kernel: [   31.742788] ---[ end trace b2d924e398047fbb ]---
Feb 10 22:50:59 italy kernel: [   31.898191] NET: Registered protocol family 23
Feb 10 22:50:59 italy kernel: [   32.202349] input: ImPS/2 Generic Wheel Mouse as /class/input/input5
Feb 10 22:50:59 italy kernel: [   32.230902] parport_pc 00:0a: reported by Plug and Play ACPI
Feb 10 22:50:59 italy kernel: [   32.231031] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
Feb 10 22:50:59 italy kernel: [   32.620920] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 10 22:50:59 italy kernel: [   33.713011] ACPI: PCI Interrupt 0000:00:0a.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 10 22:50:59 italy kernel: [   33.713861] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
Feb 10 22:50:59 italy kernel: [   34.840277] hda: UDMA/133 mode selected
Feb 10 22:50:59 italy kernel: [   34.895178] hdd: UDMA/66 mode selected
Feb 10 22:50:59 italy kernel: [   35.613848] EXT3 FS on dm-1, internal journal
Feb 10 22:50:59 italy kernel: [   36.026991] loop: module loaded
Feb 10 22:50:59 italy kernel: [   36.131008] [drm] Initialized drm 1.1.0 20060810
Feb 10 22:50:59 italy kernel: [   36.174372] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 10 22:50:59 italy kernel: [   36.174673] [drm] Initialized radeon 1.29.0 20080528 on minor 0
Feb 10 22:50:59 italy kernel: [   37.376052] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 10 22:50:59 italy kernel: [   62.999567] kjournald starting.  Commit interval 5 seconds
Feb 10 22:50:59 italy kernel: [   63.009243] EXT3 FS on hda1, internal journal
Feb 10 22:50:59 italy kernel: [   63.009243] EXT3-fs: mounted filesystem with ordered data mode.
Feb 10 22:50:59 italy kernel: [   63.058895] kjournald starting.  Commit interval 5 seconds
Feb 10 22:50:59 italy kernel: [   63.071936] EXT3 FS on dm-3, internal journal
Feb 10 22:50:59 italy kernel: [   63.072084] EXT3-fs: mounted filesystem with ordered data mode.
Feb 10 22:50:59 italy kernel: [   63.111756] kjournald starting.  Commit interval 5 seconds
Feb 10 22:50:59 italy kernel: [   63.111838] EXT3-fs: mounted filesystem with ordered data mode.
Feb 10 22:50:59 italy kernel: [   63.174664] Adding 2330616k swap on /dev/mapper/italy-swap_1.  Priority:-1 extents:1 across:2330616k
Feb 10 22:50:59 italy kernel: [   65.726895] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
Feb 12 00:20:00 italy kernel: klogd 1.5.0#5, log source = /proc/kmsg started.
Feb 12 00:20:00 italy kernel: [    0.000000] Initializing cgroup subsys cpuset
Feb 12 00:20:00 italy kernel: [    0.000000] Initializing cgroup subsys cpu
Feb 12 00:20:00 italy kernel: [    0.000000] Linux version 2.6.26-1-686 (Debian 2.6.26-13) (waldi@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-24)) #1 SMP Sat Jan 10 18:29:31 UTC 2009
Feb 12 00:20:00 italy kernel: [    0.000000] BIOS-provided physical RAM map:
Feb 12 00:20:00 italy kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Feb 12 00:20:00 italy kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Feb 12 00:20:00 italy kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Feb 12 00:20:00 italy kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000002fff0000 (usable)
Feb 12 00:20:00 italy kernel: [    0.000000]  BIOS-e820: 000000002fff0000 - 000000002fff3000 (ACPI NVS)
Feb 12 00:20:00 italy kernel: [    0.000000]  BIOS-e820: 000000002fff3000 - 0000000030000000 (ACPI data)
Feb 12 00:20:00 italy kernel: [    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Feb 12 00:20:00 italy kernel: [    0.000000] 0MB HIGHMEM available.
Feb 12 00:20:00 italy kernel: [    0.000000] 767MB LOWMEM available.
Feb 12 00:20:00 italy kernel: [    0.000000] Entering add_active_range(0, 0, 196592) 0 entries of 256 used
Feb 12 00:20:00 italy kernel: [    0.000000] Zone PFN ranges:
Feb 12 00:20:00 italy kernel: [    0.000000]   DMA             0 ->     4096
Feb 12 00:20:00 italy kernel: [    0.000000]   Normal       4096 ->   196592
Feb 12 00:20:00 italy kernel: [    0.000000]   HighMem    196592 ->   196592
Feb 12 00:20:00 italy kernel: [    0.000000] Movable zone start PFN for each node
Feb 12 00:20:00 italy kernel: [    0.000000] early_node_map[1] active PFN ranges
Feb 12 00:20:00 italy kernel: [    0.000000]     0:        0 ->   196592
Feb 12 00:20:00 italy kernel: [    0.000000] On node 0 totalpages: 196592
Feb 12 00:20:00 italy kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Feb 12 00:20:00 italy kernel: [    0.000000]   DMA zone: 0 pages reserved
Feb 12 00:20:00 italy kernel: [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
Feb 12 00:20:00 italy kernel: [    0.000000]   Normal zone: 1504 pages used for memmap
Feb 12 00:20:00 italy kernel: [    0.000000]   Normal zone: 190992 pages, LIFO batch:31
Feb 12 00:20:00 italy kernel: [    0.000000]   HighMem zone: 0 pages used for memmap
Feb 12 00:20:00 italy kernel: [    0.000000]   Movable zone: 0 pages used for memmap
Feb 12 00:20:00 italy kernel: [    0.000000] DMI 2.2 present.
Feb 12 00:20:00 italy kernel: [    0.000000] ACPI: RSDP 000F62E0, 0014 (r0 VIA694)
Feb 12 00:20:00 italy kernel: [    0.000000] ACPI: RSDT 2FFF3000, 0028 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
Feb 12 00:20:00 italy kernel: [    0.000000] ACPI: FACP 2FFF3040, 0074 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
Feb 12 00:20:00 italy kernel: [    0.000000] ACPI: DSDT 2FFF30C0, 3316 (r1 VIA694 AWRDACPI     1000 MSFT  100000E)
Feb 12 00:20:00 italy kernel: [    0.000000] ACPI: FACS 2FFF0000, 0040
Feb 12 00:20:00 italy kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Feb 12 00:20:00 italy kernel: [    0.000000] Allocating PCI resources starting at 40000000 (gap: 30000000:cfff0000)
Feb 12 00:20:00 italy kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Feb 12 00:20:00 italy kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
Feb 12 00:20:00 italy kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Feb 12 00:20:00 italy kernel: [    0.000000] SMP: Allowing 0 CPUs, 0 hotplug CPUs
Feb 12 00:20:00 italy kernel: [    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
Feb 12 00:20:00 italy kernel: [    0.000000] NR_CPUS: 8, nr_cpu_ids: 1
Feb 12 00:20:00 italy kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195056
Feb 12 00:20:00 italy kernel: [    0.000000] Kernel command line: root=/dev/mapper/italy-root ro 
Feb 12 00:20:00 italy kernel: [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
Feb 12 00:20:00 italy kernel: [    0.000000] mapped APIC to ffffb000 (0160f000)
Feb 12 00:20:00 italy kernel: [    0.000000] Enabling fast FPU save and restore... done.
Feb 12 00:20:00 italy kernel: [    0.000000] Initializing CPU#0
Feb 12 00:20:00 italy kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
Feb 12 00:20:00 italy kernel: [    0.000000] Detected 930.687 MHz processor.
Feb 12 00:20:00 italy kernel: [    0.004000] Console: colour VGA+ 80x25
Feb 12 00:20:00 italy kernel: [    0.004000] console [tty0] enabled
Feb 12 00:20:00 italy kernel: [    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Feb 12 00:20:00 italy kernel: [    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Feb 12 00:20:00 italy kernel: [    0.004000] Memory: 768324k/786368k available (1769k kernel code, 17452k reserved, 752k data, 244k init, 0k highmem)
Feb 12 00:20:00 italy kernel: [    0.004000] virtual kernel memory layout:
Feb 12 00:20:00 italy kernel: [    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
Feb 12 00:20:00 italy kernel: [    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Feb 12 00:20:00 italy kernel: [    0.004000]     vmalloc : 0xf0800000 - 0xff7fe000   ( 239 MB)
Feb 12 00:20:00 italy kernel: [    0.004000]     lowmem  : 0xc0000000 - 0xefff0000   ( 767 MB)
Feb 12 00:20:00 italy kernel: [    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
Feb 12 00:20:00 italy kernel: [    0.004000]       .data : 0xc02ba4ab - 0xc0376620   ( 752 kB)
Feb 12 00:20:00 italy kernel: [    0.004000]       .text : 0xc0100000 - 0xc02ba4ab   (1769 kB)
Feb 12 00:20:00 italy kernel: [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Feb 12 00:20:00 italy kernel: [    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
Feb 12 00:20:00 italy kernel: [    0.084276] Calibrating delay using timer specific routine.. 1863.87 BogoMIPS (lpj=3727757)
Feb 12 00:20:00 italy kernel: [    0.084444] Security Framework initialized
Feb 12 00:20:00 italy kernel: [    0.084501] SELinux:  Disabled at boot.
Feb 12 00:20:00 italy kernel: [    0.084551] Capability LSM initialized
Feb 12 00:20:00 italy kernel: [    0.084627] Mount-cache hash table entries: 512
Feb 12 00:20:00 italy kernel: [    0.084979] Initializing cgroup subsys ns
Feb 12 00:20:00 italy kernel: [    0.085031] Initializing cgroup subsys cpuacct
Feb 12 00:20:00 italy kernel: [    0.085081] Initializing cgroup subsys devices
Feb 12 00:20:00 italy kernel: [    0.085163] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Feb 12 00:20:00 italy kernel: [    0.085218] CPU: L2 Cache: 256K (64 bytes/line)
Feb 12 00:20:00 italy kernel: [    0.085269] Intel machine check architecture supported.
Feb 12 00:20:00 italy kernel: [    0.085320] Intel machine check reporting enabled on CPU#0.
Feb 12 00:20:00 italy kernel: [    0.085393] Checking 'hlt' instruction... OK.
Feb 12 00:20:00 italy kernel: [    0.100367] SMP alternatives: switching to UP code
Feb 12 00:20:00 italy kernel: [    0.114487] Freeing SMP alternatives: 16k freed
Feb 12 00:20:00 italy kernel: [    0.114545] ACPI: Core revision 20080321
Feb 12 00:20:00 italy kernel: [    0.123955] ACPI: setting ELCR to 0200 (from 0e00)
Feb 12 00:20:00 italy kernel: [    0.128008] weird, boot CPU (#0) not listedby the BIOS.
Feb 12 00:20:00 italy kernel: [    0.128008] SMP motherboard not detected.
Feb 12 00:20:00 italy kernel: [    0.128008] Local APIC not detected. Using dummy APIC emulation.
Feb 12 00:20:00 italy kernel: [    0.128008] SMP disabled
Feb 12 00:20:00 italy kernel: [    0.128008] Brought up 1 CPUs
Feb 12 00:20:00 italy kernel: [    0.128008] Total of 1 processors activated (1863.87 BogoMIPS).
Feb 12 00:20:00 italy kernel: [    0.128008] CPU0 attaching sched-domain:
Feb 12 00:20:00 italy kernel: [    0.128008]  domain 0: span 0
Feb 12 00:20:00 italy kernel: [    0.128008]   groups: 0
Feb 12 00:20:00 italy kernel: [    0.128008] net_namespace: 660 bytes
Feb 12 00:20:00 italy kernel: [    0.128008] Booting paravirtualized kernel on bare hardware
Feb 12 00:20:00 italy kernel: [    0.128008] NET: Registered protocol family 16
Feb 12 00:20:00 italy kernel: [    0.128008] ACPI: bus type pci registered
Feb 12 00:20:00 italy kernel: [    0.130376] PCI: PCI BIOS revision 2.10 entry at 0xfb3e0, last bus=1
Feb 12 00:20:00 italy kernel: [    0.130430] PCI: Using configuration type 1 for base access
Feb 12 00:20:00 italy kernel: [    0.130501] Setting up standard PCI resources
Feb 12 00:20:00 italy kernel: [    0.136668] ACPI: EC: Look up EC in DSDT
Feb 12 00:20:00 italy kernel: [    0.144972] ACPI: Interpreter enabled
Feb 12 00:20:00 italy kernel: [    0.145030] ACPI: (supports S0 S1 S4 S5)
Feb 12 00:20:00 italy kernel: [    0.145217] ACPI: Using PIC for interrupt routing
Feb 12 00:20:00 italy kernel: [    0.154063] ACPI: PCI Root Bridge [PCI0] (0000:00)
Feb 12 00:20:00 italy kernel: [    0.155186] pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
Feb 12 00:20:00 italy kernel: [    0.155243] pci 0000:00:11.0: quirk: region 5000-500f claimed by vt8235 SMB
Feb 12 00:20:00 italy kernel: [    0.155562] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb 12 00:20:00 italy kernel: [    0.199766] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Feb 12 00:20:00 italy kernel: [    0.200548] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Feb 12 00:20:00 italy kernel: [    0.201307] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Feb 12 00:20:00 italy kernel: [    0.202062] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Feb 12 00:20:00 italy kernel: [    0.202800] Linux Plug and Play Support v0.97 (c) Adam Belay
Feb 12 00:20:00 italy kernel: [    0.202929] pnp: PnP ACPI init
Feb 12 00:20:00 italy kernel: [    0.202990] ACPI: bus type pnp registered
Feb 12 00:20:00 italy kernel: [    0.209754] pnp: PnP ACPI: found 13 devices
Feb 12 00:20:00 italy kernel: [    0.209811] ACPI: ACPI bus type pnp unregistered
Feb 12 00:20:00 italy kernel: [    0.209864] PnPBIOS: Disabled by ACPI PNP
Feb 12 00:20:00 italy kernel: [    0.210581] PCI: Using ACPI for IRQ routing
Feb 12 00:20:00 italy kernel: [    0.211103] ACPI: RTC can wake from S4
Feb 12 00:20:00 italy kernel: [    0.211214] system 00:00: iomem range 0xcd000-0xcffff has been reserved
Feb 12 00:20:00 italy kernel: [    0.211270] system 00:00: iomem range 0xf0000-0xf7fff could not be reserved
Feb 12 00:20:00 italy kernel: [    0.211325] system 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Feb 12 00:20:00 italy kernel: [    0.211380] system 00:00: iomem range 0xfc000-0xfffff could not be reserved
Feb 12 00:20:00 italy kernel: [    0.211434] system 00:00: iomem range 0x2fff0000-0x2fffffff could not be reserved
Feb 12 00:20:00 italy kernel: [    0.211496] system 00:00: iomem range 0xffff0000-0xffffffff could not be reserved
Feb 12 00:20:00 italy kernel: [    0.211557] system 00:00: iomem range 0x0-0x9ffff could not be reserved
Feb 12 00:20:00 italy kernel: [    0.211611] system 00:00: iomem range 0x100000-0x2ffeffff could not be reserved
Feb 12 00:20:00 italy kernel: [    0.211672] system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
Feb 12 00:20:00 italy kernel: [    0.211727] system 00:00: iomem range 0xfff80000-0xfffeffff has been reserved
Feb 12 00:20:00 italy kernel: [    0.211793] system 00:02: ioport range 0x4000-0x407f has been reserved
Feb 12 00:20:00 italy kernel: [    0.211847] system 00:02: ioport range 0x5000-0x500f has been reserved
Feb 12 00:20:00 italy kernel: [    0.211921] system 00:03: ioport range 0x4d0-0x4d1 has been reserved
Feb 12 00:20:00 italy kernel: [    0.211975] system 00:03: ioport range 0x800-0x805 has been reserved
Feb 12 00:20:00 italy kernel: [    0.212053] system 00:03: ioport range 0x290-0x297 has been reserved
Feb 12 00:20:00 italy kernel: [    0.243079] PCI: Bridge: 0000:00:01.0
Feb 12 00:20:00 italy kernel: [    0.243128]   IO window: c000-cfff
Feb 12 00:20:00 italy kernel: [    0.243177]   MEM window: 0xe8000000-0xe9ffffff
Feb 12 00:20:00 italy kernel: [    0.243227]   PREFETCH window: 0x00000000d8000000-0x00000000e7ffffff
Feb 12 00:20:00 italy kernel: [    0.243300] PCI: Setting latency timer of device 0000:00:01.0 to 64
Feb 12 00:20:00 italy kernel: [    0.243348] NET: Registered protocol family 2
Feb 12 00:20:00 italy kernel: [    0.243598] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Feb 12 00:20:00 italy kernel: [    0.244463] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Feb 12 00:20:00 italy kernel: [    0.249402] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Feb 12 00:20:00 italy kernel: [    0.251946] TCP: Hash tables configured (established 131072 bind 65536)
Feb 12 00:20:00 italy kernel: [    0.252029] TCP reno registered
Feb 12 00:20:00 italy kernel: [    0.252359] NET: Registered protocol family 1
Feb 12 00:20:00 italy kernel: [    0.252697] checking if image is initramfs...<7>Switched to high resolution mode on CPU 0
Feb 12 00:20:00 italy kernel: [    0.828748]  it is
Feb 12 00:20:00 italy kernel: [    1.515800] Freeing initrd memory: 7199k freed
Feb 12 00:20:00 italy kernel: [    1.517480] audit: initializing netlink socket (disabled)
Feb 12 00:20:00 italy kernel: [    1.517565] type=2000 audit(1234397951.516:1): initialized
Feb 12 00:20:00 italy kernel: [    1.517892] Total HugeTLB memory allocated, 0
Feb 12 00:20:00 italy kernel: [    1.518109] VFS: Disk quotas dquot_6.5.1
Feb 12 00:20:00 italy kernel: [    1.518221] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Feb 12 00:20:00 italy kernel: [    1.518351] msgmni has been set to 1515
Feb 12 00:20:00 italy kernel: [    1.518632] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Feb 12 00:20:00 italy kernel: [    1.518697] io scheduler noop registered
Feb 12 00:20:00 italy kernel: [    1.518744] io scheduler anticipatory registered
Feb 12 00:20:00 italy kernel: [    1.518792] io scheduler deadline registered
Feb 12 00:20:00 italy kernel: [    1.518851] io scheduler cfq registered (default)
Feb 12 00:20:00 italy kernel: [    1.518919] PCI: VIA PCI bridge detected.Disabling DAC.
Feb 12 00:20:00 italy kernel: [    1.519145] pci 0000:01:00.0: Boot video device
Feb 12 00:20:00 italy kernel: [    1.519953] isapnp: Scanning for PnP cards...
Feb 12 00:20:00 italy kernel: [    1.874050] isapnp: No Plug & Play device found
Feb 12 00:20:00 italy kernel: [    1.881358] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Feb 12 00:20:00 italy kernel: [    1.881629] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 12 00:20:00 italy kernel: [    1.881857] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 12 00:20:00 italy kernel: [    1.882586] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 12 00:20:00 italy kernel: [    1.882906] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 12 00:20:00 italy kernel: [    1.886620] brd: module loaded
Feb 12 00:20:00 italy kernel: [    1.886905] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Feb 12 00:20:00 italy kernel: [    1.887427] serio: i8042 KBD port at 0x60,0x64 irq 1
Feb 12 00:20:00 italy kernel: [    1.887485] serio: i8042 AUX port at 0x60,0x64 irq 12
Feb 12 00:20:00 italy kernel: [    1.887884] mice: PS/2 mouse device common for all mice
Feb 12 00:20:00 italy kernel: [    1.888286] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
Feb 12 00:20:00 italy kernel: [    1.888363] rtc0: alarms up to one year, y3k
Feb 12 00:20:00 italy kernel: [    1.888492] cpuidle: using governor ladder
Feb 12 00:20:00 italy kernel: [    1.888540] cpuidle: using governor menu
Feb 12 00:20:00 italy kernel: [    1.888594] No iBFT detected.
Feb 12 00:20:00 italy kernel: [    1.889684] TCP cubic registered
Feb 12 00:20:00 italy kernel: [    1.889734] NET: Registered protocol family 17
Feb 12 00:20:00 italy kernel: [    1.889792] Using IPI No-Shortcut mode
Feb 12 00:20:00 italy kernel: [    1.890125] registered taskstats version 1
Feb 12 00:20:00 italy kernel: [    1.890533] rtc_cmos 00:05: setting system clock to 2009-02-12 00:19:13 UTC (1234397953)
Feb 12 00:20:00 italy kernel: [    1.891202] Freeing unused kernel memory: 244k freed
Feb 12 00:20:00 italy kernel: [    1.911147] input: AT Translated Set 2 keyboard as /class/input/input0
Feb 12 00:20:00 italy kernel: [    2.141989] ACPI: PNP0C0B:00 is registered as cooling_device0
Feb 12 00:20:00 italy kernel: [    2.142067] ACPI: Fan [FAN] (on)
Feb 12 00:20:00 italy kernel: [    2.155956] ACPI: CPU0 (power states: C1[C1] C2[C2])
Feb 12 00:20:00 italy kernel: [    2.156242] ACPI: ACPI0007:00 is registered as cooling_device1
Feb 12 00:20:00 italy kernel: [    2.160464] ACPI: LNXTHERM:01 is registered as thermal_zone0
Feb 12 00:20:00 italy kernel: [    2.160792] ACPI: Thermal Zone [THRM] (40 C)
Feb 12 00:20:00 italy kernel: [    3.272119] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
Feb 12 00:20:00 italy kernel: [    3.272224] 8139cp 0000:00:0b.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
Feb 12 00:20:00 italy kernel: [    3.272287] 8139cp 0000:00:0b.0: Try the "8139too" driver instead.
Feb 12 00:20:00 italy kernel: [    3.304353] 8139too Fast Ethernet driver 0.9.28
Feb 12 00:20:00 italy kernel: [    3.305315] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
Feb 12 00:20:00 italy kernel: [    3.305369] PCI: setting IRQ 11 as level-triggered
Feb 12 00:20:00 italy kernel: [    3.305377] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 12 00:20:00 italy kernel: [    3.306399] eth0: RealTek RTL8139 at 0xd400, 00:02:44:14:3f:2c, IRQ 11
Feb 12 00:20:00 italy kernel: [    3.306454] eth0:  Identified 8139 chip type 'RTL-8139B'
Feb 12 00:20:00 italy kernel: [    3.816254] usbcore: registered new interface driver usbfs
Feb 12 00:20:00 italy kernel: [    3.816384] usbcore: registered new interface driver hub
Feb 12 00:20:00 italy kernel: [    3.816518] usbcore: registered new device driver usb
Feb 12 00:20:00 italy kernel: [    3.843264] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Feb 12 00:20:00 italy kernel: [    3.844153] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
Feb 12 00:20:00 italy kernel: [    3.844214] PCI: setting IRQ 10 as level-triggered
Feb 12 00:20:00 italy kernel: [    3.844222] ACPI: PCI Interrupt 0000:00:0c.0[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 12 00:20:00 italy kernel: [    3.844366] ohci_hcd 0000:00:0c.0: OHCI Host Controller
Feb 12 00:20:00 italy kernel: [    3.844668] ohci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 1
Feb 12 00:20:00 italy kernel: [    3.844757] ohci_hcd 0000:00:0c.0: irq 10, io mem 0xea003000
Feb 12 00:20:00 italy kernel: [    3.902326] usb usb1: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    3.902458] hub 1-0:1.0: USB hub found
Feb 12 00:20:00 italy kernel: [    3.902529] hub 1-0:1.0: 2 ports detected
Feb 12 00:20:00 italy kernel: [    3.929843] USB Universal Host Controller Interface driver v3.0
Feb 12 00:20:00 italy kernel: [    4.012634] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Feb 12 00:20:00 italy kernel: [    4.012701] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 12 00:20:00 italy kernel: [    4.012761] usb usb1: Product: OHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.012810] usb usb1: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 12 00:20:00 italy kernel: [    4.012860] usb usb1: SerialNumber: 0000:00:0c.0
Feb 12 00:20:00 italy kernel: [    4.013877] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
Feb 12 00:20:00 italy kernel: [    4.013931] ACPI: PCI Interrupt 0000:00:0c.1[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 12 00:20:00 italy kernel: [    4.014074] ohci_hcd 0000:00:0c.1: OHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.014181] ohci_hcd 0000:00:0c.1: new USB bus registered, assigned bus number 2
Feb 12 00:20:00 italy kernel: [    4.014270] ohci_hcd 0000:00:0c.1: irq 11, io mem 0xea004000
Feb 12 00:20:00 italy kernel: [    4.018404] BUG: unable to handle kernel paging request at 01251000
Feb 12 00:20:00 italy kernel: [    4.018532] IP: [<c0163ae0>] handle_mm_fault+0x64/0x690
Feb 12 00:20:00 italy kernel: [    4.018629] *pde = 00000000 
Feb 12 00:20:00 italy kernel: [    4.018705] Oops: 0000 [#1] SMP 
Feb 12 00:20:00 italy kernel: [    4.018806] Modules linked in: uhci_hcd(+) ehci_hcd(+) ohci_hcd(+) usbcore 8139too 8139cp mii thermal processor fan thermal_sys
Feb 12 00:20:00 italy kernel: [    4.019223] 
Feb 12 00:20:00 italy kernel: [    4.019266] Pid: 651, comm: sh Not tainted (2.6.26-1-686 #1)
Feb 12 00:20:00 italy kernel: [    4.019316] EIP: 0060:[<c0163ae0>] EFLAGS: 00010246 CPU: 0
Feb 12 00:20:00 italy kernel: [    4.019369] EIP is at handle_mm_fault+0x64/0x690
Feb 12 00:20:00 italy kernel: [    4.019418] EAX: 01251000 EBX: ede2b764 ECX: ede2b764 EDX: c03b85e0
Feb 12 00:20:00 italy kernel: [    4.019470] ESI: eddeb738 EDI: b7e7df80 EBP: edd3ee80 ESP: edef5f10
Feb 12 00:20:00 italy kernel: [    4.019522]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb 12 00:20:00 italy kernel: [    4.019573] Process sh (pid: 651, ti=edef4000 task=edd3ee80 task.ti=edef4000)
Feb 12 00:20:00 italy kernel: [    4.019619] Stack: c0355c80 edee0000 00000000 b7e7df80 ede2b764 eddeb700 000008cc eded8b7c 
Feb 12 00:20:00 italy kernel: [    4.019941]        c03b85e0 c018b8a4 edef5fa0 00000001 bf9a3227 edd009a0 edd63b80 00000000 
Feb 12 00:20:00 italy kernel: [    4.020030]        00000000 00000000 00000001 c01ace18 00000001 ef0fb8f0 ef0eec6c ede2b764 
Feb 12 00:20:00 italy kernel: [    4.020030] Call Trace:
Feb 12 00:20:00 italy kernel: [    4.020030]  [<c018b8a4>] simple_read_from_buffer+0x64/0x8d
Feb 12 00:20:00 italy kernel: [    4.020030]  [<c01ace18>] sysfs_read_file+0xde/0xe8
Feb 12 00:20:00 italy kernel: [    4.020030]  [<c0115b4f>] do_page_fault+0x29b/0x5b8
Feb 12 00:20:00 italy kernel: [    4.020030]  [<c0174de3>] sys_read+0x3c/0x63
Feb 12 00:20:00 italy kernel: [    4.020030]  [<c01158b4>] do_page_fault+0x0/0x5b8
Feb 12 00:20:00 italy kernel: [    4.020030]  [<c02b980a>] error_code+0x72/0x78
Feb 12 00:20:00 italy kernel: [    4.020030]  =======================
Feb 12 00:20:00 italy kernel: [    4.020030] Code: 2c 8b 4c 24 10 f6 41 16 40 74 20 8b 44 24 08 8b 4c 24 0c 8b 54 24 10 89 44 24 70 8b 44 24 14 83 c4 5c 5b 5e 5f 5d e9 44 9e 00 00 <8b> 44 24 0c 8b 54 24 14 c1 e8 16 c1 e0 02 89 44 24 1c 8b 52 24 
Feb 12 00:20:00 italy kernel: [    4.020030] EIP: [<c0163ae0>] handle_mm_fault+0x64/0x690 SS:ESP 0068:edef5f10
Feb 12 00:20:00 italy kernel: [    4.023343] ---[ end trace d5c34e1f0dc40238 ]---
Feb 12 00:20:00 italy kernel: [    4.062508] Uniform Multi-Platform E-IDE driver
Feb 12 00:20:00 italy kernel: [    4.062574] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb 12 00:20:00 italy kernel: [    4.070618] usb usb2: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    4.070746] hub 2-0:1.0: USB hub found
Feb 12 00:20:00 italy kernel: [    4.070810] hub 2-0:1.0: 2 ports detected
Feb 12 00:20:00 italy kernel: [    4.172347] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Feb 12 00:20:00 italy kernel: [    4.172414] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 12 00:20:00 italy kernel: [    4.172474] usb usb2: Product: OHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.172523] usb usb2: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 12 00:20:00 italy kernel: [    4.172573] usb usb2: SerialNumber: 0000:00:0c.1
Feb 12 00:20:00 italy kernel: [    4.172768] ACPI: PCI Interrupt 0000:00:0c.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 12 00:20:00 italy kernel: [    4.172921] ohci_hcd 0000:00:0c.2: OHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.173026] ohci_hcd 0000:00:0c.2: new USB bus registered, assigned bus number 3
Feb 12 00:20:00 italy kernel: [    4.173114] ohci_hcd 0000:00:0c.2: irq 11, io mem 0xea005000
Feb 12 00:20:00 italy kernel: [    4.230327] usb usb3: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    4.230463] hub 3-0:1.0: USB hub found
Feb 12 00:20:00 italy kernel: [    4.230536] hub 3-0:1.0: 2 ports detected
Feb 12 00:20:00 italy kernel: [    4.296170] Marking TSC unstable due to: TSC halts in idle.
Feb 12 00:20:00 italy kernel: [    4.332307] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Feb 12 00:20:00 italy kernel: [    4.332363] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 12 00:20:00 italy kernel: [    4.332423] usb usb3: Product: OHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.332471] usb usb3: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 12 00:20:00 italy kernel: [    4.332521] usb usb3: SerialNumber: 0000:00:0c.2
Feb 12 00:20:00 italy kernel: [    4.333704] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
Feb 12 00:20:00 italy kernel: [    4.333758] ACPI: PCI Interrupt 0000:00:0c.3[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 12 00:20:00 italy kernel: [    4.333904] ehci_hcd 0000:00:0c.3: EHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.334011] ehci_hcd 0000:00:0c.3: new USB bus registered, assigned bus number 4
Feb 12 00:20:00 italy kernel: [    4.356076] ehci_hcd 0000:00:0c.3: debug port 1
Feb 12 00:20:00 italy kernel: [    4.356162] ehci_hcd 0000:00:0c.3: irq 10, io mem 0xea006000
Feb 12 00:20:00 italy kernel: [    4.368120] ehci_hcd 0000:00:0c.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 12 00:20:00 italy kernel: [    4.368393] usb usb4: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    4.368511] hub 4-0:1.0: USB hub found
Feb 12 00:20:00 italy kernel: [    4.368577] hub 4-0:1.0: 6 ports detected
Feb 12 00:20:00 italy kernel: [    4.472343] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
Feb 12 00:20:00 italy kernel: [    4.472409] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 12 00:20:00 italy kernel: [    4.472468] usb usb4: Product: EHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.472517] usb usb4: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
Feb 12 00:20:00 italy kernel: [    4.472567] usb usb4: SerialNumber: 0000:00:0c.3
Feb 12 00:20:00 italy kernel: [    4.472716] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 12 00:20:00 italy kernel: [    4.472856] uhci_hcd 0000:00:10.0: UHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.472959] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 5
Feb 12 00:20:00 italy kernel: [    4.473053] uhci_hcd 0000:00:10.0: irq 10, io base 0x0000d800
Feb 12 00:20:00 italy kernel: [    4.473305] usb usb5: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    4.473419] hub 5-0:1.0: USB hub found
Feb 12 00:20:00 italy kernel: [    4.473484] hub 5-0:1.0: 2 ports detected
Feb 12 00:20:00 italy kernel: [    4.576393] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Feb 12 00:20:00 italy kernel: [    4.576460] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 12 00:20:00 italy kernel: [    4.576520] usb usb5: Product: UHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.576568] usb usb5: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 12 00:20:00 italy kernel: [    4.576618] usb usb5: SerialNumber: 0000:00:10.0
Feb 12 00:20:00 italy kernel: [    4.576778] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 12 00:20:00 italy kernel: [    4.576918] uhci_hcd 0000:00:10.1: UHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.577022] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 6
Feb 12 00:20:00 italy kernel: [    4.577118] uhci_hcd 0000:00:10.1: irq 10, io base 0x0000dc00
Feb 12 00:20:00 italy kernel: [    4.577368] usb usb6: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    4.577483] hub 6-0:1.0: USB hub found
Feb 12 00:20:00 italy kernel: [    4.577547] hub 6-0:1.0: 2 ports detected
Feb 12 00:20:00 italy kernel: [    4.680295] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Feb 12 00:20:00 italy kernel: [    4.680361] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 12 00:20:00 italy kernel: [    4.680421] usb usb6: Product: UHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.680469] usb usb6: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 12 00:20:00 italy kernel: [    4.680519] usb usb6: SerialNumber: 0000:00:10.1
Feb 12 00:20:00 italy kernel: [    4.680669] ACPI: PCI Interrupt 0000:00:10.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 12 00:20:00 italy kernel: [    4.680810] uhci_hcd 0000:00:10.2: UHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.680915] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 7
Feb 12 00:20:00 italy kernel: [    4.681006] uhci_hcd 0000:00:10.2: irq 11, io base 0x0000e000
Feb 12 00:20:00 italy kernel: [    4.681267] usb usb7: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    4.681384] hub 7-0:1.0: USB hub found
Feb 12 00:20:00 italy kernel: [    4.681448] hub 7-0:1.0: 2 ports detected
Feb 12 00:20:00 italy kernel: [    4.732059] usb 4-5: new high speed USB device using ehci_hcd and address 2
Feb 12 00:20:00 italy kernel: [    4.784268] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Feb 12 00:20:00 italy kernel: [    4.784324] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 12 00:20:00 italy kernel: [    4.784383] usb usb7: Product: UHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.784432] usb usb7: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 12 00:20:00 italy kernel: [    4.784482] usb usb7: SerialNumber: 0000:00:10.2
Feb 12 00:20:00 italy kernel: [    4.784618] ACPI: PCI Interrupt 0000:00:10.3[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 12 00:20:00 italy kernel: [    4.784770] ehci_hcd 0000:00:10.3: EHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.784874] ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 8
Feb 12 00:20:00 italy kernel: [    4.785011] ehci_hcd 0000:00:10.3: irq 11, io mem 0xea007000
Feb 12 00:20:00 italy kernel: [    4.856045] ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 12 00:20:00 italy kernel: [    4.856291] usb usb8: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    4.856412] hub 8-0:1.0: USB hub found
Feb 12 00:20:00 italy kernel: [    4.857116] hub 8-0:1.0: 6 ports detected
Feb 12 00:20:00 italy kernel: [    4.866673] usb 4-5: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [    4.867948] usb 4-5: New USB device found, idVendor=059f, idProduct=0951
Feb 12 00:20:00 italy kernel: [    4.868050] usb 4-5: New USB device strings: Mfr=10, Product=11, SerialNumber=5
Feb 12 00:20:00 italy kernel: [    4.868111] usb 4-5: Product: LaCie Hard Drive USB
Feb 12 00:20:00 italy kernel: [    4.868160] usb 4-5: Manufacturer: LaCie SA
Feb 12 00:20:00 italy kernel: [    4.868206] usb 4-5: SerialNumber: 031D703971FF
Feb 12 00:20:00 italy kernel: [    4.960253] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
Feb 12 00:20:00 italy kernel: [    4.960313] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 12 00:20:00 italy kernel: [    4.960373] usb usb8: Product: EHCI Host Controller
Feb 12 00:20:00 italy kernel: [    4.960421] usb usb8: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
Feb 12 00:20:00 italy kernel: [    4.960471] usb usb8: SerialNumber: 0000:00:10.3
Feb 12 00:20:00 italy kernel: [    4.965482] VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:11.1
Feb 12 00:20:00 italy kernel: [    4.965600] ACPI: PCI Interrupt 0000:00:11.1[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 12 00:20:00 italy kernel: [    4.965728] VIA_IDE 0000:00:11.1: VIA VLink IRQ fixup, from 255 to 10
Feb 12 00:20:00 italy kernel: [    4.965809] VP_IDE: not 100% native mode: will probe irqs later
Feb 12 00:20:00 italy kernel: [    4.965895] VP_IDE: VIA vt8235 (rev 00) IDE UDMA133 controller on pci0000:00:11.1
Feb 12 00:20:00 italy kernel: [    4.965969]     ide0: BM-DMA at 0xe400-0xe407
Feb 12 00:20:00 italy kernel: [    4.966027]     ide1: BM-DMA at 0xe408-0xe40f
Feb 12 00:20:00 italy kernel: [    4.966077] Probing IDE interface ide0...
Feb 12 00:20:00 italy kernel: [    5.380245] hda: Maxtor 6B200P0, ATA DISK drive
Feb 12 00:20:00 italy kernel: [    5.509532] SCSI subsystem initialized
Feb 12 00:20:00 italy kernel: [    5.518467] Initializing USB Mass Storage driver...
Feb 12 00:20:00 italy kernel: [    5.644289] scsi0 : SCSI emulation for USB Mass Storage devices
Feb 12 00:20:00 italy kernel: [    5.644994] usbcore: registered new interface driver usb-storage
Feb 12 00:20:00 italy kernel: [    5.645052] USB Mass Storage support registered.
Feb 12 00:20:00 italy kernel: [    5.649961] usb-storage: device found at 2
Feb 12 00:20:00 italy kernel: [    5.650022] usb-storage: waiting for device to settle before scanning
Feb 12 00:20:00 italy kernel: [    6.060148] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Feb 12 00:20:00 italy kernel: [    6.061715] hda: UDMA/133 mode selected
Feb 12 00:20:00 italy kernel: [    6.063269] Probing IDE interface ide1...
Feb 12 00:20:00 italy kernel: [    7.208143] hdd: SONY DVD RW DW-D22A, ATAPI CD/DVD-ROM drive
Feb 12 00:20:00 italy kernel: [    7.264118] hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Feb 12 00:20:00 italy kernel: [    7.264440] hdd: UDMA/66 mode selected
Feb 12 00:20:00 italy kernel: [    7.264868] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb 12 00:20:00 italy kernel: [    7.287400] ide1 at 0x170-0x177,0x376 on irq 15
Feb 12 00:20:00 italy kernel: [    7.293005] No dock devices found.
Feb 12 00:20:00 italy kernel: [    7.315938] libata version 3.00 loaded.
Feb 12 00:20:00 italy kernel: [    7.405730] hda: max request size: 512KiB
Feb 12 00:20:00 italy kernel: [    7.408523] hda: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63
Feb 12 00:20:00 italy kernel: [    7.413279] hda: cache flushes supported
Feb 12 00:20:00 italy kernel: [    7.413436]  hda: hda1 hda2 < hda5 >
Feb 12 00:20:00 italy kernel: [    7.435098] hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Feb 12 00:20:00 italy kernel: [    7.435343] Uniform CD-ROM driver Revision: 3.20
Feb 12 00:20:00 italy kernel: [    7.713554] device-mapper: uevent: version 1.0.3
Feb 12 00:20:00 italy kernel: [    7.716457] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Feb 12 00:20:00 italy kernel: [   10.648998] usb-storage: device scan complete
Feb 12 00:20:00 italy kernel: [   10.737858] scsi 0:0:0:0: Direct-Access     SAMSUNG  HD500LJ               PQ: 0 ANSI: 2 CCS
Feb 12 00:20:00 italy kernel: [   10.778008] Driver 'sd' needs updating - please use bus_type methods
Feb 12 00:20:00 italy kernel: [   10.779974] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Feb 12 00:20:00 italy kernel: [   10.781207] sd 0:0:0:0: [sda] Write Protect is off
Feb 12 00:20:00 italy kernel: [   10.781219] sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
Feb 12 00:20:00 italy kernel: [   10.781225] sd 0:0:0:0: [sda] Assuming drive cache: write through
Feb 12 00:20:00 italy kernel: [   10.783472] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Feb 12 00:20:00 italy kernel: [   10.784849] sd 0:0:0:0: [sda] Write Protect is off
Feb 12 00:20:00 italy kernel: [   10.784862] sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
Feb 12 00:20:00 italy kernel: [   10.784868] sd 0:0:0:0: [sda] Assuming drive cache: write through
Feb 12 00:20:00 italy kernel: [   10.784876]  sda: sda1
Feb 12 00:20:00 italy kernel: [   10.786316] sd 0:0:0:0: [sda] Attached SCSI disk
Feb 12 00:20:00 italy kernel: [   10.980053] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 12 00:20:00 italy kernel: [   11.240050] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 12 00:20:00 italy kernel: [   19.905376] PM: Starting manual resume from disk
Feb 12 00:20:00 italy kernel: [   19.947387] EXT3-fs: INFO: recovery required on readonly filesystem.
Feb 12 00:20:00 italy kernel: [   19.947455] EXT3-fs: write access will be enabled during recovery.
Feb 12 00:20:00 italy kernel: [   25.256689] kjournald starting.  Commit interval 5 seconds
Feb 12 00:20:00 italy kernel: [   25.256798] EXT3-fs: dm-1: orphan cleanup on readonly fs
Feb 12 00:20:00 italy kernel: [   25.344338] ext3_orphan_cleanup: deleting unreferenced inode 421838
Feb 12 00:20:00 italy kernel: [   25.433075] ext3_orphan_cleanup: deleting unreferenced inode 421831
Feb 12 00:20:00 italy kernel: [   25.613388] ext3_orphan_cleanup: deleting unreferenced inode 827588
Feb 12 00:20:00 italy kernel: [   25.636968] ext3_orphan_cleanup: deleting unreferenced inode 811453
Feb 12 00:20:00 italy kernel: [   25.637026] ext3_orphan_cleanup: deleting unreferenced inode 827434
Feb 12 00:20:00 italy kernel: [   25.637044] ext3_orphan_cleanup: deleting unreferenced inode 827433
Feb 12 00:20:00 italy kernel: [   25.637059] ext3_orphan_cleanup: deleting unreferenced inode 827432
Feb 12 00:20:00 italy kernel: [   25.637073] ext3_orphan_cleanup: deleting unreferenced inode 827431
Feb 12 00:20:00 italy kernel: [   25.637088] ext3_orphan_cleanup: deleting unreferenced inode 827430
Feb 12 00:20:00 italy kernel: [   25.637101] EXT3-fs: dm-1: 9 orphan inodes deleted
Feb 12 00:20:00 italy kernel: [   25.637151] EXT3-fs: recovery complete.
Feb 12 00:20:00 italy kernel: [   25.644144] EXT3-fs: mounted filesystem with ordered data mode.
Feb 12 00:20:00 italy kernel: [   29.068584] udevd version 125 started
Feb 12 00:20:00 italy kernel: [   30.045211] hda: UDMA/133 mode selected
Feb 12 00:20:00 italy kernel: [   30.055936] hdd: UDMA/66 mode selected
Feb 12 00:20:00 italy kernel: [   30.096107] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 12 00:20:00 italy kernel: [   31.083663] BUG: unable to handle kernel NULL pointer dereference at 00000edc
Feb 12 00:20:00 italy kernel: [   31.083790] IP: [<c011795c>] huge_pte_alloc+0xe/0x29
Feb 12 00:20:00 italy kernel: [   31.083882] *pde = 00000000 
Feb 12 00:20:00 italy kernel: [   31.083958] Oops: 0000 [#2] SMP 
Feb 12 00:20:00 italy kernel: [   31.084039] Modules linked in: evdev ext3 jbd mbcache sha256_generic aes_i586 aes_generic cbc sd_mod dm_crypt crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod ide_cd_mod ide_disk cdrom ata_generic libata dock usb_storage scsi_mod via82cxxx ide_pci_generic ide_core uhci_hcd ehci_hcd ohci_hcd usbcore 8139too 8139cp mii thermal processor fan thermal_sys
Feb 12 00:20:00 italy kernel: [   31.084039] 
Feb 12 00:20:00 italy kernel: [   31.084039] Pid: 1454, comm: udevd Tainted: G      D   (2.6.26-1-686 #1)
Feb 12 00:20:00 italy kernel: [   31.084039] EIP: 0060:[<c011795c>] EFLAGS: 00010202 CPU: 0
Feb 12 00:20:00 italy kernel: [   31.084039] EIP is at huge_pte_alloc+0xe/0x29
Feb 12 00:20:00 italy kernel: [   31.084039] EAX: edd91d00 EBX: 00000000 ECX: edcc3d4c EDX: 00000edc
Feb 12 00:20:00 italy kernel: [   31.084039] ESI: edd91d98 EDI: b7d8a200 EBP: ef44e480 ESP: edcc1f74
Feb 12 00:20:00 italy kernel: [   31.084039]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb 12 00:20:00 italy kernel: [   31.084039] Process udevd (pid: 1454, ti=edcc0000 task=ef44e480 task.ti=edcc0000)
Feb 12 00:20:00 italy kernel: [   31.084039] Stack: edcc3d4c c016d941 c0115b4f edcc3d4c 00000004 edcc1fb8 edd91d60 00000000 
Feb 12 00:20:00 italy kernel: [   31.084039]        08eb96b8 00000000 c012dc68 00000007 bfc13e70 08eb96b8 c01158b4 bfc13f08 
Feb 12 00:20:00 italy kernel: [   31.084039]        c02b980a bfc13e70 00000000 fffffffe 08eb96b8 08eb96b8 bfc13f08 bfc13e74 
Feb 12 00:20:00 italy kernel: [   31.084039] Call Trace:
Feb 12 00:20:00 italy kernel: [   31.084039]  [<c016d941>] hugetlb_fault+0x1d/0x2c7
Feb 12 00:20:00 italy kernel: [   31.084039]  [<c0115b4f>] do_page_fault+0x29b/0x5b8
Feb 12 00:20:00 italy kernel: [   31.084039]  [<c012dc68>] sys_setpriority+0x8a/0x18d
Feb 12 00:20:00 italy kernel: [   31.084039]  [<c01158b4>] do_page_fault+0x0/0x5b8
Feb 12 00:20:00 italy kernel: [   31.084039]  [<c02b980a>] error_code+0x72/0x78
Feb 12 00:20:00 italy kernel: [   31.084039]  =======================
Feb 12 00:20:00 italy kernel: [   31.084039] Code: ff ff ff 89 46 20 59 5b eb 09 89 df eb 05 bf ea ff ff ff 83 c4 18 89 f8 5b 5e 5f 5d c3 c1 ea 16 53 31 db c1 e2 02 03 50 24 74 17 <83> 3a 00 89 d3 74 10 8b 02 e8 f0 d3 ff ff 90 84 c0 78 04 0f 0b 
Feb 12 00:20:00 italy kernel: [   31.084039] EIP: [<c011795c>] huge_pte_alloc+0xe/0x29 SS:ESP 0068:edcc1f74
Feb 12 00:20:00 italy kernel: [   31.089319] ---[ end trace d5c34e1f0dc40238 ]---
Feb 12 00:20:00 italy kernel: [   32.154721] Linux agpgart interface v0.103
Feb 12 00:20:00 italy kernel: [   32.193628] agpgart: Detected VIA KT266/KY266x/KT333 chipset
Feb 12 00:20:00 italy kernel: [   32.204473] agpgart: AGP aperture is 128M @ 0xd0000000
Feb 12 00:20:00 italy kernel: [   32.215923] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Feb 12 00:20:00 italy kernel: [   32.265161] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Feb 12 00:20:00 italy kernel: [   32.761255] Linux video capture interface: v2.00
Feb 12 00:20:00 italy kernel: [   32.969971] bttv: driver version 0.9.17 loaded
Feb 12 00:20:00 italy kernel: [   32.970033] bttv: using 8 buffers with 2080k (520 pages) each for capture
Feb 12 00:20:00 italy kernel: [   32.970174] bttv: Bt8xx card found (0).
Feb 12 00:20:00 italy kernel: [   32.970257] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 12 00:20:00 italy kernel: [   32.970393] bttv0: Bt878 (rev 17) at 0000:00:0a.0, irq: 11, latency: 32, mmio: 0xea000000
Feb 12 00:20:00 italy kernel: [   32.974405] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
Feb 12 00:20:00 italy kernel: [   32.974470] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
Feb 12 00:20:00 italy kernel: [   32.974569] bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
Feb 12 00:20:00 italy kernel: [   32.977108] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
Feb 12 00:20:00 italy kernel: [   33.004961] tveeprom 0-0050: Hauppauge model 44801, rev D182, serial# 2772248
Feb 12 00:20:00 italy kernel: [   33.005018] tveeprom 0-0050: tuner model is LG TAPC H791F (idx 82, type 39)
Feb 12 00:20:00 italy kernel: [   33.005073] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
Feb 12 00:20:00 italy kernel: [   33.005125] tveeprom 0-0050: audio processor is None (idx 0)
Feb 12 00:20:00 italy kernel: [   33.005175] tveeprom 0-0050: has no radio
Feb 12 00:20:00 italy kernel: [   33.005221] bttv0: Hauppauge eeprom indicates model#44801
Feb 12 00:20:00 italy kernel: [   33.005271] bttv0: tuner type=39
Feb 12 00:20:00 italy kernel: [   33.005319] bttv0: i2c: checking for MSP34xx @ 0x80... not found
Feb 12 00:20:00 italy kernel: [   33.617134] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
Feb 12 00:20:00 italy kernel: [   33.621068] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
Feb 12 00:20:00 italy kernel: [   33.688764] input: Power Button (FF) as /class/input/input1
Feb 12 00:20:00 italy kernel: [   33.717266] ACPI: Power Button (FF) [PWRF]
Feb 12 00:20:00 italy kernel: [   33.717504] input: Power Button (CM) as /class/input/input2
Feb 12 00:20:00 italy kernel: [   33.747710] ACPI: Power Button (CM) [PWRB]
Feb 12 00:20:00 italy kernel: [   33.747938] input: Sleep Button (CM) as /class/input/input3
Feb 12 00:20:00 italy kernel: [   33.776208] ACPI: Sleep Button (CM) [SLPB]
Feb 12 00:20:00 italy kernel: [   34.184478] tuner' 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
Feb 12 00:20:00 italy kernel: [   34.736954] tuner-simple 0-0061: creating new instance
Feb 12 00:20:00 italy kernel: [   34.737020] tuner-simple 0-0061: type set to 39 (LG NTSC (newer TAPC series))
Feb 12 00:20:00 italy kernel: [   34.746192] bttv0: registered device video0
Feb 12 00:20:00 italy kernel: [   34.746282] bttv0: registered device vbi0
Feb 12 00:20:00 italy kernel: [   34.746352] bttv0: PLL: 28636363 => 35468950 .. ok
Feb 12 00:20:00 italy kernel: [   35.379934] input: PC Speaker as /class/input/input4
Feb 12 00:20:00 italy kernel: [   35.944131] hub 4-0:1.0: unable to enumerate USB device on port 1
Feb 12 00:20:00 italy kernel: [   36.245847] NET: Registered protocol family 23
Feb 12 00:20:00 italy kernel: [   36.331351] parport_pc 00:0a: reported by Plug and Play ACPI
Feb 12 00:20:00 italy kernel: [   36.331480] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
Feb 12 00:20:00 italy kernel: [   36.540150] usb 4-1: new high speed USB device using ehci_hcd and address 4
Feb 12 00:20:00 italy kernel: [   36.596267] hub 4-0:1.0: unable to enumerate USB device on port 1
Feb 12 00:20:00 italy kernel: [   36.657328] input: ImPS/2 Generic Wheel Mouse as /class/input/input5
Feb 12 00:20:00 italy kernel: [   36.868863] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 12 00:20:00 italy kernel: [   37.052123] usb 1-1: new full speed USB device using ohci_hcd and address 2
Feb 12 00:20:00 italy kernel: [   37.277218] usb 1-1: not running at top speed; connect to a high speed hub
Feb 12 00:20:00 italy kernel: [   37.389420] usb 1-1: configuration #1 chosen from 1 choice
Feb 12 00:20:00 italy kernel: [   37.393568] scsi1 : SCSI emulation for USB Mass Storage devices
Feb 12 00:20:00 italy kernel: [   37.394035] usb 1-1: New USB device found, idVendor=07ab, idProduct=fcfe
Feb 12 00:20:00 italy kernel: [   37.394740] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb 12 00:20:00 italy kernel: [   37.394794] usb 1-1: Product: Freecom Hard Drive
Feb 12 00:20:00 italy kernel: [   37.394842] usb 1-1: Manufacturer: Freecom
Feb 12 00:20:00 italy kernel: [   37.394888] usb 1-1: SerialNumber: 01860D8900920
Feb 12 00:20:00 italy kernel: [   37.394963] usb-storage: device found at 2
Feb 12 00:20:00 italy kernel: [   37.395010] usb-storage: waiting for device to settle before scanning
Feb 12 00:20:00 italy kernel: [   37.961286] ACPI: PCI Interrupt 0000:00:0a.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 12 00:20:00 italy kernel: [   37.962114] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
Feb 12 00:20:00 italy kernel: [   39.201071] hda: UDMA/133 mode selected
Feb 12 00:20:00 italy kernel: [   39.235048] hdd: UDMA/66 mode selected
Feb 12 00:20:00 italy kernel: [   39.870170] EXT3 FS on dm-1, internal journal
Feb 12 00:20:00 italy kernel: [   40.283330] loop: module loaded
Feb 12 00:20:00 italy kernel: [   40.379109] [drm] Initialized drm 1.1.0 20060810
Feb 12 00:20:00 italy kernel: [   40.422308] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 12 00:20:00 italy kernel: [   40.422602] [drm] Initialized radeon 1.29.0 20080528 on minor 0
Feb 12 00:20:00 italy kernel: [   42.395672] usb-storage: device scan complete
Feb 12 00:20:00 italy kernel: [   42.431639] scsi 1:0:0:0: Direct-Access     SAMSUNG  HD400LD          WQ10 PQ: 0 ANSI: 0
Feb 12 00:20:00 italy kernel: [   42.461566] sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Feb 12 00:20:00 italy kernel: [   42.475577] sd 1:0:0:0: [sdb] Write Protect is off
Feb 12 00:20:00 italy kernel: [   42.475641] sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 12 00:20:00 italy kernel: [   42.475691] sd 1:0:0:0: [sdb] Assuming drive cache: write through
Feb 12 00:20:00 italy kernel: [   42.486607] sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Feb 12 00:20:00 italy kernel: [   42.500608] sd 1:0:0:0: [sdb] Write Protect is off
Feb 12 00:20:00 italy kernel: [   42.500675] sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 12 00:20:00 italy kernel: [   42.500725] sd 1:0:0:0: [sdb] Assuming drive cache: write through
Feb 12 00:20:00 italy kernel: [   42.500788]  sdb:<6>kjournald starting.  Commit interval 5 seconds
Feb 12 00:20:00 italy kernel: [   45.772451] EXT3 FS on hda1, internal journal
Feb 12 00:20:00 italy kernel: [   45.772451] EXT3-fs: mounted filesystem with ordered data mode.
Feb 12 00:20:00 italy kernel: [   45.822103] kjournald starting.  Commit interval 5 seconds
Feb 12 00:20:00 italy kernel: [   45.835143] EXT3 FS on dm-3, internal journal
Feb 12 00:20:00 italy kernel: [   45.835143] EXT3-fs: mounted filesystem with ordered data mode.
Feb 12 00:20:00 italy kernel: [   45.875245] kjournald starting.  Commit interval 5 seconds
Feb 12 00:20:00 italy kernel: [   45.875330] EXT3-fs: mounted filesystem with ordered data mode.
Feb 12 00:20:00 italy kernel: [   45.912555] Adding 2330616k swap on /dev/mapper/italy-swap_1.  Priority:-1 extents:1 across:2330616k
Feb 12 00:20:00 italy kernel: [   47.550407] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
Feb 13 23:01:45 italy kernel: klogd 1.5.0#5, log source = /proc/kmsg started.
Feb 13 23:01:45 italy kernel: [    0.000000] Initializing cgroup subsys cpuset
Feb 13 23:01:45 italy kernel: [    0.000000] Initializing cgroup subsys cpu
Feb 13 23:01:45 italy kernel: [    0.000000] Linux version 2.6.26-1-686 (Debian 2.6.26-13) (waldi@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-24)) #1 SMP Sat Jan 10 18:29:31 UTC 2009
Feb 13 23:01:45 italy kernel: [    0.000000] BIOS-provided physical RAM map:
Feb 13 23:01:45 italy kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Feb 13 23:01:45 italy kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Feb 13 23:01:45 italy kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Feb 13 23:01:45 italy kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000002fff0000 (usable)
Feb 13 23:01:45 italy kernel: [    0.000000]  BIOS-e820: 000000002fff0000 - 000000002fff3000 (ACPI NVS)
Feb 13 23:01:45 italy kernel: [    0.000000]  BIOS-e820: 000000002fff3000 - 0000000030000000 (ACPI data)
Feb 13 23:01:45 italy kernel: [    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Feb 13 23:01:45 italy kernel: [    0.000000] 0MB HIGHMEM available.
Feb 13 23:01:45 italy kernel: [    0.000000] 767MB LOWMEM available.
Feb 13 23:01:45 italy kernel: [    0.000000] Entering add_active_range(0, 0, 196592) 0 entries of 256 used
Feb 13 23:01:45 italy kernel: [    0.000000] Zone PFN ranges:
Feb 13 23:01:45 italy kernel: [    0.000000]   DMA             0 ->     4096
Feb 13 23:01:45 italy kernel: [    0.000000]   Normal       4096 ->   196592
Feb 13 23:01:45 italy kernel: [    0.000000]   HighMem    196592 ->   196592
Feb 13 23:01:45 italy kernel: [    0.000000] Movable zone start PFN for each node
Feb 13 23:01:45 italy kernel: [    0.000000] early_node_map[1] active PFN ranges
Feb 13 23:01:45 italy kernel: [    0.000000]     0:        0 ->   196592
Feb 13 23:01:45 italy kernel: [    0.000000] On node 0 totalpages: 196592
Feb 13 23:01:45 italy kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Feb 13 23:01:45 italy kernel: [    0.000000]   DMA zone: 0 pages reserved
Feb 13 23:01:45 italy kernel: [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
Feb 13 23:01:45 italy kernel: [    0.000000]   Normal zone: 1504 pages used for memmap
Feb 13 23:01:45 italy kernel: [    0.000000]   Normal zone: 190992 pages, LIFO batch:31
Feb 13 23:01:45 italy kernel: [    0.000000]   HighMem zone: 0 pages used for memmap
Feb 13 23:01:45 italy kernel: [    0.000000]   Movable zone: 0 pages used for memmap
Feb 13 23:01:45 italy kernel: [    0.000000] DMI 2.2 present.
Feb 13 23:01:45 italy kernel: [    0.000000] ACPI: RSDP 000F62E0, 0014 (r0 VIA694)
Feb 13 23:01:45 italy kernel: [    0.000000] ACPI: RSDT 2FFF3000, 0028 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
Feb 13 23:01:45 italy kernel: [    0.000000] ACPI: FACP 2FFF3040, 0074 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
Feb 13 23:01:45 italy kernel: [    0.000000] ACPI: DSDT 2FFF30C0, 3316 (r1 VIA694 AWRDACPI     1000 MSFT  100000E)
Feb 13 23:01:45 italy kernel: [    0.000000] ACPI: FACS 2FFF0000, 0040
Feb 13 23:01:45 italy kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Feb 13 23:01:45 italy kernel: [    0.000000] Allocating PCI resources starting at 40000000 (gap: 30000000:cfff0000)
Feb 13 23:01:45 italy kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Feb 13 23:01:45 italy kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
Feb 13 23:01:45 italy kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Feb 13 23:01:45 italy kernel: [    0.000000] SMP: Allowing 0 CPUs, 0 hotplug CPUs
Feb 13 23:01:45 italy kernel: [    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
Feb 13 23:01:45 italy kernel: [    0.000000] NR_CPUS: 8, nr_cpu_ids: 1
Feb 13 23:01:45 italy kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195056
Feb 13 23:01:45 italy kernel: [    0.000000] Kernel command line: root=/dev/mapper/italy-root ro 
Feb 13 23:01:45 italy kernel: [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
Feb 13 23:01:45 italy kernel: [    0.000000] mapped APIC to ffffb000 (0160f000)
Feb 13 23:01:45 italy kernel: [    0.000000] Enabling fast FPU save and restore... done.
Feb 13 23:01:45 italy kernel: [    0.000000] Initializing CPU#0
Feb 13 23:01:45 italy kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
Feb 13 23:01:45 italy kernel: [    0.000000] Detected 930.689 MHz processor.
Feb 13 23:01:45 italy kernel: [    0.004000] Console: colour VGA+ 80x25
Feb 13 23:01:45 italy kernel: [    0.004000] console [tty0] enabled
Feb 13 23:01:45 italy kernel: [    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Feb 13 23:01:45 italy kernel: [    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Feb 13 23:01:45 italy kernel: [    0.004000] Memory: 768324k/786368k available (1769k kernel code, 17452k reserved, 752k data, 244k init, 0k highmem)
Feb 13 23:01:45 italy kernel: [    0.004000] virtual kernel memory layout:
Feb 13 23:01:45 italy kernel: [    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
Feb 13 23:01:45 italy kernel: [    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Feb 13 23:01:45 italy kernel: [    0.004000]     vmalloc : 0xf0800000 - 0xff7fe000   ( 239 MB)
Feb 13 23:01:45 italy kernel: [    0.004000]     lowmem  : 0xc0000000 - 0xefff0000   ( 767 MB)
Feb 13 23:01:45 italy kernel: [    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
Feb 13 23:01:45 italy kernel: [    0.004000]       .data : 0xc02ba4ab - 0xc0376620   ( 752 kB)
Feb 13 23:01:45 italy kernel: [    0.004000]       .text : 0xc0100000 - 0xc02ba4ab   (1769 kB)
Feb 13 23:01:45 italy kernel: [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Feb 13 23:01:45 italy kernel: [    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
Feb 13 23:01:45 italy kernel: [    0.084276] Calibrating delay using timer specific routine.. 1863.87 BogoMIPS (lpj=3727756)
Feb 13 23:01:45 italy kernel: [    0.084444] Security Framework initialized
Feb 13 23:01:45 italy kernel: [    0.084501] SELinux:  Disabled at boot.
Feb 13 23:01:45 italy kernel: [    0.084551] Capability LSM initialized
Feb 13 23:01:45 italy kernel: [    0.084628] Mount-cache hash table entries: 512
Feb 13 23:01:45 italy kernel: [    0.084980] Initializing cgroup subsys ns
Feb 13 23:01:45 italy kernel: [    0.085032] Initializing cgroup subsys cpuacct
Feb 13 23:01:45 italy kernel: [    0.085081] Initializing cgroup subsys devices
Feb 13 23:01:45 italy kernel: [    0.085163] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Feb 13 23:01:45 italy kernel: [    0.085218] CPU: L2 Cache: 256K (64 bytes/line)
Feb 13 23:01:45 italy kernel: [    0.085269] Intel machine check architecture supported.
Feb 13 23:01:45 italy kernel: [    0.085320] Intel machine check reporting enabled on CPU#0.
Feb 13 23:01:45 italy kernel: [    0.085393] Checking 'hlt' instruction... OK.
Feb 13 23:01:45 italy kernel: [    0.100368] SMP alternatives: switching to UP code
Feb 13 23:01:45 italy kernel: [    0.114510] Freeing SMP alternatives: 16k freed
Feb 13 23:01:45 italy kernel: [    0.114568] ACPI: Core revision 20080321
Feb 13 23:01:45 italy kernel: [    0.123967] ACPI: setting ELCR to 0200 (from 0e00)
Feb 13 23:01:45 italy kernel: [    0.128008] weird, boot CPU (#0) not listedby the BIOS.
Feb 13 23:01:45 italy kernel: [    0.128008] SMP motherboard not detected.
Feb 13 23:01:45 italy kernel: [    0.128008] Local APIC not detected. Using dummy APIC emulation.
Feb 13 23:01:45 italy kernel: [    0.128008] SMP disabled
Feb 13 23:01:45 italy kernel: [    0.128008] Brought up 1 CPUs
Feb 13 23:01:45 italy kernel: [    0.128008] Total of 1 processors activated (1863.87 BogoMIPS).
Feb 13 23:01:45 italy kernel: [    0.128008] CPU0 attaching sched-domain:
Feb 13 23:01:45 italy kernel: [    0.128008]  domain 0: span 0
Feb 13 23:01:45 italy kernel: [    0.128008]   groups: 0
Feb 13 23:01:45 italy kernel: [    0.128008] net_namespace: 660 bytes
Feb 13 23:01:45 italy kernel: [    0.128008] Booting paravirtualized kernel on bare hardware
Feb 13 23:01:45 italy kernel: [    0.128577] NET: Registered protocol family 16
Feb 13 23:01:45 italy kernel: [    0.129149] ACPI: bus type pci registered
Feb 13 23:01:45 italy kernel: [    0.131710] PCI: PCI BIOS revision 2.10 entry at 0xfb3e0, last bus=1
Feb 13 23:01:45 italy kernel: [    0.131764] PCI: Using configuration type 1 for base access
Feb 13 23:01:45 italy kernel: [    0.131835] Setting up standard PCI resources
Feb 13 23:01:45 italy kernel: [    0.137990] ACPI: EC: Look up EC in DSDT
Feb 13 23:01:45 italy kernel: [    0.146350] ACPI: Interpreter enabled
Feb 13 23:01:45 italy kernel: [    0.146408] ACPI: (supports S0 S1 S4 S5)
Feb 13 23:01:45 italy kernel: [    0.146595] ACPI: Using PIC for interrupt routing
Feb 13 23:01:45 italy kernel: [    0.155403] ACPI: PCI Root Bridge [PCI0] (0000:00)
Feb 13 23:01:45 italy kernel: [    0.156548] pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
Feb 13 23:01:45 italy kernel: [    0.156606] pci 0000:00:11.0: quirk: region 5000-500f claimed by vt8235 SMB
Feb 13 23:01:45 italy kernel: [    0.156924] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb 13 23:01:45 italy kernel: [    0.201087] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Feb 13 23:01:45 italy kernel: [    0.201851] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Feb 13 23:01:45 italy kernel: [    0.202612] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Feb 13 23:01:45 italy kernel: [    0.203369] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Feb 13 23:01:45 italy kernel: [    0.204134] Linux Plug and Play Support v0.97 (c) Adam Belay
Feb 13 23:01:45 italy kernel: [    0.204259] pnp: PnP ACPI init
Feb 13 23:01:45 italy kernel: [    0.204320] ACPI: bus type pnp registered
Feb 13 23:01:45 italy kernel: [    0.211068] pnp: PnP ACPI: found 13 devices
Feb 13 23:01:45 italy kernel: [    0.211125] ACPI: ACPI bus type pnp unregistered
Feb 13 23:01:45 italy kernel: [    0.211177] PnPBIOS: Disabled by ACPI PNP
Feb 13 23:01:45 italy kernel: [    0.211892] PCI: Using ACPI for IRQ routing
Feb 13 23:01:45 italy kernel: [    0.212444] ACPI: RTC can wake from S4
Feb 13 23:01:45 italy kernel: [    0.212556] system 00:00: iomem range 0xcd000-0xcffff has been reserved
Feb 13 23:01:45 italy kernel: [    0.212612] system 00:00: iomem range 0xf0000-0xf7fff could not be reserved
Feb 13 23:01:45 italy kernel: [    0.212667] system 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Feb 13 23:01:45 italy kernel: [    0.212722] system 00:00: iomem range 0xfc000-0xfffff could not be reserved
Feb 13 23:01:45 italy kernel: [    0.212776] system 00:00: iomem range 0x2fff0000-0x2fffffff could not be reserved
Feb 13 23:01:45 italy kernel: [    0.212838] system 00:00: iomem range 0xffff0000-0xffffffff could not be reserved
Feb 13 23:01:45 italy kernel: [    0.212900] system 00:00: iomem range 0x0-0x9ffff could not be reserved
Feb 13 23:01:45 italy kernel: [    0.212953] system 00:00: iomem range 0x100000-0x2ffeffff could not be reserved
Feb 13 23:01:45 italy kernel: [    0.213014] system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
Feb 13 23:01:45 italy kernel: [    0.213069] system 00:00: iomem range 0xfff80000-0xfffeffff has been reserved
Feb 13 23:01:45 italy kernel: [    0.213136] system 00:02: ioport range 0x4000-0x407f has been reserved
Feb 13 23:01:45 italy kernel: [    0.213190] system 00:02: ioport range 0x5000-0x500f has been reserved
Feb 13 23:01:45 italy kernel: [    0.213264] system 00:03: ioport range 0x4d0-0x4d1 has been reserved
Feb 13 23:01:45 italy kernel: [    0.213318] system 00:03: ioport range 0x800-0x805 has been reserved
Feb 13 23:01:45 italy kernel: [    0.213371] system 00:03: ioport range 0x290-0x297 has been reserved
Feb 13 23:01:45 italy kernel: [    0.244409] PCI: Bridge: 0000:00:01.0
Feb 13 23:01:45 italy kernel: [    0.244459]   IO window: c000-cfff
Feb 13 23:01:45 italy kernel: [    0.244507]   MEM window: 0xe8000000-0xe9ffffff
Feb 13 23:01:45 italy kernel: [    0.244557]   PREFETCH window: 0x00000000d8000000-0x00000000e7ffffff
Feb 13 23:01:45 italy kernel: [    0.244630] PCI: Setting latency timer of device 0000:00:01.0 to 64
Feb 13 23:01:45 italy kernel: [    0.244677] NET: Registered protocol family 2
Feb 13 23:01:45 italy kernel: [    0.244933] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Feb 13 23:01:45 italy kernel: [    0.245778] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Feb 13 23:01:45 italy kernel: [    0.250731] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Feb 13 23:01:45 italy kernel: [    0.253316] TCP: Hash tables configured (established 131072 bind 65536)
Feb 13 23:01:45 italy kernel: [    0.253375] TCP reno registered
Feb 13 23:01:45 italy kernel: [    0.253706] NET: Registered protocol family 1
Feb 13 23:01:45 italy kernel: [    0.254043] checking if image is initramfs...<7>Switched to high resolution mode on CPU 0
Feb 13 23:01:45 italy kernel: [    0.829745]  it is
Feb 13 23:01:45 italy kernel: [    1.516719] Freeing initrd memory: 7199k freed
Feb 13 23:01:45 italy kernel: [    1.518364] audit: initializing netlink socket (disabled)
Feb 13 23:01:45 italy kernel: [    1.518448] type=2000 audit(1234566054.516:1): initialized
Feb 13 23:01:45 italy kernel: [    1.518777] Total HugeTLB memory allocated, 0
Feb 13 23:01:45 italy kernel: [    1.518991] VFS: Disk quotas dquot_6.5.1
Feb 13 23:01:45 italy kernel: [    1.519104] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Feb 13 23:01:45 italy kernel: [    1.519234] msgmni has been set to 1515
Feb 13 23:01:45 italy kernel: [    1.519512] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Feb 13 23:01:45 italy kernel: [    1.519577] io scheduler noop registered
Feb 13 23:01:45 italy kernel: [    1.519624] io scheduler anticipatory registered
Feb 13 23:01:45 italy kernel: [    1.519671] io scheduler deadline registered
Feb 13 23:01:45 italy kernel: [    1.519731] io scheduler cfq registered (default)
Feb 13 23:01:45 italy kernel: [    1.519800] PCI: VIA PCI bridge detected.Disabling DAC.
Feb 13 23:01:45 italy kernel: [    1.520069] pci 0000:01:00.0: Boot video device
Feb 13 23:01:45 italy kernel: [    1.520889] isapnp: Scanning for PnP cards...
Feb 13 23:01:45 italy kernel: [    1.874916] isapnp: No Plug & Play device found
Feb 13 23:01:45 italy kernel: [    1.882086] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Feb 13 23:01:45 italy kernel: [    1.882352] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 13 23:01:45 italy kernel: [    1.882563] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 13 23:01:45 italy kernel: [    1.883291] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 13 23:01:45 italy kernel: [    1.883614] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 13 23:01:45 italy kernel: [    1.887330] brd: module loaded
Feb 13 23:01:45 italy kernel: [    1.887611] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Feb 13 23:01:45 italy kernel: [    1.888160] serio: i8042 KBD port at 0x60,0x64 irq 1
Feb 13 23:01:45 italy kernel: [    1.888218] serio: i8042 AUX port at 0x60,0x64 irq 12
Feb 13 23:01:45 italy kernel: [    1.888626] mice: PS/2 mouse device common for all mice
Feb 13 23:01:45 italy kernel: [    1.888983] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
Feb 13 23:01:45 italy kernel: [    1.889060] rtc0: alarms up to one year, y3k
Feb 13 23:01:45 italy kernel: [    1.889187] cpuidle: using governor ladder
Feb 13 23:01:45 italy kernel: [    1.889236] cpuidle: using governor menu
Feb 13 23:01:45 italy kernel: [    1.889289] No iBFT detected.
Feb 13 23:01:45 italy kernel: [    1.890385] TCP cubic registered
Feb 13 23:01:45 italy kernel: [    1.890435] NET: Registered protocol family 17
Feb 13 23:01:45 italy kernel: [    1.890493] Using IPI No-Shortcut mode
Feb 13 23:01:45 italy kernel: [    1.890829] registered taskstats version 1
Feb 13 23:01:45 italy kernel: [    1.891239] rtc_cmos 00:05: setting system clock to 2009-02-13 23:00:55 UTC (1234566055)
Feb 13 23:01:45 italy kernel: [    1.891884] Freeing unused kernel memory: 244k freed
Feb 13 23:01:45 italy kernel: [    1.911484] input: AT Translated Set 2 keyboard as /class/input/input0
Feb 13 23:01:45 italy kernel: [    2.144336] ACPI: PNP0C0B:00 is registered as cooling_device0
Feb 13 23:01:45 italy kernel: [    2.144413] ACPI: Fan [FAN] (on)
Feb 13 23:01:45 italy kernel: [    2.158408] ACPI: CPU0 (power states: C1[C1] C2[C2])
Feb 13 23:01:45 italy kernel: [    2.158668] ACPI: ACPI0007:00 is registered as cooling_device1
Feb 13 23:01:45 italy kernel: [    2.162817] ACPI: LNXTHERM:01 is registered as thermal_zone0
Feb 13 23:01:45 italy kernel: [    2.163144] ACPI: Thermal Zone [THRM] (40 C)
Feb 13 23:01:45 italy kernel: [    3.078717] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
Feb 13 23:01:45 italy kernel: [    3.078818] 8139cp 0000:00:0b.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
Feb 13 23:01:45 italy kernel: [    3.078880] 8139cp 0000:00:0b.0: Try the "8139too" driver instead.
Feb 13 23:01:45 italy kernel: [    3.110534] 8139too Fast Ethernet driver 0.9.28
Feb 13 23:01:45 italy kernel: [    3.111489] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
Feb 13 23:01:45 italy kernel: [    3.111543] PCI: setting IRQ 11 as level-triggered
Feb 13 23:01:45 italy kernel: [    3.111551] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 13 23:01:45 italy kernel: [    3.112597] eth0: RealTek RTL8139 at 0xd400, 00:02:44:14:3f:2c, IRQ 11
Feb 13 23:01:45 italy kernel: [    3.112651] eth0:  Identified 8139 chip type 'RTL-8139B'
Feb 13 23:01:45 italy kernel: [    3.431769] usbcore: registered new interface driver usbfs
Feb 13 23:01:45 italy kernel: [    3.431897] usbcore: registered new interface driver hub
Feb 13 23:01:45 italy kernel: [    3.432045] usbcore: registered new device driver usb
Feb 13 23:01:45 italy kernel: [    3.454152] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Feb 13 23:01:45 italy kernel: [    3.455031] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
Feb 13 23:01:45 italy kernel: [    3.455093] PCI: setting IRQ 10 as level-triggered
Feb 13 23:01:45 italy kernel: [    3.455101] ACPI: PCI Interrupt 0000:00:0c.0[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 13 23:01:45 italy kernel: [    3.455247] ohci_hcd 0000:00:0c.0: OHCI Host Controller
Feb 13 23:01:45 italy kernel: [    3.455564] ohci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 1
Feb 13 23:01:45 italy kernel: [    3.455654] ohci_hcd 0000:00:0c.0: irq 10, io mem 0xea003000
Feb 13 23:01:45 italy kernel: [    3.513789] usb usb1: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    3.513919] hub 1-0:1.0: USB hub found
Feb 13 23:01:45 italy kernel: [    3.513990] hub 1-0:1.0: 2 ports detected
Feb 13 23:01:45 italy kernel: [    3.616422] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Feb 13 23:01:45 italy kernel: [    3.616489] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 13 23:01:45 italy kernel: [    3.616549] usb usb1: Product: OHCI Host Controller
Feb 13 23:01:45 italy kernel: [    3.616597] usb usb1: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 13 23:01:45 italy kernel: [    3.616647] usb usb1: SerialNumber: 0000:00:0c.0
Feb 13 23:01:45 italy kernel: [    3.617595] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
Feb 13 23:01:45 italy kernel: [    3.617649] ACPI: PCI Interrupt 0000:00:0c.1[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 13 23:01:45 italy kernel: [    3.617795] ohci_hcd 0000:00:0c.1: OHCI Host Controller
Feb 13 23:01:45 italy kernel: [    3.617908] ohci_hcd 0000:00:0c.1: new USB bus registered, assigned bus number 2
Feb 13 23:01:45 italy kernel: [    3.617998] ohci_hcd 0000:00:0c.1: irq 11, io mem 0xea004000
Feb 13 23:01:45 italy kernel: [    3.674307] usb usb2: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    3.674436] hub 2-0:1.0: USB hub found
Feb 13 23:01:45 italy kernel: [    3.674506] hub 2-0:1.0: 2 ports detected
Feb 13 23:01:45 italy kernel: [    3.776387] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Feb 13 23:01:45 italy kernel: [    3.776454] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 13 23:01:45 italy kernel: [    3.776514] usb usb2: Product: OHCI Host Controller
Feb 13 23:01:45 italy kernel: [    3.776562] usb usb2: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 13 23:01:45 italy kernel: [    3.776612] usb usb2: SerialNumber: 0000:00:0c.1
Feb 13 23:01:45 italy kernel: [    3.776717] ACPI: PCI Interrupt 0000:00:0c.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 13 23:01:45 italy kernel: [    3.776866] ohci_hcd 0000:00:0c.2: OHCI Host Controller
Feb 13 23:01:45 italy kernel: [    3.776966] ohci_hcd 0000:00:0c.2: new USB bus registered, assigned bus number 3
Feb 13 23:01:45 italy kernel: [    3.777053] ohci_hcd 0000:00:0c.2: irq 11, io mem 0xea005000
Feb 13 23:01:45 italy kernel: [    3.834289] usb usb3: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    3.834421] hub 3-0:1.0: USB hub found
Feb 13 23:01:45 italy kernel: [    3.834495] hub 3-0:1.0: 2 ports detected
Feb 13 23:01:45 italy kernel: [    3.920084] usb 1-1: new full speed USB device using ohci_hcd and address 2
Feb 13 23:01:45 italy kernel: [    3.936333] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Feb 13 23:01:45 italy kernel: [    3.936400] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 13 23:01:45 italy kernel: [    3.936460] usb usb3: Product: OHCI Host Controller
Feb 13 23:01:45 italy kernel: [    3.936509] usb usb3: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 13 23:01:45 italy kernel: [    3.936559] usb usb3: SerialNumber: 0000:00:0c.2
Feb 13 23:01:45 italy kernel: [    3.937621] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
Feb 13 23:01:45 italy kernel: [    3.937676] ACPI: PCI Interrupt 0000:00:0c.3[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 13 23:01:45 italy kernel: [    3.937824] ehci_hcd 0000:00:0c.3: EHCI Host Controller
Feb 13 23:01:45 italy kernel: [    3.937942] ehci_hcd 0000:00:0c.3: new USB bus registered, assigned bus number 4
Feb 13 23:01:45 italy kernel: [    3.938223] USB Universal Host Controller Interface driver v3.0
Feb 13 23:01:45 italy kernel: [    3.963145] ehci_hcd 0000:00:0c.3: debug port 1
Feb 13 23:01:45 italy kernel: [    3.963231] ehci_hcd 0000:00:0c.3: irq 10, io mem 0xea006000
Feb 13 23:01:45 italy kernel: [    4.079155] Uniform Multi-Platform E-IDE driver
Feb 13 23:01:45 italy kernel: [    4.079221] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb 13 23:01:45 italy kernel: [    4.120098] ehci_hcd 0000:00:0c.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 13 23:01:45 italy kernel: [    4.120372] usb usb4: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    4.120494] hub 4-0:1.0: USB hub found
Feb 13 23:01:45 italy kernel: [    4.120565] hub 4-0:1.0: 6 ports detected
Feb 13 23:01:45 italy kernel: [    4.224323] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
Feb 13 23:01:45 italy kernel: [    4.224390] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 13 23:01:45 italy kernel: [    4.224450] usb usb4: Product: EHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.224498] usb usb4: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
Feb 13 23:01:45 italy kernel: [    4.224548] usb usb4: SerialNumber: 0000:00:0c.3
Feb 13 23:01:45 italy kernel: [    4.224743] ACPI: PCI Interrupt 0000:00:10.3[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 13 23:01:45 italy kernel: [    4.224893] ehci_hcd 0000:00:10.3: EHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.224997] ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
Feb 13 23:01:45 italy kernel: [    4.225135] ehci_hcd 0000:00:10.3: irq 11, io mem 0xea007000
Feb 13 23:01:45 italy kernel: [    4.236071] ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 13 23:01:45 italy kernel: [    4.236350] usb usb5: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    4.236475] hub 5-0:1.0: USB hub found
Feb 13 23:01:45 italy kernel: [    4.236541] hub 5-0:1.0: 6 ports detected
Feb 13 23:01:45 italy kernel: [    4.340365] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Feb 13 23:01:45 italy kernel: [    4.340431] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 13 23:01:45 italy kernel: [    4.340491] usb usb5: Product: EHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.340540] usb usb5: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
Feb 13 23:01:45 italy kernel: [    4.340590] usb usb5: SerialNumber: 0000:00:10.3
Feb 13 23:01:45 italy kernel: [    4.341684] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 13 23:01:45 italy kernel: [    4.341832] uhci_hcd 0000:00:10.0: UHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.341958] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
Feb 13 23:01:45 italy kernel: [    4.342052] uhci_hcd 0000:00:10.0: irq 10, io base 0x0000d800
Feb 13 23:01:45 italy kernel: [    4.342311] usb usb6: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    4.342430] hub 6-0:1.0: USB hub found
Feb 13 23:01:45 italy kernel: [    4.342495] hub 6-0:1.0: 2 ports detected
Feb 13 23:01:45 italy kernel: [    4.444392] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Feb 13 23:01:45 italy kernel: [    4.444460] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 13 23:01:45 italy kernel: [    4.444520] usb usb6: Product: UHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.444569] usb usb6: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 13 23:01:45 italy kernel: [    4.444619] usb usb6: SerialNumber: 0000:00:10.0
Feb 13 23:01:45 italy kernel: [    4.444772] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 13 23:01:45 italy kernel: [    4.444912] uhci_hcd 0000:00:10.1: UHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.445032] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 7
Feb 13 23:01:45 italy kernel: [    4.445129] uhci_hcd 0000:00:10.1: irq 10, io base 0x0000dc00
Feb 13 23:01:45 italy kernel: [    4.445393] usb usb7: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    4.445509] hub 7-0:1.0: USB hub found
Feb 13 23:01:45 italy kernel: [    4.445576] hub 7-0:1.0: 2 ports detected
Feb 13 23:01:45 italy kernel: [    4.516095] usb 1-1: device not accepting address 2, error -62
Feb 13 23:01:45 italy kernel: [    4.548356] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Feb 13 23:01:45 italy kernel: [    4.548423] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 13 23:01:45 italy kernel: [    4.548484] usb usb7: Product: UHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.548532] usb usb7: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 13 23:01:45 italy kernel: [    4.548582] usb usb7: SerialNumber: 0000:00:10.1
Feb 13 23:01:45 italy kernel: [    4.548727] ACPI: PCI Interrupt 0000:00:10.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 13 23:01:45 italy kernel: [    4.548868] uhci_hcd 0000:00:10.2: UHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.548976] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 8
Feb 13 23:01:45 italy kernel: [    4.549071] uhci_hcd 0000:00:10.2: irq 11, io base 0x0000e000
Feb 13 23:01:45 italy kernel: [    4.549342] usb usb8: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    4.549458] hub 8-0:1.0: USB hub found
Feb 13 23:01:45 italy kernel: [    4.549524] hub 8-0:1.0: 2 ports detected
Feb 13 23:01:45 italy kernel: [    4.572117] hub 1-0:1.0: unable to enumerate USB device on port 1
Feb 13 23:01:45 italy kernel: [    4.652398] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
Feb 13 23:01:45 italy kernel: [    4.652465] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 13 23:01:45 italy kernel: [    4.652525] usb usb8: Product: UHCI Host Controller
Feb 13 23:01:45 italy kernel: [    4.652573] usb usb8: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 13 23:01:45 italy kernel: [    4.652623] usb usb8: SerialNumber: 0000:00:10.2
Feb 13 23:01:45 italy kernel: [    4.657682] VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:11.1
Feb 13 23:01:45 italy kernel: [    4.657800] ACPI: PCI Interrupt 0000:00:11.1[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 13 23:01:45 italy kernel: [    4.657927] VIA_IDE 0000:00:11.1: VIA VLink IRQ fixup, from 255 to 10
Feb 13 23:01:45 italy kernel: [    4.658008] VP_IDE: not 100% native mode: will probe irqs later
Feb 13 23:01:45 italy kernel: [    4.658094] VP_IDE: VIA vt8235 (rev 00) IDE UDMA133 controller on pci0000:00:11.1
Feb 13 23:01:45 italy kernel: [    4.658169]     ide0: BM-DMA at 0xe400-0xe407
Feb 13 23:01:45 italy kernel: [    4.658227]     ide1: BM-DMA at 0xe408-0xe40f
Feb 13 23:01:45 italy kernel: [    4.658277] Probing IDE interface ide0...
Feb 13 23:01:45 italy kernel: [    5.068077] usb 4-1: new high speed USB device using ehci_hcd and address 2
Feb 13 23:01:45 italy kernel: [    5.068374] Marking TSC unstable due to: TSC halts in idle.
Feb 13 23:01:45 italy kernel: [    5.072290] hda: Maxtor 6B200P0, ATA DISK drive
Feb 13 23:01:45 italy kernel: [    5.124236] hub 4-0:1.0: unable to enumerate USB device on port 1
Feb 13 23:01:45 italy kernel: [    5.376047] usb 4-5: new high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [    5.510708] usb 4-5: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    5.512140] usb 4-5: New USB device found, idVendor=059f, idProduct=0951
Feb 13 23:01:45 italy kernel: [    5.512206] usb 4-5: New USB device strings: Mfr=10, Product=11, SerialNumber=5
Feb 13 23:01:45 italy kernel: [    5.512266] usb 4-5: Product: LaCie Hard Drive USB
Feb 13 23:01:45 italy kernel: [    5.512329] usb 4-5: Manufacturer: LaCie SA
Feb 13 23:01:45 italy kernel: [    5.512375] usb 4-5: SerialNumber: 031D703971FF
Feb 13 23:01:45 italy kernel: [    5.586282] SCSI subsystem initialized
Feb 13 23:01:45 italy kernel: [    5.595318] Initializing USB Mass Storage driver...
Feb 13 23:01:45 italy kernel: [    5.752138] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Feb 13 23:01:45 italy kernel: [    5.753674] hda: UDMA/133 mode selected
Feb 13 23:01:45 italy kernel: [    5.755877] Probing IDE interface ide1...
Feb 13 23:01:45 italy kernel: [    6.288272] scsi0 : SCSI emulation for USB Mass Storage devices
Feb 13 23:01:45 italy kernel: [    6.288930] usb-storage: device found at 3
Feb 13 23:01:45 italy kernel: [    6.288937] usb-storage: waiting for device to settle before scanning
Feb 13 23:01:45 italy kernel: [    6.416103] usbcore: registered new interface driver usb-storage
Feb 13 23:01:45 italy kernel: [    6.416162] USB Mass Storage support registered.
Feb 13 23:01:45 italy kernel: [    6.720047] usb 1-1: new full speed USB device using ohci_hcd and address 4
Feb 13 23:01:45 italy kernel: [    6.900142] hdd: SONY DVD RW DW-D22A, ATAPI CD/DVD-ROM drive
Feb 13 23:01:45 italy kernel: [    6.945717] usb 1-1: not running at top speed; connect to a high speed hub
Feb 13 23:01:45 italy kernel: [    6.956146] hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Feb 13 23:01:45 italy kernel: [    6.956433] hdd: UDMA/66 mode selected
Feb 13 23:01:45 italy kernel: [    6.956777] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb 13 23:01:45 italy kernel: [    6.979062] ide1 at 0x170-0x177,0x376 on irq 15
Feb 13 23:01:45 italy kernel: [    6.984950] No dock devices found.
Feb 13 23:01:45 italy kernel: [    7.004737] libata version 3.00 loaded.
Feb 13 23:01:45 italy kernel: [    7.058049] usb 1-1: configuration #1 chosen from 1 choice
Feb 13 23:01:45 italy kernel: [    7.062152] scsi1 : SCSI emulation for USB Mass Storage devices
Feb 13 23:01:45 italy kernel: [    7.062590] usb 1-1: New USB device found, idVendor=07ab, idProduct=fcfe
Feb 13 23:01:45 italy kernel: [    7.062646] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb 13 23:01:45 italy kernel: [    7.062700] usb 1-1: Product: Freecom Hard Drive
Feb 13 23:01:45 italy kernel: [    7.062747] usb 1-1: Manufacturer: Freecom
Feb 13 23:01:45 italy kernel: [    7.062793] usb 1-1: SerialNumber: 01860D8900920
Feb 13 23:01:45 italy kernel: [    7.062888] usb-storage: device found at 4
Feb 13 23:01:45 italy kernel: [    7.062893] usb-storage: waiting for device to settle before scanning
Feb 13 23:01:45 italy kernel: [    7.091316] hda: max request size: 512KiB
Feb 13 23:01:45 italy kernel: [    7.097413] hda: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63
Feb 13 23:01:45 italy kernel: [    7.103061] hda: cache flushes supported
Feb 13 23:01:45 italy kernel: [    7.103230]  hda: hda1 hda2 < hda5 >
Feb 13 23:01:45 italy kernel: [    7.126322] hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Feb 13 23:01:45 italy kernel: [    7.126563] Uniform CD-ROM driver Revision: 3.20
Feb 13 23:01:45 italy kernel: [    7.417735] device-mapper: uevent: version 1.0.3
Feb 13 23:01:45 italy kernel: [    7.420646] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Feb 13 23:01:45 italy kernel: [   11.288982] usb-storage: device scan complete
Feb 13 23:01:45 italy kernel: [   11.378129] scsi 0:0:0:0: Direct-Access     SAMSUNG  HD500LJ               PQ: 0 ANSI: 2 CCS
Feb 13 23:01:45 italy kernel: [   11.418006] Driver 'sd' needs updating - please use bus_type methods
Feb 13 23:01:45 italy kernel: [   11.419965] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Feb 13 23:01:45 italy kernel: [   11.421082] sd 0:0:0:0: [sda] Write Protect is off
Feb 13 23:01:45 italy kernel: [   11.421095] sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
Feb 13 23:01:45 italy kernel: [   11.421101] sd 0:0:0:0: [sda] Assuming drive cache: write through
Feb 13 23:01:45 italy kernel: [   11.423343] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Feb 13 23:01:45 italy kernel: [   11.424444] sd 0:0:0:0: [sda] Write Protect is off
Feb 13 23:01:45 italy kernel: [   11.424456] sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
Feb 13 23:01:45 italy kernel: [   11.424462] sd 0:0:0:0: [sda] Assuming drive cache: write through
Feb 13 23:01:45 italy kernel: [   11.424473]  sda: sda1
Feb 13 23:01:45 italy kernel: [   11.425993] sd 0:0:0:0: [sda] Attached SCSI disk
Feb 13 23:01:45 italy kernel: [   11.588053] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   11.876052] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   12.063326] usb-storage: device scan complete
Feb 13 23:01:45 italy kernel: [   12.099082] scsi 1:0:0:0: Direct-Access     SAMSUNG  HD400LD          WQ10 PQ: 0 ANSI: 0
Feb 13 23:01:45 italy kernel: [   12.110318] sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Feb 13 23:01:45 italy kernel: [   12.124067] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   12.124302] sd 1:0:0:0: [sdb] Write Protect is off
Feb 13 23:01:45 italy kernel: [   12.124311] sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 13 23:01:45 italy kernel: [   12.124318] sd 1:0:0:0: [sdb] Assuming drive cache: write through
Feb 13 23:01:45 italy kernel: [   12.135273] sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Feb 13 23:01:45 italy kernel: [   12.149017] sd 1:0:0:0: [sdb] Write Protect is off
Feb 13 23:01:45 italy kernel: [   12.149017] sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 13 23:01:45 italy kernel: [   12.149017] sd 1:0:0:0: [sdb] Assuming drive cache: write through
Feb 13 23:01:45 italy kernel: [   12.149017]  sdb:<6>usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   17.486424] PM: Starting manual resume from disk
Feb 13 23:01:45 italy kernel: [   17.530843] kjournald starting.  Commit interval 5 seconds
Feb 13 23:01:45 italy kernel: [   17.530953] EXT3-fs: mounted filesystem with ordered data mode.
Feb 13 23:01:45 italy kernel: [   19.780834]  sdb1
Feb 13 23:01:45 italy kernel: [   19.781173] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb 13 23:01:45 italy kernel: [   20.171487] udevd version 125 started
Feb 13 23:01:45 italy kernel: [   21.263358] hda: UDMA/133 mode selected
Feb 13 23:01:45 italy kernel: [   21.265063] hdd: UDMA/66 mode selected
Feb 13 23:01:45 italy kernel: [   21.588110] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   23.678182] Linux agpgart interface v0.103
Feb 13 23:01:45 italy kernel: [   23.712414] agpgart: Detected VIA KT266/KY266x/KT333 chipset
Feb 13 23:01:45 italy kernel: [   23.723181] agpgart: AGP aperture is 128M @ 0xd0000000
Feb 13 23:01:45 italy kernel: [   23.733180] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Feb 13 23:01:45 italy kernel: [   23.740776] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Feb 13 23:01:45 italy kernel: [   24.205032] Linux video capture interface: v2.00
Feb 13 23:01:45 italy kernel: [   24.397610] bttv: driver version 0.9.17 loaded
Feb 13 23:01:45 italy kernel: [   24.397672] bttv: using 8 buffers with 2080k (520 pages) each for capture
Feb 13 23:01:45 italy kernel: [   24.397814] bttv: Bt8xx card found (0).
Feb 13 23:01:45 italy kernel: [   24.397897] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 13 23:01:45 italy kernel: [   24.398032] bttv0: Bt878 (rev 17) at 0000:00:0a.0, irq: 11, latency: 32, mmio: 0xea000000
Feb 13 23:01:45 italy kernel: [   24.405935] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
Feb 13 23:01:45 italy kernel: [   24.406000] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
Feb 13 23:01:45 italy kernel: [   24.406096] bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
Feb 13 23:01:45 italy kernel: [   24.408589] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
Feb 13 23:01:45 italy kernel: [   24.436205] tveeprom 0-0050: Hauppauge model 44801, rev D182, serial# 2772248
Feb 13 23:01:45 italy kernel: [   24.436262] tveeprom 0-0050: tuner model is LG TAPC H791F (idx 82, type 39)
Feb 13 23:01:45 italy kernel: [   24.436318] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
Feb 13 23:01:45 italy kernel: [   24.436370] tveeprom 0-0050: audio processor is None (idx 0)
Feb 13 23:01:45 italy kernel: [   24.436420] tveeprom 0-0050: has no radio
Feb 13 23:01:45 italy kernel: [   24.436466] bttv0: Hauppauge eeprom indicates model#44801
Feb 13 23:01:45 italy kernel: [   24.436516] bttv0: tuner type=39
Feb 13 23:01:45 italy kernel: [   24.436563] bttv0: i2c: checking for MSP34xx @ 0x80... not found
Feb 13 23:01:45 italy kernel: [   25.039949] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
Feb 13 23:01:45 italy kernel: [   25.055236] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
Feb 13 23:01:45 italy kernel: [   25.143632] input: Power Button (FF) as /class/input/input1
Feb 13 23:01:45 italy kernel: [   25.178853] ACPI: Power Button (FF) [PWRF]
Feb 13 23:01:45 italy kernel: [   25.179078] input: Power Button (CM) as /class/input/input2
Feb 13 23:01:45 italy kernel: [   25.209317] ACPI: Power Button (CM) [PWRB]
Feb 13 23:01:45 italy kernel: [   25.209532] input: Sleep Button (CM) as /class/input/input3
Feb 13 23:01:45 italy kernel: [   25.236000] ACPI: Sleep Button (CM) [SLPB]
Feb 13 23:01:45 italy kernel: [   25.534109] BUG: unable to handle kernel paging request at 49404ddc
Feb 13 23:01:45 italy kernel: [   25.534238] IP: [<c0163b5f>] handle_mm_fault+0xe3/0x690
Feb 13 23:01:45 italy kernel: [   25.534334] *pde = 00000000 
Feb 13 23:01:45 italy kernel: [   25.534410] Oops: 0000 [#1] SMP 
Feb 13 23:01:45 italy kernel: [   25.534512] Modules linked in: snd_seq tvaudio button snd_timer snd_seq_device snd bttv(+) videodev v4l1_compat firmware_class ir_common soundcore compat_ioctl32 i2c_algo_bit snd_page_alloc v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_core shpchp pci_hotplug via_agp agpgart evdev ext3 jbd mbcache sha256_generic aes_i586 aes_generic cbc sd_mod dm_crypt crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_disk ata_generic libata dock usb_storage scsi_mod via82cxxx ide_pci_generic ide_core uhci_hcd ehci_hcd ohci_hcd usbcore 8139too 8139cp mii thermal processor fan thermal_sys
Feb 13 23:01:45 italy kernel: [   25.536016] 
Feb 13 23:01:45 italy kernel: [   25.536016] Pid: 1673, comm: modprobe Not tainted (2.6.26-1-686 #1)
Feb 13 23:01:45 italy kernel: [   25.536016] EIP: 0060:[<c0163b5f>] EFLAGS: 00010202 CPU: 0
Feb 13 23:01:45 italy kernel: [   25.536016] EIP is at handle_mm_fault+0xe3/0x690
Feb 13 23:01:45 italy kernel: [   25.536016] EAX: 49404000 EBX: 01128080 ECX: 00000ddc EDX: ef71e000
Feb 13 23:01:45 italy kernel: [   25.536016] ESI: c1000000 EDI: 49404ddc EBP: edcc0f40 ESP: ef52bf10
Feb 13 23:01:45 italy kernel: [   25.536016]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Feb 13 23:01:45 italy kernel: [   25.536016] Process modprobe (pid: 1673, ti=ef52a000 task=edcc0f40 task.ti=ef52a000)
Feb 13 23:01:45 italy kernel: [   25.536016] Stack: 005ee320 b7f3d000 00000000 b7f772a0 ef716a04 edd2c5e0 00000ddc f096f000 
Feb 13 23:01:45 italy kernel: [   25.536016]        c03b85e0 fffffff4 00000001 00000000 000b7f3d 00000001 ef716c14 ef716c1c 
Feb 13 23:01:45 italy kernel: [   25.536016]        ef71695c 00000073 00000000 00000001 b7f3d000 c0166dc0 00000000 ef716a04 
Feb 13 23:01:45 italy kernel: [   25.536016] Call Trace:
Feb 13 23:01:45 italy kernel: [   25.536016]  [<f096f000>] agp_copy_info+0xa0/0xc2 [agpgart]
Feb 13 23:01:45 italy kernel: [   25.536016]  [<c0166dc0>] do_mmap_pgoff+0x266/0x2b9
Feb 13 23:01:45 italy kernel: [   25.536016]  [<c0115b4f>] do_page_fault+0x29b/0x5b8
Feb 13 23:01:45 italy kernel: [   25.536016]  [<c0106a2a>] sys_mmap2+0x62/0xa0
Feb 13 23:01:45 italy kernel: [   25.536016]  [<c01158b4>] do_page_fault+0x0/0x5b8
Feb 13 23:01:45 italy kernel: [   25.536016]  [<c02b980a>] error_code+0x72/0x78
Feb 13 23:01:45 italy kernel: [   25.536016]  =======================
Feb 13 23:01:45 italy kernel: [   25.536016] Code: 89 c3 c1 eb 0c c1 e3 05 8d 04 1e e8 79 d7 ff ff 8b 4c 24 0c c1 e9 0a 81 e1 fc 0f 00 00 89 cf 01 c7 89 4c 24 18 0f 84 9e 05 00 00 <8b> 1f f6 c3 81 0f 85 cd 04 00 00 85 db 0f 85 78 01 00 00 8b 54 
Feb 13 23:01:45 italy kernel: [   25.536016] EIP: [<c0163b5f>] handle_mm_fault+0xe3/0x690 SS:ESP 0068:ef52bf10
Feb 13 23:01:45 italy kernel: [   25.540713] ---[ end trace 0eeaa552a8ccfeb9 ]---
Feb 13 23:01:45 italy kernel: [   25.690579] tuner' 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
Feb 13 23:01:45 italy kernel: [   26.234690] tuner-simple 0-0061: creating new instance
Feb 13 23:01:45 italy kernel: [   26.234755] tuner-simple 0-0061: type set to 39 (LG NTSC (newer TAPC series))
Feb 13 23:01:45 italy kernel: [   26.243885] bttv0: registered device video0
Feb 13 23:01:45 italy kernel: [   26.243975] bttv0: registered device vbi0
Feb 13 23:01:45 italy kernel: [   26.244101] bttv0: PLL: 28636363 => 35468950 .. ok
Feb 13 23:01:45 italy kernel: [   27.095915] input: PC Speaker as /class/input/input4
Feb 13 23:01:45 italy kernel: [   27.655600] NET: Registered protocol family 23
Feb 13 23:01:45 italy kernel: [   27.911851] input: ImPS/2 Generic Wheel Mouse as /class/input/input5
Feb 13 23:01:45 italy kernel: [   27.942819] parport_pc 00:0a: reported by Plug and Play ACPI
Feb 13 23:01:45 italy kernel: [   27.942948] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
Feb 13 23:01:45 italy kernel: [   28.341742] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 13 23:01:45 italy kernel: [   29.445326] ACPI: PCI Interrupt 0000:00:0a.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 13 23:01:45 italy kernel: [   29.446172] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
Feb 13 23:01:45 italy kernel: [   30.589131] hda: UDMA/133 mode selected
Feb 13 23:01:45 italy kernel: [   30.622766] hdd: UDMA/66 mode selected
Feb 13 23:01:45 italy kernel: [   31.420720] EXT3 FS on dm-1, internal journal
Feb 13 23:01:45 italy kernel: [   31.850560] loop: module loaded
Feb 13 23:01:45 italy kernel: [   31.946221] [drm] Initialized drm 1.1.0 20060810
Feb 13 23:01:45 italy kernel: [   31.989704] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 13 23:01:45 italy kernel: [   31.990001] [drm] Initialized radeon 1.29.0 20080528 on minor 0
Feb 13 23:01:45 italy kernel: [   46.886921] kjournald starting.  Commit interval 5 seconds
Feb 13 23:01:45 italy kernel: [   46.904910] EXT3 FS on hda1, internal journal
Feb 13 23:01:45 italy kernel: [   46.904993] EXT3-fs: mounted filesystem with ordered data mode.
Feb 13 23:01:45 italy kernel: [   46.954556] kjournald starting.  Commit interval 5 seconds
Feb 13 23:01:45 italy kernel: [   46.967584] EXT3 FS on dm-3, internal journal
Feb 13 23:01:45 italy kernel: [   46.967584] EXT3-fs: mounted filesystem with ordered data mode.
Feb 13 23:01:45 italy kernel: [   47.088049] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   47.344045] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   47.592045] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   47.840054] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   48.092044] usb 4-5: reset high speed USB device using ehci_hcd and address 3
Feb 13 23:01:45 italy kernel: [   48.231811] kjournald starting.  Commit interval 5 seconds
Feb 13 23:01:45 italy kernel: [   48.231887] EXT3-fs: mounted filesystem with ordered data mode.
Feb 13 23:01:45 italy kernel: [   48.283369] Adding 2330616k swap on /dev/mapper/italy-swap_1.  Priority:-1 extents:1 across:2330616k
Feb 13 23:01:45 italy kernel: [   50.188285] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
Feb 14 15:29:46 italy kernel: klogd 1.5.0#5, log source = /proc/kmsg started.
Feb 14 15:29:46 italy kernel: [    0.000000] Initializing cgroup subsys cpuset
Feb 14 15:29:46 italy kernel: [    0.000000] Initializing cgroup subsys cpu
Feb 14 15:29:46 italy kernel: [    0.000000] Linux version 2.6.26-1-686 (Debian 2.6.26-13) (waldi@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-24)) #1 SMP Sat Jan 10 18:29:31 UTC 2009
Feb 14 15:29:46 italy kernel: [    0.000000] BIOS-provided physical RAM map:
Feb 14 15:29:46 italy kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Feb 14 15:29:46 italy kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Feb 14 15:29:46 italy kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Feb 14 15:29:46 italy kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000002fff0000 (usable)
Feb 14 15:29:46 italy kernel: [    0.000000]  BIOS-e820: 000000002fff0000 - 000000002fff3000 (ACPI NVS)
Feb 14 15:29:46 italy kernel: [    0.000000]  BIOS-e820: 000000002fff3000 - 0000000030000000 (ACPI data)
Feb 14 15:29:46 italy kernel: [    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Feb 14 15:29:46 italy kernel: [    0.000000] 0MB HIGHMEM available.
Feb 14 15:29:46 italy kernel: [    0.000000] 767MB LOWMEM available.
Feb 14 15:29:46 italy kernel: [    0.000000] Entering add_active_range(0, 0, 196592) 0 entries of 256 used
Feb 14 15:29:46 italy kernel: [    0.000000] Zone PFN ranges:
Feb 14 15:29:46 italy kernel: [    0.000000]   DMA             0 ->     4096
Feb 14 15:29:46 italy kernel: [    0.000000]   Normal       4096 ->   196592
Feb 14 15:29:46 italy kernel: [    0.000000]   HighMem    196592 ->   196592
Feb 14 15:29:46 italy kernel: [    0.000000] Movable zone start PFN for each node
Feb 14 15:29:46 italy kernel: [    0.000000] early_node_map[1] active PFN ranges
Feb 14 15:29:46 italy kernel: [    0.000000]     0:        0 ->   196592
Feb 14 15:29:46 italy kernel: [    0.000000] On node 0 totalpages: 196592
Feb 14 15:29:46 italy kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Feb 14 15:29:46 italy kernel: [    0.000000]   DMA zone: 0 pages reserved
Feb 14 15:29:46 italy kernel: [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
Feb 14 15:29:46 italy kernel: [    0.000000]   Normal zone: 1504 pages used for memmap
Feb 14 15:29:46 italy kernel: [    0.000000]   Normal zone: 190992 pages, LIFO batch:31
Feb 14 15:29:46 italy kernel: [    0.000000]   HighMem zone: 0 pages used for memmap
Feb 14 15:29:46 italy kernel: [    0.000000]   Movable zone: 0 pages used for memmap
Feb 14 15:29:46 italy kernel: [    0.000000] DMI 2.2 present.
Feb 14 15:29:46 italy kernel: [    0.000000] ACPI: RSDP 000F62E0, 0014 (r0 VIA694)
Feb 14 15:29:46 italy kernel: [    0.000000] ACPI: RSDT 2FFF3000, 0028 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
Feb 14 15:29:46 italy kernel: [    0.000000] ACPI: FACP 2FFF3040, 0074 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
Feb 14 15:29:46 italy kernel: [    0.000000] ACPI: DSDT 2FFF30C0, 3316 (r1 VIA694 AWRDACPI     1000 MSFT  100000E)
Feb 14 15:29:46 italy kernel: [    0.000000] ACPI: FACS 2FFF0000, 0040
Feb 14 15:29:46 italy kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Feb 14 15:29:46 italy kernel: [    0.000000] Allocating PCI resources starting at 40000000 (gap: 30000000:cfff0000)
Feb 14 15:29:46 italy kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Feb 14 15:29:46 italy kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
Feb 14 15:29:46 italy kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Feb 14 15:29:46 italy kernel: [    0.000000] SMP: Allowing 0 CPUs, 0 hotplug CPUs
Feb 14 15:29:46 italy kernel: [    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
Feb 14 15:29:46 italy kernel: [    0.000000] NR_CPUS: 8, nr_cpu_ids: 1
Feb 14 15:29:46 italy kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195056
Feb 14 15:29:46 italy kernel: [    0.000000] Kernel command line: root=/dev/mapper/italy-root ro 
Feb 14 15:29:46 italy kernel: [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
Feb 14 15:29:46 italy kernel: [    0.000000] mapped APIC to ffffb000 (0160f000)
Feb 14 15:29:46 italy kernel: [    0.000000] Enabling fast FPU save and restore... done.
Feb 14 15:29:46 italy kernel: [    0.000000] Initializing CPU#0
Feb 14 15:29:46 italy kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
Feb 14 15:29:46 italy kernel: [    0.000000] Detected 930.689 MHz processor.
Feb 14 15:29:46 italy kernel: [    0.004000] Console: colour VGA+ 80x25
Feb 14 15:29:46 italy kernel: [    0.004000] console [tty0] enabled
Feb 14 15:29:46 italy kernel: [    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Feb 14 15:29:46 italy kernel: [    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Feb 14 15:29:46 italy kernel: [    0.004000] Memory: 768324k/786368k available (1769k kernel code, 17452k reserved, 752k data, 244k init, 0k highmem)
Feb 14 15:29:46 italy kernel: [    0.004000] virtual kernel memory layout:
Feb 14 15:29:46 italy kernel: [    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
Feb 14 15:29:46 italy kernel: [    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Feb 14 15:29:46 italy kernel: [    0.004000]     vmalloc : 0xf0800000 - 0xff7fe000   ( 239 MB)
Feb 14 15:29:46 italy kernel: [    0.004000]     lowmem  : 0xc0000000 - 0xefff0000   ( 767 MB)
Feb 14 15:29:46 italy kernel: [    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
Feb 14 15:29:46 italy kernel: [    0.004000]       .data : 0xc02ba4ab - 0xc0376620   ( 752 kB)
Feb 14 15:29:46 italy kernel: [    0.004000]       .text : 0xc0100000 - 0xc02ba4ab   (1769 kB)
Feb 14 15:29:46 italy kernel: [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Feb 14 15:29:46 italy kernel: [    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
Feb 14 15:29:46 italy kernel: [    0.084276] Calibrating delay using timer specific routine.. 1863.86 BogoMIPS (lpj=3727739)
Feb 14 15:29:46 italy kernel: [    0.084444] Security Framework initialized
Feb 14 15:29:46 italy kernel: [    0.084501] SELinux:  Disabled at boot.
Feb 14 15:29:46 italy kernel: [    0.084551] Capability LSM initialized
Feb 14 15:29:46 italy kernel: [    0.084627] Mount-cache hash table entries: 512
Feb 14 15:29:46 italy kernel: [    0.084979] Initializing cgroup subsys ns
Feb 14 15:29:46 italy kernel: [    0.085031] Initializing cgroup subsys cpuacct
Feb 14 15:29:46 italy kernel: [    0.085081] Initializing cgroup subsys devices
Feb 14 15:29:46 italy kernel: [    0.085163] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Feb 14 15:29:46 italy kernel: [    0.085218] CPU: L2 Cache: 256K (64 bytes/line)
Feb 14 15:29:46 italy kernel: [    0.085269] Intel machine check architecture supported.
Feb 14 15:29:46 italy kernel: [    0.085320] Intel machine check reporting enabled on CPU#0.
Feb 14 15:29:46 italy kernel: [    0.085393] Checking 'hlt' instruction... OK.
Feb 14 15:29:46 italy kernel: [    0.100367] SMP alternatives: switching to UP code
Feb 14 15:29:46 italy kernel: [    0.114487] Freeing SMP alternatives: 16k freed
Feb 14 15:29:46 italy kernel: [    0.114545] ACPI: Core revision 20080321
Feb 14 15:29:46 italy kernel: [    0.123942] ACPI: setting ELCR to 0200 (from 0e00)
Feb 14 15:29:46 italy kernel: [    0.128008] weird, boot CPU (#0) not listedby the BIOS.
Feb 14 15:29:46 italy kernel: [    0.128008] SMP motherboard not detected.
Feb 14 15:29:46 italy kernel: [    0.128008] Local APIC not detected. Using dummy APIC emulation.
Feb 14 15:29:46 italy kernel: [    0.128008] SMP disabled
Feb 14 15:29:46 italy kernel: [    0.128008] Brought up 1 CPUs
Feb 14 15:29:46 italy kernel: [    0.128008] Total of 1 processors activated (1863.86 BogoMIPS).
Feb 14 15:29:46 italy kernel: [    0.128008] CPU0 attaching sched-domain:
Feb 14 15:29:46 italy kernel: [    0.128008]  domain 0: span 0
Feb 14 15:29:46 italy kernel: [    0.128008]   groups: 0
Feb 14 15:29:46 italy kernel: [    0.128008] net_namespace: 660 bytes
Feb 14 15:29:46 italy kernel: [    0.128008] Booting paravirtualized kernel on bare hardware
Feb 14 15:29:46 italy kernel: [    0.128008] NET: Registered protocol family 16
Feb 14 15:29:46 italy kernel: [    0.128008] ACPI: bus type pci registered
Feb 14 15:29:46 italy kernel: [    0.130376] PCI: PCI BIOS revision 2.10 entry at 0xfb3e0, last bus=1
Feb 14 15:29:46 italy kernel: [    0.130430] PCI: Using configuration type 1 for base access
Feb 14 15:29:46 italy kernel: [    0.130501] Setting up standard PCI resources
Feb 14 15:29:46 italy kernel: [    0.136672] ACPI: EC: Look up EC in DSDT
Feb 14 15:29:46 italy kernel: [    0.144975] ACPI: Interpreter enabled
Feb 14 15:29:46 italy kernel: [    0.145033] ACPI: (supports S0 S1 S4 S5)
Feb 14 15:29:46 italy kernel: [    0.145220] ACPI: Using PIC for interrupt routing
Feb 14 15:29:46 italy kernel: [    0.154073] ACPI: PCI Root Bridge [PCI0] (0000:00)
Feb 14 15:29:46 italy kernel: [    0.155200] pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
Feb 14 15:29:46 italy kernel: [    0.155258] pci 0000:00:11.0: quirk: region 5000-500f claimed by vt8235 SMB
Feb 14 15:29:46 italy kernel: [    0.155576] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb 14 15:29:46 italy kernel: [    0.199842] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Feb 14 15:29:46 italy kernel: [    0.200623] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Feb 14 15:29:46 italy kernel: [    0.201381] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Feb 14 15:29:46 italy kernel: [    0.202134] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Feb 14 15:29:46 italy kernel: [    0.202874] Linux Plug and Play Support v0.97 (c) Adam Belay
Feb 14 15:29:46 italy kernel: [    0.203002] pnp: PnP ACPI init
Feb 14 15:29:46 italy kernel: [    0.203063] ACPI: bus type pnp registered
Feb 14 15:29:46 italy kernel: [    0.209826] pnp: PnP ACPI: found 13 devices
Feb 14 15:29:46 italy kernel: [    0.209883] ACPI: ACPI bus type pnp unregistered
Feb 14 15:29:46 italy kernel: [    0.209936] PnPBIOS: Disabled by ACPI PNP
Feb 14 15:29:46 italy kernel: [    0.210651] PCI: Using ACPI for IRQ routing
Feb 14 15:29:46 italy kernel: [    0.211172] ACPI: RTC can wake from S4
Feb 14 15:29:46 italy kernel: [    0.211284] system 00:00: iomem range 0xcd000-0xcffff has been reserved
Feb 14 15:29:46 italy kernel: [    0.211340] system 00:00: iomem range 0xf0000-0xf7fff could not be reserved
Feb 14 15:29:46 italy kernel: [    0.211396] system 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Feb 14 15:29:46 italy kernel: [    0.211450] system 00:00: iomem range 0xfc000-0xfffff could not be reserved
Feb 14 15:29:46 italy kernel: [    0.211505] system 00:00: iomem range 0x2fff0000-0x2fffffff could not be reserved
Feb 14 15:29:46 italy kernel: [    0.211566] system 00:00: iomem range 0xffff0000-0xffffffff could not be reserved
Feb 14 15:29:46 italy kernel: [    0.211628] system 00:00: iomem range 0x0-0x9ffff could not be reserved
Feb 14 15:29:46 italy kernel: [    0.211681] system 00:00: iomem range 0x100000-0x2ffeffff could not be reserved
Feb 14 15:29:46 italy kernel: [    0.211743] system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
Feb 14 15:29:46 italy kernel: [    0.211797] system 00:00: iomem range 0xfff80000-0xfffeffff has been reserved
Feb 14 15:29:46 italy kernel: [    0.211864] system 00:02: ioport range 0x4000-0x407f has been reserved
Feb 14 15:29:46 italy kernel: [    0.211918] system 00:02: ioport range 0x5000-0x500f has been reserved
Feb 14 15:29:46 italy kernel: [    0.211993] system 00:03: ioport range 0x4d0-0x4d1 has been reserved
Feb 14 15:29:46 italy kernel: [    0.212072] system 00:03: ioport range 0x800-0x805 has been reserved
Feb 14 15:29:46 italy kernel: [    0.212125] system 00:03: ioport range 0x290-0x297 has been reserved
Feb 14 15:29:46 italy kernel: [    0.243149] PCI: Bridge: 0000:00:01.0
Feb 14 15:29:46 italy kernel: [    0.243198]   IO window: c000-cfff
Feb 14 15:29:46 italy kernel: [    0.243247]   MEM window: 0xe8000000-0xe9ffffff
Feb 14 15:29:46 italy kernel: [    0.243297]   PREFETCH window: 0x00000000d8000000-0x00000000e7ffffff
Feb 14 15:29:46 italy kernel: [    0.243370] PCI: Setting latency timer of device 0000:00:01.0 to 64
Feb 14 15:29:46 italy kernel: [    0.243417] NET: Registered protocol family 2
Feb 14 15:29:46 italy kernel: [    0.243668] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Feb 14 15:29:46 italy kernel: [    0.244531] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Feb 14 15:29:46 italy kernel: [    0.249472] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Feb 14 15:29:46 italy kernel: [    0.252014] TCP: Hash tables configured (established 131072 bind 65536)
Feb 14 15:29:46 italy kernel: [    0.252098] TCP reno registered
Feb 14 15:29:46 italy kernel: [    0.252429] NET: Registered protocol family 1
Feb 14 15:29:46 italy kernel: [    0.252766] checking if image is initramfs...<7>Switched to high resolution mode on CPU 0
Feb 14 15:29:46 italy kernel: [    0.828773]  it is
Feb 14 15:29:46 italy kernel: [    1.515765] Freeing initrd memory: 7199k freed
Feb 14 15:29:46 italy kernel: [    1.517445] audit: initializing netlink socket (disabled)
Feb 14 15:29:46 italy kernel: [    1.517529] type=2000 audit(1234625333.516:1): initialized
Feb 14 15:29:46 italy kernel: [    1.517855] Total HugeTLB memory allocated, 0
Feb 14 15:29:46 italy kernel: [    1.518073] VFS: Disk quotas dquot_6.5.1
Feb 14 15:29:46 italy kernel: [    1.518185] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Feb 14 15:29:46 italy kernel: [    1.518315] msgmni has been set to 1515
Feb 14 15:29:46 italy kernel: [    1.518594] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Feb 14 15:29:46 italy kernel: [    1.518659] io scheduler noop registered
Feb 14 15:29:46 italy kernel: [    1.518706] io scheduler anticipatory registered
Feb 14 15:29:46 italy kernel: [    1.518753] io scheduler deadline registered
Feb 14 15:29:46 italy kernel: [    1.518813] io scheduler cfq registered (default)
Feb 14 15:29:46 italy kernel: [    1.518881] PCI: VIA PCI bridge detected.Disabling DAC.
Feb 14 15:29:46 italy kernel: [    1.519107] pci 0000:01:00.0: Boot video device
Feb 14 15:29:46 italy kernel: [    1.519915] isapnp: Scanning for PnP cards...
Feb 14 15:29:46 italy kernel: [    1.874049] isapnp: No Plug & Play device found
Feb 14 15:29:46 italy kernel: [    1.881306] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Feb 14 15:29:46 italy kernel: [    1.881576] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 14 15:29:46 italy kernel: [    1.881805] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 14 15:29:46 italy kernel: [    1.882538] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 14 15:29:46 italy kernel: [    1.882859] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 14 15:29:46 italy kernel: [    1.886555] brd: module loaded
Feb 14 15:29:46 italy kernel: [    1.886841] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Feb 14 15:29:46 italy kernel: [    1.887363] serio: i8042 KBD port at 0x60,0x64 irq 1
Feb 14 15:29:46 italy kernel: [    1.887421] serio: i8042 AUX port at 0x60,0x64 irq 12
Feb 14 15:29:46 italy kernel: [    1.887823] mice: PS/2 mouse device common for all mice
Feb 14 15:29:46 italy kernel: [    1.888223] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
Feb 14 15:29:46 italy kernel: [    1.888300] rtc0: alarms up to one year, y3k
Feb 14 15:29:46 italy kernel: [    1.888429] cpuidle: using governor ladder
Feb 14 15:29:46 italy kernel: [    1.888478] cpuidle: using governor menu
Feb 14 15:29:46 italy kernel: [    1.888531] No iBFT detected.
Feb 14 15:29:46 italy kernel: [    1.889624] TCP cubic registered
Feb 14 15:29:46 italy kernel: [    1.889674] NET: Registered protocol family 17
Feb 14 15:29:46 italy kernel: [    1.889732] Using IPI No-Shortcut mode
Feb 14 15:29:46 italy kernel: [    1.890062] registered taskstats version 1
Feb 14 15:29:46 italy kernel: [    1.890471] rtc_cmos 00:05: setting system clock to 2009-02-14 15:28:55 UTC (1234625335)
Feb 14 15:29:46 italy kernel: [    1.891117] Freeing unused kernel memory: 244k freed
Feb 14 15:29:46 italy kernel: [    1.910559] input: AT Translated Set 2 keyboard as /class/input/input0
Feb 14 15:29:46 italy kernel: [    2.142322] ACPI: PNP0C0B:00 is registered as cooling_device0
Feb 14 15:29:46 italy kernel: [    2.142400] ACPI: Fan [FAN] (on)
Feb 14 15:29:46 italy kernel: [    2.156451] ACPI: CPU0 (power states: C1[C1] C2[C2])
Feb 14 15:29:46 italy kernel: [    2.156709] ACPI: ACPI0007:00 is registered as cooling_device1
Feb 14 15:29:46 italy kernel: [    2.160893] ACPI: LNXTHERM:01 is registered as thermal_zone0
Feb 14 15:29:46 italy kernel: [    2.161217] ACPI: Thermal Zone [THRM] (40 C)
Feb 14 15:29:46 italy kernel: [    3.263550] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
Feb 14 15:29:46 italy kernel: [    3.263653] 8139cp 0000:00:0b.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
Feb 14 15:29:46 italy kernel: [    3.263716] 8139cp 0000:00:0b.0: Try the "8139too" driver instead.
Feb 14 15:29:46 italy kernel: [    3.294764] 8139too Fast Ethernet driver 0.9.28
Feb 14 15:29:46 italy kernel: [    3.295724] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
Feb 14 15:29:46 italy kernel: [    3.295778] PCI: setting IRQ 11 as level-triggered
Feb 14 15:29:46 italy kernel: [    3.295786] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 14 15:29:46 italy kernel: [    3.296860] eth0: RealTek RTL8139 at 0xd400, 00:02:44:14:3f:2c, IRQ 11
Feb 14 15:29:46 italy kernel: [    3.296914] eth0:  Identified 8139 chip type 'RTL-8139B'
Feb 14 15:29:46 italy kernel: [    3.813262] usbcore: registered new interface driver usbfs
Feb 14 15:29:46 italy kernel: [    3.813390] usbcore: registered new interface driver hub
Feb 14 15:29:46 italy kernel: [    3.813512] usbcore: registered new device driver usb
Feb 14 15:29:46 italy kernel: [    3.827689] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Feb 14 15:29:46 italy kernel: [    3.828578] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
Feb 14 15:29:46 italy kernel: [    3.828640] PCI: setting IRQ 10 as level-triggered
Feb 14 15:29:46 italy kernel: [    3.828648] ACPI: PCI Interrupt 0000:00:0c.0[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 14 15:29:46 italy kernel: [    3.828792] ohci_hcd 0000:00:0c.0: OHCI Host Controller
Feb 14 15:29:46 italy kernel: [    3.829104] ohci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 1
Feb 14 15:29:46 italy kernel: [    3.829193] ohci_hcd 0000:00:0c.0: irq 10, io mem 0xea003000
Feb 14 15:29:46 italy kernel: [    3.888677] usb usb1: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    3.888810] hub 1-0:1.0: USB hub found
Feb 14 15:29:46 italy kernel: [    3.888881] hub 1-0:1.0: 2 ports detected
Feb 14 15:29:46 italy kernel: [    3.919926] USB Universal Host Controller Interface driver v3.0
Feb 14 15:29:46 italy kernel: [    4.001615] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Feb 14 15:29:46 italy kernel: [    4.001682] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 14 15:29:46 italy kernel: [    4.001742] usb usb1: Product: OHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.001790] usb usb1: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 14 15:29:46 italy kernel: [    4.001840] usb usb1: SerialNumber: 0000:00:0c.0
Feb 14 15:29:46 italy kernel: [    4.002825] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
Feb 14 15:29:46 italy kernel: [    4.002880] ACPI: PCI Interrupt 0000:00:0c.1[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 14 15:29:46 italy kernel: [    4.003023] ohci_hcd 0000:00:0c.1: OHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.003128] ohci_hcd 0000:00:0c.1: new USB bus registered, assigned bus number 2
Feb 14 15:29:46 italy kernel: [    4.003218] ohci_hcd 0000:00:0c.1: irq 11, io mem 0xea004000
Feb 14 15:29:46 italy kernel: [    4.058279] usb usb2: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    4.058408] hub 2-0:1.0: USB hub found
Feb 14 15:29:46 italy kernel: [    4.058478] hub 2-0:1.0: 2 ports detected
Feb 14 15:29:46 italy kernel: [    4.062939] Uniform Multi-Platform E-IDE driver
Feb 14 15:29:46 italy kernel: [    4.063006] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb 14 15:29:46 italy kernel: [    4.160338] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Feb 14 15:29:46 italy kernel: [    4.160405] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 14 15:29:46 italy kernel: [    4.160466] usb usb2: Product: OHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.160514] usb usb2: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 14 15:29:46 italy kernel: [    4.160565] usb usb2: SerialNumber: 0000:00:0c.1
Feb 14 15:29:46 italy kernel: [    4.160759] ACPI: PCI Interrupt 0000:00:0c.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 14 15:29:46 italy kernel: [    4.160912] ohci_hcd 0000:00:0c.2: OHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.161053] ohci_hcd 0000:00:0c.2: new USB bus registered, assigned bus number 3
Feb 14 15:29:46 italy kernel: [    4.161140] ohci_hcd 0000:00:0c.2: irq 11, io mem 0xea005000
Feb 14 15:29:46 italy kernel: [    4.218305] usb usb3: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    4.218436] hub 3-0:1.0: USB hub found
Feb 14 15:29:46 italy kernel: [    4.218502] hub 3-0:1.0: 2 ports detected
Feb 14 15:29:46 italy kernel: [    4.301663] Marking TSC unstable due to: TSC halts in idle.
Feb 14 15:29:46 italy kernel: [    4.320381] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Feb 14 15:29:46 italy kernel: [    4.320437] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 14 15:29:46 italy kernel: [    4.320497] usb usb3: Product: OHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.320545] usb usb3: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
Feb 14 15:29:46 italy kernel: [    4.320595] usb usb3: SerialNumber: 0000:00:0c.2
Feb 14 15:29:46 italy kernel: [    4.321789] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
Feb 14 15:29:46 italy kernel: [    4.321844] ACPI: PCI Interrupt 0000:00:0c.3[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 14 15:29:46 italy kernel: [    4.321989] ehci_hcd 0000:00:0c.3: EHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.322097] ehci_hcd 0000:00:0c.3: new USB bus registered, assigned bus number 4
Feb 14 15:29:46 italy kernel: [    4.344121] ehci_hcd 0000:00:0c.3: debug port 1
Feb 14 15:29:46 italy kernel: [    4.344207] ehci_hcd 0000:00:0c.3: irq 10, io mem 0xea006000
Feb 14 15:29:46 italy kernel: [    4.356120] ehci_hcd 0000:00:0c.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 14 15:29:46 italy kernel: [    4.356425] usb usb4: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    4.356546] hub 4-0:1.0: USB hub found
Feb 14 15:29:46 italy kernel: [    4.356616] hub 4-0:1.0: 6 ports detected
Feb 14 15:29:46 italy kernel: [    4.460317] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
Feb 14 15:29:46 italy kernel: [    4.460383] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 14 15:29:46 italy kernel: [    4.460443] usb usb4: Product: EHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.460492] usb usb4: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
Feb 14 15:29:46 italy kernel: [    4.460542] usb usb4: SerialNumber: 0000:00:0c.3
Feb 14 15:29:46 italy kernel: [    4.460691] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 14 15:29:46 italy kernel: [    4.460831] uhci_hcd 0000:00:10.0: UHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.460933] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 5
Feb 14 15:29:46 italy kernel: [    4.461026] uhci_hcd 0000:00:10.0: irq 10, io base 0x0000d800
Feb 14 15:29:46 italy kernel: [    4.461282] usb usb5: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    4.461396] hub 5-0:1.0: USB hub found
Feb 14 15:29:46 italy kernel: [    4.461460] hub 5-0:1.0: 2 ports detected
Feb 14 15:29:46 italy kernel: [    4.564363] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Feb 14 15:29:46 italy kernel: [    4.564430] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 14 15:29:46 italy kernel: [    4.564490] usb usb5: Product: UHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.564538] usb usb5: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 14 15:29:46 italy kernel: [    4.564588] usb usb5: SerialNumber: 0000:00:10.0
Feb 14 15:29:46 italy kernel: [    4.564756] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Feb 14 15:29:46 italy kernel: [    4.564897] uhci_hcd 0000:00:10.1: UHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.565002] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 6
Feb 14 15:29:46 italy kernel: [    4.565099] uhci_hcd 0000:00:10.1: irq 10, io base 0x0000dc00
Feb 14 15:29:46 italy kernel: [    4.565364] usb usb6: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    4.565479] hub 6-0:1.0: USB hub found
Feb 14 15:29:46 italy kernel: [    4.565543] hub 6-0:1.0: 2 ports detected
Feb 14 15:29:46 italy kernel: [    4.585621] BUG: unable to handle kernel paging request at baab99cc
Feb 14 15:29:46 italy kernel: [    4.585746] IP: [<c0163afb>] handle_mm_fault+0x7f/0x690
Feb 14 15:29:46 italy kernel: [    4.585842] *pde = 00000000 
Feb 14 15:29:46 italy kernel: [    4.585918] Oops: 0000 [#1] SMP 
Feb 14 15:29:46 italy kernel: [    4.586019] Modules linked in: ide_pci_generic(+) ide_core uhci_hcd(+) ehci_hcd(+) ohci_hcd usbcore 8139too 8139cp mii thermal processor fan thermal_sys
Feb 14 15:29:46 italy kernel: [    4.586499] 
Feb 14 15:29:46 italy kernel: [    4.586542] Pid: 731, comm: udevd Not tainted (2.6.26-1-686 #1)
Feb 14 15:29:46 italy kernel: [    4.586593] EIP: 0060:[<c0163afb>] EFLAGS: 00010287 CPU: 0
Feb 14 15:29:46 italy kernel: [    4.586646] EIP is at handle_mm_fault+0x7f/0x690
Feb 14 15:29:46 italy kernel: [    4.586695] EAX: baab99cc EBX: edd554c4 ECX: edd554c4 EDX: cccccccc
Feb 14 15:29:46 italy kernel: [    4.586747] ESI: edc64680 EDI: ef40e0a0 EBP: edc64680 ESP: eddcff18
Feb 14 15:29:46 italy kernel: [    4.586799]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb 14 15:29:46 italy kernel: [    4.586850] Process udevd (pid: 731, ti=eddce000 task=edc64680 task.ti=eddce000)
Feb 14 15:29:46 italy kernel: [    4.586903] Stack: 00000000 edd554c4 edd554c4 eddecd80 00000f40 eddbab7c c03b85e0 baab99cc 
Feb 14 15:29:46 italy kernel: [    4.587225]        ef470be0 08054620 ef433000 ef433000 eddce000 0000007b 00000000 00000000 
Feb 14 15:29:46 italy kernel: [    4.587546]        00000000 00000020 ef470be0 00000003 edc3aa70 edd554c4 eddecdb8 b7fd8ddb 
Feb 14 15:29:46 italy kernel: [    4.587866] Call Trace:
Feb 14 15:29:46 italy kernel: [    4.587950]  [<c0115b4f>] do_page_fault+0x29b/0x5b8
Feb 14 15:29:46 italy kernel: [    4.588034]  [<c0172acd>] filp_close+0x4d/0x53
Feb 14 15:29:46 italy kernel: [    4.588034]  [<c01158b4>] do_page_fault+0x0/0x5b8
Feb 14 15:29:46 italy kernel: [    4.588034]  [<c02b980a>] error_code+0x72/0x78
Feb 14 15:29:46 italy kernel: [    4.588034]  =======================
Feb 14 15:29:46 italy kernel: [    4.588034] Code: 8b 44 24 14 83 c4 5c 5b 5e 5f 5d e9 44 9e 00 00 8b 44 24 0c 8b 54 24 14 c1 e8 16 c1 e0 02 89 44 24 1c 8b 52 24 01 d0 89 44 24 1c <8b> 00 e8 56 12 fb ff 90 a8 01 75 19 8b 4c 24 0c 8b 54 24 1c 8b 
Feb 14 15:29:46 italy kernel: [    4.588034] EIP: [<c0163afb>] handle_mm_fault+0x7f/0x690 SS:ESP 0068:eddcff18
Feb 14 15:29:46 italy kernel: [    4.590435] ---[ end trace 3959a4645d21a6b8 ]---
Feb 14 15:29:46 italy kernel: [    4.669326] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Feb 14 15:29:46 italy kernel: [    4.669392] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 14 15:29:46 italy kernel: [    4.669452] usb usb6: Product: UHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.669500] usb usb6: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 14 15:29:46 italy kernel: [    4.669550] usb usb6: SerialNumber: 0000:00:10.1
Feb 14 15:29:46 italy kernel: [    4.669702] ACPI: PCI Interrupt 0000:00:10.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Feb 14 15:29:46 italy kernel: [    4.669841] uhci_hcd 0000:00:10.2: UHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.669945] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 7
Feb 14 15:29:46 italy kernel: [    4.670037] uhci_hcd 0000:00:10.2: irq 11, io base 0x0000e000
Feb 14 15:29:46 italy kernel: [    4.670297] usb usb7: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    4.670413] hub 7-0:1.0: USB hub found
Feb 14 15:29:46 italy kernel: [    4.670477] hub 7-0:1.0: 2 ports detected
Feb 14 15:29:46 italy kernel: [    4.720651] usb 4-5: new high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [    4.772721] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Feb 14 15:29:46 italy kernel: [    4.772777] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 14 15:29:46 italy kernel: [    4.772837] usb usb7: Product: UHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.772885] usb usb7: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
Feb 14 15:29:46 italy kernel: [    4.772935] usb usb7: SerialNumber: 0000:00:10.2
Feb 14 15:29:46 italy kernel: [    4.773072] ACPI: PCI Interrupt 0000:00:10.3[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Feb 14 15:29:46 italy kernel: [    4.773223] ehci_hcd 0000:00:10.3: EHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.773329] ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 8
Feb 14 15:29:46 italy kernel: [    4.773468] ehci_hcd 0000:00:10.3: irq 11, io mem 0xea007000
Feb 14 15:29:46 italy kernel: [    4.844334] ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 14 15:29:46 italy kernel: [    4.844574] usb usb8: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    4.845330] hub 8-0:1.0: USB hub found
Feb 14 15:29:46 italy kernel: [    4.845404] hub 8-0:1.0: 6 ports detected
Feb 14 15:29:46 italy kernel: [    4.854964] usb 4-5: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [    4.856023] usb 4-5: New USB device found, idVendor=059f, idProduct=0951
Feb 14 15:29:46 italy kernel: [    4.856023] usb 4-5: New USB device strings: Mfr=10, Product=11, SerialNumber=5
Feb 14 15:29:46 italy kernel: [    4.856116] usb 4-5: Product: LaCie Hard Drive USB
Feb 14 15:29:46 italy kernel: [    4.856165] usb 4-5: Manufacturer: LaCie SA
Feb 14 15:29:46 italy kernel: [    4.856212] usb 4-5: SerialNumber: 031D703971FF
Feb 14 15:29:46 italy kernel: [    4.948252] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
Feb 14 15:29:46 italy kernel: [    4.948311] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 14 15:29:46 italy kernel: [    4.948371] usb usb8: Product: EHCI Host Controller
Feb 14 15:29:46 italy kernel: [    4.948419] usb usb8: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
Feb 14 15:29:46 italy kernel: [    4.948469] usb usb8: SerialNumber: 0000:00:10.3
Feb 14 15:29:46 italy kernel: [    4.954818] VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:11.1
Feb 14 15:29:46 italy kernel: [    4.954936] ACPI: PCI Interrupt 0000:00:11.1[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 14 15:29:46 italy kernel: [    4.955064] VIA_IDE 0000:00:11.1: VIA VLink IRQ fixup, from 255 to 10
Feb 14 15:29:46 italy kernel: [    4.955145] VP_IDE: not 100% native mode: will probe irqs later
Feb 14 15:29:46 italy kernel: [    4.955229] VP_IDE: VIA vt8235 (rev 00) IDE UDMA133 controller on pci0000:00:11.1
Feb 14 15:29:46 italy kernel: [    4.955304]     ide0: BM-DMA at 0xe400-0xe407
Feb 14 15:29:46 italy kernel: [    4.955361]     ide1: BM-DMA at 0xe408-0xe40f
Feb 14 15:29:46 italy kernel: [    4.955411] Probing IDE interface ide0...
Feb 14 15:29:46 italy kernel: [    5.372201] hda: Maxtor 6B200P0, ATA DISK drive
Feb 14 15:29:46 italy kernel: [    5.394322] BUG: unable to handle kernel paging request at 01251000
Feb 14 15:29:46 italy kernel: [    5.394448] IP: [<c0163ae8>] handle_mm_fault+0x6c/0x690
Feb 14 15:29:46 italy kernel: [    5.394543] *pde = 00000000 
Feb 14 15:29:46 italy kernel: [    5.394620] Oops: 0002 [#2] SMP 
Feb 14 15:29:46 italy kernel: [    5.394721] Modules linked in: via82cxxx(+) ide_pci_generic ide_core uhci_hcd ehci_hcd ohci_hcd usbcore 8139too 8139cp mii thermal processor fan thermal_sys
Feb 14 15:29:46 italy kernel: [    5.395230] 
Feb 14 15:29:46 italy kernel: [    5.395274] Pid: 784, comm: udevd Tainted: G      D   (2.6.26-1-686 #1)
Feb 14 15:29:46 italy kernel: [    5.395327] EIP: 0060:[<c0163ae8>] EFLAGS: 00010246 CPU: 0
Feb 14 15:29:46 italy kernel: [    5.395380] EIP is at handle_mm_fault+0x6c/0x690
Feb 14 15:29:46 italy kernel: [    5.395428] EAX: 01251000 EBX: edd55cf8 ECX: edd55cf8 EDX: eddad540
Feb 14 15:29:46 italy kernel: [    5.395480] ESI: eddad578 EDI: b7e8e270 EBP: edc65b20 ESP: eddeff10
Feb 14 15:29:46 italy kernel: [    5.395532]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb 14 15:29:46 italy kernel: [    5.395583] Process udevd (pid: 784, ti=eddee000 task=edc65b20 task.ti=eddee000)
Feb 14 15:29:46 italy kernel: [    5.395636] Stack: c0355c80 00000001 00000000 b7e8e270 edd55cf8 eddad540 00000a34 ede20b7c 
Feb 14 15:29:46 italy kernel: [    5.395957]        c03b85e0 c018b8a4 eddeffa0 00000005 bfeda76c 00000002 c15bdd20 c0354e60 
Feb 14 15:29:46 italy kernel: [    5.396022]        00000256 bfedb83c bfedb83c 08c2d0b0 c01771d5 eddea3c0 c01dcd22 edd55cf8 
Feb 14 15:29:46 italy kernel: [    5.396022] Call Trace:
Feb 14 15:29:46 italy kernel: [    5.396022]  [<c018b8a4>] simple_read_from_buffer+0x64/0x8d
Feb 14 15:29:46 italy kernel: [    5.396022]  [<c01771d5>] sys_lstat64+0xf/0x23
Feb 14 15:29:46 italy kernel: [    5.396022]  [<c01dcd22>] _atomic_dec_and_lock+0x2a/0x44
Feb 14 15:29:46 italy kernel: [    5.396022]  [<c0115b4f>] do_page_fault+0x29b/0x5b8
Feb 14 15:29:46 italy kernel: [    5.396022]  [<c0172acd>] filp_close+0x4d/0x53
Feb 14 15:29:46 italy kernel: [    5.396022]  [<c01158b4>] do_page_fault+0x0/0x5b8
Feb 14 15:29:46 italy kernel: [    5.396022]  [<c02b980a>] error_code+0x72/0x78
Feb 14 15:29:46 italy kernel: [    5.396022]  =======================
Feb 14 15:29:46 italy kernel: [    5.396022] Code: 40 74 20 8b 44 24 08 8b 4c 24 0c 8b 54 24 10 89 44 24 70 8b 44 24 14 83 c4 5c 5b 5e 5f 5d e9 44 9e 00 00 8b 44 24 0c 8b 54 24 14 <c1> e8 16 c1 e0 02 89 44 24 1c 8b 52 24 01 d0 89 44 24 1c 8b 00 
Feb 14 15:29:46 italy kernel: [    5.396022] EIP: [<c0163ae8>] handle_mm_fault+0x6c/0x690 SS:ESP 0068:eddeff10
Feb 14 15:29:46 italy kernel: [    5.399421] ---[ end trace 3959a4645d21a6b8 ]---
Feb 14 15:29:46 italy kernel: [    5.503779] SCSI subsystem initialized
Feb 14 15:29:46 italy kernel: [    5.512753] Initializing USB Mass Storage driver...
Feb 14 15:29:46 italy kernel: [    5.652288] scsi0 : SCSI emulation for USB Mass Storage devices
Feb 14 15:29:46 italy kernel: [    5.652996] usbcore: registered new interface driver usb-storage
Feb 14 15:29:46 italy kernel: [    5.653055] USB Mass Storage support registered.
Feb 14 15:29:46 italy kernel: [    5.657963] usb-storage: device found at 2
Feb 14 15:29:46 italy kernel: [    5.658024] usb-storage: waiting for device to settle before scanning
Feb 14 15:29:46 italy kernel: [    6.052146] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Feb 14 15:29:46 italy kernel: [    6.053711] hda: UDMA/133 mode selected
Feb 14 15:29:46 italy kernel: [    6.055266] Probing IDE interface ide1...
Feb 14 15:29:46 italy kernel: [    7.200142] hdd: SONY DVD RW DW-D22A, ATAPI CD/DVD-ROM drive
Feb 14 15:29:46 italy kernel: [    7.256117] hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Feb 14 15:29:46 italy kernel: [    7.256439] hdd: UDMA/66 mode selected
Feb 14 15:29:46 italy kernel: [    7.256778] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb 14 15:29:46 italy kernel: [    7.279200] ide1 at 0x170-0x177,0x376 on irq 15
Feb 14 15:29:46 italy kernel: [    7.284938] No dock devices found.
Feb 14 15:29:46 italy kernel: [    7.307888] libata version 3.00 loaded.
Feb 14 15:29:46 italy kernel: [    7.397859] hda: max request size: 512KiB
Feb 14 15:29:46 italy kernel: [    7.400666] hda: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63
Feb 14 15:29:46 italy kernel: [    7.405330] hda: cache flushes supported
Feb 14 15:29:46 italy kernel: [    7.405488]  hda: hda1 hda2 < hda5 >
Feb 14 15:29:46 italy kernel: [    7.426369] hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Feb 14 15:29:46 italy kernel: [    7.426615] Uniform CD-ROM driver Revision: 3.20
Feb 14 15:29:46 italy kernel: [    7.667982] device-mapper: uevent: version 1.0.3
Feb 14 15:29:46 italy kernel: [    7.670897] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Feb 14 15:29:46 italy kernel: [   10.657009] usb-storage: device scan complete
Feb 14 15:29:46 italy kernel: [   10.746348] scsi 0:0:0:0: Direct-Access     SAMSUNG  HD500LJ               PQ: 0 ANSI: 2 CCS
Feb 14 15:29:46 italy kernel: [   10.786252] Driver 'sd' needs updating - please use bus_type methods
Feb 14 15:29:46 italy kernel: [   10.788138] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Feb 14 15:29:46 italy kernel: [   10.789241] sd 0:0:0:0: [sda] Write Protect is off
Feb 14 15:29:46 italy kernel: [   10.789255] sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
Feb 14 15:29:46 italy kernel: [   10.789261] sd 0:0:0:0: [sda] Assuming drive cache: write through
Feb 14 15:29:46 italy kernel: [   10.791490] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Feb 14 15:29:46 italy kernel: [   10.792858] sd 0:0:0:0: [sda] Write Protect is off
Feb 14 15:29:46 italy kernel: [   10.792870] sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
Feb 14 15:29:46 italy kernel: [   10.792877] sd 0:0:0:0: [sda] Assuming drive cache: write through
Feb 14 15:29:46 italy kernel: [   10.792885]  sda: sda1
Feb 14 15:29:46 italy kernel: [   10.794343] sd 0:0:0:0: [sda] Attached SCSI disk
Feb 14 15:29:46 italy kernel: [   10.968055] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   11.212045] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   11.464047] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   11.724053] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   17.764055] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   18.012040] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   18.458217] PM: Starting manual resume from disk
Feb 14 15:29:46 italy kernel: [   18.500261] EXT3-fs: INFO: recovery required on readonly filesystem.
Feb 14 15:29:46 italy kernel: [   18.500329] EXT3-fs: write access will be enabled during recovery.
Feb 14 15:29:46 italy kernel: [   20.944376] kjournald starting.  Commit interval 5 seconds
Feb 14 15:29:46 italy kernel: [   20.944486] EXT3-fs: dm-1: orphan cleanup on readonly fs
Feb 14 15:29:46 italy kernel: [   20.944547] ext3_orphan_cleanup: deleting unreferenced inode 827568
Feb 14 15:29:46 italy kernel: [   20.944629] ext3_orphan_cleanup: deleting unreferenced inode 827434
Feb 14 15:29:46 italy kernel: [   20.944646] ext3_orphan_cleanup: deleting unreferenced inode 827433
Feb 14 15:29:46 italy kernel: [   20.944661] ext3_orphan_cleanup: deleting unreferenced inode 827432
Feb 14 15:29:46 italy kernel: [   20.944675] ext3_orphan_cleanup: deleting unreferenced inode 827431
Feb 14 15:29:46 italy kernel: [   20.944689] ext3_orphan_cleanup: deleting unreferenced inode 827430
Feb 14 15:29:46 italy kernel: [   20.944701] EXT3-fs: dm-1: 6 orphan inodes deleted
Feb 14 15:29:46 italy kernel: [   20.944748] EXT3-fs: recovery complete.
Feb 14 15:29:46 italy kernel: [   20.953503] EXT3-fs: mounted filesystem with ordered data mode.
Feb 14 15:29:46 italy kernel: [   22.208067] hub 4-0:1.0: unable to enumerate USB device on port 1
Feb 14 15:29:46 italy kernel: [   22.856074] usb 4-1: new high speed USB device using ehci_hcd and address 4
Feb 14 15:29:46 italy kernel: [   22.912227] hub 4-0:1.0: unable to enumerate USB device on port 1
Feb 14 15:29:46 italy kernel: [   23.356069] usb 1-1: new full speed USB device using ohci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   23.580592] usb 1-1: not running at top speed; connect to a high speed hub
Feb 14 15:29:46 italy kernel: [   23.693289] usb 1-1: configuration #1 chosen from 1 choice
Feb 14 15:29:46 italy kernel: [   23.697081] scsi1 : SCSI emulation for USB Mass Storage devices
Feb 14 15:29:46 italy kernel: [   23.697081] usb 1-1: New USB device found, idVendor=07ab, idProduct=fcfe
Feb 14 15:29:46 italy kernel: [   23.697081] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb 14 15:29:46 italy kernel: [   23.697081] usb 1-1: Product: Freecom Hard Drive
Feb 14 15:29:46 italy kernel: [   23.697081] usb 1-1: Manufacturer: Freecom
Feb 14 15:29:46 italy kernel: [   23.697081] usb 1-1: SerialNumber: 01860D8900920
Feb 14 15:29:46 italy kernel: [   23.697081] usb-storage: device found at 2
Feb 14 15:29:46 italy kernel: [   23.697081] usb-storage: waiting for device to settle before scanning
Feb 14 15:29:46 italy kernel: [   24.542808] BUG: unable to handle kernel paging request at 5e5b244b
Feb 14 15:29:46 italy kernel: [   24.542938] IP: [<5e5b244b>]
Feb 14 15:29:46 italy kernel: [   24.543014] *pde = 00000000 
Feb 14 15:29:46 italy kernel: [   24.543091] Oops: 0000 [#3] SMP 
Feb 14 15:29:46 italy kernel: [   24.543193] Modules linked in: ext3 jbd mbcache sha256_generic aes_i586 aes_generic cbc sd_mod dm_crypt crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod ide_cd_mod ide_disk cdrom ata_generic libata dock usb_storage scsi_mod via82cxxx ide_pci_generic ide_core uhci_hcd ehci_hcd ohci_hcd usbcore 8139too 8139cp mii thermal processor fan thermal_sys
Feb 14 15:29:46 italy kernel: [   24.544038] 
Feb 14 15:29:46 italy kernel: [   24.544038] Pid: 1123, comm: grep Tainted: G      D   (2.6.26-1-686 #1)
Feb 14 15:29:46 italy kernel: [   24.544038] EIP: 0060:[<5e5b244b>] EFLAGS: 00010286 CPU: 0
Feb 14 15:29:46 italy kernel: [   24.544038] EIP is at 0x5e5b244b
Feb 14 15:29:46 italy kernel: [   24.544038] EAX: edcf36c0 EBX: eddbfa58 ECX: eddbfa58 EDX: c03b85e0
Feb 14 15:29:46 italy kernel: [   24.544038] ESI: edcf36f8 EDI: b7ef0cd0 EBP: ef4e0100 ESP: ef577f74
Feb 14 15:29:46 italy kernel: [   24.544038]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb 14 15:29:46 italy kernel: [   24.544038] Process grep (pid: 1123, ti=ef576000 task=ef4e0100 task.ti=ef576000)
Feb 14 15:29:46 italy kernel: [   24.544038] Stack: b7ef0cd0 ef4e0100 c0115b4f 00000000 00000004 ef577fb8 edcf36c0 00000000 
Feb 14 15:29:46 italy kernel: [   24.544038]        edcf36c0 099c2000 c0166b52 edcf36f8 bfcc1f0d bfcc0ac4 c01158b4 bfcc08f8 
Feb 14 15:29:46 italy kernel: [   24.544038]        c02b980a bfcc1f0d 00000000 080603e0 bfcc0ac4 080603e4 bfcc08f8 bfcc1f0d 
Feb 14 15:29:46 italy kernel: [   24.544038] Call Trace:
Feb 14 15:29:46 italy kernel: [   24.544038]  [<c0115b4f>] do_page_fault+0x29b/0x5b8
Feb 14 15:29:46 italy kernel: [   24.544038]  [<c0166b52>] sys_brk+0xd3/0xdb
Feb 14 15:29:46 italy kernel: [   24.544038]  [<c01158b4>] do_page_fault+0x0/0x5b8
Feb 14 15:29:46 italy kernel: [   24.544038]  [<c02b980a>] error_code+0x72/0x78
Feb 14 15:29:46 italy kernel: [   24.544038]  =======================
Feb 14 15:29:46 italy kernel: [   24.544038] Code:  Bad EIP value.
Feb 14 15:29:46 italy kernel: [   24.544038] EIP: [<5e5b244b>] 0x5e5b244b SS:ESP 0068:ef577f74
Feb 14 15:29:46 italy kernel: [   24.546494] ---[ end trace 3959a4645d21a6b8 ]---
Feb 14 15:29:46 italy kernel: [   25.519208] hda: UDMA/133 mode selected
Feb 14 15:29:46 italy kernel: [   25.555802] hdd: UDMA/66 mode selected
Feb 14 15:29:46 italy kernel: [   26.270428] EXT3 FS on dm-1, internal journal
Feb 14 15:29:46 italy kernel: [   26.683329] loop: module loaded
Feb 14 15:29:46 italy kernel: [   26.735440] Linux agpgart interface v0.103
Feb 14 15:29:46 italy kernel: [   26.785750] [drm] Initialized drm 1.1.0 20060810
Feb 14 15:29:46 italy kernel: [   26.822411] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 14 15:29:46 italy kernel: [   26.822693] [drm] Initialized radeon 1.29.0 20080528 on minor 0
Feb 14 15:29:46 italy kernel: [   28.699501] usb-storage: device scan complete
Feb 14 15:29:46 italy kernel: [   28.735488] scsi 1:0:0:0: Direct-Access     SAMSUNG  HD400LD          WQ10 PQ: 0 ANSI: 0
Feb 14 15:29:46 italy kernel: [   28.746429] sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Feb 14 15:29:46 italy kernel: [   28.760449] sd 1:0:0:0: [sdb] Write Protect is off
Feb 14 15:29:46 italy kernel: [   28.760519] sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 14 15:29:46 italy kernel: [   28.760571] sd 1:0:0:0: [sdb] Assuming drive cache: write through
Feb 14 15:29:46 italy kernel: [   28.771441] sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
Feb 14 15:29:46 italy kernel: [   28.785475] sd 1:0:0:0: [sdb] Write Protect is off
Feb 14 15:29:46 italy kernel: [   28.785547] sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 14 15:29:46 italy kernel: [   28.785598] sd 1:0:0:0: [sdb] Assuming drive cache: write through
Feb 14 15:29:46 italy kernel: [   28.785659]  sdb: sdb1
Feb 14 15:29:46 italy kernel: [   36.363310] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb 14 15:29:46 italy kernel: [   50.220759] kjournald starting.  Commit interval 5 seconds
Feb 14 15:29:46 italy kernel: [   50.238858] EXT3 FS on hda1, internal journal
Feb 14 15:29:46 italy kernel: [   50.238858] EXT3-fs: mounted filesystem with ordered data mode.
Feb 14 15:29:46 italy kernel: [   50.272187] kjournald starting.  Commit interval 5 seconds
Feb 14 15:29:46 italy kernel: [   50.284922] EXT3 FS on dm-3, internal journal
Feb 14 15:29:46 italy kernel: [   50.284922] EXT3-fs: mounted filesystem with ordered data mode.
Feb 14 15:29:46 italy kernel: [   50.404042] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   50.660039] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   50.904039] usb 4-5: reset high speed USB device using ehci_hcd and address 2
Feb 14 15:29:46 italy kernel: [   51.058149] kjournald starting.  Commit interval 5 seconds
Feb 14 15:29:46 italy kernel: [   51.058226] EXT3-fs: mounted filesystem with ordered data mode.
Feb 14 15:29:46 italy kernel: [   51.102432] Adding 2330616k swap on /dev/mapper/italy-swap_1.  Priority:-1 extents:1 across:2330616k

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=modules

nls_utf8 1760 0 - Live 0xf0c80000
isofs 28164 0 - Live 0xf0cbb000
zlib_inflate 14144 1 isofs, Live 0xf0c9b000
udf 67748 0 - Live 0xf0d07000
nls_base 6820 3 nls_utf8,isofs,udf, Live 0xf0c8f000
crc_itu_t 2080 1 udf, Live 0xf0ab5000
xt_multiport 2816 1 - Live 0xf0a62000
iptable_filter 2624 1 - Live 0xf0a43000
ip_tables 10160 1 iptable_filter, Live 0xf0c97000
x_tables 13284 2 xt_multiport,ip_tables, Live 0xf0c92000
binfmt_misc 7528 1 - Live 0xf0c88000
ppdev 6468 0 - Live 0xf0c85000
lp 8164 0 - Live 0xf0c82000
ipv6 235300 26 - Live 0xf0ccc000
radeon 118688 2 - Live 0xf0ad2000
drm 65256 3 radeon, Live 0xf0b49000
loop 12748 0 - Live 0xf0aab000
snd_bt87x 11268 0 - Live 0xf0ab1000
snd_ens1371 19072 1 - Live 0xf0a67000
gameport 10700 1 snd_ens1371, Live 0xf0a9f000
snd_ac97_codec 88484 1 snd_ens1371, Live 0xf0af0000
ac97_bus 1728 1 snd_ac97_codec, Live 0xf0a60000
snd_pcm_oss 32800 0 - Live 0xf0ab7000
snd_mixer_oss 12320 1 snd_pcm_oss, Live 0xf0a9a000
snd_pcm 62596 4 snd_bt87x,snd_ens1371,snd_ac97_codec,snd_pcm_oss, Live 0xf0ac1000
parport_pc 22500 1 - Live 0xf0aa4000
parport 30988 3 ppdev,lp,parport_pc, Live 0xf0a76000
serio_raw 4740 0 - Live 0xf0a64000
psmouse 32336 0 - Live 0xf0a6d000
via_ircc 15732 0 - Live 0xf09f0000
irda 95480 1 via_ircc, Live 0xf0a81000
snd_seq_dummy 2660 0 - Live 0xf09c8000
crc_ccitt 2080 1 irda, Live 0xf09e0000
i2c_viapro 6836 0 - Live 0xf0a5d000
pcspkr 2432 0 - Live 0xf092c000
tuner_simple 12080 1 - Live 0xf0a59000
tuner_types 13888 1 tuner_simple, Live 0xf09f6000
snd_seq_oss 24992 0 - Live 0xf0a51000
snd_seq_midi 5728 0 - Live 0xf09ca000
snd_rawmidi 18496 2 snd_ens1371,snd_seq_midi, Live 0xf0a3d000
tuner 21960 0 - Live 0xf0a36000
snd_seq_midi_event 6432 2 snd_seq_oss,snd_seq_midi, Live 0xf09db000
snd_seq 41456 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xf0a45000
tvaudio 19932 0 - Live 0xf0a08000
button 6096 0 - Live 0xf09d8000
snd_timer 17800 2 snd_pcm,snd_seq, Live 0xf09ea000
snd_seq_device 6380 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf0990000
snd 45604 13 snd_bt87x,snd_ens1371,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xf09fb000
bttv 148116 0 - Live 0xf0a10000
videodev 27520 2 tuner,bttv, Live 0xf09e2000
v4l1_compat 12260 1 videodev, Live 0xf09c4000
firmware_class 6816 1 bttv, Live 0xf09c1000
ir_common 39620 1 bttv, Live 0xf09cd000
compat_ioctl32 1312 1 bttv, Live 0xf095e000
soundcore 6368 1 snd, Live 0xf09be000
i2c_algo_bit 5188 1 bttv, Live 0xf09bb000
snd_page_alloc 7816 2 snd_bt87x,snd_pcm, Live 0xf0958000
v4l2_common 10240 3 tuner,tvaudio,bttv, Live 0xf0993000
videobuf_dma_sg 11140 1 bttv, Live 0xf09b7000
videobuf_core 16100 2 bttv,videobuf_dma_sg, Live 0xf09b2000
btcx_risc 4264 1 bttv, Live 0xf095b000
tveeprom 10980 1 bttv, Live 0xf098a000
i2c_core 19828 8 i2c_viapro,tuner_simple,tuner,tvaudio,bttv,i2c_algo_bit,v4l2_common,tveeprom, Live 0xf0960000
shpchp 25528 0 - Live 0xf0982000
pci_hotplug 23460 1 shpchp, Live 0xf097b000
via_agp 7744 1 - Live 0xf0941000
agpgart 28776 2 drm,via_agp, Live 0xf0972000
evdev 8000 4 - Live 0xf093e000
ext3 105512 5 - Live 0xf0997000
jbd 39444 1 ext3, Live 0xf0967000
mbcache 7108 1 ext3, Live 0xf0929000
sha256_generic 11360 0 - Live 0xf093a000
aes_i586 7744 2 - Live 0xf0937000
aes_generic 29256 1 aes_i586, Live 0xf092e000
cbc 3264 1 - Live 0xf0831000
sd_mod 22200 4 - Live 0xf08bd000
usb_storage 76032 2 - Live 0xf0944000
dm_crypt 11172 1 - Live 0xf08c9000
crypto_blkcipher 15236 3 cbc,dm_crypt, Live 0xf08c4000
dm_mirror 15104 0 - Live 0xf0883000
dm_log 8452 1 dm_mirror, Live 0xf0888000
dm_snapshot 14340 0 - Live 0xf0897000
dm_mod 46184 13 dm_crypt,dm_mirror,dm_log,dm_snapshot, Live 0xf08cf000
ide_cd_mod 27652 0 - Live 0xf08b5000
cdrom 30176 1 ide_cd_mod, Live 0xf088e000
ide_disk 10496 3 - Live 0xf085a000
ata_generic 4676 0 - Live 0xf085e000
libata 140384 1 ata_generic, Live 0xf0903000
scsi_mod 129356 3 sd_mod,usb_storage,libata, Live 0xf08e2000
dock 8304 1 libata, Live 0xf087f000
via82cxxx 6948 0 [permanent], Live 0xf0855000
ide_pci_generic 3908 0 [permanent], Live 0xf084c000
ide_core 96168 4 ide_cd_mod,ide_disk,via82cxxx,ide_pci_generic, Live 0xf089c000
uhci_hcd 18672 0 - Live 0xf084f000
ehci_hcd 28428 0 - Live 0xf0839000
ohci_hcd 18500 0 - Live 0xf0841000
usbcore 118160 5 usb_storage,uhci_hcd,ehci_hcd,ohci_hcd, Live 0xf0861000
8139too 20320 0 - Live 0xf082b000
8139cp 16800 0 - Live 0xf0833000
mii 4896 2 8139too,8139cp, Live 0xf0814000
thermal 15228 0 - Live 0xf081c000
processor 32576 2 thermal, Live 0xf0822000
fan 4164 0 - Live 0xf080d000
thermal_sys 10856 3 thermal,processor,fan, Live 0xf0810000

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=scsi

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SAMSUNG  Model: HD500LJ          Rev:     
  Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: SAMSUNG  Model: HD400LD          Rev: WQ10
  Type:   Direct-Access                    ANSI  SCSI revision: 00

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=iomem

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000cd000-000cffff : pnp 00:00
000f0000-000fffff : System ROM
00100000-2ffeffff : System RAM
  00100000-002ba4aa : Kernel code
  002ba4ab-0037661f : Kernel data
  003bc000-0041f57f : Kernel bss
2fff0000-2fff2fff : ACPI Non-volatile Storage
2fff3000-2fffffff : ACPI Tables
d0000000-d7ffffff : 0000:00:00.0
d8000000-e7ffffff : PCI Bus 0000:01
  d8000000-dfffffff : 0000:01:00.0
  e0000000-e7ffffff : 0000:01:00.1
e8000000-e9ffffff : PCI Bus 0000:01
  e8000000-e801ffff : 0000:01:00.0
  e9000000-e900ffff : 0000:01:00.0
  e9010000-e901ffff : 0000:01:00.1
ea000000-ea000fff : 0000:00:0a.0
  ea000000-ea000fff : bttv0
ea001000-ea001fff : 0000:00:0a.1
  ea001000-ea001fff : Bt87x audio
ea002000-ea0020ff : 0000:00:0b.0
  ea002000-ea0020ff : 8139too
ea003000-ea003fff : 0000:00:0c.0
  ea003000-ea003fff : ohci_hcd
ea004000-ea004fff : 0000:00:0c.1
  ea004000-ea004fff : ohci_hcd
ea005000-ea005fff : 0000:00:0c.2
  ea005000-ea005fff : ohci_hcd
ea006000-ea0060ff : 0000:00:0c.3
  ea006000-ea0060ff : ehci_hcd
ea007000-ea0070ff : 0000:00:10.3
  ea007000-ea0070ff : ehci_hcd
fee00000-fee00fff : pnp 00:00
fff80000-fffeffff : pnp 00:00
ffff0000-ffffffff : reserved

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
	Subsystem: Elitegroup Computer Systems Device 1841
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Capabilities: [a0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: agpgart-via
	Kernel modules: via-agp

00:01.0 PCI bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333 AGP] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: e8000000-e9ffffff
	Prefetchable memory behind bridge: d8000000-e7ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: shpchp

00:09.0 Multimedia audio controller: Ensoniq ES1371 [AudioPCI-97] (rev 06)
	Subsystem: Ensoniq Creative Sound Blaster AudioPCI64V, AudioPCI128
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (3000ns min, 32000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at d000 [size=64]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI+ D1- D2+ AuxCurrent=0mA PME(D0+,D1-,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ENS1371
	Kernel modules: snd-ens1371

00:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at ea000000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: bttv
	Kernel modules: bttv

00:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at ea001000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Bt87x
	Kernel modules: snd-bt87x

00:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RT8139
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at d400 [size=256]
	Region 1: Memory at ea002000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: 8139too
	Kernel modules: 8139cp, 8139too

00:0c.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at ea003000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:0c.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at ea004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:0c.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 11
	Region 0: Memory at ea005000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:0c.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: ALi Corporation Device 5272
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at ea006000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [58] Debug port: BAR=1 offset=0090
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 4: I/O ports at d800 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 10
	Region 4: I/O ports at dc00 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 11
	Region 4: I/O ports at e000 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82) (prog-if 20 [EHCI])
	Subsystem: VIA Technologies, Inc. USB 2.0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 11
	Region 0: Memory at ea007000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
	Subsystem: Elitegroup Computer Systems Device 1841
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: via-ircc, i2c-viapro

00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if 8a [Master SecP PriP])
	Subsystem: VIA Technologies, Inc. VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 10
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at e400 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: VIA_IDE
	Kernel modules: via82cxxx

01:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200 SE] (rev 01) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. ASUS Radeon 9200 SE / TD / 128M
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at c000 [size=256]
	Region 2: Memory at e9000000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at e8000000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
		Status: RQ=80 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: radeonfb

01:00.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 SE] (Secondary) (rev 01)
	Subsystem: ASUSTeK Computer Inc. Device c007
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at e0000000 (32-bit, prefetchable) [disabled] [size=128M]
	Region 1: Memory at e9010000 (32-bit, non-prefetchable) [disabled] [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cpuinfo

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 6
model		: 4
model name	: AMD Athlon(tm) processor
stepping	: 2
cpu MHz		: 930.687
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr syscall mmxext 3dnowext 3dnow up
bogomips	: 1863.87
clflush size	: 32
power management:


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ioports

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:11.1
  0170-0177 : VP_IDE
01f0-01f7 : 0000:00:11.1
  01f0-01f7 : VP_IDE
0290-0297 : pnp 00:03
02f8-02ff : serial
0376-0376 : 0000:00:11.1
  0376-0376 : VP_IDE
0378-037a : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:11.1
  03f6-03f6 : VP_IDE
03f8-03ff : serial
04d0-04d1 : pnp 00:03
0800-0805 : pnp 00:03
0cf8-0cff : PCI conf1
4000-407f : 0000:00:11.0
  4000-407f : pnp 00:02
    4000-4003 : ACPI PM1a_EVT_BLK
    4008-400b : ACPI PM_TMR
    4010-4015 : ACPI CPU throttle
    4020-4023 : ACPI GPE0_BLK
40f0-40f1 : ACPI PM1a_CNT_BLK
5000-500f : 0000:00:11.0
  5000-500f : pnp 00:02
    5000-5007 : vt596_smbus
c000-cfff : PCI Bus 0000:01
  c000-c0ff : 0000:01:00.0
d000-d03f : 0000:00:09.0
  d000-d03f : Ensoniq AudioPCI
d400-d4ff : 0000:00:0b.0
  d400-d4ff : 8139too
d800-d81f : 0000:00:10.0
  d800-d81f : uhci_hcd
dc00-dc1f : 0000:00:10.1
  dc00-dc1f : uhci_hcd
e000-e01f : 0000:00:10.2
  e000-e01f : uhci_hcd
e400-e40f : 0000:00:11.1
  e400-e40f : VP_IDE

--0F1p//8PRICkK4MW--
