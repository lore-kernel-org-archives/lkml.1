Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbXHFJVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbXHFJVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbXHFJVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:21:32 -0400
Received: from web53809.mail.re2.yahoo.com ([206.190.36.204]:39758 "HELO
	web53809.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754966AbXHFJVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:21:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RNuldoulYaO5jwlU8fb0d7+Xjm7H0hd2R+GCNWsJM1vTfC7Tfae1Pkl8Em/J3htyg3E/cmn9nUR1SszrSZ3z+N8DFQokfYMQAZ3jLqRhHCPjIgotERAyEQKIxq7XeERK0ddw/pNVV5fUAWiCsH3QK3WLfkOImETfL4RvGKmkSok=;
X-YMail-OSG: GX5eKqIVM1kcFDI.yKNTXHAouzeFpxQlqOn.PQ48zOxfvXJAssP3vn6YuSczqSE8lA--
Date: Mon, 6 Aug 2007 19:21:29 +1000 (EST)
From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans for 2.6.23]
To: david@lang.hm
Cc: Rene Herman <rene.herman@gmail.com>, Daniel Hazelton <dhazelton@enter.net>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708051916430.6905@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <997038.92524.qm@web53809.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- david@lang.hm wrote:

> On Mon, 6 Aug 2007, Nick Piggin wrote:
> 
> > david@lang.hm wrote:
> >>  On Sun, 29 Jul 2007, Rene Herman wrote:
> >> 
> >> >  On 07/29/2007 01:41 PM, david@lang.hm wrote:
> >> > 
> >> > >  I agree that tinkering with the core VM code
> should not be done 
> >> > >  lightly,
> >> > >   but this has been put through the proper
> process and is stalled with 
> >> > >   no
> >> > >   hints on how to move forward.
> >> > 
> >> > 
> >> >  It has not. Concerns that were raised (by
> specifically Nick Piggin) 
> >> >  weren't being addressed.
> >>
> >>
> >>  I may have missed them, but what I saw from him
> weren't specific issues,
> >>  but instead a nebulous 'something better may
> come along later'
> >
> > Something better, ie. the problems with page
> reclaim being fixed.
> > Why is that nebulous?
> 
> becouse that doesn't begin to address all the
> benifits.

What do you mean "address the benefits"? What I want
to address is the page reclaim problems.


> the approach of fixing page reclaim and updatedb is
> pretending that if you 
> only do everything right pages won't get pushed to
> swap in the first 
> place, and therefor swap prefetch won't be needed.

You should read what I wrote.

Anyway, the fact of the matter is that there are still
fairly significant problems with page reclaim in this
workload which I would like to see fixed.

I personally still think some of the low hanging fruit
*might* be better fixed before swap prefetch gets
merged, but I've repeatedly said I'm sick of getting
dragged back into the whole debate so I'm happy with
whatever Andrew decides to do with it.

I think it is sad to turn it off for laptops, if it
really makes the "desktop" experience so much better.
Surely for _most_ workloads we should be able to
manage 1-2GB of RAM reasonably well.

 
> this completely ignores the use case where the
> swapping was exactly the 
> right thing to do, but memory has been freed up from
> a program exiting so 
> that you couldnow fill that empty ram with data that
> was swapped out.

Yeah. However, merging patches (especially when
changing heuristics, especially in page reclaim) is
not about just thinking up a use-case that it works
well for and telling people that they're putting their
heads in the sand if they say anything against it.
Read this thread and you'll find other examples of
patches that have been around for as long or longer
and also have some good use-cases and also have not
been merged.



      ____________________________________________________________________________________
Yahoo!7 Mail has just got even bigger and better with unlimited storage on all webmail accounts. 
http://au.docs.yahoo.com/mail/unlimitedstorage.html
