Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0CCDzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 22:55:16 -0500
Received: from smh1-gp.mediaserv.net ([213.188.172.31]:32805 "EHLO
	smhav-gp.mediaserv.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751948Ab0CCDzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 22:55:12 -0500
From: werner@guyane.dyn-o-saur.com
Subject: 2.6.33 problems
To: tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1267587210.10602@guyane.dyn-o-saur.com>
Date: Wed, 03 Mar 2010 00:33:30 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1267587210"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1267587210
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

dmesg isn't complete.  That's a general problem.   When we get 1 GB dmesg buffer in the kernel config ????


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D syslog =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Mar  3 00:15:44 werner kernel: ACPI: RSDP 000f6fd0 00024 (v02 Nvidia)
Mar  3 00:15:44 werner kernel: ACPI: XSDT afee30c0 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Mar  3 00:15:44 werner kernel: ACPI: FACP afeeb840 000F4 (v03 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Mar  3 00:15:44 werner kernel: ACPI: DSDT afee3240 08581 (v01 NVIDIA ASUSACPI 00001000 MSFT 03000000)
Mar  3 00:15:44 werner kernel: ACPI: FACS afee0000 00040
Mar  3 00:15:44 werner kernel: ACPI: MCFG afeeba40 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Mar  3 00:15:44 werner kernel: ACPI: APIC afeeb980 0007C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Mar  3 00:15:44 werner kernel: Zone PFN ranges:
Mar  3 00:15:44 werner kernel:   DMA      0x00000010 -> 0x00001000
Mar  3 00:15:44 werner kernel:   Normal   0x00001000 -> 0x000377fe
Mar  3 00:15:44 werner kernel:   HighMem  0x000377fe -> 0x000afee0
Mar  3 00:15:44 werner kernel: Movable zone start PFN for each node
Mar  3 00:15:44 werner kernel: early_node_map[2] active PFN ranges
Mar  3 00:15:44 werner kernel:     0: 0x00000010 -> 0x0000009f
Mar  3 00:15:44 werner kernel:     0: 0x00000100 -> 0x000afee0
Mar  3 00:15:44 werner kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 714865
Mar  3 00:15:44 werner kernel: Console: colour dummy device 80x25
Mar  3 00:15:44 werner kernel: Fast TSC calibration using PIT
Mar  3 00:15:44 werner kernel: Detected 2511.141 MHz processor.
Mar  3 00:15:44 werner kernel: Mount-cache hash table entries: 512
Mar  3 00:15:44 werner kernel: AMD PMU driver.
Mar  3 00:15:44 werner kernel: bio: create slab <bio-0> at 0
Mar  3 00:15:44 werner kernel: raid6: int32x1    640 MB/s
Mar  3 00:15:44 werner kernel: raid6: int32x2    863 MB/s
Mar  3 00:15:44 werner kernel: raid6: int32x4    710 MB/s
Mar  3 00:15:44 werner kernel: raid6: int32x8    542 MB/s
Mar  3 00:15:44 werner kernel: raid6: mmxx1     2027 MB/s
Mar  3 00:15:44 werner kernel: raid6: mmxx2     3722 MB/s
Mar  3 00:15:44 werner kernel: raid6: sse1x1    2019 MB/s
Mar  3 00:15:44 werner kernel: raid6: sse1x2    3316 MB/s
Mar  3 00:15:44 werner kernel: raid6: sse2x1    3359 MB/s
Mar  3 00:15:44 werner kernel: raid6: sse2x2    4324 MB/s
Mar  3 00:15:44 werner kernel: raid6: using algorithm sse2x2 (4324 MB/s)
Mar  3 00:15:44 werner kernel: PCI: Probing PCI hardware
Mar  3 00:15:44 werner kernel: pci 0000:01:08.0: BAR 1: error updating (0xfd800000 !=3D 0xf9800000)
Mar  3 00:15:44 werner kernel: microcode: microcode: CPU0: AMD CPU family 0xf not supported
Mar  3 00:15:44 werner kernel: highmem bounce pool size: 64 pages
Mar  3 00:15:44 werner kernel: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Mar  3 00:15:44 werner kernel: DLM (built Mar  2 2010 05:01:14) installed
Mar  3 00:15:44 werner kernel: EFS: 1.0a - http://aeschi.ch.eu.org/efs/
Mar  3 00:15:44 werner kernel: OCFS2 User DLM kernel interface loaded
Mar  3 00:15:44 werner kernel: GFS2 (built Mar  2 2010 05:02:48) installed
Mar  3 00:15:44 werner kernel: acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
Mar  3 00:15:44 werner kernel: mdacon: MDA with 8K of memory detected.
Mar  3 00:15:44 werner kernel: Console: switching consoles 13-16 to MDA-2
Mar  3 00:15:44 werner kernel: nvidiafb: CRTC0 analog found
Mar  3 00:15:44 werner kernel: nvidiafb: CRTC1 analog not found
Mar  3 00:15:44 werner kernel: i2c i2c-0: unable to read EDID block.
Mar  3 00:15:44 werner last message repeated 2 times
Mar  3 00:15:44 werner kernel: nvidiafb: EDID found from BUS2
Mar  3 00:15:44 werner kernel: nvidiafb: CRTC 0 appears to have a CRT attached
Mar  3 00:15:44 werner kernel: nvidiafb: Using CRT on CRTC 0
Mar  3 00:15:44 werner kernel: Console: switching to colour frame buffer device 210x65
Mar  3 00:15:44 werner kernel: Could not find Carillo Ranch MCH device.
Mar  3 00:15:44 werner kernel: no IO addresses supplied
Mar  3 00:15:44 werner kernel: hgafb: probe of hgafb.0 failed with error -22
Mar  3 00:15:44 werner kernel: uvesafb: failed to execute /sbin/v86d
Mar  3 00:15:44 werner kernel: uvesafb: make sure that the v86d helper is installed and executable
Mar  3 00:15:44 werner kernel: uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D-2)
Mar  3 00:15:44 werner kernel: uvesafb: vbe_init() failed with -22
Mar  3 00:15:44 werner kernel: uvesafb: probe of uvesafb.0 failed with error -22
Mar  3 00:15:44 werner kernel: vesafb: cannot reserve video memory at 0xe0000000
Mar  3 00:15:44 werner kernel: toshiba: not a supported Toshiba laptop
Mar  3 00:15:44 werner kernel: floppy0: no floppy controllers found
Mar  3 00:15:44 werner kernel: Compaq SMART2 Driver (v 2.6.0)
Mar  3 00:15:44 werner kernel: amd74xx 0000:00:06.0: BIOS didn't set cable bits correctly. Enabling workaround.
Mar  3 00:15:44 werner kernel: JMicron IDE 0000:03:00.1: can't find IRQ for PCI INT B; please try using pci=3Dbiosirq
Mar  3 00:15:44 werner kernel: jmicron 0000:03:00.1: bad irq (0): will probe later
Mar  3 00:15:44 werner kernel: ide1: disabled, no IRQ
Mar  3 00:15:44 werner kernel: ide2: disabled, no IRQ
Mar  3 00:15:44 werner kernel: JMicron IDE: probe of 0000:03:00.1 failed with error -1
Mar  3 00:15:44 werner kernel: Loading Adaptec I2O RAID: Version 2.4 Build 5go
Mar  3 00:15:44 werner kernel: scsi: <fdomain> Detection failed (no card)
Mar  3 00:15:44 werner kernel: NCR53c406a: no available ports found
Mar  3 00:15:44 werner kernel: Emulex LightPulse Fibre Channel SCSI driver 8.3.9
Mar  3 00:15:44 werner kernel: Copyright(c) 2004-2009 Emulex.  All rights reserved.
Mar  3 00:15:44 werner kernel: Failed initialization of WD-7000 SCSI card!
Mar  3 00:15:44 werner kernel: GDT-HA: Storage RAID Controller Driver. Version: 3.05
Mar  3 00:15:44 werner kernel: 3ware Storage Controller device driver for Linux v1.26.02.002.
Mar  3 00:15:44 werner kernel: 3ware 9000 Storage Controller device driver for Linux v2.26.02.013.
Mar  3 00:15:44 werner kernel: imm: Version 2.05 (for Linux 2.4.0)
Mar  3 00:15:44 werner kernel: pata_jmicron 0000:03:00.1: BAR 0: can't reserve [io  0x9c00-0x9c07]
Mar  3 00:15:44 werner kernel: pata_jmicron 0000:03:00.1: failed to request/iomap BARs for port 0 (errno=3D-16)
Mar  3 00:15:44 werner kernel: pata_jmicron 0000:03:00.1: BAR 2: can't reserve [io  0x9400-0x9407]
Mar  3 00:15:44 werner kernel: pata_jmicron 0000:03:00.1: failed to request/iomap BARs for port 1 (errno=3D-16)
Mar  3 00:15:44 werner kernel: pata_jmicron 0000:03:00.1: no available native port
Mar  3 00:15:44 werner kernel: Error: Driver 'pata_platform' is already registered, aborting...
Mar  3 00:15:44 werner kernel: pata_acpi 0000:03:00.1: BAR 0: can't reserve [io  0x9c00-0x9c07]
Mar  3 00:15:44 werner kernel: pata_acpi 0000:03:00.1: failed to request/iomap BARs for port 0 (errno=3D-16)
Mar  3 00:15:44 werner kernel: pata_acpi 0000:03:00.1: BAR 2: can't reserve [io  0x9400-0x9407]
Mar  3 00:15:44 werner kernel: pata_acpi 0000:03:00.1: failed to request/iomap BARs for port 1 (errno=3D-16)
Mar  3 00:15:44 werner kernel: pata_acpi 0000:03:00.1: no available native port
Mar  3 00:15:44 werner kernel: mtdoops: mtd device (mtddev=3Dname/number) must be supplied
Mar  3 00:15:44 werner kernel: physmap-flash.0: failed to claim resource 0
Mar  3 00:15:44 werner kernel: Failed to ioremap_nocache
Mar  3 00:15:44 werner last message repeated 2 times
Mar  3 00:15:44 werner kernel: SNAPGEAR: failed to ioremap() BOOTCS
Mar  3 00:15:44 werner kernel: Generic platform RAM MTD, (c) 2004 Simtec Electronics
Mar  3 00:15:44 werner kernel: flash size: 8 MiB
Mar  3 00:15:44 werner kernel: page size: 512 bytes
Mar  3 00:15:44 werner kernel: OOB area size: 16 bytes
Mar  3 00:15:44 werner kernel: sector size: 8 KiB
Mar  3 00:15:44 werner kernel: pages number: 16384
Mar  3 00:15:44 werner kernel: pages per sector: 16
Mar  3 00:15:44 werner kernel: bus width: 8
Mar  3 00:15:44 werner kernel: bits in sector size: 13
Mar  3 00:15:44 werner kernel: bits in page size: 9
Mar  3 00:15:44 werner kernel: bits in OOB size: 4
Mar  3 00:15:44 werner kernel: flash size with OOB: 8448 KiB
Mar  3 00:15:44 werner kernel: page address bytes: 3
Mar  3 00:15:44 werner kernel: sector address bytes: 2
Mar  3 00:15:44 werner kernel: options: 0x62
Mar  3 00:15:44 werner kernel: onenand_wait: timeout! ctrl=3D0x0000 intr=3D0x0000
Mar  3 00:15:44 werner kernel: DE600: port 0x378 busy
Mar  3 00:15:44 werner kernel: paride: aten registered as protocol 0
Mar  3 00:15:44 werner kernel: paride: bpck registered as protocol 1
Mar  3 00:15:44 werner kernel: paride: comm registered as protocol 2
Mar  3 00:15:44 werner kernel: paride: dstr registered as protocol 3
Mar  3 00:15:44 werner kernel: paride: k951 registered as protocol 4
Mar  3 00:15:44 werner kernel: paride: k971 registered as protocol 5
Mar  3 00:15:44 werner kernel: paride: epat registered as protocol 6
Mar  3 00:15:44 werner kernel: paride: epia registered as protocol 7
Mar  3 00:15:44 werner kernel: paride: frpw registered as protocol 8
Mar  3 00:15:44 werner kernel: paride: friq registered as protocol 9
Mar  3 00:15:44 werner kernel: paride: fit2 registered as protocol 10
Mar  3 00:15:44 werner kernel: paride: fit3 registered as protocol 11
Mar  3 00:15:44 werner kernel: paride: on20 registered as protocol 12
Mar  3 00:15:44 werner kernel: paride: on26 registered as protocol 13
Mar  3 00:15:44 werner kernel: paride: ktti registered as protocol 14
Mar  3 00:15:44 werner kernel: paride: bpck6 registered as protocol 15
Mar  3 00:15:44 werner kernel: pd: pd version 1.05, major 45, cluster 64, nice 0
Mar  3 00:15:44 werner kernel: pda: Autoprobe failed
Mar  3 00:15:44 werner kernel: pd: no valid drive found
Mar  3 00:15:44 werner kernel: pcd: pcd version 1.07, major 46, nice 0
Mar  3 00:15:44 werner kernel: pcd0: Autoprobe failed
Mar  3 00:15:44 werner kernel: pcd: No CD-ROM drive found
Mar  3 00:15:44 werner kernel: pf: pf version 1.04, major 47, cluster 64, nice 0
Mar  3 00:15:44 werner kernel: pf: No ATAPI disk detected
Mar  3 00:15:44 werner kernel: pt: pt version 1.04, major 96
Mar  3 00:15:44 werner kernel: pt0: Autoprobe failed
Mar  3 00:15:44 werner kernel: pt: No ATAPI tape drive detected
Mar  3 00:15:44 werner kernel: pg: pg version 1.02, major 97
Mar  3 00:15:44 werner kernel: pga: Autoprobe failed
Mar  3 00:15:44 werner kernel: pg: No ATAPI device detected
Mar  3 00:15:44 werner kernel: GTCO usb driver version: 2.00.0006
Mar  3 00:15:44 werner kernel: Cannot allocate resource for EISA slot 1
Mar  3 00:15:44 werner kernel: Cannot allocate resource for EISA slot 7
Mar  3 00:15:44 werner kernel: Cannot allocate resource for EISA slot 8
Mar  3 00:15:44 werner kernel: dell-wmi: No known WMI GUID found
Mar  3 00:15:44 werner kernel: This machine doesn't have MSI-hotkeys through WMI
Mar  3 00:15:44 werner kernel: [Firmware Bug]: powernow-k8: No PSB or ACPI _PSS objects
Mar  3 00:15:44 werner kernel:  sda1 sda2 sda3 sda4
Mar  3 00:15:44 werner kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Mar  3 00:15:44 werner kernel: usb 2-2: device descriptor read/64, error -62
Mar  3 00:15:44 werner last message repeated 2 times
Mar  3 00:15:44 werner kernel: VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
Mar  3 00:15:44 werner kernel: usb 2-2: device descriptor read/64, error -62
Mar  3 00:15:44 werner kernel: usb 2-2: device not accepting address 4, error -62
Mar  3 00:15:44 werner kernel: usb 2-2: device not accepting address 5, error -62
Mar  3 00:15:44 werner kernel: hub 2-0:1.0: unable to enumerate USB device on port 2
Mar  3 00:15:44 werner kernel: k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
Mar  3 00:15:44 werner kernel: 8139too 0000:01:08.0: Chip not responding, ignoring board
Mar  3 00:15:44 werner kernel: 8139too: probe of 0000:01:08.0 failed with error -5
Mar  3 00:15:44 werner kernel: rt2860sta: module is from the staging directory, the quality is unknown, you have been warned.
Mar  3 00:15:44 werner kernel: EXT3-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
Mar  3 00:15:44 werner udevd-event[4935]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Mar  3 00:15:44 werner udevd-event[4934]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Mar  3 00:15:44 werner udevd-event[4933]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Mar  3 00:15:55 werner apcupsd[4911]: apcupsd FATAL ERROR in smartsetup.c at line 171 PANIC! Cannot communicate with UPS via serial port. Please make sure the port specified on the DEVICE directive is correct, and that your cable specification on the UPSCABLE directive is correct. 
Mar  3 00:15:55 werner apcupsd[4911]: apcupsd error shutdown completed
Mar  3 00:15:59 werner hal_lpadmin: Unable to connect to CUPS: 'httpConnectionEncrypt failed'.  Is CUPS running?
Mar  3 00:15:59 werner hal_lpadmin: File "/usr/libexec/hal_lpadmin", line 476, in main     h =3D HalLpAdmin()
Mar  3 00:15:59 werner hal_lpadmin: File "/usr/libexec/hal_lpadmin", line 449, in __init__     self.addPrinter()
Mar  3 00:15:59 werner hal_lpadmin: File "/usr/libexec/hal_lpadmin", line 461, in addPrinter     printer =3D HalPrinter()
Mar  3 00:15:59 werner hal_lpadmin: File "/usr/libexec/hal_lpadmin", line 51, in __init__     sys.exit (1)
Mar  3 00:15:59 werner hal_lpadmin: SystemExit: 1
Mar  3 00:16:01 werner hpijs: unable to init hpijs server 
Mar  3 00:16:03 werner udevd[2305]: add_to_rules: unknown key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Mar  3 00:16:09 werner kernel: PERCPU: allocation failed, size=3D2048 align=3D8, failed to allocate new chunk
Mar  3 00:16:09 werner kernel: Pid: 5289, comm: modprobe Tainted: G         C 2.6.33-git7 #1
Mar  3 00:16:09 werner kernel: Call Trace:
Mar  3 00:16:09 werner kernel:  [<c1c68aa9>] ? printk+0x14/0x16
Mar  3 00:16:09 werner kernel:  [<c10bbd83>] pcpu_alloc+0x6ba/0x73b
Mar  3 00:16:09 werner kernel:  [<c10b8e9e>] ? get_slab+0x8/0x50
Mar  3 00:16:09 werner kernel:  [<c1b7242d>] ? neigh_parms_alloc+0x55/0xd1
Mar  3 00:16:09 werner kernel:  [<c10bbe27>] __alloc_percpu+0xf/0x14
Mar  3 00:16:09 werner kernel:  [<c1bb20d3>] snmp_mib_init+0x22/0x5a
Mar  3 00:16:09 werner kernel:  [<ff1255af>] ipv6_add_dev+0x191/0x30b [ipv6]
Mar  3 00:16:09 werner kernel:  [<fd65c000>] ? inet6_init+0x0/0x2a2 [ipv6]
Mar  3 00:16:09 werner kernel:  [<fd65c2ec>] addrconf_init+0x3b/0x11b [ipv6]
Mar  3 00:16:09 werner kernel:  [<fd65c195>] inet6_init+0x195/0x2a2 [ipv6]
Mar  3 00:16:09 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Mar  3 00:16:09 werner kernel:  [<c10647ec>] sys_init_module+0xac/0x1e0
Mar  3 00:16:09 werner kernel:  [<c1c6b28c>] syscall_call+0x7/0xb
Mar  3 00:16:21 werner kdm_greet[5357]: Can't open default user face
Mar  3 00:17:58 werner named[5941]: /etc/named.conf:3: option 'multiple-cnames' is obsolete
Mar  3 00:17:58 werner kernel: PERCPU: allocation failed, size=3D2048 align=3D8, failed to allocate new chunk
Mar  3 00:17:58 werner kernel: Pid: 5946, comm: modprobe Tainted: G         C 2.6.33-git7 #1
Mar  3 00:17:58 werner kernel: Call Trace:
Mar  3 00:17:58 werner kernel:  [<c1c68aa9>] ? printk+0x14/0x16
Mar  3 00:17:58 werner kernel:  [<c10bbd83>] pcpu_alloc+0x6ba/0x73b
Mar  3 00:17:58 werner kernel:  [<c10b8e9e>] ? get_slab+0x8/0x50
Mar  3 00:17:58 werner kernel:  [<c1b7242d>] ? neigh_parms_alloc+0x55/0xd1
Mar  3 00:17:58 werner kernel:  [<c10bbe27>] __alloc_percpu+0xf/0x14
Mar  3 00:17:58 werner kernel:  [<c1bb20d3>] snmp_mib_init+0x22/0x5a
Mar  3 00:17:58 werner kernel:  [<ff1255af>] ipv6_add_dev+0x191/0x30b [ipv6]
Mar  3 00:17:58 werner kernel:  [<f95ba000>] ? inet6_init+0x0/0x2a2 [ipv6]
Mar  3 00:17:58 werner kernel:  [<f95ba2ec>] addrconf_init+0x3b/0x11b [ipv6]
Mar  3 00:17:58 werner kernel:  [<f95ba195>] inet6_init+0x195/0x2a2 [ipv6]
Mar  3 00:17:58 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Mar  3 00:17:58 werner kernel:  [<c10647ec>] sys_init_module+0xac/0x1e0
Mar  3 00:17:58 werner kernel:  [<c1c6b28c>] syscall_call+0x7/0xb
Mar  3 00:18:21 werner kernel: PERCPU: allocation failed, size=3D2048 align=3D8, failed to allocate new chunk
Mar  3 00:18:21 werner kernel: Pid: 6081, comm: modprobe Tainted: G         C 2.6.33-git7 #1
Mar  3 00:18:21 werner kernel: Call Trace:
Mar  3 00:18:21 werner kernel:  [<c1c68aa9>] ? printk+0x14/0x16
Mar  3 00:18:21 werner kernel:  [<c10bbd83>] pcpu_alloc+0x6ba/0x73b
Mar  3 00:18:21 werner kernel:  [<c10b8e9e>] ? get_slab+0x8/0x50
Mar  3 00:18:21 werner kernel:  [<c1b7242d>] ? neigh_parms_alloc+0x55/0xd1
Mar  3 00:18:21 werner kernel:  [<c10bbe27>] __alloc_percpu+0xf/0x14
Mar  3 00:18:21 werner kernel:  [<c1bb20d3>] snmp_mib_init+0x22/0x5a
Mar  3 00:18:21 werner kernel:  [<ff22d5af>] ipv6_add_dev+0x191/0x30b [ipv6]
Mar  3 00:18:21 werner kernel:  [<f95db000>] ? inet6_init+0x0/0x2a2 [ipv6]
Mar  3 00:18:21 werner kernel:  [<f95db2ec>] addrconf_init+0x3b/0x11b [ipv6]
Mar  3 00:18:21 werner kernel:  [<f95db195>] inet6_init+0x195/0x2a2 [ipv6]
Mar  3 00:18:21 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Mar  3 00:18:21 werner kernel:  [<c10647ec>] sys_init_module+0xac/0x1e0
Mar  3 00:18:21 werner kernel:  [<c1c6b28c>] syscall_call+0x7/0xb
Mar  3 00:18:21 werner kernel: BUG: unable to handle kernel paging request at ff1498d4
Mar  3 00:18:21 werner kernel: IP: [<c1b682f0>] unregister_pernet_operations+0x21/0x93
Mar  3 00:18:21 werner kernel: *pde =3D 36534067 *pte =3D 00000000 
Mar  3 00:18:21 werner kernel: Oops: 0002 [#1] PREEMPT SMP 
Mar  3 00:18:21 werner kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/boot_vga
Mar  3 00:18:21 werner kernel: Modules linked in: ipv6(+) bnep rfcomm hidp l2cap bluetooth snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device rt2860sta(C) uvcvideo usbvideo lp snd_hda_codec_analog rtc_cmos rtc_core rtc_lib tpm_tis snd_hda_intel tpm tpm_bios rtl8187 snd_hda_codec mac80211 snd_hwdep led_class 8139too snd_pcm cfg80211 snd_timer k8temp hwmon rfkill snd soundcore snd_page_alloc i2c_nforce2 forcedeth
Mar  3 00:18:21 werner kernel: 
Mar  3 00:18:21 werner kernel: Pid: 6081, comm: modprobe Tainted: G         C 2.6.33-git7 #1 M2N-VM DH/System Product Name
Mar  3 00:18:21 werner kernel: EIP: 0060:[<c1b682f0>] EFLAGS: 00010246 CPU: 0
Mar  3 00:18:21 werner kernel: EIP is at unregister_pernet_operations+0x21/0x93
Mar  3 00:18:21 werner kernel: EAX: ff1498d4 EBX: ff251850 ECX: f5af1f58 EDX: ff2518d4
Mar  3 00:18:21 werner kernel: ESI: ff251850 EDI: f95db000 EBP: f5af1f6c ESP: f5af1f58
Mar  3 00:18:21 werner kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Mar  3 00:18:21 werner kernel: Process modprobe (pid: 6081, ti=3Df5af0000 task=3Df5b11220 task.ti=3Df5af0000)
Mar  3 00:18:21 werner kernel: Stack:
Mar  3 00:18:21 werner kernel:  f5af1f58 f5af1f58 ff251850 00000000 f95db000 f5af1f78 c1b683b6 fffffff4
Mar  3 00:18:21 werner kernel: <0> f5af1f84 f95db257 ff253834 f5af1f9c c1001143 00000000 ff253834 00000000
Mar  3 00:18:21 werner kernel: <0> 0805e1a8 f5af1fac c10647ec b753d008 0805e158 f5af0000 c1c6b28c b753d008
Mar  3 00:18:21 werner kernel: Call Trace:
Mar  3 00:18:21 werner kernel:  [<f95db000>] ? inet6_init+0x0/0x2a2 [ipv6]
Mar  3 00:18:21 werner kernel:  [<c1b683b6>] ? unregister_pernet_subsys+0x1c/0x29
Mar  3 00:18:21 werner kernel:  [<f95db257>] ? inet6_init+0x257/0x2a2 [ipv6]
Mar  3 00:18:21 werner kernel:  [<c1001143>] ? do_one_initcall+0x51/0x13f
Mar  3 00:18:21 werner kernel:  [<c10647ec>] ? sys_init_module+0xac/0x1e0
Mar  3 00:18:21 werner kernel:  [<c1c6b28c>] ? syscall_call+0x7/0xb
Mar  3 00:18:21 werner kernel: Code: c2 75 e5 e8 13 f2 50 ff eb 97 55 89 e5 57 56 53 83 ec 08 e8 f3 b5 49 ff 89 c6 8d 4d ec 89 4d ec 89 4d f0 8b 10 8b 40 04 89 42 04 <89> 10 c7 06 00 01 10 00 c7 46 04 00 02 20 00 a1 d8 d0 10 c2 8d 
Mar  3 00:18:21 werner kernel: EIP: [<c1b682f0>] unregister_pernet_operations+0x21/0x93 SS:ESP 0068:f5af1f58
Mar  3 00:18:21 werner kernel: CR2: 00000000ff1498d4
Mar  3 00:18:21 werner kernel: ---[ end trace b3b9d920c788a99a ]---

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D lsmod.txt =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Module                  Size  Used by
ipv6                  268954  1 
bnep                    7544  2 
rfcomm                 26682  3 
hidp                    9449  2 
l2cap                  26774  14 bnep,rfcomm,hidp
bluetooth              41555  6 bnep,rfcomm,hidp,l2cap
snd_usb_audio          55817  0 
snd_usb_lib            12204  1 snd_usb_audio
snd_rawmidi            13291  1 snd_usb_lib
snd_seq_device          3889  1 snd_rawmidi
rt2860sta             424976  0 
uvcvideo               45875  0 
usbvideo               17963  0 
lp                      6304  0 
snd_hda_codec_analog    47338  1 
rtc_cmos                6794  0 
rtc_core               10275  1 rtc_cmos
rtc_lib                 1326  1 rtc_core
tpm_tis                 5568  0 
snd_hda_intel          16024  0 
tpm                     8685  1 tpm_tis
tpm_bios                3849  1 tpm
rtl8187                43242  0 
snd_hda_codec          48296  2 snd_hda_codec_analog,snd_hda_intel
mac80211              133994  1 rtl8187
snd_hwdep               4342  2 snd_usb_audio,snd_hda_codec
led_class               1833  1 rtl8187
8139too                15200  0 
snd_pcm                49801  3 snd_usb_audio,snd_hda_intel,snd_hda_codec
cfg80211               94773  2 rtl8187,mac80211
snd_timer              13278  1 snd_pcm
k8temp                  2499  0 
hwmon                   1017  1 k8temp
rfkill                 10920  2 bluetooth,cfg80211
snd                    37321  10 snd_usb_audio,snd_usb_lib,snd_rawmidi,snd_seq_device,snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore               4099  1 snd
snd_page_alloc          5221  2 snd_hda_intel,snd_pcm
i2c_nforce2             4572  0 
forcedeth              42492  0 

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  free.txt =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
             total       used       free     shared    buffers     cached
Mem:       2837788     501628    2336160          0      31052     263524
-/+ buffers/cache:     207052    2630736
Swap:            0          0          0

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  lspci.txt =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev a2)
00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio (rev a2)
00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2)
00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
00:08.1 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0c.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0d.0 VGA compatible controller: nVidia Corporation GeForce 6100 nForce 430 (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:08.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 03)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 03)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D dmesg =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Linux version 2.6.33-git7 (root@werner) (gcc version 4.3.3 (GCC) ) #1 SMP PREEMPT Tue Mar 2 06:15:19 GFT 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000afee0000 (usable)
 BIOS-e820: 00000000afee0000 - 00000000afee3000 (ACPI NVS)
 BIOS-e820: 00000000afee3000 - 00000000afef0000 (ACPI data)
 BIOS-e820: 00000000afef0000 - 00000000aff00000 (reserved)
 BIOS-e820: 00000000b0000000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.4 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) =3D=3D> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn =3D 0xafee0 max_arch_pfn =3D 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 base 0080000000 mask FFC0000000 write-back
  2 base 0100000000 mask FF00000000 write-back
  3 base 0200000000 mask FFC0000000 write-back
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000240000000 aka 9216M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000c0000000 - 0000000100000000 (usable) =3D=3D> (reserved)
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009f000 (usable)
 modified: 000000000009f000 - 00000000000a0000 (reserved)
 modified: 00000000000f0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 00000000afee0000 (usable)
 modified: 00000000afee0000 - 00000000afee3000 (ACPI NVS)
 modified: 00000000afee3000 - 00000000afef0000 (ACPI data)
 modified: 00000000afef0000 - 00000000aff00000 (reserved)
 modified: 00000000b0000000 - 00000000c0000000 (reserved)
 modified: 00000000f0000000 - 00000000f4000000 (reserved)
 modified: 00000000fec00000 - 0000000100000000 (reserved)
 modified: 0000000100000000 - 0000000240000000 (usable)
