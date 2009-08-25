Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZHYRjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZHYRjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZHYRjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:39:35 -0400
Received: from vcvps1089.vcdns.de ([88.80.200.131]:60379 "EHLO
	vcvps1089.vcdns.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbZHYRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:39:33 -0400
X-Greylist: delayed 801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 13:39:32 EDT
Message-ID: <4A941E8B.8080902@plzk.org>
Date: Tue, 25 Aug 2009 19:25:31 +0200
From: mailing54 <mailing54@plzk.org>
Reply-To: mailing54@plzk.org
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31-rc7
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------030403050605030504010102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030403050605030504010102
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I am far away from being a coder or a kernel geek, so bear with me if I 
can not provide all information on first try.

Unlike rc6, this rc (rc7) does not boot correctly on my Macbook 2.1. I 
am using amd64 kernel-debs provided by Ubuntu on 
http://kernel.ubuntu.com/~kernel-ppa/mainline/.

During boot with rc7, I can unlock my encrypted volumes just fine. After 
that, boot continues till suddenly screen goes black. I can not tell if 
the whole thing hangs or just the screen dies, but I can tell that the 
only way to get out of that limbo seems to be the power button. Again, 
everything seems to work flawless with rc6 Ubuntu deb.

Assuming that dmesg output of rc6 and rc7 should look kinda similar, I 
tried to narrow the problem down to the following part in the output of rc6:



[   21.193733] cfg80211: Regulatory domain changed to country: AT
[   21.193737]     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   21.193740]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.193742]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.193745]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.193747]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   21.707177] lp: driver loaded but no devices found
[   21.913101] Adding 2097144k swap on /dev/mapper/vgencrypted-swap.  
Priority:-1 extents:1 across:2097144k
[   22.485747] EXT3 FS on dm-1, internal journal
[   23.482830] kjournald starting.  Commit interval 5 seconds
[   23.483105] EXT3 FS on sda4, internal journal
[   23.483109] EXT3-fs: mounted filesystem with writeback data mode.
[   23.628917] SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
[   23.630731] SGI XFS Quota Management subsystem
[   23.688751] XFS mounting filesystem dm-3
[   24.004942] Ending clean XFS mount for filesystem: dm-3
[   24.844066] HDA Intel 0000:00:1b.0: PCI INT A disabled
[   24.853007] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[   24.853046] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   24.920161] hda_codec: STAC922x, Apple subsys_id=106b2200
[   25.902474] ppdev: user-space parallel port driver
[   30.269237] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   30.543459] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 
64 rq 0 len 0 ret -84
[   30.555027] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   30.555030] Bluetooth: BNEP filters: protocol multicast
[   30.591724] Bridge firewalling registered
[   30.816130] usb 5-1: USB disconnect, address 2
[   31.116057] usb 5-1: new full speed USB device using uhci_hcd and 
address 3
[   31.309153] usb 5-1: configuration #1 chosen from 1 choice
[   31.337641] Bluetooth: Generic Bluetooth USB driver ver 0.5
[   31.338153] usbcore: registered new interface driver btusb
[   33.876059] [drm] Initialized drm 1.1.0 20060810
[   33.898991] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   33.898997] pci 0000:00:02.0: setting latency timer to 64
[   33.908179] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on 
minor 0
[   34.129469] render error detected, EIR: 0x00000010
[   34.129475] page table error
[   34.129477]   PGTBL_ER: 0x00000102
[   34.129480] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, 
masking
[   34.129487] render error detected, EIR: 0x00000010
[   34.129489] page table error
[   34.129490]   PGTBL_ER: 0x00000102
[   34.408721] sky2 eth0: enabling interface
[   34.409131] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   36.660303] ADDRCONF(NETDEV_UP): wlan0: link is not ready



(complete dmesg attached)

I think the problem must be somewhere in here because when booting rc7 
(in rescue mode), the last thing I can see before all goes black is the 
frequency table shown in the first lines of the quoted section. (Also, 
there are scary-looking errors near the end ;) )


/proc/version/
Linux version 2.6.31-020631rc6-generic (root@zinc) (gcc version 4.2.3 
(Ubuntu 4.2.3-2ubuntu7)) #020631rc6 SMP Fri Aug 14 09:04:48 UTC 2009


Please let me know what further info is needed.

