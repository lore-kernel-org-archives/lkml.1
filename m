Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbXEJHFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbXEJHFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXEJHFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:05:08 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:29827 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750888AbXEJHFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:05:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=EFu4/zARi4b6f36QNdpipYouJ/2gVERA7b6NlAjDy1O4GOsNJYPIsdw+ufk3DXYq1D6Zln5+/gAG28H2ZfS3hhrAU65NO1rLEDddR2c4J71EQGDBrRuQNo+YNKSl1MRKbz0PZvBE/EuqktAa6l/9pW37kncSEcD6uvLPmbmctxk=  ;
X-YMail-OSG: bQ6100AVM1kvHN0_xmv86JsOoit85ilCbysUSvs7q2XhVwSeUdHaObVroZ0UwV_wo4.C835Nrg--
Message-ID: <4642C416.3000205@yahoo.com.au>
Date: Thu, 10 May 2007 17:04:54 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
References: <20070430162007.ad46e153.akpm@linux-foundation.org>	 <200705100928.34056.kernel@kolivas.org>	 <464261B5.6030809@yahoo.com.au>	 <200705101134.34350.kernel@kolivas.org> <46427BDB.30004@yahoo.com.au>	 <2c0942db0705092048m38b36e7fo3a7c2c59fe1612b2@mail.gmail.com>	 <46429801.8030202@yahoo.com.au> <2c0942db0705092252n13a6a79aq39f13fcfae534de2@mail.gmail.com>
In-Reply-To: <2c0942db0705092252n13a6a79aq39f13fcfae534de2@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 5/9/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> Ray Lee wrote:
>> > On 5/9/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>> >
>> >> You said it helped with the updatedb problem. That says we should 
>> look at
>> >> why it is going bad first, and for example improve use-once 
>> algorithms.
>> >> After we do that, then swap prefetching might still help, which is 
>> fine.
>> >
>> > Nick, if you're volunteering to do that analysis, then great. If not,
>> > then you're just providing a airy hope with nothing to back up when or
>> > if that work would ever occur.
>>
>> I'd like to try helping. Tell me your problem.
> 
> 
> Huh? You already stated one version of it above, namely updatedb. But

So a swapping problem with updatedb should be unusual and we'd like to see
if we can fix it without resorting to prefetching.

I know the theory behind swap prefetching, and I'm not saying it doesn't
work, so I'll snip the rest of that.


>> What's wrong with the use-once we have? What improvements are you talking
>> about?
> 
> 
> You said, effectively: "Use-once could be improved to deal with
> updatedb". I said I've been reading emails from Rik and others talking
> about that for four years now, and we're still talking about it. Were
> it merely updatedb, I'd say us userspace folk should step up and
> rewrite the damn thing to amortize its work. However, I and others
> feel it's only an example -- glaring, obviously -- of a more pervasive
> issue. A small issue, to be sure!, but an issue nevertheless.

It isn't going to get fixed unless people complain about it. If you
cover the use-once problem with swap prefetching, then it will never
get fixed.


>> I don't think it is about energy or being mean, I'm just stating the
>> issues I have with it.
> 
> 
> Nick, I in no way think you're being mean, and I'm sorry if I've given
> you that impression. However, if you're just stating the issues you
> have with it, then can I assume that you won't lobby against having
> this experiment merged?

Anybody is free to merge anything into their kernel. And if somebody
asks for my issues with the swap prefetching patch, then I'll give
them :)

-- 
SUSE Labs, Novell Inc.
