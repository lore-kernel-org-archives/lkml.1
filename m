Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbYFEL3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbYFEL3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 07:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYFEL27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 07:28:59 -0400
Received: from md2.t-2.net ([84.255.209.81]:11729 "EHLO md2.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425AbYFEL26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 07:28:58 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 07:28:58 EDT
Date: Thu, 5 Jun 2008 13:23:57 +0200
From: Andrej Hocevar <and.hocevar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM with kernel
Message-ID: <20080605112357.GA7588@stoa>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Junkmail-Status: score=10/150, host=md2.t-2.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0201.4847CCCA.0092,ss=1,fgs=0,
	ip=84.255.194.172,
	so=2008-05-01 23:44:25,
	dmn=5.4.3/2008-02-01
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this right after resuming from hibernation. Unfortunatelly, I
don't have the kernel-sources anymore as I've actually upgraded to
2.6.25.4. 



Buffer I/O error on device sda1, logical block 0
lost page write due to I/O error on sda1
scsi 1:0:0:0: Direct-Access     WD       5000AAKS Externa 106a PQ: 0
ANSI: 4
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 11 00 00 00
sd 1:0:0:0: [sdb] Assuming drive cache: write through
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 11 00 00 00
sd 1:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1 sdb2 sdb3
 sd 1:0:0:0: [sdb] Attached SCSI disk
usb-storage: device scan complete
------------[ cut here ]------------
WARNING: at fs/buffer.c:1183 mark_buffer_dirty+0x20/0x6a()
Modules linked in: xt_state xt_tcpudp iptable_filter ip_tables x_tables
nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_conntrack_ftp nf_conntrack ppdev
lp cpufreq_stats fuse sr_mod sbp2 sd_mod parport_pc parport
snd_intel8x0 snd_ac97_codec rtc ac97_bus snd_pcm_oss snd_mixer_oss
snd_pcm 8250_pci snd_timer 8250 serial_core snd_page_alloc rng_core
video output evdev ide_cd_mod cdrom ide_disk usb_storage usbhid
scsi_mod ohci1394 piix ieee1394 ide_core ehci_hcd uhci_hcd usbcore unix
[last unloaded: firmware_class]
Pid: 7364, comm: umount Not tainted 2.6.25.3summer #1
[<c011767f>] warn_on_slowpath+0x40/0x4f
[<c013c6d5>] generic_writepages+0x1a/0x21
[<c014dd56>] check_bytes_and_report+0x25/0x98
[<c014dd56>] check_bytes_and_report+0x25/0x98
[<c014e046>] check_object+0x114/0x19f
[<c0192fdf>] journal_destroy+0x11e/0x125
[<c014e561>] __slab_free+0x1be/0x1ed
[<c0192fdf>] journal_destroy+0x11e/0x125
[<c014eb91>] kfree+0x79/0x81
[<c0192fdf>] journal_destroy+0x11e/0x125
[<c0192fdf>] journal_destroy+0x11e/0x125
[<c0124ac8>] autoremove_wake_function+0x0/0x2d
[<c016a436>] mark_buffer_dirty+0x20/0x6a
[<c018a729>] ext3_put_super+0x41/0x137
[<c0153257>] generic_shutdown_super+0x4a/0xad
[<c01532c6>] kill_block_super+0xc/0x1b
[<c0153334>] deactivate_super+0x2c/0x3f
[<c01620bf>] sys_umount+0x231/0x269
[<c014e561>] __slab_free+0x1be/0x1ed
[<c01543ef>] sys_stat64+0xf/0x23
[<c01440c0>] remove_vma+0x36/0x3b
[<c0144938>] do_munmap+0x181/0x19b
[<c0162102>] sys_oldumount+0xb/0xe
[<c010393e>] syscall_call+0x7/0xb
=======================
---[ end trace 02c95bee20be13a0 ]---


	Andrej

--
www.ljudmila.org/ludliteratura
