Return-Path: <linux-kernel-owner+w=401wt.eu-S935184AbXJPUtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184AbXJPUtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935672AbXJPUtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:49:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25971 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935609AbXJPUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:49:31 -0400
Date: Tue, 16 Oct 2007 22:49:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Message-ID: <20071016204925.GH9942@kernel.dk>
References: <200710132126.33085.rjw@sisk.pl> <20071016045025.GC8125@kroah.com> <200710162204.51961.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710162204.51961.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16 2007, Rafael J. Wysocki wrote:
> On Tuesday, 16 October 2007 06:50, Greg KH wrote:
> > On Sat, Oct 13, 2007 at 09:26:32PM +0200, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > There are many traces like this in my dmesg from 2.6.23-git3 (they don't
> > > appear for vanilla 2.6.23):
> > > 
> > > <4>sysfs: duplicate filename 'ethxx1' can not be created
> > > WARNING: at /home/rafael/src/linux-2.6/fs/sysfs/dir.c:425 sysfs_add_one()
> > > 
> > > Call Trace:
> > >  [<ffffffff802d1532>] sysfs_add_one+0x5c/0xc9
> > >  [<ffffffff802d2411>] sysfs_create_link+0xd1/0x12c
> > >  [<ffffffff803756da>] device_rename+0x17a/0x1db
> > >  [<ffffffff803c903d>] dev_change_name+0x114/0x20c
> > >  [<ffffffff803c9339>] dev_ifsioc+0x204/0x2d0
> > >  [<ffffffff803c9925>] dev_ioctl+0x520/0x633
> > >  [<ffffffff803bf445>] sk_alloc+0x37/0x10c
> > >  [<ffffffff8024b977>] up_read+0x9/0xb
> > >  [<ffffffff803bc65e>] sock_ioctl+0x1fe/0x20c
> > >  [<ffffffff8029b34a>] do_ioctl+0x2a/0x77
> > >  [<ffffffff8029b5e8>] vfs_ioctl+0x251/0x26e
> > >  [<ffffffff8029b664>] sys_ioctl+0x5f/0x83
> > >  [<ffffffff8020bd4e>] system_call+0x7e/0x83
> > > 
> > > net ethxx1: device_rename: sysfs_create_symlink failed (-17)
> > > sysfs: duplicate filename 'eth1' can not be created
> > > 
> > > Everything seems to work, but this just looks fishy.
> > 
> > This is a userspace program renaming your network device to a name that
> > is already in use.  What distro and release is this?
> 
> openSUSE 10.2, with some updates (not the most recent, though).

Same thing happens in 10.3, rendering current git unusable for me with
iwl3945.

-- 
Jens Axboe

