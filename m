Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384Ab0AQDo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0AQDo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 22:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411Ab0AQDo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 22:44:27 -0500
Received: from mxav1-gp.mediaserv.net ([213.188.172.3]:39063 "EHLO
	smhav-gp.mediaserv.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753409Ab0AQDoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 22:44:25 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jan 2010 22:44:25 EST
From: werner@sys-linux.yi.org
Subject: possible problem with 2.6.33-rc4
To: linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1263698405.12452@sys-linux.yi.org>
Date: Sun, 17 Jan 2010 00:20:05 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1263698405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1263698405
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

The following error messages I received now. I'm not sure if that's a kernel problem
For make more easy to correct the error, I send the whole syslog, below.
This is from syslog, because dmesg is to small.  (dmesg always is only half, when we finally can get dmesg 1 MB or bigger ??)

W.Landgraf

==============
Jan 16 23:42:07 werner kernel: ACPI: RSDP 000f6fd0 00024 (v02 Nvidia)
Jan 16 23:42:07 werner kernel: ACPI: XSDT afee30c0 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Jan 16 23:42:07 werner kernel: ACPI: FACP afeeb840 000F4 (v03 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Jan 16 23:42:07 werner kernel: ACPI: DSDT afee3240 08581 (v01 NVIDIA ASUSACPI 00001000 MSFT 03000000)
Jan 16 23:42:07 werner kernel: ACPI: FACS afee0000 00040
Jan 16 23:42:07 werner kernel: ACPI: MCFG afeeba40 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Jan 16 23:42:07 werner kernel: ACPI: APIC afeeb980 0007C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Jan 16 23:42:07 werner kernel: Zone PFN ranges:
Jan 16 23:42:07 werner kernel:   DMA      0x00000010 -> 0x00001000
Jan 16 23:42:07 werner kernel:   Normal   0x00001000 -> 0x000373fe
Jan 16 23:42:07 werner kernel:   HighMem  0x000373fe -> 0x000afee0
Jan 16 23:42:07 werner kernel: Movable zone start PFN for each node
Jan 16 23:42:07 werner kernel: early_node_map[2] active PFN ranges
Jan 16 23:42:07 werner kernel:     0: 0x00000010 -> 0x0000009f
Jan 16 23:42:07 werner kernel:     0: 0x00000100 -> 0x000afee0
Jan 16 23:42:07 werner kernel: ACPI: No APIC-table, disabling MPS
Jan 16 23:42:07 werner kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 714865
Jan 16 23:42:07 werner kernel: Console: colour dummy device 80x25
Jan 16 23:42:07 werner kernel: Fast TSC calibration using PIT
Jan 16 23:42:07 werner kernel: Detected 2511.303 MHz processor.
Jan 16 23:42:07 werner kernel: Mount-cache hash table entries: 512
Jan 16 23:42:07 werner kernel: AMD PMU driver.
Jan 16 23:42:07 werner kernel: weird, boot CPU (#0) not listed by the BIOS.
Jan 16 23:42:07 werner kernel: bio: create slab <bio-0> at 0
Jan 16 23:42:07 werner kernel: raid6: int32x1    644 MB/s
Jan 16 23:42:07 werner kernel: raid6: int32x2    867 MB/s
Jan 16 23:42:07 werner kernel: raid6: int32x4    703 MB/s
Jan 16 23:42:07 werner kernel: raid6: int32x8    570 MB/s
Jan 16 23:42:07 werner kernel: raid6: mmxx1     2042 MB/s
Jan 16 23:42:07 werner kernel: raid6: mmxx2     3703 MB/s
Jan 16 23:42:07 werner kernel: raid6: sse1x1    1937 MB/s
Jan 16 23:42:07 werner kernel: raid6: sse1x2    3316 MB/s
Jan 16 23:42:07 werner kernel: raid6: sse2x1    3328 MB/s
Jan 16 23:42:07 werner kernel: raid6: sse2x2    4332 MB/s
Jan 16 23:42:07 werner kernel: raid6: using algorithm sse2x2 (4332 MB/s)
Jan 16 23:42:07 werner kernel: PCI: Probing PCI hardware
Jan 16 23:42:07 werner kernel: microcode: AMD CPU family 0xf not supported
Jan 16 23:42:07 werner kernel: highmem bounce pool size: 64 pages
Jan 16 23:42:07 werner kernel: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jan 16 23:42:07 werner kernel: DLM (built Jan 13 2010 06:32:57) installed
Jan 16 23:42:07 werner kernel: EFS: 1.0a - http://aeschi.ch.eu.org/efs/
Jan 16 23:42:07 werner kernel: OCFS2 User DLM kernel interface loaded
Jan 16 23:42:07 werner kernel: GFS2 (built Jan 13 2010 06:34:01) installed
Jan 16 23:42:07 werner kernel: acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
Jan 16 23:42:07 werner kernel: mdacon: MDA with 8K of memory detected.
Jan 16 23:42:07 werner kernel: Console: switching consoles 13-16 to MDA-2
Jan 16 23:42:07 werner kernel: nvidiafb: CRTC0 analog found
Jan 16 23:42:07 werner kernel: nvidiafb: CRTC1 analog not found
Jan 16 23:42:07 werner kernel: i2c i2c-0: unable to read EDID block.
Jan 16 23:42:07 werner last message repeated 2 times
Jan 16 23:42:07 werner kernel: nvidiafb: EDID found from BUS2
Jan 16 23:42:07 werner kernel: nvidiafb: CRTC 0 appears to have a CRT attached
Jan 16 23:42:07 werner kernel: nvidiafb: Using CRT on CRTC 0
Jan 16 23:42:07 werner kernel: Console: switching to colour frame buffer device 210x65
Jan 16 23:42:07 werner kernel: Could not find Carillo Ranch MCH device.
Jan 16 23:42:07 werner kernel: no IO addresses supplied
Jan 16 23:42:07 werner kernel: hgafb: probe of hgafb.0 failed with error -22
Jan 16 23:42:07 werner kernel: uvesafb: failed to execute /sbin/v86d
Jan 16 23:42:07 werner kernel: uvesafb: make sure that the v86d helper is installed and executable
Jan 16 23:42:07 werner kernel: uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
Jan 16 23:42:07 werner kernel: uvesafb: vbe_init() failed with -22
Jan 16 23:42:07 werner kernel: uvesafb: probe of uvesafb.0 failed with error -22
Jan 16 23:42:07 werner kernel: vesafb: cannot reserve video memory at 0xe0000000
Jan 16 23:42:08 werner kernel: toshiba: not a supported Toshiba laptop
Jan 16 23:42:08 werner kernel: floppy0: no floppy controllers found
Jan 16 23:42:08 werner kernel: Compaq SMART2 Driver (v 2.6.0)
Jan 16 23:42:08 werner kernel: amd74xx 0000:00:06.0: BIOS didn't set cable bits correctly. Enabling workaround.
Jan 16 23:42:08 werner kernel: JMicron IDE 0000:03:00.1: can't find IRQ for PCI INT B; please try using pci=biosirq
Jan 16 23:42:08 werner kernel: jmicron 0000:03:00.1: bad irq (0): will probe later
Jan 16 23:42:08 werner kernel: ide1: disabled, no IRQ
Jan 16 23:42:08 werner kernel: ide2: disabled, no IRQ
Jan 16 23:42:08 werner kernel: JMicron IDE: probe of 0000:03:00.1 failed with error -1
Jan 16 23:42:08 werner kernel: Loading Adaptec I2O RAID: Version 2.4 Build 5go
Jan 16 23:42:08 werner kernel: scsi: <fdomain> Detection failed (no card)
Jan 16 23:42:08 werner kernel: NCR53c406a: no available ports found
Jan 16 23:42:08 werner kernel: Emulex LightPulse Fibre Channel SCSI driver 8.3.7
Jan 16 23:42:08 werner kernel: Copyright(c) 2004-2009 Emulex.  All rights reserved.
Jan 16 23:42:08 werner kernel: Failed initialization of WD-7000 SCSI card!
Jan 16 23:42:08 werner kernel: GDT-HA: Storage RAID Controller Driver. Version: 3.05
Jan 16 23:42:08 werner kernel: 3ware Storage Controller device driver for Linux v1.26.02.002.
Jan 16 23:42:08 werner kernel: 3ware 9000 Storage Controller device driver for Linux v2.26.02.013.
Jan 16 23:42:08 werner kernel: imm: Version 2.05 (for Linux 2.4.0)
Jan 16 23:42:08 werner kernel: pata_jmicron 0000:03:00.1: BAR 0: can't reserve [io  0x9c00-0x9c07]
Jan 16 23:42:08 werner kernel: pata_jmicron 0000:03:00.1: failed to request/iomap BARs for port 0 (errno=-16)
Jan 16 23:42:08 werner kernel: pata_jmicron 0000:03:00.1: BAR 2: can't reserve [io  0x9400-0x9407]
Jan 16 23:42:08 werner kernel: pata_jmicron 0000:03:00.1: failed to request/iomap BARs for port 1 (errno=-16)
Jan 16 23:42:08 werner kernel: pata_jmicron 0000:03:00.1: no available native port
Jan 16 23:42:08 werner kernel: Error: Driver 'pata_platform' is already registered, aborting...
Jan 16 23:42:08 werner kernel: pata_acpi 0000:03:00.1: BAR 0: can't reserve [io  0x9c00-0x9c07]
Jan 16 23:42:08 werner kernel: pata_acpi 0000:03:00.1: failed to request/iomap BARs for port 0 (errno=-16)
Jan 16 23:42:08 werner kernel: pata_acpi 0000:03:00.1: BAR 2: can't reserve [io  0x9400-0x9407]
Jan 16 23:42:08 werner kernel: pata_acpi 0000:03:00.1: failed to request/iomap BARs for port 1 (errno=-16)
Jan 16 23:42:08 werner kernel: pata_acpi 0000:03:00.1: no available native port
Jan 16 23:42:08 werner kernel: mtdoops: mtd device (mtddev=name/number) must be supplied
Jan 16 23:42:08 werner kernel: physmap-flash.0: failed to claim resource 0
Jan 16 23:42:08 werner kernel: Failed to ioremap_nocache
Jan 16 23:42:08 werner last message repeated 2 times
Jan 16 23:42:08 werner kernel: SNAPGEAR: failed to ioremap() BOOTCS
Jan 16 23:42:08 werner kernel: Generic platform RAM MTD, (c) 2004 Simtec Electronics
Jan 16 23:42:08 werner kernel: flash size: 8 MiB
Jan 16 23:42:08 werner kernel: page size: 512 bytes
Jan 16 23:42:08 werner kernel: OOB area size: 16 bytes
Jan 16 23:42:08 werner kernel: sector size: 8 KiB
Jan 16 23:42:08 werner kernel: pages number: 16384
Jan 16 23:42:08 werner kernel: pages per sector: 16
Jan 16 23:42:08 werner kernel: bus width: 8
Jan 16 23:42:08 werner kernel: bits in sector size: 13
Jan 16 23:42:08 werner kernel: bits in page size: 9
Jan 16 23:42:08 werner kernel: bits in OOB size: 4
Jan 16 23:42:08 werner kernel: flash size with OOB: 8448 KiB
Jan 16 23:42:08 werner kernel: page address bytes: 3
Jan 16 23:42:08 werner kernel: sector address bytes: 2
Jan 16 23:42:08 werner kernel: options: 0x62
Jan 16 23:42:08 werner kernel: onenand_wait: timeout! ctrl=0x0000 intr=0x0000
Jan 16 23:42:08 werner kernel: Clocksource tsc unstable (delta = 278983987 ns)
Jan 16 23:42:08 werner kernel: DE600: port 0x378 busy
Jan 16 23:42:08 werner kernel: paride: aten registered as protocol 0
Jan 16 23:42:08 werner kernel: paride: bpck registered as protocol 1
Jan 16 23:42:08 werner kernel: paride: comm registered as protocol 2
Jan 16 23:42:08 werner kernel: paride: dstr registered as protocol 3
Jan 16 23:42:08 werner kernel: paride: k951 registered as protocol 4
Jan 16 23:42:08 werner kernel: paride: k971 registered as protocol 5
Jan 16 23:42:08 werner kernel: paride: epat registered as protocol 6
Jan 16 23:42:08 werner kernel: paride: epia registered as protocol 7
Jan 16 23:42:08 werner kernel: paride: frpw registered as protocol 8
Jan 16 23:42:08 werner kernel: paride: friq registered as protocol 9
Jan 16 23:42:08 werner kernel: paride: fit2 registered as protocol 10
Jan 16 23:42:08 werner kernel: paride: fit3 registered as protocol 11
Jan 16 23:42:08 werner kernel: paride: on20 registered as protocol 12
Jan 16 23:42:08 werner kernel: paride: on26 registered as protocol 13
Jan 16 23:42:08 werner kernel: paride: ktti registered as protocol 14
Jan 16 23:42:08 werner kernel: paride: bpck6 registered as protocol 15
Jan 16 23:42:08 werner kernel: pd: pd version 1.05, major 45, cluster 64, nice 0
Jan 16 23:42:08 werner kernel:  sda1 sda2 sda3 sda4
Jan 16 23:42:08 werner kernel: pda: Autoprobe failed
Jan 16 23:42:08 werner kernel: pd: no valid drive found
Jan 16 23:42:08 werner kernel: pcd: pcd version 1.07, major 46, nice 0
Jan 16 23:42:08 werner kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 16 23:42:08 werner kernel: pcd0: Autoprobe failed
Jan 16 23:42:08 werner kernel: pcd: No CD-ROM drive found
Jan 16 23:42:08 werner kernel: pf: pf version 1.04, major 47, cluster 64, nice 0
Jan 16 23:42:08 werner kernel: pf: No ATAPI disk detected
Jan 16 23:42:08 werner kernel: pt: pt version 1.04, major 96
Jan 16 23:42:08 werner kernel: pt0: Autoprobe failed
Jan 16 23:42:08 werner kernel: pt: No ATAPI tape drive detected
Jan 16 23:42:08 werner kernel: pg: pg version 1.02, major 97
Jan 16 23:42:08 werner kernel: pga: Autoprobe failed
Jan 16 23:42:08 werner kernel: pg: No ATAPI device detected
Jan 16 23:42:08 werner kernel: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Jan 16 23:42:08 werner kernel: GTCO usb driver version: 2.00.0006
Jan 16 23:42:08 werner kernel: Cannot allocate resource for EISA slot 1
Jan 16 23:42:08 werner kernel: Cannot allocate resource for EISA slot 7
Jan 16 23:42:08 werner kernel: Cannot allocate resource for EISA slot 8
Jan 16 23:42:08 werner kernel: dell-wmi: No known WMI GUID found
Jan 16 23:42:08 werner kernel: This machine doesn't have MSI-hotkeys through WMI
Jan 16 23:42:08 werner kernel: [Firmware Bug]: powernow-k8: No PSB or ACPI _PSS objects
Jan 16 23:42:08 werner udevd-event[4938]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Jan 16 23:42:08 werner udevd-event[4940]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Jan 16 23:42:08 werner udevd-event[4941]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Jan 16 23:42:08 werner udevd-event[4939]: udev_rules_apply_format: unknown format variable '$modalias | grep -q eagle-usb || exit; while ! /sbin/eaglectrl -p 2>/dev/null | /bin/grep -q Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Jan 16 23:42:08 werner kernel: VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
Jan 16 23:42:08 werner kernel: usb 2-2: device descriptor read/64, error -62
Jan 16 23:42:08 werner last message repeated 3 times
Jan 16 23:42:08 werner kernel: usb 2-2: device not accepting address 4, error -62
Jan 16 23:42:08 werner kernel: usb 2-2: device not accepting address 5, error -62
Jan 16 23:42:08 werner kernel: hub 2-0:1.0: unable to enumerate USB device on port 2
Jan 16 23:42:08 werner kernel: k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
Jan 16 23:42:08 werner kernel: rt2860sta: module is from the staging directory, the quality is unknown, you have been warned.
Jan 16 23:42:18 werner apcupsd[4916]: apcupsd FATAL ERROR in smartsetup.c at line 171 PANIC! Cannot communicate with UPS via serial port. Please make sure the port specified on the DEVICE directive is correct, and that your cable specification on the UPSCABLE directive is correct. 
Jan 16 23:42:19 werner apcupsd[4916]: apcupsd error shutdown completed
Jan 16 23:42:21 werner hpijs: unable to init hpijs server 
Jan 16 23:42:24 werner udevd[2292]: add_to_rules: unknown key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Jan 16 23:42:31 werner kernel: PERCPU: allocation failed, size=2048 align=8, failed to allocate new chunk
Jan 16 23:42:31 werner kernel: Pid: 5302, comm: modprobe Tainted: G         C 2.6.33-rc4 #1
Jan 16 23:42:31 werner kernel: Call Trace:
Jan 16 23:42:31 werner kernel:  [<c1c1ed72>] ? printk+0x14/0x16
Jan 16 23:42:31 werner kernel:  [<c10b98b5>] pcpu_alloc+0x6ba/0x73b
Jan 16 23:42:31 werner kernel:  [<c1b2cbe3>] ? neigh_parms_alloc+0x55/0xd1
Jan 16 23:42:31 werner kernel:  [<c10b9959>] __alloc_percpu+0xf/0x12
Jan 16 23:42:31 werner kernel:  [<c1b6b6dc>] snmp_mib_init+0x22/0x5a
Jan 16 23:42:31 werner kernel:  [<fed30051>] ipv6_add_dev+0x172/0x2ec [ipv6]
Jan 16 23:42:31 werner kernel:  [<fea4e000>] ? inet6_init+0x0/0x2a2 [ipv6]
Jan 16 23:42:31 werner kernel:  [<fea4e2ec>] addrconf_init+0x3b/0x11b [ipv6]
Jan 16 23:42:31 werner kernel:  [<fea4e195>] inet6_init+0x195/0x2a2 [ipv6]
Jan 16 23:42:31 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Jan 16 23:42:31 werner kernel:  [<c10645a9>] sys_init_module+0xac/0x1e0
Jan 16 23:42:31 werner kernel:  [<c1c211cc>] syscall_call+0x7/0xb
Jan 16 23:42:43 werner kdm_greet[5385]: Can't open default user face
Jan 16 23:44:09 werner named[5925]: /etc/named.conf:3: option 'multiple-cnames' is obsolete
Jan 16 23:44:09 werner kernel: PERCPU: allocation failed, size=2048 align=8, failed to allocate new chunk
Jan 16 23:44:09 werner kernel: Pid: 5930, comm: modprobe Tainted: G         C 2.6.33-rc4 #1
Jan 16 23:44:09 werner kernel: Call Trace:
Jan 16 23:44:09 werner kernel:  [<c1c1ed72>] ? printk+0x14/0x16
Jan 16 23:44:09 werner kernel:  [<c10b98b5>] pcpu_alloc+0x6ba/0x73b
Jan 16 23:44:09 werner kernel:  [<c10b5048>] ? deactivate_slab+0xb/0xb0
Jan 16 23:44:09 werner kernel:  [<c1b2cbe3>] ? neigh_parms_alloc+0x55/0xd1
Jan 16 23:44:09 werner kernel:  [<c10b9959>] __alloc_percpu+0xf/0x12
Jan 16 23:44:09 werner kernel:  [<c1b6b6dc>] snmp_mib_init+0x22/0x5a
Jan 16 23:44:09 werner kernel:  [<fed30051>] ipv6_add_dev+0x172/0x2ec [ipv6]
Jan 16 23:44:09 werner kernel:  [<f91a3000>] ? inet6_init+0x0/0x2a2 [ipv6]
Jan 16 23:44:09 werner kernel:  [<f91a32ec>] addrconf_init+0x3b/0x11b [ipv6]
Jan 16 23:44:09 werner kernel:  [<f91a3195>] inet6_init+0x195/0x2a2 [ipv6]
Jan 16 23:44:09 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Jan 16 23:44:09 werner kernel:  [<c10645a9>] sys_init_module+0xac/0x1e0
Jan 16 23:44:09 werner kernel:  [<c1c211cc>] syscall_call+0x7/0xb
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:6: ignoring out-of-zone data (SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:16: ignoring out-of-zone data (www.SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:17: ignoring out-of-zone data (irc.SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:18: ignoring out-of-zone data (ftp.SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:19: ignoring out-of-zone data (ns.SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:22: ignoring out-of-zone data (SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:23: ignoring out-of-zone data (SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:24: ignoring out-of-zone data (SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: caching-example/SYS-Linux.yi.org:25: ignoring out-of-zone data (SYS-Linux.yi.org)
Jan 16 23:44:09 werner named[5925]: checkhints: l.root-servers.net/A (199.7.83.42) missing from hints
Jan 16 23:44:09 werner named[5925]: checkhints: l.root-servers.net/A (198.32.64.12) extra record in hints
Jan 16 23:44:34 werner kernel: PERCPU: allocation failed, size=2048 align=8, failed to allocate new chunk
Jan 16 23:44:34 werner kernel: Pid: 6071, comm: modprobe Tainted: G         C 2.6.33-rc4 #1
Jan 16 23:44:34 werner kernel: Call Trace:
Jan 16 23:44:34 werner kernel:  [<c1c1ed72>] ? printk+0x14/0x16
Jan 16 23:44:34 werner kernel:  [<c10b98b5>] pcpu_alloc+0x6ba/0x73b
Jan 16 23:44:34 werner kernel:  [<c1b2cbe3>] ? neigh_parms_alloc+0x55/0xd1
Jan 16 23:44:34 werner kernel:  [<c10b9959>] __alloc_percpu+0xf/0x12
Jan 16 23:44:34 werner kernel:  [<c1b6b6dc>] snmp_mib_init+0x22/0x5a
Jan 16 23:44:34 werner kernel:  [<fee36051>] ipv6_add_dev+0x172/0x2ec [ipv6]
Jan 16 23:44:34 werner kernel:  [<f9185000>] ? inet6_init+0x0/0x2a2 [ipv6]
Jan 16 23:44:34 werner kernel:  [<f91852ec>] addrconf_init+0x3b/0x11b [ipv6]
Jan 16 23:44:34 werner kernel:  [<f9185195>] inet6_init+0x195/0x2a2 [ipv6]
Jan 16 23:44:34 werner kernel:  [<c1001143>] do_one_initcall+0x51/0x13f
Jan 16 23:44:34 werner kernel:  [<c10645a9>] sys_init_module+0xac/0x1e0
Jan 16 23:44:34 werner kernel:  [<c1c211cc>] syscall_call+0x7/0xb
Jan 16 23:44:34 werner kernel: BUG: unable to handle kernel paging request at fed53954
Jan 16 23:44:34 werner kernel: IP: [<c1b22e4e>] unregister_pernet_operations+0x21/0x93
Jan 16 23:44:34 werner kernel: *pde = 36156067 *pte = 00000000 
Jan 16 23:44:34 werner kernel: Oops: 0002 [#1] SMP 
Jan 16 23:44:34 werner kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/boot_vga
Jan 16 23:44:34 werner kernel: Modules linked in: ipv6(+) bnep rfcomm hidp l2cap bluetooth snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device rt2860sta(C) uvcvideo usbvideo lp snd_hda_codec_analog rtc_cmos rtc_core rtc_lib rtl8187 tpm_tis tpm tpm_bios mac80211 snd_hda_intel led_class snd_hda_codec k8temp hwmon cfg80211 snd_hwdep snd_pcm rfkill snd_timer snd soundcore snd_page_alloc i2c_nforce2 forcedeth
Jan 16 23:44:34 werner kernel: 
Jan 16 23:44:34 werner kernel: Pid: 6071, comm: modprobe Tainted: G         C 2.6.33-rc4 #1 M2N-VM DH/System Product Name
Jan 16 23:44:34 werner kernel: EIP: 0060:[<c1b22e4e>] EFLAGS: 00010246 CPU: 0
Jan 16 23:44:34 werner kernel: EIP is at unregister_pernet_operations+0x21/0x93
Jan 16 23:44:34 werner kernel: EAX: fed53954 EBX: fee598d0 ECX: f5a25f58 EDX: fee59954
Jan 16 23:44:34 werner kernel: ESI: fee598d0 EDI: f9185000 EBP: f5a25f6c ESP: f5a25f58
Jan 16 23:44:34 werner kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jan 16 23:44:34 werner kernel: Process modprobe (pid: 6071, ti=f5a24000 task=f5ae0000 task.ti=f5a24000)
Jan 16 23:44:34 werner kernel: Stack:
Jan 16 23:44:34 werner kernel:  f5a25f58 f5a25f58 fee598d0 00000000 f9185000 f5a25f78 c1b22f14 fffffff4
Jan 16 23:44:34 werner kernel: <0> f5a25f84 f9185257 fee5b8b4 f5a25f9c c1001143 00000000 fee5b8b4 00000000
Jan 16 23:44:34 werner kernel: <0> 0805e1a0 f5a25fac c10645a9 b7585008 0805e150 f5a24000 c1c211cc b7585008
Jan 16 23:44:34 werner kernel: Call Trace:
Jan 16 23:44:34 werner kernel:  [<f9185000>] ? inet6_init+0x0/0x2a2 [ipv6]
Jan 16 23:44:34 werner kernel:  [<c1b22f14>] ? unregister_pernet_subsys+0x1c/0x29
Jan 16 23:44:34 werner kernel:  [<f9185257>] ? inet6_init+0x257/0x2a2 [ipv6]
Jan 16 23:44:34 werner kernel:  [<c1001143>] ? do_one_initcall+0x51/0x13f
Jan 16 23:44:34 werner kernel:  [<c10645a9>] ? sys_init_module+0xac/0x1e0
Jan 16 23:44:34 werner kernel:  [<c1c211cc>] ? syscall_call+0x7/0xb
Jan 16 23:44:34 werner kernel: Code: c2 75 e5 e8 3e 3b 55 ff eb 97 55 89 e5 57 56 53 83 ec 08 e8 35 0b 4e ff 89 c6 8d 4d ec 89 4d ec 89 4d f0 8b 10 8b 40 04 89 42 04 <89> 10 c7 06 00 01 10 00 c7 46 04 00 02 20 00 a1 18 18 0c c2 8d 
Jan 16 23:44:34 werner kernel: EIP: [<c1b22e4e>] unregister_pernet_operations+0x21/0x93 SS:ESP 0068:f5a25f58
Jan 16 23:44:34 werner kernel: CR2: 00000000fed53954
Jan 16 23:44:34 werner kernel: ---[ end trace 76a4ea73058f2ab5 ]---

--bound1263698405--

