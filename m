Return-Path: <linux-kernel-owner+w=401wt.eu-S1764624AbYEASdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764624AbYEASdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYEASdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:33:08 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:35608 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbYEASdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:33:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=ZJU6qQwai5RkFKkjPBBXw/xAcLuFtP7P5a0w5laonpALKaBOZ/nvVJsOdH1jWn7P;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <481A0CC3.9040006@earthlink.net>
Date: Thu, 01 May 2008 14:32:35 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Nigel Cunningham <ncunningham@crca.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	 <20080430224610.GO8474@1wt.eu>	 <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org>	 <200805010242.36775.rjw@sisk.pl>	 <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>	 <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org> <1209609075.1271.19.camel@nigel-laptop>
In-Reply-To: <1209609075.1271.19.camel@nigel-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec7920417b424103b03529be9484edf8290c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.144.77.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> Hi.
> 
> On Wed, 2008-04-30 at 18:40 -0700, Linus Torvalds wrote:
>> The thing is, the quality of individual patches isn't what matters! What 
>> matters is the quality of the end result. And people are going to be a lot 
>> more involved in looking at, testing, and working with code that is 
>> merged, rather than code that isn't.
> 
> No. People generally expect that code that has been merged does work, so
> they don't look at it unless they're forced to (by a bug or the desire
> to make further modifications in that code) and they don't explicitly
> seek to test it. They just seek to use it.
> 
> When it doesn't work, some of us will go and seek to find the cause,
> others (most?) will simply roll back to whatever they last found to be
> reliable.
> 
> Out of tree code has the same issues.
> 
> The only time code really gets looked at and tested is when there's a
> problem, or when people are explicitly choosing to inspect it (pre-merge
> reviews, eg).
> 
> So my answer to the "how do we raise quality" question would be that
> when writing the code, we put time and effort into properly analysing
> the problem and developing a solution, we put time and effort into
> carefully testing the solution, and we put code in that will help the
> end-user help us to debug issues later (without them necessarily needing
> to git-bisect). After all, good software isn't the result of random (or
> semi-random), unconsidered modifications, but of planning, thought and
> attention to detail.
> 
> In other words, I'm arguing that the speed of merging should be
> irrelevant. What's relevant is the quality of the work done in the first
> place.
> 
> If you want better quality code, penalise the people who get buggy code
> merged. Give them a reason to get it in a better state before they try
> to merge. Of course Linus alone can't do that.
> 
> Nigel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
Amen!

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


