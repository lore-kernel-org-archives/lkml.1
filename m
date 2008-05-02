Return-Path: <linux-kernel-owner+w=401wt.eu-S933619AbYEBAQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbYEBAQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYEBAQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:16:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757177AbYEBAQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:16:04 -0400
Date: Thu, 1 May 2008 17:15:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Roth <ryanroth@sbcglobal.net>
Cc: randy.dunlap@oracle.com, Ryan.Roth@CH2M.com,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults
 onMacBookStarting With 2.6.24.5 Kernel
Message-Id: <20080501171520.38e2a478.akpm@linux-foundation.org>
In-Reply-To: <481A58A2.7070807@sbcglobal.net>
References: <bug-10586-10286@http.bugzilla.kernel.org/>
	<20080501130444.cc5c63e8.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>
	<20080501133003.be723364.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>
	<481A5276.4040607@sbcglobal.net>
	<20080501164856.f93ff909.randy.dunlap@oracle.com>
	<481A58A2.7070807@sbcglobal.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 16:56:18 -0700
Ryan Roth <ryanroth@sbcglobal.net> wrote:

> > May  1 16:15:01 kernel: proc_dir_entry 'info' already registered
> > May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
> > May  1 16:15:01 kernel: 
> > May  1 16:15:01 kernel: Call Trace:
> > May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
> > May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
> > May  1 16:15:01 kernel:  [<ffffffff810d5ec5>] proc_register+0xfe/0x14b
> > May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
> > May  1 16:15:01 kernel:  [<ffffffffa013dd37>]
> > :video:acpi_video_bus_add+0x98f/0xc6d
> > May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
> > May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
> > May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
> > May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
> > May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
> > May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
> > May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
> > May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
> > May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
> > May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
> > May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
> > May  1 16:15:01 kernel:  [<ffffffff8100bf3b>]
> > system_call_after_swapgs+0x7b/0x80

That's an acpi video problem - it won't be the cause of this regression. 
I'll forward it separately.

> > ---
> > ~Randy
> >
> >   
> The segfaults are still present causing apps to not work.  I attached a 
> boot log in case it was needed for more details.  Should I not worry 
> about the following message?
> 
> May  1 16:15:01 kernel: PCI: MCFG configuration 0: base f0000000 segment 
> 0 buses 0 - 255
> May  1 16:15:01 kernel: PCI: BIOS Bug: MCFG area at f0000000 is not 
> reserved in ACPI motherboard resources
> May  1 16:15:01 kernel: PCI: Not using MMCONFIG.

Again, the mmconfig warnings will be unrelated to this bug.
