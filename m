Return-Path: <linux-kernel-owner+w=401wt.eu-S1764061AbXGZXj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764061AbXGZXj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbXGZXjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:39:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52923 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064AbXGZXjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:39:19 -0400
Message-ID: <46A930A0.1030701@garzik.org>
Date: Thu, 26 Jul 2007 19:39:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: david@lang.hm
CC: Dirk Schoebel <dirk@liji-und-dirk.de>, ck@vds.kolivas.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       Eric St-Laurent <ericstl34@sympatico.ca>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Paul Jackson <pj@sgi.com>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070726111326.873f7b0a.akpm@linux-foundation.org> <200707270004.46211.dirk@liji-und-dirk.de> <200707270033.41055.dirk@liji-und-dirk.de> <46A92DF4.6000301@garzik.org> <Pine.LNX.4.64.0707261627220.4183@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707261627220.4183@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Thu, 26 Jul 2007, Jeff Garzik wrote:
> 
>> Dirk Schoebel wrote:
>>>  as long as the maintainer follows the kernel development things can be
>>>  left in, if the maintainer can't follow anymore they are taken out 
>>> quite
>>>  fast again. (This statement mostly counts for parts of the kernel 
>>> where a
>>>  choice is possible or the coding overhead of making such choice 
>>> possible
>>>  is quite low.)
>>
>>
>> This is just not good engineering.
>>
>> It is axiomatic that it is easy to add code, but difficult to remove 
>> code. It takes -years- to remove code that no one uses.  Long after 
>> the maintainer disappears, the users (and bug reports!) remain.
> 
> I'll point out that the code that's so hard to remove is the code that 
> exposes an API to userspace.

True.


> code that's an internal implementation (like a couple of the things 
> being discussed) gets removed much faster.

Not true.  It is highly unlikely that code will get removed if it has 
active users, even if the maintainer has disappeared.

The only things that get removed rapidly are those things mathematically 
guaranteed to be dead code.

_Behavior changes_, driver removals, feature removals happen more 
frequently than userspace ABI changes -- true -- but the rate of removal 
is still very, very slow.

It is axiomatic that we are automatically burdened with new code for at 
least 10 years :)  That's what you have to assume, when accepting anything.

	Jeff



