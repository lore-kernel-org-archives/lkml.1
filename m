Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbXGRNpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbXGRNpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXGRNpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:45:18 -0400
Received: from [212.12.190.240] ([212.12.190.240]:32850 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753859AbXGRNpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:45:16 -0400
From: Al Boldi <a1426z@gawab.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: VESAFB CUSTOM RESOLUTION
Date: Wed, 18 Jul 2007 16:45:01 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200707181342.00647.a1426z@gawab.com> <1184760917.4523.13.camel@daplas>
In-Reply-To: <1184760917.4523.13.camel@daplas>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dlhnG5I+lXpiilP"
Message-Id: <200707181645.01097.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary-00=_dlhnG5I+lXpiilP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Antonino A. Daplas wrote:
> On Wed, 2007-07-18 at 13:42 +0300, Al Boldi wrote:
> > Geert Uytterhoeven wrote:
> > > On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> >
> > Is there any technical reason why vesafb shouldn't support non-BIOS
> > modes?
>
> vesafb can only use modes included by the vendor in the card's BIOS. The
> mode table contains standard modes defined by VESA, and perhaps
> vendor-defined custom modes. However, the mode ID of custom modes varies
> from card to card, so you have to 'probe' the BIOS first for the list of
> modes and their associated ID.  X + the 'vesa' driver does that probe,
> and so does the lrmi tool vbetest.
>
> So, one cannot just set any mode, unless that mode is already defined in
> the BIOS mode table. In VBE 3.0, you might be able to choose an
> arbitrary vertical refresh rate, but that's the best mode tuning you can
> do with the video BIOS.

Thanks for a great explanation!

Looks like this chip supports VBE 3.0, but it only locks into 60Hz refresh.  
Here is an excerpt; full log attached.


Thanks!

============================
(II) Loading sub module "vbe"
(II) LoadModule: "vbe"
(II) Loading /usr/X11R6/lib/modules/libvbe.a
(II) Module vbe: vendor="The XFree86 Project"
	compiled for 4.3.0, module version = 1.1.0
	ABI class: XFree86 Video Driver, version 0.6
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Loading /usr/X11R6/lib/modules/linux/libint10.a
(II) Module int10: vendor="The XFree86 Project"
	compiled for 4.3.0, module version = 1.0.0
	ABI class: XFree86 Video Driver, version 0.6
(II) VESA(0): initializing int10
(II) VESA(0): Primary V_BIOS segment is: 0xc000
(II) VESA(0): VESA BIOS detected
(II) VESA(0): VESA VBE Version 3.0
(II) VESA(0): VESA VBE Total Mem: 16384 kB
(II) VESA(0): VESA VBE OEM: VIA P4M800 PRO

(II) VESA(0): VESA VBE OEM Software Rev: 1.0
(II) VESA(0): VESA VBE OEM Vendor: 
(II) VESA(0): VESA VBE OEM Product: 
(II) VESA(0): VESA VBE OEM Product Rev: 
(**) VESA(0): Depth 16, (--) framebuffer bpp 16
(==) VESA(0): RGB weight 565
(==) VESA(0): Default visual is TrueColor
(==) VESA(0): Using gamma correction (1.0, 1.0, 1.0)
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Loading /usr/X11R6/lib/modules/libddc.a
(II) Module ddc: vendor="The XFree86 Project"
	compiled for 4.3.0, module version = 1.0.0
	ABI class: XFree86 Video Driver, version 0.6
(II) VESA(0): VESA VBE DDC supported
(II) VESA(0): VESA VBE DDC Level 2
(II) VESA(0): VESA VBE DDC transfer in appr. 1 sec.
(II) VESA(0): VESA VBE DDC read successfully
(II) VESA(0): Manufacturer: API  Model: 9805  Serial#: 1209
(II) VESA(0): Year: 2002  Week: 8
(II) VESA(0): EDID Version: 1.3
(II) VESA(0): Analog Display Input,  Input Voltage Level: 0.700/0.300 V
(II) VESA(0): Sync:  Separate
(II) VESA(0): Max H-Image Size [cm]: horiz.: 31  vert.: 23
(II) VESA(0): Gamma: 2.90
(II) VESA(0): DPMS capabilities: StandBy Suspend Off; RGB/Color Display
(II) VESA(0): First detailed timing is preferred mode
(II) VESA(0): redX: 0.645 redY: 0.320   greenX: 0.273 greenY: 0.593
(II) VESA(0): blueX: 0.143 blueY: 0.063   whiteX: 0.282 whiteY: 0.297
(II) VESA(0): Supported VESA Video Modes:
(II) VESA(0): 720x400@70Hz
(II) VESA(0): 640x480@60Hz
(II) VESA(0): 640x480@72Hz
(II) VESA(0): 640x480@75Hz
(II) VESA(0): 800x600@56Hz
(II) VESA(0): 800x600@60Hz
(II) VESA(0): 800x600@72Hz
(II) VESA(0): 800x600@75Hz
(II) VESA(0): 1024x768@60Hz
(II) VESA(0): 1024x768@70Hz
(II) VESA(0): 1024x768@75Hz
(II) VESA(0): 1280x1024@75Hz
(II) VESA(0): Manufacturer's mask: 0
(II) VESA(0): Supported Future Video Modes:
(II) VESA(0): #0: hsize: 800  vsize 600  refresh: 85  vid: 22853
(II) VESA(0): #1: hsize: 1024  vsize 768  refresh: 85  vid: 22881
(II) VESA(0): #2: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
(II) VESA(0): #3: hsize: 1600  vsize 1200  refresh: 65  vid: 17833
(II) VESA(0): Supported additional Video Mode:
(II) VESA(0): clock: 94.5 MHz   Image Size:  310 x 230 mm
(II) VESA(0): h_active: 1024  h_sync: 1072  h_sync_end 1168 h_blank_end 1376 
h_border: 0
(II) VESA(0): v_active: 768  v_sync: 769  v_sync_end 772 v_blanking: 808 
v_border: 0
(II) VESA(0): Monitor name: Acer G781
(II) VESA(0): Serial No: 01209
(II) VESA(0): Ranges: V min: 50  V max: 120 Hz, H min: 30  H max: 86 kHz, 
PixClock max 130 MHz
 :
 :
(II) VESA(0): Total Memory: 256 64KB banks (16384kB)
(II) VESA(0): monitor1: Using hsync range of 30.00-86.00 kHz
(II) VESA(0): monitor1: Using vrefresh range of 50.00-120.00 Hz
(II) VESA(0): Not using built-in mode "1600x1200" (width too large for 
virtual size)
(II) VESA(0): Not using built-in mode "1280x1024" (width too large for 
virtual size)
(--) VESA(0): Virtual size is 1024x768 (pitch 1024)
(**) VESA(0): *Built-in mode "1024x768"
(**) VESA(0): *Built-in mode "800x600"
(**) VESA(0): *Built-in mode "640x480"
(--) VESA(0): Display dimensions: (310, 230) mm
(--) VESA(0): DPI set to (83, 84)
(II) VESA(0): Attempting to use 85Hz refresh for mode "1024x768" (117)
(II) VESA(0): Attempting to use 85Hz refresh for mode "800x600" (114)
(II) VESA(0): Attempting to use 85Hz refresh for mode "640x480" (111)
(**) VESA(0): Using "Shadow Framebuffer"
(II) Loading sub module "shadow"
(II) LoadModule: "shadow"
(II) Loading /usr/X11R6/lib/modules/libshadow.a
(II) Module shadow: vendor="The XFree86 Project"
	compiled for 4.3.0, module version = 1.0.0
	ABI class: XFree86 ANSI C Emulation, version 0.2
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/X11R6/lib/modules/libfb.a
(II) Module fb: vendor="The XFree86 Project"
	compiled for 4.3.0, module version = 1.0.0
	ABI class: XFree86 ANSI C Emulation, version 0.2
(II) do I need RAC?  No, I don't.
 :
 :
(II) LoadModule: "int10"
(II) Reloading /usr/X11R6/lib/modules/linux/libint10.a
(II) VESA(0): initializing int10
(II) VESA(0): Primary V_BIOS segment is: 0xc000
(II) VESA(0): VESA BIOS detected
(II) VESA(0): VESA VBE Version 3.0
(II) VESA(0): VESA VBE Total Mem: 16384 kB
(II) VESA(0): VESA VBE OEM: VIA P4M800 PRO

(II) VESA(0): VESA VBE OEM Software Rev: 1.0
(II) VESA(0): VESA VBE OEM Vendor: 
(II) VESA(0): VESA VBE OEM Product: 
(II) VESA(0): VESA VBE OEM Product Rev: 
(==) VESA(0): Write-combining range (0xf4000000,0x1000000)
(II) VESA(0): virtual address = 0xb6d7f000,
	physical address = 0xf4000000, size = 16777216
(II) VESA(0): VBESetVBEMode failed...Tried again without customized values.

--
Al



--Boundary-00=_dlhnG5I+lXpiilP
Content-Type: application/x-bzip2;
  name="x.log.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="x.log.bz2"

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
RelERNV//F3JFOFCQNTUWpw=

--Boundary-00=_dlhnG5I+lXpiilP--

