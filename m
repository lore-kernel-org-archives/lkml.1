Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZCRF3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZCRF3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 01:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZCRF32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 01:29:28 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:37120 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZCRF31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 01:29:27 -0400
Message-ID: <49C086B1.9060500@in.ibm.com>
Date: Wed, 18 Mar 2009 10:59:21 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: jfs-discussion@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Jfs-discussion] [BUG/JFS/2.6.29-rc8] kernel BUG at fs/mpage.c:473!
References: <49BDFB4F.7040405@in.ibm.com> <1237299710.26674.6.camel@norville.austin.ibm.com>
In-Reply-To: <1237299710.26674.6.camel@norville.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:
> On Mon, 2009-03-16 at 12:40 +0530, Sachin Sant wrote:
>   
>> While running file system stress (fsstress) on a JFS partition
>> with 2.6.29-rc8, i hit the following BUG.
>>     
>
> I tried reproducing this yesterday, but was unsuccessful.  Maybe I
> didn't let it run long enough.  Have you run this successfully on
> earlier kernels?  If so, what was the most recent that worked for you.
> Have you seen it more than once?  I'm not sure how easy it is to
> reproduce.
I haven't tried to test with earlier kernels. This was the first
time i ran these tests on this particular box.I run the fsstress
on different type of file systems one after the another (in no
particular order ). Something like ..

* create ext2 filesystem on a device
* run fsstress.
* unmount the device.

I repeat the above steps with ext3, reiserfs and jfs. May be this
combination is causing this problem.

I have seen this problem on two partitions of a power box. Same problem
seem to have been reported earlier against 2.6.25-rcx kernel.

http://lkml.indiana.edu/hypermail/linux/kernel/0803.2/1418.html


Thanks
-Sachin




-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

