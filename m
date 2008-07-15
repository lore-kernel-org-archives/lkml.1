Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYGOHYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYGOHYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYGOHYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:24:03 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:49563 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbYGOHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eJ58goipITVZqSnfMcp7qdHIoE75JjTYBrO0mQe+VPGEuzmxfAF4hFP3/+ZeKgHJyV
         d6oAApLpay9M+5+6O7xa5RXiF6VxJj+TYmgwYTG/m/42AK+doislYFKWdtlIxFLzlMG4
         zv91Jnek60BjCDu0hDYzIQ7fhenfvwls2cdgo=
Message-ID: <6d291e080807150023v6fe2cdb4t4c21b550883dd7a1@mail.gmail.com>
Date: Tue, 15 Jul 2008 02:23:59 -0500
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: From 2.4 to 2.6 to 2.7?
Cc: david@lang.hm, "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       gorcunov@gmail.com, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20080715053101.GJ1369@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
	 <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
	 <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com>
	 <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807142048260.6370@asgard>
	 <20080715053101.GJ1369@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 12:31 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Mon, Jul 14, 2008 at 08:55:59PM -0700, david@lang.hm wrote:
>> On Mon, 14 Jul 2008, Linus Torvalds wrote:
>>
>> >>Does it have to be even numbers only?
>> >
>> >No. But the even/odd thing is still so fresh in peoples memory (despite us
>> >not having used it for years), and I think some projects aped us on it, so
>> >if I didn't change the numbering setup, but just wanted to reset the minor
>> >number, I'd probably jump from 2.6 to 2.8 just for historical reasons.
>> >
>> >But I could also see the second number as being the "year", and 2008 would
>> >get 2.8, and then next year I'd make the first release of 2009 be 2.9.1
>> >(and probably avoid the ".0" just because it again has the connotations of
>> >a "big new untested release", which is not true in a date-based numbering
>> >scheme). And then 2010 would be 3.0.1 etc..
>>
>> Ok, I'll jump in.
>>
>> I don't have strong feelings either, but I do have comments
>>
>> 1. for the historical reasons you allude to above going to a completely
>> different numbering system would be a nice thing
>>
>> 2. I do like involving the year, but I think 2008/2009/2010 are much
>> clearer then 2.8/2.9/3.0 let people shorten it verbally, but still realize
>> that it's a full year being referred to.
>>
>> 3. avoid using the month of the release (which ubuntu does), first you
>> aren't going to predict the month of relese ahead of time (so what will
>> the -rc's be called, the year is fairly clear and it's not _that_ bad if
>> 2008.4 happens to come out in Jan 2009). also too many people don't
>> understand that 8.10 is between 8.9 and 8.11, not between 8.0 and 8.2
>
> That's probably why openbsd jumps from 3.9 to 4.0. I like such a numbering
> too. It compacts 3 numbers into 2 (like we had before) but without any
> major/minor notion. You just bump each new version by 0.1 at a somewhat
> regular rate. Having the year and a sub-version is fine too, but I think
> it adds unnecessary digits. Or maybe jump to 8.X for 2008, then 9.X in
> 2009 and 10.X in 2010 ? That way, we have both the date and the simplicity.
> And it's not like we really care about version 1000 in year 3000.
>
>> so my prefrence (mild as it is) goes to YYYY.r.s (r=release, s=stable)
>
> agreed, but with Y.r.s :-)
Interesting idea but that would still get us to the 20.1.5 and that
just seems really high, even if its based on year not on number of
releases. Although I still wanted to know about the original change
between 2.4 to 2.6 and what other then the version numbering prompted
the change

>
> Willy
>
>

-Stoyan
