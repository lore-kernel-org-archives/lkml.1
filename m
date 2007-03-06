Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbXCFFae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbXCFFae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXCFFae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:30:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50604 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbXCFFad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:30:33 -0500
Message-ID: <45ECFC5F.7000102@garzik.org>
Date: Tue, 06 Mar 2007 00:30:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz> <20070305084257.GA4464@mellanox.co.il> <20070305101120.GA23032@elte.hu>
In-Reply-To: <20070305101120.GA23032@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm also getting this WARN_ON() from e1000:
> 
> BUG: at drivers/pci/msi.c:611 pci_enable_msi()
>  [<c01061bd>] show_trace_log_lvl+0x19/0x2e
>  [<c01062b6>] show_trace+0x12/0x14
>  [<c01062cc>] dump_stack+0x14/0x16
>  [<c024fcc4>] pci_enable_msi+0x6d/0x203
>  [<c02b709e>] e1000_request_irq+0x2e/0xe2
>  [<c02bb742>] e1000_resume+0x7f/0xef
>  [<c0249a68>] pci_device_resume+0x1a/0x44
>  [<c02b39ec>] resume_device+0xf7/0x16f
>  [<c02b3adb>] dpm_resume+0x77/0xcb
>  [<c02b3b69>] device_resume+0x3a/0x51
>  [<c014e669>] enter_state+0x193/0x1bb
>  [<c014e712>] state_store+0x81/0x97
>  [<c01b68bc>] subsys_attr_store+0x20/0x25
>  [<c01b6feb>] sysfs_write_file+0xce/0xf6
>  [<c017e16b>] vfs_write+0xb1/0x13a
>  [<c017e899>] sys_write+0x3d/0x61
>  [<c0105220>] syscall_call+0x7/0xb
> 
> seems harmless because it seems to work fine.


I would poke Eric Biederman(sp?) about this one.  Maybe its even solved 
by the MSI-enable-related patch he posted in the past 24-48 hours.

	Jeff


