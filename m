Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZBXA5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZBXA5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZBXA50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:57:26 -0500
Received: from smtp1.Stanford.EDU ([171.67.219.81]:36070 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZBXA5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:57:22 -0500
Subject: Re: [Announce] 2.6.29-rc6-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Content-Type: multipart/mixed; boundary="=-Pd14Ufqk2tsUg9cW5/z8"
Date: Mon, 23 Feb 2009 16:57:01 -0800
Message-Id: <1235437021.4462.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pd14Ufqk2tsUg9cW5/z8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Some feedback, just tried it in Fedora 9...

(BTW, in Fedora 9 'uname -r' adds a "-tip" component at the end of the
uname string which messes up loading modules, etc, and it is not
anywhere else to be seen - where is that coming from??)

Boots fine but does not last long:

------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x44/0x5c()
Hardware name: P5K/EPU
list_add corruption. prev->next should be next (f6042ab0), but was
(null). (prev=f415a670).
Modules linked in: fuse ip6table_filter ip6_tables iptable_raw
xt_comment xt_recent xt_policy ipt_ULOG ipt_TTL ipt_ttl ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_pkttype xt_physdev
xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark
xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
xt_dscp xt_dccp xt_CONNMARK xt_connmark xt_CLASSIFY iptable_nat nf_nat
iptable_mangle nfnetlink autofs4 coretemp w83627ehf hwmon_vid hwmon nfs
lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand acpi_cpufreq
dm_multipath radeon drm ipv6 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
pcspkr snd_cs8427 snd_ac97_codec serio_raw i2c_i801 ac97_bus snd_i2c
i2c_core iTCO_wdt ohci1394 snd_mpu401_uart iTCO_vendor_support
snd_rawmidi snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm joydev snd_timer sky2
snd soundcore snd_page_alloc [last unloaded: microcode]
Pid: 5844, comm: slogin Not tainted
2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE-tip #1
Call Trace:
 [<c0438765>] warn_slowpath+0x71/0xa8
 [<c048183a>] ? cpupri_set+0xdd/0xfb
 [<c042ace7>] ? update_curr+0x15f/0x167
 [<c0429dbd>] ? resched_task+0x33/0x6b
 [<c042ace7>] ? update_curr+0x15f/0x167
 [<c0543b28>] __list_add+0x44/0x5c
 [<c0440ef1>] internal_add_timer+0x88/0x8c
 [<c044159e>] __mod_timer+0xcc/0xde
 [<c04415c9>] mod_timer+0x19/0x1f
 [<c04415e3>] add_timer+0x14/0x16
 [<c068686e>] __nf_ct_refresh_acct+0x5b/0xdb
 [<c068a095>] tcp_packet+0xa78/0xa9f
 [<c06f0018>] ? topology_sysfs_init+0xf/0x51
 [<c06f263d>] ? __spin_lock_irqsave+0x30/0x39
 [<c0685cb3>] ? __nf_conntrack_find+0x64/0x7f
 [<c0687161>] nf_conntrack_in+0x394/0x407
 [<c06c003a>] ipv4_conntrack_local+0x32/0x3c
 [<c0684d83>] nf_iterate+0x2f/0x62
 [<c0692b30>] ? dst_output+0x0/0xb
 [<c0684ed7>] nf_hook_slow+0x42/0x9f
 [<c0692b30>] ? dst_output+0x0/0xb
 [<c06942c0>] __ip_local_out+0x87/0x91
 [<c0692b30>] ? dst_output+0x0/0xb
 [<c06942d5>] ip_local_out+0xb/0x1b
 [<c0694abe>] ip_queue_xmit+0x2b7/0x331
 [<c04b6dbb>] ? pollwake+0x0/0x55
 [<c042ace7>] ? update_curr+0x15f/0x167
 [<c06a3be9>] tcp_transmit_skb+0x5cb/0x602
 [<c06a5e35>] tcp_write_xmit+0x785/0x853
 [<c045716e>] ? rt_spin_lock_fastlock+0x27/0x5e
 [<c06f1fae>] ? rt_spin_lock+0xd/0xf
 [<c04a5cf0>] ? __kmalloc+0xb6/0xeb
 [<c06a5f50>] __tcp_push_pending_frames+0x21/0x56
 [<c0699cfd>] tcp_push+0x84/0x8a
 [<c069bd22>] tcp_sendmsg+0x6b0/0x75a
 [<c0661511>] __sock_sendmsg+0x45/0x4e
 [<c06615e8>] sock_aio_write+0xce/0xdb
 [<c0513e80>] ? inode_has_perm+0x58/0x62
 [<c04aab08>] do_sync_write+0xab/0xe9
 [<c05140ca>] ? file_has_perm+0x80/0x89
 [<c0449f77>] ? autoremove_wake_function+0x0/0x33
 [<c051063a>] ? security_file_permission+0xf/0x11
 [<c04ab336>] vfs_write+0x95/0xdf
 [<c04ab419>] sys_write+0x3b/0x60
 [<c0408bab>] sysenter_do_call+0x12/0x2c
---[ end trace 934e4b7ba06b93c0 ]---

Nfs/network stops working -> I have to reboot...
I'm attaching the full dmesg output of the test machine. 

-- Fernando


--=-Pd14Ufqk2tsUg9cW5/z8
Content-Disposition: attachment; filename=dmesg.1
Content-Type: text/plain; name=dmesg.1; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE-tip (mockbuild@=
planetforge.stanford.edu) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GC=
C) ) #1 SMP PREEMPT RT Mon Feb 23 17:24:08 EST 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cff80000 (usable)
 BIOS-e820: 00000000cff80000 - 00000000cff8e000 (ACPI data)
 BIOS-e820: 00000000cff8e000 - 00000000cffe0000 (ACPI NVS)
 BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
