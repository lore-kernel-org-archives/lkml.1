Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbYCLJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbYCLJtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYCLJt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:49:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:5205 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYCLJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:49:05 -0400
Message-ID: <e8eb01770803120249te7453f6r61fc6c5d916446d6@mail.gmail.com>
Date: Wed, 12 Mar 2008 10:49:03 +0100
From: "Zbynek Drlik" <drlik.zbynek@opentech.sk>
To: linux-kernel@vger.kernel.org
Subject: kernel oops
In-Reply-To: <e8eb01770803120245x7690e6a9te8ad04296aa3fc4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e8eb01770803120245x7690e6a9te8ad04296aa3fc4d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. This is my problem after I upgraded to 2.6.24-r3. I am not to
be able run ldconfig (segmentation fault).

Code: 3d 00 f0 ff ff 89 c3 89 44 24 14 77 64 8b 45 1c 31 db 8b 44 85
20 85 c0 89 44 24 18 74 39 3d 00 f0 ff ff 89 c3 0f 87 9c 02 00 00 <80>
38 2f 0f 84 3e 01 00 00 8b 44 24 18 89 ea e8 26 03 00 00 85
 EIP: [<c016fdf6>] __link_path_walk+0x7d6/0xb10 SS:ESP 0068:f09b5e1c
---[ end trace 8e7a5d445b246e9f ]---
 BUG: unable to handle kernel paging request at virtual address ff9c0000
