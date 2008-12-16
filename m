Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYLPSOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYLPSOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYLPSOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:14:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:6781 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYLPSOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=drN3LyuTDZ9QoeY5cYK3aK71xR57AexJ93hJo70VuCBjjSGoLvpD7KyK5fpbVJ51I6
         Su05KwQGfIRJgv5tQx6HrD8PRBkGlt+q+QoIcI69a/beOpyol+vd2M4gF94NW4PIoJCr
         PTWIe4cPE0eTYBFjYq8p3KMYd7IRQcCqWLWD4=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [oops] 2.6.27 ppp+rfcomm+tty
Date: Tue, 16 Dec 2008 20:14:07 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812162014.08969.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I hope someone can make sense of this... :)

It happened during software suspend using uswsusp.

Maybe it related to [1], but I believe that one was fixed.

Thanks!
Alon.

[1] http://lkml.org/lkml/2007/10/23/317
---

Dec 16 17:30:43 alon1 pppd[19700]: Connection terminated.
Dec 16 17:30:43 alon1 ------------[ cut here ]------------
Dec 16 17:30:43 alon1 kernel BUG at drivers/char/tty_ldisc.c:199!
Dec 16 17:30:43 alon1 invalid opcode: 0000 [#1] PREEMPT 
Dec 16 17:30:43 alon1 Modules linked in: vfat fat isofs ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async radeon drm autofs4 aes_generic crypto_algapi ieee80211_crypt_ccmp bridge stp llc nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp xt_state ipt_LOG xt_limit nf_conntrack_ipv4 nf_conntrack rfcomm l2cap iptable_filter ip_tables x_tables snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base rtc_cmos rtc_core rtc_lib hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec thinkpad_acpi nsc_ircc ac97_bus rfkill ipw2200 snd_pcm irda hwmon yenta_socket snd_timer ehci_hcd ieee80211 snd led_class rsrc_nonstatic thermal uhci_hcd sr_mod e1000 intel_agp pcmcia_core crc_ccitt nvram soundcore battery processor ieee80211_crypt i2c_i801 psmouse agpgart ac cdrom snd_page_alloc button pcspkr sg usbcore unix evdev ext3 jbd ext2 mbcache loop ata_piix libata dock sd_mod scsi_mod [last unloaded: uhci_hcd]
Dec 16 17:30:43 alon1 
Dec 16 17:30:43 alon1 Pid: 19700, comm: pppd Not tainted (2.6.27-gentoo-r4 #1)
Dec 16 17:30:43 alon1 EIP: 0060:[<c01f253e>] EFLAGS: 00210046 CPU: 0
Dec 16 17:30:43 alon1 EIP is at tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 EAX: 00000000 EBX: 00200283 ECX: f9b9eda0 EDX: f9b9eda0
Dec 16 17:30:43 alon1 ESI: f53e6000 EDI: 00000000 EBP: 00000000 ESP: f303dea8
Dec 16 17:30:43 alon1 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Dec 16 17:30:43 alon1 Process pppd (pid: 19700, ti=f303c000 task=f526ec40 task.ti=f303c000)
Dec 16 17:30:43 alon1 Stack: 00000000 c01f2cef f766c400 f7206078 f1a72c78 00000000 00000001 00000001 
Dec 16 17:30:43 alon1 f303c000 00000000 00200292 f53e6010 00200292 00000000 00000000 f53e6000 
Dec 16 17:30:43 alon1 00000000 00000002 c01eb84f 00200282 f53e6000 f53e6000 00000000 f526ec40 
Dec 16 17:30:43 alon1 Call Trace:
Dec 16 17:30:43 alon1 [<c01f2cef>] tty_set_ldisc+0x2cf/0x420
Dec 16 17:30:43 alon1 [<c01eb84f>] tty_wakeup+0x2f/0x70
Dec 16 17:30:43 alon1 [<c012ff10>] autoremove_wake_function+0x0/0x50
Dec 16 17:30:43 alon1 [<c01ee77d>] tty_ioctl+0x3ed/0x840
Dec 16 17:30:43 alon1 [<c0184776>] do_unlinkat+0x46/0x150
Dec 16 17:30:43 alon1 [<c01ee390>] tty_ioctl+0x0/0x840
Dec 16 17:30:43 alon1 [<c01865bb>] vfs_ioctl+0x2b/0x90
Dec 16 17:30:43 alon1 [<c018667c>] do_vfs_ioctl+0x5c/0x2a0
Dec 16 17:30:43 alon1 [<c014d97d>] audit_syscall_exit+0x2cd/0x350
Dec 16 17:30:43 alon1 [<c0186928>] sys_ioctl+0x68/0x80
Dec 16 17:30:43 alon1 [<c0103129>] sysenter_do_call+0x12/0x21
Dec 16 17:30:43 alon1 =======================
Dec 16 17:30:43 alon1 Code: 2a 48 89 42 48 8b 42 44 e8 00 cf f4 ff 53 9d 89 e0 25 00 e0 ff ff ff 48 14 f6 40 08 08 75 06 5b c3 0f 0b eb fe 5b e9 b2 cf 0d 00 <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 56 89 c6 
Dec 16 17:30:43 alon1 EIP: [<c01f253e>] tty_ldisc_put+0x4e/0x60 SS:ESP 0068:f303dea8
Dec 16 17:30:43 alon1 ---[ end trace a8a5401810b3232e ]---
Dec 16 17:30:43 alon1 note: pppd[19700] exited with preempt_count 2
Dec 16 17:30:43 alon1 BUG: scheduling while atomic: pppd/19700/0x10000002
Dec 16 17:30:43 alon1 Modules linked in: vfat fat isofs ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async radeon drm autofs4 aes_generic crypto_algapi ieee80211_crypt_ccmp bridge stp llc nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp xt_state ipt_LOG xt_limit nf_conntrack_ipv4 nf_conntrack rfcomm l2cap iptable_filter ip_tables x_tables snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base rtc_cmos rtc_core rtc_lib hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec thinkpad_acpi nsc_ircc ac97_bus rfkill ipw2200 snd_pcm irda hwmon yenta_socket snd_timer ehci_hcd ieee80211 snd led_class rsrc_nonstatic thermal uhci_hcd sr_mod e1000 intel_agp pcmcia_core crc_ccitt nvram soundcore battery processor ieee80211_crypt i2c_i801 psmouse agpgart ac cdrom snd_page_alloc button pcspkr sg usbcore unix evdev ext3 jbd ext2 mbcache loop ata_piix libata dock sd_mod scsi_mod [last unloaded: uhci_hcd]
Dec 16 17:30:43 alon1 Pid: 19700, comm: pppd Tainted: G      D   2.6.27-gentoo-r4 #1
Dec 16 17:30:43 alon1 [<c02cf41a>] schedule+0x29a/0x310
Dec 16 17:30:43 alon1 [<c0191713>] mntput_no_expire+0x13/0xf0
Dec 16 17:30:43 alon1 [<c0118cf3>] __cond_resched+0x13/0x30
Dec 16 17:30:43 alon1 [<c02cf877>] _cond_resched+0x27/0x30
Dec 16 17:30:43 alon1 [<c011ea65>] put_files_struct+0xa5/0xb0
Dec 16 17:30:43 alon1 [<c011ffc8>] do_exit+0x128/0x820
Dec 16 17:30:43 alon1 [<c011de4b>] printk+0x1b/0x20
Dec 16 17:30:43 alon1 [<c0104028>] oops_end+0x88/0x90
Dec 16 17:30:43 alon1 [<c0104830>] do_invalid_op+0x0/0x90
Dec 16 17:30:43 alon1 [<c01048b3>] do_invalid_op+0x83/0x90
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c015ac7a>] __alloc_pages_internal+0x9a/0x430
Dec 16 17:30:43 alon1 [<c02d0e22>] error_code+0x6a/0x70
Dec 16 17:30:43 alon1 [<c01e007b>] pci_size+0x1b/0xb0
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c01f2cef>] tty_set_ldisc+0x2cf/0x420
Dec 16 17:30:43 alon1 [<c01eb84f>] tty_wakeup+0x2f/0x70
Dec 16 17:30:43 alon1 [<c012ff10>] autoremove_wake_function+0x0/0x50
Dec 16 17:30:43 alon1 [<c01ee77d>] tty_ioctl+0x3ed/0x840
Dec 16 17:30:43 alon1 [<c0184776>] do_unlinkat+0x46/0x150
Dec 16 17:30:43 alon1 [<c01ee390>] tty_ioctl+0x0/0x840
Dec 16 17:30:43 alon1 [<c01865bb>] vfs_ioctl+0x2b/0x90
Dec 16 17:30:43 alon1 [<c018667c>] do_vfs_ioctl+0x5c/0x2a0
Dec 16 17:30:43 alon1 [<c014d97d>] audit_syscall_exit+0x2cd/0x350
Dec 16 17:30:43 alon1 [<c0186928>] sys_ioctl+0x68/0x80
Dec 16 17:30:43 alon1 [<c0103129>] sysenter_do_call+0x12/0x21
Dec 16 17:30:43 alon1 =======================
Dec 16 17:30:43 alon1 BUG: scheduling while atomic: pppd/19700/0x00000002
Dec 16 17:30:43 alon1 Modules linked in: vfat fat isofs ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async radeon drm autofs4 aes_generic crypto_algapi ieee80211_crypt_ccmp bridge stp llc nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp xt_state ipt_LOG xt_limit nf_conntrack_ipv4 nf_conntrack rfcomm l2cap iptable_filter ip_tables x_tables snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base rtc_cmos rtc_core rtc_lib hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec thinkpad_acpi nsc_ircc ac97_bus rfkill ipw2200 snd_pcm irda hwmon yenta_socket snd_timer ehci_hcd ieee80211 snd led_class rsrc_nonstatic thermal uhci_hcd sr_mod e1000 intel_agp pcmcia_core crc_ccitt nvram soundcore battery processor ieee80211_crypt i2c_i801 psmouse agpgart ac cdrom snd_page_alloc button pcspkr sg usbcore unix evdev ext3 jbd ext2 mbcache loop ata_piix libata dock sd_mod scsi_mod [last unloaded: uhci_hcd]
Dec 16 17:30:43 alon1 Pid: 19700, comm: pppd Tainted: G      D   2.6.27-gentoo-r4 #1
Dec 16 17:30:43 alon1 [<c02cf41a>] schedule+0x29a/0x310
Dec 16 17:30:43 alon1 [<c0175981>] __slab_free+0x1a1/0x300
Dec 16 17:30:43 alon1 [<c02cf965>] schedule_timeout+0x75/0xc0
Dec 16 17:30:43 alon1 [<c01b9f51>] release_sysfs_dirent+0x41/0xa0
Dec 16 17:30:43 alon1 [<c01b9f51>] release_sysfs_dirent+0x41/0xa0
Dec 16 17:30:43 alon1 [<c02cf6d8>] wait_for_common+0xa8/0x170
Dec 16 17:30:43 alon1 [<c0119d60>] default_wake_function+0x0/0x10
Dec 16 17:30:43 alon1 dnsmasq[19773]: exiting on receipt of SIGTERM
Dec 16 17:30:43 alon1 [<c012cb0f>] flush_cpu_workqueue+0x5f/0x90
Dec 16 17:30:43 alon1 [<c012cd10>] wq_barrier_func+0x0/0x10
Dec 16 17:30:43 alon1 [<c01f2889>] tty_ldisc_release+0x29/0x1c0
Dec 16 17:30:43 alon1 [<c0249321>] device_move+0xa1/0x120
Dec 16 17:30:43 alon1 [<f9b9191d>] rfcomm_dlc_close+0x2d/0x40 [rfcomm]
Dec 16 17:30:43 alon1 [<c01edbed>] release_dev+0x31d/0x4e0
Dec 16 17:30:43 alon1 [<c0267d65>] sk_free+0x65/0xe0
Dec 16 17:30:43 alon1 [<c018e447>] destroy_inode+0x27/0x40
Dec 16 17:30:43 alon1 [<c0267d65>] sk_free+0x65/0xe0
Dec 16 17:30:43 alon1 [<c018b7bf>] d_kill+0x3f/0x60
Dec 16 17:30:43 alon1 [<c018e447>] destroy_inode+0x27/0x40
Dec 16 17:30:43 alon1 [<c01d87bd>] rb_erase+0x15d/0x280
Dec 16 17:30:43 alon1 [<c01eddbf>] tty_release+0xf/0x20
Dec 16 17:30:43 alon1 [<c017b011>] __fput+0x91/0x190
Dec 16 17:30:43 alon1 [<c01780b7>] filp_close+0x47/0x80
Dec 16 17:30:43 alon1 [<c011ea60>] put_files_struct+0xa0/0xb0
Dec 16 17:30:43 alon1 [<c011ffc8>] do_exit+0x128/0x820
Dec 16 17:30:43 alon1 [<c011de4b>] printk+0x1b/0x20
Dec 16 17:30:43 alon1 [<c0104028>] oops_end+0x88/0x90
Dec 16 17:30:43 alon1 [<c0104830>] do_invalid_op+0x0/0x90
Dec 16 17:30:43 alon1 [<c01048b3>] do_invalid_op+0x83/0x90
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c015ac7a>] __alloc_pages_internal+0x9a/0x430
Dec 16 17:30:43 alon1 [<c02d0e22>] error_code+0x6a/0x70
Dec 16 17:30:43 alon1 [<c01e007b>] pci_size+0x1b/0xb0
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c01f2cef>] tty_set_ldisc+0x2cf/0x420
Dec 16 17:30:43 alon1 [<c01eb84f>] tty_wakeup+0x2f/0x70
Dec 16 17:30:43 alon1 [<c012ff10>] autoremove_wake_function+0x0/0x50
Dec 16 17:30:43 alon1 [<c01ee77d>] tty_ioctl+0x3ed/0x840
Dec 16 17:30:43 alon1 [<c0184776>] do_unlinkat+0x46/0x150
Dec 16 17:30:43 alon1 [<c01ee390>] tty_ioctl+0x0/0x840
Dec 16 17:30:43 alon1 [<c01865bb>] vfs_ioctl+0x2b/0x90
Dec 16 17:30:43 alon1 [<c018667c>] do_vfs_ioctl+0x5c/0x2a0
Dec 16 17:30:43 alon1 [<c014d97d>] audit_syscall_exit+0x2cd/0x350
Dec 16 17:30:43 alon1 [<c0186928>] sys_ioctl+0x68/0x80
Dec 16 17:30:43 alon1 [<c0103129>] sysenter_do_call+0x12/0x21
Dec 16 17:30:43 alon1 =======================
Dec 16 17:30:43 alon1 BUG: scheduling while atomic: pppd/19700/0x00000002
Dec 16 17:30:43 alon1 Modules linked in: vfat fat isofs ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async radeon drm autofs4 aes_generic crypto_algapi ieee80211_crypt_ccmp bridge stp llc nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp xt_state ipt_LOG xt_limit nf_conntrack_ipv4 nf_conntrack rfcomm l2cap iptable_filter ip_tables x_tables snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base rtc_cmos rtc_core rtc_lib hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec thinkpad_acpi nsc_ircc ac97_bus rfkill ipw2200 snd_pcm irda hwmon yenta_socket snd_timer ehci_hcd ieee80211 snd led_class rsrc_nonstatic thermal uhci_hcd sr_mod e1000 intel_agp pcmcia_core crc_ccitt nvram soundcore battery processor ieee80211_crypt i2c_i801 psmouse agpgart ac cdrom snd_page_alloc button pcspkr sg usbcore unix evdev ext3 jbd ext2 mbcache loop ata_piix libata dock sd_mod scsi_mod [last unloaded: uhci_hcd]
Dec 16 17:30:43 alon1 Pid: 19700, comm: pppd Tainted: G      D   2.6.27-gentoo-r4 #1
Dec 16 17:30:43 alon1 [<c02cf41a>] schedule+0x29a/0x310
Dec 16 17:30:43 alon1 [<c02cf965>] schedule_timeout+0x75/0xc0
Dec 16 17:30:43 alon1 [<c01eb2bf>] tty_buffer_free_all+0x4f/0x70
Dec 16 17:30:43 alon1 [<c01eb4ad>] release_tty+0x2d/0x50
Dec 16 17:30:43 alon1 [<c01eb2bf>] tty_buffer_free_all+0x4f/0x70
Dec 16 17:30:43 alon1 [<c01eb4ad>] release_tty+0x2d/0x50
Dec 16 17:30:43 alon1 [<c01eb4ad>] release_tty+0x2d/0x50
Dec 16 17:30:43 alon1 [<c02cf6d8>] wait_for_common+0xa8/0x170
Dec 16 17:30:43 alon1 [<c0119d60>] default_wake_function+0x0/0x10
Dec 16 17:30:43 alon1 [<c012db68>] synchronize_rcu+0x28/0x30
Dec 16 17:30:43 alon1 [<c012db90>] wakeme_after_rcu+0x0/0x10
Dec 16 17:30:43 alon1 [<c0271ab6>] rollback_registered+0x76/0x100
Dec 16 17:30:43 alon1 [<c018e447>] destroy_inode+0x27/0x40
Dec 16 17:30:43 alon1 [<f9a776f7>] ppp_release+0x57/0x60 [ppp_generic]
Dec 16 17:30:43 alon1 [<c0271b56>] unregister_netdevice+0x16/0x70
Dec 16 17:30:43 alon1 [<c0271bbf>] unregister_netdev+0xf/0x20
Dec 16 17:30:43 alon1 [<f9a772df>] ppp_shutdown_interface+0x5f/0xb0 [ppp_generic]
Dec 16 17:30:43 alon1 [<f9a776dc>] ppp_release+0x3c/0x60 [ppp_generic]
Dec 16 17:30:43 alon1 [<c017b011>] __fput+0x91/0x190
Dec 16 17:30:43 alon1 [<c01780b7>] filp_close+0x47/0x80
Dec 16 17:30:43 alon1 [<c011ea60>] put_files_struct+0xa0/0xb0
Dec 16 17:30:43 alon1 [<c011ffc8>] do_exit+0x128/0x820
Dec 16 17:30:43 alon1 [<c011de4b>] printk+0x1b/0x20
Dec 16 17:30:43 alon1 [<c0104028>] oops_end+0x88/0x90
Dec 16 17:30:43 alon1 [<c0104830>] do_invalid_op+0x0/0x90
Dec 16 17:30:43 alon1 [<c01048b3>] do_invalid_op+0x83/0x90
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c015ac7a>] __alloc_pages_internal+0x9a/0x430
Dec 16 17:30:43 alon1 [<c02d0e22>] error_code+0x6a/0x70
Dec 16 17:30:43 alon1 [<c01e007b>] pci_size+0x1b/0xb0
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c01f2cef>] tty_set_ldisc+0x2cf/0x420
Dec 16 17:30:43 alon1 [<c01eb84f>] tty_wakeup+0x2f/0x70
Dec 16 17:30:43 alon1 [<c012ff10>] autoremove_wake_function+0x0/0x50
Dec 16 17:30:43 alon1 [<c01ee77d>] tty_ioctl+0x3ed/0x840
Dec 16 17:30:43 alon1 [<c0184776>] do_unlinkat+0x46/0x150
Dec 16 17:30:43 alon1 [<c01ee390>] tty_ioctl+0x0/0x840
Dec 16 17:30:43 alon1 [<c01865bb>] vfs_ioctl+0x2b/0x90
Dec 16 17:30:43 alon1 [<c018667c>] do_vfs_ioctl+0x5c/0x2a0
Dec 16 17:30:43 alon1 [<c014d97d>] audit_syscall_exit+0x2cd/0x350
Dec 16 17:30:43 alon1 [<c0186928>] sys_ioctl+0x68/0x80
Dec 16 17:30:43 alon1 [<c0103129>] sysenter_do_call+0x12/0x21
Dec 16 17:30:43 alon1 =======================
Dec 16 17:30:43 alon1 BUG: scheduling while atomic: pppd/19700/0x10000002
Dec 16 17:30:43 alon1 Modules linked in: vfat fat isofs ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async radeon drm autofs4 aes_generic crypto_algapi ieee80211_crypt_ccmp bridge stp llc nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp xt_state ipt_LOG xt_limit nf_conntrack_ipv4 nf_conntrack rfcomm l2cap iptable_filter ip_tables x_tables snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base rtc_cmos rtc_core rtc_lib hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec thinkpad_acpi nsc_ircc ac97_bus rfkill ipw2200 snd_pcm irda hwmon yenta_socket snd_timer ehci_hcd ieee80211 snd led_class rsrc_nonstatic thermal uhci_hcd sr_mod e1000 intel_agp pcmcia_core crc_ccitt nvram soundcore battery processor ieee80211_crypt i2c_i801 psmouse agpgart ac cdrom snd_page_alloc button pcspkr sg usbcore unix evdev ext3 jbd ext2 mbcache loop ata_piix libata dock sd_mod scsi_mod [last unloaded: uhci_hcd]
Dec 16 17:30:43 alon1 Pid: 19700, comm: pppd Tainted: G      D   2.6.27-gentoo-r4 #1
Dec 16 17:30:43 alon1 [<c02cf41a>] schedule+0x29a/0x310
Dec 16 17:30:43 alon1 [<c0118cf3>] __cond_resched+0x13/0x30
Dec 16 17:30:43 alon1 [<c02cf877>] _cond_resched+0x27/0x30
Dec 16 17:30:43 alon1 [<c028546f>] rt_cache_flush+0xaf/0xc0
Dec 16 17:30:43 alon1 [<c02b5582>] fib_disable_ip+0x22/0x30
Dec 16 17:30:43 alon1 [<c02b5bbc>] fib_netdev_event+0x9c/0xa0
Dec 16 17:30:43 alon1 [<c01343ec>] notifier_call_chain+0x3c/0x80
Dec 16 17:30:43 alon1 [<c0134477>] raw_notifier_call_chain+0x17/0x20
Dec 16 17:30:43 alon1 [<c0271ac9>] rollback_registered+0x89/0x100
Dec 16 17:30:43 alon1 [<c018e447>] destroy_inode+0x27/0x40
Dec 16 17:30:43 alon1 [<f9a776f7>] ppp_release+0x57/0x60 [ppp_generic]
Dec 16 17:30:43 alon1 [<c0271b56>] unregister_netdevice+0x16/0x70
Dec 16 17:30:43 alon1 [<c0271bbf>] unregister_netdev+0xf/0x20
Dec 16 17:30:43 alon1 [<f9a772df>] ppp_shutdown_interface+0x5f/0xb0 [ppp_generic]
Dec 16 17:30:43 alon1 [<f9a776dc>] ppp_release+0x3c/0x60 [ppp_generic]
Dec 16 17:30:43 alon1 [<c017b011>] __fput+0x91/0x190
Dec 16 17:30:43 alon1 [<c01780b7>] filp_close+0x47/0x80
Dec 16 17:30:43 alon1 [<c011ea60>] put_files_struct+0xa0/0xb0
Dec 16 17:30:43 alon1 [<c011ffc8>] do_exit+0x128/0x820
Dec 16 17:30:43 alon1 [<c011de4b>] printk+0x1b/0x20
Dec 16 17:30:43 alon1 [<c0104028>] oops_end+0x88/0x90
Dec 16 17:30:43 alon1 [<c0104830>] do_invalid_op+0x0/0x90
Dec 16 17:30:43 alon1 [<c01048b3>] do_invalid_op+0x83/0x90
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c015ac7a>] __alloc_pages_internal+0x9a/0x430
Dec 16 17:30:43 alon1 [<c02d0e22>] error_code+0x6a/0x70
Dec 16 17:30:43 alon1 [<c01e007b>] pci_size+0x1b/0xb0
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c01f2cef>] tty_set_ldisc+0x2cf/0x420
Dec 16 17:30:43 alon1 [<c01eb84f>] tty_wakeup+0x2f/0x70
Dec 16 17:30:43 alon1 [<c012ff10>] autoremove_wake_function+0x0/0x50
Dec 16 17:30:43 alon1 [<c01ee77d>] tty_ioctl+0x3ed/0x840
Dec 16 17:30:43 alon1 [<c0184776>] do_unlinkat+0x46/0x150
Dec 16 17:30:43 alon1 [<c01ee390>] tty_ioctl+0x0/0x840
Dec 16 17:30:43 alon1 [<c01865bb>] vfs_ioctl+0x2b/0x90
Dec 16 17:30:43 alon1 [<c018667c>] do_vfs_ioctl+0x5c/0x2a0
Dec 16 17:30:43 alon1 [<c014d97d>] audit_syscall_exit+0x2cd/0x350
Dec 16 17:30:43 alon1 [<c0186928>] sys_ioctl+0x68/0x80
Dec 16 17:30:43 alon1 [<c0103129>] sysenter_do_call+0x12/0x21
Dec 16 17:30:43 alon1 =======================
Dec 16 17:30:43 alon1 BUG: scheduling while atomic: pppd/19700/0x00000002
Dec 16 17:30:43 alon1 Modules linked in: vfat fat isofs ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async radeon drm autofs4 aes_generic crypto_algapi ieee80211_crypt_ccmp bridge stp llc nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp xt_state ipt_LOG xt_limit nf_conntrack_ipv4 nf_conntrack rfcomm l2cap iptable_filter ip_tables x_tables snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base rtc_cmos rtc_core rtc_lib hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec thinkpad_acpi nsc_ircc ac97_bus rfkill ipw2200 snd_pcm irda hwmon yenta_socket snd_timer ehci_hcd ieee80211 snd led_class rsrc_nonstatic thermal uhci_hcd sr_mod e1000 intel_agp pcmcia_core crc_ccitt nvram soundcore battery processor ieee80211_crypt i2c_i801 psmouse agpgart ac cdrom snd_page_alloc button pcspkr sg usbcore unix evdev ext3 jbd ext2 mbcache loop ata_piix libata dock sd_mod scsi_mod [last unloaded: uhci_hcd]
Dec 16 17:30:43 alon1 Pid: 19700, comm: pppd Tainted: G      D   2.6.27-gentoo-r4 #1
Dec 16 17:30:43 alon1 [<c02cf41a>] schedule+0x29a/0x310
Dec 16 17:30:43 alon1 [<c01b9f51>] release_sysfs_dirent+0x41/0xa0
Dec 16 17:30:43 alon1 [<c01b9f51>] release_sysfs_dirent+0x41/0xa0
Dec 16 17:30:43 alon1 [<c02cf965>] schedule_timeout+0x75/0xc0
Dec 16 17:30:43 alon1 [<c01ba182>] sysfs_addrm_finish+0x1d2/0x200
Dec 16 17:30:43 alon1 [<c01ba1d7>] remove_dir+0x27/0x40
Dec 16 17:30:43 alon1 [<c02cf6d8>] wait_for_common+0xa8/0x170
Dec 16 17:30:43 alon1 [<c0119d60>] default_wake_function+0x0/0x10
Dec 16 17:30:43 alon1 [<c012db68>] synchronize_rcu+0x28/0x30
Dec 16 17:30:43 alon1 [<c012db90>] wakeme_after_rcu+0x0/0x10
Dec 16 17:30:43 alon1 [<c0271af4>] rollback_registered+0xb4/0x100
Dec 16 17:30:43 alon1 [<c018e447>] destroy_inode+0x27/0x40
Dec 16 17:30:43 alon1 [<f9a776f7>] ppp_release+0x57/0x60 [ppp_generic]
Dec 16 17:30:43 alon1 [<c0271b56>] unregister_netdevice+0x16/0x70
Dec 16 17:30:43 alon1 [<c0271bbf>] unregister_netdev+0xf/0x20
Dec 16 17:30:43 alon1 [<f9a772df>] ppp_shutdown_interface+0x5f/0xb0 [ppp_generic]
Dec 16 17:30:43 alon1 [<f9a776dc>] ppp_release+0x3c/0x60 [ppp_generic]
Dec 16 17:30:43 alon1 [<c017b011>] __fput+0x91/0x190
Dec 16 17:30:43 alon1 [<c01780b7>] filp_close+0x47/0x80
Dec 16 17:30:43 alon1 [<c011ea60>] put_files_struct+0xa0/0xb0
Dec 16 17:30:43 alon1 [<c011ffc8>] do_exit+0x128/0x820
Dec 16 17:30:43 alon1 [<c011de4b>] printk+0x1b/0x20
Dec 16 17:30:43 alon1 [<c0104028>] oops_end+0x88/0x90
Dec 16 17:30:43 alon1 [<c0104830>] do_invalid_op+0x0/0x90
Dec 16 17:30:43 alon1 [<c01048b3>] do_invalid_op+0x83/0x90
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c015ac7a>] __alloc_pages_internal+0x9a/0x430
Dec 16 17:30:43 alon1 [<c02d0e22>] error_code+0x6a/0x70
Dec 16 17:30:43 alon1 [<c01e007b>] pci_size+0x1b/0xb0
Dec 16 17:30:43 alon1 [<c01f253e>] tty_ldisc_put+0x4e/0x60
Dec 16 17:30:43 alon1 [<c01f2cef>] tty_set_ldisc+0x2cf/0x420
Dec 16 17:30:43 alon1 [<c01eb84f>] tty_wakeup+0x2f/0x70
Dec 16 17:30:43 alon1 [<c012ff10>] autoremove_wake_function+0x0/0x50
Dec 16 17:30:43 alon1 [<c01ee77d>] tty_ioctl+0x3ed/0x840
Dec 16 17:30:43 alon1 [<c0184776>] do_unlinkat+0x46/0x150
Dec 16 17:30:43 alon1 [<c01ee390>] tty_ioctl+0x0/0x840
Dec 16 17:30:43 alon1 [<c01865bb>] vfs_ioctl+0x2b/0x90
Dec 16 17:30:43 alon1 [<c018667c>] do_vfs_ioctl+0x5c/0x2a0
Dec 16 17:30:43 alon1 [<c014d97d>] audit_syscall_exit+0x2cd/0x350
Dec 16 17:30:43 alon1 [<c0186928>] sys_ioctl+0x68/0x80
Dec 16 17:30:43 alon1 [<c0103129>] sysenter_do_call+0x12/0x21
Dec 16 17:30:43 alon1 =======================
