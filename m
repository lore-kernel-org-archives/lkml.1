Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414Ab0AGLnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab0AGLnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366Ab0AGLnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:43:14 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44770 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0AGLnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:43:12 -0500
Subject: 2.6.33-rc2 kernel failed to boot up
From: Munipradeep Beerakam <mpradeep@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-Wtq15UdA7zPXLoQl4+rJ"
Date: Thu, 07 Jan 2010 17:13:08 +0530
Message-ID: <1262864588.7157.13.camel@munipradeep-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Wtq15UdA7zPXLoQl4+rJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

I compiled 2.6.33-rc2 kernel and tried to boot into it. During booting
it halted at some point near dracut. Attached the boot log below.

Please CC me to the replies to this mail.

Thanks
Muni

--=-Wtq15UdA7zPXLoQl4+rJ
Content-Disposition: attachment; filename="boot_log.txt"
Content-Type: text/plain; name="boot_log.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

root (hd1,0)
 Filesystem type is ext2fs, partition type 0x83
kernel /vmlinuz-2.6.33-rc2  ro root=UUID=4dcf190a-01be-4254-9826-ff516d4a94c4
LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us console=
tty0 console=ttyS1,19200n1 earlyprintk=serial, crashkernel=auto selinux=0
   [Linux-bzImage, setup=0x3400, size=0x362940]
initrd /initramfs-2.6.33-rc2.img
   [Linux-initrd @ 0x37480000, 0xb6fcde bytes]

Probing EDD (edd=off to disable)... ok


console [ttyS1] enabled, bootconsole disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 2999.787 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5999.57 BogoMIPS (lpj=2999787)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20091214
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1lockdep: fixing up alternatives.
 #2lockdep: fixing up alternatives.
 #3 Ok.