printing eip: c016fdf6 *pde = 00002067 *pte = 00003000
 Oops: 0000 [#5]
Modules linked in: cpufreq_userspace vmnet(PF) vmmon(PF) vmblock i915
drm ipv6 cpufreq_ondemand snd_pcm_oss snd_mixer_oss snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 ecb
blkcipher ieee80211_crypt_wep rfcomm l2cap acpi_cpufreq freq_table
fuse button battery ac ppdev lp sdhci tifm_7xx1 mmc_core tifm_core
yenta_socket rsrc_nonstatic pcmcia_core snd_intel8x0m ipw2200
ieee80211 ieee80211_crypt firmware_class 8250_pci 8250_pnp 8250
hci_usb serial_core i2c_i801 bluetooth snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm snd_timer snd snd_page_alloc evdev joydev parport_pc
parport rtc pcspkr tg3 e1000 nfs lockd sunrpc raid10 raid1 raid0
dm_bbr dm_snapshot dm_mirror dm_mod scsi_wait_scan sbp2 ohci1394
ieee1394 sl811_hcd usbhid ff_memless ohci_hcd uhci_hcd usb_storage
ehci_hcd usbcore

Pid: 21058, comm: ldconfig Tainted: PF     D (2.6.24-gentoo-r3 #3)
EIP: 0060:[<c016fdf6>] EFLAGS: 00010287 CPU: 0
 EIP is at __link_path_walk+0x7d6/0xb10
EAX: ff9c0000 EBX: ff9c0000 ECX: c0520ae8 EDX: c178d9e0
 ESI: f0abbe3c EDI: f7b0e668 EBP: f0abbf04 ESP: f0abbe1c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
 Process ldconfig (pid: 21058, ti=f0abb000 task=f09c4000 task.ti=f0abb000)
Stack: f7460011 00000001 99c7d5e5 00000000 f7c0c0c0 c178d9e0 ff9c0000 00000000
        99c7d5e5 0000000d f7460011 f7c0c0c0 f7b0e668 f77f54e0 f7c0c0c0 f787e304
       f0abbf04 c0170173 f7460000 f787e304 f7c0c0c0 00000000 00000000 00000000
 Call Trace:
 [<c0170173>] link_path_walk+0x43/0xc0
  [<c0170394>] do_path_lookup+0x64/0x1d0
 [<c016f45a>] getname+0x9a/0xf0
  [<c0170dab>] __user_walk_fd+0x3b/0x60
 [<c016a272>] vfs_stat_fd+0x22/0x60
  [<c016a35f>] sys_stat64+0xf/0x30
 [<c0103fce>] sysenter_past_esp+0x5f/0x85
  [<c03e0000>] klist_next+0x40/0xa0
 =======================
 Code: 3d 00 f0 ff ff 89 c3 89 44 24 14 77 64 8b 45 1c 31 db 8b 44 85
20 85 c0 89 44 24 18 74 39 3d 00 f0 ff ff 89 c3 0f 87 9c 02 00 00 <80>
38 2f 0f 84 3e 01 00 00 8b 44 24 18 89 ea e8 26 03 00 00 85
 EIP: [<c016fdf6>] __link_path_walk+0x7d6/0xb10 SS:ESP 0068:f0abbe1c
---[ end trace 8e7a5d445b246e9f ]---
 BUG: unable to handle kernel paging request at virtual address ff9c0000
printing eip: c016fdf6 *pde = 00002067 *pte = 00003000
 Oops: 0000 [#6]
Modules linked in: cpufreq_userspace vmnet(PF) vmmon(PF) vmblock i915
drm ipv6 cpufreq_ondemand snd_pcm_oss snd_mixer_oss snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 ecb
blkcipher ieee80211_crypt_wep rfcomm l2cap acpi_cpufreq freq_table
fuse button battery ac ppdev lp sdhci tifm_7xx1 mmc_core tifm_core
yenta_socket rsrc_nonstatic pcmcia_core snd_intel8x0m ipw2200
ieee80211 ieee80211_crypt firmware_class 8250_pci 8250_pnp 8250
hci_usb serial_core i2c_i801 bluetooth snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm snd_timer snd snd_page_alloc evdev joydev parport_pc
parport rtc pcspkr tg3 e1000 nfs lockd sunrpc raid10 raid1 raid0
dm_bbr dm_snapshot dm_mirror dm_mod scsi_wait_scan sbp2 ohci1394
ieee1394 sl811_hcd usbhid ff_memless ohci_hcd uhci_hcd usb_storage
ehci_hcd usbcore

Pid: 21235, comm: kdesktop_lock Tainted: PF     D (2.6.24-gentoo-r3 #3)
 EIP: 0060:[<c016fdf6>] EFLAGS: 00210287 CPU: 0
EIP is at __link_path_walk+0x7d6/0xb10
 EAX: ff9c0000 EBX: ff9c0000 ECX: c0520ae8 EDX: c178d9e0
ESI: f5009e0c EDI: f7b0e668 EBP: f5009f30 ESP: f5009dec
  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process kdesktop_lock (pid: 21235, ti=f5009000 task=f7f93aa0 task.ti=f5009000)
 Stack: f0989011 00000101 99c7d5e5 f5009e48 f7c0c0c0 c178d9e0 ff9c0000 00000000
       99c7d5e5 0000000d f0989011 f7c0c0c0 f7b0e668 f77f5420 f7c0c0c0 f787e304
        f5009f30 c0170173 f0989000 f787e304 f7c0c0c0 f76fcb78 00000000 00000000
Call Trace:
  [<c0170173>] link_path_walk+0x43/0xc0
 [<c016551e>] get_unused_fd_flags+0x4e/0xd0
  [<c0170394>] do_path_lookup+0x64/0x1d0
 [<c0170fc4>] __path_lookup_intent_open+0x54/0xa0
  [<c017109e>] path_lookup_open+0x1e/0x30
 [<c017118a>] open_namei+0x6a/0x5d0
  [<c016585e>] do_filp_open+0x2e/0x60
 [<c016551e>] get_unused_fd_flags+0x4e/0xd0
  [<c01658dc>] do_sys_open+0x4c/0xe0
 [<c01659ac>] sys_open+0x1c/0x20
  [<c0104036>] syscall_call+0x7/0xb
 =======================
 Code: 3d 00 f0 ff ff 89 c3 89 44 24 14 77 64 8b 45 1c 31 db 8b 44 85
20 85 c0 89 44 24 18 74 39 3d 00 f0 ff ff 89 c3 0f 87 9c 02 00 00 <80>
38 2f 0f 84 3e 01 00 00 8b 44 24 18 89 ea e8 26 03 00 00 85
 EIP: [<c016fdf6>] __link_path_walk+0x7d6/0xb10 SS:ESP 0068:f5009dec
---[ end trace 8e7a5d445b246e9f ]---



System info:
Linux drlikzbyneknb 2.6.24-gentoo-r3 #3 Tue Mar 11 21:35:43 CET 2008
i686 Intel(R) Pentium(R) M processor 1.73GHz GenuineIntel GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
 binutils               2.18
util-linux             2.13
 mount                  2.13
module-init-tools      3.4
 e2fsprogs              1.40.4
reiserfsprogs          3.6.19
 pcmcia-cs              3.2.8
PPP                    2.4.4
 Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
 Procps                 3.2.7
Net-tools              1.60
 Kbd                    1.13
Sh-utils               6.9
 udev                   115
wireless-tools         29
 Modules Loaded         cpufreq_userspace vmnet vmmon vmblock i915 drm
ipv6 cpufreq_ondemand snd_pcm_oss snd_mixer_oss snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 ecb
blkcipher ieee80211_crypt_wep rfcomm l2cap acpi_cpufreq freq_table
fuse button battery ac ppdev lp sdhci tifm_7xx1 mmc_core tifm_core
yenta_socket rsrc_nonstatic pcmcia_core snd_intel8x0m ipw2200
ieee80211 ieee80211_crypt firmware_class 8250_pci 8250_pnp 8250
hci_usb serial_core i2c_i801 bluetooth snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm snd_timer snd snd_page_alloc evdev joydev parport_pc
parport rtc pcspkr tg3 e1000 nfs lockd sunrpc raid10 raid1 raid0
dm_bbr dm_snapshot dm_mirror dm_mod scsi_wait_scan sbp2 ohci1394
ieee1394 sl811_hcd usbhid ff_memless ohci_hcd uhci_hcd usb_storage
ehci_hcd usbcore

-- 
S pozdravom Drlik Zbynek.

Ustecko-orlicka 16
058 01 Poprad
ICO: 41009347
Tel: +421 904 380 860
Web: www.opentech.sk
 E-Mail: drlik.zbynek@opentech.sk
Skype: drlikzbynek ICQ: 365156504 Gtalk: drlik.zbynek@opentech.sk
