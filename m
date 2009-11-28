Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZK1RMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZK1RMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 12:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZK1RMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 12:12:20 -0500
Received: from server35.mindwerk.net ([213.71.17.40]:59341 "EHLO
	server35.mindwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbZK1RMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 12:12:19 -0500
X-Greylist: delayed 1197 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 12:12:19 EST
Envelope-to: linux-kernel@vger.kernel.org
From: Arno <arno@disconnect.de>
Organization: not very organized
To: linux-kernel@vger.kernel.org
Subject: [BUG: nozomi?]: Unable to establish UMTS connection
Date: Sat, 28 Nov 2009 17:52:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.31; KDE/4.3.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911281752.24299.arno@disconnect.de>
X-Auth-For: 192.168.9.234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I can't establish an UMTS connection with my UMTS-card and recent kernels.

scripts/ver_linux:
Linux p2x-555 2.6.31-ARCH #1 SMP PREEMPT Tue Nov 10 19:48:17 CET 2009 i686 
Intel(R) Pentium(R) M processor 1500MHz GenuineIntel GNU/Linux

Gnu C                  4.4.2
Gnu make               3.81
binutils               2.20.0.20091101
util-linux             2.16
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.9
jfsutils               1.1.14
reiserfsprogs          3.6.21
xfsprogs               3.0.5
pcmciautils            015
PPP                    2.4.4
Linux C Library        2.11
Dynamic linker (ldd)   2.11
Linux C++ Library      6.0.13
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.6
wireless-tools         29
Modules Loaded         nozomi ipv6 pcmcia fan snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_intel8x0 snd_intel8x0m snd_seq_device 
snd_pcm_oss snd_mixer_oss snd_ac97_codec radeon ac97_bus yenta_socket ttm 
snd_pcm drm joydev rsrc_nonstatic ipw2100 thinkpad_acpi ohci1394 intel_agp 
snd_timer pcmcia_core i2c_algo_bit irtty_sir libipw i2c_i801 rfkill sir_dev 
nsc_ircc ieee1394 agpgart snd slhc led_class irda lib80211 psmouse shpchp 
serio_raw iTCO_wdt iTCO_vendor_support battery button processor thermal 
soundcore snd_page_alloc i2c_core pci_hotplug ac ppdev nvram lp pcspkr sg 
video output crc_ccitt parport_pc evdev parport e1000 rtc_cmos rtc_core 
rtc_lib xfs exportfs uhci_hcd ehci_hcd sd_mod sr_mod cdrom floppy usbcore 
ata_piix ata_generic pata_acpi libata scsi_mod

lspci:
00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller 
(rev 03)
00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 
03)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #3 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI 
Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge 
(rev 01)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 
01)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus 
Controller (rev 01)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 
Modem Controller (rev 01)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility M7 LW 
[Radeon Mobility 7500]
02:00.0 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller 
(rev 01)
02:00.2 FireWire (IEEE 1394): Texas Instruments Device 802a (rev 01)
02:01.0 Ethernet controller: Intel Corporation 82540EP Gigabit Ethernet 
Controller (Mobile) (rev 03)
02:02.0 Network controller: Intel Corporation PRO/Wireless LAN 2100 3B Mini 
PCI Adapter (rev 04)
03:00.0 Network controller: Option N.V. Qualcomm MSM6275 UMTS chip

It's a IBM ThinkPad R51, so rather ancient hardware. When I try to establish a 
connection via UMTS/GPRS and the Qualcomm card I get a kernel trace and pppd 
dies. The exact kernel version is 2.6.31.6.

