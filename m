Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYDJTxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYDJTxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYDJTxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:53:35 -0400
Received: from rtr.ca ([76.10.145.34]:4362 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYDJTxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:53:35 -0400
Message-ID: <47FE703D.5030901@rtr.ca>
Date: Thu, 10 Apr 2008 15:53:33 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <47FD3BBB.406@rtr.ca> <38b2ab8a0804101205s1e0e4fa0l884286ec7ea9ccbd@mail.gmail.com>
In-Reply-To: <38b2ab8a0804101205s1e0e4fa0l884286ec7ea9ccbd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> Hi
> 
> On Wed, Apr 9, 2008 at 11:57 PM, Mark Lord <lkml@rtr.ca> wrote:
>>> I'm trying to know the geometry of my hard disk from a bash script
>>> and that's the reason I'm looking in /sys. The reason is that I'd like
>>> to figure out the size of a cylinder without doing a
>>> ioctl(bdev, HDIO_GETGEO, &geo)
>>>
>>  $ DEV=/dev/sda
>>  $ GEOM="`/sbin/hdparm -g $DEV | awk '{print $3}'`"
>>  $ echo $GEOM
>>  19457/255/63
>>  $
>>
> 
> Sure and you could the same with fdisk, sfdisk, parted outputs...
> 
> But that wasn't my point, sorry if it wasn't clear.
> 
> I was actually wondering why /sys/block/sda exports a lot of disk
> features but the disk geometry. I was wondering if somthing like
> 
> /sys/block/sda/geometry/heads
> 
> could be useful...
..

Probably not for going forward.  Except when partitioning,
the CHS info isn't really useful or needed for anything newer
than about 14 years old.

And there's already an ioctl for getting it.

So we could add more /sysfs bloat for it, I suppose, but..
 

