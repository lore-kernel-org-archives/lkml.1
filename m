Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYFXGMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYFXGMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYFXGMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:12:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:42540 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYFXGMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id:from;
        b=fcv117W+cKe9orSkPlxyuG5A1rKGNRnqYHaGxEH2C+hx3Pd7nihHRq/D7AYqu9A6Yf
         mrmhEG/bc6xxynutShIVVy8T4PDh3vay/V84WXufSKNHK3UgfTHxK19bN823juAA1jPx
         w6untZwgmsLPb83dH9wojRllVwp2lOVL+tLHQ=
Organization: M1K0
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Tue, 24 Jun 2008 08:12:03 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <200806240537.08888.Michal.Kudla@gmail.com> <1214279513.14590.198.camel@debian.sh.intel.com>
In-Reply-To: <1214279513.14590.198.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0AJYIMet9DZyZBD"
Message-Id: <200806240812.04559.Michal.Kudla@gmail.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0AJYIMet9DZyZBD
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
I do
 ifconfig wlan0 up

results in files:
console-frkill-1-iwconfig.txt
dmesg-2.6.26-rc7_2008-06-24-rfkill-1-ifconfig.txt
net - script config
net.lo - run script

How to run my wifi?

W li=C5=9Bcie datowanym na wtorek, 24 czerwca 2008, Zhu Yi pisze:
>ZY On Tue, 2008-06-24 at 05:37 +0200, Micha=C5=82 Kud=C5=82a wrote:
>ZY > laptok ~ # cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
>ZY > \:rfkill1/state
>ZY > 0
>ZY > laptok ~ # echo "1"> /sys/bus/pci/drivers/iwl4965/0000\:04
>ZY > \:00.0/rfkill\:rfkill1/state
>ZY > laptok ~ # iwconfig wlan0 txpower on
>ZY > laptok ~ # /etc/init.d/net.wlan0 restart
>ZY >  * Service net.wlan0 starting
>ZY >  Failed to configure wireless for wlan0
>ZY > [ !! ] * ERROR:  net.wlan0 failed to start
>ZY
>ZY Looks like the wireless config scripts in your distro did something
>ZY (probably txpower off) to disable the SW radio. Can you try the
>ZY following commands after wlan0 restart?
>ZY
>ZY $ cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/state
>ZY $ echo 1 > /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
>ZY \:rfkill1/state
>ZY $ ifconfig wlan0 up
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY



--Boundary-00=_0AJYIMet9DZyZBD
Content-Type: text/plain;
  charset="utf-8";
  name="console-frkill-1-iwconfig.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="console-frkill-1-iwconfig.txt"

Last login: Tue Jun 24 05:19:27 CEST 2008 on tty2
laptok ~ # modprobe -rv iwl4965
rmmod /lib/modules/2.6.26-rc7/kernel/drivers/net/wireless/iwlwifi/iwl4965.ko
rmmod /lib/modules/2.6.26-rc7/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
rmmod /lib/modules/2.6.26-rc7/kernel/net/mac80211/mac80211.ko
laptok ~ # modprobe -v iwl4965 debug=0x20002
insmod /lib/modules/2.6.26-rc7/kernel/net/mac80211/mac80211.ko
insmod /lib/modules/2.6.26-rc7/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
insmod /lib/modules/2.6.26-rc7/kernel/drivers/net/wireless/iwlwifi/iwl4965.ko debug=0x20002
laptok ~ # cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/
claim      name       state      type
device/    power/     subsystem/ uevent
laptok ~ # cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/state
0
laptok ~ # echo "1"> /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/state
laptok ~ # ifconfig wlan0 up
laptok ~ # ifconfig
eth0      Link encap:Ethernet  HWaddr 00:1B:FC:41:A1:D8
          inet addr:192.168.2.141  Bcast:192.168.2.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:576  Metric:1
          RX packets:28 errors:0 dropped:0 overruns:0 frame:0
          TX packets:35 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4090 (3.9 Kb)  TX bytes:4223 (4.1 Kb)
          Interrupt:18 Base address:0xe400

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:14 errors:0 dropped:0 overruns:0 frame:0
          TX packets:14 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:915 (915.0 b)  TX bytes:915 (915.0 b)

wlan0     Link encap:Ethernet  HWaddr 00:13:E8:42:88:F9
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

wmaster0  Link encap:UNSPEC  HWaddr 00-13-E8-42-88-F9-BC-60-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)


