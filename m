Return-Path: <linux-kernel-owner+w=401wt.eu-S1765638AbYEATof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765638AbYEATof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbYEAToZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:44:25 -0400
Received: from mail.lang.hm ([64.81.33.126]:42140 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbYEAToY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:44:24 -0400
Date: Thu, 1 May 2008 12:46:41 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Willy Tarreau <w@1wt.eu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080501192829.GQ8474@1wt.eu>
Message-ID: <alpine.DEB.1.10.0805011239040.9847@asgard>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
 <20080501185032.GA30883@1wt.eu> <alpine.DEB.1.10.0805011155520.9847@asgard> <20080501192829.GQ8474@1wt.eu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Willy Tarreau wrote:

> On Thu, May 01, 2008 at 12:07:53PM -0700, david@lang.hm wrote:
>> On Thu, 1 May 2008, Willy Tarreau wrote:
>>
>> I suspect that they would not have, and if I'm right the result of merging
>> half as much wouldn't be twice as many releases, but rather approximatly
>> the same release schedule with more piling up for the next release.
>
> no, this is exactly what *not* to do. Linus is right about the risk of
> getting more stuff at once. If we merge less things, we *must* be able
> to speed up the process. Half the patches to cross-check in half the
> time should be easier than all patches in full time. The time to fix
> a problem within N patches is O(N^2).

in general you are correct, however I don't think that it's the general 
bugs that end up delaying the releases, think it's the nasty, hard to 
identify and understand bugs that delay the releases, and I don't think 
that the debugging of those will speed up much.

>> even individual git trees that do get a fair bit of testing (like
>> networking for example) run into odd and hard to debug problems when
>> exposed to a wider set of hardware and loads. having the networking
>> changes go in every 4 months (with 4 months worth of changes) instead of
>> every 2 months (with 2 months worth of changes) will just mean that there
>> will be more problems in this area, and since they will be more
>> concentrated in that area it will be harder to fix them all fast as the
>> same group of people are needed for all of them.
>
> You're perfectly right and that's exactly not what I'm proposing. BTW,
> having two halves will also get more of the merge job done the side of
> developers, where testing is being done before submission. So in the
> end, we should also get *less* regressions caused by each submission.

Ok, I guess I don't understand what you are proposing then.

I thought that you were proposing going from 2 week merge + 6 week 
stabilize = release to 1 week merge half + 3 week stabilize = release

it now sounds as if you are saying 1 week merge + x week stabilize + 1 
week merge + x week stabilize = release

can you clarify?

>> if several maintainers think that you are correct that doing a merge with
>> far fewer changes will be a lot faster, they can test this in the real
>> world by skipping one release. just send Linus a 'no changes this time'
>> instead of a pull request. If you are right the stable release will happen
>> significantly faster and they can say 'I told you so' and in the next
>> release have a fair chance of convincing other maintainers to skip a
>> release.
>
> again, this cannot work because this would result in slowing them down,
> and it's not what I'm proposing.

if merging fewer catagoies of stuff doesn't speed up the release cycle 
then you are right, it would just slow things down. however I thought you 
were arguing that if we merged fewer catagories of stuff each cycle we 
could speed up the cycle. I'm saying that maintainers can choose to test 
this experimentally and see if it works. if it works we can shift to doing 
more of it, if it doesn't they only delay things by a couple of months one 
time.

you would need to have several maintainers decide to participate in the 
experiment or the difference in cycle time may not be noticable.

David Lang
