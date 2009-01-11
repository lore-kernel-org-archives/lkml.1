Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbZAKVVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbZAKVVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZAKVVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:21:37 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50738 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZAKVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:21:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=EoRx5mAaH+3QaSI0VUkWMXbCrlI8o6Y/AOo/KaQKDZW+k4J9bBtbQx3k9xb+t0o/Sh
         qsTrG6CbV8dUuBND9VQwJhSqNM2Jm/JpDRW2Tq5NJkhmV63juHzv0gEGkA4LjMXsvcCY
         PbBfmqXYNKItlwt3arYEEA3UPXXJQD9DM/Q6s=
Date: Sun, 11 Jan 2009 22:21:22 +0100
From: Diego Calleja <diegocg@gmail.com>
To: "Jan Dittmer" <jdi@l4x.org>
Cc: linux-kernel@vger.kernel.org, eric.anholt@iintel.com, airlied@linux.ie
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Message-ID: <20090111222122.4d0cb146@diego-desktop>
In-Reply-To: <621d098f0901110551v5a05f69aqc4e06a6905989d6e@mail.gmail.com>
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	<621d098f0901110551v5a05f69aqc4e06a6905989d6e@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/UbooE0ZqS463p8t7tC_4/pZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/UbooE0ZqS463p8t7tC_4/pZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I also have a failure with KMS, it's different than yours but I'll post it
in this thread...xserver-xorg-video-intel version 2.5.1 (whatever there is
in ubuntu unstable repositories)

-----------------------------------------------
(II) [drm] DRM interface version 1.3
(II) [drm] DRM open master succeeded.
(II) intel(0): [drm] Using the DRM lock SAREA also for drawables.
(II) intel(0): [drm] framebuffer mapped by ddx driver
(II) intel(0): [drm] added 1 reserved context for kernel
(II) intel(0): X context handle = 0x1
(II) intel(0): [drm] installed DRM signal handler
(**) intel(0): Framebuffer compression disabled
(**) intel(0): Tiling enabled
(==) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Tiled allocation successful.

Fatal server error:
AddScreen/ScreenInit failed for driver 0
-----------------------------------------------

Full X.org log attached.
--MP_/UbooE0ZqS463p8t7tC_4/pZ
Content-Type: text/x-log; name=Xorg.0.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=Xorg.0.log


This is a pre-release version of the X server from The X.Org Foundation.
It is not supported in any way.
Bugs may be filed in the bugzilla at http://bugs.freedesktop.org/.
Select the "xorg" product for bugs you find in this release.
Before reporting bugs in pre-release versions please check the
latest version in the X.Org Foundation git repository.
See http://wiki.x.org/wiki/GitPage for git access instructions.

