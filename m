Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYAFAYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYAFAYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYAFAYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:24:17 -0500
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:22560 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbYAFAYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:24:16 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.24-rc5: 'sysctl table check failed' when turning on printer
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2115
Date: Sun, 6 Jan 2008 01:24:11 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801060124.11782.elendil@planet.nl>
X-OriginalArrivalTime: 06 Jan 2008 00:24:14.0157 (UTC) FILETIME=[77463FD0:01C84FFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending as there were no replies on my first post mid December; issue
is still there with -rc6.)

This is the first time I've seen this error. Last time I used the printer 
was with 2.6.24-rc3 and that time this error did not occur.
The error occurs when I start a print job, not when I turn the printer on.

System is Pentium D x86_64 kernel running Debian unstable.
Printer is a HP Photosmart P1100 connected via parallel port.

Not sure who should be CCed on this.

ppdev0: registered pardevice
sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice  Sysctl already exists
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