--Boundary-00=_0AJYIMet9DZyZBD
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg-2.6.26-rc7_2008-06-24-rfkill-1-ifconfig.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-2.6.26-rc7_2008-06-24-rfkill-1-ifconfig.txt"

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
Detected 1995.042 MHz processor.
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
Calibrating delay using timer specific routine.. 3992.66 BogoMIPS (lpj=1996331)
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
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3989.81 BogoMIPS (lpj=1994906)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7982.47 BogoMIPS).
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
ACPI: AC Adapter [AC0] (off-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: SSDT 7FF9E0B0, 0688 (r1    AMI   CPU1PM        1 INTL 20060113)
Parsing all Control Methods:
Table [SSDT](id 00CE) - 8 Objects with 0 Devices 4 Methods 0 Regions
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: SSDT 7FF9E740, 0120 (r1    AMI   CPU2PM        1 INTL 20060113)
Parsing all Control Methods:
Table [SSDT](id 00D2) - 5 Objects with 0 Devices 5 Methods 0 Regions
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (71 C)
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
Clocksource tsc unstable (delta = -263697850 ns)
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
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda3, internal journal
Adding 987988k swap on /dev/sda2.  Priority:-1 extents:1 across:987988k
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 100102, writing 100106)
firmware: requesting iwlwifi-4965-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
r8169: eth0: link up
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
iwl4965: U iwl_rfkill_soft_rf_kill we recieved soft RFKILL set to state 1
iwl4965: U iwl4965_radio_kill_sw Manual SW RF KILL set to: RADIO ON
iwl4965: U iwl4965_mac_start enter
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: U iwl4965_hw_nic_init SW RF KILL supported in EEPROM.
iwl4965: U iwl4965_hw_nic_init HW RF KILL supported in EEPROM.
Registered led device: iwl-phy1:radio
Registered led device: iwl-phy1:assoc
Registered led device: iwl-phy1:RX
Registered led device: iwl-phy1:TX
iwl4965: U iwl4965_mac_hw_scan enter
iwl4965: U iwl4965_mac_hw_scan leave
iwl4965: U iwl4965_mac_start leave
iwl4965: U iwl4965_mac_add_interface enter: type 2
iwl4965: U iwl4965_mac_add_interface Set 00:13:e8:42:88:f9
iwl4965: U iwl4965_mac_add_interface leave
iwl4965: U iwl4965_mac_config_interface bssid: 00:00:00:00:00:00
iwl4965: U iwl4965_mac_config_interface leave
iwl4965: U iwl4965_bss_info_changed changes = 0x6
iwl4965: U iwl4965_bss_info_changed ERP_PREAMBLE 0
iwl4965: U iwl4965_bss_info_changed ERP_CTS 0
iwl4965: U iwl4965_mac_set_key enter
iwl4965: U iwl4965_mac_set_key enable hwcrypto key
iwl4965: U iwl4965_mac_set_key leave
iwl4965: U iwl4965_mac_config enter to channel 1
iwl4965: U iwl4965_radio_kill_sw Manual SW RF KILL set to: RADIO OFF
iwl4965: I iwl4965_rx_card_state_notif Card state received: HW:On SW:Kill
iwl4965: U iwl4965_mac_config leave - radio disabled
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwl4965: U iwl4965_bg_rf_kill Can not turn radio back on - disabled by SW switch
iwl4965: Error sending REPLY_STATISTICS_CMD: enqueue_hcmd failed: -5

--Boundary-00=_0AJYIMet9DZyZBD
Content-Type: text/plain;
  charset="utf-8";
  name="net"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="net"

# This blank configuration will automatically use DHCP for any net.*
# scripts in /etc/init.d.  To create a more complete configuration,
# please review /etc/conf.d/net.example and save your configuration
# in /etc/conf.d/net (this file :]!).

#dns_domain_eth0="m1k0.com"

# config_eth0=( "dhcp" )
#config_eth0=( "192.168.2.32 netmask 255.255.255.0 broadcast 192.168.2.255" )
#routes_eth0=( "default via 192.168.2.1" )

# uzyskanie dynamicznego adresu ip                       
# config_eth1=("dhcp") 
  
# program uruchamiajcy interfejs WiFi 
##modules_wlan0=("wpa_supplicant")
	     
# przykadowa nazwa sterownika dla interfejsu WiFi 
##wpa_supplicant_wlan0="-Dwext" 
    
# modu sucy do pokazania informacji odnonie interfejsu WiFi 
##modules_wlan0=("iwconfig") 

# essid_wlan0="any"
# preferred_aps=( "m1k0" "ConnectionPoint" )
essid_wlan0="m1k0"
key_m1k0="99-C0-D0-BB-B9-CA-59-FE-9A-01-E5-8C-B3"
config_m1k0=( "192.168.2.30 netmask 255.255.255.0 broadcast 192.168.2.255" )
routes_m1k0=( "default via 192.168.2.1" )
#config_m1k0=( "dhcp" )
			   
# Internet over GPRS 
 config_ppp0=( "ppp" ) 
 
 link_ppp0="/dev/ttyACM0" 
 
 pppd_ppp0=( 
         "115200" 
         "crtscts" 
         "modem" 
 #       "-detach" 
         "noccp" 
         "defaultroute" 
         "usepeerdns" 
         "noauth" 
         "ipcp-accept-remote" 
         "ipcp-accept-local" 
         "noipdefault" 
 ) 
 
 phone_number_ppp0=( "*99***1#" ) 
 
 chat_ppp0=( 
         'ABORT' 'BUSY' 
         'ABORT' 'ERROR' 
         'ABORT' 'NO ANSWER' 
         'ABORT' 'NO CARRIER' 
         'ABORT' 'NO DIALTONE' 
         'ABORT' 'Invalid Login' 
         'ABORT' 'Login incorrect' 
         'TIMEOUT' '5' 
         '' 'ATZ' 
         'OK' 'AT+CGATT=0' 
         'OK' 'AT+CGDCONT=1,"IP","www.plusgsm.pl"' 
         'OK' 'ATD*99***1#' 
         'CONNECT' '' 
 )
   

--Boundary-00=_0AJYIMet9DZyZBD
Content-Type: text/x-objcsrc;
  charset="utf-8";
  name="net.lo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="net.lo"

#!/sbin/runscript
# Copyright 2004-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Contributed by Roy Marples (uberlord@gentoo.org)
# Many thanks to Aron Griffis (agriffis@gentoo.org)
# for help, ideas and patches

#NB: Config is in /etc/conf.d/net

# For pcmcia users. note that pcmcia must be added to the same
# runlevel as the net.* script that needs it.
depend() {
	need localmount
	after bootmisc hostname
	use isapnp isdn pcmcia usb wlan

	# Load any custom depend functions for the given interface
	# For example, br0 may need eth0 and eth1
	local iface="${SVCNAME#*.}"
	[[ $(type -t "depend_${iface}") == "function" ]] && depend_${iface}

	if [[ ${iface} != "lo" && ${iface} != "lo0" ]] ; then
		after net.lo net.lo0

		# Support new style RC_NEED and RC_USE in one net file
		local x="RC_NEED_${iface}"
		[[ -n ${!x} ]] && need ${!x}
		x="RC_USE_${iface}"
		[[ -n ${!x} ]] && use ${!x}
		x="RC_AFTER_${iface}"
		[[ -n ${!x} ]] && after ${!x}
		x="RC_BEFORE_${iface}"
		[[ -n ${!x} ]] && before ${!x}
		x="RC_PROVIDE_${iface}"
		[[ -n ${!x} ]] && provide ${!x}
	fi

	return 0
}

