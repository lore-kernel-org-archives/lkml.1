Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZLENyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZLENyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 08:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZLENyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 08:54:22 -0500
Received: from web52907.mail.re2.yahoo.com ([206.190.49.17]:43849 "HELO
	web52907.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752936AbZLENyU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 08:54:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=mLpzFdrlWPZb+l7WWh9oPNfHWWvFFVjtSPTSLOZWxZuNicJLWbyfgUzE1qCBA2uS6n9W+11fRe+KQOSs7ZQRJHXh05hPb64FO+cpcQoVHDXOUtnBRiGgXquOXso3fnND/mmBoLqVURVPfd0UaiAdgeTsHBJuCGf0ugy+N262aec=;
Message-ID: <773065.95780.qm@web52907.mail.re2.yahoo.com>
X-YMail-OSG: PX6MiSYVM1l528bAQsfoTmMyz2LzBMwGM_cbn7Y.Y5piAb2ybHwNxT90zaAOb4Q16uDvFs88F2EZVRkBf4zaA2WNmECiOvNJ36qdgWrP998_UZjXBKiNu3Wo_hEZv3XDwyw5h1B81mNt8CsUIuf924SAhSFhjU0iSePdoYQwYLaer3NsVz_kaEMKjItyxomdAqHkSvzyjWTLFAWIk9G4fV8agEj8ICTkRy2H4NDJtsJHKM0bIjYcBFJ3nifJGfSCBSitTlh_nx8Jm4EUasLCjT9xh9YRdKULJv_nW.UelBc-
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.8.100.260964
Date: Sat, 5 Dec 2009 05:54:26 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [OOPS] Radeon KMS with 2.6.31.6
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tripped over this KMS(?) bug this morning. I have a Radeon 9550, and the userspace environment is Fedora 12. The kernel is vanilla 2.6.31.6.

Cheers,
Chris

BUG: unable to handle kernel NULL pointer dereference at 00000028
IP: [<f808f166>] ttm_bo_wait+0x45/0x145 [ttm]
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
[drm:radeon_object_list_reserve] *ERROR* radeon: failed to reserve object.
Modules linked in: tun fuse nfsd lockd auth_rpcgss exportfs sunrpc autofs4 af_packet ipt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_LOG nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_mod uinput snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_emu10k1 snd_ac97_codec snd_usb_audio ac97_bus snd_seq snd_pcm snd_usb_lib pwc ppdev parport_pc snd_rawmidi snd_timer snd_seq_device uvcvideo firewire_ohci firewire_core psmouse parport serio_raw snd_page_alloc snd_util_mem snd_hwdep videodev sg i2c_i801 pcspkr snd v4l1_compat soundcore floppy crc_itu_t dcdbas ext3 jbd mbcache sr_mod cdrom sd_mod pata_acpi sata_sil uhci_hcd ata_piix ehci_hcd libata scsi_mod usbcore e1000 button thermal radeon intel_agp ttm drm agpgart i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect [last unloaded: processor]

Pid: 18, comm: events/2 Tainted: G        W  (2.6.31.6 #1) Precision WorkStation 650    
EIP: 0060:[<f808f166>] EFLAGS: 00010282 CPU: 2
EIP is at ttm_bo_wait+0x45/0x145 [ttm]
EAX: d9f0f0e0 EBX: f5c15a00 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: f5c15a34 EBP: f5c15a90 ESP: f7052f08
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process events/2 (pid: 18, ti=f7052000 task=f7068f80 task.ti=f7052000)
Stack:
 f7068f80 c2363e80 011c781b 00000000 00000000 c12eee80 f4dc2000 f5c15a00
<0> f717a284 00000001 f5c15a34 f808fe0e 00000001 f717a284 f717a284 c12eee80
<0> f7069128 00000000 f5c1586c f717a544 f717a284 f5c15800 f809000c f5c15a24
Call Trace:
 [<f808fe0e>] ? ttm_bo_cleanup_refs+0x33/0x1ba [ttm]
 [<f809000c>] ? ttm_bo_delayed_delete+0x77/0xf1 [ttm]
 [<c11c76c2>] ? _spin_lock_irqsave+0x11/0x2a
 [<f8090096>] ? ttm_bo_delayed_workqueue+0x10/0x23 [ttm]
 [<c1030146>] ? worker_thread+0x107/0x193
 [<f8090086>] ? ttm_bo_delayed_workqueue+0x0/0x23 [ttm]
 [<c1032ee4>] ? autoremove_wake_function+0x0/0x29
 [<c103003f>] ? worker_thread+0x0/0x193
 [<c1032c9b>] ? kthread+0x6b/0x70
 [<c1032c30>] ? kthread+0x0/0x70
 [<c10033cf>] ? kernel_thread_helper+0x7/0x10
Code: 00 00 00 0f 84 16 01 00 00 8d ab 90 00 00 00 8d 7b 34 0f b6 d2 89 54 24 0c 0f b6 c9 89 4c 24 10 e9 ec 00 00 00 8b 93 88 00 00 00 <ff> 56 28 84 c0 74 25 8b 83 8c 00 00 00 89 44 24 14 c7 83 8c 00 
EIP: [<f808f166>] ttm_bo_wait+0x45/0x145 [ttm] SS:ESP 0068:f7052f08
CR2: 0000000000000028
------------[ cut here ]------------
---[ end trace c7e252cba6618d6d ]---
note: events/2[18] exited with preempt_count 1
kernel BUG at /home/chris/LINUX/linux-2.6.31/drivers/gpu/drm/ttm/ttm_bo.c:102!
invalid opcode: 0000 [#2] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
Modules linked in: tun fuse nfsd lockd auth_rpcgss exportfs sunrpc autofs4 af_packet ipt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_LOG nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_mod uinput snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_emu10k1 snd_ac97_codec snd_usb_audio ac97_bus snd_seq snd_pcm snd_usb_lib pwc ppdev parport_pc snd_rawmidi snd_timer snd_seq_device uvcvideo firewire_ohci firewire_core psmouse parport serio_raw snd_page_alloc snd_util_mem snd_hwdep videodev sg i2c_i801 pcspkr snd v4l1_compat soundcore floppy crc_itu_t dcdbas ext3 jbd mbcache sr_mod cdrom sd_mod pata_acpi sata_sil uhci_hcd ata_piix ehci_hcd libata scsi_mod usbcore e1000 button thermal radeon intel_agp ttm drm agpgart i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect [last unloaded: processor]

Pid: 2737, comm: Xorg Tainted: G      D W  (2.6.31.6 #1) Precision WorkStation 650    
EIP: 0060:[<f808f2d6>] EFLAGS: 00013206 CPU: 0
EIP is at ttm_bo_unreserve+0x35/0xaf [ttm]
EAX: f4422064 EBX: f717a544 ECX: 00000000 EDX: d9f88a64
ESI: d9f88a00 EDI: f717a284 EBP: d9f0f640 ESP: f5c0fde0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process Xorg (pid: 2737, ti=f5c0f000 task=f6bc62e0 task.ti=f5c0f000)
Stack:
 f66a94f8 f5c0fe58 f5c0fe58 d9f0f640 f816a136 ffffffab 00000000 f816a21d
<0> f8173f47 00000007 0000001c f5c0fe58 f6942c00 00000000 f717a000 00000000
<0> f5c0fe70 f5c0fe34 f8174062 f5c0fe8c f717a880 f717a000 f5117840 00000002
Call Trace:
 [<f816a136>] ? radeon_object_list_unreserve+0x19/0x28 [radeon]
 [<f816a21d>] ? radeon_object_list_validate+0x25/0x20e [radeon]
 [<f8173f47>] ? radeon_cs_parser_relocs+0x13d/0x1a8 [radeon]
 [<f8174062>] ? radeon_cs_ioctl+0xb0/0x156 [radeon]
 [<f8064269>] ? drm_ioctl+0x1b2/0x22b [drm]
 [<f8173fb2>] ? radeon_cs_ioctl+0x0/0x156 [radeon]
 [<c107e793>] ? do_sync_read+0xbe/0xf6
 [<c1088aef>] ? vfs_ioctl+0x58/0x72
 [<c1089005>] ? do_vfs_ioctl+0x457/0x497
 [<c11c781b>] ? _spin_unlock_irq+0xd/0x20
 [<c1026b56>] ? do_setitimer+0x142/0x296
 [<c1026cf0>] ? sys_setitimer+0x46/0x71
 [<c1089072>] ? sys_ioctl+0x2d/0x44
 [<c1002870>] ? sysenter_do_call+0x12/0x22
Code: c0 02 00 00 89 d8 e8 c1 82 13 c9 8b 3e 8b 86 84 00 00 00 85 c0 75 04 0f 0b eb fe f6 46 52 20 75 5d 8b 46 64 8d 56 64 39 d0 74 04 <0f> 0b eb fe 8b 56 4c 42 6b d2 50 8d 14 17 8b 4a 18 89 42 18 83 
EIP: [<f808f2d6>] ttm_bo_unreserve+0x35/0xaf [ttm] SS:ESP 0068:f5c0fde0
---[ end trace c7e252cba6618d6e ]---
note: Xorg[2737] exited with preempt_count 2
BUG: scheduling while atomic: Xorg/2737/0x10000002
Modules linked in: tun fuse nfsd lockd auth_rpcgss exportfs sunrpc autofs4 af_packet ipt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_LOG nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_mod uinput snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_emu10k1 snd_ac97_codec snd_usb_audio ac97_bus snd_seq snd_pcm snd_usb_lib pwc ppdev parport_pc snd_rawmidi snd_timer snd_seq_device uvcvideo firewire_ohci firewire_core psmouse parport serio_raw snd_page_alloc snd_util_mem snd_hwdep videodev sg i2c_i801 pcspkr snd v4l1_compat soundcore floppy crc_itu_t dcdbas ext3 jbd mbcache sr_mod cdrom sd_mod pata_acpi sata_sil uhci_hcd ata_piix ehci_hcd libata scsi_mod usbcore e1000 button thermal radeon intel_agp ttm drm agpgart i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect [last unloaded: processor]
Pid: 2737, comm: Xorg Tainted: G      D W  2.6.31.6 #1
Call Trace:
 [<c11c5665>] ? schedule+0x87/0x764
 [<c1062354>] ? lru_add_drain+0x67/0x82
 [<c10213bf>] ? __cond_resched+0xf/0x27
 [<c11c5db8>] ? _cond_resched+0x18/0x21
 [<c106af4b>] ? unmap_vmas+0x46a/0x53d
 [<c106e0df>] ? exit_mmap+0x99/0x130
 [<c1021e77>] ? mmput+0x1c/0x7e
 [<c10250d7>] ? exit_mm+0xd9/0xe0
 [<c10505fd>] ? audit_free+0x165/0x188
 [<c11c769b>] ? _spin_lock_irq+0xe/0x24
 [<c102652b>] ? do_exit+0x15e/0x55d
 [<c10036a4>] ? do_invalid_op+0x0/0x70
 [<c11c5390>] ? printk+0xe/0x16
 [<c10036a4>] ? do_invalid_op+0x0/0x70
 [<c10059a4>] ? oops_end+0x72/0x75
 [<c100370b>] ? do_invalid_op+0x67/0x70
 [<f808f2d6>] ? ttm_bo_unreserve+0x35/0xaf [ttm]
 [<c11c76c2>] ? _spin_lock_irqsave+0x11/0x2a
 [<c11c783c>] ? _spin_unlock_irqrestore+0xe/0x21
 [<c103629b>] ? down_trylock+0x1b/0x23
 [<c11c789f>] ? _spin_unlock+0xc/0x1f
 [<c10244dd>] ? vprintk+0x2da/0x30e
 [<c11c783c>] ? _spin_unlock_irqrestore+0xe/0x21
 [<f808f6d4>] ? ttm_bo_wait_unreserved+0x8b/0xfe [ttm]
 [<c11c7b5e>] ? error_code+0x66/0x6c
 [<c10036a4>] ? do_invalid_op+0x0/0x70
 [<f808f2d6>] ? ttm_bo_unreserve+0x35/0xaf [ttm]
 [<f816a136>] ? radeon_object_list_unreserve+0x19/0x28 [radeon]
 [<f816a21d>] ? radeon_object_list_validate+0x25/0x20e [radeon]
 [<f8173f47>] ? radeon_cs_parser_relocs+0x13d/0x1a8 [radeon]
 [<f8174062>] ? radeon_cs_ioctl+0xb0/0x156 [radeon]
 [<f8064269>] ? drm_ioctl+0x1b2/0x22b [drm]
 [<f8173fb2>] ? radeon_cs_ioctl+0x0/0x156 [radeon]
 [<c107e793>] ? do_sync_read+0xbe/0xf6
 [<c1088aef>] ? vfs_ioctl+0x58/0x72
 [<c1089005>] ? do_vfs_ioctl+0x457/0x497
 [<c11c781b>] ? _spin_unlock_irq+0xd/0x20
 [<c1026b56>] ? do_setitimer+0x142/0x296
 [<c1026cf0>] ? sys_setitimer+0x46/0x71
 [<c1089072>] ? sys_ioctl+0x2d/0x44
 [<c1002870>] ? sysenter_do_call+0x12/0x22
SysRq : Emergency Sync
SysRq : Emergency Remount R/O
SysRq : Resetting



      