kernel trace (2.6.31.6):
------------[ cut here ]------------
WARNING: at kernel/mutex.c:435 mutex_trylock+0x122/0x140()
Hardware name: 1829DRG
Modules linked in: ppp_async ppp_generic ipv6 fan snd_seq_dummy snd_seq_oss 
nozomi snd_seq_midi_event snd_intel8x0m snd_seq snd_seq_device snd_intel8x0 
snd_pcm_oss snd_mixer_oss pcmcia ipw2100 snd_ac97_codec libipw radeon ttm 
yenta_socket rsrc_nonstatic irtty_sir nsc_ircc sir_dev ohci1394 joydev 
ac97_bus pcmcia_core drm i2c_algo_bit snd_pcm thinkpad_acpi ieee1394 irda 
snd_timer lib80211 rfkill iTCO_wdt iTCO_vendor_support snd slhc psmouse 
intel_agp shpchp agpgart crc_ccitt ppdev soundcore snd_page_alloc i2c_i801 
pci_hotplug led_class video nvram lp ac pcspkr output sg battery button 
parport_pc processor thermal i2c_core serio_raw evdev parport e1000 rtc_cmos 
rtc_core rtc_lib xfs exportfs uhci_hcd ehci_hcd sd_mod sr_mod cdrom floppy 
usbcore ata_piix ata_generic pata_acpi libata scsi_mod
Pid: 1707, comm: pppd Tainted: G W 2.6.31-ARCH #1
Call Trace:
[<c10464da>] ? warn_slowpath_common+0x7a/0xc0
[<c1306c32>] ? mutex_trylock+0x122/0x140
[<c1046540>] ? warn_slowpath_null+0x20/0x40
[<c1306c32>] ? mutex_trylock+0x122/0x140
[<f842ff45>] ? ntty_write+0x85/0x250 [nozomi]
[<f8384318>] ? xfs_iunlock+0xb8/0xd0 [xfs]
[<c10bc076>] ? find_get_page+0x36/0xe0
[<f8071cda>] ? ppp_async_push+0x3ca/0x4b0 [ppp_async]
[<f8071e01>] ? ppp_async_send+0x41/0x70 [ppp_async]
[<f811fa70>] ? ppp_channel_push+0x40/0xc0 [ppp_generic]
[<f811fbcf>] ? ppp_write+0xdf/0xf0 [ppp_generic]
[<c10f32c8>] ? vfs_write+0xc8/0x1c0
[<f811faf0>] ? ppp_write+0x0/0xf0 [ppp_generic]
[<c10f34df>] ? sys_write+0x5f/0xb0
[<c1003cb3>] ? sysenter_do_call+0x12/0x28
---[ end trace a7919e7f17c0a727 ]---

I tried various kernel versions. Last working version is 2.6.28.10, though I 
also get a kernel trace:

kernel trace (2.6.28.10):
------------[ cut here ]------------
WARNING: at kernel/mutex.c:351 mutex_trylock+0xe0/0x130()
Modules linked in: ppp_async ppp_generic nozomi radeon drm ipv6 fan 
snd_intel8x0m snd_seq_oss snd_seq_midi_event snd_intel8x0 snd_seq 
snd_ac97_codec ac97_bus snd_seq_device pcmcia snd_pcm_oss snd_mixer_oss 
snd_pcm ohci1394 snd_timer yenta_socket rsrc_nonstatic ieee1394 snd 
pcmcia_core soundcore iTCO_wdt iTCO_vendor_support joydev ipw2100 
thinkpad_acpi i2c_i801 video ieee80211 ieee80211_crypt irtty_sir rfkill 
snd_page_alloc i2c_core output slhc sir_dev nsc_ircc psmouse intel_agp ppdev 
shpchp led_class agpgart battery ac parport_pc pci_hotplug serio_raw irda 
pcspkr nvram lp evdev thermal crc_ccitt processor button sg parport e1000 
rtc_cmos rtc_core rtc_lib xfs sr_mod cdrom uhci_hcd sd_mod ehci_hcd usbcore 
ata_piix ata_generic pata_acpi libata scsi_mod
Pid: 1969, comm: pppd Not tainted 2.6.28.10-ARCH #1
Call Trace:
[<c012e91f>] warn_on_slowpath+0x5f/0xa0
[<c016f999>] find_get_page+0x29/0xc0
[<c016fd1b>] find_lock_page+0x1b/0x60
[<c01703c5>] filemap_fault+0x235/0x470
[<c017f35a>] __do_fault+0x1fa/0x410
[<c032d150>] mutex_trylock+0xe0/0x130
[<f821fc43>] ntty_write+0x73/0x220 [nozomi]
[<c011fcb1>] do_page_fault+0x1b1/0x7b0
[<f832accb>] xfs_iunlock+0x9b/0xa0 [xfs]
[<f82c9b62>] ppp_async_push+0x3b2/0x4a0 [ppp_async]
[<f82c9c84>] ppp_async_send+0x34/0x50 [ppp_async]
[<f8181638>] ppp_channel_push+0x38/0x90 [ppp_generic]
[<f8181757>] ppp_write+0xc7/0xd0 [ppp_generic]
[<f8181690>] ppp_write+0x0/0xd0 [ppp_generic]
[<c0199d80>] vfs_write+0xa0/0x170
[<c0199f11>] sys_write+0x41/0x70
[<c0103eeb>] sysenter_do_call+0x12/0x2f
---[ end trace 3e6512b12da73ce1 ]---

Please CC: me, as I'm not subscribed to the list. I can test, but I can't 
bisect. Let me know if you need more info.

-- 
Regards,

Arno.
