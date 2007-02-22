Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXBVXEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXBVXEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXBVXEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:04:47 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:48783 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbXBVXEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:04:45 -0500
Date: Fri, 23 Feb 2007 00:04:43 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: BUG in 2.6.20-git15, Suspend to disk
Message-ID: <20070222230443.GA6342@mail.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (tirith.ics.muni.cz [147.251.4.35]); Fri, 23 Feb 2007 00:04:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after some time I've tried to suspend to disk. It basically works but it
complains into log with the following message:

BUG: at drivers/pci/pci.c:823 pcim_enable_device()
 [<c01f9e2c>] pcim_enable_device+0xbc/0xd0
 [<c025d762>] ata_pci_device_do_resume+0x22/0x80
 [<c025df85>] ata_pci_device_resume+0x15/0x30
 [<c01fc30f>] pci_device_resume+0x1f/0x60
 [<c02488ba>] resume_device+0x5a/0xf0
 [<c02489ee>] dpm_resume+0x9e/0xc0
 [<c0248a28>] device_resume+0x18/0x30
 [<c013dba5>] pm_suspend_disk+0x155/0x230
 [<c013c886>] enter_state+0x146/0x170
 [<c013c96d>] state_store+0xbd/0xd0
 [<c013c8b0>] state_store+0x0/0xd0
 [<c01a3819>] subsys_attr_store+0x29/0x40
 [<c01a3951>] sysfs_write_file+0xb1/0x110
 [<c01686e6>] vfs_write+0xa6/0x140
 [<c01a38a0>] sysfs_write_file+0x0/0x110
 [<c0168cc1>] sys_write+0x41/0x70
 [<c0104178>] syscall_call+0x7/0xb
 [<c0330000>] sleep_on_timeout+0x30/0xb0
 =======================

-- 
Luká¹ Hejtmánek
