Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYBPVuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYBPVuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 16:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbYBPVuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 16:50:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:56997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYBPVuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 16:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ArSOIwjerPV2ZQWL+9LCHsUBkySczN1N1v+TpBXXPlHhhFK2nneR5Jq5NoGcaxQpoBvCKUVdDILeFpf5svT4WTEUOFZLPIUOxJ3Nyz6F+ZJizI4PMe3b+mUW7gc1PzAWELM3180Eu+9mUM8NCcFJsDCoXBwmTznPISorWwsg5JI=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [BUG] rfcomm
Date: Sat, 16 Feb 2008 23:49:58 +0200
User-Agent: KMail/1.9.7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       marcel@holtmann.org, bluez-devel@lists.sourceforge.net
References: <200710231950.31313.alon.barlev@gmail.com> <a8e1da0802141928yabfd87ajfed0b009e1e79018@mail.gmail.com> <a8e1da0802151513p34ad118i54ddd8f00e6e136@mail.gmail.com>
In-Reply-To: <a8e1da0802151513p34ad118i54ddd8f00e6e136@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802162349.59780.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008, Dave Young wrote:
> Hi, alon
> 
> Please try the attached patch, hope it fixes your problem.
> 
> Regards
> dave

Does not work... :(

Alon.

Feb 16 23:41:33 alon1 usb 3-1: configuration #1 chosen from 1 choice
Feb 16 23:41:33 alon1 BUG: unable to handle kernel NULL pointer dereference at virtual address 00000008
Feb 16 23:41:33 alon1 printing eip: c01b2db6 *pde = 00000000 
Feb 16 23:41:33 alon1 Oops: 0000 [#1] PREEMPT 
Feb 16 23:41:33 alon1 Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async rfcomm l2cap hci_usb vmnet(P) vmmon(P) tun radeon drm autofs4 ipv6 aes_generic crypto_algapi ieee80211_crypt_ccmp nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp ipt_LOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device bluetooth ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm nsc_ircc snd_timer ipw2200 thinkpad_acpi irda snd ehci_hcd yenta_socket uhci_hcd psmouse ieee80211 soundcore intel_agp hwmon rsrc_nonstatic pcspkr e1000 crc_ccitt snd_page_alloc i2c_i801 ieee80211_crypt pcmcia_core agpgart thermal battery nvram rtc sr_mod ac sg firmware_class button processor cdrom unix usbcore evdev ext3 jbd ext2 mbcache loop ata_piix libata sd_mod scsi_mod
Feb 16 23:41:33 alon1 
Feb 16 23:41:33 alon1 Pid: 4, comm: events/0 Tainted: P        (2.6.24-gentoo-r2 #1)
Feb 16 23:41:33 alon1 EIP: 0060:[<c01b2db6>] EFLAGS: 00010282 CPU: 0
Feb 16 23:41:33 alon1 EIP is at sysfs_get_dentry+0x26/0x80
Feb 16 23:41:33 alon1 EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: f48a2210
Feb 16 23:41:33 alon1 ESI: f72eb900 EDI: f4803ae0 EBP: f4803ae0 ESP: f7c49efc
Feb 16 23:41:33 alon1 hcid[7004]: HCI dev 0 registered
Feb 16 23:41:33 alon1 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Feb 16 23:41:33 alon1 Process events/0 (pid: 4, ti=f7c48000 task=f7c3efc0 task.ti=f7c48000)
Feb 16 23:41:33 alon1 Stack: f7cb6140 f4822668 f7e71e10 c01b304d ffffffff ffffffff fffffffe c030ba9c 
Feb 16 23:41:33 alon1 f7cb6140 f4822668 f6da6720 f7cb6140 f4822668 f6da6720 c030ba8e c01ce20b 
Feb 16 23:41:33 alon1 f6e9dd00 c030ba8e f6da6720 f6e9dd00 f6e9dd00 00000000 f4822600 00000000 
Feb 16 23:41:33 alon1 Call Trace:
Feb 16 23:41:33 alon1 [<c01b304d>] sysfs_move_dir+0x3d/0x1f0
Feb 16 23:41:33 alon1 [<c01ce20b>] kobject_move+0x9b/0x120
Feb 16 23:41:33 alon1 [<c0241711>] device_move+0x51/0x110
Feb 16 23:41:33 alon1 [<f9aaed80>] del_conn+0x0/0x70 [bluetooth]
Feb 16 23:41:33 alon1 [<f9aaed99>] del_conn+0x19/0x70 [bluetooth]
Feb 16 23:41:33 alon1 [<c012c1a1>] run_workqueue+0x81/0x140
Feb 16 23:41:33 alon1 [<c02c0c88>] schedule+0x168/0x2e0
Feb 16 23:41:33 alon1 [<c012fc70>] autoremove_wake_function+0x0/0x50
Feb 16 23:41:33 alon1 [<c012c9cb>] worker_thread+0x9b/0xf0
Feb 16 23:41:33 alon1 [<c012fc70>] autoremove_wake_function+0x0/0x50
Feb 16 23:41:33 alon1 [<c012c930>] worker_thread+0x0/0xf0
Feb 16 23:41:33 alon1 [<c012f962>] kthread+0x42/0x70
Feb 16 23:41:33 alon1 [<c012f920>] kthread+0x0/0x70
Feb 16 23:41:33 alon1 [<c0104c2f>] kernel_thread_helper+0x7/0x18
Feb 16 23:41:33 alon1 =======================
Feb 16 23:41:33 alon1 Code: 26 00 00 00 00 57 89 c7 a1 50 1b 3a c0 56 53 8b 70 38 85 f6 74 08 8b 0e 85 c9 74 58 ff 06 8b 56 50 39 fa 74 47 89 fb eb 02 89 c3 <8b> 43 08 39 c2 75 f7 8b 46 08 83 c0 68 e8 98 e7 10 00 8b 43 10 
Feb 16 23:41:33 alon1 EIP: [<c01b2db6>] sysfs_get_dentry+0x26/0x80 SS:ESP 0068:f7c49efc
Feb 16 23:41:33 alon1 ---[ end trace aae864e9592acc1d ]---
Feb 16 23:41:33 alon1 hcid[7004]: HCI dev 0 up
Feb 16 23:41:33 alon1 hcid[7004]: Device hci0 has been added
Feb 16 23:41:33 alon1 hcid[7004]: Starting security manager 0
