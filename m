Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbXD2Pj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbXD2Pj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXD2Pj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:39:59 -0400
Received: from ag-out-0708.google.com ([72.14.246.246]:17052 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbXD2Pju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VjZqxpZso6WWUMulPjlwpBnBmvdezF1lVmuC1QlWkRYGNWgfKrWsuUbPrtOBNDJD7x5O84cIIX+e9KG8zl7k6UX2qJkie2aHfm/F4HdwPvYXYuml/V1rPaMhDWvFT2wW3BJSlABpCwry5kWC8Foekg9xd8JjLBuHHJEgkME1MVE=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Date: Sun, 29 Apr 2007 11:39:45 -0400
User-Agent: KMail/1.9.6
Cc: "Con Kolivas" <kernel@kolivas.org>, "Willy Tarreau" <w@1wt.eu>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       "Mark Lord" <lkml@rtr.ca>, "Zach Carter" <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
References: <200704261041.04838.gene.heskett@gmail.com> <200704292146.15653.kernel@kolivas.org> <4d8e3fd30704290509r79b7fc47i17ce286a43564259@mail.gmail.com>
In-Reply-To: <4d8e3fd30704290509r79b7fc47i17ce286a43564259@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291139.45539.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007, Paolo Ciarrocchi wrote:
[...]

>> > > CFS modifies the scheduler and nothing else, SD fiddles all over the
>> > > kernel in interesting ways.

Huh?  Doesn't grok.

>> > Hmmm I guess you confused both of them this time. CFS touches many
>> > places, which is why I think the testing coverage is still very low. SD
>> > can be tested faster. My real concern is : are there still people
>> > observing regressions with it ? If yes, they should be fixed before even
>> > being merged. If no, why not merge it as a fix for the many known corner
>> > cases of current scheduler ? After all, it's already in -mm.
>> >
>> > Willy
>>
>> Willy, you're making far too much sense. Are you replying to the correct
>> mailing list?
>
>FWIW, I strongly agree with Willy.

If we're putting it to a vote, I'm with Willy.  But this is a dictatorship and 
we shouldn't forget it. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
An ambassador is an honest man sent abroad to lie and intrigue for the
benefit of his country.
		-- Sir Henry Wotton, 1568-1639
