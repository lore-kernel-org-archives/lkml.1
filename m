Return-Path: <linux-kernel-owner+w=401wt.eu-S1760021AbZBDVOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbZBDVOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZBDVOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:14:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62374 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZBDVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:14:34 -0500
Message-ID: <498A052A.4020802@onlinehome.de>
Date: Wed, 04 Feb 2009 22:14:18 +0100
From: Malte Marwedel <m.marwedel@onlinehome.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: rfcomm: Bug, already fixed?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ni9jineCR3dZEOjQgG/ny8ps5NCeEcnN+uMb
 o4Nmzo2dNCEOofowwc4227UXQquFFqFeiod2Ef2r5U72plvBr2
 H6QoCqm6zyuWn2WyA7WsUcXgyuBblHkiLvDhHV87Tk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
while using blutetooth as serail port, dmesg shows errors and the once 
created rfcomm device cant be recreated, after it disappeared.
This happens on an Ubuntu 8.10 machine with a 2.6.24 kernel.

I would like to know if this is already fixed in a later kernel, or if 
there are other possibilities to work around the problem.

Thank you,
Malte Marwedel

Part from the dmesg:
[  111.418417] Bluetooth: L2CAP ver 2.9
[  111.418420] Bluetooth: L2CAP socket layer initialized
[  111.420567] Bluetooth: RFCOMM socket layer initialized
[  111.420576] Bluetooth: RFCOMM TTY layer initialized
[  111.420578] Bluetooth: RFCOMM ver 1.8
[  276.391367] rfcomm_tty_ioctl: TIOCSERGETLSR is not supported
[  284.457998] rfcomm_tty_ioctl: TIOCSERGETLSR is not supported
[  287.367081] rfcomm_tty_ioctl: TIOCSERGETLSR is not supported
[  306.629414] rfcomm_tty_ioctl: TIOCSERGETLSR is not supported
[  415.176792] rfcomm_tty_ioctl: TIOCSERGETLSR is not supported
[  503.641017] rfcomm_tty_ioctl: TIOCSERGETLSR is not supported
[  631.470116] ALSA 
/build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-generic/sound/alsa-driver/pci/rme9652/../../alsa-kernel/pci/rme9652/hdsp.c:1128: 
Hammerfall-DSP: cannot change speed mode (capture PID = -1, playback PID 
= 8112)
[  719.033223] rfcomm_tty_ioctl: TIOCSERGETLSR is not supported
[  831.144491] rfcomm_tty_ioctl: TIOCSERGETLSR is not supported
[ 1905.596588] ------------[ cut here ]------------
[ 1905.596591] kernel BUG at 
/build/buildd/linux-2.6.24/net/bluetooth/rfcomm/tty.c:313!
[ 1905.596593] invalid opcode: 0000 [#1] SMP
[ 1905.596595] Modules linked in: rfcomm l2cap af_packet binfmt_misc 
ppdev ipv6 cpufreq_powersave cpufreq_userspace cpufreq_ondemand 
cpufreq_stats freq_table cpufreq_conservative container video output sbs 
sbshc dock battery iptable_filter ip_tables x_tables ac sbp2 lp 
snd_hda_intel snd_hdsp snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_hwdep snd_seq_dummy snd_seq_oss hci_usb snd_seq_midi snd_rawmidi 
nvidia(P) bluetooth snd_seq_midi_event snd_seq video1394 raw1394 agpgart 
snd_timer snd_seq_device i2c_core snd parport_pc psmouse evdev iTCO_wdt 
iTCO_vendor_support parport serio_raw dcdbas shpchp pci_hotplug 
soundcore button pcspkr ext3 jbd mbcache sg usb_storage libusual sr_mod 
sd_mod cdrom usbhid hid ahci libata scsi_mod ohci1394 ieee1394 tg3 
ehci_hcd uhci_hcd usbcore thermal processor fan fbcon tileblit font 
bitblit softcursor fuse
[ 1905.596634]
[ 1905.596636] Pid: 9434, comm: rfcomm Tainted: P 
(2.6.24-22-generic #1)
[ 1905.596638] EIP: 0060:[<f90d0daa>] EFLAGS: 00010202 CPU: 1
[ 1905.596645] EIP is at rfcomm_dev_del+0xa/0x50 [rfcomm]
[ 1905.596646] EAX: 0000001b EBX: f3e74600 ECX: 00000286 EDX: 00000000
[ 1905.596647] ESI: f3e74600 EDI: bf92096c EBP: f2cc5a00 ESP: f2f7def4
[ 1905.596649]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1905.596650] Process rfcomm (pid: 9434, ti=f2f7c000 task=f2ed7700 
task.ti=f2f7c000)
[ 1905.596652] Stack: ffffffed f90d1695 00000200 000000ce 00000282 
fffa5ae8 c0479400 c031c6f8
[ 1905.596656]        f2cc5a00 00000000 00000000 00000000 00000000 
00000000 00000000 f2cc5a00
[ 1905.596659]        bf92096c 400452c9 bf92096c f90cfa59 f90d22c0 
400452c9 f293b780 c029cb1f
[ 1905.596663] Call Trace:
[ 1905.596669]  [<f90d1695>] rfcomm_dev_ioctl+0x455/0x6e0 [rfcomm]
[ 1905.596681]  [<c031c6f8>] _spin_lock_bh+0x8/0x20
[ 1905.596697]  [<f90cfa59>] rfcomm_sock_ioctl+0x29/0x50 [rfcomm]
[ 1905.596705]  [<c029cb1f>] sock_ioctl+0xcf/0x220
[ 1905.596710]  [<c029ca50>] sock_ioctl+0x0/0x220
[ 1905.596714]  [<c019dfbb>] do_ioctl+0x2b/0x90
[ 1905.596722]  [<c019e24e>] vfs_ioctl+0x22e/0x2b0
[ 1905.596729]  [<c019e326>] sys_ioctl+0x56/0x70
[ 1905.596734]  [<c01043b2>] sysenter_past_esp+0x6b/0xa9
[ 1905.596742]  [<c0310000>] unix_seqpacket_sendmsg+0x20/0x90
[ 1905.596751]  =======================
[ 1905.596752] Code: 89 f0 e8 8a cc 0b c7 b8 80 6d 0d f9 5b 5e e9 8e f6 
07 c7 c7 43 78 00 00 00 00 eb bd 0f 0b eb fe 90 53 89 c3 8b 40 1c a8 10 
74 04 <0f> 0b eb fe f0 0f ba 6b 1c 04 b8 f0 6c 0d f9 e8 62 ba 24 c7 8b
[ 1905.596771] EIP: [<f90d0daa>] rfcomm_dev_del+0xa/0x50 [rfcomm] SS:ESP 
0068:f2f7def4
[ 1905.596778] ---[ end trace e9edc4f6270f0cc8 ]---
[ 2052.004680] sysfs: duplicate filename 'rfcomm0' can not be created
[ 2052.004686] WARNING: at /build/buildd/linux-2.6.24/fs/sysfs/dir.c:424 
sysfs_add_one()
[ 2052.004691] Pid: 9524, comm: rfcomm Tainted: P      D 
2.6.24-22-generic #1
[ 2052.004710]  [<c01d736f>] sysfs_add_one+0x9f/0xe0
[ 2052.004738]  [<c01d78a8>] create_dir+0x48/0x90
[ 2052.004750]  [<c01d7919>] sysfs_create_dir+0x29/0x50
[ 2052.004758]  [<c021535f>] kobject_get+0xf/0x20
[ 2052.004766]  [<c0215823>] kobject_add+0x93/0x1b0
[ 2052.004772]  [<c0215761>] kobject_set_name+0x81/0xb0
[ 2052.004781]  [<c02808a7>] device_add+0xa7/0x510
[ 2052.004792]  [<c02154f9>] kobject_init+0x29/0x40
[ 2052.004801]  [<c0280fc8>] device_create+0x88/0xc0
[ 2052.004808]  [<c0262209>] tty_register_device+0x69/0xf0
[ 2052.004833]  [<f90d17df>] rfcomm_dev_ioctl+0x59f/0x6e0 [rfcomm]
[ 2052.004847]  [<c031c6f8>] _spin_lock_bh+0x8/0x20
[ 2052.004862]  [<f90cfa59>] rfcomm_sock_ioctl+0x29/0x50 [rfcomm]
[ 2052.004873]  [<c029cb1f>] sock_ioctl+0xcf/0x220
[ 2052.004880]  [<c029ca50>] sock_ioctl+0x0/0x220
[ 2052.004887]  [<c019dfbb>] do_ioctl+0x2b/0x90
[ 2052.004896]  [<c019e24e>] vfs_ioctl+0x22e/0x2b0
[ 2052.004905]  [<c019e326>] sys_ioctl+0x56/0x70
[ 2052.004913]  [<c01043b2>] sysenter_past_esp+0x6b/0xa9
[ 2052.004931]  =======================
[ 2052.004934] kobject_add failed for rfcomm0 with -EEXIST, don't try to 
register things with the same name in the same directory.
[ 2052.004937] Pid: 9524, comm: rfcomm Tainted: P      D 
2.6.24-22-generic #1
[ 2052.004942]  [<c02158a3>] kobject_add+0x113/0x1b0
[ 2052.004948]  [<c0215761>] kobject_set_name+0x81/0xb0
[ 2052.004957]  [<c02808a7>] device_add+0xa7/0x510
[ 2052.004967]  [<c02154f9>] kobject_init+0x29/0x40
[ 2052.004976]  [<c0280fc8>] device_create+0x88/0xc0
[ 2052.004984]  [<c0262209>] tty_register_device+0x69/0xf0
[ 2052.005008]  [<f90d17df>] rfcomm_dev_ioctl+0x59f/0x6e0 [rfcomm]
[ 2052.005020]  [<c031c6f8>] _spin_lock_bh+0x8/0x20
[ 2052.005032]  [<f90cfa59>] rfcomm_sock_ioctl+0x29/0x50 [rfcomm]
[ 2052.005042]  [<c029cb1f>] sock_ioctl+0xcf/0x220
[ 2052.005048]  [<c029ca50>] sock_ioctl+0x0/0x220
[ 2052.005055]  [<c019dfbb>] do_ioctl+0x2b/0x90
[ 2052.005065]  [<c019e24e>] vfs_ioctl+0x22e/0x2b0
[ 2052.005074]  [<c019e326>] sys_ioctl+0x56/0x70
[ 2052.005081]  [<c01043b2>] sysenter_past_esp+0x6b/0xa9
[ 2052.005098]  =======================
[ 2073.969486] sysfs: duplicate filename 'rfcomm0' can not be created
[ 2073.969492] WARNING: at /build/buildd/linux-2.6.24/fs/sysfs/dir.c:424 
sysfs_add_one()
[ 2073.969496] Pid: 9548, comm: rfcomm Tainted: P      D 
2.6.24-22-generic #1
[ 2073.969512]  [<c01d736f>] sysfs_add_one+0x9f/0xe0
[ 2073.969529]  [<c01d78a8>] create_dir+0x48/0x90
[ 2073.969546]  [<c01d7919>] sysfs_create_dir+0x29/0x50
[ 2073.969551]  [<c021535f>] kobject_get+0xf/0x20
[ 2073.969556]  [<c0215823>] kobject_add+0x93/0x1b0
[ 2073.969561]  [<c0215761>] kobject_set_name+0x81/0xb0
[ 2073.969568]  [<c02808a7>] device_add+0xa7/0x510
[ 2073.969578]  [<c02154f9>] kobject_init+0x29/0x40
[ 2073.969584]  [<c0280fc8>] device_create+0x88/0xc0
[ 2073.969591]  [<c0262209>] tty_register_device+0x69/0xf0
[ 2073.969615]  [<f90d17df>] rfcomm_dev_ioctl+0x59f/0x6e0 [rfcomm]
[ 2073.969626]  [<c031c6f8>] _spin_lock_bh+0x8/0x20
[ 2073.969637]  [<f90cfa59>] rfcomm_sock_ioctl+0x29/0x50 [rfcomm]
[ 2073.969644]  [<c029cb1f>] sock_ioctl+0xcf/0x220
[ 2073.969649]  [<c029ca50>] sock_ioctl+0x0/0x220
[ 2073.969653]  [<c019dfbb>] do_ioctl+0x2b/0x90
[ 2073.969659]  [<c019e24e>] vfs_ioctl+0x22e/0x2b0
[ 2073.969666]  [<c019e326>] sys_ioctl+0x56/0x70
[ 2073.969672]  [<c01043b2>] sysenter_past_esp+0x6b/0xa9
[ 2073.969686]  =======================
[ 2073.969689] kobject_add failed for rfcomm0 with -EEXIST, don't try to 
register things with the same name in the same directory.
[ 2073.969691] Pid: 9548, comm: rfcomm Tainted: P      D 
2.6.24-22-generic #1
[ 2073.969695]  [<c02158a3>] kobject_add+0x113/0x1b0
[ 2073.969700]  [<c0215761>] kobject_set_name+0x81/0xb0
[ 2073.969706]  [<c02808a7>] device_add+0xa7/0x510
[ 2073.969714]  [<c02154f9>] kobject_init+0x29/0x40
[ 2073.969719]  [<c0280fc8>] device_create+0x88/0xc0
[ 2073.969726]  [<c0262209>] tty_register_device+0x69/0xf0
[ 2073.969745]  [<f90d17df>] rfcomm_dev_ioctl+0x59f/0x6e0 [rfcomm]
[ 2073.969753]  [<c031c6f8>] _spin_lock_bh+0x8/0x20
[ 2073.969762]  [<f90cfa59>] rfcomm_sock_ioctl+0x29/0x50 [rfcomm]
[ 2073.969769]  [<c029cb1f>] sock_ioctl+0xcf/0x220
[ 2073.969773]  [<c029ca50>] sock_ioctl+0x0/0x220
[ 2073.969777]  [<c019dfbb>] do_ioctl+0x2b/0x90
[ 2073.969783]  [<c019e24e>] vfs_ioctl+0x22e/0x2b0
[ 2073.969789]  [<c019e326>] sys_ioctl+0x56/0x70
[ 2073.969794]  [<c01043b2>] sysenter_past_esp+0x6b/0xa9
[ 2073.969807]  =======================
[ 2074.009345] ------------[ cut here ]------------
[ 2074.009349] kernel BUG at 
/build/buildd/linux-2.6.24/kernel/workqueue.c:170!
[ 2074.009351] invalid opcode: 0000 [#2] SMP
[ 2074.009353] Modules linked in: rfcomm l2cap af_packet binfmt_misc 
ppdev ipv6 cpufreq_powersave cpufreq_userspace cpufreq_ondemand 
cpufreq_stats freq_table cpufreq_conservative container video output sbs 
sbshc dock battery iptable_filter ip_tables x_tables ac sbp2 lp 
snd_hda_intel snd_hdsp snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_hwdep snd_seq_dummy snd_seq_oss hci_usb snd_seq_midi snd_rawmidi 
nvidia(P) bluetooth snd_seq_midi_event snd_seq video1394 raw1394 agpgart 
snd_timer snd_seq_device i2c_core snd parport_pc psmouse evdev iTCO_wdt 
iTCO_vendor_support parport serio_raw dcdbas shpchp pci_hotplug 
soundcore button pcspkr ext3 jbd mbcache sg usb_storage libusual sr_mod 
sd_mod cdrom usbhid hid ahci libata scsi_mod ohci1394 ieee1394 tg3 
ehci_hcd uhci_hcd usbcore thermal processor fan fbcon tileblit font 
bitblit softcursor fuse
[ 2074.009388]
[ 2074.009390] Pid: 6541, comm: krfcommd Tainted: P      D 
(2.6.24-22-generic #1)
[ 2074.009391] EIP: 0060:[<c013d3fc>] EFLAGS: 00010203 CPU: 1
[ 2074.009397] EIP is at queue_work+0x3c/0x40
[ 2074.009398] EAX: c01b6f40 EBX: c01b6f3c ECX: f7c013a0 EDX: 00000000
[ 2074.009399] ESI: f2d2d540 EDI: 00000000 EBP: 00000092 ESP: f2d77eec
[ 2074.009401]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 2074.009402] Process krfcommd (pid: 6541, ti=f2d76000 task=f2c1d140 
task.ti=f2d76000)
[ 2074.009404] Stack: f2ccb480 f90cd838 c02a3161 f2ccb480 00000002 
00000063 f90cee18 0000000d
[ 2074.009407]        00000000 00000000 00000000 00000276 f2c1d170 
00000003 f2c1d170 f2d77fab
[ 2074.009411]        f2d77fad f2d77fa6 f2d2d564 f36d9e70 f36d9e00 
f2d2d540 c302eb0b f2c1d170
[ 2074.009414] Call Trace:
[ 2074.009420]  [<f90cd838>] __rfcomm_dlc_close+0x48/0x1a0 [rfcomm]
[ 2074.009425]  [<c02a3161>] skb_dequeue+0x41/0x60
[ 2074.009434]  [<f90cee18>] rfcomm_run+0xee8/0x1410 [rfcomm]
[ 2074.009454]  [<c031f60b>] show_kprobe_addr+0xfb/0x130
[ 2074.009461]  [<c0128180>] finish_task_switch+0x70/0x90
[ 2074.009468]  [<c031acba>] schedule+0x20a/0x600
[ 2074.009484]  [<f90cdf30>] rfcomm_run+0x0/0x1410 [rfcomm]
[ 2074.009489]  [<c01408a2>] kthread+0x42/0x70
[ 2074.009491]  [<c0140860>] kthread+0x0/0x70
[ 2074.009495]  [<c0105667>] kernel_thread_helper+0x7/0x10
[ 2074.009503]  =======================
[ 2074.009504] Code: 04 5b 89 d0 c3 8d 43 04 39 43 04 75 1e 89 c8 64 8b 
15 08 60 47 c0 e8 94 f8 ff ff 89 da e8 6d ff ff ff ba 01 00 00 00 89 d0 
5b c3 <0f> 0b eb fe 89 c2 a1 54 9f 41 c0 e9 b4 ff ff ff 8d 74 26 00 89
[ 2074.009522] EIP: [<c013d3fc>] queue_work+0x3c/0x40 SS:ESP 0068:f2d77eec
[ 2074.009534] ---[ end trace e9edc4f6270f0cc8 ]---
[ 2255.521097] usb 2-2: USB disconnect, address 4

