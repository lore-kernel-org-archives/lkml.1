Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbXBQSqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbXBQSqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbXBQSqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:46:24 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:12120 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbXBQSqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:46:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=myE9KFQ+P4vfod0QPaNacBHPZZLzJocy6+EEfYLNZlTv+FgNckgetmQVVUV03mW5CQ72V1t+9NsUefmPeelxN/hqGCv/FaFNc8ddgDMOL+SVrIF67XjHPNgFg57dlT9nxdnwIxQLQtk4OdmpbgY8J6ZnfKA7N4Vnh60bNOziBqI=
Message-ID: <cb7bb73a0702171046h5ac93d06k6bea13ce1be84299@mail.gmail.com>
Date: Sat, 17 Feb 2007 19:46:20 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Luca Tettamanti" <kronos@people.it>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070217181413.GA10134@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130203301.GA15067@dreamland.darkstar.lan>
	 <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com>
	 <20070205201824.GA13431@dreamland.darkstar.lan>
	 <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
	 <Pine.LNX.4.64.0702062118450.9224@pentafluge.infradead.org>
	 <20070207234837.GA27822@dreamland.darkstar.lan>
	 <cb7bb73a0702071619p5984c39fs16e3d05c11d45585@mail.gmail.com>
	 <20070211181743.GA15801@dreamland.darkstar.lan>
	 <cb7bb73a0702130125r25ddfe33na48ae673d5ce60ae@mail.gmail.com>
	 <20070217181413.GA10134@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Luca Tettamanti <kronos@people.it> wrote:
>
> Ok, now I'm confused O_o
> The patch should be correct, but I fail to see how EDID reading succeded
> before.

Sorry, but I have no idea on that :P

> Maybe the snow was caused by the driver hammering the I2C bus. Just
> guessing...

It it was so, it wouldn't appear when I disabled EDID parsing because
it wouldn't touch the I2C bus at all. But it appears just the same.

> Can you send me X.org log?


X Window System Version 7.1.1
Release Date: 12 May 2006
X Protocol Version 11, Revision 0, Release 7.1.1
Build Operating System: UNKNOWN
Current Operating System: Linux oblomov 2.6.18-4-686 #1 SMP Fri Feb 2
15:10:49 UTC 2007 i686
Build Date: 03 February 2007
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Module Loader present
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Tue Feb 13 10:09:25 2007
(==) Using config file: "/etc/X11/xorg.conf"
(==) ServerLayout "Default Layout"
(**) |-->Screen "Inspiron built-in monitor" (0)
(**) |   |-->Monitor "Dell Inspiron 8200 built-in monitor"
(**) |   |-->Device "NVIDIA Corporation NV11 [GeForce2 Go]"
(**) |-->Input Device "Inspiron built-in keyboard"
(**) |-->Input Device "Inspiron built-in touchpad"
(**) |-->Input Device "ACECAD Tablet"
(**) FontPath set to:
	unix/:7100,
	/usr/lib/X11/fonts/TrueType,
	/usr/share/fonts/X11/Type1,
	/usr/lib/X11/fonts/Speedo,
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi
(==) RgbPath set to "/etc/X11/rgb"
(==) ModulePath set to "/usr/lib/xorg/modules"
(II) Open ACPI successful (/var/run/acpid.socket)
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.3
	X.Org Video Driver: 1.0
	X.Org XInput driver : 0.6
	X.Org Server Extension : 0.3
	X.Org Font Renderer : 0.5
(II) Loader running on linux
(II) LoadModule: "bitmap"
(II) Loading /usr/lib/xorg/modules/fonts/libbitmap.so
(II) Module bitmap: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.5
(II) Loading font Bitmap
(II) LoadModule: "pcidata"
(II) Loading /usr/lib/xorg/modules/libpcidata.so
(II) Module pcidata: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Video Driver, version 1.0
(--) using VT number 7

(II) PCI: PCI scan (all values are in hex)
(II) PCI: 00:00:0: chip 8086,1a30 card 0000,0000 rev 04 class 06,00,00 hdr 00
(II) PCI: 00:01:0: chip 8086,1a31 card 0000,0000 rev 04 class 06,04,00 hdr 01
(II) PCI: 00:1d:0: chip 8086,2482 card 8086,4541 rev 02 class 0c,03,00 hdr 80
(II) PCI: 00:1d:2: chip 8086,2487 card 8086,4541 rev 02 class 0c,03,00 hdr 00
(II) PCI: 00:1e:0: chip 8086,2448 card 0000,0000 rev 42 class 06,04,00 hdr 01
(II) PCI: 00:1f:0: chip 8086,248c card 0000,0000 rev 02 class 06,01,00 hdr 80
(II) PCI: 00:1f:1: chip 8086,248a card 8086,4541 rev 02 class 01,01,8a hdr 00
(II) PCI: 00:1f:5: chip 8086,2485 card 1013,5959 rev 02 class 04,01,00 hdr 00
(II) PCI: 00:1f:6: chip 8086,2486 card 14f1,5421 rev 02 class 07,03,00 hdr 00
(II) PCI: 01:00:0: chip 10de,0112 card 1028,00d4 rev b2 class 03,00,00 hdr 00
(II) PCI: 02:00:0: chip 10b7,9200 card 1028,00d4 rev 78 class 02,00,00 hdr 00
(II) PCI: 02:01:0: chip 104c,ac42 card e000,0000 rev 00 class 06,07,00 hdr 82
(II) PCI: 02:01:1: chip 104c,ac42 card e800,0000 rev 00 class 06,07,00 hdr 82
(II) PCI: 02:01:2: chip 104c,8027 card 1028,00d4 rev 00 class 0c,00,10 hdr 80
(II) PCI: End of PCI scan
(II) Intel Bridge workaround enabled
(II) Host-to-PCI bridge:
(II) Bus 0: bridge is at (0:0:0), (0,0,7), BCTRL: 0x0008 (VGA_EN is set)
(II) Bus 0 I/O range:
	[0] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) Bus 0 non-prefetchable memory range:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
