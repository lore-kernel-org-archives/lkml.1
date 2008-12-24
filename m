Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbYLXOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbYLXOdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 09:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYLXOdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 09:33:01 -0500
Received: from www17.your-server.de ([213.133.104.17]:51957 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYLXOcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 09:32:55 -0500
X-Greylist: delayed 1178 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Dec 2008 09:32:53 EST
Subject: v2.6.28-rc9: No video with test_suspend=mem
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org, radeonhd@opensuse.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Dec 2008 15:13:40 +0100
Message-Id: <1230128020.3455.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ git describe
v2.6.28-rc9-57-g8960223

Suspend/resume from S3 seems to work, but I get no video after resume.

Setting BIOS option "Call Video-BIOS after S3 resume" to "ENABLED" hangs
the system, so I set it to "DISABLED". The system also hangs after
resume from S3 by executing program "vbetool post" (entered blindly).

Xorg log:

X.Org X Server 1.5.3
Release Date: 5 November 2008
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.18-92.1.18.el5 x86_64 
Current Operating System: Linux localhost.localdomain 2.6.28-rc9 #16 SMP PREEMPT Wed Dec 24 12:33:18 CET 2008 x86_64
Build Date: 11 December 2008  05:27:30PM
Build ID: xorg-x11-server 1.5.3-6.fc10 
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Wed Dec 24 12:55:39 2008
(==) Using config file: "/etc/X11/xorg.conf"
(==) No Layout section.  Using the first Screen section.
(==) No screen section available. Using defaults.
(**) |-->Screen "Default Screen Section" (0)
(**) |   |-->Monitor "<default monitor>"
(==) No device specified for screen "Default Screen Section".
	Using the first device section listed.
(**) |   |-->Device "main"
(==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
(==) Automatically adding devices
(==) Automatically enabling devices
(==) No FontPath specified.  Using compiled-in default.
(==) FontPath set to:
	catalogue:/etc/X11/fontpath.d,
	built-ins
(==) ModulePath set to "/usr/lib64/xorg/modules"
(II) Cannot locate a core pointer device.
(II) Cannot locate a core keyboard device.
(II) The server relies on HAL to provide the list of input devices.
	If no devices become available, reconfigure HAL or disable AllowEmptyInput.
(II) Open ACPI successful (/var/run/acpid.socket)
(II) Loader magic: 0x7aec60
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 4.1
	X.Org XInput driver : 2.1
	X.Org Server Extension : 1.1
	X.Org Font Renderer : 0.6
(II) Loader running on linux
(--) using VT number 7

(--) PCI:*(0@7:0:0) ATI Technologies Inc Mobilitiy Radeon HD 3450 rev 0, Mem @ 0xc0000000/268435456, 0xfebf0000/65536, I/O @ 0x0000e000/256, BIOS @ 0x????????/131072
(II) System resource ranges:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[17] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[18] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[19] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[20] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[21] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[22] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[23] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) LoadModule: "extmod"

(II) Loading /usr/lib64/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.5.3, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension SELinux
(II) Loading extension SHAPE
(II) Loading extension MIT-SUNDRY-NONSTANDARD
(II) Loading extension BIG-REQUESTS
(II) Loading extension SYNC
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XC-MISC
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-Misc
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension TOG-CUP
(II) Loading extension Extended-Visual-Information
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"

(II) Loading /usr/lib64/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.5.3, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"

(II) Loading /usr/lib64/xorg/modules/extensions//libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.5.3, module version = 1.0.0
	ABI class: X.Org Server Extension, version 1.1
(==) AIGLX enabled
(==) Exporting typical set of GLX visuals
(II) Loading extension GLX
(II) LoadModule: "freetype"

(II) Loading /usr/lib64/xorg/modules/fonts//libfreetype.so
(II) Module freetype: vendor="X.Org Foundation & the After X-TT Project"
	compiled for 1.5.3, module version = 2.1.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.6
(II) Loading font FreeType
(II) LoadModule: "dri"

(II) Loading /usr/lib64/xorg/modules/extensions//libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.5.3, module version = 1.0.0
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension XFree86-DRI
(II) LoadModule: "radeonhd"

(II) Loading /usr/lib64/xorg/modules/drivers//radeonhd_drv.so
(II) Module radeonhd: vendor="AMD GPG"
	compiled for 1.5.3, module version = 1.2.4
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 4.1
(II) RADEONHD: X driver for the following AMD GPG (ATI) graphics devices:
	RV505 : Radeon X1550, X1550 64bit.
	RV515 : Radeon X1300, X1550, X1600; FireGL V3300, V3350.
	RV516 : Radeon X1300, X1550, X1550 64-bit, X1600; FireMV 2250.
	R520  : Radeon X1800; FireGL V5300, V7200, V7300, V7350.
	RV530 : Radeon X1300 XT, X1600, X1600 Pro, X1650; FireGL V3400, V5200.
	RV535 : Radeon X1300, X1650.
	RV550 : Radeon X2300 HD.
	RV560 : Radeon X1650.
	RV570 : Radeon X1950, X1950 GT; FireGL V7400.
	R580  : Radeon X1900, X1950; AMD Stream Processor.
	R600  : Radeon HD 2900 GT/Pro/XT; FireGL V7600/V8600/V8650.
	RV610 : Radeon HD 2350, HD 2400 Pro/XT, HD 2400 Pro AGP; FireGL V4000.
	RV620 : Radeon HD 3450, HD 3470.
	RV630 : Radeon HD 2600 LE/Pro/XT, HD 2600 Pro/XT AGP; Gemini RV630;
		FireGL V3600/V5600.
	RV635 : Radeon HD 3650, HD 3670.
	RV670 : Radeon HD 3690, 3850, HD 3870, FireGL V7700, FireStream 9170.
	R680  : Radeon HD 3870 X2.
	M52   : Mobility Radeon X1300.
	M54   : Mobility Radeon X1400; M54-GL.
	M56   : Mobility Radeon X1600; Mobility FireGL V5200.
	M58   : Mobility Radeon X1800, X1800 XT; Mobility FireGL V7100, V7200.
	M62   : Mobility Radeon X1350.
	M64   : Mobility Radeon X1450, X2300.
	M66   : Mobility Radeon X1700, X1700 XT; FireGL V5250.
	M68   : Mobility Radeon X1900.
	M71   : Mobility Radeon HD 2300.
	M72   : Mobility Radeon HD 2400; Radeon E2400.
	M74   : Mobility Radeon HD 2400 XT.
	M76   : Mobility Radeon HD 2600;
		(Gemini ATI) Mobility Radeon HD 2600 XT.
	M82   : Mobility Radeon HD 3400.
	M86   : Mobility Radeon HD 3650, HD 3670, Mobility FireGL V5700.
	M88   : Mobility Radeon HD 3850, HD 3850 X2, HD 3870, HD3870 X2.
	RS600 : Radeon Xpress 1200, Xpress 1250.
	RS690 : Radeon X1200, X1250, X1270.
	RS740 : RS740, RS740M.
	RS780 : Radeon HD 3100/3200/3300 Series.
	RV770 : Radeon HD 4800 Series; Everest, K2, Denali ATI FirePro.
	R700  : Radeon R700.
	M98   : Radeon M98 Mobility.
	RV730 : Radeon HD4670, HD4650.
	M96   : Radeon M96 Mobility.
	RV710 : Radeon HD4570, HD4350.

(II) RADEONHD: version 1.2.4, built from git branch master, commit 003325a5

(II) Primary Device is: PCI 07@00:00:0
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[17] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[18] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[19] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[20] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[21] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[22] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[23] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) resource ranges after probing:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[17] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[18] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[19] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[20] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[21] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[22] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[23] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[24] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[25] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[26] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[27] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[28] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) Setting vga for screen 0.
(II) RADEONHD(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
(==) RADEONHD(0): Depth 24, (--) framebuffer bpp 32
(**) RADEONHD(0): Selected ShadowFB.
(II) RADEONHD(0): Unknown card detected: 0x95C5:0x1043:0x01E2.
	If - and only if - your card does not work or does not work optimally
	please contact radeonhd@opensuse.org to help rectify this.
	Use the subject: 0x95C5:0x1043:0x01E2: <name of board>
	and *please* describe the problems you are seeing
	in your message.
(--) RADEONHD(0): Detected an RV620 on an unidentified card
(II) RADEONHD(0): Mapped IO @ 0xfebf0000 to 0x7fc43a64c000 (size 0x00010000)
(II) RADEONHD(0): PCIE Card Detected
(II) RADEONHD(0): Getting BIOS copy from legacy VBIOS location
(II) RADEONHD(0): ATOM BIOS Rom: 
	SubsystemVendorID: 0x1043 SubsystemID: 0x01e2
	IOBaseAddress: 0xe000
	Filename: SV27971a.bin
	BIOS Bootup Message: 
95C5.10.79.0.1.AS05                                                         

(II) RADEONHD(0): Analog TV Default Mode: 1
(II) RADEONHD(0): Found default TV Mode NTSC
(EE) RADEONHD(0): No Video RAM detected.
(II) UnloadModule: "radeonhd"
(EE) Screen(s) found, but none have a usable configuration.

Fatal server error:
no screens found




So what can I do to make video work again after S3 suspend/resume?



Kernel log:
Dec 24 12:54:38 localhost kernel: [    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
Dec 24 12:54:38 localhost kernel: [    0.000000] Initializing cgroup subsys cpuset
Dec 24 12:54:38 localhost kernel: [    0.000000] Linux version 2.6.28-rc9 (thomas@localhost.localdomain) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #16 SMP PREEMPT Wed Dec 24 12:33:18 CET 2008
Dec 24 12:54:38 localhost kernel: [    0.000000] Command line: ro root=UUID=bc411e66-df48-4424-9b50-19780567b995 rhgb test_suspend=mem
Dec 24 12:54:38 localhost kernel: [    0.000000] KERNEL supported cpus:
Dec 24 12:54:38 localhost kernel: [    0.000000]   Intel GenuineIntel
Dec 24 12:54:38 localhost kernel: [    0.000000]   AMD AuthenticAMD
Dec 24 12:54:38 localhost kernel: [    0.000000]   Centaur CentaurHauls
Dec 24 12:54:38 localhost kernel: [    0.000000] BIOS-provided physical RAM map:
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffd0000 (usable)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 00000000bffd0000 - 00000000bffde000 (ACPI data)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 00000000bffde000 - 00000000c0000000 (ACPI NVS)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Dec 24 12:54:38 localhost kernel: [    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
Dec 24 12:54:38 localhost kernel: [    0.000000] DMI present.
Dec 24 12:54:38 localhost kernel: [    0.000000] last_pfn = 0x1c0000 max_arch_pfn = 0x3ffffffff
Dec 24 12:54:38 localhost kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Dec 24 12:54:38 localhost kernel: [    0.000000] last_pfn = 0xbffd0 max_arch_pfn = 0x3ffffffff
Dec 24 12:54:38 localhost kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000bffd0000
Dec 24 12:54:38 localhost kernel: [    0.000000] last_map_addr: bffd0000 end: bffd0000
Dec 24 12:54:38 localhost kernel: [    0.000000] init_memory_mapping: 0000000100000000-00000001c0000000
Dec 24 12:54:38 localhost kernel: [    0.000000] last_map_addr: 1c0000000 end: 1c0000000
Dec 24 12:54:38 localhost kernel: [    0.000000] RAMDISK: 37c64000 - 37fef83d
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: RSDP 000F98B0, 0014 (r0 ACPIAM)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: RSDT BFFD0000, 003C (r1 MSIISM OEMRSDT   4000807 MSFT       97)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: FACP BFFD0200, 0084 (r2 MSIISM OEMFACP   4000807 MSFT       97)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: DSDT BFFD0440, 5045 (r1  1ADGH 1ADGH013       13 INTL 20051117)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: FACS BFFDE000, 0040
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: APIC BFFD0390, 0070 (r1 MSIISM OEMAPIC   4000807 MSFT       97)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: MCFG BFFD0400, 003C (r1 MSIISM OEMMCFG   4000807 MSFT       97)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: OEMB BFFDE040, 0061 (r1 MSIISM AMI_OEM   4000807 MSFT       97)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: HPET BFFD5490, 0038 (r1 MSIISM OEMHPET0  4000807 MSFT       97)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: SSDT BFFD54D0, 028A (r1 A M I  POWERNOW        1 AMD         1)
Dec 24 12:54:38 localhost kernel: [    0.000000] (7 early reservations) ==> bootmem [0000000000 - 01c0000000]
Dec 24 12:54:38 localhost kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Dec 24 12:54:38 localhost kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Dec 24 12:54:38 localhost kernel: [    0.000000]   #2 [0000200000 - 0000e759fc]    TEXT DATA BSS ==> [0000200000 - 0000e759fc]
Dec 24 12:54:38 localhost kernel: [    0.000000]   #3 [0037c64000 - 0037fef83d]          RAMDISK ==> [0037c64000 - 0037fef83d]
Dec 24 12:54:38 localhost kernel: [    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
Dec 24 12:54:38 localhost kernel: [    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
Dec 24 12:54:38 localhost kernel: [    0.000000]   #6 [000000b000 - 000000e000]          PGTABLE ==> [000000b000 - 000000e000]
Dec 24 12:54:38 localhost kernel: [    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
Dec 24 12:54:38 localhost kernel: [    0.000000] Zone PFN ranges:
Dec 24 12:54:38 localhost kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Dec 24 12:54:38 localhost kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Dec 24 12:54:38 localhost kernel: [    0.000000]   Normal   0x00100000 -> 0x001c0000
Dec 24 12:54:38 localhost kernel: [    0.000000] Movable zone start PFN for each node
Dec 24 12:54:38 localhost kernel: [    0.000000] early_node_map[3] active PFN ranges
Dec 24 12:54:38 localhost kernel: [    0.000000]     0: 0x00000000 -> 0x0000009f
Dec 24 12:54:38 localhost kernel: [    0.000000]     0: 0x00000100 -> 0x000bffd0
Dec 24 12:54:38 localhost kernel: [    0.000000]     0: 0x00100000 -> 0x001c0000
Dec 24 12:54:38 localhost kernel: [    0.000000] Detected use of extended apic ids on hypertransport bus
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x2008
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Dec 24 12:54:38 localhost kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
Dec 24 12:54:38 localhost kernel: [    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
Dec 24 12:54:38 localhost kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Dec 24 12:54:38 localhost kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000bffd0000 - 00000000bffde000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000bffde000 - 00000000c0000000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000d0000000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000fec00000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff780000
Dec 24 12:54:38 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000ff780000 - 0000000100000000
Dec 24 12:54:38 localhost kernel: [    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
Dec 24 12:54:38 localhost kernel: [    0.000000] PERCPU: Allocating 57344 bytes of per cpu data
Dec 24 12:54:38 localhost kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1544335
Dec 24 12:54:38 localhost kernel: [    0.000000] Kernel command line: ro root=UUID=bc411e66-df48-4424-9b50-19780567b995 rhgb test_suspend=mem
Dec 24 12:54:38 localhost kernel: [    0.000000] Initializing CPU#0
Dec 24 12:54:38 localhost kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Dec 24 12:54:38 localhost kernel: [    0.000000] Fast TSC calibration using PIT
Dec 24 12:54:38 localhost kernel: [    0.000000] Detected 2600.097 MHz processor.
Dec 24 12:54:38 localhost kernel: [    0.000999] Console: colour VGA+ 80x25
Dec 24 12:54:38 localhost kernel: [    0.000999] console [tty0] enabled
Dec 24 12:54:38 localhost kernel: [    0.000999] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Dec 24 12:54:38 localhost kernel: [    0.000999] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Dec 24 12:54:38 localhost kernel: [    0.000999] Checking aperture...
Dec 24 12:54:38 localhost kernel: [    0.000999] No AGP bridge found
Dec 24 12:54:38 localhost kernel: [    0.000999] Node 0: aperture @ 20000000 size 32 MB
Dec 24 12:54:38 localhost kernel: [    0.000999] Aperture pointing to e820 RAM. Ignoring.
Dec 24 12:54:38 localhost kernel: [    0.000999] Your BIOS doesn't leave a aperture memory hole
Dec 24 12:54:38 localhost kernel: [    0.000999] Please enable the IOMMU option in the BIOS setup
Dec 24 12:54:38 localhost kernel: [    0.000999] This costs you 64 MB of RAM
Dec 24 12:54:38 localhost kernel: [    0.000999] Mapping aperture over 65536 KB of RAM @ 20000000
Dec 24 12:54:38 localhost kernel: [    0.000999] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Dec 24 12:54:38 localhost kernel: [    0.000999] Memory: 6094824k/7340032k available (6825k kernel code, 1049156k absent, 195064k reserved, 4201k data, 476k init)
Dec 24 12:54:38 localhost kernel: [    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Dec 24 12:54:38 localhost kernel: [    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Dec 24 12:54:38 localhost kernel: [    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 5200.19 BogoMIPS (lpj=2600097)
Dec 24 12:54:38 localhost kernel: [    0.000999] Security Framework initialized
Dec 24 12:54:38 localhost kernel: [    0.000999] SELinux:  Initializing.
Dec 24 12:54:38 localhost kernel: [    0.000999] Mount-cache hash table entries: 256
Dec 24 12:54:38 localhost kernel: [    0.000999] Initializing cgroup subsys ns
Dec 24 12:54:38 localhost kernel: [    0.000999] Initializing cgroup subsys cpuacct
Dec 24 12:54:38 localhost kernel: [    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Dec 24 12:54:38 localhost kernel: [    0.001007] CPU: L2 Cache: 512K (64 bytes/line)
Dec 24 12:54:38 localhost kernel: [    0.001115] CPU: Physical Processor ID: 0
Dec 24 12:54:38 localhost kernel: [    0.001216] CPU: Processor Core ID: 0
Dec 24 12:54:38 localhost kernel: [    0.001323] using C1E aware idle routine
Dec 24 12:54:38 localhost kernel: [    0.001434] ACPI: Core revision 20080926
Dec 24 12:54:38 localhost kernel: [    0.008050] Setting APIC routing to flat
Dec 24 12:54:38 localhost kernel: [    0.008619] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Dec 24 12:54:38 localhost kernel: [    0.018804] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
Dec 24 12:54:38 localhost kernel: [    0.018997] Booting processor 1 APIC 0x1 ip 0x6000
Dec 24 12:54:38 localhost kernel: [    0.000999] Initializing CPU#1
Dec 24 12:54:38 localhost kernel: [    0.000999] Calibrating delay using timer specific routine.. 5199.68 BogoMIPS (lpj=2599842)
Dec 24 12:54:38 localhost kernel: [    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Dec 24 12:54:38 localhost kernel: [    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
Dec 24 12:54:38 localhost kernel: [    0.000999] CPU: Physical Processor ID: 0
Dec 24 12:54:38 localhost kernel: [    0.000999] CPU: Processor Core ID: 1
Dec 24 12:54:38 localhost kernel: [    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
Dec 24 12:54:38 localhost kernel: [    0.089315] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
Dec 24 12:54:38 localhost kernel: [    0.090116] Brought up 2 CPUs
Dec 24 12:54:38 localhost kernel: [    0.090218] Total of 2 processors activated (10399.87 BogoMIPS).
Dec 24 12:54:38 localhost kernel: [    0.090464] net_namespace: 1400 bytes
Dec 24 12:54:38 localhost kernel: [    0.091098] xor: automatically using best checksumming function: generic_sse
Dec 24 12:54:38 localhost kernel: [    0.095987]    generic_sse:  7716.000 MB/sec
Dec 24 12:54:38 localhost kernel: [    0.096088] xor: using function: generic_sse (7716.000 MB/sec)
Dec 24 12:54:38 localhost kernel: [    0.096224] NET: Registered protocol family 16
Dec 24 12:54:38 localhost kernel: [    0.096344] TOM: 00000000c0000000 aka 3072M
Dec 24 12:54:38 localhost kernel: [    0.096344] TOM2: 00000001c0000000 aka 7168M
Dec 24 12:54:38 localhost kernel: [    0.096344] ACPI: bus type pci registered
Dec 24 12:54:38 localhost kernel: [    0.097014] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Dec 24 12:54:38 localhost kernel: [    0.097115] PCI: Not using MMCONFIG.
Dec 24 12:54:38 localhost kernel: [    0.097216] PCI: Using configuration type 1 for base access
Dec 24 12:54:38 localhost kernel: [    0.120206] ACPI: Interpreter enabled
Dec 24 12:54:38 localhost kernel: [    0.120311] ACPI: (supports S0 S1 S3 S4 S5)
Dec 24 12:54:38 localhost kernel: [    0.120525] ACPI: Using IOAPIC for interrupt routing
Dec 24 12:54:38 localhost kernel: [    0.120676] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Dec 24 12:54:38 localhost kernel: [    0.126271] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
Dec 24 12:54:38 localhost kernel: [    0.135642] PCI: Using MMCONFIG at e0000000 - efffffff
Dec 24 12:54:38 localhost kernel: [    0.146116] ACPI: No dock devices found.
Dec 24 12:54:38 localhost kernel: [    0.146280] ACPI: PCI Root Bridge [PCI0] (0000:00)
Dec 24 12:54:38 localhost kernel: [    0.146409] pci 0000:00:01.1: PME# supported from D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.146982] pci 0000:00:01.1: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.147119] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.147222] pci 0000:00:02.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.147352] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.147455] pci 0000:00:02.1: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.147748] pci 0000:00:06.1: PME# supported from D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.147851] pci 0000:00:06.1: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.148006] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.148110] pci 0000:00:08.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.148256] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.148360] pci 0000:00:09.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.148481] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.148584] pci 0000:00:0a.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.148703] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.148806] pci 0000:00:0b.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.148925] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.148979] pci 0000:00:0c.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.149097] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.149200] pci 0000:00:0d.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.149319] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.149422] pci 0000:00:0e.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.149541] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.149644] pci 0000:00:0f.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.149880] pci 0000:01:04.0: PME# supported from D2 D3hot D3cold
Dec 24 12:54:38 localhost kernel: [    0.149979] pci 0000:01:04.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    0.150101] pci 0000:00:06.0: transparent bridge
Dec 24 12:54:38 localhost kernel: [    0.163095] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
Dec 24 12:54:38 localhost kernel: [    0.163534] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
Dec 24 12:54:38 localhost kernel: [    0.163996] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
Dec 24 12:54:38 localhost kernel: [    0.164453] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *10
Dec 24 12:54:38 localhost kernel: [    0.164891] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
Dec 24 12:54:38 localhost kernel: [    0.165351] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
Dec 24 12:54:38 localhost kernel: [    0.165789] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *11
Dec 24 12:54:38 localhost kernel: [    0.166175] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
Dec 24 12:54:38 localhost kernel: [    0.166634] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *7
Dec 24 12:54:38 localhost kernel: [    0.167113] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *5
Dec 24 12:54:38 localhost kernel: [    0.167490] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *10
Dec 24 12:54:38 localhost kernel: [    0.167908] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *11
Dec 24 12:54:38 localhost kernel: [    0.168272] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *10
Dec 24 12:54:38 localhost kernel: [    0.168691] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
Dec 24 12:54:38 localhost kernel: [    0.169129] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
Dec 24 12:54:38 localhost kernel: [    0.169547] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *11
Dec 24 12:54:38 localhost kernel: [    0.169964] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *5
Dec 24 12:54:38 localhost kernel: [    0.170408] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disabled.
Dec 24 12:54:38 localhost kernel: [    0.170844] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
Dec 24 12:54:38 localhost kernel: [    0.171116] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 5D, should be 55 [20080926]
Dec 24 12:54:38 localhost kernel: [    0.171267] SCSI subsystem initialized
Dec 24 12:54:38 localhost kernel: [    0.172025] usbcore: registered new interface driver usbfs
Dec 24 12:54:38 localhost kernel: [    0.172114] usbcore: registered new interface driver hub
Dec 24 12:54:38 localhost kernel: [    0.172114] usbcore: registered new device driver usb
Dec 24 12:54:38 localhost kernel: [    0.172994] PCI: Using ACPI for IRQ routing
Dec 24 12:54:38 localhost kernel: [    0.177011] Bluetooth: Core ver 2.13
Dec 24 12:54:38 localhost kernel: [    0.177115] NET: Registered protocol family 31
Dec 24 12:54:38 localhost kernel: [    0.177115] Bluetooth: HCI device and connection manager initialized
Dec 24 12:54:38 localhost kernel: [    0.177197] Bluetooth: HCI socket layer initialized
Dec 24 12:54:38 localhost kernel: [    0.180008] cfg80211: Calling CRDA to update world regulatory domain
Dec 24 12:54:38 localhost kernel: [    0.180102] cfg80211: Failed calling CRDA
Dec 24 12:54:38 localhost kernel: [    0.180102] cfg80211: calling CRDA failed - unable to update world regulatory domain, using static definition
Dec 24 12:54:38 localhost kernel: [    0.180273] NetLabel: Initializing
Dec 24 12:54:38 localhost kernel: [    0.180374] NetLabel:  domain hash size = 128
Dec 24 12:54:38 localhost kernel: [    0.180475] NetLabel:  protocols = UNLABELED CIPSOv4
Dec 24 12:54:38 localhost kernel: [    0.180588] NetLabel:  unlabeled traffic allowed by default
Dec 24 12:54:38 localhost kernel: [    0.181049] PCI-DMA: Disabling AGP.
Dec 24 12:54:38 localhost kernel: [    0.181223] PCI-DMA: aperture base @ 20000000 size 65536 KB
Dec 24 12:54:38 localhost kernel: [    0.181223] PCI-DMA: using GART IOMMU.
Dec 24 12:54:38 localhost kernel: [    0.181223] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
Dec 24 12:54:38 localhost kernel: [    0.182053] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
Dec 24 12:54:38 localhost kernel: [    0.182236] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
Dec 24 12:54:38 localhost kernel: [    0.190014] pnp: PnP ACPI init
Dec 24 12:54:38 localhost kernel: [    0.190130] ACPI: bus type pnp registered
Dec 24 12:54:38 localhost kernel: [    0.195584] pnp: PnP ACPI: found 15 devices
Dec 24 12:54:38 localhost kernel: [    0.195686] ACPI: ACPI bus type pnp unregistered
Dec 24 12:54:38 localhost kernel: [    0.195797] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
Dec 24 12:54:38 localhost kernel: [    0.195899] system 00:06: ioport range 0x800-0x80f has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196012] system 00:06: ioport range 0x2000-0x207f has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196115] system 00:06: ioport range 0x2080-0x20ff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196217] system 00:06: ioport range 0x2400-0x247f has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196326] system 00:06: ioport range 0x2480-0x24ff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196429] system 00:06: ioport range 0x2800-0x287f has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196531] system 00:06: ioport range 0x2880-0x28ff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196634] system 00:06: ioport range 0x2c00-0x2c7f has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196737] system 00:06: ioport range 0x2c80-0x2cff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196840] system 00:06: iomem range 0xfe980000-0xfe9bffff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.196943] system 00:06: iomem range 0xfee01000-0xfeefffff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.197057] system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.197160] system 00:08: iomem range 0xfee00000-0xfee00fff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.197271] system 00:0b: ioport range 0xa00-0xa0f has been reserved
Dec 24 12:54:38 localhost kernel: [    0.197373] system 00:0b: ioport range 0xa10-0xa1f has been reserved
Dec 24 12:54:38 localhost kernel: [    0.197477] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.197582] system 00:0d: iomem range 0xd0000000-0xdfffffff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.197687] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
Dec 24 12:54:38 localhost kernel: [    0.197790] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
Dec 24 12:54:38 localhost kernel: [    0.197893] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
Dec 24 12:54:38 localhost kernel: [    0.197996] system 00:0e: iomem range 0x100000-0xbfffffff could not be reserved
Dec 24 12:54:38 localhost kernel: [    0.198187] system 00:0e: iomem range 0xfec00000-0xffffffff could not be reserved
Dec 24 12:54:38 localhost kernel: [    0.203468] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
Dec 24 12:54:38 localhost kernel: [    0.203571] pci 0000:00:06.0:   IO window: 0xd000-0xdfff
Dec 24 12:54:38 localhost kernel: [    0.203675] pci 0000:00:06.0:   MEM window: 0xfea00000-0xfeafffff
Dec 24 12:54:38 localhost kernel: [    0.203778] pci 0000:00:06.0:   PREFETCH window: 0x000000f0000000-0x000000f00fffff
Dec 24 12:54:38 localhost kernel: [    0.203962] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
Dec 24 12:54:38 localhost kernel: [    0.204073] pci 0000:00:0a.0:   IO window: disabled
Dec 24 12:54:38 localhost kernel: [    0.204175] pci 0000:00:0a.0:   MEM window: disabled
Dec 24 12:54:38 localhost kernel: [    0.204283] pci 0000:00:0a.0:   PREFETCH window: disabled
Dec 24 12:54:38 localhost kernel: [    0.204386] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
Dec 24 12:54:38 localhost kernel: [    0.204490] pci 0000:00:0b.0:   IO window: disabled
Dec 24 12:54:38 localhost kernel: [    0.204594] pci 0000:00:0b.0:   MEM window: disabled
Dec 24 12:54:38 localhost kernel: [    0.204696] pci 0000:00:0b.0:   PREFETCH window: disabled
Dec 24 12:54:38 localhost kernel: [    0.204800] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
Dec 24 12:54:38 localhost kernel: [    0.204902] pci 0000:00:0c.0:   IO window: disabled
Dec 24 12:54:38 localhost kernel: [    0.205012] pci 0000:00:0c.0:   MEM window: disabled
Dec 24 12:54:38 localhost kernel: [    0.205114] pci 0000:00:0c.0:   PREFETCH window: disabled
Dec 24 12:54:38 localhost kernel: [    0.205217] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:05
Dec 24 12:54:38 localhost kernel: [    0.205328] pci 0000:00:0d.0:   IO window: disabled
Dec 24 12:54:38 localhost kernel: [    0.205432] pci 0000:00:0d.0:   MEM window: disabled
Dec 24 12:54:38 localhost kernel: [    0.205534] pci 0000:00:0d.0:   PREFETCH window: disabled
Dec 24 12:54:38 localhost kernel: [    0.205638] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:06
Dec 24 12:54:38 localhost kernel: [    0.205742] pci 0000:00:0e.0:   IO window: disabled
Dec 24 12:54:38 localhost kernel: [    0.205845] pci 0000:00:0e.0:   MEM window: disabled
Dec 24 12:54:38 localhost kernel: [    0.205948] pci 0000:00:0e.0:   PREFETCH window: disabled
Dec 24 12:54:38 localhost kernel: [    0.206060] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:07
Dec 24 12:54:38 localhost kernel: [    0.206163] pci 0000:00:0f.0:   IO window: 0xe000-0xefff
Dec 24 12:54:38 localhost kernel: [    0.206270] pci 0000:00:0f.0:   MEM window: 0xfeb00000-0xfebfffff
Dec 24 12:54:38 localhost kernel: [    0.206377] pci 0000:00:0f.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
Dec 24 12:54:38 localhost kernel: [    0.206591] bus: 00 index 0 io port: [0x00-0xffff]
Dec 24 12:54:38 localhost kernel: [    0.206693] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
Dec 24 12:54:38 localhost kernel: [    0.206795] bus: 01 index 0 io port: [0xd000-0xdfff]
Dec 24 12:54:38 localhost kernel: [    0.206897] bus: 01 index 1 mmio: [0xfea00000-0xfeafffff]
Dec 24 12:54:38 localhost kernel: [    0.207008] bus: 01 index 2 mmio: [0xf0000000-0xf00fffff]
Dec 24 12:54:38 localhost kernel: [    0.207110] bus: 01 index 3 io port: [0x00-0xffff]
Dec 24 12:54:38 localhost kernel: [    0.207212] bus: 01 index 4 mmio: [0x000000-0xffffffffffffffff]
Dec 24 12:54:38 localhost kernel: [    0.207320] bus: 02 index 0 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.207421] bus: 02 index 1 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.207523] bus: 02 index 2 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.207624] bus: 02 index 3 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.207725] bus: 03 index 0 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.207826] bus: 03 index 1 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.207927] bus: 03 index 2 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208036] bus: 03 index 3 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208138] bus: 04 index 0 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208239] bus: 04 index 1 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208345] bus: 04 index 2 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208446] bus: 04 index 3 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208547] bus: 05 index 0 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208648] bus: 05 index 1 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208749] bus: 05 index 2 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208850] bus: 05 index 3 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.208952] bus: 06 index 0 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.209061] bus: 06 index 1 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.209162] bus: 06 index 2 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.209268] bus: 06 index 3 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.209370] bus: 07 index 0 io port: [0xe000-0xefff]
Dec 24 12:54:38 localhost kernel: [    0.209472] bus: 07 index 1 mmio: [0xfeb00000-0xfebfffff]
Dec 24 12:54:38 localhost kernel: [    0.209574] bus: 07 index 2 mmio: [0xc0000000-0xcfffffff]
Dec 24 12:54:38 localhost kernel: [    0.209676] bus: 07 index 3 mmio: [0x0-0x0]
Dec 24 12:54:38 localhost kernel: [    0.209788] NET: Registered protocol family 2
Dec 24 12:54:38 localhost kernel: [    0.219060] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
Dec 24 12:54:38 localhost kernel: [    0.220944] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Dec 24 12:54:38 localhost kernel: [    0.223613] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Dec 24 12:54:38 localhost kernel: [    0.224326] TCP: Hash tables configured (established 262144 bind 65536)
Dec 24 12:54:38 localhost kernel: [    0.224430] TCP reno registered
Dec 24 12:54:38 localhost kernel: [    0.227097] NET: Registered protocol family 1
Dec 24 12:54:38 localhost kernel: [    0.227320] checking if image is initramfs... it is
Dec 24 12:54:38 localhost kernel: [    0.400188] Freeing initrd memory: 3630k freed
Dec 24 12:54:38 localhost kernel: [    0.404025] alg: cipher: Test 1 failed on encryption for aes-asm
Dec 24 12:54:38 localhost kernel: [    0.404130] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
Dec 24 12:54:38 localhost kernel: [    0.404708] audit: initializing netlink socket (disabled)
Dec 24 12:54:38 localhost kernel: [    0.404822] type=2000 audit(1230119634.404:1): initialized
Dec 24 12:54:38 localhost kernel: [    0.409377] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Dec 24 12:54:38 localhost kernel: [    0.412628] VFS: Disk quotas dquot_6.5.1
Dec 24 12:54:38 localhost kernel: [    0.412812] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Dec 24 12:54:38 localhost kernel: [    0.414380] NTFS driver 2.1.29 [Flags: R/O].
Dec 24 12:54:38 localhost kernel: [    0.414619] fuse init (API version 7.10)
Dec 24 12:54:38 localhost kernel: [    0.415152] JFS: nTxBlock = 8192, nTxLock = 65536
Dec 24 12:54:38 localhost kernel: [    0.418686] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
Dec 24 12:54:38 localhost kernel: [    0.419754] SGI XFS Quota Management subsystem
Dec 24 12:54:38 localhost kernel: [    0.419863] msgmni has been set to 11912
Dec 24 12:54:38 localhost kernel: [    0.420244] alg: No test for cipher_null (cipher_null-generic)
Dec 24 12:54:38 localhost kernel: [    0.420434] alg: No test for digest_null (digest_null-generic)
Dec 24 12:54:38 localhost kernel: [    0.420578] alg: No test for compress_null (compress_null-generic)
Dec 24 12:54:38 localhost kernel: [    0.421589] alg: No test for fcrypt (fcrypt-generic)
Dec 24 12:54:38 localhost kernel: [    0.423743] alg: No test for stdrng (krng)
Dec 24 12:54:38 localhost kernel: [    0.423850] async_tx: api initialized (sync-only)
Dec 24 12:54:38 localhost kernel: [    0.424158] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Dec 24 12:54:38 localhost kernel: [    0.424346] io scheduler noop registered
Dec 24 12:54:38 localhost kernel: [    0.424447] io scheduler anticipatory registered
Dec 24 12:54:38 localhost kernel: [    0.424548] io scheduler deadline registered (default)
Dec 24 12:54:38 localhost kernel: [    0.424722] io scheduler cfq registered
Dec 24 12:54:38 localhost kernel: [    0.424849] pci 0000:00:00.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.447054] pci 0000:00:05.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.447167] pci 0000:00:05.1: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.447285] pci 0000:00:05.2: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.447396] pci 0000:00:06.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.447509] pci 0000:00:06.1: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.447624] pci 0000:00:08.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.449782] pci 0000:00:09.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.449894] pci 0000:00:0a.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.450014] pci 0000:00:0b.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.450127] pci 0000:00:0c.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.450240] pci 0000:00:0d.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.450356] pci 0000:00:0e.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.450469] pci 0000:00:0f.0: Enabling HT MSI Mapping
Dec 24 12:54:38 localhost kernel: [    0.456487] pcieport-driver 0000:00:0a.0: found MSI capability
Dec 24 12:54:38 localhost kernel: [    0.456742] pcieport-driver 0000:00:0b.0: found MSI capability
Dec 24 12:54:38 localhost kernel: [    0.456992] pcieport-driver 0000:00:0c.0: found MSI capability
Dec 24 12:54:38 localhost kernel: [    0.457249] pcieport-driver 0000:00:0d.0: found MSI capability
Dec 24 12:54:38 localhost kernel: [    0.457502] pcieport-driver 0000:00:0e.0: found MSI capability
Dec 24 12:54:38 localhost kernel: [    0.457751] pcieport-driver 0000:00:0f.0: found MSI capability
Dec 24 12:54:38 localhost kernel: [    0.458092] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Dec 24 12:54:38 localhost kernel: [    0.458195] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Dec 24 12:54:38 localhost kernel: [    0.466243] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
Dec 24 12:54:38 localhost kernel: [    0.466398] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Dec 24 12:54:38 localhost kernel: [    0.466501] fakephp: Fake PCI Hot Plug Controller Driver
Dec 24 12:54:38 localhost kernel: [    0.468037] input: Power Button (FF) as /class/input/input0
Dec 24 12:54:38 localhost kernel: [    0.468140] ACPI: Power Button (FF) [PWRF]
Dec 24 12:54:38 localhost kernel: [    0.468342] input: Power Button (CM) as /class/input/input1
Dec 24 12:54:38 localhost kernel: [    0.468444] ACPI: Power Button (CM) [PWRB]
Dec 24 12:54:38 localhost kernel: [    0.469000] processor ACPI_CPU:00: registered as cooling_device0
Dec 24 12:54:38 localhost kernel: [    0.469181] processor ACPI_CPU:01: registered as cooling_device1
Dec 24 12:54:38 localhost kernel: [    0.483872] lp: driver loaded but no devices found
Dec 24 12:54:38 localhost kernel: [    0.484338] Non-volatile memory driver v1.2
Dec 24 12:54:38 localhost kernel: [    0.485157] ppdev: user-space parallel port driver
Dec 24 12:54:38 localhost kernel: [    0.485265] Linux agpgart interface v0.103
Dec 24 12:54:38 localhost kernel: [    0.485504] ipmi message handler version 39.2
Dec 24 12:54:38 localhost kernel: [    0.485610] ipmi device interface
Dec 24 12:54:38 localhost kernel: [    0.485810] IPMI System Interface driver.
Dec 24 12:54:38 localhost kernel: [    0.496117] ipmi_si: Unable to find any System Interface(s)
Dec 24 12:54:38 localhost kernel: [    0.496221] IPMI Watchdog: driver initialized
Dec 24 12:54:38 localhost kernel: [    0.496328] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
Dec 24 12:54:38 localhost kernel: [    0.496519] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Dec 24 12:54:38 localhost kernel: [    0.496701] Hangcheck: Using get_cycles().
Dec 24 12:54:38 localhost kernel: [    0.496856] [drm] Initialized drm 1.1.0 20060810
Dec 24 12:54:38 localhost kernel: [    0.497430] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
Dec 24 12:54:38 localhost kernel: [    0.498607] Floppy drive(s): fd0 is 1.44M
Dec 24 12:54:38 localhost kernel: [    0.512608] FDC 0 is a post-1991 82077
Dec 24 12:54:38 localhost kernel: [    0.515561] brd: module loaded
Dec 24 12:54:38 localhost kernel: [    0.516688] loop: module loaded
Dec 24 12:54:38 localhost kernel: [    0.517060] nbd: registered device at major 43
Dec 24 12:54:38 localhost kernel: [    0.519142] Ethernet Channel Bonding Driver: v3.3.0 (June 10, 2008)
Dec 24 12:54:38 localhost kernel: [    0.519246] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
Dec 24 12:54:38 localhost kernel: [    0.519806] PPP generic driver version 2.4.2
Dec 24 12:54:38 localhost kernel: [    0.520087] PPP Deflate Compression module registered
Dec 24 12:54:38 localhost kernel: [    0.520956] PPP MPPE Compression module registered
Dec 24 12:54:38 localhost kernel: [    0.521099] NET: Registered protocol family 24
Dec 24 12:54:38 localhost kernel: [    0.521924] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
Dec 24 12:54:38 localhost kernel: [    0.522351] tun: Universal TUN/TAP device driver, 1.6
Dec 24 12:54:38 localhost kernel: [    0.522455] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Dec 24 12:54:38 localhost kernel: [    0.522620] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
Dec 24 12:54:38 localhost kernel: [    0.523057] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <johns393@maroon.tc.umn.edu>
Dec 24 12:54:38 localhost kernel: [    0.523299] usbcore: registered new interface driver cdc_ether
Dec 24 12:54:38 localhost kernel: [    0.523446] usbcore: registered new interface driver rndis_host
Dec 24 12:54:38 localhost kernel: [    0.523572] console [netcon0] enabled
Dec 24 12:54:38 localhost kernel: [    0.523673] netconsole: network logging started
Dec 24 12:54:38 localhost kernel: [    0.523775] Linux video capture interface: v2.00
Dec 24 12:54:38 localhost kernel: [    0.524011] usbcore: registered new interface driver uvcvideo
Dec 24 12:54:38 localhost kernel: [    0.524114] USB Video Class driver (v0.1.0)
Dec 24 12:54:38 localhost kernel: [    0.524806] Loading iSCSI transport class v2.0-870.
Dec 24 12:54:38 localhost kernel: [    0.525621] rdac: device handler registered
Dec 24 12:54:38 localhost kernel: [    0.525722] hp_sw: device handler registered
Dec 24 12:54:38 localhost kernel: [    0.525823] emc: device handler registered
Dec 24 12:54:38 localhost kernel: [    0.525925] st: Version 20080504, fixed bufsize 32768, s/g segs 256
Dec 24 12:54:38 localhost kernel: [    0.526085] Driver 'st' needs updating - please use bus_type methods
Dec 24 12:54:38 localhost kernel: [    0.526241] osst :I: Tape driver with OnStream support version 0.99.4
Dec 24 12:54:38 localhost kernel: [    0.526242] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
Dec 24 12:54:38 localhost kernel: [    0.526495] Driver 'osst' needs updating - please use bus_type methods
Dec 24 12:54:38 localhost kernel: [    0.526683] Driver 'sd' needs updating - please use bus_type methods
Dec 24 12:54:38 localhost kernel: [    0.526828] Driver 'sr' needs updating - please use bus_type methods
Dec 24 12:54:38 localhost kernel: [    0.527030] SCSI Media Changer driver v0.25 
Dec 24 12:54:38 localhost kernel: [    0.527181] Driver 'ch' needs updating - please use bus_type methods
Dec 24 12:54:38 localhost kernel: [    0.527754] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
Dec 24 12:54:38 localhost kernel: [    0.527864] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
Dec 24 12:54:38 localhost kernel: [    0.528058] sata_nv 0000:00:05.0: Using SWNCQ mode
Dec 24 12:54:38 localhost kernel: [    0.528516] scsi0 : sata_nv
Dec 24 12:54:38 localhost kernel: [    0.528750] scsi1 : sata_nv
Dec 24 12:54:38 localhost kernel: [    0.529093] ata1: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xbc00 irq 23
Dec 24 12:54:38 localhost kernel: [    0.529198] ata2: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xbc08 irq 23
Dec 24 12:54:38 localhost kernel: [    0.983053] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Dec 24 12:54:38 localhost kernel: [    0.986115] ata1.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/66
Dec 24 12:54:38 localhost kernel: [    0.992123] ata1.00: configured for UDMA/66
Dec 24 12:54:38 localhost kernel: [    1.301093] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215  1.18 PQ: 0 ANSI: 5
Dec 24 12:54:38 localhost kernel: [    1.343126] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
Dec 24 12:54:38 localhost kernel: [    1.343316] Uniform CD-ROM driver Revision: 3.20
Dec 24 12:54:38 localhost kernel: [    1.343739] sr 0:0:0:0: Attached scsi generic sg0 type 5
Dec 24 12:54:38 localhost kernel: [    1.344271] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
Dec 24 12:54:38 localhost kernel: [    1.344381] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 (level, low) -> IRQ 22
Dec 24 12:54:38 localhost kernel: [    1.344564] sata_nv 0000:00:05.1: Using SWNCQ mode
Dec 24 12:54:38 localhost kernel: [    1.345015] scsi2 : sata_nv
Dec 24 12:54:38 localhost kernel: [    1.345232] scsi3 : sata_nv
Dec 24 12:54:38 localhost kernel: [    1.345509] ata3: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb080 irq 22
Dec 24 12:54:38 localhost kernel: [    1.345614] ata4: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xb088 irq 22
Dec 24 12:54:38 localhost kernel: [    1.799035] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec 24 12:54:38 localhost kernel: [    1.802297] ata3.00: ATA-7: Hitachi HDT725032VLA360, V54OA7EA, max UDMA/133
Dec 24 12:54:38 localhost kernel: [    1.802401] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
Dec 24 12:54:38 localhost kernel: [    1.808294] ata3.00: configured for UDMA/133
Dec 24 12:54:38 localhost kernel: [    2.122090] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDT72503 V54O PQ: 0 ANSI: 5
Dec 24 12:54:38 localhost kernel: [    2.122451] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
Dec 24 12:54:38 localhost kernel: [    2.122646] sd 2:0:0:0: [sda] Write Protect is off
Dec 24 12:54:38 localhost kernel: [    2.122769] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 24 12:54:38 localhost kernel: [    2.123018] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
Dec 24 12:54:38 localhost kernel: [    2.123211] sd 2:0:0:0: [sda] Write Protect is off
Dec 24 12:54:38 localhost kernel: [    2.123341] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 24 12:54:38 localhost kernel: [    2.123525]  sda: sda1 sda2 sda3 sda4
Dec 24 12:54:38 localhost kernel: [    2.151711] sd 2:0:0:0: [sda] Attached SCSI disk
Dec 24 12:54:38 localhost kernel: [    2.151927] sd 2:0:0:0: Attached scsi generic sg1 type 0
Dec 24 12:54:38 localhost kernel: [    2.152423] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
Dec 24 12:54:38 localhost kernel: [    2.152533] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 (level, low) -> IRQ 21
Dec 24 12:54:38 localhost kernel: [    2.152716] sata_nv 0000:00:05.2: Using SWNCQ mode
Dec 24 12:54:38 localhost kernel: [    2.153173] scsi4 : sata_nv
Dec 24 12:54:38 localhost kernel: [    2.153389] scsi5 : sata_nv
Dec 24 12:54:38 localhost kernel: [    2.153659] ata5: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480 irq 21
Dec 24 12:54:38 localhost kernel: [    2.153764] ata6: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488 irq 21
Dec 24 12:54:38 localhost kernel: [    2.759231] scsi6 : pata_amd
Dec 24 12:54:38 localhost kernel: [    2.759435] scsi7 : pata_amd
Dec 24 12:54:38 localhost kernel: [    2.760719] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
Dec 24 12:54:38 localhost kernel: [    2.760823] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Dec 24 12:54:38 localhost kernel: [    2.922394] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 19
Dec 24 12:54:38 localhost kernel: [    2.922504] firewire_ohci 0000:01:04.0: PCI INT A -> Link[LNKD] -> GSI 19 (level, low) -> IRQ 19
Dec 24 12:54:38 localhost kernel: [    2.979014] firewire_ohci: Added fw-ohci device 0000:01:04.0, OHCI version 1.10
Dec 24 12:54:38 localhost kernel: [    2.979659] SSFDC read-only Flash Translation layer
Dec 24 12:54:38 localhost kernel: [    2.979839] slram: not enough parameters.
Dec 24 12:54:38 localhost kernel: [    2.979943] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Dec 24 12:54:38 localhost kernel: [    2.980359] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
Dec 24 12:54:38 localhost kernel: [    2.980463] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
Dec 24 12:54:38 localhost kernel: [    2.980657] ehci_hcd 0000:00:02.1: EHCI Host Controller
Dec 24 12:54:38 localhost kernel: [    2.980834] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
Dec 24 12:54:38 localhost kernel: [    2.981043] ehci_hcd 0000:00:02.1: debug port 1
Dec 24 12:54:38 localhost kernel: [    2.981152] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe9fac00
Dec 24 12:54:38 localhost kernel: [    2.987015] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
Dec 24 12:54:38 localhost kernel: [    2.987247] usb usb1: configuration #1 chosen from 1 choice
Dec 24 12:54:38 localhost kernel: [    2.987419] hub 1-0:1.0: USB hub found
Dec 24 12:54:38 localhost kernel: [    2.987525] hub 1-0:1.0: 10 ports detected
Dec 24 12:54:38 localhost kernel: [    2.987858] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Dec 24 12:54:38 localhost kernel: [    2.988246] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
Dec 24 12:54:38 localhost kernel: [    2.988362] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
Dec 24 12:54:38 localhost kernel: [    2.988556] ohci_hcd 0000:00:02.0: OHCI Host Controller
Dec 24 12:54:38 localhost kernel: [    2.988712] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
Dec 24 12:54:38 localhost kernel: [    2.988906] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe9fb000
Dec 24 12:54:38 localhost kernel: [    3.041109] usb usb2: configuration #1 chosen from 1 choice
Dec 24 12:54:38 localhost kernel: [    3.041269] hub 2-0:1.0: USB hub found
Dec 24 12:54:38 localhost kernel: [    3.041376] hub 2-0:1.0: 10 ports detected
Dec 24 12:54:38 localhost kernel: [    3.041671] uhci_hcd: USB Universal Host Controller Interface driver
Dec 24 12:54:38 localhost kernel: [    3.041899] usbcore: registered new interface driver cdc_acm
Dec 24 12:54:38 localhost kernel: [    3.042003] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
Dec 24 12:54:38 localhost kernel: [    3.042233] usbcore: registered new interface driver usblp
Dec 24 12:54:38 localhost kernel: [    3.042381] usbcore: registered new interface driver cdc_wdm
Dec 24 12:54:38 localhost kernel: [    3.042484] Initializing USB Mass Storage driver...
Dec 24 12:54:38 localhost kernel: [    3.042637] usbcore: registered new interface driver usb-storage
Dec 24 12:54:38 localhost kernel: [    3.042740] USB Mass Storage support registered.
Dec 24 12:54:38 localhost kernel: [    3.042943] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Dec 24 12:54:38 localhost kernel: [    3.045719] serio: i8042 KBD port at 0x60,0x64 irq 1
Dec 24 12:54:38 localhost kernel: [    3.047850] serio: i8042 AUX port at 0x60,0x64 irq 12
Dec 24 12:54:38 localhost kernel: [    3.048031] mice: PS/2 mouse device common for all mice
Dec 24 12:54:38 localhost kernel: [    3.054484] input: PC Speaker as /class/input/input2
Dec 24 12:54:38 localhost kernel: [    3.060397] rtc_cmos 00:02: RTC can wake from S4
Dec 24 12:54:38 localhost kernel: [    3.060576] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
Dec 24 12:54:38 localhost kernel: [    3.060709] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
Dec 24 12:54:38 localhost kernel: [    3.060860] i2c /dev entries driver
Dec 24 12:54:38 localhost kernel: [    3.061261] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
Dec 24 12:54:38 localhost kernel: [    3.061478] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
Dec 24 12:54:38 localhost kernel: [    3.061799] w83627ehf: Found W83627EHG chip at 0xa10
Dec 24 12:54:38 localhost kernel: [    3.062282] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
Dec 24 12:54:38 localhost kernel: [    3.062485] w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
Dec 24 12:54:38 localhost kernel: [    3.062735] w83627hf/thf/hg WDT: initialized. timeout=60 sec (nowayout=0)
Dec 24 12:54:38 localhost kernel: [    3.062839] md: linear personality registered for level -1
Dec 24 12:54:38 localhost kernel: [    3.062941] md: raid0 personality registered for level 0
Dec 24 12:54:38 localhost kernel: [    3.063050] md: raid1 personality registered for level 1
Dec 24 12:54:38 localhost kernel: [    3.063152] md: raid10 personality registered for level 10
Dec 24 12:54:38 localhost kernel: [    3.080028] raid6: int64x1   2304 MB/s
Dec 24 12:54:38 localhost kernel: [    3.097018] raid6: int64x2   3218 MB/s
Dec 24 12:54:38 localhost kernel: [    3.114005] raid6: int64x4   2324 MB/s
Dec 24 12:54:38 localhost kernel: [    3.131028] raid6: int64x8   2363 MB/s
Dec 24 12:54:38 localhost kernel: [    3.148018] raid6: sse2x1    3578 MB/s
Dec 24 12:54:38 localhost kernel: [    3.165011] raid6: sse2x2    4566 MB/s
Dec 24 12:54:38 localhost kernel: [    3.182010] raid6: sse2x4    4972 MB/s
Dec 24 12:54:38 localhost kernel: [    3.182111] raid6: using algorithm sse2x4 (4972 MB/s)
Dec 24 12:54:38 localhost kernel: [    3.182214] md: raid6 personality registered for level 6
Dec 24 12:54:38 localhost kernel: [    3.182323] md: raid5 personality registered for level 5
Dec 24 12:54:38 localhost kernel: [    3.182425] md: raid4 personality registered for level 4
Dec 24 12:54:38 localhost kernel: [    3.182527] md: multipath personality registered for level -4
Dec 24 12:54:38 localhost kernel: [    3.182629] md: faulty personality registered for level -5
Dec 24 12:54:38 localhost kernel: [    3.182854] device-mapper: uevent: version 1.0.3
Dec 24 12:54:38 localhost kernel: [    3.183067] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Dec 24 12:54:38 localhost kernel: [    3.183379] Bluetooth: Virtual HCI driver ver 1.2
Dec 24 12:54:38 localhost kernel: [    3.183539] Bluetooth: HCI UART driver ver 2.2
Dec 24 12:54:38 localhost kernel: [    3.183641] Bluetooth: HCI H4 protocol initialized
Dec 24 12:54:38 localhost kernel: [    3.183742] Bluetooth: HCI BCSP protocol initialized
Dec 24 12:54:38 localhost kernel: [    3.183844] Bluetooth: HCILL protocol initialized
Dec 24 12:54:38 localhost kernel: [    3.183945] Bluetooth: Broadcom Blutonium firmware driver ver 1.2
Dec 24 12:54:38 localhost kernel: [    3.184107] usbcore: registered new interface driver bcm203x
Dec 24 12:54:38 localhost kernel: [    3.184210] Bluetooth: Digianswer Bluetooth USB driver ver 0.10
Dec 24 12:54:38 localhost kernel: [    3.184385] usbcore: registered new interface driver bpa10x
Dec 24 12:54:38 localhost kernel: [    3.184488] Bluetooth: BlueFRITZ! USB driver ver 1.2
Dec 24 12:54:38 localhost kernel: [    3.184630] usbcore: registered new interface driver bfusb
Dec 24 12:54:38 localhost kernel: [    3.184733] Bluetooth: Generic Bluetooth USB driver ver 0.3
Dec 24 12:54:38 localhost kernel: [    3.184878] usbcore: registered new interface driver btusb
Dec 24 12:54:38 localhost kernel: [    3.184981] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
Dec 24 12:54:38 localhost kernel: [    3.185191] cpuidle: using governor ladder
Dec 24 12:54:38 localhost kernel: [    3.185300] cpuidle: using governor menu
Dec 24 12:54:38 localhost kernel: [    3.185524] sdhci: Secure Digital Host Controller Interface driver
Dec 24 12:54:38 localhost kernel: [    3.185626] sdhci: Copyright(c) Pierre Ossman
Dec 24 12:54:38 localhost kernel: [    3.185784] ricoh-mmc: Ricoh MMC Controller disabling driver
Dec 24 12:54:38 localhost kernel: [    3.185886] ricoh-mmc: Copyright(c) Philip Langdale
Dec 24 12:54:38 localhost kernel: [    3.186041] wbsd: Winbond W83L51xD SD/MMC card interface driver
Dec 24 12:54:38 localhost kernel: [    3.186143] wbsd: Copyright(c) Pierre Ossman
Dec 24 12:54:38 localhost kernel: [    3.187448] usbcore: registered new interface driver hiddev
Dec 24 12:54:38 localhost kernel: [    3.187598] usbcore: registered new interface driver usbhid
Dec 24 12:54:38 localhost kernel: [    3.187701] usbhid: v2.6:USB HID core driver
Dec 24 12:54:38 localhost kernel: [    3.187865] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
Dec 24 12:54:38 localhost kernel: [    3.189237] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
Dec 24 12:54:38 localhost kernel: [    3.189349] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
Dec 24 12:54:38 localhost kernel: [    3.384021] usb 1-4: new high speed USB device using ehci_hcd and address 2
Dec 24 12:54:38 localhost kernel: [    3.399842] ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 18
Dec 24 12:54:38 localhost kernel: [    3.399954] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 18 (level, low) -> IRQ 18
Dec 24 12:54:38 localhost kernel: [    3.425285] ALSA device list:
Dec 24 12:54:38 localhost kernel: [    3.425386]   #0: Dummy 1
Dec 24 12:54:38 localhost kernel: [    3.425486]   #1: Virtual MIDI Card 1
Dec 24 12:54:38 localhost kernel: [    3.425587]   #2: HDA NVidia at 0xfe9f0000 irq 21
Dec 24 12:54:38 localhost kernel: [    3.425689]   #3: HDA ATI HDMI at 0xfebec000 irq 18
Dec 24 12:54:38 localhost kernel: [    3.425872] oprofile: using NMI interrupt.
Dec 24 12:54:38 localhost kernel: [    3.426119] GACT probability on
Dec 24 12:54:38 localhost kernel: [    3.426220] Mirror/redirect action on
Dec 24 12:54:38 localhost kernel: [    3.426328] Simple TC action Loaded
Dec 24 12:54:38 localhost kernel: [    3.426721] netem: version 1.2
Dec 24 12:54:38 localhost kernel: [    3.426822] u32 classifier
Dec 24 12:54:38 localhost kernel: [    3.426922]     Performance counters on
Dec 24 12:54:38 localhost kernel: [    3.427030]     input device check on 
Dec 24 12:54:38 localhost kernel: [    3.427130]     Actions configured 
Dec 24 12:54:38 localhost kernel: [    3.427233] Netfilter messages via NETLINK v0.30.
Dec 24 12:54:38 localhost kernel: [    3.427358] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Dec 24 12:54:38 localhost kernel: [    3.427626] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Dec 24 12:54:38 localhost kernel: [    3.427808] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
Dec 24 12:54:38 localhost kernel: [    3.427990] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Dec 24 12:54:38 localhost kernel: [    3.428358] IPVS: Registered protocols (TCP, UDP, AH, ESP)
Dec 24 12:54:38 localhost kernel: [    3.428485] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
Dec 24 12:54:38 localhost kernel: [    3.428706] IPVS: ipvs loaded.
Dec 24 12:54:38 localhost kernel: [    3.428807] IPVS: [rr] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.428907] IPVS: [wrr] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429017] IPVS: [lc] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429118] IPVS: [wlc] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429233] IPVS: [lblc] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429352] IPVS: [lblcr] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429454] IPVS: [dh] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429555] IPVS: [sh] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429656] IPVS: [sed] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429757] IPVS: [nq] scheduler registered.
Dec 24 12:54:38 localhost kernel: [    3.429859] IPVS: ftp: loaded support on port[0] = 21
Dec 24 12:54:38 localhost kernel: [    3.430367] IPv4 over IPv4 tunneling driver
Dec 24 12:54:38 localhost kernel: [    3.430826] GRE over IPv4 tunneling driver
Dec 24 12:54:38 localhost kernel: [    3.431510] ip_tables: (C) 2000-2006 Netfilter Core Team
Dec 24 12:54:38 localhost kernel: [    3.431633] ClusterIP Version 0.8 loaded successfully
Dec 24 12:54:38 localhost kernel: [    3.431751] arp_tables: (C) 2002 David S. Miller
Dec 24 12:54:38 localhost kernel: [    3.431880] TCP bic registered
Dec 24 12:54:38 localhost kernel: [    3.431981] TCP cubic registered
Dec 24 12:54:38 localhost kernel: [    3.432091] TCP westwood registered
Dec 24 12:54:38 localhost kernel: [    3.432192] TCP highspeed registered
Dec 24 12:54:38 localhost kernel: [    3.432300] TCP hybla registered
Dec 24 12:54:38 localhost kernel: [    3.432400] TCP htcp registered
Dec 24 12:54:38 localhost kernel: [    3.432501] TCP vegas registered
Dec 24 12:54:38 localhost kernel: [    3.432602] TCP veno registered
Dec 24 12:54:38 localhost kernel: [    3.432702] TCP scalable registered
Dec 24 12:54:38 localhost kernel: [    3.432803] TCP lp registered
Dec 24 12:54:38 localhost kernel: [    3.432903] TCP yeah registered
Dec 24 12:54:38 localhost kernel: [    3.433011] TCP illinois registered
Dec 24 12:54:38 localhost kernel: [    3.433112] Initializing XFRM netlink socket
Dec 24 12:54:38 localhost kernel: [    3.433358] NET: Registered protocol family 10
Dec 24 12:54:38 localhost kernel: [    3.434079] lo: Disabled Privacy Extensions
Dec 24 12:54:38 localhost kernel: [    3.436277] tunl0: Disabled Privacy Extensions
Dec 24 12:54:38 localhost kernel: [    3.437359] Mobile IPv6
Dec 24 12:54:38 localhost kernel: [    3.437469] ip6_tables: (C) 2000-2006 Netfilter Core Team
Dec 24 12:54:38 localhost kernel: [    3.437668] IPv6 over IPv4 tunneling driver
Dec 24 12:54:38 localhost kernel: [    3.438305] sit0: Disabled Privacy Extensions
Dec 24 12:54:38 localhost kernel: [    3.439366] ip6tnl0: Disabled Privacy Extensions
Dec 24 12:54:38 localhost kernel: [    3.439933] NET: Registered protocol family 17
Dec 24 12:54:38 localhost kernel: [    3.440050] NET: Registered protocol family 15
Dec 24 12:54:38 localhost kernel: [    3.440220] Bridge firewalling registered
Dec 24 12:54:38 localhost kernel: [    3.440331] Ebtables v2.0 registered
Dec 24 12:54:38 localhost kernel: [    3.440475] ebt_ulog: out of memory trying to call netlink_kernel_create
Dec 24 12:54:38 localhost kernel: [    3.440578] NET: Registered protocol family 5
Dec 24 12:54:38 localhost kernel: [    3.447061] Bluetooth: L2CAP ver 2.11
Dec 24 12:54:38 localhost kernel: [    3.447162] Bluetooth: L2CAP socket layer initialized
Dec 24 12:54:38 localhost kernel: [    3.447270] Bluetooth: SCO (Voice Link) ver 0.6
Dec 24 12:54:38 localhost kernel: [    3.447371] Bluetooth: SCO socket layer initialized
Dec 24 12:54:38 localhost kernel: [    3.447526] Bluetooth: RFCOMM socket layer initialized
Dec 24 12:54:38 localhost kernel: [    3.447639] Bluetooth: RFCOMM TTY layer initialized
Dec 24 12:54:38 localhost kernel: [    3.447740] Bluetooth: RFCOMM ver 1.10
Dec 24 12:54:38 localhost kernel: [    3.447841] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Dec 24 12:54:38 localhost kernel: [    3.447942] Bluetooth: BNEP filters: protocol multicast
Dec 24 12:54:38 localhost kernel: [    3.448054] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Dec 24 12:54:38 localhost kernel: [    3.448222] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
Dec 24 12:54:38 localhost kernel: [    3.448331] All bugs added by David S. Miller <davem@redhat.com>
Dec 24 12:54:38 localhost kernel: [    3.458546] DCCP watch registered (port=0)
Dec 24 12:54:38 localhost kernel: [    3.458672] CCID: Registered CCID 3 (TCP-Friendly Rate Control)
Dec 24 12:54:38 localhost kernel: [    3.458858] CCID: Registered CCID 2 (TCP-like)
Dec 24 12:54:38 localhost kernel: [    3.460136] SCTP: Hash tables configured (established 65536 bind 65536)
Dec 24 12:54:38 localhost kernel: [    3.467142] TIPC: Activated (version 1.6.4 compiled Dec 19 2008 21:02:01)
Dec 24 12:54:38 localhost kernel: [    3.467461] NET: Registered protocol family 30
Dec 24 12:54:38 localhost kernel: [    3.467563] TIPC: Started in single node mode
Dec 24 12:54:38 localhost kernel: [    3.467679] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ processors (2 cpu cores) (version 2.20.00)
Dec 24 12:54:38 localhost kernel: [    3.467927] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
Dec 24 12:54:38 localhost kernel: [    3.468037] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
Dec 24 12:54:38 localhost kernel: [    3.468139] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
Dec 24 12:54:38 localhost kernel: [    3.468241] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
Dec 24 12:54:38 localhost kernel: [    3.468348] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
Dec 24 12:54:38 localhost kernel: [    3.468450] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
Dec 24 12:54:38 localhost kernel: [    3.468884] PM: test RTC wakeup from 'mem' suspend
Dec 24 12:54:38 localhost kernel: [    3.468986] PM: Syncing filesystems ... done.
Dec 24 12:54:38 localhost kernel: [    3.471230] Freezing user space processes ... (elapsed 0.00 seconds) done.
Dec 24 12:54:38 localhost kernel: [    3.471309] Freezing remaining freezable tasks ... <7>PM: Adding info for firewire:fw0
Dec 24 12:54:38 localhost kernel: [    3.491099] firewire_core: created device fw0: GUID 0010dc0000cf25c6, S400
Dec 24 12:54:38 localhost kernel: [    3.500949] usb 1-4: configuration #1 chosen from 1 choice
Dec 24 12:54:38 localhost kernel: [    3.605262] usb 1-6: new high speed USB device using ehci_hcd and address 3
Dec 24 12:54:38 localhost kernel: [    3.719693] usb 1-6: configuration #1 chosen from 1 choice
Dec 24 12:54:38 localhost kernel: [    3.719804] hub 1-6:1.0: USB hub found
Dec 24 12:54:38 localhost kernel: [    3.719904] hub 1-6:1.0: 4 ports detected
Dec 24 12:54:38 localhost kernel: [    3.720821] (elapsed 0.24 seconds) done.
Dec 24 12:54:38 localhost kernel: [    3.720888] Suspending console(s) (use no_console_suspend to debug)
Dec 24 12:54:38 localhost kernel: [    3.743174] sd 2:0:0:0: [sda] Synchronizing SCSI cache
Dec 24 12:54:38 localhost kernel: [    3.743314] sd 2:0:0:0: [sda] Stopping disk
Dec 24 12:54:38 localhost kernel: [    4.129032] HDA Intel 0000:07:00.1: PCI INT B disabled
Dec 24 12:54:38 localhost kernel: [    4.162028] HDA Intel 0000:00:06.1: PCI INT B disabled
Dec 24 12:54:38 localhost kernel: [    4.779037] sata_nv 0000:00:05.2: PCI INT C disabled
Dec 24 12:54:38 localhost kernel: [    5.093037] sata_nv 0000:00:05.1: PCI INT B disabled
Dec 24 12:54:38 localhost kernel: [    5.407029] sata_nv 0000:00:05.0: PCI INT A disabled
Dec 24 12:54:38 localhost kernel: [    5.429031] ehci_hcd 0000:00:02.1: PCI INT B disabled
Dec 24 12:54:38 localhost kernel: [    5.440029] ohci_hcd 0000:00:02.0: PCI INT A disabled
Dec 24 12:54:38 localhost kernel: [    5.451015] ohci_hcd 0000:00:02.0: PME# enabled
Dec 24 12:54:38 localhost kernel: [    5.451023] ohci_hcd 0000:00:02.0: wake-up capability enabled by ACPI
Dec 24 12:54:38 localhost kernel: [    5.451026] ohci_hcd 0000:00:02.0: PME# enabled
Dec 24 12:54:38 localhost kernel: [    5.451027] ohci_hcd 0000:00:02.0: wake-up capability enabled by ACPI
Dec 24 12:54:38 localhost kernel: [    5.451247] PM: suspend devices took 1.731 seconds
Dec 24 12:54:38 localhost kernel: [    5.451374] ACPI: Preparing to enter system sleep state S3
Dec 24 12:54:38 localhost kernel: [    5.451905] Disabling non-boot CPUs ...
Dec 24 12:54:38 localhost kernel: [    5.452949] kvm: disabling virtualization on CPU1
Dec 24 12:54:38 localhost kernel: [    5.454216] CPU 1 is now offline
Dec 24 12:54:38 localhost kernel: [    5.454218] SMP alternatives: switching to UP code
Dec 24 12:54:38 localhost kernel: [    5.613759] CPU1 is down
Dec 24 12:54:38 localhost kernel: [    5.613859] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Dec 24 12:54:38 localhost kernel: [    5.613859] PCI-DMA: Resuming GART IOMMU
Dec 24 12:54:38 localhost kernel: [    5.613859] PCI-DMA: Restoring GART aperture settings
Dec 24 12:54:38 localhost kernel: [    5.616142] Enabling non-boot CPUs ...
Dec 24 12:54:38 localhost kernel: [    5.616360] SMP alternatives: switching to SMP code
Dec 24 12:54:38 localhost kernel: [    5.793954] Booting processor 1 APIC 0x1 ip 0x6000
Dec 24 12:54:38 localhost kernel: [    5.452949] Initializing CPU#1
Dec 24 12:54:38 localhost kernel: [    5.452949] Calibrating delay using timer specific routine.. 5200.04 BogoMIPS (lpj=2600024)
Dec 24 12:54:38 localhost kernel: [    5.452949] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Dec 24 12:54:38 localhost kernel: [    5.452949] CPU: L2 Cache: 512K (64 bytes/line)
Dec 24 12:54:38 localhost kernel: [    5.452949] CPU: Physical Processor ID: 0
Dec 24 12:54:38 localhost kernel: [    5.452949] CPU: Processor Core ID: 1
Dec 24 12:54:38 localhost kernel: [    5.452949] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
Dec 24 12:54:38 localhost kernel: [    5.864398] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
Dec 24 12:54:38 localhost kernel: [    5.864405] kvm: enabling virtualization on CPU1
Dec 24 12:54:38 localhost kernel: [    5.868265] CPU1 is up
Dec 24 12:54:38 localhost kernel: [    5.868266] ACPI: Waking up from system sleep state S3
Dec 24 12:54:38 localhost kernel: [    5.869064] ohci_hcd 0000:00:02.0: wake-up capability disabled by ACPI
Dec 24 12:54:38 localhost kernel: [    5.869067] ohci_hcd 0000:00:02.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    5.869069] ohci_hcd 0000:00:02.0: wake-up capability disabled by ACPI
Dec 24 12:54:38 localhost kernel: [    5.869071] ohci_hcd 0000:00:02.0: PME# disabled
Dec 24 12:54:38 localhost kernel: [    5.879019] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
Dec 24 12:54:38 localhost kernel: [    5.911015] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
Dec 24 12:54:38 localhost kernel: [    5.933027] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
Dec 24 12:54:38 localhost kernel: [    5.944028] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 (level, low) -> IRQ 22
Dec 24 12:54:38 localhost kernel: [    5.955029] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 (level, low) -> IRQ 21
Dec 24 12:54:38 localhost kernel: [    5.966033] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
Dec 24 12:54:38 localhost kernel: [    6.045046] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 18 (level, low) -> IRQ 18
Dec 24 12:54:38 localhost kernel: [    6.045228] sd 2:0:0:0: [sda] Starting disk
Dec 24 12:54:38 localhost kernel: [    6.387033] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Dec 24 12:54:38 localhost kernel: [    6.390116] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
Dec 24 12:54:38 localhost kernel: [    6.390118] ata1.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
Dec 24 12:54:38 localhost kernel: [    6.396124] ata1.00: configured for UDMA/66
Dec 24 12:54:38 localhost kernel: [   11.447016] ata3: link is slow to respond, please be patient (ready=0)
Dec 24 12:54:38 localhost kernel: [   11.855038] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec 24 12:54:38 localhost kernel: [   11.874112] ata3.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
Dec 24 12:54:38 localhost kernel: [   11.874114] ata3.00: ACPI cmd f5/00:00:00:00:00:00 filtered out
Dec 24 12:54:38 localhost kernel: [   11.880276] ata3.00: configured for UDMA/133
Dec 24 12:54:38 localhost kernel: [   11.880358] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
Dec 24 12:54:38 localhost kernel: [   11.880373] sd 2:0:0:0: [sda] Write Protect is off
Dec 24 12:54:38 localhost kernel: [   11.880394] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 24 12:54:38 localhost kernel: [   11.880401] sda: detected capacity change from 0 to 320072933376
Dec 24 12:54:38 localhost kernel: [   12.098245] PM: resume devices took 6.230 seconds
Dec 24 12:54:38 localhost kernel: [   12.098249] ------------[ cut here ]------------
Dec 24 12:54:38 localhost kernel: [   12.098251] WARNING: at kernel/power/main.c:177 suspend_test_finish+0x6c/0x71()
Dec 24 12:54:38 localhost kernel: [   12.098252] Component: resume devices
Dec 24 12:54:38 localhost kernel: [   12.098253] Modules linked in:
Dec 24 12:54:38 localhost kernel: [   12.098255] Pid: 1, comm: swapper Not tainted 2.6.28-rc9 #16
Dec 24 12:54:38 localhost kernel: [   12.098257] Call Trace:
Dec 24 12:54:38 localhost kernel: [   12.098261]  [<ffffffff80455e82>] warn_slowpath+0x8c/0xb3
Dec 24 12:54:38 localhost kernel: [   12.098265]  [<ffffffff8046d17d>] ? down_trylock+0x2d/0x34
Dec 24 12:54:38 localhost kernel: [   12.098269]  [<ffffffff80aa2c3f>] ? _spin_unlock+0x2a/0x35
Dec 24 12:54:38 localhost kernel: [   12.098271]  [<ffffffff80456b2b>] ? vprintk+0x2aa/0x2ed
Dec 24 12:54:38 localhost kernel: [   12.098273]  [<ffffffff80aa045e>] ? printk+0x3c/0x3e
Dec 24 12:54:38 localhost kernel: [   12.098275]  [<ffffffff80aa045e>] ? printk+0x3c/0x3e
Dec 24 12:54:38 localhost kernel: [   12.098277]  [<ffffffff8047c3dc>] suspend_test_finish+0x6c/0x71
Dec 24 12:54:38 localhost kernel: [   12.098280]  [<ffffffff8047c55e>] suspend_devices_and_enter+0x17d/0x1b3
Dec 24 12:54:38 localhost kernel: [   12.098282]  [<ffffffff8047c720>] enter_state+0x163/0x1c9
Dec 24 12:54:38 localhost kernel: [   12.098284]  [<ffffffff8047c874>] pm_suspend+0x16/0x1c
Dec 24 12:54:38 localhost kernel: [   12.098287]  [<ffffffff80f3996f>] test_suspend+0x130/0x1c1
Dec 24 12:54:38 localhost kernel: [   12.098289]  [<ffffffff80f3983f>] ? test_suspend+0x0/0x1c1
Dec 24 12:54:38 localhost kernel: [   12.098292]  [<ffffffff80409058>] _stext+0x58/0x133
Dec 24 12:54:38 localhost kernel: [   12.098295]  [<ffffffff80695760>] ? ida_get_new_above+0x18d/0x1ae
Dec 24 12:54:38 localhost kernel: [   12.098298]  [<ffffffff80aa2b9a>] ? _spin_unlock_irqrestore+0x2c/0x37
Dec 24 12:54:38 localhost kernel: [   12.098300]  [<ffffffff806958c1>] ? idr_pre_get+0x58/0x6e
Dec 24 12:54:38 localhost kernel: [   12.098303]  [<ffffffff80aa27b9>] ? _spin_lock+0x16/0x2e
Dec 24 12:54:38 localhost kernel: [   12.098305]  [<ffffffff80aa2c3f>] ? _spin_unlock+0x2a/0x35
Dec 24 12:54:38 localhost kernel: [   12.098309]  [<ffffffff80512fff>] ? proc_register+0x17f/0x193
Dec 24 12:54:38 localhost kernel: [   12.098311]  [<ffffffff8051313b>] ? create_proc_entry+0x7e/0x94
Dec 24 12:54:38 localhost kernel: [   12.098313]  [<ffffffff80495a50>] ? register_irq_proc+0xa3/0xbf
Dec 24 12:54:38 localhost kernel: [   12.098315]  [<ffffffff80510000>] ? proc_coredump_filter_read+0x15/0xb7
Dec 24 12:54:38 localhost kernel: [   12.098318]  [<ffffffff80f22650>] kernel_init+0x126/0x17a
Dec 24 12:54:38 localhost kernel: [   12.098320]  [<ffffffff80423199>] child_rip+0xa/0x11
Dec 24 12:54:38 localhost kernel: [   12.098322]  [<ffffffff80f2252a>] ? kernel_init+0x0/0x17a
Dec 24 12:54:38 localhost kernel: [   12.098324]  [<ffffffff8042318f>] ? child_rip+0x0/0x11
Dec 24 12:54:38 localhost kernel: [   12.098326] ---[ end trace a186036a01a81689 ]---
Dec 24 12:54:38 localhost kernel: [   12.109342] Restarting tasks ... <3>hub 1-0:1.0: over-current change on port 1
Dec 24 12:54:38 localhost kernel: [   12.109651] done.
Dec 24 12:54:38 localhost kernel: [   12.109815] registered taskstats version 1
Dec 24 12:54:38 localhost kernel: [   12.110150] rtc_cmos 00:02: setting system clock to 2008-12-24 11:54:10 UTC (1230119650)
Dec 24 12:54:38 localhost kernel: [   12.110371] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Dec 24 12:54:38 localhost kernel: [   12.113026] Freeing unused kernel memory: 476k freed
Dec 24 12:54:38 localhost kernel: [   12.113379] Write protecting the kernel read-only data: 10172k
Dec 24 12:54:38 localhost kernel: [   12.210019] hub 1-0:1.0: over-current change on port 2
Dec 24 12:54:38 localhost kernel: [   12.373441] usb 1-6.1: new low speed USB device using ehci_hcd and address 4
Dec 24 12:54:38 localhost kernel: [   12.440018] end_request: I/O error, dev fd0, sector 0
Dec 24 12:54:38 localhost kernel: [   12.468216] usb 1-6.1: configuration #1 chosen from 1 choice
Dec 24 12:54:38 localhost kernel: [   12.475627] input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input3
Dec 24 12:54:38 localhost kernel: [   12.481137] generic-usb 0003:045E:0029.0001: input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:02.1-6.1/input0
Dec 24 12:54:38 localhost kernel: [   12.544444] usb 1-6.2: new low speed USB device using ehci_hcd and address 5
Dec 24 12:54:38 localhost kernel: [   12.631619] usb 1-6.2: configuration #1 chosen from 1 choice
Dec 24 12:54:38 localhost kernel: [   12.636605] input: DELL DELL USB Keyboard as /class/input/input4
Dec 24 12:54:38 localhost kernel: [   12.643367] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2/input0
Dec 24 12:54:38 localhost kernel: [   12.653893] input: DELL DELL USB Keyboard as /class/input/input5
Dec 24 12:54:38 localhost kernel: [   12.660354] generic-usb 0003:413C:2003.0003: input,hidraw2: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-6.2/input1
Dec 24 12:54:38 localhost kernel: [   26.535022] end_request: I/O error, dev fd0, sector 0
Dec 24 12:54:38 localhost kernel: [   26.648022] end_request: I/O error, dev fd0, sector 0
Dec 24 12:54:38 localhost kernel: [   26.860024] end_request: I/O error, dev fd0, sector 0
Dec 24 12:54:38 localhost kernel: [   27.032342] kjournald starting.  Commit interval 5 seconds
Dec 24 12:54:38 localhost kernel: [   27.032353] EXT3-fs: mounted filesystem with ordered data mode.
Dec 24 12:54:38 localhost kernel: [   27.161403] type=1404 audit(1230119665.551:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
Dec 24 12:54:38 localhost kernel: [   27.583374] type=1403 audit(1230119665.972:3): policy loaded auid=4294967295 ses=4294967295
Dec 24 12:54:38 localhost kernel: [   29.000016] Clocksource tsc unstable (delta = -76901359 ns)
Dec 24 12:54:38 localhost kernel: [   30.550449] udevd version 127 started
Dec 24 12:54:38 localhost kernel: [   32.223585] ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ff000000-0x00000000ffffffff - kernel bug?
Dec 24 12:54:38 localhost kernel: [   32.223595] resource map sanity check conflict: 0xff000000 0xffffffff 0xff780000 0xffffffff reserved
Dec 24 12:54:38 localhost kernel: [   32.223602] ------------[ cut here ]------------
Dec 24 12:54:38 localhost kernel: [   32.223604] WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0xd2/0x2ba()
Dec 24 12:54:38 localhost kernel: [   32.223607] Modules linked in: ck804xrom(+) [last unloaded: scsi_wait_scan]
Dec 24 12:54:38 localhost kernel: [   32.223612] Pid: 1778, comm: modprobe Tainted: G        W  2.6.28-rc9 #16
Dec 24 12:54:38 localhost kernel: [   32.223614] Call Trace:
Dec 24 12:54:38 localhost kernel: [   32.223619]  [<ffffffff80455f01>] warn_on_slowpath+0x58/0x7d
Dec 24 12:54:38 localhost kernel: [   32.223625]  [<ffffffff80aa2b9a>] ? _spin_unlock_irqrestore+0x2c/0x37
Dec 24 12:54:38 localhost kernel: [   32.223629]  [<ffffffff804565f7>] ? release_console_sem+0x190/0x1c6
Dec 24 12:54:38 localhost kernel: [   32.223632]  [<ffffffff80aa045e>] ? printk+0x3c/0x3e
Dec 24 12:54:38 localhost kernel: [   32.223635]  [<ffffffff80aa2bd0>] ? _read_unlock+0x2b/0x36
Dec 24 12:54:38 localhost kernel: [   32.223640]  [<ffffffffa000d000>] ? init_ck804xrom+0x0/0x55d [ck804xrom]
Dec 24 12:54:38 localhost kernel: [   32.223643]  [<ffffffff8043d791>] __ioremap_caller+0xd2/0x2ba
Dec 24 12:54:38 localhost kernel: [   32.223646]  [<ffffffffa000d25c>] ? init_ck804xrom+0x25c/0x55d [ck804xrom]
Dec 24 12:54:38 localhost kernel: [   32.223651]  [<ffffffff808f9311>] ? raw_pci_write+0x1f/0x38
Dec 24 12:54:38 localhost kernel: [   32.223654]  [<ffffffff80aa2b9a>] ? _spin_unlock_irqrestore+0x2c/0x37
Dec 24 12:54:38 localhost kernel: [   32.223658]  [<ffffffffa000d000>] ? init_ck804xrom+0x0/0x55d [ck804xrom]
Dec 24 12:54:38 localhost kernel: [   32.223661]  [<ffffffff8043da4c>] ioremap_nocache+0x12/0x14
Dec 24 12:54:38 localhost kernel: [   32.223664]  [<ffffffffa000d25c>] init_ck804xrom+0x25c/0x55d [ck804xrom]
Dec 24 12:54:38 localhost kernel: [   32.223668]  [<ffffffffa000d000>] ? init_ck804xrom+0x0/0x55d [ck804xrom]
Dec 24 12:54:38 localhost kernel: [   32.223671]  [<ffffffff80409058>] _stext+0x58/0x133
Dec 24 12:54:38 localhost kernel: [   32.223675]  [<ffffffff804cc448>] ? do_sync_read+0xe7/0x12d
Dec 24 12:54:38 localhost kernel: [   32.223679]  [<ffffffff8047b3f4>] sys_init_module+0xa9/0x1b7
Dec 24 12:54:38 localhost kernel: [   32.223682]  [<ffffffff8042220b>] system_call_fastpath+0x16/0x1b
Dec 24 12:54:38 localhost kernel: [   32.223685] ---[ end trace a186036a01a81689 ]---
Dec 24 12:54:38 localhost kernel: [   32.257043] Found: PMC Pm49FL004
Dec 24 12:54:38 localhost kernel: [   32.257064] ck804xrom @fff80000: Found 1 x8 devices at 0x0 in 8-bit bank
Dec 24 12:54:38 localhost kernel: [   32.257069] number of JEDEC chips: 1
Dec 24 12:54:38 localhost kernel: [   32.257071] cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
Dec 24 12:54:38 localhost kernel: [   32.258389] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 17
Dec 24 12:54:38 localhost kernel: [   32.258402] olympic 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 17 (level, low) -> IRQ 17
Dec 24 12:54:38 localhost kernel: [   32.258461] Olympic.c v1.0.5 6/04/02 - Peter De Schrijver & Mike Phillips 
Dec 24 12:54:38 localhost kernel: [   32.258464] 0000:01:00.0. I/O at d800, MMIO at ffffc2001074ec00, LAP at ffffc200106e8000, using irq 17
Dec 24 12:54:38 localhost kernel: [   32.259629] rfd_ftl: no RFD magic found in 'ck804xrom @fff80000'
Dec 24 12:54:38 localhost kernel: [   32.269094] ftl_cs: FTL header not found.
Dec 24 12:54:38 localhost kernel: [   32.288967] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
Dec 24 12:54:38 localhost kernel: [   32.289406] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
Dec 24 12:54:38 localhost kernel: [   32.289417] forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 20 (level, low) -> IRQ 20
Dec 24 12:54:38 localhost kernel: [   32.429497] wlan0: register 'rndis_wlan' at usb-0000:00:02.1-4, Wireless RNDIS device, BCM4320b based, 00:16:01:cf:56:29
Dec 24 12:54:38 localhost kernel: [   32.429527] usbcore: registered new interface driver rndis_wlan
Dec 24 12:54:38 localhost kernel: [   32.806339] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, addr 00:16:17:45:c9:df
Dec 24 12:54:38 localhost kernel: [   32.806343] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
Dec 24 12:54:38 localhost kernel: [   32.806768] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
Dec 24 12:54:38 localhost kernel: [   32.806772] forcedeth 0000:00:09.0: PCI INT A -> Link[LMAD] -> GSI 20 (level, low) -> IRQ 20
Dec 24 12:54:38 localhost kernel: [   33.322442] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, addr 00:16:17:45:c9:de
Dec 24 12:54:38 localhost kernel: [   33.322445] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
Dec 24 12:54:38 localhost kernel: [   33.704685] rndis_wlan 1-4:1.0: rndis media disconnect
Dec 24 12:54:38 localhost kernel: [   36.001747] Olympic: 0000:01:00.0 registered as: tr0
Dec 24 12:54:38 localhost kernel: [   37.438653] EXT3 FS on dm-0, internal journal
Dec 24 12:54:38 localhost kernel: [   38.863757] Adding 6387004k swap on /dev/sda4.  Priority:-1 extents:1 across:6387004k