DMI 2.4 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn =3D 0x230000 max_arch_pfn =3D 0x1000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 377fe000 @ 10000-17000
NX (Execute Disable) protection: active
RAMDISK: 37d9b000 - 37fef6ea
Allocated new RAMDISK: 00100000 - 003546ea
Move RAMDISK from 0000000037d9b000 - 0000000037fef6e9 to 00100000 - 003546e=
9
ACPI: RSDP 000FBC10, 0014 (r0 ACPIAM)
ACPI: RSDT CFF80000, 003C (r1 A_M_I_ OEMRSDT   6000819 MSFT       97)
ACPI: FACP CFF80200, 0084 (r2 A_M_I_ OEMFACP   6000819 MSFT       97)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT CFF80440, 8B31 (r1  A0992 A0992015       15 INTL 20060113)
ACPI: FACS CFF8E000, 0040
ACPI: APIC CFF80390, 006C (r1 A_M_I_ OEMAPIC   6000819 MSFT       97)
ACPI: MCFG CFF80400, 003C (r1 A_M_I_ OEMMCFG   6000819 MSFT       97)
ACPI: OEMB CFF8E040, 0081 (r1 A_M_I_ AMI_OEM   6000819 MSFT       97)
ACPI: HPET CFF88F80, 0038 (r1 A_M_I_ OEMHPET   6000819 MSFT       97)
ACPI: OSFR CFF88FC0, 00B0 (r1 A_M_I_ OEMOSFR   6000819 MSFT       97)
ACPI: Local APIC address 0xfee00000
8072MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00013000 - 00019f00
(9 early reservations) =3D=3D> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [0000001000 - 00000=
02000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
07000]
  #3 [0000400000 - 0000a487cc]    TEXT DATA BSS =3D=3D> [0000400000 - 0000a=
487cc]
  #4 [0000a49000 - 0000a53000]    INIT_PG_TABLE =3D=3D> [0000a49000 - 0000a=
53000]
  #5 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000009fc00 - 00001=
00000]
  #6 [0000010000 - 0000013000]          PGTABLE =3D=3D> [0000010000 - 00000=
13000]
  #7 [0000100000 - 00003546ea]      NEW RAMDISK =3D=3D> [0000100000 - 00003=
546ea]
  #8 [0000013000 - 000001a000]          BOOTMAP =3D=3D> [0000013000 - 00000=
1a000]
found SMP MP-table at [c00ff780] ff780
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x00230000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000cff80
    0: 0x00100000 -> 0x00230000