(II) Bus 0 prefetchable memory range:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
(II) PCI-to-PCI bridge:
(II) Bus 1: bridge is at (0:1:0), (0,1,1), BCTRL: 0x000e (VGA_EN is set)
(II) Bus 1 I/O range:
	[0] -1	0	0x0000c000 - 0x0000c0ff (0x100) IX[B]
	[1] -1	0	0x0000c400 - 0x0000c4ff (0x100) IX[B]
	[2] -1	0	0x0000c800 - 0x0000c8ff (0x100) IX[B]
	[3] -1	0	0x0000cc00 - 0x0000ccff (0x100) IX[B]
(II) Bus 1 non-prefetchable memory range:
	[0] -1	0	0xfc000000 - 0xfdffffff (0x2000000) MX[B]
(II) Bus 1 prefetchable memory range:
	[0] -1	0	0xe0000000 - 0xe7ffffff (0x8000000) MX[B]
(II) Subtractive PCI-to-PCI bridge:
(II) Bus 2: bridge is at (0:30:0), (0,2,16), BCTRL: 0x0006 (VGA_EN is cleared)
(II) Bus 2 I/O range:
	[0] -1	0	0x0000e000 - 0x0000e0ff (0x100) IX[B]
	[1] -1	0	0x0000e400 - 0x0000e4ff (0x100) IX[B]
	[2] -1	0	0x0000e800 - 0x0000e8ff (0x100) IX[B]
	[3] -1	0	0x0000ec00 - 0x0000ecff (0x100) IX[B]
	[4] -1	0	0x0000f000 - 0x0000f0ff (0x100) IX[B]
	[5] -1	0	0x0000f400 - 0x0000f4ff (0x100) IX[B]
	[6] -1	0	0x0000f800 - 0x0000f8ff (0x100) IX[B]
	[7] -1	0	0x0000fc00 - 0x0000fcff (0x100) IX[B]
(II) Bus 2 non-prefetchable memory range:
	[0] -1	0	0xf4000000 - 0xfbffffff (0x8000000) MX[B]
(II) Bus 2 prefetchable memory range:
	[0] -1	0	0x30000000 - 0x34ffffff (0x5000000) MX[B]
(II) PCI-to-ISA bridge:
(II) Bus -1: bridge is at (0:31:0), (0,-1,-1), BCTRL: 0x0008 (VGA_EN is set)
(II) PCI-to-CardBus bridge:
(II) Bus 3: bridge is at (2:1:0), (2,3,6), BCTRL: 0x05c0 (VGA_EN is cleared)
(II) Bus 3 I/O range:
	[0] -1	0	0x0000e000 - 0x0000e0ff (0x100) IX[B]
	[1] -1	0	0x0000e400 - 0x0000e4ff (0x100) IX[B]
(II) Bus 3 non-prefetchable memory range:
	[0] -1	0	0xf4000000 - 0xf5ffffff (0x2000000) MX[B]
(II) Bus 3 prefetchable memory range:
	[0] -1	0	0x30000000 - 0x31ffffff (0x2000000) MX[B]
(II) PCI-to-CardBus bridge:
(II) Bus 7: bridge is at (2:1:1), (2,7,10), BCTRL: 0x05c0 (VGA_EN is cleared)
(II) Bus 7 I/O range:
	[0] -1	0	0x0000e800 - 0x0000e8ff (0x100) IX[B]
(II) Bus 7 non-prefetchable memory range:
	[0] -1	0	0xf6000000 - 0xf7ffffff (0x2000000) MX[B]
(II) Bus 7 prefetchable memory range:
	[0] -1	0	0x32000000 - 0x33ffffff (0x2000000) MX[B]
(--) PCI:*(1:0:0) nVidia Corporation NV11 [GeForce2 Go] rev 178, Mem @
0xfc000000/24, 0xe0000000/27
(II) Addressable bus resource ranges are
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
	[1] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) OS-reported resource ranges:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
(II) PCI Memory resource overlap reduced 0xe8000000 from 0xebffffff to
0xe7ffffff
(II) Active PCI resource ranges:
	[0] -1	0	0xf8ff8000 - 0xf8ffbfff (0x4000) MX[B]
	[1] -1	0	0xf8fff000 - 0xf8fff7ff (0x800) MX[B]
	[2] -1	0	0xf8fffc00 - 0xf8fffc7f (0x80) MX[B]
	[3] -1	0	0x35000000 - 0x350003ff (0x400) MX[B]
	[4] -1	0	0xe8000000 - 0xe7ffffff (0x0) MX[B]O
	[5] -1	0	0xe0000000 - 0xe7ffffff (0x8000000) MX[B](B)
	[6] -1	0	0xfc000000 - 0xfcffffff (0x1000000) MX[B](B)
	[7] -1	0	0x0000ec80 - 0x0000ecff (0x80) IX[B]
	[8] -1	0	0x0000dc00 - 0x0000dc7f (0x80) IX[B]
	[9] -1	0	0x0000d400 - 0x0000d4ff (0x100) IX[B]
	[10] -1	0	0x0000dc80 - 0x0000dcbf (0x40) IX[B]
	[11] -1	0	0x0000d800 - 0x0000d8ff (0x100) IX[B]
	[12] -1	0	0x0000bfa0 - 0x0000bfaf (0x10) IX[B]
	[13] -1	0	0x00000374 - 0x00000374 (0x1) IX[B]
	[14] -1	0	0x00000170 - 0x00000170 (0x1) IX[B]
	[15] -1	0	0x000003f4 - 0x000003f4 (0x1) IX[B]
	[16] -1	0	0x000001f0 - 0x000001f0 (0x1) IX[B]
	[17] -1	0	0x0000bf20 - 0x0000bf3f (0x20) IX[B]
	[18] -1	0	0x0000bf80 - 0x0000bf9f (0x20) IX[B]
