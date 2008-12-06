Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYLFMLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYLFMLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 07:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYLFMLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 07:11:34 -0500
Received: from lucidpixels.com ([75.144.35.66]:44114 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbYLFMLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 07:11:33 -0500
Date: Sat, 6 Dec 2008 07:11:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       smartmontools-support@lists.sourceforge.net
Subject: Re: Have the velociraptors in a test system now, checkout the
 errors.
In-Reply-To: <493A5E62.1020508@msgid.tls.msk.ru>
Message-ID: <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan> <493A5E62.1020508@msgid.tls.msk.ru>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Michael Tokarev wrote:

> Justin Piszcz wrote:
>> Point of thread: Two problems, mentioned in detail below, NCQ in Linux
> []
>
>> Two-disks failed out of the RAID5 and I currentlty cannot even 'see' one
>> of the drives with smartctl, will reboot the host and check sde again.
>
> Not to say it's your case (i remember you mentioned a new powerful PSU
> in your last emails), but anyway.
>
> We had numerous, countless disk failures like this in the past - with
> seagate scsi drives (not sas, not sata but ol'good scsi - 9Gb and 36Gb
> barracuda ones).  As that - a drive suddenly disappears from the bus,
> without any indication it was/is here, only power-cycle cures the prob.
>
> One such case were related to a broken (it seems) batch of those 9Gb
> drives (it was back in 2000 or so).  The frequency of such failures
> fluctuated a lot, and did not depend on system load - it was possible
> to see disk disappearance after a few mins after boot without any load,
> or it may run for several weeks under a good load.  The failing drive
> was always the same, replace it and voila, it works again.  There was
> about 10..20 such drives we had, some are still here somewhere (not in
> use).
>
> And another case was with 36gb 10krpm barracudas, at about 2004 or so.
> And also with 18gb 15Krpm maxtors.  Some of them.
>
> This case looked really mysterious to me.  Until I found (after many
> many times experimenting with all that) that the cause is under-powered
> PSU.  For example, when there were 2 disks running on the system, no
> hdd stopped, but with 4 disks rinning, one were quite likely to stop
> (always the same, other disks were working still).  When this new
> problem started appearing and I had not yet understand the cause,
> we also tried to replace the "failing" drives, and it helped somewhat, --
> i.e., there were high chances that the replacement disk will actually
> work better.  But some non-zero chance existed that it will not work
> the same or even worse way the "failing" drive failed.
>
> It come to good surprize to me that the problem was the PSU.  It was
> 350W (quite descent in 2002 when the test system was bought), but
> obviously not enough for the load with all the 15krpm drives...
> (and later on the system become instable too, and now I know why -
> also lack of proper power, now for chipset/cpu).
>
> The prob with 9gb drives were real (not due to the PSU), but
> Seagate never acknowleged it.
>
> Just... another "funny" scenario which happened for real.
> And my probs obviously were NOT related to NCQ (TCQ really) -
> TCQ worked on all those drives just fine, much better and
> with much better effect than all thouse modern NCQ-aware
> drives.....  Ohwell.
>
> /mjt
>

Very interesting story there, what OS(') were you using at the time?
Windows? Linux? UNIX?

As far the PSU, just btw/FYI, Velociraptors consume ~4-5 watts a piece, my 
entire system used ~100-120watts with all 12 velociraptors on a 650 watt 
PSU (now moved into a test system).

Justin.

