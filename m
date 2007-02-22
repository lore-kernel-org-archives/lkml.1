Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbXBVXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbXBVXNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXBVXNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:13:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46177 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbXBVXNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:13:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Subject: Re: BUG in 2.6.20-git15, Suspend to disk
Date: Fri, 23 Feb 2007 00:06:47 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
References: <20070222230443.GA6342@mail.muni.cz>
In-Reply-To: <20070222230443.GA6342@mail.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702230006.48037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, 23 February 2007 00:04, Lukas Hejtmanek wrote:
> Hello,
> 
> after some time I've tried to suspend to disk. It basically works but it
> complains into log with the following message:

Tejun says it is known and he's going to fix it.

> BUG: at drivers/pci/pci.c:823 pcim_enable_device()
>  [<c01f9e2c>] pcim_enable_device+0xbc/0xd0
>  [<c025d762>] ata_pci_device_do_resume+0x22/0x80
>  [<c025df85>] ata_pci_device_resume+0x15/0x30
>  [<c01fc30f>] pci_device_resume+0x1f/0x60
>  [<c02488ba>] resume_device+0x5a/0xf0
>  [<c02489ee>] dpm_resume+0x9e/0xc0
>  [<c0248a28>] device_resume+0x18/0x30
>  [<c013dba5>] pm_suspend_disk+0x155/0x230
>  [<c013c886>] enter_state+0x146/0x170
>  [<c013c96d>] state_store+0xbd/0xd0
>  [<c013c8b0>] state_store+0x0/0xd0
>  [<c01a3819>] subsys_attr_store+0x29/0x40
>  [<c01a3951>] sysfs_write_file+0xb1/0x110
>  [<c01686e6>] vfs_write+0xa6/0x140
>  [<c01a38a0>] sysfs_write_file+0x0/0x110
>  [<c0168cc1>] sys_write+0x41/0x70
>  [<c0104178>] syscall_call+0x7/0xb
>  [<c0330000>] sleep_on_timeout+0x30/0xb0
>  =======================
> 

Greetings,
Rafael
-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
