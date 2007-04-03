Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXDCXvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXDCXvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030357AbXDCXvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:51:53 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41271 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224AbXDCXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:51:51 -0400
Subject: Re: 2.6.21-rc5-mm4
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com>
	 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
	 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 16:51:54 -0700
Message-Id: <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 16:40 -0700, Christoph Lameter wrote:
> On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> 
> > > x86_64 with numa emulation 4 nodes boots fine here.
> > 
> > Not sure, if this helps any (slub_debug = 1) :(
> 
> Specify only slub_debug. The 1 is not recognized by SLUB so there were no 
> debug options set.
> 
> > Linux version 2.6.21-rc5-mm4 (root@elm3b29) (gcc version 4.1.0 (SUSE
> > Linux)) #2 SMP Tue Apr 3 17:36:21 PDT 2007
> > Command line: root=/dev/hda2 vga=0x314  selinux=0   console=tty0
> > console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent
> > showopts
> 
> ^^^ I see no slub_debug option set.

Hmm. booted fine with slub_debug :(

Linux version 2.6.21-rc5-mm4 (root@elm3b29) (gcc version 4.1.0 (SUSE Linux)) #2 SMP Tue Apr 3 17:36:21 PDT 2007
Command line: root=/dev/hda2 vga=0x314  slub_debug selinux=0   console=tty0 console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent showopts
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfef0000 (usable)
 BIOS-e820: 00000000dfef0000 - 00000000dfeff000 (ACPI data)
 BIOS-e820: 00000000dfeff000 - 00000000dff00000 (ACPI NVS)
 BIOS-e820: 00000000dff00000 - 00000000e0000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001e0000000 (usable)
end_pfn_map = 1966080
DMI 2.3 present.
ACPI: RSDP 000F6970, 0024 (r2 PTLTD )
ACPI: XSDT DFEFC625, 003C (r1 PTLTD      XSDT    6040000  LTP        0)
ACPI: FACP DFEFED02, 00F4 (r3 AMD    HAMMER    6040000 PTEC    F4240)
ACPI: DSDT DFEFC661, 262D (r1 AMD-K8  AMDACPI  6040000 MSFT  100000D)
ACPI: FACS DFEFFFC0, 0040
ACPI: SRAT DFEFEDF6, 0160 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: APIC DFEFEF56, 00AA (r1 PTLTD      APIC    6040000  LTP        0)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 1 -> APIC 1 -> Node 1
SRAT: PXM 2 -> APIC 2 -> Node 2
SRAT: PXM 3 -> APIC 3 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-e0000000
SRAT: Node 0 PXM 0 0-180000000
SRAT: PXM 1 (100000000-1a0000000) overlaps with PXM 0 (0-180000000)
SRAT: SRAT not used.
Scanning NUMA topology in Northbridge 24
Number of nodes 4
Node 0 MemBase 0000000000000000 Limit 0000000180000000
Node 1 MemBase 0000000180000000 Limit 00000001a0000000
Node 2 MemBase 00000001a0000000 Limit 00000001c0000000
Node 3 MemBase 00000001c0000000 Limit 00000001e0000000
Using node hash shift of 29
Bootmem setup node 0 0000000000000000-0000000180000000
Bootmem setup node 1 0000000180000000-00000001a0000000
Bootmem setup node 2 00000001a0000000-00000001c0000000
Bootmem setup node 3 00000001c0000000-00000001e0000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1966080
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0:        0 ->      159
    0:      256 ->   917232
    0:   917248 ->   917504
    0:  1048576 ->  1572864
    1:  1572864 ->  1703936
    2:  1703936 ->  1835008
    3:  1835008 ->  1966080
ACPI: PM-Timer IO Port: 0x8008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfa3e0000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xfa3e0000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xfa3e1000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xfa3e1000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xfa3e2000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xfa3e2000, GSI 32-35
ACPI: IOAPIC (id[0x08] address[0xfa3e4000] gsi_base[36])
IOAPIC[4]: apic_id 8, address 0xfa3e4000, GSI 36-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
PERCPU: Allocating 41984 bytes of per cpu data
Built 4 zonelists.  Total pages: 1771993
Kernel command line: root=/dev/hda2 vga=0x314  slub_debug selinux=0   console=tty0 console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent showoptsInitializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 1398.208 MHz processor.
Console: colour dummy device 80x25
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 7021948k/7864320k available (3113k kernel code, 317632k reserved, 1229k data, 364k init)
SLUB V6: General Slabs=18, HW alignment=128, Processors=4, Nodes=64
Calibrating delay using timer specific routine.. 2798.98 BogoMIPS (lpj=5597964)
Security Framework v1.0.0 initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
Freeing SMP alternatives: 36k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12484009
Detected 12.484 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 2796.59 BogoMIPS (lpj=5593189)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 1
Opteron MP w/ 1MB stepping 00
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 2796.59 BogoMIPS (lpj=5593186)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 2
Opteron MP w/ 1MB stepping 00
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 2796.59 BogoMIPS (lpj=5593188)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 3
Opteron MP w/ 1MB stepping 00
Brought up 4 CPUs
migration_cost=0,764
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
0000:00:07.1: cannot adjust BAR0 (not I/O)
0000:00:07.1: cannot adjust BAR1 (not I/O)
0000:00:07.1: cannot adjust BAR2 (not I/O)
0000:00:07.1: cannot adjust BAR3 (not I/O)
ACPI: PCI Root Bridge [PCI1] (0000:08)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 *5 10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 10 *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 14 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
pnp: 00:05: ioport range 0x4d0-0x4d1 has been reserved
Time: tsc clocksource has been installed.
pnp: 00:05: ioport range 0x1100-0x117f has been reserved
pnp: 00:05: ioport range 0x1180-0x11ff has been reserved
pnp: 00:06: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:06: iomem range 0xc0000-0xc87ff has been reserved
pnp: 00:06: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:06: iomem range 0xffc00000-0xfff7ffff has been reserved
PCI: Bridge: 0000:00:06.0
Time: acpi_pm clocksource has been installed.
  IO window: 2000-2fff
  MEM window: fa000000-fa0fffff
  PREFETCH window: e2000000-e20fffff
PCI: Bridge: 0000:09:01.0
  IO window: disabled.
  MEM window: fa400000-faffffff
  PREFETCH window: fc000000-fdffffff
PCI: Bridge: 0000:08:01.0
  IO window: disabled.
  MEM window: fa400000-faffffff
  PREFETCH window: fc000000-fdffffff
PCI: Bridge: 0000:08:02.0
  IO window: 3000-3fff
  MEM window: fb000000-fb0fffff
  PREFETCH window: e2100000-e21fffff
PCI: Bridge: 0000:08:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:08:04.0
  IO window: 4000-4fff
  MEM window: fb100000-fb1fffff
  PREFETCH window: e2200000-e22fffff
ACPI: PCI Interrupt 0000:08:04.0[A] -> GSI 36 (level, low) -> IRQ 36
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 1048576 (order: 12, 25165824 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 1048576 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
vesafb: framebuffer at 0xfc000000, mapped to 0xffffc20002780000, using 1875k, total 16384k
vesafb: mode is 800x600x16, linelength=1600, pages=16
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
AMD768 RNG detected
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
loop: module loaded
tg3.c:v3.75 (March 23, 2007)
ACPI: PCI Interrupt 0000:19:02.0[A] -> GSI 38 (level, low) -> IRQ 38
eth0: Tigon3 [partno(3C996B-T) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:04:76:f0:f9:aa
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[76ff000f] dma_mask[64-bit]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD8111: IDE controller at PCI slot 0000:00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
    ide0: BM-DMA at 0x1020-0x1027, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1028-0x102f, BIOS settings: hdc:DMA, hdd:pio
hda: IC35L080AVVA07-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: TOSHIBA DVD-ROM SD-M1612, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2
hdc: ATAPI 48X DVD-ROM drive, 512kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
input: PS/2 Generic Mouse as /class/input/input2
async_tx: api initialized (sync-only)
xor: automatically using best checksumming function: generic_sse
   generic_sse:  4488.000 MB/sec
xor: using function: generic_sse (4488.000 MB/sec)
TCP cubic registered
NET: Registered protocol family 1
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ReiserFS: hda2: found reiserfs format "3.6" with standard journal
ReiserFS: hda2: using ordered data mode
ReiserFS: hda2: journal params: device hda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda2: checking transaction log (hda2)
ReiserFS: hda2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 364k freed
INIT: version 2.86 booting
System Boot Control: Running /etc/init.d/boot
Mounting procfs at /proc                                             done
Mounting sysfs at /sys                                               done
Mounting tmpfs at /dev                                               done
Initializing /dev                                                    done
Mounting devpts at /dev/pts                                          done
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
lp0: using parport0 (interrupt-driven).
Starting udevd Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
                                                                     done
Activating swap-devices in /etc/fstab...                             done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
/bin/mknod -m600 /dev/shm/root b 3 2
Checking root file system...
fsck 1.40-WIP (02-Oct-2006)
[/sbin/fsck.reiserfs (1) -- /dev/shm/root] fsck.reiserfs -a /dev/shm/root
Reiserfs super block in block 16 on 0x302 of format 3.6 with standard journal
Blocks (total/free): 19842352/8198650 by 4096 bytes
Filesystem is clean
Filesystem seems mounted read-only. Skipping journal replay.
Checking internal tree..finished                                     done
Loading required kernel modules                                      done
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.comActivating device mapper...
                                                                     done
Starting MD Raid                                                     done
Waiting for udev to settle...
Scanning for LVM volume groups...
  Reading all physical volumes.  This may take a while...
  No volume groups found
  No volume groups found
Activating LVM volume groups...
  No volume groups found
                                                                     done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
Checking file systems...
fsck 1.40-WIP (02-Oct-2006)
Checking all file systems.                                           done
                                                                     done
Mounting local file systems...
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
udev on /dev type tmpfs (rw)
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
nothing was mounted                                                  done
Setting up the hardware clock                                        done
FATAL: Module apparmor not found.
Loading AppArmor module                                              failed
- could not start AppArmor                                           failed
Creating /var/log/boot.msg                                           done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
Setting up hostname 'elm3b29'                                        done
Setting up loopback interface     lo
    lo        IP address: 127.0.0.1/8
                                                                     done
Activating remaining swap-devices in /etc/fstab...
Adding 1048784k swap on /dev/hda1.  Priority:-1 extents:1 across:1048done
Setting current sysctl status from /etc/sysctl.conf
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.rp_filter = 1
                                                                     done
Enabling syn flood protection                                        done
Disabling IP forwarding                                              done
                                                                     done
System Boot Control: The system has been                             set up
Skipped features:                                             boot.cycle
System Boot Control: Running /etc/init.d/boot.local                  done
INIT: Entering runlevel: 3
blogd: Warning: the ioctl TIOCGDEV is not known by the kernel
Boot logging started on /dev/ttyS0(/dev/console) at Tue Apr  3 17:52:03 2007
Master Resource Control: previous runlevel: N, switching to runlevel:3
FATAL: Module apparmor not found.
Loading AppArmor module                                              failed
- could not start AppArmor                                           failed
Initializing random number generator                                 done
Starting resource manager                                            done
Starting D-BUS daemon                                                done
input: Power Button (FF) as /class/input/input3                      done

ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input4
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
[acpid]: starting up

[acpid]: 0 rules loaded

acpid: loading ACPI modules ( ac battery button fan processor thermaldone
acpid: will skip unsupported modules
acpid: loading ACPI laptop modules ( )                               done
Starting acpid                                                       done
Starting EWLM daemon
Starting HAL daemon                                                  done


