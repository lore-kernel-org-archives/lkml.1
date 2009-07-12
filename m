Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZGLDFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZGLDFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 23:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZGLDFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 23:05:39 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50783 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZGLDFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 23:05:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aHtTex1Y+/hbiTMJfiRDEwcyx+NRyKmDGdPhNTIXFX/yhNxV42jos0pXugI1Tg8NEm
         eLIUlRedzy8u3419468kAnzu+3prEFEC7wj8uHMCzsW0WgfgSdFyLwzZocKfoG2mbcfP
         VoQNCk1tq8JlyrGNBzWwQ/YFqpinyRu/sGZNQ=
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 12:05:34 +0900
Message-ID: <62c294d80907112005n6458193dye48d5bd3203d50f4@mail.gmail.com>
Subject: sometimes kernel cannot detect GlidePoint input Device
From: haiyang kang <cornsea@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-laptop@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i find if my microsoft usb mouse is detected first, the glidepoint
device can not be detected,
but i cannot make sure, because i have not check all the cannot dmesg.

 my machine : Dell D610
 Linux localhost.localdomain 2.6.29.4-167.fc11.i586 #1 SMP Wed May 27
17:14:37 EDT 2009 i686 i686 i386 GNU/Linux

this is the  diff file for can and cannot dmesg.

diff --git a/failure_dmesg.txt b/success_dmesg.txt
index 871bcd9..e9d6327 100644
--- a/failure_dmesg.txt
+++ b/success_dmesg.txt
@@ -103,7 +103,7 @@ Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
 PID hash table entries: 4096 (order: 12, 16384 bytes)
 Fast TSC calibration using PIT
-Detected 1994.855 MHz processor.
+Detected 1995.118 MHz processor.
 Console: colour VGA+ 80x25
 console [tty0] enabled
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
@@ -121,7 +121,7 @@ virtual kernel memory layout:
      .text : 0xc0400000 - 0xc070be4a   (3119 kB)
 Checking if this processor honours the WP bit even in supervisor mode...Ok.
 SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
-Calibrating delay loop (skipped), value calculated using timer
frequency.. 3989.71 BogoMIPS (lpj=1994855)
+Calibrating delay loop (skipped), value calculated using timer
frequency.. 3990.23 BogoMIPS (lpj=1995118)
 Security Framework initialized
 SELinux:  Initializing.
 SELinux:  Starting in permissive mode
@@ -144,7 +144,7 @@ ftrace: allocating 18115 entries in 72 pages
 ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
 CPU0: Intel(R) Pentium(R) M processor 2.00GHz stepping 08
 Brought up 1 CPUs
-Total of 1 processors activated (3989.71 BogoMIPS).
+Total of 1 processors activated (3990.23 BogoMIPS).
 sizeof(vma)=84 bytes
 sizeof(page)=32 bytes
 sizeof(inode)=340 bytes
@@ -157,7 +157,7 @@ CPU0 attaching NULL sched-domain.
 net_namespace: 1064 bytes
 Booting paravirtualized kernel on bare hardware
 regulator: core version 0.5
-Time:  0:04:34  Date: 07/12/09
+Time:  0:08:37  Date: 07/12/09
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
@@ -460,7 +460,7 @@ checking if image is initramfs... it is
 Freeing initrd memory: 3056k freed
 apm: BIOS not found.
 audit: initializing netlink socket (disabled)
-type=2000 audit(1247357073.522:1): initialized
+type=2000 audit(1247357316.522:1): initialized
 highmem bounce pool size: 64 pages
 HugeTLB registered 4 MB page size, pre-allocated 0 pages
 VFS: Disk quotas dquot_6.5.2
@@ -496,7 +496,7 @@ ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
 processor ACPI_CPU:00: registered as cooling_device0
 ACPI: Processor [CPU0] (supports 8 throttling states)
 thermal LNXTHERM:01: registered as thermal_zone0
-ACPI: Thermal Zone [THM] (41 C)
+ACPI: Thermal Zone [THM] (60 C)
 isapnp: Scanning for PnP cards...
 Switched to high resolution mode on CPU 0
 isapnp: No Plug & Play device found
