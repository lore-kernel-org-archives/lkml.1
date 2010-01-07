Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054Ab0AGSFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab0AGSFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181Ab0AGSFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:05:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0AGSFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:05:31 -0500
Date: Thu, 7 Jan 2010 10:04:49 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Voegtle <tv@lio96.de>, Jan Kara <jack@suse.cz>,
       "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, dmonakhov@openvz.org
Subject: Re: Linux 2.6.31.10
Message-ID: <20100107180449.GA17495@suse.de>
References: <20100106234533.GC1960@kroah.com>
 <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 03:27:21PM +0100, Thomas Voegtle wrote:
> Hi,
> 
> On Wed, 6 Jan 2010, Greg KH wrote:
> > I'm announcing the release of the 2.6.31.10 kernel.  All users of the
> > 2.6.31 kernel series are very strongly encouraged to upgrade.
> 
> 
> Something broken here, during using a suse 11.2 installation with quota 
> switched on (this is reproducible )

Jan, this looks like something in the quota patches you sent.  Any
ideas?

Thomas, is this on an ext3 or ext4 partition, or something else?

thanks,

greg k-h

> 
> 
> ------------[ cut here ]------------
> kernel BUG at fs/quota/dquot.c:1398!
> invalid opcode: 0000 [#1]
> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias
> 
> Pid: 3037, comm: rpm Not tainted (2.6.31.10-BIG #1) P3TSSA
> EIP: 0060:[<c10b871e>] EFLAGS: 00010246 CPU: 0
> EIP is at inode_reserved_space+0x23/0x3e
> EAX: c1855c3c EBX: d608ff4c ECX: d462307c EDX: 00000000
> ESI: 00000001 EDI: d462307c EBP: d608feac ESP: d608fea8
>   DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> Process rpm (pid: 3037, ti=d608f000 task=d710afc0 task.ti=d608f000)
> Stack:
>   09a0c500 d608fefc c10badb1 d462307c 000000e4 d796e000 00000000 00000000
> <0> 00000002 d608fee4 00000000 00000000 d44055a0 00000000 00000000 
> d4405320
> <0> 00005140 09a0c500 d462307c d608ff4c d462307c d608ff10 c10b87a6 
> 09a0c500
> Call Trace:
>   [<c10badb1>] ? dquot_transfer+0x106/0x30f
>   [<c10b87a6>] ? vfs_dq_transfer+0x6d/0x9c
>   [<c10956f3>] ? notify_change+0x190/0x295
>   [<c108202a>] ? chown_common+0x65/0x88
>   [<c1604af2>] ? schedule+0x3df/0x40c
>   [<c10821c5>] ? sys_lchown+0x4e/0x7b
>   [<c1002b1b>] ? sysenter_do_call+0x12/0x26
> Code: 05 e8 5e 85 f7 ff c9 c3 55 89 c1 89 e5 83 ec 04 65 a1 14 00 00 00 89 
> 45 fc 31 c0 8b 81 90 00 00 00 8b 40 24 8b 50 44 85 d2 75 04 <0f> 0b eb fe 
> 89 c8 ff d2 8b
> 55 fc 65 33 15 14 00 00 00 74 05 e8
> EIP: [<c10b871e>] inode_reserved_space+0x23/0x3e SS:ESP 0068:d608fea8
> ---[ end trace 575c2988a2722de1 ]---
> 