# Define where our modules are
MODULES_DIR="${svclib}/net"

# Make some wrappers to fudge after/before/need/use depend flags.
# These are callbacks so MODULE will be set.
after() {
	eval "${MODULE}_after() { echo \"$*\"; }"
}
before() {
	eval "${MODULE}_before() { echo \"$*\"; }"
}
need() {
	eval "${MODULE}_need() { echo \"$*\"; }"
}
installed() {
	# We deliberately misspell this as _installed will probably be used
	# at some point
	eval "${MODULE}_instlled() { echo \"$*\"; }"
}
provide() {
	eval "${MODULE}_provide() { echo \"$*\"; }"
}
functions() {
	eval "${MODULE}_functions() { echo \"$*\"; }"
}
variables() {
	eval "${MODULE}_variables() { echo \"$*\"; }"
}

is_loopback() {
	[[ $1 == "lo" || $1 == "lo0" ]]
}

# char* interface_device(char *iface)
#
# Gets the base device of the interface
# Can handle eth0:1 and eth0.1
# Which returns eth0 in this case
interface_device() {
	local dev="${1%%.*}"
	[[ ${dev} == "$1" ]] && dev="${1%%:*}"
	echo "${dev}"
}

# char* interface_type(char* iface)
#
# Returns the base type of the interface
# eth, ippp, etc
interface_type() {
	echo "${1%%[0-9]*}"
}

# int calculate_metric(char *interface, int base)
#
# Calculates the best metric for the interface
# We use this when we add routes so we can prefer interfaces over each other
calculate_metric() {
	local iface="$1" metric="$2"

	# Have we already got a metric?
	local m=$(awk '$1=="'${iface}'" && $2=="00000000" { print $7 }' \
		/proc/net/route)
	if [[ -n ${m} ]] ; then
		echo "${m}"
		return 0
	fi

	local i= dest= gw= flags= ref= u= m= mtu= metrics=
	while read i dest gw flags ref u m mtu ; do
		# Ignore lo
		is_loopback "${i}" && continue
		# We work out metrics from default routes only
		[[ ${dest} != "00000000" || ${gw} == "00000000" ]] && continue
		metrics="${metrics}\n${m}"
	done < /proc/net/route

	# Now, sort our metrics
	metrics=$(echo -e "${metrics}" | sort -n)

	# Now, find the lowest we can use
	local gotbase=false
	for m in ${metrics} ; do
		[[ ${m} -lt ${metric} ]] && continue
		[[ ${m} == ${metric} ]] && ((metric++))
		[[ ${m} -gt ${metric} ]] && break
	done
	
	echo "${metric}"
}

