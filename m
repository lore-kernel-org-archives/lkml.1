Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYBENGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYBENGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYBENGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:06:16 -0500
Received: from md2.t-2.net ([84.255.209.71]:7527 "EHLO md2.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYBENGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:06:13 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 08:06:13 EST
Date: Tue, 5 Feb 2008 13:57:30 +0100
From: Andrej Hocevar <and.hocevar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel oops
Message-ID: <20080205125730.GA6552@stoa>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
X-Weltschmerz: A la recherche du temps perdu
X-alter-ego: Woody Allen
X-band-name: The Real Things (www.realthings.tk) | the best garage r'n'r
X-geek: GL/AT d+(>pu) s: a-@>- C++(>---) UL++ P++ L+++ !E W++ N-- o-- K w--
	O? M? V? PS+ PE Y+ PGP t++ 5? X-- R- tv! b+++$>++++ DI? !D G
	e(>++++) h---(>) r++(*@) y+++
X-OS: Debian GNU/Linux lenny/sid@2.6.23.13newhome
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Junkmail-Status: score=10/150, host=md2.t-2.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010204.47A85D46.00F0,ss=1,fgs=0,
	ip=84.255.194.172,
	so=2007-07-31 18:51:00,
	dmn=5.4.3/2008-02-01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this has occured a couple of times. i was editing a unicode file with
vim in the console. after a reboot, i immediately tried to do just that
again and it crashed. it might have occured upon trying to select some
text with the mouse (gpm) or trying to delete characters from the file.

	regards,

	andrej



1)

=======================================================================

Linux stoa 2.6.23.13newhome #3 Wed Jan 30 19:39:38 CET 2008 i686
GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               Binutils
util-linux             2.13.1
mount                  2.13
module-init-tools      3.3-pre2
e2fsprogs              1.40.3
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   114
wireless-tools         29
Modules Loaded         nf_conntrack_ipv4 xt_state xt_tcpudp
iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp
nf_conntrack nfnetlink af_packet ppdev lp cpufreq_stats fuse sr_mod sbp2
snd_intel8x0 snd_ac97_codec irda ac97_bus snd_pcm_oss snd_mixer_oss
crc_ccitt parport_pc parport snd_pcm video output
rng_core snd_timer snd_page_alloc rtc 8250_pci 8250 serial_core evdev
sd_mod ide_cd cdrom ide_disk usb_storage usbhid scsi_mod ohci1394 piix
ieee1394 ide_core ehci_hcd uhci_hcd usbcore unix

=======================================================================

2)

=======================================================================

