Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbZARObt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbZARObt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 09:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbZARObj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 09:31:39 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:51788 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbZARObg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 09:31:36 -0500
Message-ID: <497322CC.7050900@cfl.rr.com>
Date: Sun, 18 Jan 2009 07:38:36 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Mark Hounschell <markh@compro.net>
Subject: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II processor
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded from a Phenom to a Phenom-II processor and I could no longer boot.

I have tried kernels from 2.6.26 through 2.6.28.

I _can_ however boot these kernels when they are configured for HZ = 250. I
haven't tried HZ = 300. But certainly if HZ = 1000 the boot hangs at the spot
indicated below in the dmesg output.

The machine is up and stable running 2.6.26.8 with a (HZ = 1000) configured kernel.

While running a 2.6.26.8 kernel configured for HZ = 250:

/proc/version:

Linux version 2.6.26.8 (root@harley) (gcc version 4.3.1 20080507 (prerelease)
[gcc-4_3-branch revision 135036] (SUSE Linux) ) #2 SMP PREEMPT Sat Jan 17
16:37:58 EST 2009


scripts/ver_linux:

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux harley 2.6.26.8 #2 SMP PREEMPT Sat Jan 17 16:37:58 EST 2009 i686 athlon
i386 GNU/Linux

Gnu C                  4.3
Gnu make               3.81
binutils               11.0
2.18.50.20080409
11.1
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.40.8
reiserfsprogs          3.6.19
PPP                    2.4.4
Linux C Library        2.8
Dynamic linker (ldd)   2.8
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.11
udev                   120
wireless-tools         29
Modules Loaded         ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device appletalk ax25 ipx p8023
ip6t_REJECT nf_conntrack_ipv6 ipt_REJECT xt_state iptable_mangle iptable_nat
nf_nat iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4
nf_conntrack ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop dm_mod
snd_hda_intel snd_pcm snd_timer ati_agp nvidia snd ppdev rtc_cmos ide_cd_mod
i2c_piix4 parport_pc rtc_core usb_storage usblp soundcore cdrom agpgart
snd_page_alloc parport rtc_lib e1000e ide_disk i2c_core sg ehci_hcd ohci_hcd
sd_mod usbcore ssb e1000 sky2 edd ext3 mbcache jbd aic7xxx scsi_transport_spi
atiixp ide_core ahci pata_jmicron libata scsi_mod dock


/proc/cpuinfo:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Processor model unknown
stepping        : 2
cpu MHz         : 3000.306
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp
lm 3dnowext 3dnow constant_tsc pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 3956.73
clflush size    : 64
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Processor model unknown
stepping        : 2
cpu MHz         : 3000.306
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp
lm 3dnowext 3dnow constant_tsc pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 6000.60
clflush size    : 64
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Processor model unknown
stepping        : 2
cpu MHz         : 3000.306
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp
lm 3dnowext 3dnow constant_tsc pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 6000.47
clflush size    : 64
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Processor model unknown
stepping        : 2
cpu MHz         : 3000.306
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp
lm 3dnowext 3dnow constant_tsc pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 6000.47
clflush size    : 64
power management: ts ttp tm stc 100mhzsteps hwpstate


dmesg:

