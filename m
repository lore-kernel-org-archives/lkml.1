Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbXC2OTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbXC2OTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 10:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXC2OTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 10:19:47 -0400
Received: from mail.tmr.com ([64.65.253.246]:52394 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbXC2OTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 10:19:47 -0400
Message-ID: <460BCB1D.9030806@tmr.com>
Date: Thu, 29 Mar 2007 10:20:13 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: roland <devzero@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
References: <05e401c76cdb$178be430$eeeea8c0@aldipc>
In-Reply-To: <05e401c76cdb$178be430$eeeea8c0@aldipc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

roland wrote:
> partitions on loop or device-mapper devices ?
> 
> you can use kpartx tool for this.
> 
> bryn m. reeves told me, that it's probably poissible to create udev 
> rules that will automatically create partition maps when a new loop 
> device is setup, which is better than adding partitioning logig into 
> dm-loop for example.

It is certainly possible to create a partitionable RAID device from a 
loop device. Should be possible to use nbd as well, but I can't seem to 
get nbd to work on 2.6.21-rc (my working system runs 2.6.17).
> 
> example:
>> kpartx -a /dev/mapper/loop0
>>
>> # ls /dev/mapper/loop0*
>> /dev/mapper/loop0  /dev/mapper/loop0p1  /dev/mapper/loop0p2
>> /dev/mapper/loop0p3
> 
> i have seen a patch for loop.c doing this, though. search the archives 
> for this
> 
> regards
> roland
> 
> 
> 
> 
> 
> On Thu, Mar 22, 2007 at 02:33:14PM +0000, Al Viro wrote:
>> Correction: current ABI is crap.  To set the thing up you need to open
>> it and issue an ioctl.  Which is a bloody bad idea, for obvious 
>> reasons...
> 
> Agreed.  What would be a right way?  Global device ala ptmx/tun/tap?
> New syscall?  Something else?
> 
>  OG.
> -
> ]


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