Brought up 4 CPUs
Total of 4 processors activated (23999.67 BogoMIPS).
regulator: core version 0.5
Time:  6:57:47  Date: 01/07/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-0f] at [mem 0xe0000000-0xe0ffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe0ffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:02.0: PCI bridge to [bus 07-0b]
pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:07:00.0: PCI bridge to [bus 09-0b]
pci 0000:09:00.0: PCI bridge to [bus 0b-0b]
pci 0000:09:01.0: PCI bridge to [bus 0a-0a]
pci 0000:07:00.3: PCI bridge to [bus 08-08]
pci 0000:00:03.0: PCI bridge to [bus 0f-0f]
pci 0000:00:04.0: PCI bridge to [bus 0c-0d]
pci 0000:00:05.0: PCI bridge to [bus 0e-0e]
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:06.0: PCI bridge to [bus 03-04]
pci 0000:03:00.0: PCI bridge to [bus 04-04]
pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:07.0: PCI bridge to [bus 05-06]
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
vgaarb: device added: PCI:0000:01:01.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
kstop/0 used greatest stack depth: 6408 bytes left
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [io  0x0c00-0x0c1f] has been reserved
system 00:01: [io  0x0c60-0x0c67] has been reserved
system 00:0a: [io  0x0c28] has been reserved
system 00:0a: [io  0x0c2c] has been reserved
system 00:0b: [io  0x0400-0x043f] has been reserved
system 00:0b: [io  0x0440-0x045f] has been reserved
system 00:0b: [io  0x04d0-0x04d1] has been reserved
system 00:0b: [io  0x0c60-0x0c7f] could not be reserved
system 00:0b: [io  0x0ce0-0x0cff] could not be reserved
system 00:0b: [io  0x0580-0x05ff] has been reserved
system 00:0b: [io  0x0c30] has been reserved
system 00:0b: [io  0x0c34] has been reserved
system 00:0b: [io  0x0c40-0x0c5f] has been reserved
system 00:0b: [io  0x0ca8] has been reserved
system 00:0b: [io  0x0cac] has been reserved
system 00:0b: [io  0x0cb0] has been reserved
system 00:0b: [io  0x0cb4] has been reserved
system 00:0b: [io  0x0cc0-0x0cdf] has been reserved
system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0b: [mem 0xfe000000-0xfe01ffff] has been reserved
system 00:0b: [mem 0xfe020000-0xfe6fffff] has been reserved
system 00:0b: [mem 0xfe700400-0xfebfffff] has been reserved
system 00:0b: [mem 0xfff00000-0xffffffff] has been reserved
pci 0000:00:1c.0: BAR 15: assigned [mem 0xd0000000-0xd00fffff pref]
pci 0000:09:00.0: PCI bridge to [bus 0b-0b]
pci 0000:09:00.0:   bridge window [io  disabled]
pci 0000:09:00.0:   bridge window [mem disabled]
pci 0000:09:00.0:   bridge window [mem pref disabled]
pci 0000:09:01.0: PCI bridge to [bus 0a-0a]
pci 0000:09:01.0:   bridge window [io  disabled]
pci 0000:09:01.0:   bridge window [mem disabled]
pci 0000:09:01.0:   bridge window [mem pref disabled]
pci 0000:07:00.0: PCI bridge to [bus 09-0b]
pci 0000:07:00.0:   bridge window [io  disabled]
pci 0000:07:00.0:   bridge window [mem disabled]
pci 0000:07:00.0:   bridge window [mem pref disabled]
pci 0000:07:00.3: PCI bridge to [bus 08-08]
pci 0000:07:00.3:   bridge window [io  disabled]
pci 0000:07:00.3:   bridge window [mem disabled]
pci 0000:07:00.3:   bridge window [mem pref disabled]
pci 0000:00:02.0: PCI bridge to [bus 07-0b]
pci 0000:00:02.0:   bridge window [io  disabled]
pci 0000:00:02.0:   bridge window [mem disabled]
pci 0000:00:02.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 0f-0f]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem disabled]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI bridge to [bus 0c-0d]
pci 0000:00:04.0:   bridge window [io  disabled]
pci 0000:00:04.0:   bridge window [mem disabled]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 0e-0e]
pci 0000:00:05.0:   bridge window [io  0x5000-0xffff]
pci 0000:00:05.0:   bridge window [mem disabled]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:03:00.0: PCI bridge to [bus 04-04]
pci 0000:03:00.0:   bridge window [io  disabled]
pci 0000:03:00.0:   bridge window [mem 0xda000000-0xdcffffff]
pci 0000:03:00.0:   bridge window [mem pref disabled]
pci 0000:00:06.0: PCI bridge to [bus 03-04]
pci 0000:00:06.0:   bridge window [io  disabled]
pci 0000:00:06.0:   bridge window [mem 0xda000000-0xdcffffff]
pci 0000:00:06.0:   bridge window [mem pref disabled]
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:05:00.0:   bridge window [io  disabled]
pci 0000:05:00.0:   bridge window [mem 0xd7000000-0xd9ffffff]
pci 0000:05:00.0:   bridge window [mem pref disabled]
pci 0000:00:07.0: PCI bridge to [bus 05-06]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem 0xd7000000-0xd9ffffff]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:02:00.0: BAR 6: assigned [mem 0xd0000000-0xd00fffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.0:   bridge window [mem 0xdd000000-0xdeffffff]
pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd00fffff pref]
pci 0000:01:01.0: BAR 6: assigned [mem 0xf8020000-0xf803ffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 01-01]
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xf8000000-0xf8ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 6, 327680 bytes)
UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
NET: Registered protocol family 1
pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 11711k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
audit: initializing netlink socket (disabled)
type=2000 audit(1262847464.120:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7874
cryptomgr_test used greatest stack depth: 5896 bytes left
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pci-stub: invalid id string ""
cryptomgr_test used greatest stack depth: 5832 bytes left
cryptomgr_test used greatest stack depth: 5736 bytes left
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
erial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:03: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input1
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.33-rc2 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 18, io base 0x00002200
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00002600
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb 1-3: new high speed USB device using ehci_hcd and address 3
usb usb3: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 19, io base 0x00002800
usb 1-3: New USB device found, idVendor=0424, idProduct=2502
usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos 00:07: RTC can wake from S4
usb 2-2: new full speed USB device using uhci_hcd and address 2
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, 242 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
usb 2-2: New USB device found, idVendor=04b3, idProduct=4004
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-2: Product: IBM MM2
usb 2-2: Manufacturer: IBM
usb 2-2: SerialNumber: 0000000010002
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
input: IBM IBM MM2 as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input2
generic-usb 0003:04B3:4004.0001: input,hidraw0: USB HID v1.10 Keyboard [IBM IBM MM2] on usb-0000:00:1d.0-2/input0
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
input: IBM IBM MM2 as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input3
generic-usb 0003:04B3:4004.0002: input,hidraw1: USB HID v1.10 Mouse [IBM IBM MM2] on usb-0000:00:1d.0-2/input1
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
  Magic number: 10:569:973
rtc_cmos 00:07: setting system clock to 2010-01-07 06:57:56 UTC (1262847476)
Initalizing network drop monitor service
Freeing unused kernel memory: 2632k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1872k freed
Freeing unused kernel memory: 1784k freed
mknod used greatest stack depth: 5680 bytes left
mount used greatest stack depth: 5160 bytes left
dracut: dracut-002-25.git44a6a0d9.el6.1
dracut: dracut-002-25.git44a6a0d9.el6.1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
udev: starting version 145
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:01:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[drm] radeon: Initializing kernel modesetting.
[drm] register mmio base: 0xF8000000
[drm] register mmio size: 65536
[drm] GPU reset succeed (RBBM_STATUS=0x00000140)
[drm] radeon: VRAM 64M
[drm] radeon: VRAM from 0x00000000 to 0x03FFFFFF
[drm] radeon: GTT 512M
[drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=64M, BAR=128M
[drm] RAM width 16bits DDR
[TTM] Zone  kernel: Available graphics memory: 2019004 kiB.
[drm] radeon: 16M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] radeon: cp idle (0x00008080)
[drm] Loading R100 Microcode
platform radeon_cp.0: firmware: requesting radeon/R100_cp.bin
[drm] radeon: ring at 0x0000000020000000
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] No valid Ext TMDS info found in BIOS
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   DVI-D
[drm]   HPD2
[drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[drm]   Encoders:
[drm]     DFP2: INTERNAL_DVO1
[drm] fb mappable at 0xF0040000
[drm] vram apper at 0xF0000000
[drm] size 786432
[drm] fb depth is 8
[drm]    pitch is 1024
[drm] TMDS-10: set mode 1024x768 1d
[drm:radeon_i2c_sw_put_byte] *ERROR* i2c 0x08 0x30 write failed
[drm:radeon_i2c_sw_put_byte] *ERROR* i2c 0x09 0x00 write failed
[drm:radeon_i2c_sw_put_byte] *ERROR* i2c 0x0a 0x90 write failed
[drm:radeon_i2c_sw_put_byte] *ERROR* i2c 0x0c 0x89 write failed
[drm:radeon_i2c_sw_put_byte] *ERROR* i2c 0x08 0x3b write failed
Console: switching to colour frame buffer device 128x48
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.0.0 20080528 for 0000:01:01.0 on minor 0
modprobe used greatest stack depth: 3440 bytes left
dracut: Startingdracut: Starting plymouth daemon
 plymouth daemon
dracut: error: unexpectedly disconnected from boot status daemon
dracut: Mounted root filesystem /dev/sdc2

--=-Wtq15UdA7zPXLoQl4+rJ--

