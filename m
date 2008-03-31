Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYCaQwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYCaQwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYCaQwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:52:34 -0400
Received: from smtp2.infomaniak.ch ([84.16.68.90]:52189 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYCaQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:52:30 -0400
X-Greylist: delayed 1708 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Mar 2008 12:52:29 EDT
From: Didier Raboud <didier@raboud.com>
To: linux-kernel@vger.kernel.org
Subject: =?utf-8?q?2=2E6=2E25-rc7=C2=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?utf-8?q?_Dell_Latitude?= D630
Date: Mon, 31 Mar 2008 18:23:34 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, debian-kernel@lists.debian.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8687908.0KJcU4fV75";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803311823.36693.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp2 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8687908.0KJcU4fV75
Content-Type: multipart/mixed;
  boundary="Boundary-01=_GAR8HpowvbkYvMZ"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_GAR8HpowvbkYvMZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,=20

I'm using the latest Debian 2.6.25-rc7 kernel [0] and I have big troubles w=
ith=20
hibernation. With this version, the hibernation (suspend on disk) is=20
sometimes not resuming correctly. The only thing I get is a blinking cursor=
=20
at the top-left of the screen. The problem is that it is not easily=20
reproducible=C2=A0: sometimes it works, sometimes not.

AFAIK, 2.6.24 is not affected, but 2.6.25-rc6 and -rc7 (at least) are.

I'm using a Dell Latitude D630. (lspci attached).

Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two successful=20
hibernate/resume cycles.

Regards,=20

Didier Raboud, aka OdyX

N.B. Please keep me CC'ed as I'm not subscribed to the lists.

[0] http://wiki.debian.org/DebianKernel

--Boundary-01=_GAR8HpowvbkYvMZ
Content-Type: text/plain;
  charset="utf-8";
  name="d630_lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="d630_lspci"

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02)
09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M Gigabit Ethernet PCI Express (rev 02)
0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)

--Boundary-01=_GAR8HpowvbkYvMZ
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg_hibernateTwice_2.6.25-rc7"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg_hibernateTwice_2.6.25-rc7"

0000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] time.c: Detected 2194.499 MHz processor.
[    0.000022] Console: colour dummy device 80x25
[    0.000025] console [tty0] enabled
[    0.000047] Checking aperture...
[    0.000059] Calgary: detecting Calgary via BIOS EBDA area
[    0.000060] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2046156k/2087424k available (2205k kernel code, 4088=
0k reserved, 1027k data, 372k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.080007] Calibrating delay using timer specific routine.. 4394.05 Bog=
oMIPS (lpj=3D8788102)
[    0.080051] Security Framework initialized
[    0.080056] SELinux:  Disabled at boot.
[    0.080060] Capability LSM initialized
[    0.080268] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[    0.081480] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[    0.082099] Mount-cache hash table entries: 256
[    0.082249] Initializing cgroup subsys ns
[    0.082253] Initializing cgroup subsys cpuacct
[    0.082273] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.082274] CPU: L2 cache: 4096K
[    0.082277] CPU 0/0 -> Node 0
[    0.082278] CPU: Physical Processor ID: 0
[    0.082279] CPU: Processor Core ID: 0
[    0.082286] CPU0: Thermal monitoring enabled (TM2)
[    0.082288] using mwait in idle threads.
[    0.083121] ACPI: Core revision 20070126
[    0.134667] Using local APIC timer interrupts.
[    0.136009] APIC timer calibration result 12468744
[    0.136011] Detected 12.468 MHz APIC timer.
[    0.136165] Booting processor 1/2 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4388.98 Bog=
oMIPS (lpj=3D8777965)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
[    0.224619] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.228045] Brought up 2 CPUs
[    0.228133] CPU0 attaching sched-domain:
[    0.228135]  domain 0: span 00000003
[    0.228137]   groups: 00000001 00000002
[    0.228140]   domain 1: span 00000003
[    0.228141]    groups: 00000003
[    0.228143] CPU1 attaching sched-domain:
[    0.228145]  domain 0: span 00000003
[    0.228146]   groups: 00000002 00000001
[    0.228148]   domain 1: span 00000003
[    0.228150]    groups: 00000003
[    0.228407] net_namespace: 1016 bytes
[    0.228411] Booting paravirtualized kernel on bare hardware
[    0.228588] NET: Registered protocol family 16
[    0.228765] ACPI: bus type pci registered
[    0.232540] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.232542] PCI: Using configuration type 1
[    0.240278] ACPI: EC: Look up EC in DSDT
[    0.262055] ACPI: SSDT 7F690C80, 0043 (r1  LMPWR  DELLLOM     1001 INTL =
20050624)
[    0.262228] ACPI: Interpreter enabled
[    0.262231] ACPI: (supports S0 S3 S4 S5)
[    0.262244] ACPI: Using IOAPIC for interrupt routing
[    0.321140] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.322090] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 AC=
PI/GPIO/TCO
[    0.322094] pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GP=
IO
[    0.323117] PCI: Transparent bridge - 0000:00:1e.0
[    0.323179] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.323792] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.323999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.324153] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.324298] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.342911] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    0.343040] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[    0.343151] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *0, disabled.
[    0.343277] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
[    0.343404] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 =
14 15)
[    0.343531] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 =
14 15)
[    0.343658] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 =
14 15)
[    0.343771] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.343921] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.343947] pnp: PnP ACPI init
[    0.343953] ACPI: bus type pnp registered
[    0.363269] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.363347] pnp 00:01: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.363422] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.363495] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.363574] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.363616]  00:05: calling quirk 0xffffffff8035b7de: quirk_system_pci_r=
esources+0x0/0x173()
[    0.363660] pnp 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.363735] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.363811] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.363928]  00:08: calling quirk 0xffffffff8035b7de: quirk_system_pci_r=
esources+0x0/0x173()
[    0.363971] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (a=
ctive)
[    0.372994] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.381375]  00:0a: calling quirk 0xffffffff8035b7de: quirk_system_pci_r=
esources+0x0/0x173()
[    0.381418] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.385228]  00:0b: calling quirk 0xffffffff8035b7de: quirk_system_pci_r=
esources+0x0/0x173()
[    0.385277] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.385320]  00:0c: calling quirk 0xffffffff8035b7de: quirk_system_pci_r=
esources+0x0/0x173()
[    0.385367] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.408235]  00:0d: calling quirk 0xffffffff8035b7de: quirk_system_pci_r=
esources+0x0/0x173()
[    0.408291] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.408411] pnp: PnP ACPI: found 14 devices
[    0.408413] ACPI: ACPI bus type pnp unregistered
[    0.408565] usbcore: registered new interface driver usbfs
[    0.408614] usbcore: registered new interface driver hub
[    0.408648] usbcore: registered new device driver usb
[    0.408775] PCI: Using ACPI for IRQ routing
[    0.408777] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[    0.424048] NET: Registered protocol family 8
[    0.424049] NET: Registered protocol family 20
[    0.424082] PCI-GART: No AMD northbridge found.
[    0.424089] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.424093] hpet0: 3 64-bit timers, 14318180 Hz
[    0.425127] ACPI: RTC can wake from S4
[    0.440044] pnp: the driver 'system' has been registered
[    0.440053] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.440056] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.440057] system 00:05: driver attached
[    0.440063] system 00:08: iomem range 0xfed00000-0xfed003ff has been res=
erved
[    0.440065] system 00:08: driver attached
[    0.440070] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.440073] system 00:0a: iomem range 0xfed40000-0xfed44fff could not be=
 reserved
[    0.440074] system 00:0a: driver attached
[    0.440079] system 00:0b: ioport range 0x900-0x97f has been reserved
[    0.440081] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.440084] system 00:0b: ioport range 0x1000-0x1005 has been reserved
[    0.440086] system 00:0b: ioport range 0x1008-0x100f has been reserved
[    0.440087] system 00:0b: driver attached
[    0.440092] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.440094] system 00:0c: ioport range 0x1006-0x1007 has been reserved
[    0.440097] system 00:0c: ioport range 0x100a-0x1059 could not be reserv=
ed
[    0.440099] system 00:0c: ioport range 0x1060-0x107f has been reserved
[    0.440101] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.440103] system 00:0c: ioport range 0x10c0-0x10df has been reserved
[    0.440105] system 00:0c: ioport range 0x1010-0x102f has been reserved
[    0.440107] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.440109] system 00:0c: driver attached
[    0.440114] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.440116] system 00:0d: iomem range 0x9f000-0x9ffff could not be reser=
ved
[    0.440118] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.440122] system 00:0d: iomem range 0xe0000-0xfffff has been reserved
[    0.440124] system 00:0d: iomem range 0x100000-0x7f6803ff could not be r=
eserved
[    0.440127] system 00:0d: iomem range 0x7f680400-0x7f6fffff could not be=
 reserved
[    0.440129] system 00:0d: iomem range 0x7f700000-0x7f7fffff could not be=
 reserved
[    0.440131] system 00:0d: iomem range 0x7f700000-0x7fefffff could not be=
 reserved
[    0.440134] system 00:0d: iomem range 0xffe00000-0xffffffff could not be=
 reserved
[    0.440136] system 00:0d: iomem range 0xffa00000-0xffbfffff has been res=
erved
[    0.440139] system 00:0d: iomem range 0xfec00000-0xfec0ffff could not be=
 reserved
[    0.440141] system 00:0d: iomem range 0xfee00000-0xfee0ffff could not be=
 reserved
[    0.440143] system 00:0d: iomem range 0xfed20000-0xfed3ffff could not be=
 reserved
[    0.440146] system 00:0d: iomem range 0xfed45000-0xfed8ffff could not be=
 reserved
