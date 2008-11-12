Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYKLX65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYKLX65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYKLX6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:58:45 -0500
Received: from lucidpixels.com ([75.144.35.66]:59358 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYKLX6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:58:44 -0500
Date: Wed, 12 Nov 2008 18:58:43 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org
Subject: Re: typo in raid[456] kernel code/no change based on type?
In-Reply-To: <alpine.DEB.1.10.0811121855470.10512@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0811121858300.10512@p34.internal.lan>
References: <alpine.DEB.1.10.0811121855470.10512@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Nov 2008, Justin Piszcz wrote:

> $ cat /proc/mdstat Personalities : [raid1] [raid6] [raid5] [raid4] md1 : 
> active raid1 sdb2[1] sda2[0]
>      136448 blocks [2/2] [UU]
>
> md2 : active raid1 sdb3[1] sda3[0]
>      276109056 blocks [2/2] [UU]
>
> md3 : active raid6 sdj1[10] sdc1[4] sdl1[8] sdk1[1] sdi1[9] sdh1[7] sdg1[6] 
> sdf1[3] sde1[2] sdd1[0]
>      2344263680 blocks level 6, 1024k chunk, algorithm 2 [10/9] [UUUUU_UUUU]
>      [===================>.]  recovery = 99.1% (290466636/293032960) 
> finish=0.6min speed=67979K/sec
>
> md0 : active raid1 sdb1[1] sda1[0]
>      16787776 blocks [2/2] [UU]
>
> unused devices: <none>
>
> --
>
> But in the kernel logs:
>
> [ 3497.577716] md: recovery of RAID array md3
> [ 3497.577720] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [ 3497.577721] md: using maximum available idle IO bandwidth (but not more 
> than 90000 KB/sec) for recovery.
> [ 3497.577728] md: using 128k window, over a total of 293032960 blocks.
> [ 6981.488528] md: md3: recovery done.
> [ 6982.273208] RAID5 conf printout:
>               ^^^^^
> [ 6982.273215]  --- rd:10 wd:10
> [ 6982.273219]  disk 0, o:1, dev:sdd1
> [ 6982.273223]  disk 1, o:1, dev:sdk1
> [ 6982.273227]  disk 2, o:1, dev:sde1
> [ 6982.273231]  disk 3, o:1, dev:sdf1
> [ 6982.273245]  disk 4, o:1, dev:sdc1
> [ 6982.273258]  disk 5, o:1, dev:sdj1
> [ 6982.273260]  disk 6, o:1, dev:sdg1
> [ 6982.273263]  disk 7, o:1, dev:sdh1
> [ 6982.273265]  disk 8, o:1, dev:sdl1
> [ 6982.273267]  disk 9, o:1, dev:sdi1
>
> Is the type detectable via auto-assemble, if it is shouldn't it print out
> the right raid type in the logs/dmesg?
>
> Justin.
>
>

Forgot to cc linux-raid.

