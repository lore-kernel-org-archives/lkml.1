Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYFKUsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYFKUsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbYFKUsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:48:20 -0400
Received: from lucidpixels.com ([75.144.35.66]:47846 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYFKUsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:48:19 -0400
Date: Wed, 11 Jun 2008 16:48:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bill Davidsen <davidsen@tmr.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte
 Veliciraptors
In-Reply-To: <4850354A.8090503@tmr.com>
Message-ID: <alpine.DEB.1.10.0806111647360.18136@p34.internal.lan>
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan> <4850354A.8090503@tmr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jun 2008, Bill Davidsen wrote:

> Justin Piszcz wrote:
>> First, the original benchmarks with 6-SATA drives with fixed formatting, 
>> using
>> right justification and the same decimal point precision throughout:
>> http://home.comcast.net/~jpiszcz/20080607/raid-benchmarks-decimal-fix-and-right-justified/disks.html 
>> 
>> Now for for veliciraptors! Ever wonder what kind of speed is possible with
>> 3 disk, 4,5,6,7,8,9,10-disk RAID5s? I ran a loop to find out, each run is
>> executed three times and the average is taken of all three runs per each 
>> RAID5 disk set.
>> 
>> In short? The 965 no longer does justice with faster drives, a new chipset
>> and motherboard are needed. After reading or writing to 4-5 veliciraptors
>> it saturates the bus/965 chipset.
>
> This is very interesting, but a 16GB chunk size bears no relationship to 
> anything I would run in the real world, and I suspect most people are in the 
> same category.

I based my bonnie++ test on:
http://everything2.org/?node_id=1479435

So I could compare to his results.

I use a 1024k (1MiB) with 16384 stripe, this offered the best overall 
read/write/rewrite performance AFAIK.

Justin.
