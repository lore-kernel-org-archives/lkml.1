Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbXHFCZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbXHFCZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXHFCZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:25:20 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37982
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXHFCZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:25:09 -0400
Date: Sun, 5 Aug 2007 19:22:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Rene Herman <rene.herman@gmail.com>, Daniel Hazelton <dhazelton@enter.net>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
In-Reply-To: <46B6840B.8080006@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0708051916430.6905@asgard.lang.hm>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
 <20070727030040.0ea97ff7.akpm@linux-foundation.org> <1185531918.8799.17.camel@Homer.simpson.net>
 <200707271345.55187.dhazelton@enter.net> <46AA3680.4010508@gmail.com>
 <Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm> <46AAEDEB.7040003@gmail.com>
 <Pine.LNX.4.64.0707280138370.32476@asgard.lang.hm> <46AB166A.2000300@gmail.com>
 <Pine.LNX.4.64.0707281349540.32476@asgard.lang.hm> <46AC6771.8080000@gmail.com>
 <Pine.LNX.4.64.0707290420250.15835@asgard.lang.hm> <46AC9DC5.8070900@gmail.com>
 <Pine.LNX.4.64.0707291405350.15835@asgard.lang.hm> <46B6840B.8080006@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Nick Piggin wrote:

> david@lang.hm wrote:
>>  On Sun, 29 Jul 2007, Rene Herman wrote:
>> 
>> >  On 07/29/2007 01:41 PM, david@lang.hm wrote:
>> > 
>> > >  I agree that tinkering with the core VM code should not be done 
>> > >  lightly,
>> > >   but this has been put through the proper process and is stalled with 
>> > >   no
>> > >   hints on how to move forward.
>> > 
>> > 
>> >  It has not. Concerns that were raised (by specifically Nick Piggin) 
>> >  weren't being addressed.
>>
>>
>>  I may have missed them, but what I saw from him weren't specific issues,
>>  but instead a nebulous 'something better may come along later'
>
> Something better, ie. the problems with page reclaim being fixed.
> Why is that nebulous?

becouse that doesn't begin to address all the benifits.

the approach of fixing page reclaim and updatedb is pretending that if you 
only do everything right pages won't get pushed to swap in the first 
place, and therefor swap prefetch won't be needed.

this completely ignores the use case where the swapping was exactly the 
right thing to do, but memory has been freed up from a program exiting so 
that you couldnow fill that empty ram with data that was swapped out.

David Lang
