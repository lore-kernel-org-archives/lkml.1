Return-Path: <linux-kernel-owner+w=401wt.eu-S933247AbXC3IMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbXC3IMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 04:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbXC3IMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 04:12:39 -0400
Received: from lucidpixels.com ([75.144.35.66]:47445 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbXC3IMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 04:12:38 -0400
Date: Fri, 30 Mar 2007 04:12:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
In-Reply-To: <17932.37976.65001.735686@notabene.brown>
Message-ID: <Pine.LNX.4.64.0703300412310.18662@p34.internal.lan>
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
 <17931.23488.160031.119117@notabene.brown> <Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
 <17932.37976.65001.735686@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Mar 2007, Neil Brown wrote:

> On Thursday March 29, jpiszcz@lucidpixels.com wrote:
>>
>>>
>>> Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
>>> running at?
>> Around 44MB/s.
>>
>> I do use the following optimization, perhaps a bad idea if I want other
>> processes to 'stay alive'?
>>
>> echo "Setting minimum resync speed to 200MB/s..."
>> echo "This improves the resync speed from 2.1MB/s to 44MB/s"
>> echo 200000 > /sys/block/md0/md/sync_speed_min
>> echo 200000 > /sys/block/md1/md/sync_speed_min
>> echo 200000 > /sys/block/md2/md/sync_speed_min
>> echo 200000 > /sys/block/md3/md/sync_speed_min
>> echo 200000 > /sys/block/md4/md/sync_speed_min
>>
>
> Yes, well....
>
> You told it to use up to 200MB/s and the drives are only delivering
> 44MB/s, so they will be taking nearly all of the available bandwidth.
> You shouldn't be too surprised if other things suffer.
>
> NeilBrown
>

Understood, will reduce this, thanks.

Justin.