@@ -645,7 +645,7 @@ Initializing XFRM netlink socket
 NET: Registered protocol family 17
 Using IPI No-Shortcut mode
 registered taskstats version 1
-  Magic number: 1:416:51
+  Magic number: 1:966:101
 Initalizing network drop monitor service
 Freeing unused kernel memory: 424k freed
 Write protecting the kernel read-only data: 1448k
@@ -659,7 +659,7 @@ ACPI: Video Device [VID2] (multi-head: yes  rom:
no  post: no)
 [drm] Initialized drm 1.1.0 20060810
 i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 i915 0000:00:02.0: setting latency timer to 64
-Clocksource tsc unstable (delta = -73941129 ns)
+Clocksource tsc unstable (delta = -72576178 ns)
 integrated sync not supported
 usb 4-1: new low speed USB device using uhci_hcd and address 2
 usb 4-1: New USB device found, idVendor=045e, idProduct=00cb
@@ -667,8 +667,10 @@ usb 4-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=0
 usb 4-1: Product: Microsoft Basic Optical Mouse v2.0
 usb 4-1: Manufacturer: Microsoft
 usb 4-1: configuration #1 chosen from 1 choice
-input: Microsoft  Microsoft Basic Optical Mouse v2.0  as
/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input7
+input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input7
+input: Microsoft  Microsoft Basic Optical Mouse v2.0  as
/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input8
 generic-usb 0003:045E:00CB.0001: input,hidraw0: USB HID v1.11 Mouse
[Microsoft  Microsoft Basic Optical Mouse v2.0 ] on
usb-0000:00:1d.2-1/input0
+input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input9
 i2c-adapter i2c-0: unable to read EDID block.
 i915 0000:00:02.0: VGA-1: no EDID data
 integrated sync not supported
@@ -684,50 +686,47 @@ kjournald starting.  Commit interval 5 seconds
 EXT3-fs: mounted filesystem with ordered data mode.
 SELinux:  Disabled at runtime.
 SELinux:  Unregistering netfilter hooks
-type=1404 audit(1247357078.235:2): selinux=0 auid=4294967295 ses=4294967295
+type=1404 audit(1247357321.311:2): selinux=0 auid=4294967295 ses=4294967295
 udev: starting version 141
 dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
-input: PC Speaker as /devices/platform/pcspkr/input/input8
-parport_pc 00:0c: reported by Plug and Play ACPI
-parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
 lib80211: common routines for IEEE802.11 drivers
 lib80211_crypt: registered algorithm 'NULL'
-ieee80211: 802.11 data/management/control stack, git-1.1.13
-ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
-ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
-ipw2200: Copyright(c) 2003-2006 Intel Corporation
-ipw2200 0000:03:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
-ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
-eth0 (ipw2200): not using net_device_ops yet
-ipw2200 0000:03:03.0: firmware: requesting ipw2200-bss.fw
-i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
+parport_pc 00:0c: reported by Plug and Play ACPI
+parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
+input: PC Speaker as /devices/platform/pcspkr/input/input10
+intel_rng: FWH not detected
 tg3.c:v3.97 (December 10, 2008)
 tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 tg3 0000:02:00.0: setting latency timer to 64
 tg3 0000:02:00.0: wake-up capability disabled by ACPI
 tg3 0000:02:00.0: PME# disabled
-ipw2200: Detected geography ZZJ (14 802.11bg channels, 4 802.11a channels)
-eth1: Tigon3 [partno(BCM95751) rev 4001] (PCI Express) MAC address
00:14:22:b4:73:4b
-eth1: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
-eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
-eth1: dma_rwctrl[76180000] dma_mask[64-bit]
-udev: renamed network interface eth0 to eth1
-udev: renamed network interface eth1_rename to eth0
-intel_rng: FWH not detected
-yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:0182]
-yenta_cardbus 0000:03:01.0: Using CSCINT to route CSC interrupts to PCI
-yenta_cardbus 0000:03:01.0: Routing CardBus interrupts to PCI
-yenta_cardbus 0000:03:01.0: TI: mfunc 0x01111122, devctl 0x64
+eth0: Tigon3 [partno(BCM95751) rev 4001] (PCI Express) MAC address
00:14:22:b4:73:4b
+eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
+eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
+eth0: dma_rwctrl[76180000] dma_mask[64-bit]
 iTCO_vendor_support: vendor-support=0
