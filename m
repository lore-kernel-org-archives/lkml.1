Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbYBOD2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbYBOD2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbYBOD2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:28:22 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:21929 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbYBOD2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:28:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J9LqvOFE8dR2jAmgJFVyRQkqJmY5lurGUQKc0aaaTBmYijx9O+IrLqa68Qw8CeRfc09LgzfZ9uBRQHZlpmbWYN2x9QRsB7cveWlVn5DqV89MJHl9Kp9AvOb6mvfTaKa/pNkmHmWGxhJmB3ytZVQbr9QmEGL3t2yc/gd4kFLym8M=
Message-ID: <a8e1da0802141928yabfd87ajfed0b009e1e79018@mail.gmail.com>
Date: Fri, 15 Feb 2008 11:28:20 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] rfcomm
Cc: "Alon Bar-Lev" <alon.barlev@gmail.com>, linux-kernel@vger.kernel.org,
       marcel@holtmann.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <20080212235814.b4a2e565.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710231950.31313.alon.barlev@gmail.com>
	 <a8e1da0711051849ma591d4k6a816e2de7390347@mail.gmail.com>
	 <9e0cf0bf0711052149t5c9fe50j19d13e368690efb@mail.gmail.com>
	 <200802111757.56537.alon.barlev@gmail.com>
	 <20080212235814.b4a2e565.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 3:58 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 11 Feb 2008 17:57:54 +0200 Alon Bar-Lev <alon.barlev@gmail.com> wrote:
