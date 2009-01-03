Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZACM2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZACM2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 07:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbZACM21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 07:28:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45512 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759887AbZACM2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 07:28:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [Regression] X server doesn't start on MSI Wind w/ current mainline
Date: Sat, 3 Jan 2009 13:28:40 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4n1XJNBBoP/sABz"
Message-Id: <200901031328.40574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_4n1XJNBBoP/sABz
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

With the current mainline and the linux-next branch of your pci-2.6 tree on
top, the X server doesn't start any more on MSI Wind (Intel hardware) w/
openSUSE 11.1 .

I also tested the linux-next branch of the pci-2.6 tree on top of 2.6.28 and
it doesn't cause any problem with the X server to happen.

Attached is an X server log.

Thanks,
Rafael

--Boundary-00=_4n1XJNBBoP/sABz
Content-Type: text/x-log;
  charset="iso-8859-2";
  name="Xorg.0.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Xorg.0.log"


X.Org X Server 1.5.2
Release Date: 10 October 2008
X Protocol Version 11, Revision 0
Build Operating System: openSUSE SUSE LINUX
Current Operating System: Linux wind 2.6.28-tst #88 SMP Sat Jan 3 12:21:59 =
CET 2009 i686
Build Date: 03 December 2008  09:21:06AM
=20
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Module Loader present
Markers: (--) probed, (**) from config file, (=3D=3D) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Sat Jan  3 12:55:24 2009
(=3D=3D) Using config file: "/etc/X11/xorg.conf"
(=3D=3D) ServerLayout "Layout[all]"
(**) |-->Screen "Screen[0]" (0)
(**) |   |-->Monitor "Monitor[0]"
(**) |   |-->Device "Device[0]"
(**) |-->Input Device "Keyboard[0]"
(**) |-->Input Device "Mouse[1]"
(**) Option "ZapWarning" "on"
(**) Option "AllowMouseOpenFail" "on"
(**) Option "Xinerama" "off"
(**) Option "AIGLX" "on"
(=3D=3D) Automatically adding devices
(=3D=3D) Automatically enabling devices
(WW) The directory "/usr/share/fonts/local" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/PEX" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin2/misc" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin2/75dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin2/100dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin2/Type1" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin7/75dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/baekmuk" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/japanese" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/kwintv" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/uni" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/CID" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/ucs/misc" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/ucs/75dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/ucs/100dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/hellas/misc" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/hellas/75dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/hellas/100dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/hellas/Type1" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/misc/sgi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/xtest" does not exist.
	Entry deleted from font path.
(=3D=3D) Including the default font path /usr/share/fonts/misc:unscaled,/us=
r/share/fonts/TTF/,/usr/share/fonts/OTF,/usr/share/fonts/Type1/,/usr/share/=
fonts/100dpi:unscaled,/usr/share/fonts/75dpi:unscaled.
(**) FontPath set to:
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/75dpi:unscaled,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/Type1,
	/usr/share/fonts/URW,
	/usr/share/fonts/Speedo,
	/usr/share/fonts/cyrillic,
	/usr/share/fonts/truetype,
	/opt/kde3/share/fonts,
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/OTF,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/75dpi:unscaled
(**) Input device list set to "/dev/gpmdata,/dev/input/mice"
(=3D=3D) ModulePath set to "/usr/lib/xorg/modules/updates,/usr/lib/xorg/mod=
ules"
(**) Extension "Composite" is enabled
(II) Open ACPI successful (/var/run/acpid.socket)
(II) Loader magic: 0x81f45c0
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 4.1
	X.Org XInput driver : 2.1
	X.Org Server Extension : 1.1
	X.Org Font Renderer : 0.6
(II) Loader running on linux
(--) using VT number 7

(--) PCI:*(0@0:2:0) unknown vendor (0x8086) unknown chipset (0x27ae) rev 3,=
 Mem @ 0xdfe80000/0, 0xc0000000/0, 0xdff00000/0, I/O @ 0x0000d0f0/0
(--) PCI: (0@0:2:1) unknown vendor (0x8086) unknown chipset (0x27a6) rev 3,=
 Mem @ 0xdfe00000/0
(II) System resource ranges:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) "extmod" will be loaded. This was enabled by default and also specifie=
d in the config file.
(II) "dbe" will be loaded. This was enabled by default and also specified i=
n the config file.
(II) "glx" will be loaded. This was enabled by default and also specified i=
n the config file.
(II) "freetype" will be loaded. This was enabled by default and also specif=
ied in the config file.
(II) "record" will be loaded by default.
(II) "dri" will be loaded by default.
(II) LoadModule: "glx"

(II) Loading /usr/lib/xorg/modules//extensions/libglx.so
(II) Module glx: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 1.1
(**) AIGLX enabled
(**) Exporting typical set of GLX visuals
(II) Loading extension GLX
(II) LoadModule: "type1"

(WW) Warning, couldn't open module type1
(II) UnloadModule: "type1"
(EE) Failed to load module "type1" (module does not exist, 0)
(II) LoadModule: "extmod"

(II) Loading /usr/lib/xorg/modules//extensions/libextmod.so
(II) Module extmod: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 1.1
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

(II) Loading /usr/lib/xorg/modules//extensions/libdbe.so
(II) Module dbe: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "freetype"

