Return-Path: <linux-kernel-owner+w=401wt.eu-S1765418AbXE2UBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765418AbXE2UBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbXE2UBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:01:09 -0400
Received: from mail.tmr.com ([64.65.253.246]:33563 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbXE2UBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:01:08 -0400
Message-ID: <465C8684.2030600@tmr.com>
Date: Tue, 29 May 2007 16:01:08 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What causes iowait other than waiting for i/o?
References: <465B4B75.2040602@tmr.com> <465C5B61.6000702@redhat.com>
In-Reply-To: <465C5B61.6000702@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Bill Davidsen wrote:
>> I recently noted that my system was spending a lot of time in i/o 
>> wait when doing some tasks which I thought didn't involve i/o, as 
>> noted by the lack of disk light activity most of the time. I thought 
>> of network, certainly the NIC had no activity for this job. So I set 
>> up a little loop to capture all disk i/o and network activity 
>> (including loopback). That was no obvious help, and the program 
>> doesn't use pipes.
>>
>> At this point I'm really curious, does someone have a good clue?
>>
>> Note: I don't think this is a bug or performance issue, unless the 
>> kernel is doing something and charging time to iowait instead of 
>> system I don't see anything to fix, but I would like to understand.
>
> All filesystem IO and direct disk IO can cause iowait.
>
> This includes NFS activity.
>
If I didn't note it before, I'm read the the data from /proc, cpustats, 
net/dev, and diskstats. I assume that all i/o would show up in one of 
those places. NFS isn't involved, although this machine is a fileserver 
as a side job the modules weren't even loaded during testing.

A puzzlement for future consideration. If I get a chance later this week 
I'll make a pretty graphic of all the stuff going on when the iowait 
spiked, ctx rate, inq rate, hell the last time I even grabbed the CPU 
temp to see if it told me anything (didn't, thermal throttling NOT).

Thanks for the feedback, I think that lets out the obvious stuff.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

