Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbXD0EFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbXD0EFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXD0EFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:05:44 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755250AbXD0EFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:05:43 -0400
Date: Thu, 26 Apr 2007 21:04:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <rol@as2917.net>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
Subject: Re: Strange problem with Device Mapper
Message-Id: <20070426210455.05400edf.akpm@linux-foundation.org>
In-Reply-To: <006001c78826$13f50cf0$4b00a8c0@donald>
References: <006001c78826$13f50cf0$4b00a8c0@donald>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 19:12:27 +0200 "Paul Rolland" <rol@as2917.net> wrote:

> Hello,
> 
> I've a machine that has been installed with Intel Soft Raid on top
> of 2 SATA disks.
> I'm trying to have this work as a RAID-1 array. 
> Bios configuration has been done, using 128K chunk, and the kernel
> (2.6.20.7) sees perfectly /dev/mapper/isw_xxxxxxxx_RAID1
> 
> But, I'm facing two problems :
> 1 - If i try to create partitions on this device, it does fail (the 
>     values are not interpreted correctly)
> 
> 2 - To avoid 1), I stop the RAID array (dmraid -an), then I do create
>     exactly the same partition set on /dev/sda, and /dev/sdb, and
>     then I reactivate RAID (dmraid -ay).
>     This allows me to see all the /dev/mapper/isw_xxxxxxx_RAID1p1, p2, ...
>     But, running fsck -t ext2 /dev/mapper/isw_xxxxxxx_RAID1p1
>     ends in a lock when the partition is larger than 10Go (well, it is
>     Ok on the 10Go one, and it locks on the 100Go).
>     Not a real hardlock, I still can switch to a new VC, but it's not
>     more possible to start a new command or to stop fsck.
> 
> Should I do everything on the physical disks before activating RAID ?
> Is it a normal behavior ?
> 
> BTW, I also noticed that such a device doesn't support BLKRRPART ioctl...
> So it is possible that what I'm doing is wrong...
> 
> Any idea ?
> 

cc added.