X.Org X Server 1.5.99.3
Release Date: (unreleased)
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.24-16-server x86_64 Ubuntu
Current Operating System: Linux diego-desktop 2.6.29-rc1-dirty #2 SMP PREEM=
PT Sun Jan 11 21:21:50 CET 2009 x86_64
Build Date: 06 January 2009  06:25:17AM
xorg-server 2:1.5.99.3-0ubuntu4 (buildd@crested.buildd)=20
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (=3D=3D) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Sun Jan 11 20:34:06 2009
(=3D=3D) Using config file: "/etc/X11/xorg.conf"
(=3D=3D) ServerLayout "Default Layout"
(**) |-->Screen "Default Screen" (0)
(**) |   |-->Monitor "Configured Monitor"
(**) |   |-->Device "Configured Video Device"
(**) |-->Input Device "stylus"
(**) |-->Input Device "cursor"
(**) |-->Input Device "eraser"
(**) |-->Input Device "pad"
(=3D=3D) Automatically adding devices
(=3D=3D) Automatically enabling devices
(=3D=3D) No FontPath specified.  Using compiled-in default.
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(=3D=3D) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType
(=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
(II) Cannot locate a core pointer device.
(II) Cannot locate a core keyboard device.
(II) The server relies on HAL to provide the list of input devices.
	If no devices become available, reconfigure HAL or disable AllowEmptyInput.
(II) Loader magic: 0xdc0
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 5.0
	X.Org XInput driver : 4.0
	X.Org Server Extension : 2.0
(II) Loader running on linux
(++) using VT number 7

(--) PCI:*(0@0:2:0) Intel Corporation 82945G/GZ Integrated Graphics Control=
ler rev 2, Mem @ 0xcfd00000/524288, 0xd0000000/268435456, 0xcfd80000/262144=
, I/O @ 0x00008800/8
(II) Open ACPI successful (/var/run/acpid.socket)
(II) System resource ranges:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions//libglx.so
(II) Module glx: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(=3D=3D) AIGLX enabled
(=3D=3D) Exporting typical set of GLX visuals
(II) Loading extension GLX
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions//librecord.so
(II) Module record: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions//libdri2.so
(II) Module dri2: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(II) Scanning /usr/share/xserver-xorg/pci directory for additional PCI ID's=
 supported by the drivers
(II) Matched intel from file name intel.ids
(=3D=3D) Matched intel for the autoconfigured driver
(=3D=3D) Assigned the driver to the xf86ConfigLayout
(II) LoadModule: "intel"
(II) Loading /usr/lib/xorg/modules/drivers//intel_drv.so
(II) Module intel: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 2.5.1
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) LoadModule: "wacom"
(II) Loading /usr/lib/xorg/modules/input//wacom_drv.so
(II) Module wacom: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 1.0.0
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 4.0
(II) Wacom driver level: 47-0.8.1-6 $
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, 965G, G35, 965Q, 946GZ,
	965GM, 965GME/GLE, G33, Q35, Q33,
	Mobile Intel=C2=AE GM45 Express Chipset,
	Intel Integrated Graphics Device, G45/G43, Q45/Q43, G41
(II) Primary Device is: PCI 00@00:02:0
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) resource ranges after probing:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[5] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[6] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[7] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[8] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[9] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[10] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) Loading sub module "vgahw"
(II) LoadModule: "vgahw"
(II) Loading /usr/lib/xorg/modules//libvgahw.so
(II) Module vgahw: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 0.1.0
	ABI class: X.Org Video Driver, version 5.0
(II) intel(0): Creating default Display subsection in Screen section
	"Default Screen" for depth/fbbpp 24/32
(=3D=3D) intel(0): Depth 24, (--) framebuffer bpp 32
(=3D=3D) intel(0): RGB weight 888
(=3D=3D) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) 945G
(--) intel(0): Chipset: "945G"
(--) intel(0): Linear framebuffer at 0xD0000000
(--) intel(0): IO registers at addr 0xCFD00000
(WW) intel(0): libpciaccess reported 0 rom size, guessing 64kB
(=3D=3D) intel(0): Using EXA for acceleration
(II) intel(0): 2 display pipes available.
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Module "ddc" already built-in
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"
(II) Module "i2c" already built-in
(II) intel(0): Output VGA using monitor section Configured Monitor
(II) intel(0): I2C bus "CRTDDC_A" initialized.
(II) intel(0): I2C device "CRTDDC_A:E-EDID segment register" registered at =
address 0x60.
(II) intel(0): I2C device "CRTDDC_A:ddc2" registered at address 0xA0.
(II) intel(0): I2C device "CRTDDC_A:ddc2" removed.
(II) intel(0): I2C device "CRTDDC_A:E-EDID segment register" removed.
(II) intel(0): I2C bus "CRTDDC_A" removed.
(II) intel(0): EDID vendor "BNQ", prod id 30369
(II) intel(0): Using EDID range info for horizontal sync
(II) intel(0): Using EDID range info for vertical refresh
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 =
1025 1028 1066 +hsync +vsync (64.0 kHz)
(II) intel(0): Modeline "640x350"x0.0   25.17  640 656 752 800  350 387 389=
 449 +hsync -vsync (31.5 kHz)
