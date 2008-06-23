Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYFWDbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYFWDbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYFWDa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:30:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:63162 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYFWDax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id:from;
        b=q+memLdlD4cKl9zagbgqv2Tee4QOdguVI87M1wL9sn8TsKwbSOPmBFK4etBYAchA6Z
         waWm6oP1k2oYcBlVrzjbCvIRyLlsuRaJYy5mhD88mffGdTuCKbFjZUBdCD5Xplb+m2fl
         ZZTgBQq1ouEUc2RKBXQ6OAKgZZxTL9oxyg8Ow=
Organization: M1K0
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Mon, 23 Jun 2008 05:30:43 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <200806162021.37105.Michal.Kudla@gmail.com> <1213665088.2533.24.camel@debian.sh.intel.com>
In-Reply-To: <1213665088.2533.24.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kjxXI/3PbeCn2OQ"
Message-Id: <200806230530.44283.Michal.Kudla@gmail.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kjxXI/3PbeCn2OQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
I installed new version - 2.6.26-rc7.
There is some changes and I don't execute last settings
>ZY Your radio is disabled by the software rf_kill switch. Please do a
>ZY $ echo 0 > /sys/bus/pci/drivers/iwl4965/<dev id>/rfkill\:rfkill0/state

Still don't work

If my distro (Gentoo) is conflicted, please point to proper distro

My dmesg
http://michal.kudla.googlepages.com/dmesg-2.6.26-rc7_2008-06-23.txt

My console log

Password:
Last login: Mon Jun 23 04:58:21 CEST 2008 on tty1
laptok ~ # modprobe -rv iwl4965
rmmod /lib/modules/2.6.26-rc7/kernel/drivers/net/wireless/iwlwifi/iwl4965.ko
rmmod /lib/modules/2.6.26-rc7/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
rmmod /lib/modules/2.6.26-rc7/kernel/net/mac80211/mac80211.ko
laptok ~ # modprobe -v iwl4965 debug=3D0x20002
insmod /lib/modules/2.6.26-rc7/kernel/net/mac80211/mac80211.ko
insmod /lib/modules/2.6.26-rc7/kernel/drivers/net/wireless/iwlwifi/iwlcore.=
ko
insmod /lib/modules/2.6.26-rc7/kernel/drivers/net/wireless/iwlwifi/iwl4965.=
ko=20
debug=3D0x20002
laptok ~ # iwconfig wlan0 txpower on
laptok ~ # /etc/init.d/net.wlan0 restart
 * Service net.wlan0 starting
SIOCSIFFLAGS: No such device
SIOCSIFFLAGS: No such device
SIOCSIFFLAGS: No such device
 Failed to configure wireless for wlan0                                  =20
[ !! ] * ERROR:  net.wlan0 failed to start
laptok ~ # dmesg >dmesg-`uname -r`_`date +%F`.txt
laptok ~ # cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/[TAB key]
antenna               ieee80211:phy1/       resource0
broken_parity_status  input:input5/         retry_rate
bus/                  irq                   rfkill:rfkill1/
channels              local_cpulist         rs_window
class                 local_cpus            statistics
config                measurement           status
device                modalias              subsystem/
driver/               msi_bus               subsystem_device
dump_errors           net:wlan0/            subsystem_vendor
dump_events           net:wmaster0/         temperature
enable                power/                tx_power
filter_flags          power_level           uevent
flags                 resource              vendor
laptok ~ #=20
cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/[TAB key]
claim      name       state      type
device/    power/     subsystem/ uevent
laptok ~ #=20
cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/state
0




W li=C5=9Bcie datowanym na wtorek, 17 czerwca 2008, Zhu Yi pisze:
>ZY On Mon, 2008-06-16 at 20:21 +0200, Micha=C5=82 Kud=C5=82a wrote:
>ZY > And my wifi working!
>ZY >
>ZY > Bt, I don't know why my wifi working under 2.6.23 and 2.6.24?
>ZY
>ZY mac80211 in those (old) kernels doesn't indicate to switch the SW
>ZY rf_kill on with user sets txpower off.
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY



