Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962Ab0AFRhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0AFRhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407Ab0AFRhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:37:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:48638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab0AFRhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:37:20 -0500
Date: Wed, 6 Jan 2010 17:37:18 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
Subject: Re: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images
 displayed  are side by side (should only show one).
In-Reply-To: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001061736080.5372@casper.infradead.org>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> For a long time I have gotten two pictures of Tux showing up when I
> include the Tux display option in my custom kernel builds.  I don't
> know how many kernel revisions ago it was when I started noticing
> this.  It seems like it might have been early in the 2.6 series
> kernels.
> 
> dmesg:
> 
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel 945GME Chipset
> agpgart-intel 0000:00:00.0: detected 7932K stolen memory
> agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [drm] Initialized drm 1.1.0 20060810
> i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0: setting latency timer to 64
> [drm] set up 7M of stolen space
> integrated sync not supported
> ACPI: Battery Slot [BAT0] (battery present)
> [drm] initialized overlay support
> [drm] LVDS-8: set mode 1024x600 27
> Console: switching to colour frame buffer device 128x37
> fb0: inteldrmfb frame buffer device
> registered panic notifier
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 

> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_INTEL=y
> CONFIG_VGA_ARB=y
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_KMS=y
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> # Frame buffer hardware drivers
> #
> CONFIG_FB_VESA=y
> CONFIG_FB_EFI=y

Try disabling these two above options.