(II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 60=
5 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484=
 500 -hsync -vsync (37.5 kHz)
(II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492=
 520 -hsync -vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486=
 525 -hsync -vsync (35.0 kHz)
(II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492=
 525 -hsync -vsync (31.5 kHz)
(II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414=
 449 -hsync +vsync (31.5 kHz)
(II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 =
1025 1028 1066 +hsync +vsync (80.0 kHz)
(II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 76=
9 772 800 +hsync +vsync (60.0 kHz)
(II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 77=
1 777 806 -hsync -vsync (56.5 kHz)
(II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 77=
1 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 62=
8 667 -hsync -vsync (49.7 kHz)
(II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 60=
4 625 +hsync +vsync (46.9 kHz)
(II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 64=
3 666 +hsync +vsync (48.1 kHz)
(II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 86=
5 868 900 +hsync +vsync (67.5 kHz)
(II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 86=
5 868 900 +hsync +vsync (67.5 kHz)
(II) intel(0): Modeline "1280x1024"x76.0  141.82  1280 1376 1512 1744  1024=
 1025 1028 1070 -hsync +vsync (81.3 kHz)
(II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 =
1025 1028 1066 +hsync +vsync (64.0 kHz)
(II) intel(0): Modeline "1280x1024"x72.0  132.75  1280 1368 1504 1728  1024=
 1025 1028 1067 -hsync +vsync (76.8 kHz)
(II) intel(0): EDID vendor "BNQ", prod id 30369
(II) intel(0): Output VGA connected
(II) intel(0): Using exact sizes for initial modes
(II) intel(0): Output VGA using initial mode 1280x1024
(II) intel(0): detected 256 kB GTT.
(II) intel(0): detected 7932 kB stolen memory.
(=3D=3D) intel(0): video overlay key set to 0x101fe
(=3D=3D) intel(0): Intel XvMC decoder disabled
(=3D=3D) intel(0): Will not try to enable page flipping
(=3D=3D) intel(0): Triple buffering disabled
(=3D=3D) intel(0): Using gamma correction (1.0, 1.0, 1.0)
(**) intel(0): Display dimensions: (340, 270) mm
(**) intel(0): DPI set to (95, 120)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules//libfb.so
(II) Module fb: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(II) Loading sub module "exa"
(II) LoadModule: "exa"
(II) Loading /usr/lib/xorg/modules//libexa.so
(II) Module exa: vendor=3D"X.Org Foundation"
	compiled for 1.5.99.3, module version =3D 2.4.0
	ABI class: X.Org Video Driver, version 5.0
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"
(II) Module "ramdac" already built-in
(II) intel(0): Comparing regs from server start up to After PreInit
(=3D=3D) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B](OprD)
	[5] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B](OprD)
	[6] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B](OprD)
	[7] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[8] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[9] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B](OprU)
	[10] 0	0	0x000003c0 - 0x000003df (0x20) IS[B](OprU)
(II) intel(0): Kernel reported 238848 total, 1 used
(II) intel(0): I830CheckAvailableMemory: 955388 kB available
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenByBusid: drmOpenMinor returns 11
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(II) [drm] DRM interface version 1.3
(II) [drm] DRM open master succeeded.
(II) intel(0): [drm] Using the DRM lock SAREA also for drawables.
(II) intel(0): [drm] framebuffer mapped by ddx driver
(II) intel(0): [drm] added 1 reserved context for kernel
(II) intel(0): X context handle =3D 0x1
(II) intel(0): [drm] installed DRM signal handler
(**) intel(0): Framebuffer compression disabled
(**) intel(0): Tiling enabled
(=3D=3D) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Tiled allocation successful.

Fatal server error:
AddScreen/ScreenInit failed for driver 0


Please consult the The X.Org Foundation support=20
	 at http://wiki.x.org
 for help.=20
Please also check the log file at "/var/log/Xorg.0.log" for additional info=
rmation.

 ddxSigGiveUp: Closing log

--MP_/UbooE0ZqS463p8t7tC_4/pZ--
