Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbXFZEXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbXFZEXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXFZEXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:23:05 -0400
Received: from server.rillion.net ([207.210.78.215]:42424 "EHLO rillion.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbXFZEXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:23:04 -0400
Message-ID: <46809495.6000109@rillion.net>
Date: Tue, 26 Jun 2007 16:22:45 +1200
From: Graeme Sheppard <nodes@rillion.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Patent or not patent a new idea
References: <46803772.7020408@rillion.net>	<46806CCB.6020708@rillion.net>	<18048.30679.872740.744997@notabene.brown>	<468085E9.70804@rillion.net> <18048.35410.896207.686311@notabene.brown>
In-Reply-To: <18048.35410.896207.686311@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> ???
> (reads original description in more detail).
> 
> So... the filesystem images are identical in both copies, and the
> "interesting" bit is that the image is just a file on some filesystem.
> 
> So could I implement your idea by:
> 
>   dd if=/dev/zero of=/1/bigfile count=lotsandlots
>   dd if=/dev/zero of=/2/bigfile count=lotsandlots
>   losetup /dev/loop1 /1/bigfile
>   losetup /dev/loop2 /2/bigfile
>   mdadm -C /dev/md0 --level=raid1 --raid-disks=2 /dev/loop1 /dev/loop2
>   mkfs /dev/md0
>   mount /dev/md2 /space
> 
> ??
> 
> Why would you bother?  Well, I do it a lot of code testing, but I
> would be hard pressed to make a case for that sort of config in
> production.

Thanks for the brief howto there. I'll install the mdadm suite and
experiment. It seems like a userspace driver?

> You said:
>>  1) the disks need
>>    not be the same size or from the same manufacturer; 2) the supporting code
>>    would be cross-platform.
> 
> md/raid already works happily with different sized drives from
> different manufacturers (for raid1, it only uses as much space as the smaller
> drive provides, For raid0 it uses it all).
> I don't know what you mean by '2'.

2 meant in the way that a driver for a PC raid card is not much use on
a Sparc.

> So I still cannot see anything particularly new.  What am I missing?

I think it's what I missed. Thanks for the heads-up. If the above is
a good technique it could suit me well.