Initializing cgroup subsys cpuset
Linux version 2.6.26.8-lcrs (root@harley) (gcc version 4.3.1 20080507
(prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #2 SMP PREEMPT Sat
Jan 17 16:37:58 EST 2009
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bffe0000 (usable)
 BIOS-e820: 00000000bffe0000 - 00000000bffe3000 (ACPI NVS)
 BIOS-e820: 00000000bffe3000 - 00000000bfff0000 (ACPI data)
 BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3264MB HIGHMEM available.
832MB LOWMEM available.
found SMP MP-table at [c00f3f00] 000f3f00
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   212992
  HighMem    212992 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->  1048576
On node 0 totalpages: 1048576
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1632 pages used for memmap
  Normal zone: 207264 pages, LIFO batch:31
  HighMem zone: 6528 pages used for memmap
  HighMem zone: 829056 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.5 present.
ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
ACPI: XSDT BFFE3080, 004C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS BFFE0000, 0040
ACPI: SSDT BFFE8E40, 088C (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: HPET BFFE9700, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG BFFE9740, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC BFFE8D80, 0084 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 38788 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 4
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
Kernel command line: root=/dev/sda5 hwprobe=-modules.pata apm=off selinux=0
noresume splash=silent bigphysarea=0x4000 vmalloc=192M vga=0x317
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3000.306 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3031940k/4194304k available (1748k kernel code, 112564k reserved, 732k
data, 216k init, 2293632k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe15000 - 0xfffff000   (1960 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf4800000 - 0xff7fe000   ( 175 MB)
    lowmem  : 0xc0000000 - 0xf4000000   ( 832 MB)
      .init : 0xc0373000 - 0xc03a9000   ( 216 kB)
      .data : 0xc02b5336 - 0xc036c6d0   ( 732 kB)
      .text : 0xc0100000 - 0xc02b5336   (1748 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.


      The 2.6.26.8 kernel hangs up right here.


CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
Probably due to long platform interrupts. Consider using "lpj=" boot option.
Calibrating delay loop... 3956.73 BogoMIPS (lpj=7913472)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(4) -> Core 0
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080321
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Processor model unknown stepping 02
Booting processor 1/1 ip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6000.60 BogoMIPS (lpj=12001200)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(4) -> Core 2
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Processor model unknown stepping 02
Booting processor 2/2 ip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000950)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2(4) -> Core 1
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: AMD Processor model unknown stepping 02
Booting processor 3/3 ip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000955)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3(4) -> Core 3
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: AMD Processor model unknown stepping 02
Brought up 4 CPUs
Total of 4 processors activated (21958.28 BogoMIPS).
net_namespace: 660 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:12.0: set SATA to AHCI mode
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0d: mem resource (0xfed00000-0xfed000ff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
pnp 00:0d: mem resource (0xffff0000-0xffffffff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
pnp 00:0d: mem resource (0xfec00000-0xfec00fff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
pnp 00:0d: mem resource (0xfee00000-0xfee00fff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
pnp 00:0d: mem resource (0xfff80000-0xfffeffff) overlaps 0000:00:00.0 BAR 3
(0xe0000000-0xffffffff), disabling
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: Cannot allocate resource region 3 of device 0000:00:00.0
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 3
system 00:01: ioport range 0x4100-0x411f has been reserved
system 00:01: ioport range 0x228-0x22f has been reserved
system 00:01: ioport range 0x40b-0x40b has been reserved
system 00:01: ioport range 0x4d6-0x4d6 has been reserved
system 00:01: ioport range 0xc00-0xc01 has been reserved
system 00:01: ioport range 0xc14-0xc14 has been reserved
system 00:01: ioport range 0xc50-0xc52 has been reserved
system 00:01: ioport range 0xc6c-0xc6d has been reserved
system 00:01: ioport range 0xc6f-0xc6f has been reserved
system 00:01: ioport range 0xcd0-0xcd1 has been reserved
system 00:01: ioport range 0xcd2-0xcd3 has been reserved
system 00:01: ioport range 0xcd4-0xcdf has been reserved
system 00:01: ioport range 0x4000-0x40fe has been reserved
system 00:01: ioport range 0x4210-0x4217 has been reserved
system 00:01: ioport range 0xb10-0xb1f has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x220-0x225 has been reserved
system 00:0d: iomem range 0xf0000-0xfffff could not be reserved
system 00:0d: iomem range 0x0-0x1fffff could not be reserved
system 00:0d: iomem range 0xbffe0000-0xbfffffff could not be reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0x100000-0xbffdffff could not be reserved
PCI: Bridge: 0000:00:02.0
  IO window: d000-dfff
  MEM window: 0xf8000000-0xfbffffff
  PREFETCH window: 0x00000000c0000000-0x00000000dfffffff
PCI: Bridge: 0000:00:04.0
  IO window: c000-cfff
  MEM window: 0xfdc00000-0xfdcfffff
  PREFETCH window: 0x00000000fdb00000-0x00000000fdbfffff
PCI: Bridge: 0000:00:06.0
  IO window: b000-bfff
  MEM window: 0xfda00000-0xfdafffff
  PREFETCH window: 0x00000000fdf00000-0x00000000fdffffff
PCI: Bridge: 0000:00:07.0
  IO window: e000-efff
  MEM window: 0xfde00000-0xfdefffff
  PREFETCH window: 0x00000000fdd00000-0x00000000fddfffff
PCI: Bridge: 0000:00:14.4
  IO window: a000-afff
  MEM window: 0xfd900000-0xfd9fffff
  PREFETCH window: 0x00000000fd800000-0x00000000fd8fffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:07.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 10039k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1232260163.932:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
bigphysarea: Allocated 16384 pages at 0xc3038000.
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1462
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
PCI: Setting latency timer of device 0000:00:07.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:07.0:pcie00]
vesafb: framebuffer at 0xf9000000, mapped to 0xf4880000, using 3072k, total 14336k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: protected mode interface info at c000:b0a0
vesafb: pmi: set display start = c00cb103, set palette = c00cb15e
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0
3d1 3d2 3d3 3d4 3d5 3da
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.1.1.1 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
logips2pp: Detected unknown logitech mouse model 11
input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
Using IPI No-Shortcut mode
Freeing unused kernel memory: 216k freed
No dock devices found.
SCSI subsystem initialized
libata version 3.00 loaded.
pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:03:00.1 to 64
scsi0 : pata_jmicron
scsi1 : pata_jmicron
ata1: PATA max UDMA/100 cmd 0xbf00 ctl 0xbe00 bmdma 0xbb00 irq 19
ata2: PATA max UDMA/100 cmd 0xbd00 ctl 0xbc00 bmdma 0xbb08 irq 19
ahci 0000:00:12.0: version 3.0
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
ata3: softreset failed (device not ready)
ata3: failed due to HW bug, retry pmp=0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: configured for UDMA/133
ata4: softreset failed (device not ready)
ata4: failed due to HW bug, retry pmp=0
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
ata4.00: configured for UDMA/133
ata5: softreset failed (device not ready)
ata5: failed due to HW bug, retry pmp=0
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata5.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 abar m8192@0xfdafe000 port 0xfdafe100 irq 18
ata8: SATA max UDMA/133 abar m8192@0xfdafe000 port 0xfdafe180 irq 18
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SB600_PATA: IDE controller (0x1002:0x438c rev 0x00) at  PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
SB600_PATA: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf900-0xf907
Probing IDE interface ide0...
hda: ST3120023A, ATA DISK drive
hdb: TSSTcorpCD/DVDW TS-H552B, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ACPI: PCI Interrupt 0000:05:06.0[A] -> GSI 21 (level, low) -> IRQ 21
scsi8 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2930CU SCSI adapter>
        aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:04:00.0 to 64
sky2 0000:04:00.0: v1.21 addr 0xfdefc000 irq 19 Yukon-EC Ultra (0xb4) rev 5
sky2 eth0: addr 00:e0:4d:7a:8c:ee
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
Driver 'sd' needs updating - please use bus_type methods
usbcore: registered new device driver usb
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sda: sda1 sda2 sda3 < sda5<6>usb usb1: configuration #1 chosen from 1 choice
 sda6<6>hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
 sda7 sda8 sda9 sda10 >
sd 2:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdb: sdb1 sdb2 sdb3 <<6>usb usb1: New USB device found, idVendor=1d6b,
idProduct=0001
 sdb5<6>usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
 sdb6<6>usb usb1: Manufacturer: Linux 2.6.26.8-lcrs ohci_hcd
usb usb1: SerialNumber: 0000:00:13.0
 sdb7<6>ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 2
 sdb8<6>ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
 sdb9<6>ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
 sdb10 >
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26.8-lcrs ehci_hcd
usb usb2: SerialNumber: 0000:00:13.5
ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26.8-lcrs ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.26.8-lcrs ohci_hcd
usb usb4: SerialNumber: 0000:00:13.2
ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=03f0, idProduct=5111
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: Photosmart 3200 series
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 2-1: Manufacturer: HP
usb 2-1: SerialNumber: MY5B98310Z045K
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.26.8-lcrs ohci_hcd
usb usb5: SerialNumber: 0000:00:13.3
ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 2-2: new high speed USB device using ehci_hcd and address 3
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.26.8-lcrs ohci_hcd
usb usb6: SerialNumber: 0000:00:13.4
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
usb 2-2: New USB device found, idVendor=0424, idProduct=2504
usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 3:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: Attached scsi generic sg2 type 0
hda: max request size: 128KiB
hda: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
Linux agpgart interface v0.103
eth1: (PCI Express:2.5GB/s:Width x1) 00:1b:21:0f:09:1b
eth1: Intel(R) PRO/1000 Network Connection
eth1: MAC: 1, PHY: 4, PBA No: d50854-003
usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2 vid 0x03F0 pid 0x5111
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
scsi9 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
IT8718 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month
ppdev: user-space parallel port driver
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ALSA sound/pci/hda/hda_codec.c:3021: autoconfig: line_outs=4
(0x14/0x15/0x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:3025:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3029:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3038:    inputs: mic=0x18, fmic=0x19, line=0x1a,
fline=0x0, cd=0x0, aux=0x0
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  177.82  Tue Nov  4 13:35:57 PST 2008
Adding 8393952k swap on /dev/sda2.  Priority:-1 extents:1 across:8393952k
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
scsi 9:0:0:0: Direct-Access     HP       Photosmart 3210  1.00 PQ: 0 ANSI: 2
sd 9:0:0:0: [sdd] Attached SCSI removable disk
sd 9:0:0:0: Attached scsi generic sg3 type 0
usb-storage: device scan complete
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.9)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
sky2 eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_UP): eth1: link is not ready
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
NET: Registered protocol family 4
NET: Registered protocol family 3
NET: Registered protocol family 5
hda-intel: Invalid position buffer, using LPIB read method instead.




Using a 2.6.28 kernel the dmesg is slightly different and it seems to get a
little further. The last line on the screen is

Using C1E aware idle routine.

The BIOS on my MB doesn't recognize the processor type either BTW. At post it
says it an AMD processor type undefined.

Regards
Mark






