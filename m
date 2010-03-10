Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab0CJSLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:11:42 -0500
Received: from web113315.mail.gq1.yahoo.com ([98.136.167.15]:39341 "HELO
	web113315.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932603Ab0CJSLl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:11:41 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 13:11:41 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=fJRCowcYXe8atgWUI/4aUi+qd0k4CLo3CUPn8w9uBilJXPYZvua2F6uhA7JO3YqxOoB/vf7MRsW79CU53as+/gMFe8756DRB5m6bvea3XZXQocAljL+FM0lJ0C22o6z3/tR2FgEAv6n5+UXq26d7y8xTo0aRUDizJzEmmijjK7c=;
Message-ID: <382850.23128.qm@web113315.mail.gq1.yahoo.com>
X-YMail-OSG: y_gLlVEVM1kD5ADOJQtVDplgSMO71YE1bKEf1HXbUNOmvu6
 8G9NkUYmiqFUjhPrFXeQnF8EwH8XJYsbsjhLpo597MIV_a8PmVsn87MUO.j1
 ZOIEoVeTStj8z0vl4mZmBXVFBG0K1giYBxEcFiNR5YMfxCkQb_1HHUfCSZ0j
 uSqxa1jeja6tRxOEkvfeCFa7Mxuwrgq5Qb9QEsDaAoAV74qMMdUJTi8NWZkF
 cTIbUtX_4mh6ARM9T11SNJmzqPX_SHieCcvhVrggoLzqlxcO2mIJdvFUeDUP
 l_m_kW45AOXZYovtWabvateQlNPLYh6kl3A1R
X-Mailer: YahooMailRC/300.3 YahooMailWebService/0.8.100.260964
Date: Wed, 10 Mar 2010 10:05:00 -0800 (PST)
From: Darwin Te <darwin_te1@yahoo.com>
Subject: =?utf-8?B?S2VybmVsIG1lbW9yeSBsZWFrIHdhcm5pbmcgZHVlIHRvIEtERUQ04oCP?=
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not subscribed.  CC'ed me.

OS:  Kubuntu Karmic, Linux cube 2.6.31-20-generic-pae #57-Ubuntu SMP Mon Feb 8 10:23:59 UTC 2010 i686 GNU/Linux

Kernel should not memory leak whatever happens to kded4.

[519658.792531] ------------[ cut here ]------------
[519658.792545] WARNING: at /build/buildd/linux-2.6.31/fs/notify/inotify/inotify_fsnotify.c:129 idr_callback+0x4f/0x80()
[519658.792548] Hardware name: System Product Name
[519658.792551] inotify closing but id=0 for entry=d99d96c0 in group=de00e400 still in idr.  Probably leaking memory
[519658.792554] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs vmnet parport_pc vmblock vsock vmci vmmon binfmt_misc vboxnetadp vboxnetflt vboxdrv ppdev snd_hda_codec_analog snd_usb_audio snd_usb_lib snd_seq_dummy snd_seq_oss snd_hda_intel snd_seq_midi snd_hda_codec snd_rawmidi snd_hwdep snd_seq_midi_event snd_pcm_oss snd_mixer_oss iptable_filter snd_seq snd_pcm ip_tables snd_timer snd_seq_device snd_page_alloc psmouse i2c_nforce2 snd serio_raw soundcore asus_atk0110 lp x_tables parport usbhid ohci1394 ieee1394 forcedeth [last unloaded: parport_pc]
[519658.792613] Pid: 2700, comm: kded4 Not tainted 2.6.31-20-generic-pae #57-Ubuntu
[519658.792616] Call Trace:
[519658.792622]  [<c014692d>] warn_slowpath_common+0x6d/0xa0
[519658.792626]  [<c0219e5f>] ? idr_callback+0x4f/0x80
[519658.792630]  [<c0219e5f>] ? idr_callback+0x4f/0x80
[519658.792633]  [<c01469a6>] warn_slowpath_fmt+0x26/0x30
[519658.792637]  [<c0219e5f>] idr_callback+0x4f/0x80
[519658.792643]  [<c0318956>] idr_for_each+0x76/0xd0
[519658.792646]  [<c0219e10>] ? idr_callback+0x0/0x80
[519658.792650]  [<c0217fa7>] ? fsnotify_put_event+0x37/0x50
[519658.792654]  [<c0218051>] ? fsnotify_flush_notify+0x91/0xa0
[519658.792660]  [<c0579de8>] ? _spin_lock+0x8/0x10
[519658.792664]  [<c0219df5>] inotify_free_group_priv+0x15/0x30
[519658.792668]  [<c02180c9>] fsnotify_final_destroy_group+0x19/0x30
[519658.792671]  [<c02181b7>] fsnotify_put_group+0x77/0x80
[519658.792675]  [<c021a051>] inotify_release+0x21/0x40
[519658.792680]  [<c01ecd5a>] __fput+0xda/0x1f0
[519658.792684]  [<c01ece85>] fput+0x15/0x20
[519658.792687]  [<c01e92a7>] filp_close+0x47/0x70
[519658.792691]  [<c02c4db0>] ? exit_sem+0xd0/0x1d0
[519658.792695]  [<c0148433>] put_files_struct+0x63/0xb0
[519658.792698]  [<c01484c3>] exit_files+0x43/0x60
[519658.792702]  [<c014958f>] do_exit+0x11f/0x2e0
[519658.792706]  [<c01546ad>] ? dequeue_signal+0x2d/0x170
[519658.792710]  [<c014978a>] do_group_exit+0x3a/0xb0
[519658.792714]  [<c0155f0f>] get_signal_to_deliver+0x18f/0x2a0
[519658.792718]  [<c01ce164>] ? do_wp_page+0xf4/0x8b0
[519658.792721]  [<c010308b>] do_signal+0x6b/0x160
[519658.792726]  [<c012eb6f>] ? kmap_atomic+0x1f/0x30
[519658.792729]  [<c01cf22f>] ? handle_mm_fault+0x3df/0x4a0
[519658.792735]  [<c0167136>] ? getnstimeofday+0x56/0x110
[519658.792738]  [<c01031cd>] do_notify_resume+0x4d/0x60
[519658.792742]  [<c0103488>] work_notifysig+0x13/0x1b
[519658.792745] ---[ end trace df2223bcafca9845 ]---


      
