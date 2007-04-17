Return-Path: <linux-kernel-owner+w=401wt.eu-S1030384AbXDQVph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030384AbXDQVph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965055AbXDQVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:45:37 -0400
Received: from holomorphy.com ([66.93.40.71]:35477 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030AbXDQVpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:45:36 -0400
Date: Tue, 17 Apr 2007 14:45:59 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
Message-ID: <20070417214559.GX8915@holomorphy.com>
References: <200704150931.42268.a1426z@gawab.com> <200704171929.00258.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704171929.00258.a1426z@gawab.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Anyone who thinks that there exists only two kinds of code: 100% correct
>> and 100% incorrect with no shades of grey inbetween is in reality a sort
>> of an extremist: whom, depending on mood and affection, we could call
>> either a 'coding purist' or a 'coding taliban' ;-)

On Tue, Apr 17, 2007 at 07:29:00PM +0300, Al Boldi wrote:
> I am not sure what you mean by this?!?
> It's probably well known that nothing is perfect, even if you tried, but to 
> use this to excuse sub-optimal coding sounds rather lame.
> Now, admitting that everything may be fixable, would have been a much more 
> reasonable response.

I don't need this sort of help. I wasn't even all that interested in
having it acknowledged as a cfs lacuna, but rather a common design goal
across all scheduler implementations with a standardized semantics.

Granted, some of my insistence was intended as a hint about what might
not be working very well, but I was rather far from wanting to suggest
such things, hence the initial avoidance of even mentioning whatever
issues cfs' current incarnation in particular might have directly. I
rather wanted some statement of the eventual intention, along with some
consensus as to what scheduler implementations in general should also
use as their objective for nice semantics. With that in hand, it would
be made possible to track the progress of cfs in that particular area,
and also make direct comparisons against other schedulers attempting to
implement the same prioritization semantics.

A less abstract statement about this would be that I wanted to hear
"This is what should be going on in the area of prioritization in terms
of nice levels. We can get yardsticks to measure how schedulers are
doing in this area from this." How cfs' current implementation did was
a secondary concern apart from using the issue as a hint about what
there might be to patch up. The whole reason for resorting to hints
instead of going on about nice level support being weak directly was
precisely to avoid making the kind of statement you're making. I'm
not in the business of shooting down scheduler implementations. I
furthermore expect cfs to be useful to people regardless of whether
it "pans out" in terms of mainline acceptance, just as many of the
other out-of-tree schedulers are; if it should hit mainline, so be it,
as it's a technical improvement over epoch expiry semantics regardless.

Also, AFAICS honoring nice levels isn't a fundamental issue with the
design. Adjusting the sorting key calculation, which doesn't affect the
overall design at all, should suffice IMHO. This is also quite far from
what you suggest in terms of the gravity of the issue. While I have my
own disagreements with the response, it's best to take it at face value
instead of the sort of interpretation you're doing.


-- wli
