Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbXLPUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbXLPUTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 15:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbXLPUTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 15:19:44 -0500
Received: from hpsmtp-eml14.KPNXCHANGE.COM ([213.75.38.114]:35984 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbXLPUTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 15:19:43 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.24-rc5: 'sysctl table check failed' when turning on printer
Date: Sun, 16 Dec 2007 21:19:40 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712162119.41186.elendil@planet.nl>
X-OriginalArrivalTime: 16 Dec 2007 20:19:42.0135 (UTC) FILETIME=[FDCE5C70:01C84020]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first time I've seen this error. Last time I used the printer 
was with 2.6.24-rc3 and that time this error did not occur.

System is Pentium D x86_64 kernel running Debian unstable.
Printer is a HP Photosmart P1100 connected via parallel port.

Not sure who should be CCed on this.

ppdev0: registered pardevice
sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice  
Sysctl already exists
Pid: 14491, comm: hpijs Not tainted 2.6.24-rc5 #1

Call Trace:
 [<ffffffff8024c0b0>] set_fail+0x3f/0x47
 [<ffffffff8024c566>] sysctl_check_table+0x4ae/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8023ca15>] register_sysctl_table+0x52/0x9d
 [<ffffffff881d97cb>] :parport:parport_device_proc_register+0xc3/0xe3
 [<ffffffff881d7da7>] :parport:parport_register_device+0x206/0x267
 [<ffffffff884171ae>] :ppdev:pp_irq+0x0/0x40
 [<ffffffff8841774f>] :ppdev:pp_ioctl+0x13f/0x77c
 [<ffffffff80296a11>] do_ioctl+0x55/0x6b
 [<ffffffff80296c6a>] vfs_ioctl+0x243/0x25c
 [<ffffffff80296cd4>] sys_ioctl+0x51/0x71
 [<ffffffff8020beee>] system_call+0x7e/0x83

Cheers,
FJP
