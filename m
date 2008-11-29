Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYK2A1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYK2A1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 19:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYK2A1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 19:27:44 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:3406 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYK2A1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 19:27:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Y677wsjZZ3UjLO7IRjCW6t1AxoXn5hD//KNqeAwVLIox6vO4/azumBUJJy6TaV2NGC
         ocVBzD9+vNyGhyhTSzaq8PNz0gb37UofaN/0VGhjGQc5t/TtnnIC0ymnG98b+5gSoggf
         Ye2fsNt8u9xuNPl0qCzdWclE2Lsk6JJ6Zv1kA=
Subject: warning at usb-serial.c (2.6.27.7)
From: satish <eerpini@gmail.com>
Reply-To: eerpini@gmail.com
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 29 Nov 2008 05:57:11 +0530
Message-Id: <1227918431.2915.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following error often when i use my ZTE AC8700 USB modem. It
usually shows up when the pppd dies or when the modem is not able to
connect because of some other problem , ...... is this any serious ??

WARNING: at drivers/usb/serial/usb-serial.c:324 serial_write_room
+0x47/0x5b [usbserial]()
Modules linked in: ppp_async crc_ccitt ppp_generic slhc fuse rfcomm
l2cap ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT
xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter
ip6_tables x_tables cpufreq_ondemand acpi_cpufreq dm_multipath i915 drm
ipv6 snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
arc4 ecb snd_seq_device iwl3945 snd_pcm_oss sr_mod snd_mixer_oss cdrom
mac80211 snd_pcm b44 ppdev pata_acpi firewire_ohci usb_storage ssb
snd_timer ata_generic firewire_core serio_raw joydev snd_page_alloc
iTCO_wdt parport_pc pcspkr ata_piix mii snd_hwdep option
iTCO_vendor_support sg crc_itu_t parport snd video usbserial output
hci_usb wmi battery cfg80211 soundcore ac button bluetooth ahci libata
sd_mod scsi_mod sha256_generic cbc aes_i586 aes_generic dm_crypt
crypto_blkcipher dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd
mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G        W 2.6.27.7 #1
 [<c0637b24>] ? printk+0xf/0x13
 [<c0429968>] warn_on_slowpath+0x41/0x65
 [<c0433500>] ? complete_signal+0x17a/0x18c
 [<c04338c6>] ? __group_send_sig_info+0xa/0xc
 [<c0433ead>] ? group_send_sig_info+0x53/0x5c
 [<c048fc6c>] ? send_sigio+0x134/0x190
 [<c05829b7>] ? usb_submit_urb+0x1e1/0x1fd
 [<f8d724fc>] ? option_write+0x11c/0x1a1 [option]
 [<f8c5d468>] serial_write_room+0x47/0x5b [usbserial]
 [<c054f22f>] tty_write_room+0x18/0x1a
 [<c054d40b>] opost+0x14/0x1bb
 [<c054ec93>] n_tty_receive_buf+0xb2c/0xfe1
 [<c041e97d>] ? __enqueue_entity+0xe3/0xeb
 [<c04203e7>] ? enqueue_entity+0x203/0x20b
 [<c042042a>] ? enqueue_task_fair+0x3b/0x3f
 [<c041c534>] ? enqueue_task+0x4c/0x58
 [<c041ba86>] ? resched_task+0x20/0x64
 [<c054fef6>] ? tty_ldisc_try+0x2d/0x33
 [<c054a63d>] flush_to_ldisc+0xf1/0x17c
 [<c054a709>] tty_flip_buffer_push+0x41/0x51
 [<f8d72b86>] option_indat_callback+0x92/0xe8 [option]
 [<c05813e5>] usb_hcd_giveback_urb+0x63/0x93
 [<f886c6bd>] uhci_giveback_urb+0xe7/0x15e [uhci_hcd]
 [<f886cee9>] uhci_scan_schedule+0x52e/0x767 [uhci_hcd]
 [<f886e98c>] uhci_irq+0x110/0x125 [uhci_hcd]
 [<c058104e>] usb_hcd_irq+0x3a/0x7c
 [<c045cd70>] handle_IRQ_event+0x2a/0x5a
 [<c045dd84>] handle_fasteoi_irq+0x85/0xc0
 [<c045dcff>] ? handle_fasteoi_irq+0x0/0xc0
 [<c04059db>] do_IRQ+0x9a/0xc4
 [<c040446f>] common_interrupt+0x23/0x28
 [<c05400e5>] ? acpi_idle_enter_simple+0x1ba/0x231
 [<c05acffe>] ? menu_select+0x38/0x86
 [<c05ac21a>] cpuidle_idle_call+0x62/0x92
 [<c0402ab5>] cpu_idle+0xe8/0x10b
 [<c0629c96>] rest_init+0x4e/0x50
 =======================
---[ end trace f067aa1dcef227bb ]---

if it would help , lsusb for my modem gives the following :

Bus 004 Device 002: ID 05c6:6000 Qualcomm, Inc. 

Thanks
Satish
-- 
http://satish.playdrupal.com

