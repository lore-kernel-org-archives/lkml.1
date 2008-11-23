Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYKWWZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYKWWZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYKWWZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:25:24 -0500
Received: from lucidpixels.com ([75.144.35.66]:44112 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYKWWZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:25:23 -0500
Date: Sun, 23 Nov 2008 17:25:22 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stian Jordet <liste@jordet.net>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <1227476908.32357.5.camel@chevrolet>
Message-ID: <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>
References: <1226760254.5089.11.camel@chevrolet> <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com> <1227476908.32357.5.camel@chevrolet>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Nov 2008, Stian Jordet wrote:

> ti., 18.11.2008 kl. 11.51 -0200, skrev Sergio Luis:
>> please post your config and dmesg output. It might help people try to
>> identify something wrong.
>
> (see http://marc.info/?l=linux-kernel&m=122676220019858&w=2 for the
> start of this thread)
>
> Hmm. I have now converted my root and /home filesystems to ext3, and
> that actually fixed it (!). I have no idea why xfs is performing so
> extremely poorly on this machine, i'm running xfs on every filesystem on
> eight other computers (one heavy loaded server, as well).
>
> Anyway, I'm now unpacking the 2.6.27.6 kernel in 15 seconds, with xfs on
> the same array it used between five and six minutes.
>
> I still have a xfs array, and when I copy files to or from that array,
> the gnome session practically freezes, and the load average easily goes
> beyond 10.
>
> How should I debug this? I'm not very eager about reformatting my 1,5TB
> xfs array... Besides, xfs have never let me down earlier.
>
> Thanks.
>
> Please cc me on any replies.
>
> Regards,
> Stian
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

As the original posted stated:

1. please post dmesg output
2. you may want to include your kernel .config
3. xfs_info /dev/mdX or /dev/device may also be useful
4. you can also check fragmentation:
    # xfs_db -c frag -f /dev/md2
    actual 257492, ideal 242687, fragmentation factor 5.75%
5. something sounds very strange, I also run XFS on a lot of systems and
    have never heard of that before..
6. also post your /etc/fstab options
7. what distribution are you running?
8. are -only- the two fujitsu's (raid0) affected or are other arrays
    affected on this HW as well (separate disks etc)?
9. you can also compile in support for latency_top & power_top to see
    if there is any excessive polling going on by any one specific
    device/function as well

Justin.
