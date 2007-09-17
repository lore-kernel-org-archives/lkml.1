Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbXIQT1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbXIQT1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbXIQT1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:27:34 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:30571 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbXIQT1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:reply-to:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=kCpFG/cbggc0pJLOi7EmDMjLQIfijxd/s6vhxTAvDF8fDJEG9aNX50ojrWbCVrK8ca8g8yjJKCYcZB3heyq3CQadfDqZVr/jVCrZcq5mtgEgW5HgcIuUe9/cYUqCldcV1l2sSpKbhJvfXWs84d1y7JaRieunq68nMtbE6p3TJoU=
Reply-To: mark.hagger@ntlworld.com
To: linux-kernel@vger.kernel.org, mxhaard@users.sourceforge.net
Subject: kernel oops with 2.6.2x kernels and gspca module
Date: Mon, 17 Sep 2007 20:27:26 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709172027.26325.mark.hagger@ntlworld.com>
From: Mark Hagger <chhagger@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm unable to use the gscpa module to drive my webcam.  As soon as the webcam is plugged in the following
sort of kernel crash happens.  With much older kernels (2.6.19 or so) from earlier this year I did have this
camera working for a while, but since upgrading to later kernels I've had no luck at all.

Regards,

Mark


Linux whisky.alcohol 2.6.22.2-42_1.cubbi_suspend2.fc6 #1 SMP Mon Aug 20 01:28:07 CEST 2007 i686 athlon i386 GNU/Linux