[    0.440148] system 00:0d: iomem range 0xfeda0000-0xfeda3fff could not be=
 reserved
[    0.440150] system 00:0d: iomem range 0xfeda4000-0xfeda4fff could not be=
 reserved
[    0.440153] system 00:0d: iomem range 0xfeda5000-0xfeda5fff could not be=
 reserved
[    0.440155] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been res=
erved
[    0.440157] system 00:0d: iomem range 0xfed18000-0xfed1bfff could not be=
 reserved
[    0.440160] system 00:0d: iomem range 0xf8000000-0xfbffffff could not be=
 reserved
[    0.440161] system 00:0d: driver attached
[    0.440517] PCI: Bridge: 0000:00:1c.0
[    0.440518]   IO window: disabled.
[    0.440524]   MEM window: disabled.
[    0.440528]   PREFETCH window: disabled.
[    0.440535] PCI: Bridge: 0000:00:1c.1
[    0.440536]   IO window: disabled.
[    0.440541]   MEM window: 0xfe800000-0xfe8fffff
[    0.440545]   PREFETCH window: disabled.
[    0.440552] PCI: Bridge: 0000:00:1c.5
[    0.440553]   IO window: disabled.
[    0.440559]   MEM window: 0xfe700000-0xfe7fffff
[    0.440563]   PREFETCH window: disabled.
[    0.440575] PCI: Bus 4, cardbus bridge: 0000:03:01.0
[    0.440577]   IO window: 0x00002000-0x000020ff
[    0.440581]   IO window: 0x00002400-0x000024ff
[    0.440586]   PREFETCH window: 0x88000000-0x8bffffff
[    0.440591]   MEM window: 0x8c000000-0x8fffffff
[    0.440596] PCI: Bridge: 0000:00:1e.0
[    0.440599]   IO window: 2000-2fff
[    0.440604]   MEM window: 0xfe600000-0xfe6fffff
[    0.440608]   PREFETCH window: 0x0000000088000000-0x000000008bffffff
[    0.440639] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[    0.440645] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.440668] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -=
> IRQ 17
[    0.440673] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.440695] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -=
> IRQ 17
[    0.440700] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[    0.440713] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.440729] PCI: Enabling device 0000:03:01.0 (0000 -> 0003)
[    0.440733] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -=
> IRQ 19
[    0.440761] NET: Registered protocol family 2
[    0.476137] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.476791] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.478355] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.478885] TCP: Hash tables configured (established 262144 bind 65536)
[    0.478888] TCP reno registered
[    0.488226] checking if image is initramfs...<7>Switched to high resolut=
ion mode on CPU 1
[    0.504044] Switched to high resolution mode on CPU 0
[    0.758664]  it is
[    1.046924] Freeing initrd memory: 7523k freed
[    0.826122] audit: initializing netlink socket (disabled)
[    0.826141] type=3D2000 audit(1206978198.048:1): initialized
[    0.826364] Total HugeTLB memory allocated, 0
[    0.826457] VFS: Disk quotas dquot_6.5.1
[    0.826481] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.826563] io scheduler noop registered
[    0.826564] io scheduler anticipatory registered
[    0.826566] io scheduler deadline registered
[    0.826577] io scheduler cfq registered (default)
[    0.826587] pci 0000:00:02.0: Boot video device
[    0.826811] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.826857] assign_interrupt_mode Found MSI capability
[    0.826906] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.826940] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.826971] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.827070] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.827116] assign_interrupt_mode Found MSI capability
[    0.827160] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.827194] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.827224] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.827323] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[    0.827368] assign_interrupt_mode Found MSI capability
[    0.827412] Allocate Port Service[0000:00:1c.5:pcie00]
[    0.827448] Allocate Port Service[0000:00:1c.5:pcie02]
[    0.827479] Allocate Port Service[0000:00:1c.5:pcie03]
[    0.828010] vesafb: framebuffer at 0xe0000000, mapped to 0xffffc20004980=
000, using 6144k, total 7616k
[    0.828012] vesafb: mode is 1024x768x32, linelength=3D4096, pages=3D1
[    0.828014] vesafb: scrolling: redraw
[    0.828016] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    0.854933] Console: switching to colour frame buffer device 128x48
[    0.879970] fb0: VESA VGA frame buffer device
[    0.881953] Real Time Clock Driver v1.12ac
[    0.882048] hpet_resources: 0xfed00000 is busy
[    0.882119] Linux agpgart interface v0.103
[    0.882122] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[    0.882271] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.882457] pnp: the driver 'serial' has been registered
[    0.882680] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.882714] serial 00:09: driver attached
[    0.882806] isa bounce pool size: 16 pages
[    0.883436] brd: module loaded
[    0.883492] input: Macintosh mouse button emulation as /class/input/inpu=
t0
[    0.883573] pnp: the driver 'i8042 kbd' has been registered
[    0.883582] i8042 kbd 00:02: driver attached
[    0.883609] pnp: the driver 'i8042 aux' has been registered
[    0.883618] i8042 aux 00:01: driver attached
[    0.883648] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
 irq 1,12
[    0.886866] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.886871] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.916129] mice: PS/2 mouse device common for all mice
[    0.916166] cpuidle: using governor ladder
[    0.916168] cpuidle: using governor menu
[    0.916475] TCP bic registered
[    0.916483] NET: Registered protocol family 1
[    0.916492] NET: Registered protocol family 17
[    0.916597] registered taskstats version 1
[    0.916703] Freeing unused kernel memory: 372k freed
[    0.920167] input: AT Translated Set 2 keyboard as /class/input/input1
[    1.285700] ACPI: SSDT 7F6810F6, 0286 (r1  PmRef  Cpu0Ist     3000 INTL =
20050624)
[    1.286034] ACPI: SSDT 7F680BBB, 04B6 (r1  PmRef  Cpu0Cst     3001 INTL =
20050624)
[    1.286571] Monitor-Mwait will be used to enter C-1 state
[    1.286574] Monitor-Mwait will be used to enter C-2 state
[    1.286576] Monitor-Mwait will be used to enter C-3 state
[    1.286701] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.286739] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.286742] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.287052] ACPI: SSDT 7F68137C, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL =
20050624)
[    1.287278] ACPI: SSDT 7F681071, 0085 (r1  PmRef  Cpu1Cst     3000 INTL =
20050624)
[    1.288091] Marking TSC unstable due to TSC halts in idle
[    1.063100] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.063138] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.063141] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.066103] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.067974] ACPI: Thermal Zone [THM] (55 C)
[    1.534970] ACPI: ACPI Dock Station Driver=20
[    1.554558] USB Universal Host Controller Interface driver v3.0
[    1.554598] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -=
> IRQ 20
[    1.554609] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    1.554612] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.554760] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    1.554793] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    1.554898] usb usb1: configuration #1 chosen from 1 choice
[    1.554917] hub 1-0:1.0: USB hub found
[    1.554922] hub 1-0:1.0: 2 ports detected
[    1.624663] SCSI subsystem initialized
[    1.635956] libata version 3.00 loaded.
[    1.656474] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.656477] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.656479] usb usb1: Product: UHCI Host Controller
[    1.656480] usb usb1: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    1.656482] usb usb1: SerialNumber: 0000:00:1a.0
[    1.656520] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -=
> IRQ 21
[    1.656530] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    1.656534] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.656579] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 2
[    1.656612] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    1.656705] usb usb2: configuration #1 chosen from 1 choice
[    1.656724] hub 2-0:1.0: USB hub found
[    1.656731] hub 2-0:1.0: 2 ports detected
[    1.760455] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.760460] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.760464] usb usb2: Product: UHCI Host Controller
[    1.760466] usb usb2: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    1.760469] usb usb2: SerialNumber: 0000:00:1a.1
[    1.760516] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -=
> IRQ 20
[    1.760528] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    1.760533] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.760591] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 3
[    1.760619] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    1.760704] usb usb3: configuration #1 chosen from 1 choice
[    1.760723] hub 3-0:1.0: USB hub found
[    1.760728] hub 3-0:1.0: 2 ports detected
[    1.864045] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.864050] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.864053] usb usb3: Product: UHCI Host Controller
[    1.864056] usb usb3: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    1.864059] usb usb3: SerialNumber: 0000:00:1d.0
[    1.864091] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -=
> IRQ 21
[    1.864101] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    1.864106] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.864168] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 4
[    1.864202] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    1.864283] usb usb4: configuration #1 chosen from 1 choice
[    1.864304] hub 4-0:1.0: USB hub found
[    1.864308] hub 4-0:1.0: 2 ports detected
[    1.895933] usb 1-2: new full speed USB device using uhci_hcd and addres=
s 2
[    1.967695] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.967699] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.967702] usb usb4: Product: UHCI Host Controller
[    1.967705] usb usb4: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    1.967708] usb usb4: SerialNumber: 0000:00:1d.1
[    1.967743] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -=
> IRQ 22
[    1.967754] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    1.967758] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.967824] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 5
[    1.967853] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    1.967937] usb usb5: configuration #1 chosen from 1 choice
[    1.967955] hub 5-0:1.0: USB hub found
[    1.967960] hub 5-0:1.0: 2 ports detected
[    1.995578] Clocksource tsc unstable (delta =3D -297745226 ns)
[    2.071101] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.071105] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.071108] usb usb5: Product: UHCI Host Controller
[    2.071111] usb usb5: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    2.071114] usb usb5: SerialNumber: 0000:00:1d.2
[    1.845553] tg3.c:v3.88 (March 20, 2008)
[    1.845582] ACPI: PCI Interrupt 0000:09:00.0[A] -> GSI 17 (level, low) -=
> IRQ 17
[    1.845592] PCI: Setting latency timer of device 0000:09:00.0 to 64
[    2.076029] usb 1-2: configuration #1 chosen from 1 choice
[    2.079623] usb 1-2: New USB device found, idVendor=3D413c, idProduct=3D=
8140
[    2.079626] usb 1-2: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    1.866102] eth0: Tigon3 [partno(BCM95755m) rev a002 PHY(5755)] (PCI Exp=
ress) 10/100/1000Base-T Ethernet 00:18:8b:d6:63:72
[    1.866105] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] =
TSOcap[1]
[    1.866107] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.866943] ACPI: PCI Interrupt 0000:03:01.4[A] -> GSI 19 (level, low) -=
> IRQ 19
[    1.867015] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -=
> IRQ 22
[    1.867024] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    1.867027] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.867077] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 6
[    1.870975] ehci_hcd 0000:00:1a.7: debug port 1
[    1.870982] PCI: cache line size of 32 is not supported by device 0000:0=
0:1a.7
[    1.870987] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.107141] Uniform Multi-Platform E-IDE driver
[    2.107144] ide: Assuming 33MHz system bus speed for PIO modes; override=
 with idebus=3Dxx