--Boundary-00=_kjxXI/3PbeCn2OQ
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg-2.6.26-rc7_2008-06-23.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-2.6.26-rc7_2008-06-23.txt"

Linux version 2.6.26-rc7 (root@laptok) (gcc version 4.3.1 (Gentoo 4.3.1 p1.0) ) #2 SMP Mon Jun 23 05:01:04 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007fff0000 (ACPI NVS)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at [c00ff780] 000ff780
Entering add_active_range(0, 0, 524176) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524176
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524176
On node 0 totalpages: 524176
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2304 pages used for memmap
  HighMem zone: 292496 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000FB430, 0014 (r0 ACPIAM)
ACPI: RSDT 7FF90000, 003C (r1 NEC              4000719 MSFT       97)
ACPI: FACP 7FF90200, 0084 (r2 AMITW  OEMFACP   4000719 MSFT       97)
ACPI: DSDT 7FF905B0, 6885 (r1  A0791 A0791000        0 INTL 20060113)
ACPI: FACS 7FF9E000, 0040
ACPI: APIC 7FF90390, 005C (r1 AMITW  OEMAPIC   4000719 MSFT       97)
ACPI: MCFG 7FF903F0, 003C (r1 AMITW  OEMMCFG   4000719 MSFT       97)
ACPI: SLIC 7FF90430, 0176 (r1 NEC              4000719 MSFT       97)
ACPI: OEMB 7FF9E040, 0061 (r1 AMITW  AMI_OEM   4000719 MSFT       97)
ACPI: HPET 7FF96E40, 0038 (r1 AMITW  OEMHPET   4000719 MSFT       97)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0xffffffff base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 38248 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520080
Kernel command line: root=/dev/sda3
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1995.065 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2071896k/2096704k available (3771k kernel code, 23596k reserved, 1505k data, 268k init, 1179200k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc062f000 - 0xc0672000   ( 268 kB)
      .data : 0xc04aef9a - 0xc0627630   (1505 kB)
      .text : 0xc0100000 - 0xc04aef9a   (3771 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 3992.67 BogoMIPS (lpj=1996338)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080321
Parsing all Control Methods:
Table [DSDT](id 0001) - 958 Objects with 68 Devices 298 Methods 35 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
APIC calibration not consistent with PM Timer: 118ms instead of 100ms
APIC delta adjusted to PM-Timer: 1246875 (1483767)
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3989.80 BogoMIPS (lpj=1994904)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7982.48 BogoMIPS).
net_namespace: 332 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=6
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:....................................................................................................................................
Initialized 34/35 Regions 23/23 Fields 43/44 Buffers 32/33 Packages (967 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:..
Executed 2 _INI methods requiring 0 _STA executions (examined 73 objects)
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 9 Wake, Enabled 1 Runtime GPEs in this block
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 *15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
system 00:08: ioport range 0x25c-0x25f has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x800-0x87f has been reserved
system 00:08: ioport range 0x500-0x53f has been reserved
system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
system 00:08: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
system 00:0c: iomem range 0x100000-0x7fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: 0xf4000000-0xf7ffffff
  PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: 0xfbe00000-0xfbefffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: d000-dfff
  MEM window: 0xf8000000-0xfbdfffff
  PREFETCH window: 0x00000000dc000000-0x00000000dfffffff
PCI: Bridge: 0000:00:1e.0
  IO window: e000-efff
  MEM window: 0xfbf00000-0xfbffffff
  PREFETCH window: 0x0000000088000000-0x00000000880fffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/W DEBUG].
msgmni has been set to 1745
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie02]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
ACPI: AC Adapter [AC0] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: SSDT 7FF9E0B0, 0688 (r1    AMI   CPU1PM        1 INTL 20060113)
Parsing all Control Methods:
Table [SSDT](id 00D1) - 8 Objects with 0 Devices 4 Methods 0 Regions
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: SSDT 7FF9E740, 0120 (r1    AMI   CPU2PM        1 INTL 20060113)
Parsing all Control Methods:
Table [SSDT](id 00D5) - 5 Objects with 0 Devices 5 Methods 0 Regions
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (67 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
brd: module loaded
loop: module loaded
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:06:07.0[A] -> GSI 18 (level, low) -> IRQ 18
eth0: RTL8169sc/8110sc at 0xf882e400, 00:1b:fc:41:a1:d8, XID 18000000 IRQ 18
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 19 (level, low) -> IRQ 19
ICH8M: not 100% native mode: will probe irqs later
ICH8M: IDE port disabled
    ide0: BM-DMA at 0xffa0-0xffa7
Probing IDE interface ide0...
hdb: TSSTcorpCD/DVDW TS-L632D, ATAPI CD/DVD-ROM drive
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hdb: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0xb080 ctl 0xb000 bmdma 0xa800 irq 18
ata2: SATA max UDMA/133 cmd 0xac00 ctl 0xa880 bmdma 0xa808 irq 18
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: WDC WD1600BEVS-00RST0, 04.01G04, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVS-0 04.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf3fffc00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf3fff800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b880
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000bc00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b400
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b480
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b800
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 2-6: new high speed USB device using ehci_hcd and address 4
usb 2-6: configuration #1 chosen from 1 choice
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
usb 6-1: new low speed USB device using uhci_hcd and address 2
usb 6-1: configuration #1 chosen from 1 choice
usb 7-1: new full speed USB device using uhci_hcd and address 2
usb 7-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
i2c /dev entries driver
i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 17 (level, low) -> IRQ 17
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
EDAC MC: Ver: 2.1.0 Jun 23 2008
cpuidle: using governor ladder
cpuidle: using governor menu
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:06:01.1 [1180:0822] (rev 22)
ACPI: PCI Interrupt 0000:06:01.1[B] -> GSI 17 (level, low) -> IRQ 17
Marking TSC unstable due to: TSC halts in idle.
mmc0: Will use DMA mode even though HW doesn't fully claim to support it.
Registered led device: mmc0
mmc0: SDHCI at 0xfbfff000 irq 17 DMA
usbcore: registered new interface driver hiddev
input: Generic USB K/B as /class/input/input0
input: USB HID v1.10 Keyboard [Generic USB K/B] on usb-0000:00:1d.1-1
input: Generic USB K/B as /class/input/input1
input: USB HID v1.10 Mouse [Generic USB K/B] on usb-0000:00:1d.1-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.5
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI No-Shortcut mode
Clocksource tsc unstable (delta = -237396081 ns)
Synaptics Touchpad, model: 1, fw: 6.1, id: 0xa3a0b3, caps: 0xa04713/0x10008
input: SynPS/2 Synaptics TouchPad as /class/input/input2
input: AT Translated Set 2 keyboard as /class/input/input3
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 268k freed
asus-laptop: Asus Laptop Support version 0.42
asus-laptop: Error calling BSTS
asus-laptop:   S96S model detected
Registered led device: asus::mail
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
nvidiafb: Device ID: 10de0425 
nvidiafb: unknown NV_ARCH
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26kds
iwl4965: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:04:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
phy0: Selected rate control algorithm 'iwl-4965-rs'
ACPI: PCI interrupt for device 0000:04:00.0 disabled
input: 4965AGN as /class/input/input4
EXT3 FS on sda3, internal journal
Adding 987988k swap on /dev/sda2.  Priority:-1 extents:1 across:987988k
r8169: eth0: link up
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 100102, writing 100106)
firmware: requesting iwlwifi-4965-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd failed: -5
iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
mac80211-phy0: failed to remove key (0, ff:ff:ff:ff:ff:ff) from hardware (-5)
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
ACPI: PCI interrupt for device 0000:04:00.0 disabled
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26kds
iwl4965: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:04:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
phy1: Selected rate control algorithm 'iwl-4965-rs'
iwl4965: U iwl_rfkill_init Initializing RFKILL.
input: 4965AGN as /class/input/input5
iwl4965: U iwl_rfkill_init RFKILL initialization complete.
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
firmware: requesting iwlwifi-4965-1.ucode
iwl4965: U iwl4965_hw_nic_init SW RF KILL supported in EEPROM.
iwl4965: U iwl4965_hw_nic_init HW RF KILL supported in EEPROM.
Registered led device: iwl-phy1:radio
Registered led device: iwl-phy1:assoc
Registered led device: iwl-phy1:RX
Registered led device: iwl-phy1:TX
iwl4965: U iwl4965_mac_start leave
iwl4965: U iwl4965_mac_add_interface enter: type 2
iwl4965: U iwl4965_mac_add_interface Set 00:13:e8:42:88:f9
iwl4965: U iwl4965_mac_add_interface leave
iwl4965: U iwl4965_mac_config_interface bssid: 00:00:00:00:00:00
iwl4965: U iwl4965_mac_config_interface leave
iwl4965: U iwl4965_bss_info_changed changes = 0x6
iwl4965: U iwl4965_bss_info_changed ERP_PREAMBLE 0
iwl4965: U iwl4965_bss_info_changed ERP_CTS 0
iwl4965: U iwl4965_mac_config enter to channel 1
iwl4965: U iwl4965_mac_config leave
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwl4965: U iwl4965_mac_hw_scan enter
iwl4965: U iwl4965_mac_hw_scan leave
iwl4965: U iwl4965_mac_set_key enter
iwl4965: U iwl4965_mac_config enter to channel 1
iwl4965: U iwl4965_mac_config leave
iwl4965: U iwl4965_mac_set_key enable hwcrypto key
iwl4965: U iwl4965_mac_set_key leave
iwl4965: U iwl4965_mac_hw_scan enter
iwl4965: U iwl4965_mac_hw_scan enter
iwl4965: U iwl4965_mac_hw_scan leave
iwl4965: U iwl4965_mac_config enter to channel 1
iwl4965: U iwl4965_mac_config leave - scanning
iwl4965: U iwl4965_mac_set_key enter
iwl4965: U iwl4965_mac_config enter to channel 1
iwl4965: U iwl4965_radio_kill_sw Manual SW RF KILL set to: RADIO OFF
iwl4965: I iwl4965_rx_card_state_notif Card state received: HW:On SW:Kill
iwl4965: U iwl4965_mac_config leave - radio disabled
iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd failed: -5
iwl4965: U iwl4965_bg_rf_kill Can not turn radio back on - disabled by SW switch
iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
iwl4965: U iwl4965_mac_set_key disable hwcrypto key
iwl4965: U iwl4965_mac_set_key leave
mac80211-phy1: failed to remove key (0, ff:ff:ff:ff:ff:ff) from hardware (-5)
iwl4965: U iwl4965_mac_remove_interface enter
iwl4965: U iwl4965_mac_remove_interface leave
iwl4965: U iwl4965_mac_stop enter
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access power-down complete, gpctl = 0x090033d4
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access Wait for complete power-down, gpctl = 0x090433c5
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl4965: U _iwl_grab_nic_access power-down complete, gpctl = 0x080033d4
iwl4965: U iwl4965_mac_stop leave
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Radio disabled by SW RF kill (module parameter)
iwl4965: U iwl4965_mac_start leave - failed
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Radio disabled by SW RF kill (module parameter)
iwl4965: U iwl4965_mac_start leave - failed
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Radio disabled by SW RF kill (module parameter)
iwl4965: U iwl4965_mac_start leave - failed

--Boundary-00=_kjxXI/3PbeCn2OQ--
