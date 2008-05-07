Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbYEGQux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbYEGQux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYEGQuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:50:12 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1412 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYEGQuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:50:03 -0400
Message-ID: <4821DDB8.8040804@xs4all.nl>
Date: Wed, 07 May 2008 18:50:00 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25 hald trace?
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found multiple sets of the type off logging that is below this text.
This is on my VIA Epia EN12000 running Fedora 8 and a custom 2.6.25 kernel.

What is the trace good for?
hald is polling an empty CD/DVD drive.
Is this a bug? Or a feature? Normal?
Is hald the cause?
Or something besides hald?
How can I fix it?

Please let us know.

Thanks,
Udo

May  7 00:28:40 recorder kernel: hda: ide_cd_check_ireason: wrong
transfer direction!
May  7 00:37:39 recorder kernel: INFO: task hald-addon-stor:2285 blocked
for more than 120 seconds.
May  7 00:37:39 recorder kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  7 00:37:39 recorder kernel: hald-addon-st D f721c680     0  2285   2229
May  7 00:37:39 recorder kernel:        f7363b94 00000082 f4f5ae4c
f721c680 c0254cd3 c02563fe 7fffffff 7fffffff
May  7 00:37:39 recorder kernel:        f7363bf0 f7363bfc c02fd43c
c024c42e ffffffff f7025cc0 c044e8e0 00000000
May  7 00:37:39 recorder kernel:        00000086 ffffffff f7025cc0
00000286 00000000 00000000 00000000 f7363c08
May  7 00:37:39 recorder kernel: Call Trace:
May  7 00:37:39 recorder kernel:  [<c0254cd3>]
cdrom_start_packet_command+0xf0/0xf7
May  7 00:37:39 recorder kernel:  [<c02563fe>] cdrom_do_newpc_cont+0x0/0x2c
May  7 00:37:39 recorder kernel:  [<c02fd43c>] schedule_timeout+0x13/0x84
May  7 00:37:39 recorder kernel:  [<c024c42e>] ide_do_request+0x5c4/0x800
May  7 00:37:39 recorder kernel:  [<c02fd2c4>] wait_for_common+0xd4/0x144
May  7 00:37:39 recorder kernel:  [<c0113ac0>] default_wake_function+0x0/0xc
May  7 00:37:39 recorder kernel:  [<c024c81c>] ide_do_drive_cmd+0xcb/0xe7
May  7 00:37:39 recorder kernel:  [<c025547f>] ide_cd_queue_pc+0x35/0xa6
May  7 00:37:39 recorder kernel:  [<c02556fe>] cdrom_check_status+0x55/0x60
May  7 00:37:39 recorder kernel:  [<c01d6b56>] blk_end_sync_rq+0x0/0x26
May  7 00:37:39 recorder kernel:  [<c0257134>]
ide_cdrom_drive_status+0x1d/0x8f
May  7 00:37:39 recorder kernel:  [<c02fd2c4>] wait_for_common+0xd4/0x144
May  7 00:37:39 recorder kernel:  [<c0277116>] cdrom_ioctl+0x25/0xb03
May  7 00:37:39 recorder kernel:  [<c027771b>] cdrom_ioctl+0x62a/0xb03
May  7 00:37:39 recorder kernel:  [<c024c82e>] ide_do_drive_cmd+0xdd/0xe7
May  7 00:37:39 recorder kernel:  [<c025547f>] ide_cd_queue_pc+0x35/0xa6
May  7 00:37:39 recorder kernel:  [<c0254b1c>] idecd_ioctl+0x12f/0x144
May  7 00:37:39 recorder kernel:  [<c015fc01>] __d_lookup+0x10b/0x115
May  7 00:37:39 recorder kernel:  [<c015746a>] do_lookup+0x53/0x145
May  7 00:37:39 recorder kernel:  [<c01d76b7>] blkdev_driver_ioctl+0x4b/0x5b
May  7 00:37:39 recorder kernel:  [<c01d7d0c>] blkdev_ioctl+0x645/0x695
May  7 00:37:39 recorder kernel:  [<c01dbed8>] kobject_get+0xf/0x13
May  7 00:37:39 recorder kernel:  [<c01d7f5e>] get_disk+0x50/0x67
May  7 00:37:39 recorder kernel:  [<c01d7f7c>] exact_lock+0x7/0xd
May  7 00:37:39 recorder kernel:  [<c0234243>] kobj_lookup+0x103/0x12d
May  7 00:37:39 recorder kernel:  [<c0254bcf>] idecd_open+0x78/0x8c
May  7 00:37:39 recorder kernel:  [<c0170778>] do_open+0x1c8/0x247
May  7 00:37:39 recorder kernel:  [<c01709ca>] blkdev_open+0x3a/0x4d
May  7 00:37:39 recorder kernel:  [<c014fb35>] __dentry_open+0x10a/0x196
May  7 00:37:39 recorder kernel:  [<c014fbdd>] nameidata_to_filp+0x1c/0x2c
May  7 00:37:39 recorder kernel:  [<c014fc18>] do_filp_open+0x2b/0x31
May  7 00:37:39 recorder kernel:  [<c017007a>] block_ioctl+0x10/0x13
May  7 00:37:39 recorder kernel:  [<c017006a>] block_ioctl+0x0/0x13
May  7 00:37:39 recorder kernel:  [<c015b110>] vfs_ioctl+0x1c/0x5d
May  7 00:37:39 recorder kernel:  [<c015b38a>] do_vfs_ioctl+0x239/0x24c
May  7 00:37:39 recorder kernel:  [<c014fccb>] do_sys_open+0xad/0xb5
May  7 00:37:39 recorder kernel:  [<c015b3de>] sys_ioctl+0x41/0x5b
May  7 00:37:39 recorder kernel:  [<c0102996>] sysenter_past_esp+0x5f/0x89
May  7 00:37:39 recorder kernel:  =======================
