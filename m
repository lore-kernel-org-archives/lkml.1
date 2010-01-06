Return-Path: <linux-kernel-owner+w=401wt.eu-S932380Ab0AFRQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab0AFRQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945Ab0AFRQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:16:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37772 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab0AFRQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:16:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UTjUY7UU5KB6QhCqhdu9uWKWhHSY0kEGRzLGj0Amp67gt9DgRe5kD5ozmZ6OOQrd9k
         mAwe+auoIa47N0kwE78K7N9J5eb35BVgIvdZvliey5ciGUsm2ViMJjadthb5S+Ul+cbA
         Kz4eisFYr+lPrzk6yoozuWK+KHanim4o44Db0=
MIME-Version: 1.0
Date: Wed, 6 Jan 2010 12:16:37 -0500
Message-ID: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
Subject: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images displayed 
	are side by side (should only show one).
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a long time I have gotten two pictures of Tux showing up when I
include the Tux display option in my custom kernel builds.  I don't
know how many kernel revisions ago it was when I started noticing
this.  It seems like it might have been early in the 2.6 series
kernels.

dmesg:

Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GME Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm] set up 7M of stolen space
integrated sync not supported
ACPI: Battery Slot [BAT0] (battery present)
[drm] initialized overlay support
[drm] LVDS-8: set mode 1024x600 27
Console: switching to colour frame buffer device 128x37
fb0: inteldrmfb frame buffer device
registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

# lspci -vvxxx -s 2.1

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: ASUSTeK Computer Inc. Device 8340
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f7f80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 86 80 a6 27 07 00 90 00 03 00 80 03 00 00 80 00
10: 00 00 f8 f7 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 40 83
30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 48 00 00 00 09 00 09 71 23 25 4a a1
50: 0e 00 30 00 1b 00 00 00 00 00 00 00 00 00 80 7f
60: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 88 40 64 34 10 00 00 00 86 0f 05 00 00 00 00 00

>From .config:

# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_VGA_ARB=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

# Frame buffer hardware drivers
#
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y

# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_CLUT224=y
