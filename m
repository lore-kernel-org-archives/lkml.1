Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYHNRSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYHNRSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYHNRR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:17:58 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2141 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYHNRR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:17:56 -0400
Message-ID: <48A468C2.2010100@xs4all.nl>
Date: Thu, 14 Aug 2008 19:17:54 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 hald trace?
References: <4821DDB8.8040804@xs4all.nl>
In-Reply-To: <4821DDB8.8040804@xs4all.nl>
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Udo van den Heuvel wrote:
> I found multiple sets of the type off logging that is below this text.
> This is on my VIA Epia EN12000 running Fedora 8 and a custom 2.6.25 kernel.

2.6.26 now..

> What is the trace good for?
> hald is polling an empty CD/DVD drive.
> Is this a bug? Or a feature? Normal?
> Is hald the cause?
> Or something besides hald?
> How can I fix it?
> 
> Please let us know.

Aug 14 19:11:01 recorder kernel: INFO: task hald-addon-stor:1522 blocked
for more than 120 seconds.
Aug 14 19:11:01 recorder kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 14 19:11:01 recorder kernel: hald-addon-st D c04581d8     0  1522   1475
Aug 14 19:11:01 recorder kernel:       ef83bbb4 00000086 0000000c
c04581d8 00000246 f6df6e40 f6df6fa8 f6df6fa8
Aug 14 19:11:01 recorder kernel:       00000004 c025c709 ef83bc2c
7fffffff ef83bc14 ef83bc20 c0306dd6 ef83bca4
Aug 14 19:11:01 recorder kernel:       c0253f15 ffffffff f7b5bb40
c04581d8 00000000 00000096 ffffffff f7b5bb40
Aug 14 19:11:01 recorder kernel: Call Trace:
Aug 14 19:11:01 recorder kernel: [<c025c709>]
cdrom_start_packet_command+0xb6/0xbd
Aug 14 19:11:01 recorder kernel: [<c0306dd6>] schedule_timeout+0x14/0xaf
Aug 14 19:11:01 recorder kernel: [<c0253f15>] ide_do_request+0x605/0x813
Aug 14 19:11:01 recorder kernel: [<c0306cdb>] wait_for_common+0xb6/0x11d
Aug 14 19:11:01 recorder kernel: [<c011444b>] default_wake_function+0x0/0xc
Aug 14 19:11:01 recorder kernel: [<c02541ec>] ide_do_drive_cmd+0xc9/0xe5
Aug 14 19:11:01 recorder kernel: [<c025cd1c>] ide_cd_queue_pc+0x35/0xa1
Aug 14 19:11:01 recorder kernel: [<c025cd1c>] ide_cd_queue_pc+0x35/0xa1
Aug 14 19:11:01 recorder kernel: [<c025cd1c>] ide_cd_queue_pc+0x35/0xa1
Aug 14 19:11:01 recorder kernel: [<c0306cdb>] wait_for_common+0xb6/0x11d
Aug 14 19:11:01 recorder kernel: [<c01db796>] __blk_put_request+0x1d/0x70
Aug 14 19:11:01 recorder kernel: [<c025dafe>] cdrom_read_tocentry+0xbf/0xca
Aug 14 19:11:01 recorder kernel: [<c01dddd1>] blk_end_sync_rq+0x0/0x23
Aug 14 19:11:01 recorder kernel: [<c025dc6b>] ide_cd_read_toc+0xf1/0x3f8
Aug 14 19:11:01 recorder kernel: [<c025e4fc>]
idecd_revalidate_disk+0x10/0x18
Aug 14 19:11:01 recorder kernel: [<c01754b2>] __invalidate_device+0x2e/0x34
Aug 14 19:11:01 recorder kernel: [<c01754f1>] check_disk_change+0x39/0x5c
Aug 14 19:11:01 recorder kernel: [<c0280718>] cdrom_open+0x879/0x8c9
Aug 14 19:11:01 recorder kernel: [<c015adeb>] do_lookup+0x53/0x145
Aug 14 19:11:01 recorder kernel: [<c01e353f>] kobject_get+0xf/0x13
Aug 14 19:11:01 recorder kernel: [<c01df7be>] get_disk+0x53/0x6a
Aug 14 19:11:01 recorder kernel: [<c01df7dc>] exact_lock+0x7/0xd
Aug 14 19:11:01 recorder kernel: [<c023cfac>] kobj_lookup+0x108/0x134
Aug 14 19:11:01 recorder kernel: [<c025c63f>] idecd_open+0x4f/0x63
Aug 14 19:11:01 recorder kernel: [<c0175c20>] do_open+0x84/0x23c
Aug 14 19:11:01 recorder kernel: [<c0175dd8>] blkdev_open+0x0/0x4d
Aug 14 19:11:01 recorder kernel: [<c0175dfd>] blkdev_open+0x25/0x4d
Aug 14 19:11:01 recorder kernel: [<c01533c6>] __dentry_open+0x129/0x211
Aug 14 19:11:01 recorder kernel: [<c015352b>] nameidata_to_filp+0x1c/0x2c
Aug 14 19:11:01 recorder kernel: [<c015dee4>] do_filp_open+0x319/0x6d6
Aug 14 19:11:01 recorder kernel: [<c012a6e7>] ktime_get+0xf/0x2b
Aug 14 19:11:01 recorder kernel: [<c027d682>] cdrom_release+0x179/0x1ae
Aug 14 19:11:01 recorder kernel: [<c0113356>] hrtick_start_fair+0xd0/0x11a
Aug 14 19:11:01 recorder kernel: [<c012bf6a>] getnstimeofday+0x32/0xb8
Aug 14 19:11:01 recorder kernel: [<c0153116>] get_unused_fd_flags+0x5e/0xc9
Aug 14 19:11:01 recorder kernel: [<c01531be>] do_sys_open+0x3d/0xb6
Aug 14 19:11:01 recorder kernel: [<c015327b>] sys_open+0x1e/0x23
Aug 14 19:11:01 recorder kernel: [<c0102ad1>] sysenter_past_esp+0x6a/0x99
Aug 14 19:11:01 recorder kernel: [<c0174332>] bio_fs_destructor+0x0/0xb
Aug 14 19:11:01 recorder kernel: =======================


Kind regards,
Udo