On node 0 totalpages: 2096911
free_area_init_node: node 0, pgdat c087a1a0, node_mem_map c1000340
  DMA zone: 52 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3931 pages, LIFO batch:0
  Normal zone: 2834 pages used for memmap
  Normal zone: 220396 pages, LIFO batch:31
  HighMem zone: 26235 pages used for memmap
  HighMem zone: 1843463 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at d4000000 (gap: d0000000:2ee00000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 45056 bytes of per cpu data
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 206779=
0
Kernel command line: ro root=3DUUID=3D6897f47d-2c85-4530-94bb-b348325653ee =
rhgb quiet
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
NR_IRQS:1280
CPU 0 irqstacks, hard=3Dc0959000 soft=3Dc0939000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 2671.478 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
allocated 45874880 bytes of page_cgroup
please try cgroup_disable=3Dmemory option if you don't want
Memory: 8215344k/9175040k available (3032k kernel code, 171392k reserved, 1=
844k data, 404k init, 7478792k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc58000 - 0xfffff000   (3740 kB)
    pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc08c9000 - 0xc092e000   ( 404 kB)
      .data : 0xc06f6307 - 0xc08c34a0   (1844 kB)
      .text : 0xc0400000 - 0xc06f6307   (3032 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. =
5342.95 BogoMIPS (lpj=3D2671478)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Intel Performance Monitoring support detected.
... version:         2
... num counters:    2
... bit width:       40
... value mask:      000000ffffffffff
... mask length:     7
... fixed counters:  3
... counter mask:    0000000700000003
Checking 'hlt' instruction... OK.
ACPI: Core revision 20081204
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
CPU 1 irqstacks, hard=3Dc095a000 soft=3Dc093a000
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5343.00 BogoMIPS (lpj=3D26=
71500)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
CPU 2 irqstacks, hard=3Dc095b000 soft=3Dc093b000
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5343.02 BogoMIPS (lpj=3D26=
71513)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
CPU 3 irqstacks, hard=3Dc095c000 soft=3Dc093c000
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5343.02 BogoMIPS (lpj=3D26=
71514)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (21372.01 BogoMIPS).
sizeof(vma)=3D88 bytes
sizeof(page)=3D52 bytes
sizeof(inode)=3D476 bytes
sizeof(dentry)=3D156 bytes
sizeof(ext3inode)=3D648 bytes
sizeof(buffer_head)=3D112 bytes
sizeof(skbuff)=3D180 bytes
sizeof(task_struct)=3D3360 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-3 level CPU
   groups: 0-1 2-3
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-3 level CPU
   groups: 0-1 2-3
CPU2 attaching sched-domain:
 domain 0: span 2-3 level MC
  groups: 2 3
  domain 1: span 0-3 level CPU
   groups: 2-3 0-1
CPU3 attaching sched-domain:
 domain 0: span 2-3 level MC
  groups: 3 2
  domain 1: span 0-3 level CPU
   groups: 2-3 0-1
net_namespace: 1140 bytes
Booting paravirtualized kernel on bare hardware
regulator: core version 0.5
Time: 16:36:21  Date: 02/23/09
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D4
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0xb800-0xb81f]
pci 0000:00:1a.1: reg 20 io port: [0xb880-0xb89f]
pci 0000:00:1a.2: reg 20 io port: [0xbc00-0xbc1f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe8ffc00-0xfe8fffff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe8f8000-0xfe8fbfff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xb080-0xb09f]
pci 0000:00:1d.1: reg 20 io port: [0xb400-0xb41f]
pci 0000:00:1d.2: reg 20 io port: [0xb480-0xb49f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe8ff800-0xfe8ffbff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
pci 0000:00:1f.2: reg 10 io port: [0xa000-0xa007]
pci 0000:00:1f.2: reg 14 io port: [0x9c00-0x9c03]
pci 0000:00:1f.2: reg 18 io port: [0x9880-0x9887]
pci 0000:00:1f.2: reg 1c io port: [0x9800-0x9803]
pci 0000:00:1f.2: reg 20 io port: [0x9480-0x948f]
pci 0000:00:1f.2: reg 24 io port: [0x9400-0x940f]
pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe8ff400-0xfe8ff4ff]
pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
pci 0000:00:1f.5: reg 10 io port: [0xb000-0xb007]
pci 0000:00:1f.5: reg 14 io port: [0xac00-0xac03]
pci 0000:00:1f.5: reg 18 io port: [0xa880-0xa887]
pci 0000:00:1f.5: reg 1c io port: [0xa800-0xa803]
pci 0000:00:1f.5: reg 20 io port: [0xa480-0xa48f]
pci 0000:00:1f.5: reg 24 io port: [0xa400-0xa40f]
pci 0000:01:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:01:00.0: reg 18 64bit mmio: [0xfe9e0000-0xfe9effff]
pci 0000:01:00.0: reg 20 io port: [0xc000-0xc0ff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfe9c0000-0xfe9dffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 64bit mmio: [0xfe9f0000-0xfe9fffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it=
 with 'pcie_aspm=3Dforce'
pci 0000:00:01.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:01.0: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
pci 0000:02:00.0: reg 10 64bit mmio: [0xfeafc000-0xfeafffff]
pci 0000:02:00.0: reg 18 io port: [0xd800-0xd8ff]
pci 0000:02:00.0: reg 30 32bit mmio: [0xfeac0000-0xfeadffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.5: bridge io port: [0xd000-0xdfff]
pci 0000:00:1c.5: bridge 32bit mmio: [0xfea00000-0xfeafffff]
pci 0000:04:02.0: reg 10 io port: [0xec00-0xec1f]
pci 0000:04:02.0: reg 14 io port: [0xe880-0xe88f]
pci 0000:04:02.0: reg 18 io port: [0xe800-0xe80f]
pci 0000:04:02.0: reg 1c io port: [0xe480-0xe4bf]
pci 0000:04:02.0: supports D2
pci 0000:04:03.0: reg 10 32bit mmio: [0xfebff800-0xfebfffff]
pci 0000:04:03.0: reg 14 io port: [0xe400-0xe47f]
pci 0000:04:03.0: supports D2
pci 0000:04:03.0: PME# supported from D2 D3hot D3cold
pci 0000:04:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disable=
d.
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI Warning (tbutils-0242): Incorrect checksum in table [OEMB] - 77, shoul=
d be 76 [20081204]
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
system 00:06: ioport range 0x290-0x297 has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x800-0x87f has been reserved
system 00:07: ioport range 0x480-0x4bf has been reserved
system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
system 00:07: iomem range 0xffa00000-0xffafffff has been reserved
system 00:07: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:07: iomem range 0xffe00000-0xffefffff has been reserved
system 00:07: iomem range 0xfff00000-0xfffffffe has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0xc0000-0xcffff could not be reserved
system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
system 00:0e: iomem range 0x100000-0xcfffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xc000-0xcfff
pci 0000:00:01.0:   MEM window: 0xfe900000-0xfe9fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
pci 0000:00:1c.5:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
pci 0000:00:1e.0:   IO window: 0xe000-0xefff
pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:01: resource 1 mem: [0xfe900000-0xfe9fffff]
pci_bus 0000:01: resource 2 mem: [0xd0000000-0xdfffffff]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 mem: [0x0-0x0]
pci_bus 0000:03: resource 1 mem: [0x0-0x0]
pci_bus 0000:03: resource 2 mem: [0xfdf00000-0xfdffffff]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
pci_bus 0000:02: resource 2 mem: [0x0-0x0]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:04: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:04: resource 1 mem: [0xfeb00000-0xfebfffff]
pci_bus 0000:04: resource 2 mem: [0x0-0x0]
pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 2385k freed
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=3D2000 audit(1235406980.549:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1445
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input=
/input1
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT CFF8E0D0, 01D2 (r1    AMI   CPU1PM        1 INTL 20060113)
processor ACPI_CPU:00: registered as cooling_device0
ACPI: SSDT CFF8E2B0, 0143 (r1    AMI   CPU2PM        1 INTL 20060113)
processor ACPI_CPU:01: registered as cooling_device1
ACPI: SSDT CFF8E400, 0143 (r1    AMI   CPU3PM        1 INTL 20060113)
processor ACPI_CPU:02: registered as cooling_device2
ACPI: SSDT CFF8E550, 0143 (r1    AMI   CPU4PM        1 INTL 20060113)
processor ACPI_CPU:03: registered as cooling_device3
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
input: Macintosh mouse button emulation as /devices/virtual/input/input2
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 22 (level, low) -> IRQ 22
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 22
ata2: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488 irq 22
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD5000YS-01MPB0, 09.02E09, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000YS-01M 09.0 PQ: 0 ANSI: =
5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-6: ST380817AS, 3.42, max UDMA/133
ata2.00: 156301488 sectors, multi 16: LBA48 NCQ (not used)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST380817AS       3.42 PQ: 0 ANSI: =
5
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ata_piix 0000:00:1f.5: PCI INT B -> GSI 22 (level, low) -> IRQ 22
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480 irq 22
ata4: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488 irq 22
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATAPI: Optiarc DVD RW AD-7190S, 1.01, max UDMA/100
ata4.00: configured for UDMA/100
scsi 3:0:0:0: CD-ROM            Optiarc  DVD RW AD-7190S  1.01 PQ: 0 ANSI: =
5
sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg2 type 5
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe8ffc00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE=
-tip ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe8ff800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE=
-tip ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b800
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE=
-tip uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE=
-tip uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000bc00
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE=
-tip uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b080
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE=
-tip uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
usb usb7: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb7: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE=
-tip uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
usb usb8: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb8: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE=
-tip uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redha=
t.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=3D1 kernel paramater, acct=3D1 nf_conntrack module option=
 or
sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
  Magic number: 13:979:641
***************************************************************************=
**
*                                                                          =
 *
*  REMINDER, the following debugging option is turned on in your .config:  =
 *
*                                                                          =
 *
*        CONFIG_IRQSOFF_TRACER                                             =
 *
*                                                                          =
 *
*  it may increase runtime overhead and latencies.                         =
 *
*                                                                          =
 *
***************************************************************************=
**
Freeing unused kernel memory: 404k freed
Write protecting the kernel text: 3036k
Write protecting the kernel read-only data: 1344k
usb 3-1: new low speed USB device using uhci_hcd and address 2
usb 3-1: New USB device found, idVendor=3D046d, idProduct=3Dc518
usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-1: Product: USB Receiver
usb 3-1: Manufacturer: Logitech
usb 3-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3=
-1:1.0/input/input3
generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11 Mouse [Logite=
ch USB Receiver] on usb-0000:00:1a.0-1/input0
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3=
-1:1.1/input/input4
generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB HID v1.11 Devi=
ce [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
usb 3-2: new low speed USB device using uhci_hcd and address 3
usb 3-2: New USB device found, idVendor=3D045e, idProduct=3D00db
usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-2: Product: Natural=AE Ergonomic Keyboard 4000
usb 3-2: Manufacturer: Microsoft
usb 3-2: configuration #1 chosen from 1 choice
input: Microsoft Natural=AE Ergonomic Keyboard 4000 as /devices/pci0000:00/=
0000:00:1a.0/usb3/3-2/3-2:1.0/input/input5
microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID v1.11 Keyboard [Micro=
soft Natural=AE Ergonomic Keyboard 4000] on usb-0000:00:1a.0-2/input0
input: Microsoft Natural=AE Ergonomic Keyboard 4000 as /devices/pci0000:00/=
0000:00:1a.0/usb3/3-2/3-2:1.1/input/input6
microsoft 0003:045E:00DB.0004: input,hidraw3: USB HID v1.11 Device [Microso=
ft Natural=AE Ergonomic Keyboard 4000] on usb-0000:00:1a.0-2/input1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: 8192 avtab hash slots, 178327 rules.
SELinux: 8192 avtab hash slots, 178327 rules.
SELinux:  8 users, 12 roles, 2433 types, 119 bools, 1 sens, 1024 cats
SELinux:  73 classes, 178327 rules
SELinux:  class kernel_service not defined in policy
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_cont=
exts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=3D1403 audit(1235406986.598:2): policy loaded auid=3D4294967295 ses=3D=
4294967295
sky2 driver version 1.22
sky2 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:02:00.0: setting latency timer to 64
sky2 0000:02:00.0: Yukon-2 EC Ultra chip revision 3
sky2 0000:02:00.0: Marvell Yukon 88E8056 Gigabit Ethernet Controller
 Part Number: Yukon 88E8056
 Engineering Level: Rev. 1.2
 Manufacturer: Marvell
sky2 eth0: addr 00:1f:c6:42:c3:fc
iTCO_vendor_support: vendor-support=3D0
ohci1394 0000:04:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH9 TCO device (Version=3D2, TCOBASE=3D0x0860)
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SM=
RG [0x400-0x40f]
ACPI: Device needs an ACPI driver
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[16]  MMIO=3D[febff800-febff=
fff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
input: PC Speaker as /devices/platform/pcspkr/input/input7
ICE1712 0000:04:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ALSA sound/pci/hda/hda_codec.c:3503: autoconfig: line_outs=3D4 (0x14/0x15/0=
x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:3507:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0=
x0)
ALSA sound/pci/hda/hda_codec.c:3511:    hp_outs=3D1 (0x1b/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3512:    mono: mono_out=3D0x0
ALSA sound/pci/hda/hda_codec.c:3520:    inputs: mic=3D0x18, fmic=3D0x19, li=
ne=3D0x1a, fline=3D0x0, cd=3D0x0, aux=3D0x0
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c000125477b]
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:01:00.0: setting latency timer to 64
[drm] Initialized radeon 1.29.0 20080528 on minor 0
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
mtrr: type mismatch for d0000000,8000000 old: write-back new: write-combini=
ng
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
[drm] Setting GART location based on new memory map
[drm] Loading R400 Microcode
[drm] Num pipes: 3
[drm] writeback test succeeded in 1 usecs
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda3, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda5, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda6, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
swap_cgroup: uses 4004 bytes of vmalloc for pointer array space and 4100096=
 bytes to hold mem_cgroup pointers on swap
swap_cgroup can be disabled by noswapaccount boot option.
Adding 4096564k swap on /dev/sda2.  Priority:-1 extents:1 across:4096564k=20
swap_cgroup: uses 4004 bytes of vmalloc for pointer array space and 4100096=
 bytes to hold mem_cgroup pointers on swap
swap_cgroup can be disabled by noswapaccount boot option.
Adding 4096564k swap on /dev/sdb2.  Priority:-2 extents:1 across:4096564k=20
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contex=
ts
platform microcode: firmware: requesting intel-ucode/06-17-07
platform microcode: firmware: requesting intel-ucode/06-17-07
platform microcode: firmware: requesting intel-ucode/06-17-07
platform microcode: firmware: requesting intel-ucode/06-17-07
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Microcode Update Driver: v2.00 removed.
sky2 eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control rx
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be=
 insecure.
SELinux: initialized (dev 0:14, type nfs), uses genfs_contexts
w83627ehf: Found W83627DHG chip at 0x290
ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region HWRE =
[0x290-0x299]
ACPI: Device needs an ACPI driver
coretemp coretemp.0: Using relative temperature scale!
coretemp coretemp.1: Using relative temperature scale!
coretemp coretemp.2: Using relative temperature scale!
coretemp coretemp.3: Using relative temperature scale!
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
Netfilter messages via NETLINK v0.30.
ctnetlink v0.93: registering with nfnetlink.
ClusterIP Version 0.8 loaded successfully
eth0: no IPv6 routers present
ip6_tables: (C) 2000-2006 Netfilter Core Team
[drm] Num pipes: 3
mtrr: no MTRR for d0000000,8000000 found
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
mtrr: type mismatch for d0000000,8000000 old: write-back new: write-combini=
ng
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combin=
ing
[drm] Setting GART location based on new memory map
[drm] Loading R400 Microcode
[drm] Num pipes: 3
[drm] writeback test succeeded in 1 usecs
[drm] Num pipes: 3
[drm] Loading R400 Microcode
[drm] Num pipes: 3
SELinux: initialized (dev 0:10, type nfs), uses genfs_contexts
fuse init (API version 7.11)
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x44/0x5c()
Hardware name: P5K/EPU
list_add corruption. prev->next should be next (f6042ab0), but was (null). =
(prev=3Df415a670).
Modules linked in: fuse ip6table_filter ip6_tables iptable_raw xt_comment x=
t_recent xt_policy ipt_ULOG ipt_TTL ipt_ttl ipt_REDIRECT ipt_NETMAP ipt_MAS=
QUERADE ipt_LOG ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tf=
tp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_=
nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_t=
ftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack=
_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf=
_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_pkttype xt_physdev xt_owner x=
t_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_lim=
it xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_C=
ONNMARK xt_connmark xt_CLASSIFY iptable_nat nf_nat iptable_mangle nfnetlink=
 autofs4 coretemp w83627ehf hwmon_vid hwmon nfs lockd nfs_acl auth_rpcgss s=
unrpc cpufreq_ondemand acpi_cpufreq dm_multipath radeon drm ipv6 snd_hda_co=
dec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_a=
k4xxx snd_ak4xxx_adda pcspkr snd_cs8427 snd_ac97_codec serio_raw i2c_i801 a=
c97_bus snd_i2c i2c_core iTCO_wdt ohci1394 snd_mpu401_uart iTCO_vendor_supp=
ort snd_rawmidi snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_se=
q_device snd_pcm_oss snd_mixer_oss snd_pcm joydev snd_timer sky2 snd soundc=
ore snd_page_alloc [last unloaded: microcode]
Pid: 5844, comm: slogin Not tainted 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686=
.rtPAE-tip #1
Call Trace:
 [<c0438765>] warn_slowpath+0x71/0xa8
 [<c048183a>] ? cpupri_set+0xdd/0xfb
 [<c042ace7>] ? update_curr+0x15f/0x167
 [<c0429dbd>] ? resched_task+0x33/0x6b
 [<c042ace7>] ? update_curr+0x15f/0x167
 [<c0543b28>] __list_add+0x44/0x5c
 [<c0440ef1>] internal_add_timer+0x88/0x8c
 [<c044159e>] __mod_timer+0xcc/0xde
 [<c04415c9>] mod_timer+0x19/0x1f
 [<c04415e3>] add_timer+0x14/0x16
 [<c068686e>] __nf_ct_refresh_acct+0x5b/0xdb
 [<c068a095>] tcp_packet+0xa78/0xa9f
 [<c06f0018>] ? topology_sysfs_init+0xf/0x51
 [<c06f263d>] ? __spin_lock_irqsave+0x30/0x39
 [<c0685cb3>] ? __nf_conntrack_find+0x64/0x7f
 [<c0687161>] nf_conntrack_in+0x394/0x407
 [<c06c003a>] ipv4_conntrack_local+0x32/0x3c
 [<c0684d83>] nf_iterate+0x2f/0x62
 [<c0692b30>] ? dst_output+0x0/0xb
 [<c0684ed7>] nf_hook_slow+0x42/0x9f
 [<c0692b30>] ? dst_output+0x0/0xb
 [<c06942c0>] __ip_local_out+0x87/0x91
 [<c0692b30>] ? dst_output+0x0/0xb
 [<c06942d5>] ip_local_out+0xb/0x1b
 [<c0694abe>] ip_queue_xmit+0x2b7/0x331
 [<c04b6dbb>] ? pollwake+0x0/0x55
 [<c042ace7>] ? update_curr+0x15f/0x167
 [<c06a3be9>] tcp_transmit_skb+0x5cb/0x602
 [<c06a5e35>] tcp_write_xmit+0x785/0x853
 [<c045716e>] ? rt_spin_lock_fastlock+0x27/0x5e
 [<c06f1fae>] ? rt_spin_lock+0xd/0xf
 [<c04a5cf0>] ? __kmalloc+0xb6/0xeb
 [<c06a5f50>] __tcp_push_pending_frames+0x21/0x56
 [<c0699cfd>] tcp_push+0x84/0x8a
 [<c069bd22>] tcp_sendmsg+0x6b0/0x75a
 [<c0661511>] __sock_sendmsg+0x45/0x4e
 [<c06615e8>] sock_aio_write+0xce/0xdb
 [<c0513e80>] ? inode_has_perm+0x58/0x62
 [<c04aab08>] do_sync_write+0xab/0xe9
 [<c05140ca>] ? file_has_perm+0x80/0x89
 [<c0449f77>] ? autoremove_wake_function+0x0/0x33
 [<c051063a>] ? security_file_permission+0xf/0x11
 [<c04ab336>] vfs_write+0x95/0xdf
 [<c04ab419>] sys_write+0x3b/0x60
 [<c0408bab>] sysenter_do_call+0x12/0x2c
---[ end trace 934e4b7ba06b93c0 ]---
nfs: server cm-meho not responding, still trying

--=-Pd14Ufqk2tsUg9cW5/z8--

