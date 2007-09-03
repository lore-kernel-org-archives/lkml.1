Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbXICPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbXICPoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 11:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXICPoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 11:44:09 -0400
Received: from lucidpixels.com ([75.144.35.66]:58804 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbXICPoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 11:44:08 -0400
Date: Mon, 3 Sep 2007 11:44:08 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Bill Davidsen <davidsen@tmr.com>
cc: bjdouma@xs4all.nl, linux-kernel@vger.kernel.org
Subject: Re: bogomips discrepancy on Intel Core2 Quad CPU
In-Reply-To: <46DC1E9B.3030108@tmr.com>
Message-ID: <Pine.LNX.4.64.0709031143540.27061@p34.internal.lan>
References: <46DBC092.8030209@xs4all.nl> <46DC1E9B.3030108@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Sep 2007, Bill Davidsen wrote:

> Bauke Jan Douma wrote:
>> $> uname -a
>> Linux skyscraper 2.6.22.5 #7 SMP PREEMPT Sun Sep 2 12:12:25 CEST 2007 i686 
>> GNU/Linux
>> 
>> $> cat /proc/cpuinfo | grep bogomips
>> bogomips    : 4813.46
>> bogomips    : 4810.91
>> bogomips    : 4810.91
>> bogomips    : 10583.94
>> 
>> The latter seems way off base.
>> Prod me for more info.
>> 
> I see this occasionally on a dual, speedstep (or similar) finds a way to 
> throttle down the cores under light load. I suspect that if you load the 
> system:
>
>  for n in 1 2 3 4; do
>    nice -19 bash -c 'while true; do a=$RANDOM; done' &
>  done
>
> Then you should see your bogomips rise on all cores.
>
>
>> bjd
>
> 	[... copy of output snipped, see the O.P. ...]
>
> -- 
> Bill Davidsen <davidsen@tmr.com>
>  "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

$ uname -a
Linux p34.internal.lan 2.6.22 #2 SMP Mon Jul 16 18:40:31 EDT 2007 x86_64 
GNU/Linux

$ cat /proc/cpuinfo | grep bogomips
bogomips        : 4797.72
bogomips        : 4795.16
bogomips        : 4795.21
bogomips        : 4795.19

Mine is fine, not using any speedstep here.

Justin.