(II) Active PCI resource ranges after removing overlaps:
	[0] -1	0	0xf8ff8000 - 0xf8ffbfff (0x4000) MX[B]
	[1] -1	0	0xf8fff000 - 0xf8fff7ff (0x800) MX[B]
	[2] -1	0	0xf8fffc00 - 0xf8fffc7f (0x80) MX[B]
	[3] -1	0	0x35000000 - 0x350003ff (0x400) MX[B]
	[4] -1	0	0xe8000000 - 0xe7ffffff (0x0) MX[B]O
	[5] -1	0	0xe0000000 - 0xe7ffffff (0x8000000) MX[B](B)
	[6] -1	0	0xfc000000 - 0xfcffffff (0x1000000) MX[B](B)
	[7] -1	0	0x0000ec80 - 0x0000ecff (0x80) IX[B]
	[8] -1	0	0x0000dc00 - 0x0000dc7f (0x80) IX[B]
	[9] -1	0	0x0000d400 - 0x0000d4ff (0x100) IX[B]
	[10] -1	0	0x0000dc80 - 0x0000dcbf (0x40) IX[B]
	[11] -1	0	0x0000d800 - 0x0000d8ff (0x100) IX[B]
	[12] -1	0	0x0000bfa0 - 0x0000bfaf (0x10) IX[B]
	[13] -1	0	0x00000374 - 0x00000374 (0x1) IX[B]
	[14] -1	0	0x00000170 - 0x00000170 (0x1) IX[B]
	[15] -1	0	0x000003f4 - 0x000003f4 (0x1) IX[B]
	[16] -1	0	0x000001f0 - 0x000001f0 (0x1) IX[B]
	[17] -1	0	0x0000bf20 - 0x0000bf3f (0x20) IX[B]
	[18] -1	0	0x0000bf80 - 0x0000bf9f (0x20) IX[B]