[    1.890334] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    1.890439] usb usb6: configuration #1 chosen from 1 choice
[    1.890460] hub 6-0:1.0: USB hub found
[    1.890466] hub 6-0:1.0: 4 ports detected
[    1.937266] firewire_ohci: Added fw-ohci device 0000:03:01.4, OHCI versi=
on 1.10
[    1.992418] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.992423] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.992427] usb usb6: Product: EHCI Host Controller
[    1.992429] usb usb6: Manufacturer: Linux 2.6.25-rc7-amd64 ehci_hcd
[    1.992432] usb usb6: SerialNumber: 0000:00:1a.7
[    1.992494] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -=
> IRQ 20
[    1.992509] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    1.992512] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.992559] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 7
[    1.999690] ehci_hcd 0000:00:1d.7: debug port 1
[    1.999696] PCI: cache line size of 32 is not supported by device 0000:0=
0:1d.7
[    1.999702] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.318693] usb 5-1: new full speed USB device using uhci_hcd and addres=
s 2
[    2.107797] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    2.107941] usb usb7: configuration #1 chosen from 1 choice
[    2.107979] hub 7-0:1.0: USB hub found
[    2.107987] hub 7-0:1.0: 6 ports detected
[    2.210448] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.210453] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.210456] usb usb7: Product: EHCI Host Controller
[    2.210459] usb usb7: Manufacturer: Linux 2.6.25-rc7-amd64 ehci_hcd
[    2.210462] usb usb7: SerialNumber: 0000:00:1d.7
[    2.434060] ahci 0000:00:1f.2: version 3.0
[    2.434060] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -=
> IRQ 17
[    2.293455] usb 1-2: USB disconnect, address 2
[    2.655810] firewire_core: created device fw0: GUID 384fc0003b237850, S4=
00
[    3.428972] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x=
5 impl SATA mode
[    3.428977] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum=
 part=20
[    3.428985] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    3.429259] scsi0 : ahci
[    3.429348] scsi1 : ahci
[    3.429506] scsi2 : ahci
[    3.429757] ata1: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fb90=
0 irq 1276
[    3.429759] ata2: DUMMY
[    3.429761] ata3: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fba0=
0 irq 1276
[    3.379275] usb 1-2: new full speed USB device using uhci_hcd and addres=
s 3
[    3.776981] usb 1-2: configuration #1 chosen from 1 choice
[    3.780532] usb 1-2: New USB device found, idVendor=3D413c, idProduct=3D=
8140
[    3.780534] usb 1-2: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    3.692953] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.693897] ata1.00: ATA-7: Hitachi HTS541612J9SA00, SBDOC74P, max UDMA/=
100
[    3.693901] ata1.00: 234441648 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    3.903744] ata1.00: configured for UDMA/100
[    4.017233] usb 5-1: new full speed USB device using uhci_hcd and addres=
s 3
[    4.165472] usb 5-1: configuration #1 chosen from 1 choice
[    4.167866] hub 5-1:1.0: USB hub found
[    4.169814] hub 5-1:1.0: 4 ports detected
[    4.006623] ata3: SATA link down (SStatus 0 SControl 300)
[    4.212439] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54161 SB=
DO PQ: 0 ANSI: 5
[    4.212440] ICH8M: IDE controller (0x8086:0x2850 rev 0x02) at  PCI slot =
0000:00:1f.1
[    4.212440] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -=
> IRQ 16
[    4.212440] ICH8M: not 100% native mode: will probe irqs later
[    4.212440] ICH8M: IDE port disabled
[    4.212440]     ide0: BM-DMA at 0x6fa0-0x6fa7, BIOS settings: hda:DMA, h=
db:PIO
[    4.212440] Probing IDE interface ide0...
[    4.221329] Driver 'sd' needs updating - please use bus_type methods
[    4.225666] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (12003=
4 MB)
[    4.225689] sd 0:0:0:0: [sda] Write Protect is off
[    4.225693] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.225727] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.225807] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (12003=
4 MB)
[    4.225819] sd 0:0:0:0: [sda] Write Protect is off
[    4.225821] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.225841] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.225844]  sda:<6>usb 5-1: New USB device found, idVendor=3D0b97, idPr=
oduct=3D7761
[    4.276613] usb 5-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    4.515768] usb 5-2: new full speed USB device using uhci_hcd and addres=
s 4
[    4.640443]  sda1 sda2 < sda5 >
[    4.440493] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.481112] usb 5-2: configuration #1 chosen from 1 choice
[    4.484051] usb 5-2: New USB device found, idVendor=3D0483, idProduct=3D=
2016
[    4.484053] usb 5-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    4.484055] usb 5-2: Product: Biometric Coprocessor
[    4.484057] usb 5-2: Manufacturer: STMicroelectronics
[    4.690077] usb 5-1.2: new full speed USB device using uhci_hcd and addr=
ess 5
[    4.805479] usb 5-1.2: configuration #1 chosen from 1 choice
[    4.806852] usb 5-1.2: New USB device found, idVendor=3D0b97, idProduct=
=3D7772
[    4.806852] usb 5-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    4.806852] usb 5-1.2: Product: O2Micro CCID SC Reader
[    4.806852] usb 5-1.2: Manufacturer: O2
[    5.277571] hda: HL-DT-ST DVD+/-RW GSA-T11N, ATAPI CD/DVD-ROM drive
[    5.277599] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.278679] hda: UDMA/33 mode selected
[    5.279227] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.294953] hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[    5.294962] Uniform CD-ROM driver Revision: 3.20
[    5.282807] device-mapper: uevent: version 1.0.3
[    5.283144] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:=
 dm-devel@redhat.com
[   19.479478] PM: Starting manual resume from disk
[   19.342472] kjournald starting.  Commit interval 5 seconds
[   19.342489] EXT3-fs: mounted filesystem with ordered data mode.
[   22.361219] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   22.302608] agpgart: Detected an Intel 965GM Chipset.
[   22.303537] agpgart: Detected 7676K stolen memory.
[   22.315734] agpgart: AGP aperture is 256M @ 0xe0000000
[   22.504624] ACPI: WMI: Mapper loaded
[   22.530613] ACPI: AC Adapter [AC] (on-line)
[   22.778371] input: Lid Switch as /class/input/input2
[   22.812273] ACPI: Lid Switch [LID]
[   22.812328] input: Power Button (CM) as /class/input/input3
[   22.646073] ACPI: \_SB_.PCI0.IDE0.SEC0.MAST: found ejectable bay
[   22.646077] ACPI: \_SB_.PCI0.IDE0.SEC0.MAST: Adding notify handler
[   22.646108] ACPI: Bay [\_SB_.PCI0.IDE0.SEC0.MAST] Added
[   22.646120] ACPI: \_SB_.PCI0.IDE1.PRI_.MAST: found ejectable bay
[   22.646124] ACPI: \_SB_.PCI0.IDE1.PRI_.MAST: Adding notify handler
[   22.646142] ACPI: Bay [\_SB_.PCI0.IDE1.PRI_.MAST] Added
[   22.875604] ACPI: Power Button (CM) [PBTN]
[   22.875659] input: Sleep Button (CM) as /class/input/input4
[   22.937320] ACPI: Sleep Button (CM) [SBTN]
[   22.775800] ACPI: Battery Slot [BAT0] (battery present)
[   22.775847] ACPI: Battery Slot [BAT1] (battery absent)
[   22.795661] input: Video Bus as /class/input/input5
[   22.851422] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   22.852013] input: Video Bus as /class/input/input6
[   22.914306] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: n=
o)
[   22.914452] input: Video Bus as /class/input/input7
[   22.972002] Bluetooth: Core ver 2.11
[   22.978303] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: n=
o)
[   22.987341] NET: Registered protocol family 31
[   22.987343] Bluetooth: HCI device and connection manager initialized
[   22.987347] Bluetooth: HCI socket layer initialized
[   23.017969] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   23.018040] iTCO_wdt: Found a ICH8M TCO device (Version=3D2, TCOBASE=3D0=
x1060)
[   23.018077] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   23.202386] Bluetooth: HCI USB driver ver 2.9
[   23.208339] usbcore: registered new interface driver hci_usb
[   23.311310] Yenta: CardBus bridge found at 0000:03:01.0 [1028:01f9]
[   23.311333] Yenta O2: res at 0x94/0xD4: 00/ea
[   23.311335] Yenta O2: enabling read prefetch/write burst
[   23.439955] Yenta: ISA IRQ mask 0x04b8, PCI irq 19
[   23.439959] Socket status: 30000006
[   23.439961] Yenta: Raising subordinate bus# of parent bus (#03) from #04=
 to #07
