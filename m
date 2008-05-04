Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYEDS1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYEDS1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYEDS11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:27:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:45870 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYEDS10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BWsy5epdrYNJGMuKhL2LRZJieYbN1Nt9bYNlArSvG0q813BId/Yp2XUoCZoaICo5BmgvgxYlZm4x1AI7/TuUAn1DchK4ia/R8AksMFgikvyRsEo5aKSTT1V9lpVcKfO2/Y4DfLLIaTAZWPzO3O+ktt0bhpyMT4sugqdSbhNUD20=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [OOPS] fs/buffer.c:1183 mark_buffer_dirty+0x5b/0x80()
Date: Sun, 4 May 2008 21:27:18 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805042127.19784.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I may mess the usb disk, but I don't think oops is expected outcome... :)

Alon.

---

May  4 21:16:02 alon1 automount[31406]: >> mount: you must specify the filesystem type
May  4 21:16:02 alon1 automount[31406]: mount(generic): failed to mount /dev/cdrom (type auto) on /mnt/auto/cdrom
May  4 21:16:02 alon1 automount[31406]: failed to mount /mnt/auto/cdrom
May  4 21:16:02 alon1 automount[31412]: failed to mount /mnt/auto/.directory
May  4 21:16:57 alon1 ------------[ cut here ]------------
May  4 21:16:57 alon1 WARNING: at fs/buffer.c:1183 mark_buffer_dirty+0x5b/0x80()
May  4 21:16:57 alon1 Modules linked in: nls_cp437 vfat fat usb_storage aes_generic crypto_algapi ieee80211_crypt_ccmp ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async radeon drm vmnet(P) vmmon(P) ipv6 tun autofs4 nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp ipt_LOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack rfcomm l2cap iptable_filter ip_tables x_tables snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base pcmcia hci_usb bluetooth snd_intel8x0 snd_ac97_codec ac97_bus ipw2200 nsc_ircc snd_pcm thinkpad_acpi irda snd_timer ieee80211 yenta_socket snd psmouse ehci_hcd rsrc_nonstatic hwmon pcspkr i2c_i801 ieee80211_crypt e1000 uhci_hcd crc_ccitt soundcore pcmcia_core intel_agp nvram rtc snd_page_alloc thermal firmware_class sr_mod agpgart sg processor cdrom battery ac button unix usbcore evdev ext3 jbd ext2 mbcache loop ata_piix libata dock sd_mod scsi_mod [last unloaded: uhci_hcd]
May  4 21:16:57 alon1 Pid: 7035, comm: bash Tainted: P         2.6.25-gentoo-r2 #3
May  4 21:16:57 alon1 [<c011baaf>] warn_on_slowpath+0x5f/0x90
May  4 21:16:57 alon1 [<c015329f>] find_get_pages_tag+0x2f/0x90
May  4 21:16:57 alon1 [<c0134191>] getnstimeofday+0x31/0xc0
May  4 21:16:57 alon1 [<c013247d>] ktime_get_ts+0x1d/0x50
May  4 21:16:57 alon1 [<c01d03f1>] rb_insert_color+0x91/0xc0
May  4 21:16:57 alon1 [<c0131ae2>] enqueue_hrtimer+0x72/0xf0
May  4 21:16:57 alon1 [<c0117a7b>] hrtick_set+0x7b/0x120
May  4 21:16:57 alon1 [<c02c0145>] schedule+0x185/0x310
May  4 21:16:57 alon1 [<c019727b>] mark_buffer_dirty+0x5b/0x80
May  4 21:16:57 alon1 [<f9e4fd9f>] journal_update_superblock+0x5f/0xd0 [jbd]
May  4 21:16:57 alon1 [<f9e51046>] journal_destroy+0x196/0x220 [jbd]
May  4 21:16:57 alon1 [<c0188fe7>] destroy_inode+0x27/0x40
May  4 21:16:57 alon1 [<f9e84b12>] ext3_put_super+0x22/0x1a0 [ext3]
May  4 21:16:57 alon1 [<c0189aa7>] invalidate_inodes+0xc7/0xe0
May  4 21:16:57 alon1 [<c0176b65>] generic_shutdown_super+0x55/0x110
May  4 21:16:57 alon1 [<c018b9f0>] mntput_no_expire+0x40/0x90
May  4 21:16:57 alon1 [<c0176c2c>] kill_block_super+0xc/0x20
May  4 21:16:57 alon1 [<c0176cf4>] deactivate_super+0x54/0x80
May  4 21:16:57 alon1 [<c018b33d>] set_fs_pwd+0x4d/0x60
May  4 21:16:57 alon1 [<c0174309>] sys_chdir+0x69/0x70
May  4 21:16:57 alon1 [<c014ad05>] audit_syscall_entry+0x105/0x130
May  4 21:16:57 alon1 [<c010a77b>] do_syscall_trace+0x1ab/0x1d0
May  4 21:16:57 alon1 [<c0103f7a>] syscall_call+0x7/0xb
May  4 21:16:57 alon1 =======================
May  4 21:16:57 alon1 ---[ end trace d8c92486a2ccffd4 ]---
May  4 21:16:57 alon1 Buffer I/O error on device sdb1, logical block 1575
May  4 21:16:57 alon1 lost page write due to I/O error on sdb1

