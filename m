Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZDICge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZDICge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 22:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZDICgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 22:36:15 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64129 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbZDICgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 22:36:14 -0400
Subject: Re: [2.6.30-rc1] gpf in btrfs during shutdown
From: Chris Mason <chris.mason@oracle.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200904082155.54736.edt@aei.ca>
References: <1238787179.24082.7.camel@think.oraclecorp.com>
	 <200904081948.02742.edt@aei.ca>
	 <1239236094.7365.1.camel@think.oraclecorp.com>
	 <200904082155.54736.edt@aei.ca>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 22:36:02 -0400
Message-Id: <1239244562.14512.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.49DD5F17.0054:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 21:55 -0400, Ed Tomlinson wrote:
> On Wednesday 08 April 2009 20:14:54 Chris Mason wrote:
> > On Wed, 2009-04-08 at 19:48 -0400, Ed Tomlinson wrote:
> > 
> > > 
> > > Chris,
> > > 
> > > Just go the following gpf during shutdown runing 2.6.30-rc1 on amd64 on a kernel built with gcc 4.3.3
> > > 
> > > * Unmounting filesystems ...[75813.573941] EXT4-fs: mballoc: 313285 blocks 3098 reqs (2001 success)
> > > [75813.593628] EXT4-fs: mballoc: 1312 extents scanned, 438 goal hits, 1063 2^N hits, 0 breaks, 0 lost
> > > [75813.621386] EXT4-fs: mballoc: 1551 generated and it took 21437865
> > > [75813.640246] EXT4-fs: mballoc: 364104 preallocated, 204441 discarded
> > > [75813.685443] general protection fault: 0000 [#1] PREEMPT SMP
> > > [75813.698277] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/enable
> > > [75813.698277] CPU 1
> > > [75813.698277] Modules linked in: btrfs/etc/init.d/halt zlib_deflate zlib_inflate crc32c libcrc32c radeon drm bridge stp llc bnep rf]
> > > .sh: line 90:  6[75813.698277] Pid: 6768, comm: umount Not tainted 2.6.30-rc1-crc #1 System Product Name
> > > 768 Segmentation[75813.698277] RIP: 0010:[<ffffffff8030e3a7>]  [<ffffffff8030e3a7>] kmem_cache_alloc+0x77/0x210
> > >  fault      umou[75813.698277] RSP: 0018:ffff8801466514a8  EFLAGS: 00010046
> > > nt "${x}" >&/dev[75813.698277] RAX: 0000000000000000 RBX: ffff880028066b40 RCX: ffff88015f3444a0
> > > /null
> > 
> > That's not supposed to happen.  Do you have slab (or slub) debug
> > enabled? 
> 
> I am using slub without debugging enabled.  I've attached my config incase it will help.
> 

Please enable slub debug, lets see what it turns up.

-chris