[   23.439966] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[   23.439968] pcmcia: parent PCI bridge Memory window: 0xfe600000 - 0xfe6f=
ffff
[   23.439970] pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bff=
ffff
[   23.632922] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -=
> IRQ 17
[   23.613341] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection=
 driver for Linux, 1.2.23ks
[   23.613344] iwl3945: Copyright(c) 2003-2007 Intel Corporation
[   23.613467] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -=
> IRQ 17
[   23.613481] PCI: Setting latency timer of device 0000:0c:00.0 to 64
[   23.613500] iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connect=
ion
[   23.676200] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
[   23.676667] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   23.816874] ACPI: PCI interrupt for device 0000:0c:00.0 disabled
[   24.261624] input: PS/2 Mouse as /class/input/input8
[   24.297096] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -=
> IRQ 21
[   24.297116] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   24.109311] input: AlpsPS/2 ALPS GlidePoint as /class/input/input9
[   25.413291] EXT3 FS on dm-6, internal journal
[   25.763186] loop: module loaded
[   28.738265] kjournald starting.  Commit interval 5 seconds
[   28.748592] EXT3 FS on sda1, internal journal
[   28.748592] EXT3-fs: mounted filesystem with ordered data mode.
[   28.827097] kjournald starting.  Commit interval 5 seconds
[   28.829843] EXT3 FS on dm-4, internal journal
[   28.829846] EXT3-fs: mounted filesystem with ordered data mode.
[   28.874167] kjournald starting.  Commit interval 5 seconds
[   28.877006] EXT3 FS on dm-5, internal journal
[   28.877010] EXT3-fs: mounted filesystem with ordered data mode.
[   28.921456] kjournald starting.  Commit interval 5 seconds
[   28.924202] EXT3 FS on dm-3, internal journal
[   28.924204] EXT3-fs: mounted filesystem with ordered data mode.
[   28.954809] kjournald starting.  Commit interval 5 seconds
[   28.958698] EXT3 FS on dm-2, internal journal
[   28.958704] EXT3-fs: mounted filesystem with ordered data mode.
[   28.981242] Adding 6152184k swap on /dev/mapper/Tamino-swap_1.  Priority=
:-1 extents:1 across:6152184k
[   30.514873] fuse init (API version 7.9)
[   32.435232] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -=
> IRQ 17
[   32.435378] PM: Writing back config space on device 0000:0c:00.0 at offs=
et 1 (was 100102, writing 100106)
[   33.972769] NET: Registered protocol family 10
[   33.973216] lo: Disabled Privacy Extensions
[   33.973588] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   33.974038] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   36.410939] wlan0: Initial auth_alg=3D0
[   36.410945] wlan0: authenticate with AP 00:18:84:21:ef:2b
[   36.412647] wlan0: RX authentication from 00:18:84:21:ef:2b (alg=3D0 tra=
nsaction=3D2 status=3D0)
[   36.412650] wlan0: authenticated
[   36.412654] wlan0: associate with AP 00:18:84:21:ef:2b
[   36.283355] wlan0: RX AssocResp from 00:18:84:21:ef:2b (capab=3D0x431 st=
atus=3D0 aid=3D1)
[   36.283359] wlan0: associated
[   36.283407] wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWma=
x=3D1023 burst=3D20
[   36.283411] wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWm=
ax=3D1023 burst=3D0
[   36.283415] wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWma=
x=3D15 burst=3D30
[   36.283419] wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWma=
x=3D7 burst=3D15
[   36.283791] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   36.378878] wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWma=
x=3D1023 burst=3D20
[   36.512003] wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWm=
ax=3D1023 burst=3D0
[   36.379028] wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWma=
x=3D15 burst=3D30
[   36.512193] wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWma=
x=3D7 burst=3D15
[   38.070490] Bluetooth: L2CAP ver 2.9
[   38.070494] Bluetooth: L2CAP socket layer initialized
[   37.981386] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   38.329811] Bluetooth: RFCOMM socket layer initialized
[   38.329820] Bluetooth: RFCOMM TTY layer initialized
[   38.329822] Bluetooth: RFCOMM ver 1.8
[   43.102835] warning: `avahi-daemon' uses 32-bit capabilities (legacy sup=
port in use)
[   46.278610] pnp: the driver 'parport_pc' has been registered
[   46.278946] lp: driver loaded but no devices found
[   46.392346] ppdev: user-space parallel port driver
[   46.698214] wlan0: no IPv6 routers present
[   50.457312] [drm] Initialized drm 1.1.0 20060810
[   50.494946] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   50.494953] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   50.495044] [drm] Initialized i915 1.6.0 20060119 on minor 0
[  104.258195] CPU0 attaching NULL sched-domain.
[  104.258208] CPU1 attaching NULL sched-domain.
[  104.273951] CPU0 attaching sched-domain:
[  104.273964]  domain 0: span 00000003
[  104.273969]   groups: 00000001 00000002
[  104.273977]   domain 1: span 00000003
[  104.273981]    groups: 00000003
[  104.273987] CPU1 attaching sched-domain:
[  104.273991]  domain 0: span 00000003
[  104.273995]   groups: 00000002 00000001
[  104.274002]   domain 1: span 00000003
[  104.274005]    groups: 00000003
[  121.494863] Syncing filesystems ... done.
[  121.494915] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[  121.495516] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[  121.495614] PM: Shrinking memory...  =08-=08done (0 pages freed)
[  121.514672] PM: Freed 0 kbytes in 0.04 seconds (0.00 MB/s)
[  121.516965] ACPI: Preparing to enter system sleep state S4
[  121.518827] Suspending console(s)
[  121.518831] drm_sysfs_suspend
[  121.521511] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  122.128192] serial 00:09: disabled
[  122.128250] ACPI handle has no context!
[  122.201724] ACPI: PCI interrupt for device 0000:0c:00.0 disabled
[  122.246086] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  122.246121] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  122.246155] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  122.246189] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[  122.262067] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[  122.277875] ACPI: PCI interrupt for device 0000:00:1a.7 disabled
[  122.277918] ACPI: PCI interrupt for device 0000:00:1a.1 disabled
[  122.277961] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[  122.278058] Disabling non-boot CPUs ...
[  122.278072] CPU0 attaching NULL sched-domain.
[  122.278074] CPU1 attaching NULL sched-domain.
[  122.012363] CPU 1 is now offline
[  122.012366] SMP alternatives: switching to UP code
[  122.013615] CPU0 attaching sched-domain:
[  122.013618]  domain 0: span 00000001
[  122.013619]   groups: 00000001
[  122.013793] CPU1 is down
[  122.013916] Extended CMOS year: 2000
[  122.014012] PM: Creating hibernation image:=20
[  122.016358] PM: Need to copy 160268 pages
[  122.016358] Extended CMOS year: 2000
[  122.016358] Enabling non-boot CPUs ...
[  122.016358] CPU0 attaching NULL sched-domain.
[  122.024471] SMP alternatives: switching to SMP code
[  122.025385] Booting processor 1/2 APIC 0x1
[  122.292156] Initializing CPU#1
[  122.293794] Calibrating delay using timer specific routine.. 4386.86 Bog=
oMIPS (lpj=3D8773722)
[  122.293794] CPU: L1 I cache: 32K, L1 D cache: 32K
[  122.293794] CPU: L2 cache: 4096K
[  122.293794] CPU 1/1 -> Node 0
[  122.293794] CPU: Physical Processor ID: 0
[  122.293794] CPU: Processor Core ID: 1
[  122.293794] Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
[  122.116979] CPU0 attaching sched-domain:
[  122.116981]  domain 0: span 00000003
[  122.116983]   groups: 00000001 00000002
[  122.116985]   domain 1: span 00000003
[  122.116987]    groups: 00000003
[  122.116989] CPU1 attaching sched-domain:
[  122.116990]  domain 0: span 00000003
[  122.116991]   groups: 00000002 00000001
[  122.116993]   domain 1: span 00000003
[  122.116995]    groups: 00000003
[  122.293794] CPU1 is up
[  122.293800] Switched to high resolution mode on CPU 1
[  122.166900] ACPI: \_SB_.PCI0.IDE1.PRI_.MAST: Bay event
[  122.355095] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[  122.355100] PCI: Setting latency timer of device 0000:00:02.0 to 64
[  122.355120] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -=
> IRQ 20
[  122.355125] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[  122.355177] usb usb1: root hub lost power or was reset
[  122.355199] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -=
> IRQ 21
[  122.355204] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[  122.355272] usb usb2: root hub lost power or was reset
[  122.355294] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -=
> IRQ 22
[  122.355299] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[  122.355351] usb usb6: root hub lost power or was reset
[  122.359236] ehci_hcd 0000:00:1a.7: debug port 1
[  122.359242] PCI: cache line size of 32 is not supported by device 0000:0=
0:1a.7
[  122.372946] PM: Writing back config space on device 0000:00:1b.0 at offs=
et 1 (was 100106, writing 100102)
[  122.372976] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -=
> IRQ 21
[  122.372985] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[  122.497784] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[  122.497860] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[  122.497940] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[  122.497948] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -=
> IRQ 20
[  122.497953] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[  122.498004] usb usb3: root hub lost power or was reset
[  122.498022] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -=
> IRQ 21
[  122.498027] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[  122.498078] usb usb4: root hub lost power or was reset
[  122.498096] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -=
> IRQ 22
[  122.498101] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[  122.498152] usb usb5: root hub lost power or was reset
[  122.498174] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -=
> IRQ 20
[  122.498183] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[  122.498250] usb usb7: root hub lost power or was reset
[  122.502131] ehci_hcd 0000:00:1d.7: debug port 1
[  122.502137] PCI: cache line size of 32 is not supported by device 0000:0=
0:1d.7
[  122.502162] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 6 (was 20040300, writing 20070300)
[  122.502190] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[  122.502270] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -=
> IRQ 16
[  122.502315] PM: Writing back config space on device 0000:00:1f.2 at offs=
et 1 (was 2b00403, writing 2b00407)
[  122.502360] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[  122.516838] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -=
> IRQ 17
[  122.529126] PM: Writing back config space on device 0000:09:00.0 at offs=
et c (was 0, writing dfad0000)
[  122.529154] PM: Writing back config space on device 0000:09:00.0 at offs=
et 1 (was 100106, writing 100506)
[  122.590977] PM: Writing back config space on device 0000:03:01.0 at offs=
et f (was 14001ff, writing 5c001ff)
[  122.591004] PM: Writing back config space on device 0000:03:01.0 at offs=
et 3 (was 824000, writing 82a800)
[  122.591011] PM: Writing back config space on device 0000:03:01.0 at offs=
et 1 (was 4100007, writing 4100087)
[  122.591036] Yenta O2: res at 0x94/0xD4: 00/ea
[  122.591037] Yenta O2: enabling read prefetch/write burst
[  122.745779] PM: Writing back config space on device 0000:03:01.4 at offs=
et f (was 100, writing 103)
[  122.745803] PM: Writing back config space on device 0000:03:01.4 at offs=
et 5 (was 0, writing fe6fe800)
[  122.745810] PM: Writing back config space on device 0000:03:01.4 at offs=
et 4 (was 0, writing fe6ff000)
[  122.745817] PM: Writing back config space on device 0000:03:01.4 at offs=
et 3 (was 0, writing 4010)
[  122.745825] PM: Writing back config space on device 0000:03:01.4 at offs=
et 1 (was 2100080, writing 2180117)
[  122.619021] ata3: SATA link down (SStatus 0 SControl 300)
[  122.830640] pnp: Res cnt 2
[  122.838113] pnp: res cnt 2
[  122.838114] pnp: Encode irq
[  122.838115] pnp: Encode io
[  122.845289] serial 00:09: activated
[  122.782508] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  122.784550] ata1.00: configured for UDMA/100
[  122.798554] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (12003=
4 MB)
[  122.798576] sd 0:0:0:0: [sda] Write Protect is off
[  122.798579] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  122.798612] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  124.442501] sd 0:0:0:0: [sda] Starting disk
[  124.467524] do_drive_get_GTF: Run _GTF error: status =3D 0x5
[  124.467524] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[  124.468158] hda: UDMA/33 mode selected
[  124.510014] Restarting tasks ... <6>usb 1-2: USB disconnect, address 3
[  124.524315] done.
[  124.651641] usb 5-1: USB disconnect, address 3
[  124.651646] usb 5-1.2: USB disconnect, address 5
[  124.779585] usb 5-2: USB disconnect, address 4
[  125.862319] usb 1-2: new full speed USB device using uhci_hcd and addres=
s 4
[  126.050633] usb 1-2: configuration #1 chosen from 1 choice
[  126.311979] usb 1-2: New USB device found, idVendor=3D413c, idProduct=3D=
8140
[  126.311984] usb 1-2: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[  126.549536] usb 5-1: new full speed USB device using uhci_hcd and addres=
s 6
[  126.455994] usb 5-1: configuration #1 chosen from 1 choice
[  126.458016] hub 5-1:1.0: USB hub found
[  126.459912] hub 5-1:1.0: 4 ports detected
[  126.569858] usb 5-1: New USB device found, idVendor=3D0b97, idProduct=3D=
7761
[  126.569868] usb 5-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[  126.808228] usb 5-2: new full speed USB device using uhci_hcd and addres=
s 7
[  126.982550] usb 5-2: configuration #1 chosen from 1 choice
[  126.982728] usb 5-2: New USB device found, idVendor=3D0483, idProduct=3D=
2016
[  126.982728] usb 5-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[  126.982728] usb 5-2: Product: Biometric Coprocessor
[  126.982728] usb 5-2: Manufacturer: STMicroelectronics
[  127.188237] usb 5-1.2: new full speed USB device using uhci_hcd and addr=
ess 8
[  127.301244] usb 5-1.2: configuration #1 chosen from 1 choice
[  127.301449] usb 5-1.2: New USB device found, idVendor=3D0b97, idProduct=
=3D7772
[  127.301449] usb 5-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[  127.301449] usb 5-1.2: Product: O2Micro CCID SC Reader
[  127.301449] usb 5-1.2: Manufacturer: O2
[  131.137161] wlan0: Initial auth_alg=3D0
[  131.137179] wlan0: authenticate with AP 00:0c:41:9d:64:c2
[  131.414772] wlan0: Initial auth_alg=3D0
[  131.414786] wlan0: authenticate with AP 00:0c:41:9d:64:c2
[  131.414821] wlan0: RX authentication from 00:0c:41:9d:64:c2 (alg=3D0 tra=
nsaction=3D2 status=3D0)
[  131.414827] wlan0: authenticated
[  131.414833] wlan0: associate with AP 00:0c:41:9d:64:c2
[  131.416313] wlan0: authentication frame received from 00:0c:41:9d:64:c2,=
 but not in authenticate state - ignored
[  131.418260] wlan0: authentication frame received from 00:0c:41:9d:64:c2,=
 but not in authenticate state - ignored
[  131.145365] wlan0: RX ReassocResp from 00:0c:41:9d:64:c2 (capab=3D0x411 =
status=3D0 aid=3D2)
[  131.145374] wlan0: associated
[  214.688933] Syncing filesystems ... done.
[  214.688933] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[  214.700037] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[  214.700128] PM: Shrinking memory...  =08-=08done (0 pages freed)
[  214.719065] PM: Freed 0 kbytes in 0.04 seconds (0.00 MB/s)
[  214.721413] ACPI: Preparing to enter system sleep state S4
[  214.723227] Suspending console(s)
[  214.724834] drm_sysfs_suspend
[  214.724935] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  214.872565] serial 00:09: disabled
[  214.872622] ACPI handle has no context!
[  214.943325] ACPI: PCI interrupt for device 0000:0c:00.0 disabled
[  214.987782] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  214.987817] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  214.987851] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  214.987885] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[  215.003591] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[  215.019405] ACPI: PCI interrupt for device 0000:00:1a.7 disabled
[  215.019449] ACPI: PCI interrupt for device 0000:00:1a.1 disabled
[  215.019492] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[  215.019603] Disabling non-boot CPUs ...
[  215.019612] CPU0 attaching NULL sched-domain.
[  215.019614] CPU1 attaching NULL sched-domain.
[  215.047340] CPU 1 is now offline
[  215.047342] SMP alternatives: switching to UP code
[  215.048557] CPU0 attaching sched-domain:
[  215.048559]  domain 0: span 00000001
[  215.048561]   groups: 00000001
[  215.048741] CPU1 is down
[  215.048865] Extended CMOS year: 2000
[  215.048961] PM: Creating hibernation image:=20
[  215.051329] PM: Need to copy 160501 pages
[  215.051329] Extended CMOS year: 2000
[  215.051329] Enabling non-boot CPUs ...
[  215.051329] CPU0 attaching NULL sched-domain.
[  215.059443] SMP alternatives: switching to SMP code
[  215.060356] Booting processor 1/2 APIC 0x1
[  216.467233] Initializing CPU#1
[  216.467233] Calibrating delay using timer specific routine.. 4389.04 Bog=
oMIPS (lpj=3D8778096)
[  216.467233] CPU: L1 I cache: 32K, L1 D cache: 32K
[  216.467233] CPU: L2 cache: 4096K
[  216.467233] CPU 1/1 -> Node 0
[  216.467233] CPU: Physical Processor ID: 0
[  216.467233] CPU: Processor Core ID: 1
[  216.467233] Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
[  215.152000] CPU0 attaching sched-domain:
[  215.152003]  domain 0: span 00000003
[  215.152004]   groups: 00000001 00000002
[  215.152007]   domain 1: span 00000003
[  215.152008]    groups: 00000003
[  215.152010] CPU1 attaching sched-domain:
[  215.152011]  domain 0: span 00000003
[  215.152013]   groups: 00000002 00000001
[  215.152015]   domain 1: span 00000003
[  215.152016]    groups: 00000003
[  216.467233] CPU1 is up
[  216.467239] Switched to high resolution mode on CPU 1
[  215.168991] ACPI: \_SB_.PCI0.IDE1.PRI_.MAST: Bay event
[  216.529391] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[  216.529396] PCI: Setting latency timer of device 0000:00:02.0 to 64
[  216.529416] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -=
> IRQ 20
[  216.529420] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[  216.529472] usb usb1: root hub lost power or was reset
[  216.529493] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -=
> IRQ 21
[  216.529498] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[  216.529567] usb usb2: root hub lost power or was reset
[  216.529588] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -=
> IRQ 22
[  216.529593] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[  216.529646] usb usb6: root hub lost power or was reset
[  216.533523] ehci_hcd 0000:00:1a.7: debug port 1
[  216.533529] PCI: cache line size of 32 is not supported by device 0000:0=
0:1a.7
[  216.546428] PM: Writing back config space on device 0000:00:1b.0 at offs=
et 1 (was 100106, writing 100102)
[  216.546457] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -=
> IRQ 21
[  216.546467] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[  216.671014] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[  216.671090] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[  216.671165] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[  216.671173] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -=
> IRQ 20
[  216.671179] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[  216.671230] usb usb3: root hub lost power or was reset
[  216.671248] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -=
> IRQ 21
[  216.671253] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[  216.671305] usb usb4: root hub lost power or was reset
[  216.671322] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -=
> IRQ 22
[  216.671328] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[  216.671379] usb usb5: root hub lost power or was reset
[  216.671410] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -=
> IRQ 20
[  216.671418] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[  216.671472] usb usb7: root hub lost power or was reset
[  216.675344] ehci_hcd 0000:00:1d.7: debug port 1
[  216.675350] PCI: cache line size of 32 is not supported by device 0000:0=
0:1d.7
[  216.675375] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 6 (was 20040300, writing 20070300)
[  216.675404] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[  216.675484] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -=
> IRQ 16
[  216.675529] PM: Writing back config space on device 0000:00:1f.2 at offs=
et 1 (was 2b00403, writing 2b00407)
[  216.675573] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[  216.690100] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -=
> IRQ 17
[  216.702399] PM: Writing back config space on device 0000:09:00.0 at offs=
et c (was 0, writing dbad0000)
[  216.702427] PM: Writing back config space on device 0000:09:00.0 at offs=
et 1 (was 100106, writing 100506)
[  216.764196] PM: Writing back config space on device 0000:03:01.0 at offs=
et f (was 14001ff, writing 5c001ff)
[  216.764223] PM: Writing back config space on device 0000:03:01.0 at offs=
et 3 (was 824000, writing 82a800)
[  216.764230] PM: Writing back config space on device 0000:03:01.0 at offs=
et 1 (was 4100007, writing 4100087)
[  216.764254] Yenta O2: res at 0x94/0xD4: 00/ea
[  216.764255] Yenta O2: enabling read prefetch/write burst
[  216.920027] PM: Writing back config space on device 0000:03:01.4 at offs=
et f (was 100, writing 103)
[  216.920051] PM: Writing back config space on device 0000:03:01.4 at offs=
et 5 (was 0, writing fe6fe800)
[  216.920058] PM: Writing back config space on device 0000:03:01.4 at offs=
et 4 (was 0, writing fe6ff000)
[  216.920065] PM: Writing back config space on device 0000:03:01.4 at offs=
et 3 (was 0, writing 4010)
[  216.920073] PM: Writing back config space on device 0000:03:01.4 at offs=
et 1 (was 2100080, writing 2180117)
[  215.653740] ata3: SATA link down (SStatus 0 SControl 300)
[  217.003977] pnp: Res cnt 2
[  217.011383] pnp: res cnt 2
[  217.011384] pnp: Encode irq
[  217.011385] pnp: Encode io
[  217.018625] serial 00:09: activated
[  215.816401] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  215.818443] ata1.00: configured for UDMA/100
[  215.832446] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (12003=
4 MB)
[  215.832468] sd 0:0:0:0: [sda] Write Protect is off
[  215.832471] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  215.832504] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  217.480507] sd 0:0:0:0: [sda] Starting disk
[  218.212824] do_drive_get_GTF: Run _GTF error: status =3D 0x5
[  218.213712] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[  218.214529] hda: UDMA/33 mode selected
[  218.256455] Restarting tasks ... <6>usb 1-2: USB disconnect, address 4
[  218.269961] done.
[  218.397075] usb 5-1: USB disconnect, address 6
[  218.397079] usb 5-1.2: USB disconnect, address 8
[  218.525014] usb 5-2: USB disconnect, address 7
[  219.615552] usb 5-1: new full speed USB device using uhci_hcd and addres=
s 9
[  219.767000] usb 5-1: configuration #1 chosen from 1 choice
[  219.767173] hub 5-1:1.0: USB hub found
[  219.768617] hub 5-1:1.0: 4 ports detected
[  219.875599] usb 5-1: New USB device found, idVendor=3D0b97, idProduct=3D=
7761
[  219.875610] usb 5-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[  220.114410] usb 5-2: new full speed USB device using uhci_hcd and addres=
s 10
[  220.283517] usb 5-2: configuration #1 chosen from 1 choice
[  220.283784] usb 5-2: New USB device found, idVendor=3D0483, idProduct=3D=
2016
[  220.283784] usb 5-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[  220.283784] usb 5-2: Product: Biometric Coprocessor
[  220.283784] usb 5-2: Manufacturer: STMicroelectronics
[  220.519549] usb 1-2: new full speed USB device using uhci_hcd and addres=
s 5
[  220.702401] usb 1-2: configuration #1 chosen from 1 choice
[  220.706157] usb 1-2: New USB device found, idVendor=3D413c, idProduct=3D=
8140
[  220.706169] usb 1-2: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[  220.911570] usb 5-1.2: new full speed USB device using uhci_hcd and addr=
ess 11
[  221.028870] usb 5-1.2: configuration #1 chosen from 1 choice
[  221.029102] usb 5-1.2: New USB device found, idVendor=3D0b97, idProduct=
=3D7772
[  221.029102] usb 5-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[  221.029102] usb 5-1.2: Product: O2Micro CCID SC Reader
[  221.029102] usb 5-1.2: Manufacturer: O2
[  224.183245] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183245] wlan0: deauthenticated
[  224.183245] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183245] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183245] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183245] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: RX deauthentication from 00:0c:41:9d:64:c2 (reason=3D=
7)
[  224.183246] wlan0: authenticate with AP 00:0c:41:9d:64:c2
[  224.187164] wlan0: RX authentication from 00:0c:41:9d:64:c2 (alg=3D0 tra=
nsaction=3D2 status=3D0)
[  224.187173] wlan0: authenticated
[  224.187179] wlan0: associate with AP 00:0c:41:9d:64:c2
[  224.191265] wlan0: RX ReassocResp from 00:0c:41:9d:64:c2 (capab=3D0x411 =
status=3D0 aid=3D2)
[  224.191273] wlan0: associated
[  225.648612] wlan0: Initial auth_alg=3D0
[  225.648627] wlan0: authenticate with AP 00:18:84:21:ef:2b
[  225.651138] wlan0: Initial auth_alg=3D0
[  225.651152] wlan0: authenticate with AP 00:18:84:21:ef:2b
[  225.651186] wlan0: RX authentication from 00:18:84:21:ef:2b (alg=3D0 tra=
nsaction=3D2 status=3D0)
[  225.651191] wlan0: authenticated
[  225.651197] wlan0: associate with AP 00:18:84:21:ef:2b
[  225.653431] wlan0: authentication frame received from 00:18:84:21:ef:2b,=
 but not in authenticate state - ignored
[  225.657286] wlan0: Initial auth_alg=3D0
[  225.657298] wlan0: authenticate with AP 00:18:84:21:ef:2b
[  225.657328] wlan0: association frame received from 00:18:84:21:ef:2b, bu=
t not in associate state - ignored
[  225.659210] wlan0: RX authentication from 00:18:84:21:ef:2b (alg=3D0 tra=
nsaction=3D2 status=3D0)
[  225.659219] wlan0: authenticated
[  225.659225] wlan0: associate with AP 00:18:84:21:ef:2b
[  225.664308] wlan0: RX ReassocResp from 00:18:84:21:ef:2b (capab=3D0x431 =
status=3D0 aid=3D1)
[  225.664320] wlan0: associated
[  225.664400] wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWma=
x=3D1023 burst=3D20
[  225.664407] wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWm=
ax=3D1023 burst=3D0
[  225.664414] wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWma=
x=3D15 burst=3D30
[  225.664420] wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWma=
x=3D7 burst=3D15
[  225.687616] wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWma=
x=3D1023 burst=3D20
[  225.687616] wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWm=
ax=3D1023 burst=3D0
[  225.687616] wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWma=
x=3D15 burst=3D30
[  225.687616] wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWma=
x=3D7 burst=3D15
[  224.807692] ACPI: PCI interrupt for device 0000:0c:00.0 disabled
[  226.484082] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -=
> IRQ 17
[  226.484260] PM: Writing back config space on device 0000:0c:00.0 at offs=
et 1 (was 100102, writing 100106)
[  226.547091] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  234.300158] wlan0: disassociate(reason=3D3)
[  238.546500] wlan0: Initial auth_alg=3D0
[  238.546514] wlan0: authenticate with AP 00:0f:cc:b4:4e:14
[  236.844757] wlan0: Initial auth_alg=3D0
[  236.844757] wlan0: authenticate with AP 00:0f:cc:b4:4e:14
[  238.549303] wlan0: RX authentication from 00:0f:cc:b4:4e:14 (alg=3D0 tra=
nsaction=3D2 status=3D0)
[  238.549313] wlan0: authenticated
[  238.549319] wlan0: associate with AP 00:0f:cc:b4:4e:14
[  238.554791] wlan0: RX AssocResp from 00:0f:cc:b4:4e:14 (capab=3D0x451 st=
atus=3D0 aid=3D1)
[  238.554803] wlan0: associated
[  238.554813] wlan0: switched to long barker preamble (BSSID=3D00:0f:cc:b4=
:4e:14)
[  238.555608] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

--Boundary-01=_GAR8HpowvbkYvMZ
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg_hibernateTwice_2.6.24"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg_hibernateTwice_2.6.24"

Initializing cgroup subsys cpuset
Linux version 2.6.24-1-amd64 (Debian 2.6.24-5) (waldi@debian.org) (gcc vers=
ion 4.1.3 20080308 (prerelease) (Debian 4.1.2-21)) #1 SMP Thu Mar 27 16:52:=
38 UTC 2008
Command line: BOOT_IMAGE=3D(hd0,1)/vmlinuz-2.6.24-1-amd64 root=3D/dev/mappe=
r/Tamino-Root ro quiet vga=3D792
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f680400 (usable)
 BIOS-e820: 000000007f680400 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 521856) 1 entries of 3200 used
end_pfn_map =3D 1048576
DMI 2.4 present.
ACPI: RSDP 000FBB00, 0024 (r2 DELL  )
ACPI: XSDT 7F681E00, 0064 (r1 DELL    M08     27D70512 ASL        61)
ACPI: FACP 7F681C9C, 00F4 (r4 DELL    M08     27D70512 ASL        61)
ACPI: DSDT 7F682400, 6122 (r2 INT430 SYSFexxx     1001 INTL 20050624)
ACPI: FACS 7F690C00, 0040
ACPI: HPET 7F681F00, 0038 (r1 DELL    M08            1 ASL        61)
ACPI: APIC 7F682000, 0068 (r1 DELL    M08     27D70512 ASL        47)
ACPI: ASF! 7F681C00, 007E (r32 DELL    M08     27D70512 ASL        61)
ACPI: MCFG 7F681FC0, 003E (r16 DELL    M08     27D70512 ASL        61)
ACPI: SLIC 7F68209C, 0176 (r1 DELL    M08     27D70512 ASL        61)
ACPI: TCPA 7F682300, 0032 (r1                        0 ASL         0)
ACPI: SSDT 7F6806EF, 04CC (r1  PmRef    CpuPm     3000 INTL 20050624)
No NUMA configuration found
=46aking a node at 0000000000000000-000000007f680000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 521856) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007f680000
No mptable found.
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   521856
On node 0 totalpages: 521759
  DMA zone: 56 pages used for memmap
  DMA zone: 1064 pages reserved
  DMA zone: 2879 pages, LIFO batch:0
  DMA32 zone: 7078 pages used for memmap
  DMA32 zone: 510682 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
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
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:78000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 34400 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 513561
Policy zone: DMA32
Kernel command line: BOOT_IMAGE=3D(hd0,1)/vmlinuz-2.6.24-1-amd64 root=3D/de=
v/mapper/Tamino-Root ro quiet vga=3D792
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
hpet clockevent registered
TSC calibrated against HPET
time.c: Detected 2194.496 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2046628k/2087424k available (2143k kernel code, 40408k reserved, 10=
03k data, 316k init)
Calibrating delay using timer specific routine.. 4393.98 BogoMIPS (lpj=3D87=
87961)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12468728
Detected 12.468 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4400.45 BogoMIPS (lpj=3D88=
00918)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at f8000000 - fbffffff
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 7F690C80, 0043 (r1  LMPWR  DELLLOM     1001 INTL 20050624)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1080-10bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disab=
led.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
pnpacpi: exceeded the max number of mem resources: 12
pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
pnp: the driver 'system' has been registered
system 00:05: ioport range 0xc80-0xcaf has been reserved
system 00:05: ioport range 0xcc0-0xcff could not be reserved
system 00:05: driver attached
system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:08: driver attached
system 00:0a: ioport range 0xcb0-0xcbb has been reserved
system 00:0a: iomem range 0xfed40000-0xfed44fff could not be reserved
system 00:0a: driver attached
system 00:0b: ioport range 0x900-0x97f has been reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x1000-0x1005 has been reserved
system 00:0b: ioport range 0x1008-0x100f has been reserved
system 00:0b: driver attached
system 00:0c: ioport range 0xf400-0xf4fe has been reserved
system 00:0c: ioport range 0x1006-0x1007 has been reserved
system 00:0c: ioport range 0x100a-0x1059 could not be reserved
system 00:0c: ioport range 0x1060-0x107f has been reserved
system 00:0c: ioport range 0x1080-0x10bf has been reserved
system 00:0c: ioport range 0x10c0-0x10df has been reserved
system 00:0c: ioport range 0x1010-0x102f has been reserved
system 00:0c: ioport range 0x809-0x809 has been reserved
system 00:0c: driver attached
system 00:0d: iomem range 0x0-0x9efff could not be reserved
system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff has been reserved
system 00:0d: iomem range 0xe0000-0xfffff has been reserved
system 00:0d: iomem range 0x100000-0x7f6803ff could not be reserved
system 00:0d: iomem range 0x7f680400-0x7f6fffff could not be reserved
system 00:0d: iomem range 0x7f700000-0x7f7fffff could not be reserved
system 00:0d: iomem range 0x7f700000-0x7fefffff could not be reserved
system 00:0d: iomem range 0xffe00000-0xffffffff could not be reserved
system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
system 00:0d: iomem range 0xfec00000-0xfec0ffff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfee0ffff could not be reserved
system 00:0d: driver attached
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: fe800000-fe8fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.5
  IO window: disabled.
  MEM window: fe700000-fe7fffff
  PREFETCH window: disabled.
PCI: Bus 4, cardbus bridge: 0000:03:01.0
  IO window: 00001400-000014ff
  IO window: 00001800-000018ff
  PREFETCH window: 88000000-8bffffff
  MEM window: 8c000000-8fffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: fe600000-fe6fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PCI: Enabling device 0000:03:01.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 19
NET: Registered protocol family 2
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
=46reeing initrd memory: 7401k freed
audit: initializing netlink socket (disabled)
audit(1206977597.084:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
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
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
Allocate Port Service[0000:00:1c.5:pcie03]
vesafb: framebuffer at 0xe0000000, mapped to 0xffffc20004980000, using 6144=
k, total 7616k
vesafb: mode is 1024x768x32, linelength=3D4096, pages=3D1
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
pnp: the driver 'serial' has been registered
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial 00:09: driver attached
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
input: Macintosh mouse button emulation as /class/input/input0
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:02: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:01: driver attached
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
=46reeing unused kernel memory: 316k freed
input: AT Translated Set 2 keyboard as /class/input/input1
ACPI: SSDT 7F6810F6, 0286 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 7F680BBB, 04B6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F68137C, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 7F681071, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
Marking TSC unstable due to TSC halts in idle
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
Time: hpet clocksource has been installed.
ACPI: Thermal Zone [THM] (57 C)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-2: new full speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
Clocksource tsc unstable (delta =3D -301309212 ns)
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
usb 1-2: configuration #1 chosen from 1 choice
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
usb 5-1: new full speed USB device using uhci_hcd and address 2
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:03:01.4[A] -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:03:01.4, OHCI version 1.10
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:09:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:09:00.0 to 64
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
pnp: the driver 'ide' has been registered
usb 1-2: USB disconnect, address 2
eth0: Tigon3 [partno(BCM95755m) rev a002 PHY(5755)] (PCI Express) 10/100/10=
00Base-T Ethernet 00:18:8b:d6:63:72
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
ahci 0000:00:1f.2: nr_ports (3) and implemented port map (0x5) don't match,=
 using nr_ports
ahci 0000:00:1f.2: forcing PORTS_IMPL to 0x7
firewire_core: created new fw device fw0 (0 config rom retries, S400)
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part=20
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fb900 irq 1276
ata2: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fb980 irq 1276
ata3: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fba00 irq 1276
usb 1-2: new full speed USB device using uhci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: Hitachi HTS541612J9SA00, SBDOC74P, max UDMA/100
ata1.00: 234441648 sectors, multi 8: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
usb 5-1: new full speed USB device using uhci_hcd and address 3
usb 5-1: configuration #1 chosen from 1 choice
hub 5-1:1.0: USB hub found
hub 5-1:1.0: 4 ports detected
ata2: SATA link down (SStatus 0 SControl 0)
usb 5-2: new full speed USB device using uhci_hcd and address 4
ata3: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54161 SBDO PQ: 0 ANSI: 5
ICH8M: IDE controller (0x8086:0x2850 rev 0x02) at  PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
ICH8M: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x6fa0-0x6fa7, BIOS settings: hda:DMA, hdb:pio
ICH8M: IDE port disabled
Probing IDE interface ide0...
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda:<6>usb 5-2: configuration #1 chosen from 1 choice
usb 5-1.2: new full speed USB device using uhci_hcd and address 5
usb 5-1.2: configuration #1 chosen from 1 choice
 sda1 sda2 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
hda: HL-DT-ST DVD+/-RW GSA-T11N, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redha=
t.com
Attempting manual resume
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Battery Slot [BAT1] (battery absent)
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [LID]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PBTN]
input: Sleep Button (CM) as /class/input/input4
ACPI: Sleep Button (CM) [SBTN]
input: Video Bus as /class/input/input5
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
input: Video Bus as /class/input/input6
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
input: Video Bus as /class/input/input7
ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
ACPI: AC Adapter [AC] (on-line)
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
Yenta: CardBus bridge found at 0000:03:01.0 [1028:01f9]
Yenta O2: res at 0x94/0xD4: 00/ea
Yenta O2: enabling read prefetch/write burst
Yenta: ISA IRQ mask 0x0cb8, PCI irq 19
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#03) from #04 to #07
pcmcia: parent PCI bridge Memory window: 0xfe600000 - 0xfe6fffff
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Lin=
ux, 1.1.17ks
iwl3945: Copyright(c) 2003-2007 Intel Corporation
ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:0c:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
input: PS/2 Mouse as /class/input/input8
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
input: AlpsPS/2 ALPS GlidePoint as /class/input/input9
iTCO_wdt: Found a ICH8M TCO device (Version=3D2, TCOBASE=3D0x1060)
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
EXT3 FS on dm-6, internal journal
loop: module loaded
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 6152184k swap on /dev/mapper/Tamino-swap_1.  Priority:-1 extents:1 a=
cross:6152184k
fuse init (API version 7.9)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:18:84:21:ef:2b
wlan0: RX authentication from 00:18:84:21:ef:2b (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:18:84:21:ef:2b
wlan0: RX AssocResp from 00:18:84:21:ef:2b (capab=3D0x431 status=3D0 aid=3D=
1)
wlan0: associated
wlan0: switched to short barker preamble (BSSID=3D00:18:84:21:ef:2b)
wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D1023 burst=
=3D20
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 burst=
=3D0
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 burst=3D=
30
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 burst=3D15
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D1023 burst=
=3D20
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 burst=
=3D0
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 burst=3D=
30
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 burst=3D15
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
pnp: the driver 'parport_pc' has been registered
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
wlan0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
Syncing filesystems ... done.
=46reezing user space processes ... (elapsed 0.00 seconds) done.
=46reezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Shrinking memory...  =08-=08done (0 pages freed)
=46reed 0 kbytes in 0.07 seconds (0.00 MB/s)
Suspending console(s)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
serial 00:09: disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
ACPI: PCI interrupt for device 0000:00:1a.7 disabled
ACPI: PCI interrupt for device 0000:00:1a.1 disabled
ACPI: PCI interrupt for device 0000:00:1a.0 disabled
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU1 is down
Extended CMOS year: 2000
swsusp: critical section:=20
swsusp: Need to copy 165823 pages
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4388.80 BogoMIPS (lpj=3D87=
77608)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
CPU1 is up
Switched to high resolution mode on CPU 1
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
usb usb1: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
usb usb2: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1a.7 to 64
usb usb6: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 10010=
6, writing 100102)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1c.5 to 64
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
usb usb3: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
usb usb4: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
usb usb5: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
PM: Writing back config space on device 0000:00:1e.0 at offset 6 (was 20040=
300, writing 20070300)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b004=
03, writing 2b00407)
PCI: Setting latency timer of device 0000:00:1f.2 to 64
Coming out of suspend...
PM: Writing back config space on device 0000:0c:00.0 at offset 1 (was 10010=
6, writing 100506)
PM: Writing back config space on device 0000:09:00.0 at offset c (was 0, wr=
iting dfa50000)
PM: Writing back config space on device 0000:09:00.0 at offset 1 (was 10010=
6, writing 100506)
PM: Writing back config space on device 0000:03:01.0 at offset f (was 14001=
ff, writing 5c001ff)
PM: Writing back config space on device 0000:03:01.0 at offset 3 (was 82400=
0, writing 82a800)
PM: Writing back config space on device 0000:03:01.0 at offset 1 (was 41000=
07, writing 4100087)
Yenta O2: res at 0x94/0xD4: 00/ea
Yenta O2: enabling read prefetch/write burst
ata3: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 0)
PM: Writing back config space on device 0000:03:01.4 at offset f (was 100, =
writing 103)
PM: Writing back config space on device 0000:03:01.4 at offset 5 (was 0, wr=
iting fe6fe800)
PM: Writing back config space on device 0000:03:01.4 at offset 4 (was 0, wr=
iting fe6ff000)
PM: Writing back config space on device 0000:03:01.4 at offset 3 (was 0, wr=
iting 4010)
PM: Writing back config space on device 0000:03:01.4 at offset 1 (was 21000=
80, writing 2180117)
i8042 aux 00:01: activation not supported
i8042 kbd 00:02: activation not supported
pnp: Res cnt 2
pnp: res cnt 2
pnp: Encode irq
pnp: Encode io
serial 00:09: activated
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] Starting disk
do_drive_get_GTF: Run _GTF error: status =3D 0x5
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
Restarting tasks ... <6>usb 1-2: USB disconnect, address 3
done.
swsusp: Basic memory bitmaps freed
usb 5-1: USB disconnect, address 3
usb 5-1.2: USB disconnect, address 5
usb 5-2: USB disconnect, address 4
usb 1-2: new full speed USB device using uhci_hcd and address 4
usb 1-2: configuration #1 chosen from 1 choice
usb 5-1: new full speed USB device using uhci_hcd and address 6
usb 5-1: configuration #1 chosen from 1 choice
hub 5-1:1.0: USB hub found
hub 5-1:1.0: 4 ports detected
usb 5-2: new full speed USB device using uhci_hcd and address 7
usb 5-2: configuration #1 chosen from 1 choice
usb 5-1.2: new full speed USB device using uhci_hcd and address 8
usb 5-1.2: configuration #1 chosen from 1 choice
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:18:84:21:ef:2b
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:18:84:21:ef:2b
wlan0: RX authentication from 00:18:84:21:ef:2b (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:18:84:21:ef:2b
wlan0: RX ReassocResp from 00:18:84:21:ef:2b (capab=3D0x431 status=3D0 aid=
=3D1)
wlan0: associated
wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D1023 burst=
=3D20
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 burst=
=3D0
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 burst=3D=
30
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 burst=3D15
wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D1023 burst=
=3D20
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 burst=
=3D0
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 burst=3D=
30
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 burst=3D15
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
Syncing filesystems ... done.
=46reezing user space processes ... (elapsed 0.00 seconds) done.
=46reezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Shrinking memory...  =08-=08done (0 pages freed)
=46reed 0 kbytes in 0.07 seconds (0.00 MB/s)
Suspending console(s)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
serial 00:09: disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
ACPI: PCI interrupt for device 0000:00:1a.7 disabled
ACPI: PCI interrupt for device 0000:00:1a.1 disabled
ACPI: PCI interrupt for device 0000:00:1a.0 disabled
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU1 is down
Extended CMOS year: 2000
swsusp: critical section:=20
swsusp: Need to copy 166144 pages
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4388.78 BogoMIPS (lpj=3D87=
77570)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
CPU1 is up
Switched to high resolution mode on CPU 1
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
usb usb1: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
usb usb2: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1a.7 to 64
usb usb6: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 10010=
6, writing 100102)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1c.5 to 64
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
usb usb3: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
usb usb4: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
usb usb5: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 8bf18=
801, writing 1fff1)
PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was a2802=
020, writing a28000f0)
PM: Writing back config space on device 0000:00:1e.0 at offset 6 (was 20040=
300, writing 20070300)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b004=
03, writing 2b00407)
PCI: Setting latency timer of device 0000:00:1f.2 to 64
Coming out of suspend...
PM: Writing back config space on device 0000:0c:00.0 at offset 1 (was 10010=
6, writing 100506)
PM: Writing back config space on device 0000:09:00.0 at offset c (was 0, wr=
iting dfa50000)
PM: Writing back config space on device 0000:09:00.0 at offset 1 (was 10010=
6, writing 100506)
PM: Writing back config space on device 0000:03:01.0 at offset f (was 14001=
ff, writing 5c001ff)
PM: Writing back config space on device 0000:03:01.0 at offset e (was 24fd,=
 writing 18fd)
PM: Writing back config space on device 0000:03:01.0 at offset d (was 2401,=
 writing 1801)
PM: Writing back config space on device 0000:03:01.0 at offset c (was 20fd,=
 writing 14fd)
PM: Writing back config space on device 0000:03:01.0 at offset b (was 2001,=
 writing 1401)
PM: Writing back config space on device 0000:03:01.0 at offset 3 (was 82400=
0, writing 82a800)
PM: Writing back config space on device 0000:03:01.0 at offset 1 (was 41000=
07, writing 4100087)
Yenta O2: res at 0x94/0xD4: 00/ea
Yenta O2: enabling read prefetch/write burst
ata3: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 0)
PM: Writing back config space on device 0000:03:01.4 at offset f (was 100, =
writing 103)
PM: Writing back config space on device 0000:03:01.4 at offset 5 (was 0, wr=
iting fe6fe800)
PM: Writing back config space on device 0000:03:01.4 at offset 4 (was 0, wr=
iting fe6ff000)
PM: Writing back config space on device 0000:03:01.4 at offset 3 (was 0, wr=
iting 4010)
PM: Writing back config space on device 0000:03:01.4 at offset 1 (was 21000=
80, writing 2180117)
i8042 aux 00:01: activation not supported
i8042 kbd 00:02: activation not supported
pnp: Res cnt 2
pnp: res cnt 2
pnp: Encode irq
pnp: Encode io
serial 00:09: activated
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] Starting disk
do_drive_get_GTF: Run _GTF error: status =3D 0x5
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
Restarting tasks ... <6>usb 1-2: USB disconnect, address 4
done.
swsusp: Basic memory bitmaps freed
usb 5-1: USB disconnect, address 6
usb 5-1.2: USB disconnect, address 8
usb 5-2: USB disconnect, address 7
usb 5-1: new full speed USB device using uhci_hcd and address 9
usb 5-1: configuration #1 chosen from 1 choice
hub 5-1:1.0: USB hub found
hub 5-1:1.0: 4 ports detected
usb 5-2: new full speed USB device using uhci_hcd and address 10
usb 5-2: configuration #1 chosen from 1 choice
usb 1-2: new full speed USB device using uhci_hcd and address 5
usb 1-2: configuration #1 chosen from 1 choice
usb 5-1.2: new full speed USB device using uhci_hcd and address 11
usb 5-1.2: configuration #1 chosen from 1 choice
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:18:84:21:ef:2b
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:18:84:21:ef:2b
wlan0: RX authentication from 00:18:84:21:ef:2b (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:18:84:21:ef:2b
wlan0: authentication frame received from 00:18:84:21:ef:2b, but not in aut=
henticate state - ignored
wlan0: RX ReassocResp from 00:18:84:21:ef:2b (capab=3D0x431 status=3D0 aid=
=3D1)
wlan0: associated
wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D1023 burst=
=3D20
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 burst=
=3D0
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 burst=3D=
30
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 burst=3D15
wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D1023 burst=
=3D20
wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 burst=
=3D0
wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 burst=3D=
30
wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 burst=3D15

--Boundary-01=_GAR8HpowvbkYvMZ--

--nextPart8687908.0KJcU4fV75
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH8RAIwW1nnOmiePARAjGYAJ0bjrpj+HwBngY2BpdYRRL1pt8SJQCgmbRX
o/AyQmDgYJ3H6GpZh+VvjHQ=
=MMRl
-----END PGP SIGNATURE-----

--nextPart8687908.0KJcU4fV75--