Regards,

Tobias

--------------030403050605030504010102
Content-Type: text/plain;
 name="dmesgout"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesgout"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-020631rc6-generic (root@zinc) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #020631rc6 SMP Fri Aug 14 09:04:48 UTC 2009
[    0.000000] Command line: root=/dev/mapper/vgencrypted-sysroot ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007e0f8000 (usable)
[    0.000000]  BIOS-e820: 000000007e0f8000 - 000000007e2f9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007e2f9000 - 000000007eebe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007eebe000 - 000000007eeef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007eeef000 - 000000007ef00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ef00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7e0f8 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 07F000000 mask FFF000000 uncachable
[    0.000000]   3 base 07EF00000 mask FFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007e0f8000 (usable)
[    0.000000]  modified: 000000007e0f8000 - 000000007e2f9000 (ACPI NVS)
[    0.000000]  modified: 000000007e2f9000 - 000000007eebe000 (ACPI data)
[    0.000000]  modified: 000000007eebe000 - 000000007eeef000 (ACPI NVS)
[    0.000000]  modified: 000000007eeef000 - 000000007ef00000 (ACPI data)
[    0.000000]  modified: 000000007ef00000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007e0f8000
[    0.000000]  0000000000 - 007e000000 page 2M
[    0.000000]  007e000000 - 007e0f8000 page 4k
[    0.000000] kernel direct mapping tables up to 7e0f8000 @ 8000-c000
[    0.000000] RAMDISK: 37774000 - 37fef004
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000007eefd1c0 00074 (v01 APPLE   Apple00 000000A5      01000013)
[    0.000000] ACPI: FACP 000000007eefb000 000F4 (v03 APPLE   Apple00 000000A5 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000007eef0000 041E4 (v01 APPLE   MacBook 00020001 INTL 20050309)
[    0.000000] ACPI: FACS 000000007eec0000 00040
[    0.000000] ACPI: HPET 000000007eefa000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000007eef9000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: MCFG 000000007eef8000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ASF! 000000007eef7000 000A0 (v32 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000007eef6000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000007eef5000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000007eeef000 004DC (v01 APPLE     CpuPm 00003000 INTL 20050309)
[    0.000000] ACPI: SSDT 000000007eebd000 0064F (v01 SataRe  SataPri 00001000 INTL 20050309)
[    0.000000] ACPI: SSDT 000000007eebc000 0069C (v01 SataRe  SataSec 00001000 INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 007e0f8000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001a508cc]    TEXT DATA BSS ==> [0001000000 - 0001a508cc]
[    0.000000]   #3 [0037774000 - 0037fef004]          RAMDISK ==> [0037774000 - 0037fef004]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0001a51000 - 0001a51265]              BRK ==> [0001a51000 - 0001a51265]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002000000-ffff880003bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007e0f8
[    0.000000] On node 0 totalpages: 516242
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 101 pages reserved
[    0.000000]   DMA zone: 3837 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7004 pages used for memmap
[    0.000000]   DMA32 zone: 505244 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages at ffff880001a62000, static data 89632 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 509081
[    0.000000] Kernel command line: root=/dev/mapper/vgencrypted-sysroot ro quiet splash 
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2012864k/2065376k available (5030k kernel code, 408k absent, 51380k reserved, 3376k data, 548k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] NR_IRQS:2304
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using PMTIMER reference calibration
[    0.000000] Detected 1994.995 MHz processor.
[    0.001391] Console: colour VGA+ 80x25
[    0.001395] console [tty0] enabled
[    0.004000] allocated 20971520 bytes of page_cgroup
[    0.004000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.99 BogoMIPS (lpj=7979980)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] Performance Counters: Core2 events, Intel PMU driver.
[    0.004000] ... version:                 2
[    0.004000] ... bit width:               40
[    0.004000] ... generic counters:        2
[    0.004000] ... value mask:              000000ffffffffff
[    0.004000] ... max period:              000000007fffffff
[    0.004000] ... fixed-purpose counters:  3
[    0.004000] ... counter mask:            0000000700000003
[    0.004000] ACPI: Core revision 20090521
[    0.010903] Setting APIC routing to flat
[    0.011487] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.051181] CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
[    0.052001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 3990.05 BogoMIPS (lpj=7980103)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.136849] CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
[    0.136860] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.140127] Brought up 2 CPUs
[    0.140130] Total of 2 processors activated (7980.04 BogoMIPS).
[    0.140187] CPU0 attaching sched-domain:
[    0.140191]  domain 0: span 0-1 level MC
[    0.140193]   groups: 0 1
[    0.140200] CPU1 attaching sched-domain:
[    0.140202]  domain 0: span 0-1 level MC
[    0.140205]   groups: 1 0
[    0.140296] Booting paravirtualized kernel on bare hardware
[    0.140398] regulator: core version 0.5
[    0.140398] Time: 15:51:53  Date: 08/25/09
[    0.140398] NET: Registered protocol family 16
[    0.140398] ACPI: bus type pci registered
[    0.140398] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
[    0.140398] PCI: MCFG area at f0000000 reserved in E820
[    0.140398] PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.141120] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.141122] PCI: Using configuration type 1 for base access
[    0.142062] bio: create slab <bio-0> at 0
[    0.144546] ACPI: EC: EC description table is found, configuring boot EC
[    0.144677] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.153529] ACPI: BIOS _OSI(Linux) query ignored
[    0.154067] ACPI: Interpreter enabled
[    0.154071] ACPI: (supports S0 S3 S4 S5)
[    0.154096] ACPI: Using IOAPIC for interrupt routing
[    0.162476] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.162476] ACPI: EC: driver started in interrupt mode
[    0.164175] ACPI: No dock devices found.
[    0.165011] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.165117] pci 0000:00:02.0: reg 10 32bit mmio: [0x90380000-0x903fffff]
[    0.165123] pci 0000:00:02.0: reg 14 io port: [0x20e0-0x20e7]
[    0.165129] pci 0000:00:02.0: reg 18 32bit mmio: [0x80000000-0x8fffffff]
[    0.165135] pci 0000:00:02.0: reg 1c 32bit mmio: [0x90400000-0x9043ffff]
[    0.165181] pci 0000:00:02.1: reg 10 32bit mmio: [0x90300000-0x9037ffff]
[    0.165246] pci 0000:00:07.0: reg 10 32bit mmio: [0x90444000-0x90444fff]
[    0.165355] pci 0000:00:1b.0: reg 10 64bit mmio: [0x90440000-0x90443fff]
[    0.165420] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.165425] pci 0000:00:1b.0: PME# disabled
[    0.165514] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.165520] pci 0000:00:1c.0: PME# disabled
[    0.165611] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.165617] pci 0000:00:1c.1: PME# disabled
[    0.165690] pci 0000:00:1d.0: reg 20 io port: [0x2080-0x209f]
[    0.165759] pci 0000:00:1d.1: reg 20 io port: [0x2060-0x207f]
[    0.165828] pci 0000:00:1d.2: reg 20 io port: [0x2040-0x205f]
[    0.165896] pci 0000:00:1d.3: reg 20 io port: [0x2020-0x203f]
[    0.165969] pci 0000:00:1d.7: reg 10 32bit mmio: [0x90445400-0x904457ff]
[    0.166036] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.166042] pci 0000:00:1d.7: PME# disabled
[    0.166217] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.166222] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.166227] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    0.166232] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
[    0.166239] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
[    0.166294] pci 0000:00:1f.1: reg 10 io port: [0x20d8-0x20df]
[    0.166303] pci 0000:00:1f.1: reg 14 io port: [0x20f4-0x20f7]
[    0.166312] pci 0000:00:1f.1: reg 18 io port: [0x20d0-0x20d7]
[    0.166320] pci 0000:00:1f.1: reg 1c io port: [0x20f0-0x20f3]
[    0.166329] pci 0000:00:1f.1: reg 20 io port: [0x20b0-0x20bf]
[    0.166389] pci 0000:00:1f.2: reg 10 io port: [0x20c8-0x20cf]
[    0.166398] pci 0000:00:1f.2: reg 14 io port: [0x20ec-0x20ef]
[    0.166407] pci 0000:00:1f.2: reg 18 io port: [0x20c0-0x20c7]
[    0.166415] pci 0000:00:1f.2: reg 1c io port: [0x20e8-0x20eb]
[    0.166424] pci 0000:00:1f.2: reg 20 io port: [0x20a0-0x20af]
[    0.166433] pci 0000:00:1f.2: reg 24 32bit mmio: [0x90445000-0x904453ff]
[    0.166464] pci 0000:00:1f.2: PME# supported from D3hot
[    0.166470] pci 0000:00:1f.2: PME# disabled
[    0.166535] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.166662] pci 0000:01:00.0: reg 10 64bit mmio: [0x90200000-0x90203fff]
[    0.166674] pci 0000:01:00.0: reg 18 io port: [0x1000-0x10ff]
[    0.166711] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.166768] pci 0000:01:00.0: supports D1 D2
[    0.166770] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.166777] pci 0000:01:00.0: PME# disabled
[    0.166847] pci 0000:00:1c.0: bridge io port: [0x1000-0x1fff]
[    0.166853] pci 0000:00:1c.0: bridge 32bit mmio: [0x90200000-0x902fffff]
[    0.166934] pci 0000:02:00.0: reg 10 64bit mmio: [0x90100000-0x9010ffff]
[    0.167028] pci 0000:02:00.0: supports D1
[    0.167031] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.167037] pci 0000:02:00.0: PME# disabled
[    0.167123] pci 0000:00:1c.1: bridge 32bit mmio: [0x90100000-0x901fffff]
[    0.167181] pci 0000:03:03.0: reg 10 32bit mmio: [0x90000000-0x90000fff]
[    0.167246] pci 0000:03:03.0: supports D1 D2
[    0.167249] pci 0000:03:03.0: PME# supported from D0 D1 D2 D3hot
[    0.167254] pci 0000:03:03.0: PME# disabled
[    0.167320] pci 0000:00:1e.0: transparent bridge
[    0.167328] pci 0000:00:1e.0: bridge 32bit mmio: [0x90000000-0x900fffff]
[    0.167357] pci_bus 0000:00: on NUMA node 0
[    0.167363] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.167585] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.167674] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.167782] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.174907] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.175024] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.175137] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.175249] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.175362] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.175479] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.175595] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.175709] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.175890] SCSI subsystem initialized
[    0.175916] libata version 3.00 loaded.
[    0.176033] usbcore: registered new interface driver usbfs
[    0.176051] usbcore: registered new interface driver hub
[    0.176071] usbcore: registered new device driver usb
[    0.176074] ACPI: WMI: Mapper loaded
[    0.176074] PCI: Using ACPI for IRQ routing
[    0.188010] Bluetooth: Core ver 2.15
[    0.188028] NET: Registered protocol family 31
[    0.188028] Bluetooth: HCI device and connection manager initialized
[    0.188028] Bluetooth: HCI socket layer initialized
[    0.188028] NET: Registered protocol family 8
[    0.188028] NET: Registered protocol family 20
[    0.188044] NetLabel: Initializing
[    0.188046] NetLabel:  domain hash size = 128
[    0.188048] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.188064] NetLabel:  unlabeled traffic allowed by default
[    0.188119] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.188125] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.204014] pnp: PnP ACPI init
[    0.204027] ACPI: bus type pnp registered
[    0.205740] pnp 00:07: io resource (0x1640-0x164f) overlaps 0000:00:1c.0 BAR 7 (0x1000-0x1fff), disabling
[    0.206509] pnp: PnP ACPI: found 9 devices
[    0.206512] ACPI: ACPI bus type pnp unregistered
[    0.206524] system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.206528] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.206532] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.206536] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.206539] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.206543] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.206552] system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.206559] system 00:07: ioport range 0x680-0x6ef has been reserved
[    0.206563] system 00:07: ioport range 0x800-0x80f has been reserved
[    0.206566] system 00:07: ioport range 0x810-0x817 has been reserved
[    0.206569] system 00:07: ioport range 0x400-0x47f has been reserved
[    0.206573] system 00:07: ioport range 0x500-0x53f has been reserved
[    0.211244] pci 0000:01:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
[    0.211333] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.211338] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
[    0.211345] pci 0000:00:1c.0:   MEM window: 0x90200000-0x902fffff
[    0.211351] pci 0000:00:1c.0:   PREFETCH window: 0x90500000-0x905fffff
[    0.211357] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
[    0.211359] pci 0000:00:1c.1:   IO window: disabled
[    0.211366] pci 0000:00:1c.1:   MEM window: 0x90100000-0x901fffff
[    0.211372] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.211377] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.211379] pci 0000:00:1e.0:   IO window: disabled
[    0.211386] pci 0000:00:1e.0:   MEM window: 0x90000000-0x900fffff
[    0.211391] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.211408] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.211414] pci 0000:00:1c.0: setting latency timer to 64
[    0.211426] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.211431] pci 0000:00:1c.1: setting latency timer to 64
[    0.211500] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.211508] pci 0000:00:1e.0: setting latency timer to 64
[    0.211513] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.211516] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.211519] pci_bus 0000:01: resource 0 io:  [0x1000-0x1fff]
[    0.211522] pci_bus 0000:01: resource 1 mem: [0x90200000-0x902fffff]
[    0.211525] pci_bus 0000:01: resource 2 pref mem [0x90500000-0x905fffff]
[    0.211528] pci_bus 0000:02: resource 1 mem: [0x90100000-0x901fffff]
[    0.211531] pci_bus 0000:03: resource 1 mem: [0x90000000-0x900fffff]
[    0.211534] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.211537] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.211577] NET: Registered protocol family 2
[    0.211680] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.212192] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.214361] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.214989] TCP: Hash tables configured (established 262144 bind 65536)
[    0.214992] TCP reno registered
[    0.215122] NET: Registered protocol family 1
[    0.215209] Trying to unpack rootfs image as initramfs...
[    0.462868] Freeing initrd memory: 8684k freed
[    0.469756] Scanning for low memory corruption every 60 seconds
[    0.469980] audit: initializing netlink socket (disabled)
[    0.470002] type=2000 audit(1251215513.467:1): initialized
[    0.482588] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.484200] VFS: Disk quotas dquot_6.5.2
[    0.484272] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.484987] fuse init (API version 7.12)
[    0.485082] msgmni has been set to 3949
[    0.485353] alg: No test for stdrng (krng)
[    0.485369] io scheduler noop registered
[    0.485372] io scheduler anticipatory registered
[    0.485374] io scheduler deadline registered
[    0.485390] io scheduler cfq registered (default)
[    0.485403] pci 0000:00:02.0: Boot video device
[    0.485674] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.485687] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.485861] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.485873] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.485993] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.486015] Firmware did not grant requested _OSC control
[    0.486037] Firmware did not grant requested _OSC control
[    0.486071] Firmware did not grant requested _OSC control
[    0.486087] Firmware did not grant requested _OSC control
[    0.486105] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.486149] efifb: dmi detected MacBook2,1 - framebuffer at 0000000080000000 (1280x800, stride 8192)
[    0.486271] ACPI: AC Adapter [ADP1] (on-line)
[    0.486385] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.486390] ACPI: Power Button [PWRF]
[    0.486454] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.486500] ACPI: Lid Switch [LID0]
[    0.486551] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.486554] ACPI: Power Button [PWRB]
[    0.486609] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    0.486612] ACPI: Sleep Button [SLPB]
[    0.487368] ACPI: SSDT 000000007eeb8c10 0026C (v01 APPLE   Cpu0Ist 00003000 INTL 20050309)
[    0.487771] ACPI: SSDT 000000007eeb8910 002A0 (v01 APPLE   Cpu0Cst 00003001 INTL 20050309)
[    0.488308] Monitor-Mwait will be used to enter C-1 state
[    0.488343] Monitor-Mwait will be used to enter C-2 state
[    0.488374] Monitor-Mwait will be used to enter C-3 state
[    0.488385] Marking TSC unstable due to TSC halts in idle
[    0.488418] Switched to high resolution mode on CPU 0
[    0.488434] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.488462] processor LNXCPU:00: registered as cooling_device0
[    0.488466] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.488896] ACPI: SSDT 000000007eeb8f10 00087 (v01 APPLE   Cpu1Ist 00003000 INTL 20050309)
[    0.488975] Switched to high resolution mode on CPU 1
[    0.489214] ACPI: SSDT 000000007eeb7f10 00085 (v01 APPLE   Cpu1Cst 00003000 INTL 20050309)
[    0.489722] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.489746] processor LNXCPU:01: registered as cooling_device1
[    0.489750] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.492195] XENFS: not registering filesystem on non-xen platform
[    0.493554] Linux agpgart interface v0.103
[    0.493565] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.495007] brd: module loaded
[    0.495531] loop: module loaded
[    0.495613] input: Macintosh mouse button emulation as /devices/virtual/input/input4
[    0.495740] ata_piix 0000:00:1f.1: version 2.13
[    0.495793] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.495807] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.495854] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.495950] scsi0 : ata_piix
[    0.496182] scsi1 : ata_piix
[    0.496926] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x20b0 irq 14
[    0.496930] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x20b8 irq 15
[    0.496957] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.496964] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.503346] ACPI Warning: \_SB_.BAT0._BIF: Return Package type mismatch at index 9 - found Integer, expected String/Buffer 20090521 nspredef-946
[    0.510581] ACPI: Battery Slot [BAT0] (battery present)
[    0.652029] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.663954] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KBVB, max UDMA/66
[    0.664158] scsi2 : ata_piix
[    0.664231] scsi3 : ata_piix
[    0.665363] ata3: SATA max UDMA/133 cmd 0x20c8 ctl 0x20ec bmdma 0x20a0 irq 19
[    0.665367] ata4: SATA max UDMA/133 cmd 0x20c0 ctl 0x20e8 bmdma 0x20a8 irq 19
[    0.666063] Fixed MDIO Bus: probed
[    0.666070] PPP generic driver version 2.4.2
[    0.666168] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.666192] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.666204] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.666210] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.666266] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.670184] ehci_hcd 0000:00:1d.7: debug port 1
[    0.670192] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.670215] ehci_hcd 0000:00:1d.7: irq 21, io mem 0x90445400
[    0.684024] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.684112] usb usb1: configuration #1 chosen from 1 choice
[    0.684146] hub 1-0:1.0: USB hub found
[    0.684155] hub 1-0:1.0: 8 ports detected
[    0.684250] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.684269] uhci_hcd: USB Universal Host Controller Interface driver
[    0.684327] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.684335] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.684339] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.684375] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.684410] uhci_hcd 0000:00:1d.0: irq 21, io base 0x00002080
[    0.684469] ata1.00: configured for UDMA/66
[    0.684507] usb usb2: configuration #1 chosen from 1 choice
[    0.684537] hub 2-0:1.0: USB hub found
[    0.684544] hub 2-0:1.0: 2 ports detected
[    0.684604] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.684611] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.684615] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.684654] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.684683] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    0.684784] usb usb3: configuration #1 chosen from 1 choice
[    0.684954] hub 3-0:1.0: USB hub found
[    0.684963] hub 3-0:1.0: 2 ports detected
[    0.685028] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.685036] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.685040] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.685079] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.685116] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    0.685205] usb usb4: configuration #1 chosen from 1 choice
[    0.685238] hub 4-0:1.0: USB hub found
[    0.685245] hub 4-0:1.0: 2 ports detected
[    0.685297] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.685304] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.685308] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.685342] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    0.685380] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
[    0.685474] usb usb5: configuration #1 chosen from 1 choice
[    0.685506] hub 5-0:1.0: USB hub found
[    0.685514] hub 5-0:1.0: 2 ports detected
[    0.685629] PNP: No PS/2 controller found. Probing ports directly.
[    0.686405] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D  KBVB PQ: 0 ANSI: 5
[    0.686494] i8042.c: No controller found.
[    0.686626] mice: PS/2 mouse device common for all mice
[    0.686783] rtc_cmos 00:08: RTC can wake from S4
[    0.686821] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    0.686866] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.686971] device-mapper: uevent: version 1.0.3
[    0.687079] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    0.687184] device-mapper: multipath: version 1.1.0 loaded
[    0.687188] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.687526] cpuidle: using governor ladder
[    0.687659] cpuidle: using governor menu
[    0.688108] TCP cubic registered
[    0.688260] NET: Registered protocol family 10
[    0.688759] lo: Disabled Privacy Extensions
[    0.689125] NET: Registered protocol family 17
[    0.689147] Bluetooth: L2CAP ver 2.13
[    0.689149] Bluetooth: L2CAP socket layer initialized
[    0.689153] Bluetooth: SCO (Voice Link) ver 0.6
[    0.689155] Bluetooth: SCO socket layer initialized
[    0.689205] Bluetooth: RFCOMM TTY layer initialized
[    0.689208] Bluetooth: RFCOMM socket layer initialized
[    0.689210] Bluetooth: RFCOMM ver 1.11
[    0.689905] PM: Resume from disk failed.
[    0.689917] registered taskstats version 1
[    0.690028]   Magic number: 5:820:892
[    0.690073] bdi default: hash matches
[    0.690122] rtc_cmos 00:08: setting system clock to 2009-08-25 15:51:54 UTC (1251215514)
[    0.690125] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.690126] EDD information not available.
[    0.690779] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    0.690785] Uniform CD-ROM driver Revision: 3.20
[    0.690929] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.691017] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.851402] ata3.01: ATA-8: WDC WD5000BEVT-00ZAT0, 01.01A01, max UDMA/133
[    0.851408] ata3.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.857460] ata3.01: configured for UDMA/133
[    0.857601] scsi 2:0:1:0: Direct-Access     ATA      WDC WD5000BEVT-0 01.0 PQ: 0 ANSI: 5
[    0.857812] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    0.857817] sd 2:0:1:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.857863] sd 2:0:1:0: [sda] Write Protect is off
[    0.857866] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.857890] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.858007]  sda: sda1 sda2 sda3 sda4
[    0.923404] sd 2:0:1:0: [sda] Attached SCSI disk
[    0.923455] Freeing unused kernel memory: 548k freed
[    0.923692] Write protecting the kernel read-only data: 7236k
[    1.001011] Clocksource tsc unstable (delta = -136945792 ns)
[    1.109035] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    1.171909] sky2 driver version 1.23
[    1.171967] sky2 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.172004] sky2 0000:01:00.0: setting latency timer to 64
[    1.172032] sky2 0000:01:00.0: Yukon-2 EC chip revision 2
[    1.172238] sky2 0000:01:00.0: irq 26 for MSI/MSI-X
[    1.173903] sky2 eth0: addr 00:17:f2:34:c6:ea
[    1.240499] usb 1-4: configuration #1 chosen from 1 choice
[    1.266869] ohci1394 0000:03:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.322049] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[90000000-900007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    1.708074] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    1.894617] usb 2-2: configuration #1 chosen from 1 choice
[    1.906689] usbcore: registered new interface driver hiddev
[    1.906791] usbcore: registered new interface driver usbhid
[    1.906793] usbhid: v2.6:USB HID core driver
[    1.911960] input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input5
[    1.912027] apple 0003:05AC:021B.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input0
[    1.914594] input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input6
[    1.914692] apple 0003:05AC:021B.0002: input,hidraw1: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
[    2.144111] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    2.321298] usb 4-2: configuration #1 chosen from 1 choice
[    2.329301] generic-usb 0003:05AC:8240.0003: hiddev96,hidraw2: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[    2.568111] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    2.604625] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe1fa140]
[    2.748558] usb 5-1: configuration #1 chosen from 1 choice
[    2.768964] input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input7
[    2.769072] generic-usb 0003:05AC:1000.0004: input,hidraw3: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
[    2.800969] input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input8
[    2.801108] generic-usb 0003:05AC:1000.0005: input,hidraw4: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
[   12.153661] PM: Starting manual resume from disk
[   12.153665] PM: Resume from partition 252:2
[   12.153667] PM: Checking hibernation image.
[   12.154053] PM: Resume from disk failed.
[   12.165474] EXT3-fs: INFO: recovery required on readonly filesystem.
[   12.165476] EXT3-fs: write access will be enabled during recovery.
[   12.219247] kjournald starting.  Commit interval 5 seconds
[   12.219262] EXT3-fs: recovery complete.
[   12.220061] EXT3-fs: mounted filesystem with writeback data mode.
[   18.858570] udev: starting version 141
[   19.121198] cfg80211: Calling CRDA to update world regulatory domain
[   19.289337] agpgart-intel 0000:00:00.0: Intel 945GM Chipset
[   19.290537] agpgart-intel 0000:00:00.0: detected 16124K stolen memory
[   19.293823] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[   19.436811] intel_rng: FWH not detected
[   19.453460] usb 1-4: firmware: requesting isight.fw
[   19.677950] cfg80211: World regulatory domain updated:
[   19.677953] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   19.677957] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.677959] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   19.677962] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   19.677965] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.677967] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.691125] Unable to load isight firmware
[   19.691160] usbcore: registered new interface driver isight_firmware
[   19.708485] appletouch: Geyser mode initialized.
[   19.708599] input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input9
[   19.708741] usbcore: registered new interface driver appletouch
[   19.875830] input: PC Speaker as /devices/platform/pcspkr/input/input10
[   20.006485] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/input/input11
[   20.006532] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   20.173058] iTCO_vendor_support: vendor-support=0
[   20.184613] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   20.184715] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0460)
[   20.184778] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   20.368294] applesmc: Apple MacBook (v2) detected:
[   20.368297] applesmc:  - Model with accelerometer
[   20.368299] applesmc:  - Model without light sensors and backlight
[   20.368301] applesmc:  - Model with 10 temperature sensors
[   20.424647] applesmc: device successfully initialized (0xe0, 0x00).
[   20.424650] applesmc: device successfully initialized.
[   20.425199] applesmc: 1 fans found.
[   20.426480] input: applesmc as /devices/platform/applesmc.768/input/input12
[   20.426552] applesmc: driver successfully loaded.
[   20.922611] ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   20.922625] ath9k 0000:02:00.0: setting latency timer to 64
[   20.953204] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   20.953236] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   21.051959] ath: EEPROM regdomain: 0x37
[   21.051961] ath: EEPROM indicates we should expect a direct regpair map
[   21.051964] ath: Country alpha2 being used: AT
[   21.051966] ath: Regpair used: 0x37
[   21.141097] hda_codec: STAC922x, Apple subsys_id=106b2200
[   21.183834] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   21.184513] Registered led device: ath9k-phy0::radio
[   21.184532] Registered led device: ath9k-phy0::assoc
[   21.184550] Registered led device: ath9k-phy0::tx
[   21.184568] Registered led device: ath9k-phy0::rx
[   21.184589] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81: mem=0xffffc900042a0000, irq=17
[   21.184732] cfg80211: Calling CRDA for country: AT
[   21.193733] cfg80211: Regulatory domain changed to country: AT
[   21.193737] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   21.193740] 	(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.193742] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.193745] 	(5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   21.193747] 	(5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   21.707177] lp: driver loaded but no devices found
[   21.913101] Adding 2097144k swap on /dev/mapper/vgencrypted-swap.  Priority:-1 extents:1 across:2097144k 
[   22.485747] EXT3 FS on dm-1, internal journal
[   23.482830] kjournald starting.  Commit interval 5 seconds
[   23.483105] EXT3 FS on sda4, internal journal
[   23.483109] EXT3-fs: mounted filesystem with writeback data mode.
[   23.628917] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   23.630731] SGI XFS Quota Management subsystem
[   23.688751] XFS mounting filesystem dm-3
[   24.004942] Ending clean XFS mount for filesystem: dm-3
[   24.844066] HDA Intel 0000:00:1b.0: PCI INT A disabled
[   24.853007] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   24.853046] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   24.920161] hda_codec: STAC922x, Apple subsys_id=106b2200
[   25.902474] ppdev: user-space parallel port driver
[   30.269237] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   30.543459] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
[   30.555027] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   30.555030] Bluetooth: BNEP filters: protocol multicast
[   30.591724] Bridge firewalling registered
[   30.816130] usb 5-1: USB disconnect, address 2
[   31.116057] usb 5-1: new full speed USB device using uhci_hcd and address 3
[   31.309153] usb 5-1: configuration #1 chosen from 1 choice
[   31.337641] Bluetooth: Generic Bluetooth USB driver ver 0.5
[   31.338153] usbcore: registered new interface driver btusb
[   33.876059] [drm] Initialized drm 1.1.0 20060810
[   33.898991] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   33.898997] pci 0000:00:02.0: setting latency timer to 64
[   33.908179] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   34.129469] render error detected, EIR: 0x00000010
[   34.129475] page table error
[   34.129477]   PGTBL_ER: 0x00000102
[   34.129480] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
[   34.129487] render error detected, EIR: 0x00000010
[   34.129489] page table error
[   34.129490]   PGTBL_ER: 0x00000102
[   34.408721] sky2 eth0: enabling interface
[   34.409131] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   36.660303] ADDRCONF(NETDEV_UP): wlan0: link is not ready

--------------030403050605030504010102--
