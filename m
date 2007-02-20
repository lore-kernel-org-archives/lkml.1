Return-Path: <linux-kernel-owner+w=401wt.eu-S965554AbXBTAJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554AbXBTAJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965600AbXBTAIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:50 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36172 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbXBTAIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:30 -0500
Date: Tue, 20 Feb 2007 01:08:29 +0100
From: Adrian Bunk <bunk@stusta.de>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org
Subject: BACKLIGHT_CLASS_DEVICE=y, SYSFS=n compile error
Message-ID: <20070220000829.GO13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_BACKLIGHT_CLASS_DEVICE=y, CONFIG_SYSFS=n results int he 
following compile error:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `nvidia_bl_exit':
(.text+0x27d01): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `nvidia_bl_init':
(.text+0x27e3c): undefined reference to `backlight_device_register'
drivers/built-in.o: In function `radeonfb_bl_exit':
(.text+0x3b64e): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `radeonfb_bl_init':
(.text+0x3b6d1): undefined reference to `backlight_device_register'
drivers/built-in.o: In function `acpi_video_bus_put_devices':
video.c:(.text+0x9a798): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `brightness_exit':
ibm_acpi.c:(.text+0xa393f): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `brightness_init':
ibm_acpi.c:(.text+0xa569c): undefined reference to `backlight_device_register'
drivers/built-in.o: In function `sony_acpi_add':
sony-laptop.c:(.text+0x183c4e): undefined reference to `backlight_device_register'
sony-laptop.c:(.text+0x183da1): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `sony_acpi_remove':
sony-laptop.c:(.text+0x183de5): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `appledisplay_disconnect':
appledisplay.c:(.text+0x6a4d18): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `appledisplay_probe':
appledisplay.c:(.text+0x6a4f17): undefined reference to `backlight_device_register'
appledisplay.c:(.text+0x6a4f88): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `rivafb_probe':
fbdev.c:(.init.text+0x4e23): undefined reference to `backlight_device_register'
drivers/built-in.o: In function `atyfb_pci_probe':
atyfb_base.c:(.init.text+0x6eb2): undefined reference to `backlight_device_register'
drivers/built-in.o: In function `aty128_probe':
aty128fb.c:(.init.text+0x7f57): undefined reference to `backlight_device_register'
drivers/built-in.o: In function `toshiba_acpi_init':
toshiba_acpi.c:(.init.text+0x1b315): undefined reference to `backlight_device_register'
drivers/built-in.o: In function `msi_init':
msi-laptop.c:(.init.text+0x34c67): undefined reference to `backlight_device_register'
msi-laptop.c:(.init.text+0x34ce1): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `rivafb_remove':
fbdev.c:(.exit.text+0x18d): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `atyfb_remove':
atyfb_base.c:(.exit.text+0x2e0): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `aty128_remove':
aty128fb.c:(.exit.text+0x3eb): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `asus_acpi_exit':
asus_acpi.c:(.exit.text+0x109b): undefined reference to `backlight_device_unregister'
drivers/built-in.o:toshiba_acpi.c:(.exit.text+0x10cc): more undefined 
references to `backlight_device_unregister' follow
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

