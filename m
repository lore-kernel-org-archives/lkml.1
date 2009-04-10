Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZDJVJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZDJVJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 17:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZDJVI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 17:08:58 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61772 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZDJVI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 17:08:58 -0400
To: paulmck@linux.vnet.ibm.com, viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, hugh@veritas.com, jmorris@namei.org,
       akpm@linux-foundation.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp>
	<20090410142203.GA6719@linux.vnet.ibm.com>
	<20090410150353.GL26366@ZenIV.linux.org.uk>
	<20090410153229.GB6719@linux.vnet.ibm.com>
In-Reply-To: <20090410153229.GB6719@linux.vnet.ibm.com>
Message-Id: <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 11 Apr 2009 06:08:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul E. McKenney wrote:
> Tetsuo, how many tasks did you have on this machine?
I didn't count how many tasks were running on this machine.
But the number of tasks should be very low, for this happened during
the boot stage of Debian Sarge.

30 seconds ago from the first stalled message

[   41.415158] INFO: RCU detected CPU 1 stall (t=4294902646/2500 jiffies)
[   41.417332] Pid: 3487, comm: khelper Tainted: G        W  2.6.30-rc1 #1
[   41.417332] Call Trace:

the system was doing

[   10.555521] kjournald starting.  Commit interval 5 seconds
[   10.556727] EXT3 FS on sdb1, internal journal
[   10.556727] EXT3-fs: recovery complete.
[   10.557585] EXT3-fs: mounted filesystem with writeback data mode.
/dev/sdb1 on /usr/src/all type ext3 (rw,noatime,nodiratime)
Detecting hardware: agpgart pcnet32 piix BusLogic ide_scsi
Skipping unavailable/built-in agpgart module.
pcnet32 disabled in configuration.
Skipping unavailable/built-in piix module.
Skipping unavailable/built-in BusLogic module.
Skipping unavailable/built-in ide_scsi module.
Running 0dns-down to make sure resolv.conf is ok...done.
Setting up networking...done.
Starting hotplug subsystem:
   pci     
     ignoring pci display device 00:0f.0
[   16.727603] ------------[ cut here ]------------
[   16.729910] WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()

> Though I too find it hard to believe that there were enough to chew up
> two minutes.  Maybe the list got corrupted so that it has a loop?

I powered off the machine after two minutes, for I thought the loop
was infinite.
