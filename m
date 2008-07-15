Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYGODzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYGODzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYGODzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:55:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:44048 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbYGODzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:55:04 -0400
Date: Mon, 14 Jul 2008 20:55:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807142048260.6370@asgard>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>  <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com>
 <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Linus Torvalds wrote:

>> Does it have to be even numbers only?
>
> No. But the even/odd thing is still so fresh in peoples memory (despite us
> not having used it for years), and I think some projects aped us on it, so
> if I didn't change the numbering setup, but just wanted to reset the minor
> number, I'd probably jump from 2.6 to 2.8 just for historical reasons.
>
> But I could also see the second number as being the "year", and 2008 would
> get 2.8, and then next year I'd make the first release of 2009 be 2.9.1
> (and probably avoid the ".0" just because it again has the connotations of
> a "big new untested release", which is not true in a date-based numbering
> scheme). And then 2010 would be 3.0.1 etc..

Ok, I'll jump in.

I don't have strong feelings either, but I do have comments

1. for the historical reasons you allude to above going to a completely 
different numbering system would be a nice thing

2. I do like involving the year, but I think 2008/2009/2010 are much 
clearer then 2.8/2.9/3.0 let people shorten it verbally, but still realize 
that it's a full year being referred to.

3. avoid using the month of the release (which ubuntu does), first you 
aren't going to predict the month of relese ahead of time (so what will 
the -rc's be called, the year is fairly clear and it's not _that_ bad if 
2008.4 happens to come out in Jan 2009). also too many people don't 
understand that 8.10 is between 8.9 and 8.11, not between 8.0 and 8.2

so my prefrence (mild as it is) goes to YYYY.r.s (r=release, s=stable)

David Lang

> Anyway, I have to say that I personally don't have any hugely strong
> opinions on the numbering. I suspect others do, though, and I'm almost
> certain that this is an absolutely _perfect_ "bikeshed-painting" subject
> where thousands of people will be very passionate and send me their
> opinions on why _their_ particular shed color is so much better.
>
> The only thing I do know is that I agree that "big meaningless numbers"
> are bad. "26" is already pretty big. As you point out, the 2.4.x series
> has much bigger numbers yet.
>
> And yes, something like "2008" is obviously numerically bigger, but has a
> direct meaning and as such is possibly better than something arbitrary and
> non-descriptive like "26".
>
> Let the bike-shed-painting begin.
>
> (I had planned on taking this up at the kernel summit, where the shed
> painting is at least limited to a much smaller audience, but since you
> asked..)
>
> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
