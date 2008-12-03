Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYLCPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYLCPjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYLCPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:39:16 -0500
Received: from md2.t-2.net ([84.255.209.81]:7691 "EHLO md2.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYLCPjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:39:15 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2008 10:39:14 EST
Date: Wed, 3 Dec 2008 16:33:02 +0100
From: Andrej Hocevar <and.hocevar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: buffer i/o error
Message-ID: <20081203153302.GA12232@stoa>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Junkmail-Status: score=10/150, host=md2.t-2.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010204.4936A6B2.0113,ss=1,fgs=0,
	ip=84.255.194.172,
	so=2008-08-01 02:07:42,
	dmn=5.7.1/2008-09-02,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I suddenly realized that one of my external disks (a Western Digital
MyBook usb disk) wasn't accessible anymore. Then I found the following message.
There seems to have been no apparent damage or loss, but I'm reporting it
anyway.

Regards,

Andrej Hocevar


------------[ cut here ]------------
WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x20/0x69()
Modules linked in: nls_cp437 isofs loop xt_state xt_tcpudp iptable_filter
ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ipv4 nfDec  3 16:24:58 stoa
kernel: Pid: 12202, comm: umount Not tainted 2.6.27.7home #1
 [<c0118eae>] warn_on_slowpath+0x40/0x63
 [<c0151c22>] check_object+0x10d/0x197
 [<c0152e76>] __slab_alloc+0x366/0x3de
 [<c011394b>] place_entity+0x9c/0xde
 [<c011388f>] update_curr+0x3d/0x5d
 [<c01149a0>] __dequeue_entity+0x1f/0x71
 [<c01158f0>] pick_next_task_fair+0xdf/0xe9
 [<c016fe20>] mark_buffer_dirty+0x20/0x69
 [<c0198b88>] journal_update_superblock+0x4a/0x7c
 [<c0198e00>] journal_destroy+0x101/0x146
 [<c0126742>] autoremove_wake_function+0x0/0x2d
 [<c018fcfd>] ext3_put_super+0x1f/0x147
 [<c01578a6>] generic_shutdown_super+0x4a/0xad
 [<c0157915>] kill_block_super+0xc/0x1b
 [<c0157983>] deactivate_super+0x2c/0x3f
 [<c0167772>] sys_umount+0x253/0x279
 [<c01677a3>] sys_oldumount+0xb/0xe
 [<c0102b36>] syscall_call+0x7/0xb
 [<c0310000>] via_ircc_open+0xfa/0x59b
 =======================
---[ end trace af37a7a2247422ea ]---

 
Linux stoa 2.6.27.7home #1 Sun Nov 23 14:37:46 CET 2008 i686 GNU/Linux
 
Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1
module-init-tools      found
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         nls_cp437 isofs loop xt_state xt_tcpudp iptable_filter
ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_conntrack_ftp
nf_conntrack snd_mixer_oss ppdev lp cpufreq_stats fuse sr_mod sbp2 snd_intel8x0
snd_ac97_codec ac97_bus 8250_pci 8250 snd_pcm snd_timer rng_core serial_core
snd_page_alloc video output parport_pc parport sd_mod evdev ide_cd_mod cdrom
ide_disk usb_storage usbhid scsi_mod piix ohci1394 ide_core ieee1394 ehci_hcd
uhci_hcd usbcore unix

--
www.ljudmila.org/ludliteratura