initial memory mapped : 0 - 02800000
found SMP MP-table at [c00f5440] f5440
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 15000-1a000
ACPI: RSDP 000f6fd0 00024 (v02 Nvidia)
ACPI: XSDT afee30c0 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: FACP afeeb840 000F4 (v03 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: DSDT afee3240 08581 (v01 NVIDIA ASUSACPI 00001000 MSFT 03000000)
ACPI: FACS afee0000 00040
ACPI: MCFG afeeba40 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: APIC afeeb980 0007C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
1926MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
  node 0 low ram: 00000000 - 377fe000
  node 0 bootmap 00016000 - 0001cf00
(13 early reservations) =3D=3D> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [0000001000 - 0000002000]
  #2 [0001000000 - 00024fc3b0]    TEXT DATA BSS =3D=3D> [0001000000 - 00024fc3b0]
  #3 [00024fd000 - 000250714d]              BRK =3D=3D> [00024fd000 - 000250714d]
  #4 [00000f5450 - 0000100000]    BIOS reserved =3D=3D> [00000f5450 - 0000100000]
  #5 [00000f5440 - 00000f5450]     MP-table mpf =3D=3D> [00000f5440 - 00000f5450]
  #6 [000009f000 - 00000f1400]    BIOS reserved =3D=3D> [000009f000 - 00000f1400]
  #7 [00000f1554 - 00000f5440]    BIOS reserved =3D=3D> [00000f1554 - 00000f5440]
  #8 [00000f1400 - 00000f1554]     MP-table mpc =3D=3D> [00000f1400 - 00000f1554]
  #9 [0000010000 - 0000011000]       TRAMPOLINE =3D=3D> [0000010000 - 0000011000]
  #10 [0000011000 - 0000015000]      ACPI WAKEUP =3D=3D> [0000011000 - 0000015000]
  #11 [0000015000 - 0000016000]          PGTABLE =3D=3D> [0000015000 - 0000016000]
  #12 [0000016000 - 000001d000]          BOOTMAP =3D=3D> [0000016000 - 000001d000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x000afee0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000afee0
On node 0 totalpages: 720495
free_area_init_node: node 0, pgdat c2112c60, node_mem_map c2509200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 3854 pages used for memmap
  HighMem zone: 489428 pages, LIFO batch:31
Using APIC driver default
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
SFI: Simple Firmware Interface v0.7 http://simplefirmware.org
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 Version 17 at 0xFEC00000.
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at c0000000 (gap: c0000000:30000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 14 pages/cpu @c3c00000 s35876 r0 d21468 u2097152
pcpu-alloc: s35876 r0 d21468 u2097152 alloc=3D1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 714865
Kernel command line: BOOT_IMAGE=3D2633git7 ro root=3D801 4 root=3D/dev/sda1 devfs=3Dnomount noapic nolapic acpi=3Dht rootwait
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:000afee0)
Memory: 2835992k/2882432k available (12721k kernel code, 45040k reserved, 4853k data, 848k init, 1973128k highmem)
virtual kernel memory layout:
    fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc212a000 - 0xc21fe000   ( 848 kB)
      .data : 0xc1c6c67d - 0xc2129aa8   (4853 kB)
      .text : 0xc1000000 - 0xc1c6c67d   (12721 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1
Hierarchical RCU implementation.
NR_IRQS:1280
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 2511.141 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5022.28 BogoMIPS (lpj=3D2511141)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: 
no APIC, boot with the "lapic" boot parameter to force-enable it.
no hardware sampling interrupt available.
AMD PMU driver.
.. version:                0
.. bit width:              48
.. generic registers:      4
.. value mask:             0000ffffffffffff
.. max period:             00007fffffffffff
.. fixed-purpose events:   0
.. event mask:             000000000000000f
Checking 'hlt' instruction... OK.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (5022.28 BogoMIPS).
devtmpfs: initialized
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  7112.000 MB/sec
xor: using function: pIII_sse (7112.000 MB/sec)
regulator: core version 0.5
NET: Registered protocol family 16
EISA bus registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int32x1    640 MB/s
raid6: int32x2    863 MB/s
raid6: int32x4    710 MB/s
raid6: int32x8    542 MB/s
raid6: mmxx1     2027 MB/s
raid6: mmxx2     3722 MB/s
raid6: sse1x1    2019 MB/s
raid6: sse1x2    3316 MB/s
raid6: sse2x1    3359 MB/s
raid6: sse2x2    4324 MB/s
raid6: using algorithm sse2x2 (4324 MB/s)
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:01.1: reg 10: [io  0xfc00-0xfc3f]
pci 0000:00:01.1: reg 20: [io  0x1c00-0x1c3f]
pci 0000:00:01.1: reg 24: [io  0x1c40-0x1c7f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: reg 10: [mem 0xfe02f000-0xfe02ffff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10: [mem 0xfe02e000-0xfe02e0ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:05.0: reg 10: [mem 0xfe024000-0xfe027fff]
pci 0000:00:05.0: PME# supported from D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
pci 0000:00:07.0: reg 10: [mem 0xfe02d000-0xfe02dfff]
pci 0000:00:07.0: reg 14: [io  0xec00-0xec07]
pci 0000:00:07.0: supports D1 D2
pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:08.0: reg 10: [io  0x09f0-0x09f7]
pci 0000:00:08.0: reg 14: [io  0x0bf0-0x0bf3]
pci 0000:00:08.0: reg 18: [io  0x0970-0x0977]
pci 0000:00:08.0: reg 1c: [io  0x0b70-0x0b73]
pci 0000:00:08.0: reg 20: [io  0xd800-0xd80f]
pci 0000:00:08.0: reg 24: [mem 0xfe02c000-0xfe02cfff]
pci 0000:00:08.1: reg 10: [io  0x09e0-0x09e7]
pci 0000:00:08.1: reg 14: [io  0x0be0-0x0be3]
pci 0000:00:08.1: reg 18: [io  0x0960-0x0967]
pci 0000:00:08.1: reg 1c: [io  0x0b60-0x0b63]
pci 0000:00:08.1: reg 20: [io  0xc400-0xc40f]
pci 0000:00:08.1: reg 24: [mem 0xfe02b000-0xfe02bfff]
pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: reg 10: [mem 0xfb000000-0xfbffffff]
pci 0000:00:0d.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:00:0d.0: reg 1c: [mem 0xfc000000-0xfcffffff 64bit]
pci 0000:00:0d.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:08.0: reg 10: [io  0xbc00-0xbcff]
pci 0000:01:08.0: reg 14: [mem 0x00000000-0x000000ff]
pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:00:04.0: PCI bridge to [bus 01-01] (subtractive decode)
pci 0000:00:04.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:04.0:   bridge window [mem 0xfd800000-0xfd8fffff]
pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff pref]
pci 0000:00:04.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:04.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
pci 0000:00:09.0: PCI bridge to [bus 02-02]
pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:00:09.0:   bridge window [mem 0xfdd00000-0xfddfffff 64bit pref]
pci 0000:03:00.0: reg 24: [mem 0xfdcfe000-0xfdcfffff]
pci 0000:03:00.0: reg 30: [mem 0xfdce0000-0xfdceffff pref]
pci 0000:03:00.0: PME# supported from D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.1: reg 10: [io  0x9c00-0x9c07]
pci 0000:03:00.1: reg 14: [io  0x9800-0x9803]
pci 0000:03:00.1: reg 18: [io  0x9400-0x9407]
pci 0000:03:00.1: reg 1c: [io  0x9000-0x9003]
pci 0000:03:00.1: reg 20: [io  0x8c00-0x8c0f]
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=3Dforce'
pci 0000:00:0b.0: PCI bridge to [bus 03-03]
pci 0000:00:0b.0:   bridge window [io  0x8000-0x9fff]
pci 0000:00:0b.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:00:0b.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
pci 0000:00:0c.0: PCI bridge to [bus 04-04]
pci 0000:00:0c.0:   bridge window [io  0x7000-0x7fff]
pci 0000:00:0c.0:   bridge window [mem 0xfda00000-0xfdafffff]
pci 0000:00:0c.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
vgaarb: device added: PCI:0000:00:0d.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
pci 0000:00:00.0: default IRQ router [10de:03ea]
PCI: pci_cache_line_size set to 64 bytes
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource pit
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
CacheFiles: Loaded
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fc6b0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc6e0, dseg 0xf0000
PnPBIOS: 13 nodes reported by PnP BIOS; 13 recorded by driver
system 00:07: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:07: [mem 0xfffe0000-0xffffffff] has been reserved
system 00:07: [mem 0xfec00000-0xfec0ffff] has been reserved
system 00:07: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:07: [mem 0xfefff000-0xfefff3ff] has been reserved
system 00:07: [mem 0x00100000-0x00ffffff] could not be reserved
system 00:08: [mem 0x000f0000-0x000f3fff] could not be reserved
system 00:08: [mem 0x000f4000-0x000f7fff] could not be reserved
system 00:08: [mem 0x000f8000-0x000fffff] could not be reserved
system 00:08: [mem 0x000d2800-0x000d3fff] has been reserved
Switching to clocksource acpi_pm
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:0d.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
pci 0000:01:08.0: BAR 6: assigned [mem 0xfdf00000-0xfdf0ffff pref]
pci 0000:01:08.0: BAR 1: assigned [mem 0xfd800000-0xfd8000ff]
pci 0000:01:08.0: BAR 1: error updating (0xfd800000 !=3D 0xf9800000)
pci 0000:01:08.0: BAR 1: set to [mem 0xfd800000-0xfd8000ff] (PCI address [0xfd800000-0xfd8000ff]
pci 0000:00:04.0: PCI bridge to [bus 01-01]
pci 0000:00:04.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:04.0:   bridge window [mem 0xfd800000-0xfd8fffff]
pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff pref]
pci 0000:00:09.0: PCI bridge to [bus 02-02]
pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:00:09.0:   bridge window [mem 0xfdd00000-0xfddfffff 64bit pref]
pci 0000:00:0b.0: PCI bridge to [bus 03-03]
pci 0000:00:0b.0:   bridge window [io  0x8000-0x9fff]
pci 0000:00:0b.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
pci 0000:00:0b.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
pci 0000:00:0c.0: PCI bridge to [bus 04-04]
pci 0000:00:0c.0:   bridge window [io  0x7000-0x7fff]
pci 0000:00:0c.0:   bridge window [mem 0xfda00000-0xfdafffff]
pci 0000:00:0c.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:01: resource 1 [mem 0xfd800000-0xfd8fffff]
pci_bus 0000:01: resource 2 [mem 0xfdf00000-0xfdffffff pref]
pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
pci_bus 0000:01: resource 5 [mem 0x00000000-0xffffffff]
pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
pci_bus 0000:02: resource 1 [mem 0xfde00000-0xfdefffff]
pci_bus 0000:02: resource 2 [mem 0xfdd00000-0xfddfffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x8000-0x9fff]
pci_bus 0000:03: resource 1 [mem 0xfdc00000-0xfdcfffff]
pci_bus 0000:03: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x7000-0x7fff]
pci_bus 0000:04: resource 1 [mem 0xfda00000-0xfdafffff]
pci_bus 0000:04: resource 2 [mem 0xfd900000-0xfd9fffff 64bit pref]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:0d.0: Boot video device
PCI: CLS 32 bytes, default 64
Machine check injector initialized
elanfreq: error: no Elan processor found!
cpufreq-nforce2: No nForce2 chipset.
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
scx200: NatSemi SCx200 Driver
microcode: microcode: CPU0: AMD CPU family 0xf not supported
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=3D2000 audit(1267575305.267:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
DLM (built Mar  2 2010 05:01:14) installed
squashfs: version 4.0 (2009/01/31) Phillip Lougher
FS-Cache: Netfs 'nfs' registered for caching
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/W].
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
JFFS2 version 2.2. (NAND) (SUMMARY)  =C2=A9 2001-2006 Red Hat, Inc.
ROMFS MTD (C) 2007 Red Hat, Inc.
QNX4 filesystem 0.2.3 registered.
fuse init (API version 7.13)
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
BeFS version: 0.9.3
OCFS2 1.5.0
ocfs2: Registered cluster interface o2cb
ocfs2: Registered cluster interface user
OCFS2 Node Manager 1.5.0
OCFS2 DLM 1.5.0
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
Btrfs loaded
GFS2 (built Mar  2 2010 05:02:48) installed
msgmni has been set to 1687
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:09.0: setting latency timer to 64
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0c.0: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
cpcihp_generic: not configured, disabling.
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
mdacon: MDA with 8K of memory detected.
Console: switching consoles 13-16 to MDA-2
nvidiafb: Device ID: 10de03d0 
nvidiafb: CRTC0 analog found
nvidiafb: CRTC1 analog not found
i2c i2c-0: unable to read EDID block.
i2c i2c-0: unable to read EDID block.
i2c i2c-0: unable to read EDID block.
nvidiafb: EDID found from BUS2
nvidiafb: CRTC 0 appears to have a CRT attached
nvidiafb: Using CRT on CRTC 0
nvidiafb: MTRR set to ON
fbcon: NV3d (fb0) is primary device
Console: switching to colour frame buffer device 210x65
nvidiafb: PCI nVidia NV3d framebuffer (64MB @ 0xE0000000)
VIA Graphics Intergration Chipset framebuffer 2.4 initializing
vmlfb: initializing
Could not find Carillo Ranch MCH device.
no IO addresses supplied
hgafb: HGA card not detected.
hgafb: probe of hgafb.0 failed with error -22
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
vesafb: cannot reserve video memory at 0xe0000000
vesafb: framebuffer at 0xe0000000, mapped to 0xfd680000, using 3072k, total 262144k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D1
vesafb: protected mode interface info at c000:d030
vesafb: pmi: set display start =3D c00cd066, set palette =3D c00cd0d0
vesafb: pmi: ports =3D 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
fb1: VESA VGA frame buffer device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb2: VGA16 VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Non-volatile memory driver v1.3
toshiba: not a supported Toshiba laptop
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to userspace modesetting.
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
parport_pc 00:0e: reported by Plug and Play BIOS
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
MM: desc_per_page =3D 128
nbd: registered device at major 43
usbcore: registered new interface driver ub
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
Phantom Linux Driver, version n0.9.8, init OK
Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
c2port c2port0: C2 port uc added
c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
Driver for timberdale has been successfully registered.
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:06.0: UDMA133 controller
amd74xx 0000:00:06.0: IDE controller (0x10de:0x03ec rev 0xa2)
amd74xx 0000:00:06.0: IDE port disabled
amd74xx 0000:00:06.0: BIOS didn't set cable bits correctly. Enabling workaround.
amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007
Probing IDE interface ide0...
hda: Hitachi HDT725050VLAT80, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/133 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
jmicron 0000:03:00.1: IDE controller (0x197b:0x2363 rev 0x03)
JMicron IDE 0000:03:00.1: enabling device (0000 -> 0001)
JMicron IDE 0000:03:00.1: can't find IRQ for PCI INT B; please try using pci=3Dbiosirq
jmicron 0000:03:00.1: bad irq (0): will probe later
JMicron IDE 0000:03:00.1: setting latency timer to 64
    ide1: BM-DMA at 0x8c00-0x8c07
    ide2: BM-DMA at 0x8c08-0x8c0f
Probing IDE interface ide1...
Probing IDE interface ide2...
ide1: disabled, no IRQ
ide1: failed to initialize IDE interface
ide1: disabling port
ide2: disabled, no IRQ
ide2: failed to initialize IDE interface
ide2: disabling port
JMicron IDE: probe of 0000:03:00.1 failed with error -1
ide_generic: please use "probe_mask=3D0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 976773168 sectors (500107 MB) w/7372KiB Cache, CHS=3D60801/255/63
hda: cache flushes supported
 hda: hda2 hda3 hda4
ide-cd driver 5.00
Loading iSCSI transport class v2.0-870.
rdac: device handler registered
hp_sw: device handler registered
emc: device handler registered
alua: device handler registered
fnic: Cisco FCoE HBA Driver, ver 1.4.0.98
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[24702]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
NCR53c406a: no available ports found
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase=3D and irq=3D options
QLogic Fibre Channel HBA Driver: 8.03.02-k1
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.3.9
Copyright(c) 2004-2009 Emulex.  All rights reserved.
Brocade BFA FC/FCOE SCSI driver - version: 2.0.0.0
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
       with "disable_clustering=3D1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.04.17.1-rc1 Thu. Oct. 29, 11:41:51 PST 2009
mpt2sas version 04.100.01.00 loaded
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.013.
ppa: Version 2.07 (for Linux 2.4.x)
imm: Version 2.05 (for Linux 2.4.0)
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.3 (June 10, 2009)
RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
stex: Promise SuperTrak EX Driver version: 4.6.0000.4
cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
iscsi: registered transport (cxgb3i)
Broadcom NetXtreme II iSCSI Driver bnx2i v2.1.0 (Dec 06, 2009)
iscsi: registered transport (bnx2i)
iscsi: registered transport (be2iscsi)
st: Version 20081215, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
SCSI Media Changer driver v0.25 
osd: LOADED open-osd 0.2.0
ahci 0000:03:00.0: version 3.0
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
ahci 0000:03:00.0: setting latency timer to 64
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfdcfe000 port 0xfdcfe100 irq 5
ata2: SATA max UDMA/133 abar m8192@0xfdcfe000 port 0xfdcfe180 irq 5
sata_nv 0000:00:08.0: version 3.5
sata_nv 0000:00:08.0: setting latency timer to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 10
ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq 10
sata_nv 0000:00:08.1: setting latency timer to 64
scsi6 : sata_nv
scsi7 : sata_nv
ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq 11
ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq 11
pata_jmicron 0000:03:00.1: BAR 0: can't reserve [io  0x9c00-0x9c07]
pata_jmicron 0000:03:00.1: failed to request/iomap BARs for port 0 (errno=3D-16)
pata_jmicron 0000:03:00.1: BAR 2: can't reserve [io  0x9400-0x9407]
pata_jmicron 0000:03:00.1: failed to request/iomap BARs for port 1 (errno=3D-16)
pata_jmicron 0000:03:00.1: no available native port
Error: Driver 'pata_platform' is already registered, aborting...
pata_acpi 0000:03:00.1: BAR 0: can't reserve [io  0x9c00-0x9c07]
pata_acpi 0000:03:00.1: failed to request/iomap BARs for port 0 (errno=3D-16)
pata_acpi 0000:03:00.1: BAR 2: can't reserve [io  0x9400-0x9407]
pata_acpi 0000:03:00.1: failed to request/iomap BARs for port 1 (errno=3D-16)
pata_acpi 0000:03:00.1: no available native port
SSFDC read-only Flash Translation layer
mtdoops: mtd device (mtddev=3Dname/number) must be supplied
L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
device id =3D 2440
device id =3D 2480
device id =3D 24c0
device id =3D 24d0
device id =3D 25a1
device id =3D 2670
physmap-flash.0: failed to claim resource 0
SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
Could not find PAR responsible for SC520CDP Flash Bank #0
Trying default address 0x8400000
Could not find PAR responsible for SC520CDP Flash Bank #1
Trying default address 0x8c00000
Could not find PAR responsible for SC520CDP DIL Flash
Trying default address 0x9400000
SC520 CDP flash device: 0x800000 at 0x8400000
Failed to ioremap_nocache
NetSc520 flash device: 0x100000 at 0x200000
Failed to ioremap_nocache
Failed to ioremap_nocache
scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
SNAPGEAR: failed to ioremap() BOOTCS
Generic platform RAM MTD, (c) 2004 Simtec Electronics
No recognised DiskOnChip devices found
slram: not enough parameters.
Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
pmc551: not detected
ftl_cs: FTL header not found.
No valid DiskOnChip devices found
NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 8MiB 1,8V 8-bit)
flash size: 8 MiB
page size: 512 bytes
OOB area size: 16 bytes
sector size: 8 KiB
pages number: 16384
pages per sector: 16
bus width: 8
bits in sector size: 13
bits in page size: 9
bits in OOB size: 4
flash size with OOB: 8448 KiB
page address bytes: 3
sector address bytes: 2
options: 0x62
Scanning device for bad blocks
Creating 1 MTD partitions on "NAND 8MiB 1,8V 8-bit":
0x000000000000-0x000000800000 : "NAND simulator partition 0"
ftl_cs: FTL header not found.
usbcore: registered new interface driver alauda
onenand_wait: timeout! ctrl=3D0x0000 intr=3D0x0000
OneNAND Manufacturer: Samsung (0xec)
OneNAND 16MB 1.8V 16-bit (0x04)
OneNAND version =3D 0x001e
Lock scheme is Continuous Lock
Scanning device for bad blocks
Creating 1 MTD partitions on "OneNAND simulator":
0x000000000000-0x000001000000 : "OneNAND simulator partition"
ftl_cs: FTL header not found.
Fixed MDIO Bus: probed
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Broadcom NetXtreme II CNIC Driver cnic v2.1.0 (Oct 10, 2009)
D-Link DE-620 pocket adapter io 0x378, which is busy.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
PPPoL2TP kernel driver, V1.0
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=3D256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
DE600: port 0x378 busy
atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
I2O subsystem v1.325
i2o: max drivers =3D 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.14
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.14
Fusion MPT FC Host driver 3.04.14
Fusion MPT SAS Host driver 3.04.14
Fusion MPT misc device (ioctl) driver 3.04.14
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=3D10,220)
Fusion MPT LAN driver 3.04.14
video1394: Installed video1394 module
ieee1394: raw1394: /dev/raw1394 device initialized
Intel ISA PCIC probe: not found.
Databook TCIC-2 PCMCIA probe: not found.
aoe: AoE v47 initialised.
paride: aten registered as protocol 0
paride: bpck registered as protocol 1
paride: comm registered as protocol 2
paride: dstr registered as protocol 3
paride: k951 registered as protocol 4
paride: k971 registered as protocol 5
paride: epat registered as protocol 6
paride: epia registered as protocol 7
paride: frpw registered as protocol 8
paride: friq registered as protocol 9
paride: fit2 registered as protocol 10
paride: fit3 registered as protocol 11
paride: on20 registered as protocol 12
paride: on26 registered as protocol 13
paride: ktti registered as protocol 14
bpck6: BACKPACK Protocol Driver V2.0.2
bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. USA
paride: bpck6 registered as protocol 15
pd: pd version 1.05, major 45, cluster 64, nice 0
pda: Autoprobe failed
pd: no valid drive found
pcd: pcd version 1.07, major 46, nice 0
pcd0: Autoprobe failed
pcd: No CD-ROM drive found
pf: pf version 1.04, major 47, cluster 64, nice 0
pf: No ATAPI disk detected
pt: pt version 1.04, major 96
pt0: Autoprobe failed
pt: No ATAPI tape drive detected
pg: pg version 1.02, major 97
pga: Autoprobe failed
pg: No ATAPI device detected
usbcore: registered new interface driver hwa-rc
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 32 is not supported
ehci_hcd 0000:00:02.1: irq 10, io mem 0xfe02e000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.33-git7 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
driver isp1362-hcd, 2005-04-04
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 5, io mem 0xfe02f000
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.33-git7 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
sl811: driver sl811-hcd, 19 May 2005
r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
usbcore: registered new interface driver hwa-hc
usbcore: registered new interface driver wusb-cbaf
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
usbcore: registered new interface driver cdc_wdm
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver ums-alauda
usbcore: registered new interface driver ums-cypress
usbcore: registered new interface driver ums-datafab
usbcore: registered new interface driver ums-freecom
usbcore: registered new interface driver ums-isd200
usbcore: registered new interface driver ums-jumpshot
usbcore: registered new interface driver ums-karma
usbcore: registered new interface driver ums-onetouch
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver ums-sddr55
usbcore: registered new interface driver ums-usbat
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: PARKBD AT adapter on parport0
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver appletouch
usbcore: registered new interface driver bcm5974
inport.c: Didn't find InPort mouse at 0x23c
logibm.c: Didn't find Logitech busmouse at 0x23c
usbcore: registered new interface driver usb_acecad
acecad: v3.2:USB Acecad Flair tablet driver
usbcore: registered new interface driver aiptek
aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006
usbcore: registered new interface driver kbtab
kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
usbcore: registered new interface driver wacom
wacom: v1.52:USB Wacom tablet driver
input: PC Speaker as /devices/platform/pcspkr/input/input0
i2c /dev entries driver
Linux video capture interface: v2.00
usbcore: registered new interface driver dabusb
dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: faulty personality registered for level -5
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.1.1 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
EDAC MC: Ver: 2.1.0 Mar  2 2010
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 7
Cannot allocate resource for EISA slot 8
EISA: Detected 0 cards.
cpuidle: using governor ladder
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies, Inc.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
dell-wmi: No known WMI GUID found
This machine doesn't have MSI-hotkeys through WMI
oprofile: using timer interrupt.
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 33
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
lib80211_crypt: registered algorithm 'WEP'
lib80211_crypt: registered algorithm 'CCMP'
lib80211_crypt: registered algorithm 'TKIP'
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ processors (1 cpu cores) (version 2.20.00)
[Firmware Bug]: powernow-k8: No PSB or ACPI _PSS objects
Using IPI No-Shortcut mode
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: SAMSUNG HD753LJ, 1AA01104, max UDMA7
ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:
sd 4:0:0:0: Attached scsi generic sg0 type 0
 sda1 sda2 sda3 sda4
sd 4:0:0:0: [sda] Attached SCSI disk
usb 1-5: new high speed USB device using ehci_hcd and address 4
usb 1-5: New USB device found, idVendor=3D0bda, idProduct=3D8187
usb 1-5: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 1-5: Product: RTL8187_Wireless
usb 1-5: Manufacturer: Manufacturer_Realtek_RTL8187_
usb 1-5: SerialNumber: 0015AF2347F2
psmouse serio1: ID: 10 00 64
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-H66N, CB00, max UDMA/100
ata4.00: configured for UDMA/100
scsi 5:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H66N  CB00 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
sr 5:0:0:0: Attached scsi generic sg1 type 5
usb 2-2: new full speed USB device using ohci_hcd and address 2
usb 2-2: device descriptor read/64, error -62
ata6: SATA link down (SStatus 0 SControl 300)
usb 2-2: device descriptor read/64, error -62
usb 2-2: new full speed USB device using ohci_hcd and address 3
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input2
usb 2-2: device descriptor read/64, error -62
kAFS: Red Hat AFS client v0.1 registering.
raid6test: testing the 4-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q)  OK
raid6test: testing the 5-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P)  OK
raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P)  OK
raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P)  OK
raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q)  OK
raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q)  OK
raid6test: testing the 11-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D)  OK
raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D)  OK
raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D)  OK
raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D)  OK
raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D)  OK
raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D)  OK
raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P)  OK
raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D)  OK
raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D)  OK
raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D)  OK
raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D)  OK
raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D)  OK
raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D)  OK
raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P)  OK
raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D)  OK
raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D)  OK
raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D)  OK
raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D)  OK
raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D)  OK
raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D)  OK
raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P)  OK
raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)  OK
raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D)  OK
raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D)  OK
raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D)  OK
raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D)  OK
raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D)  OK
raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P)  OK
raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)  OK
raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D)  OK
raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D)  OK
raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D)  OK
raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D)  OK
raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P)  OK
raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)  OK
raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D)  OK
raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D)  OK
raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D)  OK
raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P)  OK
raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)  OK
raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D)  OK
raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D)  OK
raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P)  OK
raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)  OK
raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D)  OK
raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P)  OK
raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)  OK
raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P)  OK
raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)  OK
raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)  OK
raid6test: testing the 12-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D)  OK
raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D)  OK
raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D)  OK
raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D)  OK
raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D)  OK
raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D)  OK
raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D)  OK
raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)  OK
raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D)  OK
raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D)  OK
raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D)  OK
raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D)  OK
raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D)  OK
raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D)  OK
raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D)  OK
raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)  OK
raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D)  OK
raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D)  OK
raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D)  OK
raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D)  OK
raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D)  OK
raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D)  OK
raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D)  OK
raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)  OK
raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)  OK
raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D)  OK
raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D)  OK
raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D)  OK
raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D)  OK
raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D)  OK
raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D)  OK
raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)  OK
raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)  OK
raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D)  OK
raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D)  OK
raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D)  OK
raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D)  OK
raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D)  OK
raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)  OK
raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)  OK
raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D)  OK
raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D)  OK
raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D)  OK
raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D)  OK
raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)  OK
raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)  OK
raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D)  OK
raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D)  OK
raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D)  OK
raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)  OK
raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)  OK
raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D)  OK
raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D)  OK
raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)  OK
raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)  OK
raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D)  OK
raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)  OK
raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)  OK
raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)  OK
raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)  OK
raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q)  OK
raid6test: testing the 16-disk case...
raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D)  OK
raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D)  OK
raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D)  OK
raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D)  OK
raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D)  OK
raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D)  OK
raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D)  OK
raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D)  OK
raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D)  OK
raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)  OK
raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)  OK
raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)  OK
raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)  OK
raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(P)  OK
raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(Q)  OK
raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D)  OK
raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D)  OK
raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D)  OK
raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D)  OK
raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D)  OK
raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D)  OK
raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D)  OK
raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D)  OK
raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)  OK
raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)  OK
raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)  OK
raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)  OK
raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(P)  OK
raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(Q)  OK
raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D)  OK
raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D)  OK
raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D)  OK
raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D)  OK
raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D)  OK
raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D)  OK
raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D)  OK
raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)  OK
raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)  OK
raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)  OK
raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)  OK
raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(P)  OK
raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(Q)  OK
raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D)  OK
raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D)  OK
raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D)  OK
raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D)  OK
raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D)  OK
raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D)  OK
raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)  OK
raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)  OK
raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)  OK
raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)  OK
raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(P)  OK
raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(Q)  OK
raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D)  OK
raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D)  OK
raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D)  OK
raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D)  OK
raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D)  OK
raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)  OK
raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)  OK
raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)  OK
raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)  OK
raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(P)  OK
raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(Q)  OK
raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D)  OK
raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D)  OK
raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D)  OK
raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D)  OK
raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)  OK
raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)  OK
raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)  OK
raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)  OK
raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(P)  OK
raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(Q)  OK
raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D)  OK
raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D)  OK
raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D)  OK
raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)  OK
raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)  OK
raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)  OK
raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)  OK
raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(P)  OK
raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(Q)  OK
raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D)  OK
raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D)  OK
raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)  OK
raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)  OK
raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)  OK
raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)  OK
raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(P)  OK
raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(Q)  OK
raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D)  OK
raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)  OK
raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)  OK
raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)  OK
raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)  OK
raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(P)  OK
raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(Q)  OK
raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)  OK
raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)  OK
raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)  OK
raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)  OK
raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(P)  OK
raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(Q)  OK
raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D)  OK
raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D)  OK
raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D)  OK
raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(P)  OK
raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(Q)  OK
raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D)  OK
raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D)  OK
raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(P)  OK
raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(Q)  OK
raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D)  OK
raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(P)  OK
raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(Q)  OK
raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(P)  OK
raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(Q)  OK
raid6test: test_disks(14, 15): faila=3D 14(P)  failb=3D 15(Q)  OK
raid6test: 
raid6test: complete (257 tests, 0 failures)
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=3Dnoautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs (sda1): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
kjournald starting.  Commit interval 5 seconds
devtmpfs: mounted
Freeing unused kernel memory: 848k freed
usb 2-2: device descriptor read/64, error -62
usb 2-2: new full speed USB device using ohci_hcd and address 4
usb 2-2: device not accepting address 4, error -62
usb 2-2: new full speed USB device using ohci_hcd and address 5
usb 2-2: device not accepting address 5, error -62
hub 2-0:1.0: unable to enumerate USB device on port 2
usb 2-3: new full speed USB device using ohci_hcd and address 6
usb 2-3: New USB device found, idVendor=3D04e8, idProduct=3D326c
usb 2-3: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 2-3: Product: Samsung ML-2010
usb 2-3: Manufacturer: Samsung
usb 2-3: SerialNumber: 3A21BKCYC01812Z.
usblp0: USB Bidirectional printer dev 6 if 0 alt 0 proto 2 vid 0x04E8 pid 0x326C
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
forcedeth 0000:00:07.0: setting latency timer to 64
forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x50ef @ 1, addr 00:1d:60:19:59:cc
forcedeth 0000:00:07.0: highdma pwrctl mgmt gbit lnktim msi desc-v3
i2c i2c-3: nForce2 SMBus adapter at 0x1c00
i2c i2c-4: nForce2 SMBus adapter at 0x1c40
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: 00
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
cfg80211: Calling CRDA to update world regulatory domain
8139too Fast Ethernet driver 0.9.28
8139too 0000:01:08.0: Chip not responding, ignoring board
8139too: probe of 0000:01:08.0 failed with error -5
HDA Intel 0000:00:05.0: setting latency timer to 64
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
phy0: Selected rate control algorithm 'minstrel'
phy0: hwaddr 00:15:af:23:47:f2, RTL8187vB (default) V1 + rtl8225z2, rfkill mask 2
rtl8187: Customer ID is 0x00
Registered led device: rtl8187-phy0::radio
Registered led device: rtl8187-phy0::tx
Registered led device: rtl8187-phy0::rx
rtl8187: wireless switch is on
usbcore: registered new interface driver rtl8187
hda_codec: AD1988: BIOS auto-probing.
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:05.0/input/input3
EXT3-fs (sda1): using internal journal
parport0: no more devices allowed
lp: driver loaded but no devices found
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
rt2860sta: module is from the staging directory, the quality is unknown, you have been warned.
usbcore: registered new interface driver snd-usb-audio
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda2): using internal journal
EXT3-fs (sda2): mounted filesystem with ordered data mode
EXT3-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): using internal journal
EXT3-fs (sda3): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda4): using internal journal
EXT3-fs (sda4): mounted filesystem with ordered data mode

--bound1267587210--