(II) OS-reported resource ranges after removing overlaps with PCI:
	[0] -1	0	0x00100000 - 0x34ffffff (0x34f00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
(II) All system resource ranges:
	[0] -1	0	0x00100000 - 0x34ffffff (0x34f00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xf8ff8000 - 0xf8ffbfff (0x4000) MX[B]
	[5] -1	0	0xf8fff000 - 0xf8fff7ff (0x800) MX[B]
	[6] -1	0	0xf8fffc00 - 0xf8fffc7f (0x80) MX[B]
	[7] -1	0	0x35000000 - 0x350003ff (0x400) MX[B]
	[8] -1	0	0xe8000000 - 0xe7ffffff (0x0) MX[B]O
	[9] -1	0	0xe0000000 - 0xe7ffffff (0x8000000) MX[B](B)
	[10] -1	0	0xfc000000 - 0xfcffffff (0x1000000) MX[B](B)
	[11] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[12] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[13] -1	0	0x0000ec80 - 0x0000ecff (0x80) IX[B]
	[14] -1	0	0x0000dc00 - 0x0000dc7f (0x80) IX[B]
	[15] -1	0	0x0000d400 - 0x0000d4ff (0x100) IX[B]
	[16] -1	0	0x0000dc80 - 0x0000dcbf (0x40) IX[B]
	[17] -1	0	0x0000d800 - 0x0000d8ff (0x100) IX[B]
	[18] -1	0	0x0000bfa0 - 0x0000bfaf (0x10) IX[B]
	[19] -1	0	0x00000374 - 0x00000374 (0x1) IX[B]
	[20] -1	0	0x00000170 - 0x00000170 (0x1) IX[B]
	[21] -1	0	0x000003f4 - 0x000003f4 (0x1) IX[B]
	[22] -1	0	0x000001f0 - 0x000001f0 (0x1) IX[B]
	[23] -1	0	0x0000bf20 - 0x0000bf3f (0x20) IX[B]
	[24] -1	0	0x0000bf80 - 0x0000bf9f (0x20) IX[B]
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions/libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(II) Loading sub module "drm"
(II) LoadModule: "drm"
(II) Loading /usr/lib/xorg/modules/linux/libdrm.so
(II) Module drm: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension XFree86-DRI
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
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
(II) LoadModule: "freetype"
(II) Loading /usr/lib/xorg/modules/fonts/libfreetype.so
(II) Module freetype: vendor="X.Org Foundation & the After X-TT Project"
	compiled for 7.1.1, module version = 2.1.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.5
(II) Loading font FreeType
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions/libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions/librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension RECORD
(II) LoadModule: "speedo"
(WW) Warning, couldn't open module speedo
(II) UnloadModule: "speedo"
(EE) Failed to load module "speedo" (module does not exist, 0)
(II) LoadModule: "type1"
(II) Loading /usr/lib/xorg/modules/fonts/libtype1.so
(II) Module type1: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.2
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.5
(II) Loading font Type1
(II) LoadModule: "vbe"
(II) Loading /usr/lib/xorg/modules/libvbe.so
(II) Module vbe: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.1.0
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "nv"
(II) Loading /usr/lib/xorg/modules/drivers/nv_drv.so
(II) Module nv: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.2.0
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "kbd"
(II) Loading /usr/lib/xorg/modules/input/kbd_drv.so
(II) Module kbd: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.1.0
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 0.6
(II) LoadModule: "synaptics"
(II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
(II) Module synaptics: vendor="The XFree86 Project"
	compiled for 4.2.0, module version = 1.0.0
	Module class: XFree86 XInput Driver
	ABI class: XFree86 XInput driver, version 0.3
(II) LoadModule: "evdev"
(II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
(II) Module evdev: vendor="X.Org Foundation"
	compiled for 0.0.0, module version = 1.1.0
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 0.6
(II) NV: driver for NVIDIA chipsets: RIVA 128, RIVA TNT, RIVA TNT2,
	Unknown TNT2, Vanta, RIVA TNT2 Ultra, RIVA TNT2 Model 64,
	Aladdin TNT2, GeForce 256, GeForce DDR, Quadro, GeForce2 MX/MX 400,
	GeForce2 MX 100/200, GeForce2 Go, Quadro2 MXR/EX/Go,
	GeForce2 Integrated GPU, GeForce2 GTS, GeForce2 Ti, GeForce2 Ultra,
	Quadro2 Pro, GeForce4 MX 460, GeForce4 MX 440, GeForce4 MX 420,
	GeForce4 MX 440-SE, GeForce4 440 Go, GeForce4 420 Go,
	GeForce4 420 Go 32M, GeForce4 460 Go, Quadro4 550 XGL,
	GeForce4 440 Go 64M, Quadro NVS, Quadro4 500 GoGL,
	GeForce4 410 Go 16M, GeForce4 MX 440 with AGP8X,
	GeForce4 MX 440SE with AGP8X, GeForce4 MX 420 with AGP8X,
	GeForce4 MX 4000, GeForce4 448 Go, GeForce4 488 Go, Quadro4 580 XGL,
	Quadro4 NVS 280 SD, Quadro4 380 XGL, Quadro NVS 50 PCI,
	GeForce4 448 Go, GeForce4 MX Integrated GPU, GeForce3,
	GeForce3 Ti 200, GeForce3 Ti 500, Quadro DCC, GeForce4 Ti 4600,
	GeForce4 Ti 4400, GeForce4 Ti 4200, Quadro4 900 XGL, Quadro4 750 XGL,
	Quadro4 700 XGL, GeForce4 Ti 4800, GeForce4 Ti 4200 with AGP8X,
	GeForce4 Ti 4800 SE, GeForce4 4200 Go, Quadro4 700 GoGL,
	Quadro4 980 XGL, Quadro4 780 XGL, GeForce FX 5800 Ultra,
	GeForce FX 5800, Quadro FX 2000, Quadro FX 1000,
	GeForce FX 5600 Ultra, GeForce FX 5600, GeForce FX 5600XT,
	GeForce FX Go5600, GeForce FX Go5650, Quadro FX Go700,
	GeForce FX 5200, GeForce FX 5200 Ultra, GeForce FX 5200,
	GeForce FX 5200LE, GeForce FX Go5200, GeForce FX Go5250,
	GeForce FX 5500, GeForce FX 5100, GeForce FX Go5200 32M/64M,
	Quadro NVS 55/280 PCI, Quadro FX 500/600 PCI,
	GeForce FX Go53xx Series, GeForce FX Go5100, GeForce FX 5900 Ultra,
	GeForce FX 5900, GeForce FX 5900XT, GeForce FX 5950 Ultra,
	GeForce FX 5900ZT, Quadro FX 3000, Quadro FX 700,
	GeForce FX 5700 Ultra, GeForce FX 5700, GeForce FX 5700LE,
	GeForce FX 5700VE, GeForce FX Go5700, GeForce FX Go5700,
	Quadro FX Go1000, Quadro FX 1100, GeForce 6800 Ultra, GeForce 6800,
	GeForce 6800 LE, GeForce 6800 XE, GeForce 6800 XT, GeForce 6800 GT,
	GeForce 6800 GT, GeForce 6800 GS, GeForce 6800 XT, Quadro FX 4000,
	GeForce 6800 GS, GeForce 6800, GeForce 6800 LE, GeForce 6800 XT,
	GeForce Go 6800, GeForce Go 6800 Ultra, Quadro FX Go1400,
	Quadro FX 3450/4000 SDI, Quadro FX 1400, GeForce 6600 GT,
	GeForce 6600, GeForce 6600 LE, GeForce 6600 VE, GeForce Go 6600,
	GeForce 6610 XL, GeForce Go 6600 TE/6200 TE, GeForce 6700 XL,
	GeForce Go 6600, GeForce Go 6600 GT, Quadro FX 550, Quadro FX 550,
	Quadro FX 540, GeForce 6200, GeForce 6500,
	GeForce 6200 TurboCache(TM), GeForce 6200SE TurboCache(TM),
	GeForce 6200 LE, GeForce Go 6200, Quadro NVS 285, GeForce Go 6400,
	GeForce Go 6200, GeForce Go 6400, GeForce 6250, GeForce 6800,
	GeForce 6800 LE, GeForce 6800 GT, GeForce 6800 XT, GeForce 6200,
	GeForce 6200 A-LE, GeForce 7800 GTX, GeForce 7800 GTX,
	GeForce 7800 GT, GeForce 7800 GS, GeForce 7800 SLI, GeForce Go 7800,
	GeForce Go 7800 GTX, Quadro FX 4500, GeForce 7300 LE,
	GeForce 7300 SE, GeForce Go 7200, GeForce Go 7300, GeForce Go 7400,
	GeForce Go 7400 GS, Quadro NVS 110M, Quadro NVS 120M, Quadro FX 350M,
	GeForce 7500 LE, Quadro FX 350, GeForce 7300 GS, GeForce 7600 GT,
	GeForce 7600 GS, GeForce 7300 GT, GeForce 7600 LE, GeForce 7300 GT,
	GeForce Go 7700, GeForce Go 7600, GeForce Go 7600 GT,
	Quadro NVS 300M, GeForce Go 7900 SE, Quadro FX 550M, Quadro FX 560,
	GeForce 7900 GTX, GeForce 7900 GT, GeForce 7900 GS,
	GeForce Go 7900 GS, GeForce Go 7900 GTX, Quadro FX 2500M,
	Quadro FX 1500M, Quadro FX 5500, Quadro FX 3500, Quadro FX 1500,
	Quadro FX 4500 X2, GeForce 6150, GeForce 6150 LE, GeForce 6100,
	GeForce Go 6150, GeForce Go 6100
(II) Primary Device is: PCI 01:00:0
(--) Assigning device section with no busID to primary device
(--) Chipset GeForce2 Go found
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0x00100000 - 0x34ffffff (0x34f00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xf8ff8000 - 0xf8ffbfff (0x4000) MX[B]
	[5] -1	0	0xf8fff000 - 0xf8fff7ff (0x800) MX[B]
	[6] -1	0	0xf8fffc00 - 0xf8fffc7f (0x80) MX[B]
	[7] -1	0	0x35000000 - 0x350003ff (0x400) MX[B]
	[8] -1	0	0xe8000000 - 0xe7ffffff (0x0) MX[B]O
	[9] -1	0	0xe0000000 - 0xe7ffffff (0x8000000) MX[B](B)
	[10] -1	0	0xfc000000 - 0xfcffffff (0x1000000) MX[B](B)
	[11] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[12] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[13] -1	0	0x0000ec80 - 0x0000ecff (0x80) IX[B]
	[14] -1	0	0x0000dc00 - 0x0000dc7f (0x80) IX[B]
	[15] -1	0	0x0000d400 - 0x0000d4ff (0x100) IX[B]
	[16] -1	0	0x0000dc80 - 0x0000dcbf (0x40) IX[B]
	[17] -1	0	0x0000d800 - 0x0000d8ff (0x100) IX[B]
	[18] -1	0	0x0000bfa0 - 0x0000bfaf (0x10) IX[B]
	[19] -1	0	0x00000374 - 0x00000374 (0x1) IX[B]
	[20] -1	0	0x00000170 - 0x00000170 (0x1) IX[B]
	[21] -1	0	0x000003f4 - 0x000003f4 (0x1) IX[B]
	[22] -1	0	0x000001f0 - 0x000001f0 (0x1) IX[B]
	[23] -1	0	0x0000bf20 - 0x0000bf3f (0x20) IX[B]
	[24] -1	0	0x0000bf80 - 0x0000bf9f (0x20) IX[B]
(II) resource ranges after probing:
	[0] -1	0	0x00100000 - 0x34ffffff (0x34f00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xf8ff8000 - 0xf8ffbfff (0x4000) MX[B]
	[5] -1	0	0xf8fff000 - 0xf8fff7ff (0x800) MX[B]
	[6] -1	0	0xf8fffc00 - 0xf8fffc7f (0x80) MX[B]
	[7] -1	0	0x35000000 - 0x350003ff (0x400) MX[B]
	[8] -1	0	0xe8000000 - 0xe7ffffff (0x0) MX[B]O
	[9] -1	0	0xe0000000 - 0xe7ffffff (0x8000000) MX[B](B)
	[10] -1	0	0xfc000000 - 0xfcffffff (0x1000000) MX[B](B)
	[11] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[12] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[13] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[14] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[15] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[16] -1	0	0x0000ec80 - 0x0000ecff (0x80) IX[B]
	[17] -1	0	0x0000dc00 - 0x0000dc7f (0x80) IX[B]
	[18] -1	0	0x0000d400 - 0x0000d4ff (0x100) IX[B]
	[19] -1	0	0x0000dc80 - 0x0000dcbf (0x40) IX[B]
	[20] -1	0	0x0000d800 - 0x0000d8ff (0x100) IX[B]
	[21] -1	0	0x0000bfa0 - 0x0000bfaf (0x10) IX[B]
	[22] -1	0	0x00000374 - 0x00000374 (0x1) IX[B]
	[23] -1	0	0x00000170 - 0x00000170 (0x1) IX[B]
	[24] -1	0	0x000003f4 - 0x000003f4 (0x1) IX[B]
	[25] -1	0	0x000001f0 - 0x000001f0 (0x1) IX[B]
	[26] -1	0	0x0000bf20 - 0x0000bf3f (0x20) IX[B]
	[27] -1	0	0x0000bf80 - 0x0000bf9f (0x20) IX[B]
	[28] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[29] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) Setting vga for screen 0.
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Loading /usr/lib/xorg/modules/libint10.so
(II) Module int10: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Video Driver, version 1.0
(II) NV(0): Initializing int10
(II) NV(0): Primary V_BIOS segment is: 0xc000
(--) NV(0): Chipset: "GeForce2 Go"
(**) NV(0): Depth 24, (--) framebuffer bpp 32
(==) NV(0): RGB weight 888
(==) NV(0): Default visual is TrueColor
(II) Loading sub module "vgahw"
(II) LoadModule: "vgahw"
(II) Loading /usr/lib/xorg/modules/libvgahw.so
(II) Module vgahw: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 0.1.0
	ABI class: X.Org Video Driver, version 1.0
(==) NV(0): Using HW cursor
(--) NV(0): Linear framebuffer at 0xE0000000
(--) NV(0): MMIO registers at 0xFC000000
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"
(II) Loading /usr/lib/xorg/modules/libi2c.so
(II) Module i2c: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.2.0
	ABI class: X.Org Video Driver, version 1.0
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Loading /usr/lib/xorg/modules/libddc.so
(II) Module ddc: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Video Driver, version 1.0
(II) NV(0): I2C bus "DDC" initialized.
(II) NV(0): Probing for EDID on I2C bus A...
(II) NV(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) NV(0): I2C device "DDC:ddc2" removed.
(II) NV(0):   ... none found
(II) NV(0): Probing for EDID on I2C bus B...
(II) NV(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) NV(0): I2C device "DDC:ddc2" removed.
(--) NV(0): DDC detected a DFP:
(II) NV(0): Manufacturer: SHP  Model: 138e  Serial#: 0
(II) NV(0): Year: 1990  Week: 0
(II) NV(0): EDID Version: 1.3
(II) NV(0): Digital Display Input
(II) NV(0): Max H-Image Size [cm]: horiz.: 30  vert.: 23
(II) NV(0): Gamma: 2.20
(II) NV(0): DPMS capabilities: StandBy Suspend; RGB/Color Display
(II) NV(0): First detailed timing is preferred mode
(II) NV(0): redX: 0.599 redY: 0.335   greenX: 0.312 greenY: 0.552
(II) NV(0): blueX: 0.150 blueY: 0.145   whiteX: 0.312 whiteY: 0.328
(II) NV(0): Manufacturer's mask: 0
(II) NV(0): Supported Future Video Modes:
(II) NV(0): #0: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
(II) NV(0): Supported additional Video Mode:
(II) NV(0): clock: 160.0 MHz   Image Size:  304 x 228 mm
(II) NV(0): h_active: 1600  h_sync: 1664  h_sync_end 1856 h_blank_end
2112 h_border: 0
(II) NV(0): v_active: 1200  v_sync: 1201  v_sync_end 1204 v_blanking:
1250 v_border: 0
(--) NV(0): CRTC 1 is currently programmed for DFP
(II) NV(0): Using DFP on CRTC 1
(--) NV(0): Panel size is 1600 x 1200
(II) NV(0): Panel is LVDS
(--) NV(0): VideoRAM: 32768 kBytes
(**) NV(0): Using gamma correction (0.7, 0.7, 0.7)
(WW) NV(0): config file hsync range 30-100kHz not within DDC hsync ranges.
(II) NV(0): Dell Inspiron 8200 built-in monitor: Using hsync range of
30.00-100.00 kHz
(II) NV(0): Dell Inspiron 8200 built-in monitor: Using vrefresh value
of 60.00 Hz
(II) NV(0): Clock range:  12.00 to 350.00 MHz
(II) NV(0): Not using default mode "640x350" (vrefresh out of range)
(II) NV(0): Not using default mode "320x175" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "640x400" (vrefresh out of range)
(II) NV(0): Not using default mode "320x200" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "720x400" (vrefresh out of range)
(II) NV(0): Not using default mode "360x200" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "320x240" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "640x480" (vrefresh out of range)
(II) NV(0): Not using default mode "320x240" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "640x480" (vrefresh out of range)
(II) NV(0): Not using default mode "320x240" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "640x480" (vrefresh out of range)
(II) NV(0): Not using default mode "320x240" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "800x600" (vrefresh out of range)
(II) NV(0): Not using default mode "400x300" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "400x300" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "800x600" (vrefresh out of range)
(II) NV(0): Not using default mode "400x300" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "800x600" (vrefresh out of range)
(II) NV(0): Not using default mode "400x300" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "800x600" (vrefresh out of range)
(II) NV(0): Not using default mode "400x300" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1024x768" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "512x384" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "512x384" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1024x768" (vrefresh out of range)
(II) NV(0): Not using default mode "512x384" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1024x768" (vrefresh out of range)
(II) NV(0): Not using default mode "512x384" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1024x768" (vrefresh out of range)
(II) NV(0): Not using default mode "512x384" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1152x864" (vrefresh out of range)
(II) NV(0): Not using default mode "576x432" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "640x480" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1280x960" (vrefresh out of range)
(II) NV(0): Not using default mode "640x480" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "640x512" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1280x1024" (vrefresh out of range)
(II) NV(0): Not using default mode "640x512" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1280x1024" (vrefresh out of range)
(II) NV(0): Not using default mode "640x512" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "800x600" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1600x1200" (vrefresh out of range)
(II) NV(0): Not using default mode "800x600" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1600x1200" (vrefresh out of range)
(II) NV(0): Not using default mode "800x600" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1600x1200" (vrefresh out of range)
(II) NV(0): Not using default mode "800x600" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1600x1200" (hsync out of range)
(II) NV(0): Not using default mode "800x600" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1792x1344" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1792x1344" (unknown reason)
(II) NV(0): Not using default mode "896x672" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1792x1344" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1792x1344" (unknown reason)
(II) NV(0): Not using default mode "896x672" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1856x1392" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1856x1392" (unknown reason)
(II) NV(0): Not using default mode "928x696" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1856x1392" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1856x1392" (unknown reason)
(II) NV(0): Not using default mode "928x696" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1920x1440" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1920x1440" (unknown reason)
(II) NV(0): Not using default mode "960x720" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1920x1440" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1920x1440" (unknown reason)
(II) NV(0): Not using default mode "960x720" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "832x624" (vrefresh out of range)
(II) NV(0): Not using default mode "416x312" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "640x384" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "640x400" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1152x768" (vrefresh out of range)
(II) NV(0): Not using default mode "576x384" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1152x864" (vrefresh out of range)
(II) NV(0): Not using default mode "576x432" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "700x525" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1400x1050" (vrefresh out of range)
(II) NV(0): Not using default mode "700x525" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1400x1050" (vrefresh out of range)
(II) NV(0): Not using default mode "700x525" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1400x1050" (vrefresh out of range)
(II) NV(0): Not using default mode "700x525" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "720x450" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "800x512" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1680x1050" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1680x1050" (unknown reason)
(II) NV(0): Not using default mode "840x525" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1920x1200" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1920x1200" (unknown reason)
(II) NV(0): Not using default mode "960x600" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1920x1200" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1920x1200" (unknown reason)
(II) NV(0): Not using default mode "960x600" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "1920x1440" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "1920x1440" (unknown reason)
(II) NV(0): Not using default mode "960x720" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "2048x1536" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "2048x1536" (unknown reason)
(II) NV(0): Not using default mode "1024x768" (bad mode
clock/interlace/doublescan)
(II) NV(0): Mode "2048x1536" is larger than BIOS programmed panel size
of 1600 x 1200.  Removing.
(II) NV(0): Not using default mode "2048x1536" (unknown reason)
(II) NV(0): Not using default mode "1024x768" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "2048x1536" (bad mode
clock/interlace/doublescan)
(II) NV(0): Not using default mode "1024x768" (bad mode
clock/interlace/doublescan)
(--) NV(0): Virtual size is 1600x1200 (pitch 1600)
(**) NV(0): *Default mode "1600x1200": 162.0 MHz, 75.0 kHz, 60.0 Hz
(II) NV(0): Modeline "1600x1200"  162.00  1600 1664 1856 2160  1200
1201 1204 1250 +hsync +vsync
(**) NV(0): *Default mode "1024x768": 65.0 MHz, 48.4 kHz, 60.0 Hz
(II) NV(0): Modeline "1024x768"   65.00  1024 1048 1184 1344  768 771
777 806 -hsync -vsync
(**) NV(0): *Default mode "800x600": 40.0 MHz, 37.9 kHz, 60.3 Hz
(II) NV(0): Modeline "800x600"   40.00  800 840 968 1056  600 601 605
628 +hsync +vsync
(**) NV(0): *Default mode "640x480": 25.2 MHz, 31.5 kHz, 60.0 Hz
(II) NV(0): Modeline "640x480"   25.20  640 656 752 800  480 490 492
525 -hsync -vsync
(**) NV(0):  Default mode "1400x1050": 122.0 MHz, 64.9 kHz, 60.0 Hz
(II) NV(0): Modeline "1400x1050"  122.00  1400 1488 1640 1880  1050
1052 1064 1082 +hsync +vsync
(**) NV(0):  Default mode "1280x1024": 108.0 MHz, 64.0 kHz, 60.0 Hz
(II) NV(0): Modeline "1280x1024"  108.00  1280 1328 1440 1688  1024
1025 1028 1066 +hsync +vsync
(**) NV(0):  Default mode "1440x900": 108.8 MHz, 56.9 kHz, 60.2 Hz
(II) NV(0): Modeline "1440x900"  108.84  1440 1472 1880 1912  900 918
927 946 +hsync +vsync
(**) NV(0):  Default mode "1280x960": 108.0 MHz, 60.0 kHz, 60.0 Hz
(II) NV(0): Modeline "1280x960"  108.00  1280 1376 1488 1800  960 961
964 1000 +hsync +vsync
(**) NV(0):  Default mode "1280x800": 83.5 MHz, 49.7 kHz, 60.0 Hz
(II) NV(0): Modeline "1280x800"   83.46  1280 1344 1480 1680  800 801 804 828
(**) NV(0):  Default mode "1280x768": 80.1 MHz, 47.7 kHz, 60.0 Hz
(II) NV(0): Modeline "1280x768"   80.14  1280 1344 1480 1680  768 769 772 795
(++) NV(0): DPI set to (100, 100)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules/libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.3
(II) Loading sub module "xaa"
(II) LoadModule: "xaa"
(II) Loading /usr/lib/xorg/modules/libxaa.so
(II) Module xaa: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.2.0
	ABI class: X.Org Video Driver, version 1.0
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"
(II) Loading /usr/lib/xorg/modules/libramdac.so
(II) Module ramdac: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 0.1.0
	ABI class: X.Org Video Driver, version 1.0
(--) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] 0	0	0xe0000000 - 0xe7ffffff (0x8000000) MX[B]
	[1] 0	0	0xfc000000 - 0xfcffffff (0x1000000) MX[B]
	[2] -1	0	0x00100000 - 0x34ffffff (0x34f00000) MX[B]E(B)
	[3] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[4] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[5] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[6] -1	0	0xf8ff8000 - 0xf8ffbfff (0x4000) MX[B]
	[7] -1	0	0xf8fff000 - 0xf8fff7ff (0x800) MX[B]
	[8] -1	0	0xf8fffc00 - 0xf8fffc7f (0x80) MX[B]
	[9] -1	0	0x35000000 - 0x350003ff (0x400) MX[B]
	[10] -1	0	0xe8000000 - 0xe7ffffff (0x0) MX[B]O
	[11] -1	0	0xe0000000 - 0xe7ffffff (0x8000000) MX[B](B)
	[12] -1	0	0xfc000000 - 0xfcffffff (0x1000000) MX[B](B)
	[13] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B](OprD)
	[14] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B](OprD)
	[15] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B](OprD)
	[16] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[17] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[18] -1	0	0x0000ec80 - 0x0000ecff (0x80) IX[B]
	[19] -1	0	0x0000dc00 - 0x0000dc7f (0x80) IX[B]
	[20] -1	0	0x0000d400 - 0x0000d4ff (0x100) IX[B]
	[21] -1	0	0x0000dc80 - 0x0000dcbf (0x40) IX[B]
	[22] -1	0	0x0000d800 - 0x0000d8ff (0x100) IX[B]
	[23] -1	0	0x0000bfa0 - 0x0000bfaf (0x10) IX[B]
	[24] -1	0	0x00000374 - 0x00000374 (0x1) IX[B]
	[25] -1	0	0x00000170 - 0x00000170 (0x1) IX[B]
	[26] -1	0	0x000003f4 - 0x000003f4 (0x1) IX[B]
	[27] -1	0	0x000001f0 - 0x000001f0 (0x1) IX[B]
	[28] -1	0	0x0000bf20 - 0x0000bf3f (0x20) IX[B]
	[29] -1	0	0x0000bf80 - 0x0000bf9f (0x20) IX[B]
	[30] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B](OprU)
	[31] 0	0	0x000003c0 - 0x000003df (0x20) IS[B](OprU)