Feb  5 13:25:37 stoa kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
Feb  5 13:25:37 stoa kernel:  printing eip:
Feb  5 13:25:37 stoa kernel: c01ebbca
Feb  5 13:25:37 stoa kernel: *pde = 00000000
Feb  5 13:25:37 stoa kernel: Oops: 0000 [#1]
Feb  5 13:25:37 stoa kernel: Modules linked in: ppdev lp cpufreq_stats fuse sr_mod sbp2 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm sd_mod 8250_pci irda 8250 serial_core rtc parport_pc parport crc_ccitt rng_core snd_timer snd_page_alloc video output evdev usb_storage scsi_mod usbhid ide_cd cdrom ide_disk ohci1394 ehci_hcd uhci_hcd piix ide_core ieee1394 usbcore unix
Feb  5 13:25:37 stoa kernel: CPU:    0
Feb  5 13:25:37 stoa kernel: EIP:    0060:[<c01ebbca>]    Not tainted VLI
Feb  5 13:25:37 stoa kernel: EFLAGS: 00010202   (2.6.23.13newhome #3)
Feb  5 13:25:37 stoa kernel: EIP is at acpi_ps_has_completed_scope+0xb/0x1d
Feb  5 13:25:37 stoa kernel: eax: 00000000   ebx: 00001001   ecx: 00000001   edx: 00000000
Feb  5 13:25:37 stoa kernel: esi: ed1e9800   edi: 00000000   ebp: ed1e9824   esp: ea647e04
Feb  5 13:25:37 stoa kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Feb  5 13:25:37 stoa kernel: Process hald (pid: 5453, ti=ea646000 task=ea514540 task.ti=ea646000)
Feb  5 13:25:37 stoa kernel: Stack: c01eb38f c01f0aef dfc49190 ed1e9400 c01ea3a7 c03fe1f0 00000287 c01f0a27 
Feb  5 13:25:37 stoa kernel:        ed1e9400 ed1e9800 c15a3d20 00000287 00000000 00000000 ed1e9400 ed1e9800 
Feb  5 13:25:37 stoa kernel:        00000000 dfc27090 c01ead50 dfc483a8 ed1e9824 dfc27030 c01deba1 00000000 
Feb  5 13:25:37 stoa kernel: Call Trace:
Feb  5 13:25:37 stoa kernel:  [<c01eb38f>] acpi_ps_parse_loop+0x3e/0x737
Feb  5 13:25:37 stoa kernel:  [<c01f0aef>] acpi_ut_acquire_mutex+0x31/0x7a
Feb  5 13:25:37 stoa kernel:  [<c01ea3a7>] acpi_ns_get_next_node+0x13/0x34
Feb  5 13:25:37 stoa kernel:  [<c01f0a27>] acpi_ut_release_mutex+0x5b/0x63
Feb  5 13:25:37 stoa kernel:  [<c01ead50>] acpi_ps_parse_aml+0x60/0x237
Feb  5 13:25:37 stoa kernel:  [<c01deba1>] acpi_ds_init_aml_walk+0xb4/0xfe
Feb  5 13:25:37 stoa kernel:  [<c01ebf7c>] acpi_ps_execute_method+0x11b/0x1bb
Feb  5 13:25:37 stoa kernel:  [<c01e9315>] acpi_ns_evaluate+0x99/0xf0
Feb  5 13:25:37 stoa kernel:  [<c01e8f81>] acpi_evaluate_object+0x124/0x1c7
Feb  5 13:25:37 stoa kernel:  [<c01f4848>] acpi_ac_seq_show+0x0/0x50
Feb  5 13:25:37 stoa kernel:  [<c01db1fc>] acpi_evaluate_integer+0x7b/0xae
Feb  5 13:25:37 stoa kernel:  [<c01f467e>] acpi_ac_get_state+0x26/0x61
Feb  5 13:25:37 stoa kernel:  [<c0146bde>] mmap_region+0x312/0x3ce
Feb  5 13:25:37 stoa kernel:  [<c01f485a>] acpi_ac_seq_show+0x12/0x50
Feb  5 13:25:37 stoa kernel:  [<c0166d9a>] seq_read+0xec/0x276
Feb  5 13:25:37 stoa kernel:  [<c0166cae>] seq_read+0x0/0x276
Feb  5 13:25:37 stoa kernel:  [<c0178d15>] proc_reg_read+0x35/0x46
Feb  5 13:25:37 stoa kernel:  [<c0178ce0>] proc_reg_read+0x0/0x46
Feb  5 13:25:37 stoa kernel:  [<c0153b51>] vfs_read+0x88/0x10a
Feb  5 13:25:37 stoa kernel:  [<c0153e71>] sys_read+0x41/0x67
Feb  5 13:25:37 stoa kernel:  [<c0103bee>] syscall_call+0x7/0xb
Feb  5 13:25:37 stoa kernel:  =======================
Feb  5 13:25:37 stoa kernel: Code: c0 25 2e c0 c1 e0 04 05 c0 1c 2e c0 c3 b8 70 23 2e c0 c3 b8 38 df 32 c0 c3 8b 40 1c 8b 40 10 c3 8b 50 1c b9 01 00 00 00 8b 40 04 <3b> 42 14 73 09 31 c9 83 7a 0c 00 0f 94 c1 0f b6 c1 c3 85 c0 53 




Feb  5 13:32:44 stoa kernel: BUG: unable to handle kernel paging request at virtual address 01000044
Feb  5 13:32:44 stoa kernel:  printing eip:
Feb  5 13:32:44 stoa kernel: c01501ef
Feb  5 13:32:44 stoa kernel: *pde = 00000000
Feb  5 13:32:44 stoa kernel: Oops: 0000 [#1]
Feb  5 13:32:44 stoa kernel: Modules linked in: ppdev lp cpufreq_stats fuse sr_mod sbp2 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss video sd_mod output rng_core irda parport_pc parport 8250_pci 8250 serial_core snd_pcm crc_ccitt snd_timer snd_page_alloc evdev rtc ide_disk ide_cd cdrom usb_storage usbhid scsi_mod ohci1394 piix ieee1394 ide_core ehci_hcd uhci_hcd usbcore unix
Feb  5 13:32:44 stoa kernel: CPU:    0
Feb  5 13:32:44 stoa kernel: EIP:    0060:[<c01501ef>]    Not tainted VLI
Feb  5 13:32:44 stoa kernel: EFLAGS: 00010006   (2.6.23.13newhome #3)
Feb  5 13:32:44 stoa kernel: EIP is at kmem_cache_alloc+0x40/0x7c
Feb  5 13:32:44 stoa kernel: eax: 00000000   ebx: 01000044   ecx: c0385c70   edx: c15c3a40
Feb  5 13:32:44 stoa kernel: esi: c0385c70   edi: 00000286   ebp: 00011200   esp: dfc5fd90
Feb  5 13:32:44 stoa kernel: ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Feb  5 13:32:44 stoa kernel: Process pdflush (pid: 189, ti=dfc5e000 task=dfc08540 task.ti=dfc5e000)
Feb  5 13:32:44 stoa kernel: Stack: c013bc77 eeb764d0 00000010 dfff51e0 00011210 ef070cc0 c013bc77 dfc8c6f0 
Feb  5 13:32:44 stoa kernel:        00000017 ee9a9a68 00000008 ee9a9b90 00000000 00000000 dfff50c0 ef070cc0 
Feb  5 13:32:44 stoa kernel:        c016e566 00000010 00000000 dfd00738 c15c8260 00000001 00000001 c016e5c9 
Feb  5 13:32:44 stoa kernel: Call Trace:
Feb  5 13:32:44 stoa kernel:  [<c013bc77>] mempool_alloc+0x28/0x9f
Feb  5 13:32:44 stoa kernel:  [<c013bc77>] mempool_alloc+0x28/0x9f
Feb  5 13:32:44 stoa kernel:  [<c016e566>] bio_alloc_bioset+0x9b/0xf3
Feb  5 13:32:44 stoa kernel:  [<c016e5c9>] bio_alloc+0xb/0x17
Feb  5 13:32:44 stoa kernel:  [<c016b9d0>] submit_bh+0x5e/0xd4
Feb  5 13:32:44 stoa kernel:  [<c016ccda>] __block_write_full_page+0x1ab/0x27e
Feb  5 13:32:44 stoa kernel:  [<c0104597>] common_interrupt+0x23/0x28
Feb  5 13:32:44 stoa kernel:  [<c017000f>] blkdev_get_block+0x0/0x33
Feb  5 13:32:44 stoa kernel:  [<c016ce7f>] block_write_full_page+0xd2/0xda
Feb  5 13:32:44 stoa kernel:  [<c017000f>] blkdev_get_block+0x0/0x33
Feb  5 13:32:44 stoa kernel:  [<c013db98>] __writepage+0x8/0x1f
Feb  5 13:32:44 stoa kernel:  [<c013e019>] write_cache_pages+0x165/0x280
Feb  5 13:32:44 stoa kernel:  [<c013db90>] __writepage+0x0/0x1f
Feb  5 13:32:44 stoa kernel:  [<c013e134>] generic_writepages+0x0/0x26
Feb  5 13:32:44 stoa kernel:  [<c013e153>] generic_writepages+0x1f/0x26
Feb  5 13:32:44 stoa kernel:  [<c013e17a>] do_writepages+0x20/0x30
Feb  5 13:32:44 stoa kernel:  [<c0168777>] __writeback_single_inode+0x16e/0x2d4
Feb  5 13:32:44 stoa kernel:  [<c02cc29f>] schedule_timeout+0x77/0x8b
Feb  5 13:32:44 stoa kernel:  [<c01156bb>] update_curr+0x10b/0x135
Feb  5 13:32:44 stoa kernel:  [<c0168b7f>] sync_sb_inodes+0x154/0x1e5
Feb  5 13:32:44 stoa kernel:  [<c0168d38>] writeback_inodes+0x42/0x69
Feb  5 13:32:44 stoa kernel:  [<c013e7ea>] pdflush+0x0/0x15e
Feb  5 13:32:44 stoa kernel:  [<c013e51c>] wb_kupdate+0x6e/0xd2
Feb  5 13:32:44 stoa kernel:  [<c013e8c4>] pdflush+0xda/0x15e
Feb  5 13:32:44 stoa kernel:  [<c02cbcca>] __sched_text_start+0x212/0x26f
Feb  5 13:32:44 stoa kernel:  [<c013e4ae>] wb_kupdate+0x0/0xd2
Feb  5 13:32:44 stoa kernel:  [<c01274d3>] kthread+0x36/0x5b
Feb  5 13:32:44 stoa kernel:  [<c012749d>] kthread+0x0/0x5b
Feb  5 13:32:44 stoa kernel:  [<c0104747>] kernel_thread_helper+0x7/0x10
Feb  5 13:32:44 stoa kernel:  =======================
Feb  5 13:32:44 stoa kernel: Code: 00 00 00 85 d2 74 06 83 7a 0c 00 75 17 89 54 24 04 83 c9 ff 89 ea 89 04 24 89 f0 e8 44 fb ff ff 89 c3 eb 0d 8b 5a 0c 0f b7 42 0a <8b> 04 83 89 42 0c 57 9d 89 e8 25 00 80 00 00 66 85 c0 74 1f 85 
Feb  5 13:32:44 stoa kernel: EIP: [<c01501ef>] kmem_cache_alloc+0x40/0x7c SS:ESP 0068:dfc5fd90




Feb  5 13:34:22 stoa kernel: BUG: unable to handle kernel paging request at virtual address 3175b800
Feb  5 13:34:22 stoa kernel:  printing eip:
Feb  5 13:34:22 stoa kernel: c0150a77
Feb  5 13:34:22 stoa kernel: *pde = 00000000
Feb  5 13:34:22 stoa kernel: Oops: 0000 [#2]
Feb  5 13:34:22 stoa kernel: Modules linked in: ppdev lp cpufreq_stats fuse sr_mod sbp2 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss video sd_mod output rng_core irda parport_pc parport 8250_pci 8250 serial_core snd_pcm crc_ccitt snd_timer snd_page_alloc evdev rtc ide_disk ide_cd cdrom usb_storage usbhid scsi_mod ohci1394 piix ieee1394 ide_core ehci_hcd uhci_hcd usbcore unix
Feb  5 13:34:22 stoa kernel: CPU:    0
Feb  5 13:34:22 stoa kernel: EIP:    0060:[<c0150a77>]    Tainted: G      D VLI
Feb  5 13:34:22 stoa kernel: EFLAGS: 00010006   (2.6.23.13newhome #3)
Feb  5 13:34:22 stoa kernel: EIP is at __kmalloc_track_caller+0x4a/0x88
Feb  5 13:34:22 stoa kernel: eax: 00000000   ebx: 3175b800   ecx: c0385be4   edx: c15c62e0
Feb  5 13:34:22 stoa kernel: esi: c0385be4   edi: 00000286   ebp: 000000d0   esp: e8f8bec0
Feb  5 13:34:22 stoa kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Feb  5 13:34:22 stoa kernel: Process modprobe (pid: 6174, ti=e8f8a000 task=ee68aa80 task.ti=e8f8a000)
Feb  5 13:34:22 stoa kernel: Stack: 00000003 c01319bd 000000d0 ee7bc800 ee7bca68 00000006 c0141624 c0131a40 
Feb  5 13:34:22 stoa kernel:        f3a3ace6 ee7bc834 ee7bc800 ee7bca68 f3ab2c00 c0132c24 00000000 00000000 
Feb  5 13:34:22 stoa kernel:        e8b705f4 e8b705f0 00003cb4 00000438 c0146bde 00000000 00000000 00000000 
Feb  5 13:34:22 stoa kernel: Call Trace:
Feb  5 13:34:22 stoa kernel:  [<c01319bd>] module_add_modinfo_attrs+0x58/0x7a
Feb  5 13:34:22 stoa kernel:  [<c0141624>] kstrdup+0x2f/0x50
Feb  5 13:34:22 stoa kernel:  [<c0131a40>] mod_sysfs_setup+0x61/0x8b
Feb  5 13:34:22 stoa kernel:  [<c0132c24>] sys_init_module+0x105b/0x12b1
Feb  5 13:34:22 stoa kernel:  [<c0146bde>] mmap_region+0x312/0x3ce
Feb  5 13:34:22 stoa kernel:  [<c0261a5f>] synchronize_net+0x0/0xa
Feb  5 13:34:22 stoa kernel:  [<c0103bee>] syscall_call+0x7/0xb
Feb  5 13:34:22 stoa kernel:  [<c012007b>] do_timer+0x65/0xa5
Feb  5 13:34:22 stoa kernel:  =======================
Feb  5 13:34:22 stoa kernel: Code: 00 00 00 85 d2 74 06 83 7a 0c 00 75 17 89 54 24 04 83 c9 ff 89 ea 89 f0 89 1c 24 e8 bc f2 ff ff 89 c3 eb 0d 8b 5a 0c 0f b7 42 0a <8b> 04 83 89 42 0c 57 9d 89 e8 25 00 80 00 00 66 85 c0 74 1f 85 
Feb  5 13:34:22 stoa kernel: EIP: [<c0150a77>] __kmalloc_track_caller+0x4a/0x88 SS:ESP 0068:e8f8bec0





Feb  5 13:34:22 stoa kernel: BUG: unable to handle kernel paging request at virtual address 3175b800
Feb  5 13:34:22 stoa kernel:  printing eip:
Feb  5 13:34:22 stoa kernel: c0150b01
Feb  5 13:34:22 stoa kernel: *pde = 00000000
Feb  5 13:34:22 stoa kernel: Oops: 0000 [#3]
Feb  5 13:34:22 stoa kernel: Modules linked in: ppdev lp cpufreq_stats fuse sr_mod sbp2 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss video sd_mod output rng_core irda parport_pc parport 8250_pci 8250 serial_core snd_pcm crc_ccitt snd_timer snd_page_alloc evdev rtc ide_disk ide_cd cdrom usb_storage usbhid scsi_mod ohci1394 piix ieee1394 ide_core ehci_hcd uhci_hcd usbcore unix
Feb  5 13:34:22 stoa kernel: CPU:    0
Feb  5 13:34:22 stoa kernel: EIP:    0060:[<c0150b01>]    Tainted: G      D VLI
Feb  5 13:34:22 stoa kernel: EFLAGS: 00010006   (2.6.23.13newhome #3)
Feb  5 13:34:22 stoa kernel: EIP is at __kmalloc+0x4c/0x8a
Feb  5 13:34:22 stoa kernel: eax: 00000000   ebx: 3175b800   ecx: c0385be4   edx: c15c62e0
Feb  5 13:34:22 stoa kernel: esi: c0385be4   edi: 00000286   ebp: 000000d0   esp: e8b4fe20
Feb  5 13:34:22 stoa kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Feb  5 13:34:22 stoa kernel: Process route (pid: 6201, ti=e8b4e000 task=e8186540 task.ti=e8b4e000)
Feb  5 13:34:22 stoa kernel: Stack: e80c1f80 e86a9500 e86a9000 e85d76e8 ffffff97 00000000 c029f81d e8b4fe84 
Feb  5 13:34:22 stoa kernel:        0000890b c029caf4 00000000 00000000 00000000 e8b4fef4 e85d76c0 00000000 
Feb  5 13:34:22 stoa kernel:        00000000 00000000 00000000 e86a9000 00000000 00000000 00000000 ffffff97 
Feb  5 13:34:22 stoa kernel: Call Trace:
Feb  5 13:34:22 stoa kernel:  [<c029f81d>] fn_hash_insert+0x7e/0x619
Feb  5 13:34:22 stoa kernel:  [<c029caf4>] inet_addr_type+0x73/0xc8
Feb  5 13:34:22 stoa kernel:  [<c029d4c9>] ip_rt_ioctl+0x2ed/0x334
Feb  5 13:34:22 stoa kernel:  [<c02594a1>] sock_attach_fd+0x53/0xae
Feb  5 13:34:22 stoa kernel:  [<c0259054>] sock_ioctl+0x19f/0x1be
Feb  5 13:34:22 stoa kernel:  [<c0258eb5>] sock_ioctl+0x0/0x1be
Feb  5 13:34:22 stoa kernel:  [<c015c369>] do_ioctl+0x19/0x4d
Feb  5 13:34:22 stoa kernel:  [<c015c585>] vfs_ioctl+0x1e8/0x1ff
Feb  5 13:34:22 stoa kernel:  [<c01521ce>] do_sys_open+0xbb/0xc5
Feb  5 13:34:22 stoa kernel:  [<c015c5cf>] sys_ioctl+0x33/0x4c
Feb  5 13:34:22 stoa kernel:  [<c0103bee>] syscall_call+0x7/0xb
Feb  5 13:34:22 stoa kernel:  [<c02c0000>] ieee80211_rx_mgmt_assoc_resp+0x4be/0x5c5
Feb  5 13:34:22 stoa kernel:  =======================
Feb  5 13:34:22 stoa kernel: Code: 00 00 00 85 d2 74 06 83 7a 0c 00 75 17 89 54 24 04 83 c9 ff 89 ea 89 04 24 89 f0 e8 32 f2 ff ff 89 c3 eb 0d 8b 5a 0c 0f b7 42 0a <8b> 04 83 89 42 0c 57 9d 89 e8 25 00 80 00 00 66 85 c0 74 1f 85 
Feb  5 13:34:22 stoa kernel: EIP: [<c0150b01>] __kmalloc+0x4c/0x8a SS:ESP 0068:e8b4fe20




Feb  5 13:34:29 stoa kernel: BUG: unable to handle kernel paging request at virtual address 3175b800
Feb  5 13:34:29 stoa kernel:  printing eip:
Feb  5 13:34:29 stoa kernel: c0150b01
Feb  5 13:34:29 stoa kernel: *pde = 00000000
Feb  5 13:34:29 stoa kernel: Oops: 0000 [#4]
Feb  5 13:34:29 stoa kernel: Modules linked in: ppdev lp cpufreq_stats fuse sr_mod sbp2 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss video sd_mod output rng_core irda parport_pc parport 8250_pci 8250 serial_core snd_pcm crc_ccitt snd_timer snd_page_alloc evdev rtc ide_disk ide_cd cdrom usb_storage usbhid scsi_mod ohci1394 piix ieee1394 ide_core ehci_hcd uhci_hcd usbcore unix
Feb  5 13:34:29 stoa kernel: CPU:    0
Feb  5 13:34:29 stoa kernel: EIP:    0060:[<c0150b01>]    Tainted: G      D VLI
Feb  5 13:34:29 stoa kernel: EFLAGS: 00010006   (2.6.23.13newhome #3)
Feb  5 13:34:29 stoa kernel: EIP is at __kmalloc+0x4c/0x8a
Feb  5 13:34:29 stoa kernel: eax: 00000000   ebx: 3175b800   ecx: c0385be4   edx: c15c62e0
Feb  5 13:34:29 stoa kernel: esi: c0385be4   edi: 00000286   ebp: 000080d0   esp: ea47ddc4
Feb  5 13:34:29 stoa kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Feb  5 13:34:29 stoa kernel: Process sleepd (pid: 5413, ti=ea47c000 task=eceb2000 task.ti=ea47c000)
Feb  5 13:34:29 stoa kernel: Stack: e85c2200 ecc47eb0 dfc483f0 00000004 ea47de4c e86a95b0 c01e98d4 c03300a3 
Feb  5 13:34:29 stoa kernel:        c03300a3 c0160b25 00000008 00000001 00000000 00000000 dfc483f0 e86a95b0 
Feb  5 13:34:29 stoa kernel:        00000000 e86a95b0 c01e9938 137e7407 00000005 e8fbc018 dffea400 e85c2200 
Feb  5 13:34:29 stoa kernel: Call Trace:
Feb  5 13:34:29 stoa kernel:  [<c01e98d4>] acpi_ns_internalize_name+0x44/0x77
Feb  5 13:34:29 stoa kernel:  [<c0160b25>] dput+0x21/0xd7
Feb  5 13:34:29 stoa kernel:  [<c01e9938>] acpi_ns_get_node+0x31/0x93
Feb  5 13:34:29 stoa kernel:  [<c0163913>] mntput_no_expire+0x11/0x4e
Feb  5 13:34:29 stoa kernel:  [<c015a8d3>] link_path_walk+0xa5/0xaf
Feb  5 13:34:29 stoa kernel:  [<c01e92aa>] acpi_ns_evaluate+0x2e/0xf0
Feb  5 13:34:29 stoa kernel:  [<c01e8f81>] acpi_evaluate_object+0x124/0x1c7
Feb  5 13:34:29 stoa kernel:  [<c01db1fc>] acpi_evaluate_integer+0x7b/0xae
Feb  5 13:34:29 stoa kernel:  [<c01f1c16>] acpi_bus_get_status+0x32/0x89
Feb  5 13:34:29 stoa kernel:  [<c0166c8e>] single_open+0x48/0x68
Feb  5 13:34:29 stoa kernel:  [<c01f4c87>] acpi_battery_get_status+0xb/0x3d
Feb  5 13:34:29 stoa kernel:  [<c0178e47>] proc_reg_open+0x0/0x30
Feb  5 13:34:29 stoa kernel:  [<c0178e71>] proc_reg_open+0x2a/0x30
Feb  5 13:34:29 stoa kernel:  [<c01f4d6e>] acpi_battery_update+0x2a/0x88
Feb  5 13:34:29 stoa kernel:  [<c0151fc5>] __dentry_open+0xd4/0x160
Feb  5 13:34:29 stoa kernel:  [<c01f4e0b>] acpi_battery_read+0x3f/0x7a
Feb  5 13:34:29 stoa kernel:  [<c0166d9a>] seq_read+0xec/0x276
Feb  5 13:34:29 stoa kernel:  [<c0166cae>] seq_read+0x0/0x276
Feb  5 13:34:29 stoa kernel:  [<c0178d15>] proc_reg_read+0x35/0x46
Feb  5 13:34:29 stoa kernel:  [<c0178ce0>] proc_reg_read+0x0/0x46
Feb  5 13:34:29 stoa kernel:  [<c0153b51>] vfs_read+0x88/0x10a
Feb  5 13:34:29 stoa kernel:  [<c0153e71>] sys_read+0x41/0x67
Feb  5 13:34:29 stoa kernel:  [<c0103bee>] syscall_call+0x7/0xb
Feb  5 13:34:29 stoa kernel:  =======================
Feb  5 13:34:29 stoa kernel: Code: 00 00 00 85 d2 74 06 83 7a 0c 00 75 17 89 54 24 04 83 c9 ff 89 ea 89 04 24 89 f0 e8 32 f2 ff ff 89 c3 eb 0d 8b 5a 0c 0f b7 42 0a <8b> 04 83 89 42 0c 57 9d 89 e8 25 00 80 00 00 66 85 c0 74 1f 85 
Feb  5 13:34:29 stoa kernel: EIP: [<c0150b01>] __kmalloc+0x4c/0x8a SS:ESP 0068:ea47ddc4

=======================================================================

--
www.ljudmila.org/ludliteratura                 myspace.com/therealthings