(II) Loading /usr/lib/xorg/modules//fonts/libfreetype.so
(II) Module freetype: vendor=3D"X.Org Foundation & the After X-TT Project"
	compiled for 1.5.2, module version =3D 2.1.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.6
(II) Loading font FreeType
(II) LoadModule: "record"

(II) Loading /usr/lib/xorg/modules//extensions/librecord.so
(II) Module record: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension RECORD
(II) LoadModule: "dri"

(II) Loading /usr/lib/xorg/modules//extensions/libdri.so
(II) Module dri: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	ABI class: X.Org Server Extension, version 1.1
(II) Loading extension XFree86-DRI
(II) LoadModule: "intel"

(II) Loading /usr/lib/xorg/modules//drivers/intel_drv.so
(II) Module intel: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 2.5.0
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 4.1
(II) LoadModule: "kbd"

(II) Loading /usr/lib/xorg/modules//input/kbd_drv.so
(II) Module kbd: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.3.1
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 2.1
(II) LoadModule: "mouse"

(II) Loading /usr/lib/xorg/modules//input/mouse_drv.so
(II) Module mouse: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.3.0
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 2.1
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
	compiled for 1.5.2, module version =3D 0.1.0
	ABI class: X.Org Video Driver, version 4.1
(**) intel(0): Depth 24, (--) framebuffer bpp 32
(=3D=3D) intel(0): RGB weight 888
(=3D=3D) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) 945GME
(--) intel(0): Chipset: "945GME"
(--) intel(0): Linear framebuffer at 0xC0000000
(--) intel(0): IO registers at addr 0xDFE80000
(WW) intel(0): libpciaccess reported 0 rom size, guessing 64kB
(=3D=3D) intel(0): Using EXA for acceleration
(II) intel(0): 2 display pipes available.
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Module "ddc" already built-in
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"
(II) Module "i2c" already built-in
(II) intel(0): Output VGA using monitor section EXT
(**) intel(0): Option "Ignore" "false"
(II) intel(0): Output LVDS using monitor section Monitor[0]
(**) intel(0): Option "PreferredMode" "1024x600"
(II) intel(0): I2C bus "LVDSDDC_C" initialized.
(II) intel(0): Attempting to determine panel fixed mode.
(II) intel(0): I2C device "LVDSDDC_C:ddc2" registered at address 0xA0.
(II) intel(0): EDID vendor "HSD", prod id 1001
(II) intel(0): DDCModeFromDetailedTiming: 1024x600 Warning: We only handle =
seperate sync.
(II) intel(0): EDID vendor "HSD", prod id 1001
(II) intel(0): DDCModeFromDetailedTiming: 1024x600 Warning: We only handle =
seperate sync.
(II) intel(0): Output VGA disconnected
(II) intel(0): Output LVDS connected
(II) intel(0): Using user preference for initial modes
(II) intel(0): Output LVDS using initial mode 1024x600
(II) intel(0): Monitoring connected displays enabled
(II) intel(0): detected 256 kB GTT.
(II) intel(0): detected 7932 kB stolen memory.
(=3D=3D) intel(0): video overlay key set to 0x101fe
(=3D=3D) intel(0): Intel XvMC decoder disabled
(=3D=3D) intel(0): Will not try to enable page flipping
(=3D=3D) intel(0): Triple buffering disabled
(=3D=3D) intel(0): Using gamma correction (1.0, 1.0, 1.0)
(**) intel(0): Display dimensions: (203, 152) mm
(**) intel(0): DPI set to (128, 100)
(II) Loading sub module "fb"
(II) LoadModule: "fb"

(II) Loading /usr/lib/xorg/modules//libfb.so
(II) Module fb: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(II) Loading sub module "exa"
(II) LoadModule: "exa"

(II) Loading /usr/lib/xorg/modules//libexa.so
(II) Module exa: vendor=3D"X.Org Foundation"
	compiled for 1.5.2, module version =3D 2.4.0
	ABI class: X.Org Video Driver, version 4.1
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"
(II) Module "ramdac" already built-in
(II) intel(0): Comparing regs from server start up to After PreInit
(WW) intel(0): Register 0x61200 (PP_STATUS) changed from 0xc0000008 to 0xd0=
00000a
(WW) intel(0): PP_STATUS before: on, ready, sequencing idle
(WW) intel(0): PP_STATUS after: on, ready, sequencing on
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
(II) intel(0): Kernel reported 238336 total, 1 used
(II) intel(0): I830CheckAvailableMemory: 953340 kB available
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 13, (OK)
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 13, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 13, (OK)
drmOpenByBusid: drmOpenMinor returns 13
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(II) [drm] DRM interface version 1.3
(II) [drm] DRM open master succeeded.
(II) intel(0): [drm] Using the DRM lock SAREA also for drawables.
(II) intel(0): [drm] framebuffer mapped by ddx driver
(II) intel(0): [drm] added 1 reserved context for kernel
(II) intel(0): X context handle =3D 0x1
(II) intel(0): [drm] installed DRM signal handler
(**) intel(0): Framebuffer compression enabled
(**) intel(0): Tiling enabled
(=3D=3D) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Tiled allocation successful.

=46atal server error:
AddScreen/ScreenInit failed for driver 0


--Boundary-00=_4n1XJNBBoP/sABz--