+ppdev: user-space parallel port driver
 iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
 iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x1060)
 iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
-ppdev: user-space parallel port driver
+ieee80211: 802.11 data/management/control stack, git-1.1.13
+ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
+yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:0182]
+yenta_cardbus 0000:03:01.0: Using CSCINT to route CSC interrupts to PCI
+yenta_cardbus 0000:03:01.0: Routing CardBus interrupts to PCI
+yenta_cardbus 0000:03:01.0: TI: mfunc 0x01111122, devctl 0x64
+ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
+ipw2200: Copyright(c) 2003-2006 Intel Corporation
+i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x0c78, PCI irq 19
 yenta_cardbus 0000:03:01.0: Socket status: 30000006
 pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 to #07
 yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window:
0xdfc00000 - 0xdfcfffff
 yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window:
0x60000000 - 0x63ffffff
+ipw2200 0000:03:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
+ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
+eth1 (ipw2200): not using net_device_ops yet
+ipw2200 0000:03:03.0: firmware: requesting ipw2200-bss.fw
 pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
 pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: clean.
 pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
@@ -738,7 +737,8 @@ Intel ICH Modem 0000:00:1e.3: setting latency timer to 64
 ALSA sound/pci/ac97/ac97_codec.c:2159: MC'97 1 converters and GPIO
not ready (0xff00)
 Intel ICH 0000:00:1e.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 Intel ICH 0000:00:1e.2: setting latency timer to 64
-intel8x0_measure_ac97_clock: measured 50777 usecs
+ipw2200: Detected geography ZZJ (14 802.11bg channels, 4 802.11a channels)
+intel8x0_measure_ac97_clock: measured 50774 usecs
 intel8x0: clocking to 48000
 device-mapper: multipath: version 1.0.5 loaded
 EXT3 FS on sda3, internal journal
@@ -760,10 +760,10 @@ tg3 0000:02:00.0: PME# disabled
 ADDRCONF(NETDEV_UP): eth0: link is not ready
 Bridge firewalling registered
 virbr0: starting userspace STP failed, starting kernel STP
-lo: Disabled Privacy Extensions
 tg3: eth0: Link is up at 100 Mbps, full duplex.
 tg3: eth0: Flow control is off for TX and off for RX.
 ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
+lo: Disabled Privacy Extensions
 i2c-adapter i2c-0: unable to read EDID block.
 i915 0000:00:02.0: VGA-1: no EDID data
 i2c-adapter i2c-0: unable to read EDID block.
@@ -787,12 +787,13 @@ integrated sync not supported
 [drm] TV-15: set mode NTSC 480i 0
 [drm] TV-15: set mode NTSC 480i 0
 i2c-adapter i2c-0: unable to read EDID block.
-virbr0: no IPv6 routers present
 i915 0000:00:02.0: VGA-1: no EDID data
 i2c-adapter i2c-0: unable to read EDID block.
 i915 0000:00:02.0: VGA-1: no EDID data
+eth0: no IPv6 routers present
 integrated sync not supported
 [drm] TV-15: set mode NTSC 480i 0
+virbr0: no IPv6 routers present
 [drm] TV-15: set mode NTSC 480i 0
 i2c-adapter i2c-0: unable to read EDID block.
 i915 0000:00:02.0: VGA-1: no EDID data
@@ -801,7 +802,6 @@ i915 0000:00:02.0: VGA-1: no EDID data
 integrated sync not supported
 [drm] TV-15: set mode NTSC 480i 0
 [drm] TV-15: set mode NTSC 480i 0
-eth0: no IPv6 routers present
 i2c-adapter i2c-0: unable to read EDID block.
 i915 0000:00:02.0: VGA-1: no EDID data
 i2c-adapter i2c-0: unable to read EDID block.