>
>  > On Tuesday 06 November 2007, Alon Bar-Lev wrote:
>  > > On 11/6/07, Dave Young <hidave.darkstar@gmail.com> wrote:
>  > > > Hi,
>  > > > sorry for reply again, this seems a diffrent issue ...
>  > >
>  > > All that I do is running pppd over the rfcomm, suspending the system and resume.
>  > > I don't load any binary module.
>  > >
>  > > Alon.
>  > >
>  >
>  > Tried 2.6.24.1...
>  > PLEASE fix this.
>  > Thanks!
>  >
>  > ---
>  >
>  > Feb 11 17:46:05 alon1 Restarting tasks ... <6>usb 2-1: USB disconnect, address 10
>  > Feb 11 17:46:05 alon1 done.
>  > Feb 11 17:46:05 alon1 usb 3-1: USB disconnect, address 7
>  > Feb 11 17:46:05 alon1 usb 3-2: USB disconnect, address 6
>  > Feb 11 17:46:05 alon1 usb 3-1: new full speed USB device using uhci_hcd and address 8
>  > Feb 11 17:46:05 alon1 usb 3-1: configuration #1 chosen from 1 choice
>  > Feb 11 17:46:05 alon1 BUG: unable to handle kernel NULL pointer dereference at virtual address 00000008
>  > Feb 11 17:46:05 alon1 printing eip: c01b2da6 *pde = 00000000
>  > Feb 11 17:46:05 alon1 Oops: 0000 [#1] PREEMPT
>  > Feb 11 17:46:05 alon1 Modules linked in: aes_generic crypto_algapi ieee80211_crypt_ccmp ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async thinkpad_acpi hwmon nvram vmnet(P) vmmon(P) tun radeon drm autofs4 ipv6 nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp ipt_LOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables rfcomm l2cap snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm ipw2200 nsc_ircc snd_timer irda ieee80211 snd psmouse yenta_socket ehci_hcd pcspkr ieee80211_crypt e1000 rsrc_nonstatic uhci_hcd soundcore i2c_i801 intel_agp crc_ccitt thermal sr_mod pcmcia_core snd_page_al!
>   lo!
>
>
> >  c battery rtc firmware_class agpgart ac processor cdrom sg button unix usbcore evdev ext3 jbd ext2 mbcache loop ata_piix libata sd_mod scsi_mod
>  > Feb 11 17:46:05 alon1
>  > Feb 11 17:46:05 alon1 Pid: 4, comm: events/0 Tainted: P        (2.6.24-gentoo-r1 #1)
>  > Feb 11 17:46:05 alon1 EIP: 0060:[<c01b2da6>] EFLAGS: 00010286 CPU: 0
>  > Feb 11 17:46:05 alon1 EIP is at sysfs_get_dentry+0x26/0x80
>  > Feb 11 17:46:05 alon1 EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: ebf21000
>  > Feb 11 17:46:05 alon1 ESI: eab4e880 EDI: f713bb40 EBP: f713bb40 ESP: f7c49f00
>  > Feb 11 17:46:05 alon1 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>  > Feb 11 17:46:05 alon1 Process events/0 (pid: 4, ti=f7c48000 task=f7c3efc0 task.ti=f7c48000)
>  > Feb 11 17:46:05 alon1 Stack: f7c97120 f7135a68 f7e71e10 c01b303d ffffffff ffffffff fffffffe c030ba9c
>  > Feb 11 17:46:05 alon1 f7c97120 f7135a68 f2fefb40 f7c97120 f7135a68 f2fefb40 c030ba8e c01ce1fb
>  > Feb 11 17:46:05 alon1 f75f1b00 c030ba8e f2fefb40 f75f1b00 f75f1b00 00000000 f7135a00 00000000
>  > Feb 11 17:46:05 alon1 Call Trace:
>  > Feb 11 17:46:05 alon1 [<c01b303d>] sysfs_move_dir+0x3d/0x1f0
>  > Feb 11 17:46:05 alon1 [<c01ce1fb>] kobject_move+0x9b/0x120
>  > Feb 11 17:46:05 alon1 [<c0241701>] device_move+0x51/0x110
>  > Feb 11 17:46:05 alon1 [<f9a8adb0>] del_conn+0x0/0x40 [bluetooth]
>  > Feb 11 17:46:05 alon1 [<f9a8adc0>] del_conn+0x10/0x40 [bluetooth]
>  > Feb 11 17:46:05 alon1 [<c012c1a1>] run_workqueue+0x81/0x140
>  > Feb 11 17:46:05 alon1 [<c02c0c78>] schedule+0x168/0x2e0
>  > Feb 11 17:46:05 alon1 [<c012fc70>] autoremove_wake_function+0x0/0x50
>  > Feb 11 17:46:05 alon1 [<c012c9cb>] worker_thread+0x9b/0xf0
>  > Feb 11 17:46:05 alon1 [<c012fc70>] autoremove_wake_function+0x0/0x50
>  > Feb 11 17:46:05 alon1 [<c012c930>] worker_thread+0x0/0xf0
>  > Feb 11 17:46:05 alon1 [<c012f962>] kthread+0x42/0x70
>  > Feb 11 17:46:05 alon1 [<c012f920>] kthread+0x0/0x70
>  > Feb 11 17:46:05 alon1 [<c0104c2f>] kernel_thread_helper+0x7/0x18
>  > Feb 11 17:46:05 alon1 =======================
>  > Feb 11 17:46:05 alon1 Code: 26 00 00 00 00 57 89 c7 a1 50 1b 3a c0 56 53 8b 70 38 85 f6 74 08 8b 0e 85 c9 74 58 ff 06 8b 56 50 39 fa 74 47 89 fb eb 02 89 c3 <8b> 43 08 39 c2 75 f7 8b 46 08 83 c0 68 e8 98 e7 10 00 8b 43 10
>  > Feb 11 17:46:05 alon1 EIP: [<c01b2da6>] sysfs_get_dentry+0x26/0x80 SS:ESP 0068:f7c49f00
>
>  A number of bluetooth fixes went into 2.6.25-rc1.  It would be interestig
>  to see if we fixed this.
>
>

Seems there's some bugs about suspend/resume bluetooth devices.
I cannot produce the above bug, but my bluetooth dongle does'nt work
as normal  when I tying s2ram

Another similar report:
http://lkml.org/lkml/2008/2/13/701

Regards
dave