Sep 17 20:14:24 whisky kernel: usb 2-2: new full speed USB device using uhci_hcd and address 2
Sep 17 20:14:24 whisky kernel: usb 2-2: configuration #1 chosen from 1 choice
Sep 17 20:14:25 whisky kernel: v4l1_compat: no version for "struct_module" found: kernel tainted.
Sep 17 20:14:25 whisky kernel: Linux video capture interface: v2.00
Sep 17 20:14:25 whisky kernel: /var/tmp/bach-build/BUILD/gspcav1-20070508/gspca_core.c: USB GSPCA camera found.(SPCA561A)
Sep 17 20:14:25 whisky kernel: /var/tmp/bach-build/BUILD/gspcav1-20070508/gspca_core.c: [spca5xx_probe:4098] Camera type S561
Sep 17 20:14:25 whisky kernel: /var/tmp/bach-build/BUILD/gspcav1-20070508/gspca_core.c: [spca5xx_getcapability:1215] maxw 352 maxh 288 minw 160 minh 120
Sep 17 20:14:25 whisky kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000075
Sep 17 20:14:25 whisky kernel:  printing eip:
Sep 17 20:14:25 whisky kernel: c063826e
Sep 17 20:14:25 whisky kernel: *pde = 2314b067
Sep 17 20:14:25 whisky kernel: *pte = 00000000
Sep 17 20:14:25 whisky kernel: Oops: 0002 [#1]
Sep 17 20:14:25 whisky kernel: SMP
Sep 17 20:14:25 whisky kernel: last sysfs file: /devices/pci0000:00/0000:00:10.1/usb2/2-2/dev
Sep 17 20:14:25 whisky kernel: Modules linked in: gspca(F)(U) videodev(F)(U) v4l2_common(F)(U) v4l1_compat(F)(U) arc4 ecb blkcipher ppp_mppe ppp_async crc_
ccitt ppp_generic slhc nfsd exportfs lockd nfs_acl w83627ehf i2c_isa eeprom ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink ip_t
ables x_tables hidp l2cap bluetooth sunrpc cpufreq_ondemand video sbs button dock battery ac ipv6 lp snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_e
vent snd_seq floppy snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm snd_timer snd soundcore k8temp i2c_viapro snd_page_alloc hwmon via_rhine ohci1394 i
2c_core mii parport_pc parport ide_cd rtc_cmos serio_raw cdrom dm_snapshot dm_zero dm_mirror dm_mod sata_via libata sd_mod scsi_mod ext3 jbd mbcache ehci_h
cd ohci_hcd uhci_hcd
Sep 17 20:14:25 whisky kernel: CPU:    0
Sep 17 20:14:25 whisky kernel: EIP:    0060:[<c063826e>]    Tainted: GF      VLI
Sep 17 20:14:25 whisky kernel: EFLAGS: 00010246   (2.6.22.2-42_1.cubbi_suspend2.fc6 #1)
Sep 17 20:14:25 whisky kernel: EIP is at mutex_lock+0x1d/0x29
Sep 17 20:14:25 whisky kernel: eax: 00000075   ebx: 00000075   ecx: 00000004   edx: e579a000
Sep 17 20:14:25 whisky kernel: esi: c07444c0   edi: ffffffef   ebp: c0563413   esp: e579ad64
Sep 17 20:14:25 whisky kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Sep 17 20:14:25 whisky kernel: Process modprobe (pid: 4047, ti=e579a000 task=e432ac00 task.ti=e579a000)
Sep 17 20:14:25 whisky kernel: Stack: df8089d0 f8e8a454 c04bc721 f8da52ca df808a50 00000004 f8da0124 00000000
Sep 17 20:14:25 whisky kernel:        00000000 f8da9047 e4728000 df8089c8 df808a5c 00000160 f8e5bf2c f8e6edf0
Sep 17 20:14:25 whisky kernel:        f8e6bd00 f8e6816d 000004bf 00000160 00000120 000000a0 00000078 e306ee00
Sep 17 20:14:25 whisky kernel: Call Trace:
Sep 17 20:14:25 whisky kernel:  [<c04bc721>] sysfs_add_file+0x2a/0x70
Sep 17 20:14:25 whisky kernel:  [<f8da52ca>] video_register_device+0x1af/0x220 [videodev]
Sep 17 20:14:25 whisky kernel:  [<f8e5bf2c>] spca5xx_probe+0x44a/0x5f1 [gspca]
Sep 17 20:14:25 whisky kernel:  [<c059d037>] usb_probe_interface+0x81/0xb2
Sep 17 20:14:25 whisky kernel:  [<c05623bf>] driver_probe_device+0xea/0x168
Sep 17 20:14:25 whisky kernel:  [<c05624e3>] __driver_attach+0x0/0xa5
Sep 17 20:14:25 whisky kernel:  [<c0562553>] __driver_attach+0x70/0xa5
Sep 17 20:14:25 whisky kernel:  [<c0561938>] bus_for_each_dev+0x39/0x5b
Sep 17 20:14:25 whisky kernel:  [<c056221a>] driver_attach+0x16/0x18
Sep 17 20:14:25 whisky kernel:  [<c05624e3>] __driver_attach+0x0/0xa5
Sep 17 20:14:25 whisky kernel:  [<c0561c1c>] bus_add_driver+0x6d/0x16d
Sep 17 20:14:25 whisky kernel:  [<c059cb85>] usb_register_driver+0x6d/0xd4
Sep 17 20:14:25 whisky kernel:  [<f88db017>] usb_spca5xx_init+0x17/0x42 [gspca]
Sep 17 20:14:25 whisky kernel:  [<c0431b86>] blocking_notifier_call_chain+0x17/0x1a
Sep 17 20:14:25 whisky kernel:  [<c04446d3>] sys_init_module+0x169a/0x17d3
Sep 17 20:14:25 whisky kernel:  [<c0474ff2>] do_munmap+0x193/0x1ac
Sep 17 20:14:25 whisky kernel:  [<c04853d2>] vfs_read+0xa6/0x158
Sep 17 20:14:25 whisky kernel:  [<c0404f5e>] syscall_call+0x7/0xb
Sep 17 20:14:25 whisky kernel:  =======================
Sep 17 20:14:25 whisky kernel: Code: c1 03 48 79 05 89 d8 5b eb 2d 5b 31 c0 c3 53 ba 56 00 00 00 89 c3 83 ec 04 b8 16 aa 6d c0 e8 17 9b de ff e8 e5 f7 ff f
f 89 d8 90 <ff> 08 79 05 e8 c4 00 00 00 58 5b c3 57 56 89 c6 53 83 ec 0c 8d
Sep 17 20:14:25 whisky kernel: EIP: [<c063826e>] mutex_lock+0x1d/0x29 SS:ESP 0068:e579ad64