(==) NV(0): Write-combining range (0xe0000000,0x2000000)
(II) NV(0): Using XFree86 Acceleration Architecture (XAA)
	Screen to screen bit blits
	Solid filled rectangles
	8x8 mono pattern filled rectangles
	Indirect CPU to Screen color expansion
	Solid Lines
	Scanline Image Writes
	Offscreen Pixmaps
	Setting up tile and stipple cache:
		32 128x128 slots
		29 256x256 slots
		14 512x512 slots
(==) NV(0): Backing store disabled
(==) NV(0): Silken mouse enabled
(**) Option "dpms"
(**) NV(0): DPMS enabled
(==) RandR enabled
(II) Initializing built-in extension MIT-SHM
(II) Initializing built-in extension XInputExtension
(II) Initializing built-in extension XTEST
(II) Initializing built-in extension XKEYBOARD
(II) Initializing built-in extension XC-APPGROUP
(II) Initializing built-in extension SECURITY
(II) Initializing built-in extension XINERAMA
(II) Initializing built-in extension XFIXES
(II) Initializing built-in extension XFree86-Bigfont
(II) Initializing built-in extension RENDER
(II) Initializing built-in extension RANDR
(II) Initializing built-in extension COMPOSITE
(II) Initializing built-in extension DAMAGE
(II) Initializing built-in extension XEVIE
(EE) AIGLX: Screen 0 is not DRI capable
(II) Loading local sub module "GLcore"
(II) LoadModule: "GLcore"
(II) Loading /usr/lib/xorg/modules/extensions/libGLcore.so
(II) Module GLcore: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(II) GLX: Initialized MESA-PROXY GL provider for screen 0
(**) Option "CoreKeyboard"
(**) Inspiron built-in keyboard: Core Keyboard
(**) Option "Protocol" "standard"
(**) Inspiron built-in keyboard: Protocol: standard
(**) Option "AutoRepeat" "500 30"
(**) Option "XkbRules" "xorg"
(**) Inspiron built-in keyboard: XkbRules: "xorg"
(**) Option "XkbModel" "inspiron"
(**) Inspiron built-in keyboard: XkbModel: "inspiron"
(**) Option "XkbLayout" "us(intl)"
(**) Inspiron built-in keyboard: XkbLayout: "us(intl)"
(**) Option "CustomKeycodes" "off"
(**) Inspiron built-in keyboard: CustomKeycodes disabled
(II) Synaptics touchpad driver version 0.14.6 (1406)
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(**) Option "SHMConfig" "true"
(**) Option "LeftEdge" "100"
(**) Option "RightEdge" "920"
(**) Option "TopEdge" "70"
(**) Option "BottomEdge" "650"
(**) Option "VertScrollDelta" "10"
(**) Option "HorizScrollDelta" "10"
(**) Option "CircularScrolling" "1"
(**) Option "CircScrollTrigger" "4"
(--) Inspiron built-in touchpad touchpad found
(**) Option "CorePointer"
(**) Inspiron built-in touchpad: Core Pointer
(II) evdev brain: Rescanning devices (1).
(EE) PreInit returned NULL for "ACECAD Tablet"
(II) XINPUT: Adding extended input device "evdev brain" (type: evdev brain)
(II) XINPUT: Adding extended input device "Inspiron built-in touchpad"
(type: MOUSE)
(II) XINPUT: Adding extended input device "Inspiron built-in keyboard"
(type: KEYBOARD)
    xkb_keycodes             { include "xfree86+aliases(qwerty)" };
    xkb_types                { include "complete" };
    xkb_compatibility        { include "complete" };
    xkb_symbols              { include "pc(pc105)+us(intl)+inet(inspiron)" };
    xkb_geometry             { include "pc(pc104)" };
Synaptics DeviceInit called
SynapticsCtrl called.
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
(II) evdev brain: Rescanning devices (2).
SynapticsCtrl called.
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (3).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (4).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (5).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (6).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (7).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (8).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (9).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (10).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (11).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (12).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found
Synaptics DeviceOff called
(II) Open ACPI successful (/var/run/acpid.socket)
(II) evdev brain: Rescanning devices (13).
Synaptics DeviceOn called
(--) Inspiron built-in touchpad auto-dev sets device to /dev/input/event3
(**) Option "Device" "/dev/input/event3"
(--) Inspiron built-in touchpad touchpad found

-- 
Giuseppe "Oblomov" Bilotta
