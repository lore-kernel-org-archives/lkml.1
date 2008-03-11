Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYCKVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYCKVeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbYCKVeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:34:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:49520 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752469AbYCKVeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:34:11 -0400
X-Authenticated: #12956409
X-Provags-ID: V01U2FsdGVkX19BsqBZpPlBSnf2w64aKyPn7rdDjzCAOve+YM7hE/
	ASvyNBUBeciUe/
Message-ID: <47D6FAD0.1020608@gmx.net>
Date: Tue, 11 Mar 2008 22:34:08 +0100
From: Cyrus Massoumi <cyrusm@gmx.net>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Nicholas Miell <nmiell@comcast.net>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, "Molnar, Ingo" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
References: <200803111749.29143.nickpiggin@yahoo.com.au> <1205269674.12854.16.camel@entropy>
In-Reply-To: <1205269674.12854.16.camel@entropy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Miell wrote:
> On Tue, 2008-03-11 at 17:49 +1100, Nick Piggin wrote:
> 
>> So PostgreSQL performance profile is actually much more interesting.
>> To my dismay, I found that Linux 2.6.25-rc5 performs really badly
>> after saturating the runqueues and subsequently increasing threads.
>> 2.6.22 drops a little bit, but basically settles near the peak
>> performance. With 2.6.25-rc5, throughput seems to be falling off
>> linearly with the number of threads.
>>
> 
> The FreeBSD folks have a whole host of benchmark results (MySQL,
> PostgreSQL, BIND, NSD, ebizzy, SPECjbb, etc.) located at
> http://people.freebsd.org/~kris/scaling/ that demonstrate that the
> 2.6.23+ scheduler is worse than the 2.6.22 scheduler and both are worse
> than FreeBSD 7.
> 
> The interesting thing is that they've been running these tests
> constantly for years now to demonstrate that their new scheduler hasn't
> regressed compared to their old scheduler and as a benchmark against the
> competition (i.e. Linux).
> 
> Does anybody even do this at all for Linux?
> 
> (Also, ignoring MySQL because it's a terrible piece of software at least
> when regarding it's scalability is a bad idea. It's the M in LAMP, it
> has a huge user base, and FreeBSD manages to outperform Linux with the
> same unscalable piece of software.)

Did you actually see this? 
http://www.kernel.org/pub/linux/kernel/people/npiggin/sysbench/

FreeBSD does not outperform Linux, it's actually a bit faster according 
to Nick's tests.

I cannot comment on BIND and NSD, but SPECjbb looks pretty close and the 
bad ebizzy performance seems to be an issue with glibc's memory allocator.


greetings
Cyrus

