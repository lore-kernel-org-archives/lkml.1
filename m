Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYBKWtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYBKWtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbYBKWtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:49:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:2256 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYBKWte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:49:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:sender;
        b=Ji0BOBDaxHjFARmq1j7QRAaOXATRo4DnYvoF+/jOMYqHDP28rOU14RDF/OdnmaKKfq3HO39XW8314QMy84M24gXgRQyV4b7fq+XaEl1h6e7BPQPvXObIoFniw/+7+mSPSh3azP9Y3G/Fd+YGk5GR5e3c+XZP/bb/DZH/DMzV2kc=
Date: Mon, 11 Feb 2008 23:48:12 +0100
From: Frederik Deweerdt <deweerdt@free.fr>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       marcel@holtmann.org, bluez-devel@lists.sourceforge.net
Subject: Re: [BUG] rfcomm
Message-ID: <20080211224812.GA30068@slug>
References: <200710231950.31313.alon.barlev@gmail.com> <a8e1da0711051849ma591d4k6a816e2de7390347@mail.gmail.com> <9e0cf0bf0711052149t5c9fe50j19d13e368690efb@mail.gmail.com> <200802111757.56537.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200802111757.56537.alon.barlev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alon,

On Mon, Feb 11, 2008 at 05:57:54PM +0200, Alon Bar-Lev wrote:
[...]
> Feb 11 17:46:05 alon1 BUG: unable to handle kernel NULL pointer dereference at virtual address 00000008
> Feb 11 17:46:05 alon1 printing eip: c01b2da6 *pde = 00000000 
> Feb 11 17:46:05 alon1 Oops: 0000 [#1] PREEMPT 
> Feb 11 17:46:05 alon1 Modules linked in: aes_generic crypto_algapi ieee80211_crypt_ccmp ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async thinkpad_acpi hwmon nvram vmnet(P) vmmon(P) tun radeon drm autofs4 ipv6 nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp ipt_LOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables rfcomm l2cap snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm ipw2200 nsc_ircc snd_timer irda ieee80211 snd psmouse yenta_socket ehci_hcd pcspkr ieee80211_crypt e1000 rsrc_nonstatic uhci_hcd soundcore i2c_i801 intel_agp crc_ccitt thermal sr_mod pcmcia_core snd_page_alloc battery rtc firmware_class agpgart ac processor cdrom sg button unix usbcore evdev ext3 jbd ext2 mbcache loop ata_piix libata sd_mod scsi_mod
> Feb 11 17:46:05 alon1 
> Feb 11 17:46:05 alon1 Pid: 4, comm: events/0 Tainted: P        (2.6.24-gentoo-r1 #1)
> Feb 11 17:46:05 alon1 EIP: 0060:[<c01b2da6>] EFLAGS: 00010286 CPU: 0
> Feb 11 17:46:05 alon1 EIP is at sysfs_get_dentry+0x26/0x80
> Feb 11 17:46:05 alon1 EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: ebf21000
> Feb 11 17:46:05 alon1 ESI: eab4e880 EDI: f713bb40 EBP: f713bb40 ESP: f7c49f00
> Feb 11 17:46:05 alon1 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Feb 11 17:46:05 alon1 Process events/0 (pid: 4, ti=f7c48000 task=f7c3efc0 task.ti=f7c48000)
> Feb 11 17:46:05 alon1 Stack: f7c97120 f7135a68 f7e71e10 c01b303d ffffffff ffffffff fffffffe c030ba9c 
> Feb 11 17:46:05 alon1 f7c97120 f7135a68 f2fefb40 f7c97120 f7135a68 f2fefb40 c030ba8e c01ce1fb 
> Feb 11 17:46:05 alon1 f75f1b00 c030ba8e f2fefb40 f75f1b00 f75f1b00 00000000 f7135a00 00000000 
> Feb 11 17:46:05 alon1 Call Trace:
> Feb 11 17:46:05 alon1 [<c01b303d>] sysfs_move_dir+0x3d/0x1f0
> Feb 11 17:46:05 alon1 [<c01ce1fb>] kobject_move+0x9b/0x120
> Feb 11 17:46:05 alon1 [<c0241701>] device_move+0x51/0x110
> Feb 11 17:46:05 alon1 [<f9a8adb0>] del_conn+0x0/0x40 [bluetooth]
> Feb 11 17:46:05 alon1 [<f9a8adc0>] del_conn+0x10/0x40 [bluetooth]
> Feb 11 17:46:05 alon1 [<c012c1a1>] run_workqueue+0x81/0x140
> Feb 11 17:46:05 alon1 [<c02c0c78>] schedule+0x168/0x2e0
> Feb 11 17:46:05 alon1 [<c012fc70>] autoremove_wake_function+0x0/0x50
> Feb 11 17:46:05 alon1 [<c012c9cb>] worker_thread+0x9b/0xf0
> Feb 11 17:46:05 alon1 [<c012fc70>] autoremove_wake_function+0x0/0x50
> Feb 11 17:46:05 alon1 [<c012c930>] worker_thread+0x0/0xf0
> Feb 11 17:46:05 alon1 [<c012f962>] kthread+0x42/0x70
> Feb 11 17:46:05 alon1 [<c012f920>] kthread+0x0/0x70
> Feb 11 17:46:05 alon1 [<c0104c2f>] kernel_thread_helper+0x7/0x18
> Feb 11 17:46:05 alon1 =======================
> Feb 11 17:46:05 alon1 Code: 26 00 00 00 00 57 89 c7 a1 50 1b 3a c0 56 53 8b 70 38 85 f6 74 08 8b 0e 85 c9 74 58 ff 06 8b 56 50 39 fa 74 47 89 fb eb 02 89 c3 <8b> 43 08 39 c2 75 f7 8b 46 08 83 c0 68 e8 98 e7 10 00 8b 43 10 
> Feb 11 17:46:05 alon1 EIP: [<c01b2da6>] sysfs_get_dentry+0x26/0x80 SS:ESP 0068:f7c49f00

If your compiler doesn't produce a code too different from mine, it
looks like cur in sysfs_get_dentry()...

	while (cur->s_parent != dentry->d_fsdata)
		cur = cur->s_parent;

... got NULL and dereferenced. Could you try the following (merely
tested by booting) patch? While not a fix, it could help pointing to
the right direction.

Regards,
Frederik


diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4948d9b..90cdf0d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -106,8 +106,11 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 
 		/* find the first ancestor which hasn't been looked up */
 		cur = sd;
-		while (cur->s_parent != dentry->d_fsdata)
+		while (cur->s_parent != dentry->d_fsdata) {
 			cur = cur->s_parent;
+			if (!cur)
+				return ERR_PTR(-ENOENT);
+		}
 
 		/* look it up */
 		parent = dentry;
