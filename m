Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZBGURx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZBGURx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZBGURo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:17:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:51337 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZBGURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:17:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q0NFJBhY4y/vcDIr8Tlz2737Hf8zkvo/4s2EqRf2TEgD5CETyjYfYRsfoD08nuwmYm
         08IGfDB7EUu+l/R4P5bvOhZZuSFkaw2/5hg5WmMYWtkfXQSMzfaSBIN6oHtwVYN/jWjr
         gROyHedl2CALXZ3YuVzWXvkx9x5oLOeE7SoD0=
MIME-Version: 1.0
In-Reply-To: <20090207200652.GA3255@x200.localdomain>
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com>
	 <20090207200652.GA3255@x200.localdomain>
Date: Sat, 7 Feb 2009 21:17:41 +0100
Message-ID: <c43b2e150902071217id7bfdbaq66dbbd7d5e370c23@mail.gmail.com>
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
From: wixor <wixorpeek@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: JosephChan@via.com.tw, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done:

VIA Graphics Intergration Chipset framebuffer 2.4 initializing
VIAFB PCI Probe!!
parse_lcd_port: viafb_lcd_port:,interface:0
parse_dvi_port: viafb_dvi_port:,interface:0
I2C bus via_i2c registered.
TMDS Chip = 0
viafb_init_dvi_size()
viaparinfo->tmds_setting_info->get_dvi_size_method 2
dvi_get_panel_info!
viafb_dvi_sense!!
viafb_dvi_query_EDID!!
viafb_dvi_query_EDID!!
dvi panel size is  0
viafb_lvds_identify_vt1636.
viafb_lvds_identify_vt1636.
viafb_init_lcd_size()
viaparinfo->lvds_setting_info->get_lcd_size_method 2
Get LCD Size method by VGA BIOS !!
fp_get_panel_id()
LCD Panel_ID = 1
LCD Panel Size = 1
LVDS Chip = 0
LVDS1 output_interface = 5
LVDS2 output_interface = 5
Device ID = 3364
FB Size = 6000
Get FB info from PCI system!
fb_base = a0000000
fb_len = 10000000
------------[ cut here ]------------
kernel BUG at mm/vmalloc.c:294!
invalid opcode: 0000 [#1]
last sysfs file: /sys/devices/virtual/block/loop7/range
Modules linked in: viafb(+) fb i2c_algo_bit cfbcopyarea cfbimgblt
cfbfillrect af_packet p4_clockmod speedstep_lib loop arc4 ecb
cryptomgr aead crypto_blkcipher crypto_algapi ath5k mac80211 sr_mod
snd_hda_intel crypto cdrom led_class snd_pcm rtc_cmos rtc_core rtc_lib
pcspkr snd_timer snd_page_alloc snd_hwdep snd ehci_hcd psmouse
uhci_hcd evdev cfg80211 i2c_viapro soundcore via_rhine mii i2c_core
usbcore pata_via fan battery ac button thermal processor thermal_sys
via_agp agpgart hwmon unix

Pid: 1699, comm: modprobe Not tainted (2.6.28.3 #8) AMILO PRO V3515
EIP: 0060:[<c0162b00>] EFLAGS: 00010207 CPU: 0
EIP is at __insert_vmap_area+0x90/0xc0
EAX: 00701000 EBX: f0700000 ECX: 00000000 EDX: ef9e4f4c
ESI: ef9bff80 EDI: 00080000 EBP: 10001000 ESP: ee253d10
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 1699, ti=ee252000 task=efb2cd20 task.ti=ee252000)
Stack:
 f0700000 f0700000 c0162ca8 00000046 00701000 ef9bff80 00000000 ef9bff80
 0007ffff fff80000 c0103ddc 00000006 ee8219c0 00080000 ee8219c0 10001000
 c0162ded fffaa000 ffffffff 000000d0 f0690000 00000001 fffaa000 b0000000
Call Trace:
 [<c0162ca8>] alloc_vmap_area+0x178/0x210
 [<c0103ddc>] apic_timer_interrupt+0x28/0x30
 [<c0162ded>] __get_vm_area_node+0xad/0x160
 [<c0162f2c>] get_vm_area_caller+0x3c/0x50
 [<f0ab72ae>] viafb_init+0x2ae/0xf18 [viafb]
 [<c0116e53>] __ioremap_caller+0x1c3/0x350
 [<c0205179>] pci_get_subsys+0x59/0x80
 [<f0ab72ae>] viafb_init+0x2ae/0xf18 [viafb]
 [<c0117138>] ioremap_nocache+0x18/0x20
 [<f0ab72ae>] viafb_init+0x2ae/0xf18 [viafb]
 [<f0ab72ae>] viafb_init+0x2ae/0xf18 [viafb]
 [<f0ab7000>] viafb_init+0x0/0xf18 [viafb]
 [<c0101126>] do_one_initcall+0x36/0x1b0
 [<c01b02a0>] sysfs_ilookup_test+0x0/0x10
 [<c01b06e1>] __sysfs_add_one+0x11/0xa0
 [<c01b0a44>] sysfs_addrm_finish+0x14/0x1b0
 [<c01630d0>] __vunmap+0xb0/0xe0
 [<c01426ea>] load_module+0x128a/0x13f0
 [<c01429ab>] sys_init_module+0x8b/0x1b0
 [<c0103261>] sysenter_do_call+0x12/0x25
Code: 8b 5a 18 8d 4e 18 89 46 1c 89 5e 18 89 4a 18 89 4b 04 5b 5e c3
8d b6 00 00 00 00 8b 46 04 3b 42 f4 76 08 8d 42 04 89 d1 eb 9d 90 <0f>
0b eb fe a1 84 9c 37 c0 8d 56 18 c7 46 1c 84 9c 37 c0 89 46
EIP: [<c0162b00>] __insert_vmap_area+0x90/0xc0 SS:ESP 0068:ee253d10
---[ end trace 046ce8de4ba1e0d8 ]---

--
wixor