# int netmask2cidr(char *netmask)
#
# Returns the CIDR of a given netmask
netmask2cidr() {
	local binary= i= bin=

	for i in ${1//./ }; do
		bin=""
		while [[ ${i} != "0" ]] ; do
			bin=$[${i}%2]${bin}
			(( i=i>>1 ))
		done
		binary="${binary}${bin}"
	done
	binary="${binary%%0*}"
	echo "${#binary}"
}


# bool is_function(char* name)
#
# Returns 0 if the given name is a shell function, otherwise 1
is_function() {
	[[ -z $1 ]] && return 1
	[[ $(type -t "$1") == "function" ]]
}

# void function_wrap(char* source, char* target)
#
# wraps function calls - for example function_wrap(this, that)
# maps function names this_* to that_*
function_wrap() {
	local i=

	is_function "${2}_depend" && return

	for i in $(typeset -f | grep -o '^'"${1}"'_[^ ]*'); do
		eval "${2}${i#${1}}() { ${i} \"\$@\"; }"
	done
}

# char[] * expand_parameters(char *cmd)
#
# Returns an array after expanding parameters. For example
# "192.168.{1..3}.{1..3}/24 brd +"
# will return
# "192.168.1.1/24 brd +"
# "192.168.1.2/24 brd +"
# "192.168.1.3/24 brd +"
# "192.168.2.1/24 brd +"
# "192.168.2.2/24 brd +"
# "192.168.2.3/24 brd +"
# "192.168.3.1/24 brd +"
# "192.168.3.2/24 brd +"
# "192.168.3.3/24 brd +"
expand_parameters() {
	local x=$(eval echo ${@// /_})
	local -a a=( ${x} )

	a=( "${a[@]/#/\"}" )
	a=( "${a[@]/%/\"}" )
	echo "${a[*]//_/ }"
}

# void configure_variables(char *interface, char *option1, [char *option2])
#
# Maps configuration options from <variable>_<option> to <variable>_<iface>
# option2 takes precedence over option1
configure_variables() {
	local iface="$1" option1="$2" option2="$3"

	local mod= func= x= i=
	local -a ivars=() ovars1=() ovars2=()
	local ifvar=$(bash_variable "${iface}")

	for mod in ${MODULES[@]}; do
		is_function ${mod}_variables || continue
		for v in $(${mod}_variables) ; do
			x=
			[[ -n ${option2} ]] && x="${v}_${option2}[@]"
			[[ -z ${!x} ]] && x="${v}_${option1}[@]"
			[[ -n ${!x} ]] && eval "${v}_${ifvar}=( \"\${!x}\" )"
		done
	done

	return 0
}
# bool module_load_minimum(char *module)
#
# Does the minimum checking on a module - even when forcing
module_load_minimum() {
	local f="$1.sh" MODULE="${1##*/}"

	if [[ ! -f ${f} ]] ; then
		eerror "${f} does not exist"
		return 1
	fi

	if ! source "${f}" ; then
		eerror "${MODULE} failed a sanity check"
		return 1
	fi

	for f in depend; do
		is_function "${MODULE}_${f}" && continue
		eerror "${MODULE}.sh does not support the required function ${f}"
		return 1
	done

	return 0
}

# bool modules_load_auto()
#
# Load and check each module for sanity
# If the module is not installed, the functions are to be removed
modules_load_auto() {
	local i j inst

	# Populate the MODULES array
	# Basically we treat evey file in ${MODULES_DIR} as a module
	MODULES=( $( cd "${MODULES_DIR}" ; ls *.sh ) )
	j="${#MODULES[@]}"
	for (( i=0; i<j; i++ )); do
		MODULES[i]="${MODULES_DIR}/${MODULES[i]}"
		[[ ! -f ${MODULES[i]} ]] && unset MODULES[i]
	done
	MODULES=( "${MODULES[@]}" )

	# Each of these sources into the global namespace, so it's
	# important that module functions and variables are prefixed with
	# the module name, for example iproute2_

	j="${#MODULES[@]}"
	loaded_interface=false
	for (( i=0; i<j; i++ )); do
		MODULES[i]="${MODULES[i]%.sh*}"
		if [[ ${MODULES[i]##*/} == "interface" ]] ; then
			eerror "interface is a reserved name - cannot load a module called interface"
			return 1
		fi
		
		(
		u=0;
		module_load_minimum "${MODULES[i]}" || u=1;
		if [[ ${u} == 0 ]] ; then
			inst="${MODULES[i]##*/}_check_installed";
			if is_function "${inst}" ; then
				${inst} false || u=1;
			fi
		fi
		exit "${u}";
		)

		if [[ $? == 0 ]] ; then
			source "${MODULES[i]}.sh"
			MODULES[i]="${MODULES[i]##*/}"
		else
			unset MODULES[i]
		fi
	done

	MODULES=( "${MODULES[@]}" )
	return 0
}

# bool modules_check_installed(void)
#
# Ensure that all modules have the required modules loaded
# This enables us to remove modules from the MODULES array
# Whilst other modules can still explicitly call them
# One example of this is essidnet which configures network
# settings for the specific ESSID connected to as the user
# may be using a daemon to configure wireless instead of our
# iwconfig module
modules_check_installed() {
	local i j missingdeps nmods="${#MODULES[@]}"

	for (( i=0; i<nmods; i++ )); do
		is_function "${MODULES[i]}_instlled" || continue
		for j in $( ${MODULES[i]}_instlled ); do
			missingdeps=true
			if is_function "${j}_check_installed" ; then
				${j}_check_installed && missingdeps=false
			elif is_function "${j}_depend" ; then
				missingdeps=false
			fi
			${missingdeps} && unset MODULES[i] && unset PROVIDES[i] && break
		done
	done

	MODULES=( "${MODULES[@]}" )
	PROVIDES=( "${PROVIDES[@]}" )
}

# bool modules_check_user(void)
modules_check_user() {
	local iface="$1" ifvar=$(bash_variable "${IFACE}")
	local i= j= k= l= nmods="${#MODULES[@]}"
	local -a umods=()

	# Has the interface got any specific modules?
	umods="modules_${ifvar}[@]"
	umods=( "${!umods}" )

	# Global setting follows interface-specific setting
	umods=( "${umods[@]}" "${modules[@]}" )

	# Add our preferred modules
	local -a pmods=( "iproute2" "dhcpcd" "iwconfig" "netplugd" )
	umods=( "${umods[@]}" "${pmods[@]}" )

	# First we strip any modules that conflict from user settings
	# So if the user specifies pump then we don't use dhcpcd
	for (( i=0; i<${#umods[@]}; i++ )); do
		# Some users will inevitably put "dhcp" in their modules
		# list.  To keep users from screwing up their system this
		# way, ignore this setting so that the default dhcp
		# module will be used.
		[[ ${umods[i]} == "dhcp" ]] && continue

		# We remove any modules we explicitly don't want
		if [[ ${umods[i]} == "!"* ]] ; then
			for (( j=0; j<nmods; j++ )); do
				[[ -z ${MODULES[j]} ]] && continue
				if [[ ${umods[i]:1} == "${MODULES[j]}" \
					|| ${umods[i]:1} == "${PROVIDES[j]}" ]] ; then
					# We may need to setup a class wrapper for it even though
					# we don't use it directly
					# However, we put it into an array and wrap later as
					# another module may provide the same thing
					${MODULES[j]}_check_installed \
						&& WRAP_MODULES=(
							"${WRAP_MODULES[@]}"
							"${MODULES[j]} ${PROVIDES[j]}"
						)
					unset MODULES[j]
					unset PROVIDES[j]
				fi
			done
			continue
		fi

		if ! is_function "${umods[i]}_depend" ; then
			# If the module is one of our preferred modules, then
			# ignore this error; whatever is available will be
			# used instead.
			(( i < ${#umods[@]} - ${#pmods[@]} )) || continue

			# The function may not exist because the modules software is
			# not installed. Load the module and report its error
			if [[ -e "${MODULES_DIR}/${umods[i]}.sh" ]] ; then
				source "${MODULES_DIR}/${umods[i]}.sh"
				is_function "${umods[i]}_check_installed" \
					&& ${umods[i]}_check_installed true
			else
				eerror "The module \"${umods[i]}\" does not exist"
			fi
			return 1
		fi

		if is_function "${umods[i]}_provide" ; then
			mod=$(${umods[i]}_provide)
		else
			mod="${umods[i]}"
		fi
		for (( j=0; j<nmods; j++ )); do
			[[ -z ${MODULES[j]} ]] && continue
			if [[ ${PROVIDES[j]} == "${mod}" && ${umods[i]} != "${MODULES[j]}" ]] ; then
				# We don't have a match - now ensure that we still provide an
				# alternative. This is to handle our preferred modules.
				for (( l=0; l<nmods; l++ )); do
					[[ ${l} == "${j}" || -z ${MODULES[l]} ]] && continue
					if [[ ${PROVIDES[l]} == "${mod}" ]] ; then
						unset MODULES[j]
						unset PROVIDES[j]
						break
					fi
				done
			fi
		done
	done

	# Then we strip conflicting modules.
	# We only need to do this for 3rd party modules that conflict with
	# our own modules and the preferred list AND the user modules
	# list doesn't specify a preference.
	for (( i=0; i<nmods-1; i++ )); do
		[[ -z ${MODULES[i]} ]] && continue			
		for (( j=i+1; j<nmods; j++)); do
			[[ -z ${MODULES[j]} ]] && continue
			[[ ${PROVIDES[i]} == "${PROVIDES[j]}" ]] \
			&& unset MODULES[j] && unset PROVIDES[j]
		done
	done

	MODULES=( "${MODULES[@]}" )
	PROVIDES=( "${PROVIDES[@]}" )
	return 0
}

# void modules_sort(void)
#
# Sort our modules
modules_sort() {
	local i= j= nmods=${#MODULES[@]} m=
	local -a provide=() provide_list=() after=() dead=() sorted=() sortedp=()

	# Make our provide list
	for ((i=0; i<nmods; i++)); do
		dead[i]="false"
		if [[ ${MODULES[i]} != "${PROVIDES[i]}" ]] ; then
			local provided=false
			for ((j=0; j<${#provide[@]}; j++)); do
				if [[ ${provide[j]} == "${PROVIDES[i]}" ]] ; then
					provide_list[j]="${provide_list[j]} ${MODULES[i]}"
					provided=true
				fi
			done
			if ! ${provided}; then
				provide[j]="${PROVIDES[i]}"
				provide_list[j]="${MODULES[i]}"
			fi
		fi
	done

	# Create an after array, which holds which modules the module at
	# index i must be after
	for ((i=0; i<nmods; i++)); do
		if is_function "${MODULES[i]}_after" ; then
			after[i]=" ${after[i]} $(${MODULES[i]}_after) "
		fi
		if is_function "${MODULES[i]}_before" ; then
			for m in $(${MODULES[i]}_before); do
				for ((j=0; j<nmods; j++)) ; do
					if [[ ${PROVIDES[j]} == "${m}" ]] ; then
						after[j]=" ${after[j]} ${MODULES[i]} "
						break
					fi
				done
			done
		fi
	done

	# Replace the after list modules with real modules
	for ((i=0; i<nmods; i++)); do
		if [[ -n ${after[i]} ]] ; then
			for ((j=0; j<${#provide[@]}; j++)); do
				after[i]="${after[i]// ${provide[j]} / ${provide_list[j]} }"
			done
		fi
	done
	
	# We then use the below code to provide a topologial sort
    module_after_visit() {
        local name="$1" i= x=

		for ((i=0; i<nmods; i++)); do
			[[ ${MODULES[i]} == "$1" ]] && break
		done

        ${dead[i]} && return
        dead[i]="true"

        for x in ${after[i]} ; do
            module_after_visit "${x}"
        done

        sorted=( "${sorted[@]}" "${MODULES[i]}" )
		sortedp=( "${sortedp[@]}" "${PROVIDES[i]}" )
    }

	for x in ${MODULES[@]}; do
		module_after_visit "${x}"
	done

	MODULES=( "${sorted[@]}" )
	PROVIDES=( "${sortedp[@]}" )
}

# bool modules_check_depends(bool showprovides)
modules_check_depends() {
	local showprovides="${1:-false}" nmods="${#MODULES[@]}" i= j= needmod=
	local missingdeps= p= interface=false

	for (( i=0; i<nmods; i++ )); do
		if is_function "${MODULES[i]}_need" ; then
			for needmod in $(${MODULES[i]}_need); do
				missingdeps=true
				for (( j=0; j<nmods; j++ )); do
					if [[ ${needmod} == "${MODULES[j]}" \
						|| ${needmod} == "${PROVIDES[j]}" ]] ; then
						missingdeps=false
						break
					fi
				done
				if ${missingdeps} ; then
					eerror "${MODULES[i]} needs ${needmod} (dependency failure)"
					return 1
				fi
			done
		fi

		if is_function "${MODULES[i]}_functions" ; then
			for f in $(${MODULES[i]}_functions); do
				if ! is_function "${f}" ; then
					eerror "${MODULES[i]}: missing required function \"${f}\""
					return 1
				fi
			done
		fi

		[[ ${PROVIDES[i]} == "interface" ]] && interface=true

		if ${showprovides} ; then
			[[ ${PROVIDES[i]} != "${MODULES[i]}" ]] \
			&& veinfo "${MODULES[i]} provides ${PROVIDES[i]}"
		fi
	done

	if ! ${interface} ; then
		eerror "no interface module has been loaded"
		return 1
	fi

	return 0
}

# bool modules_load(char *iface, bool starting)
#
# Loads the defined handler and modules for the interface
# Returns 0 on success, otherwise 1
modules_load()  {
	local iface="$1" starting="${2:-true}" MODULE= p=false i= j= k=
	local -a x=()
	local RC_INDENTATION="${RC_INDENTATION}"
	local -a PROVIDES=() WRAP_MODULES=()

	if ! is_loopback "${iface}" ; then
		x="modules_force_${iface}[@]"
		[[ -n ${!x} ]] && modules_force=( "${!x}" )
		if [[ -n ${modules_force} ]] ; then
			ewarn "WARNING: You are forcing modules!"
			ewarn "Do not complain or file bugs if things start breaking"
			report=true
		fi
	fi

	veinfo "Loading networking modules for ${iface}"
	eindent

	if [[ -z ${modules_force} ]] ; then
		modules_load_auto || return 1
	else
		j="${#modules_force[@]}"
		for (( i=0; i<j; i++ )); do
			module_load_minimum "${MODULES_DIR}/${modules_force[i]}" || return 1
			if is_function "${modules_force[i]}_check_installed" ; then
				${modules_force[i]}_check_installed || unset modules_force[i]
			fi
		done
		MODULES=( "${modules_force[@]}" )
	fi

	j="${#MODULES[@]}"
	for (( i=0; i<j; i++ )); do
		# Now load our dependencies - we need to use the MODULE variable
		# here as the after/before/need functions use it
		MODULE="${MODULES[i]}"
		${MODULE}_depend

		# expose does exactly the same thing as depend
		# However it is more "correct" as it exposes things to other modules
		# instead of depending on them ;)
		is_function "${MODULES[i]}_expose" && ${MODULES[i]}_expose

		# If no provide is given, assume module name
		if is_function "${MODULES[i]}_provide" ; then
			PROVIDES[i]=$(${MODULES[i]}_provide)
		else
			PROVIDES[i]="${MODULES[i]}"
		fi
	done

	if [[ -n ${modules_force[@]} ]] ; then
		# Strip any duplicate modules providing the same thing
		j="${#MODULES[@]}"
		for (( i=0; i<j-1; i++ )); do
			[[ -z ${MODULES[i]} ]] && continue
			for (( k=i+1; k<j; k++ )); do
				if [[ ${PROVIDES[i]} == ${PROVIDES[k]} ]] ; then
					unset MODULES[k]
					unset PROVIDES[k]
				fi
			done
		done
		MODULES=( "${MODULES[@]}" )
		PROVIDES=( "${PROVIDES[@]}" )
	else
		if ${starting}; then
			modules_check_user "${iface}" || return 1
		else
			# Always prefer iproute2 for taking down interfaces
			if is_function iproute2_provide ; then
				function_wrap iproute2 "$(iproute2_provide)"
			fi
		fi
	fi
	
	# Wrap our modules
	j="${#MODULES[@]}"
	for (( i=0; i<j; i++ )); do
		function_wrap "${MODULES[i]}" "${PROVIDES[i]}"
	done
	j="${#WRAP_MODULES[@]}"
	for (( i=0; i<j; i++ )); do
		function_wrap ${WRAP_MODULES[i]}
	done
	
	if [[ -z ${modules_force[@]} ]] ; then
		modules_check_installed || return 1
		modules_sort || return 1
	fi

	veinfo "modules: ${MODULES[@]}"
	eindent

	${starting} && p=true
	modules_check_depends "${p}" || return 1
	return 0
}

# bool iface_start(char *interface)
#
# iface_start is called from start.  It's expected to start the base
# interface (for example "eth0"), aliases (for example "eth0:1") and to start
# VLAN interfaces (for example eth0.0, eth0.1).  VLAN setup is accomplished by
# calling itself recursively.
iface_start() {
	local iface="$1" mod config_counter="-1" x config_worked=false
	local RC_INDENTATION="${RC_INDENTATION}"
	local -a config=() fallback=() fallback_route=() conf=() a=() b=()
	local ifvar=$(bash_variable "$1") i= j= metric=0

	interface_exists "${iface}" && interface_up "${iface}"

	# pre Start any modules with
	for mod in ${MODULES[@]}; do
		if is_function "${mod}_pre_start" ; then
			${mod}_pre_start "${iface}" || { eend 1; return 1; }
		fi
	done

	interface_exists "${iface}" && interface_up "${iface}"

	x="metric_${ifvar}"
	# If we don't have a metric then calculate one
	# Our modules will set the metric variable to a suitable base
	# in their pre starts.
	if [[ -z ${!x} ]] ; then
		eval "metric_${ifvar}=\"$(calculate_metric "${iface}" "${metric}")\""
	fi

	# We now expand the configuration parameters and pray that the
	# fallbacks expand to the same number as config or there will be
	# trouble!
	a="config_${ifvar}[@]"
	a=( "${!a}" )
	for (( i=0; i<${#a[@]}; i++ )); do 
		eval b=( $(expand_parameters "${a[i]}") )
		config=( "${config[@]}" "${b[@]}" )
	done

	a="fallback_${ifvar}[@]"
	a=( "${!a}" )
	for (( i=0; i<${#a[@]}; i++ )); do 
		eval b=( $(expand_parameters "${a[i]}") )
		fallback=( "${fallback[@]}" "${b[@]}" )
	done

	# We don't expand routes
	fallback_route="fallback_route_${ifvar}[@]"
	fallback_route=( "${!fallback_route}" )
	
	# We must support old configs
	if [[ -z ${config} ]] ; then
		interface_get_old_config "${iface}" || return 1
		if [[ -n ${config} ]] ; then
			ewarn "You are using a deprecated configuration syntax for ${iface}"
			ewarn "You are advised to read /etc/conf.d/net.example and upgrade it accordingly"
		fi
	fi

	# Handle "noop" correctly
	if [[ ${config[0]} == "noop" ]] ; then
		if interface_is_up "${iface}" true ; then
			einfo "Keeping current configuration for ${iface}"
			eend 0
			return 0
		fi

		# Remove noop from the config var
		config=( "${config[@]:1}" )
	fi

	# Provide a default of DHCP if no configuration is set and we're auto
	# Otherwise a default of NULL
	if [[ -z ${config} ]] ; then
		ewarn "Configuration not set for ${iface} - assuming DHCP"
		if is_function "dhcp_start" ; then
			config=( "dhcp" )
		else
			eerror "No DHCP client installed"
			return 1
		fi
	fi

	einfo "Bringing up ${iface}"
	eindent
	for (( config_counter=0; config_counter<${#config[@]}; config_counter++ )); do
		# Handle null and noop correctly
		if [[ ${config[config_counter]} == "null" \
			|| ${config[config_counter]} == "noop" ]] ; then
			eend 0
			config_worked=true
			continue
		fi

		# We convert it to an array - this has the added
		# bonus of trimming spaces!
		conf=( ${config[config_counter]} )
		einfo "${conf[0]}"

		# Do we have a function for our config?
		if is_function "${conf[0]}_start" ; then
			eindent
			${conf[0]}_start "${iface}" ; x=$?
			eoutdent
			[[ ${x} == 0 ]] && config_worked=true && continue
			# We need to test to see if it's an IP address or a function
			# We do this by testing if the 1st character is a digit
		elif [[ ${conf[0]:0:1} == [[:digit:]] || ${conf[0]} == *:* ]] ; then
			x="0"
			if ! is_loopback "${iface}" ; then
				if [[ " ${MODULES[@]} " == *" arping "* ]] ; then
					if arping_address_exists "${iface}" "${conf[0]}" ; then
						eerror "${conf[0]%%/*} already taken on ${iface}"
						x="1"
					fi
				fi
			fi
			[[ ${x} == "0" ]] && interface_add_address "${iface}" ${conf[@]}; x="$?"
			eend "${x}" && config_worked=true && continue
		else
			if [[ ${conf[0]} == "dhcp" ]] ; then
				eerror "No DHCP client installed"
			else
				eerror "No loaded modules provide \"${conf[0]}\" (${conf[0]}_start)"
			fi
		fi

		if [[ -n ${fallback[config_counter]} ]] ; then
			einfo "Trying fallback configuration"
			config[config_counter]="${fallback[config_counter]}"
			fallback[config_counter]=""

			# Do we have a fallback route?
			if [[ -n ${fallback_route[config_counter]} ]] ; then
				x="fallback_route[config_counter]"
				eval "routes_${ifvar}=( \"\${!x}\" )"
				fallback_route[config_counter]=""
			fi

			(( config_counter-- )) # since the loop will increment it
			continue
		fi
	done
	eoutdent

	# We return failure if no configuration parameters worked
	${config_worked} || return 1

	# Start any modules with _post_start
	for mod in ${MODULES[@]}; do
		if is_function "${mod}_post_start" ; then
			${mod}_post_start "${iface}" || return 1
		fi
	done

	return 0
}

# bool iface_stop(char *interface)
#
# iface_stop: bring down an interface.  Don't trust information in
# /etc/conf.d/net since the configuration might have changed since
# iface_start ran.  Instead query for current configuration and bring
# down the interface.
iface_stop() {
	local iface="$1" i= aliases= need_begin=false mod=
	local RC_INDENTATION="${RC_INDENTATION}"

	# pre Stop any modules
	for mod in ${MODULES[@]}; do
		if is_function "${mod}_pre_stop" ; then
			${mod}_pre_stop "${iface}" || return 1
		fi
	done

	einfo "Bringing down ${iface}"
	eindent

	# Collect list of aliases for this interface.
	# List will be in reverse order.
	if interface_exists "${iface}" ; then
		aliases=$(interface_get_aliases_rev "${iface}")
	fi

	# Stop aliases before primary interface.
	# Note this must be done in reverse order, since ifconfig eth0:1 
	# will remove eth0:2, etc.  It might be sufficient to simply remove 
	# the base interface but we're being safe here.
	for i in ${aliases} ${iface}; do
		# Stop all our modules
		for mod in ${MODULES[@]}; do
			if is_function "${mod}_stop" ; then
				${mod}_stop "${i}" || return 1
			fi
		done

		# A module may have removed the interface
		if ! interface_exists "${iface}" ; then
			eend 0
			continue
		fi

		# We don't delete ppp assigned addresses
		if ! is_function pppd_exists || ! pppd_exists "${i}" ; then
			# Delete all the addresses for this alias
			interface_del_addresses "${i}"
		fi

		# Do final shut down of this alias
		if [[ ${IN_BACKGROUND} != "true" \
			&& ${RC_DOWN_INTERFACE} == "yes" ]] ; then
			ebegin "Shutting down ${i}"
			interface_iface_stop "${i}"
			eend "$?"
		fi
	done

	# post Stop any modules
	for mod in ${MODULES[@]}; do
		# We have already taken down the interface, so no need to error
		is_function "${mod}_post_stop" && ${mod}_post_stop "${iface}"
	done

	return 0
}

# bool run_start(char *iface)
#
# Brings up ${IFACE}.  Calls preup, iface_start, then postup.
# Returns 0 (success) unless preup or iface_start returns 1 (failure).
# Ignores the return value from postup.
# We cannot check that the device exists ourselves as modules like
# tuntap make create it.
run_start() {
	local iface="$1" IFVAR=$(bash_variable "$1")

	# We do this so users can specify additional addresses for lo if they
	# need too - additional routes too
	# However, no extra modules are loaded as they are just not needed
	if [[ ${iface} == "lo" ]] ; then
		metric_lo="0"
		config_lo=( "127.0.0.1/8 brd 127.255.255.255" "${config_lo[@]}" )
		routes_lo=( "127.0.0.0/8" "${routes_lo[@]}" )
	elif [[ ${iface} == "lo0" ]] ; then
		metric_lo0="0"
		config_lo0=( "127.0.0.1/8 brd 127.255.255.255" "${config_lo[@]}" )
		routes_lo0=( "127.0.0.0/8" "${routes_lo[@]}" )
	elif [[ -n ${metric} ]] ; then
		eval "metric_${IFVAR}=\"${metric}\""
	fi

	# We may not have a loaded module for ${iface}
	# Some users may have "alias natsemi eth0" in /etc/modules.d/foo
	# so we can work with this
	# However, if they do the same with eth1 and try to start it
	# but eth0 has not been loaded then the module gets loaded as
	# eth0.
	# Not much we can do about this :(
	# Also, we cannot error here as some modules - such as bridge
	# create interfaces
	if ! interface_exists "${iface}" ; then
		/sbin/modprobe "${iface}" &>/dev/null
	fi

	# Call user-defined preup function if it exists
	if is_function preup ; then
		einfo "Running preup function"
		eindent
		( preup "${iface}" )
		eend "$?" "preup ${iface} failed" || return 1
		eoutdent
	fi

	# If config is set to noop and the interface is up with an address
	# then we don't start it
	local config=
	config="config_${IFVAR}[@]"
	config=( "${!config}" )
	if [[ ${config[0]} == "noop" ]] && interface_is_up "${iface}" true ; then
		einfo "Keeping current configuration for ${iface}"
		eend 0
	else
		# Remove noop from the config var
		[[ ${config[0]} == "noop" ]] \
			&& eval "config_${IFVAR}=( "\"\$\{config\[@\]:1\}\"" )"

		# There may be existing ip address info - so we strip it
		if [[ ${RC_INTERFACE_KEEP_CONFIG} != "yes" \
			&& ${IN_BACKGROUND} != "true" ]] ; then
			interface_del_addresses "${iface}"
		fi

		# Start the interface
		if ! iface_start "${iface}" ; then
			if [[ ${IN_BACKGROUND} != "true" ]] ; then
				interface_exists "${iface}" && interface_down "${iface}"
			fi
			eend 1
			return 1
		fi
	fi

	# Call user-defined postup function if it exists
	if is_function postup ; then
		# We need to mark the service as started incase a
		# postdown function wants to restart services that depend on us
		mark_service_started "net.${iface}"
		end_service "net.${iface}" 0
		einfo "Running postup function"
		eindent
		( postup "${iface}" )
		eoutdent
	fi

	return 0
}

# bool run_stop(char *iface) {
#
# Brings down ${iface}.  If predown call returns non-zero, then
# stop returns non-zero to indicate failure bringing down device.
# In all other cases stop returns 0 to indicate success.
run_stop() {
	local iface="$1" IFVAR=$(bash_variable "$1") x

	# Load our ESSID variable so users can use it in predown() instead
	# of having to write code.
	local ESSID=$(get_options ESSID) ESSIDVAR=
	[[ -n ${ESSID} ]] && ESSIDVAR=$(bash_variable "${ESSID}")

	# Call user-defined predown function if it exists
	if is_function predown ; then
		einfo "Running predown function"
		eindent
		( predown "${iface}" )
		eend $? "predown ${iface} failed" || return 1
		eoutdent
	elif is_net_fs / ; then
		eerror "root filesystem is network mounted -- can't stop ${iface}"
		return 1
	elif is_union_fs / ; then
		for x in $(unionctl "${dir}" --list \
		| sed -e 's/^\(.*\) .*/\1/') ; do
			if is_net_fs "${x}" ; then
				eerror "Part of the root filesystem is network mounted - cannot stop ${iface}"
				return 1
			fi
		done
	fi

	iface_stop "${iface}" || return 1  # always succeeds, btw

	# Release resolv.conf information.
	[[ -x /sbin/resolvconf ]] && resolvconf -d "${iface}"
	
	# Mark us as inactive if called from the background
	[[ ${IN_BACKGROUND} == "true" ]] && mark_service_inactive "net.${iface}"

	# Call user-defined postdown function if it exists
	if is_function postdown ; then
		# We need to mark the service as stopped incase a
		# postdown function wants to restart services that depend on us
		[[ ${IN_BACKGROUND} != "true" ]] && mark_service_stopped "net.${iface}"
		end_service "net.${iface}" 0
		einfo "Running postdown function"
		eindent
		( postdown "${iface}" )
		eoutdent
	fi


	return 0
}

# bool run(char *iface, char *cmd)
#
# Main start/stop entry point
# We load modules here and remove any functions that they
# added as we may be called inside the same shell scope for another interface
run() {
	local iface="$1" cmd="$2" r=1 RC_INDENTATION="${RC_INDENTATION}"
	local starting=true
	local -a MODULES=() mods=()
	local IN_BACKGROUND="${IN_BACKGROUND}"

	if [[ ${IN_BACKGROUND} == "true" || ${IN_BACKGROUND} == "1" ]] ; then
		IN_BACKGROUND=true
	else
		IN_BACKGROUND=false
	fi

	# We need to override the exit function as runscript.sh now checks
	# for it. We need it so we can mark the service as inactive ourselves.
	unset -f exit

	eindent
	[[ ${cmd} == "stop" ]] && starting=false

	# We force lo to only use these modules for a major speed boost
	if is_loopback "${iface}" ; then	
		modules_force=( "iproute2" "ifconfig" "system" )
	fi

	if modules_load "${iface}" "${starting}" ; then
		if [[ ${cmd} == "stop" ]] ; then
			# Reverse the module list for stopping
			mods=( "${MODULES[@]}" )
			for ((i = 0; i < ${#mods[@]}; i++)); do
				MODULES[i]=${mods[((${#mods[@]} - i - 1))]}
			done

			run_stop "${iface}" && r=0
		else
			# Only hotplug on ethernet interfaces
			if [[ ${IN_HOTPLUG} == 1 ]] ; then
				if ! interface_is_ethernet "${iface}" ; then
					eerror "We only hotplug for ethernet interfaces"
					return 1
				fi
			fi

			run_start "${iface}" && r=0
		fi
	fi

	if [[ ${r} != "0" ]] ; then
		if [[ ${cmd} == "start" ]] ; then
			# Call user-defined failup if it exists
			if is_function failup ; then
				einfo "Running failup function"
				eindent
				( failup "${iface}" )
				eoutdent
			fi
		else
			# Call user-defined faildown if it exists
			if is_function faildown ; then
				einfo "Running faildown function"
				eindent
				( faildown "${iface}" )
				eoutdent
			fi
		fi
		[[ ${IN_BACKGROUND} == "true" ]] \
			&& mark_service_inactive "net.${iface}"
	fi

	return "${r}"
}

# bool start(void)
#
# Start entry point so that we only have one function
# which localises variables and unsets functions
start() {
	declare -r IFACE="${SVCNAME#*.}"
	einfo "Starting ${IFACE}"
	run "${IFACE}" start
}

# bool stop(void)
#
# Stop entry point so that we only have one function
# which localises variables and unsets functions
stop() {
	declare -r IFACE="${SVCNAME#*.}"
	einfo "Stopping ${IFACE}"
	run "${IFACE}" stop
}

# vim:ts=4

--Boundary-00=_0AJYIMet9DZyZBD--
