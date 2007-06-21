Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXFUPtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXFUPtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbXFUPtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:49:06 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57351 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbXFUPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:49:05 -0400
Message-ID: <467A9DE6.4010505@s5r6.in-berlin.de>
Date: Thu, 21 Jun 2007 17:48:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: How to improve the quality of the kernel?
References: <200706180141.41101.a1426z@gawab.com> <200706180655.47998.a1426z@gawab.com> <20070620213419.GI12950@stusta.de> <200706210626.20429.a1426z@gawab.com>
In-Reply-To: <200706210626.20429.a1426z@gawab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Adrian Bunk wrote:
>> On Mon, Jun 18, 2007 at 06:55:47AM +0300, Al Boldi wrote:
>> > Michal Piotrowski wrote:
>> > > On 18/06/07, Al Boldi <a1426z@gawab.com> wrote:
>> > > > Bartlomiej Zolnierkiewicz wrote:

[on the tracking of review status of patches]

>> > > > > however we need to educate each and every developer
>> > > > > about importance of the code review and proper recognition of
>> > > > > reviewers.
>> > > >
>> > > > That's as easy to manage as is currently done with rc-regressions.
>> > >
>> > > Are you a volunteer?
>> >
>> > Probably not, as this task requires a real PRO!
>> >...
>>
>> That's wrong.
>>
>> We are talking about _tracking_.
>>
>> I'm not sure whether it makes much sense, and it would cost an enormous
>> amount of time, but tracking patches should be possible without any
>> knowledge of the kernel.

I suspect you are...

> If that's really true, which I can't imagine, then the proper way forward 
> would probably involve a fully automated system.

...both wrong --- because patches have varying requirements WRT review
and testing.

What you discuss here under the label "patch tracking" blends into, how
shall I call it, "patch handling" as done by maintainers.  Neither a
layman nor an automaton is able to
  1. measure required vs. accomplished review and testing of a patch,
  2. recruit reviewers and testers.

And IMO *these* two are the points where we typically fail.  We
occasionally underestimate the required amount of review and testing,
but more importantly, we are chronically short of reviewers and
partially of testers.  (Hmm, I think Adrian and one or another guy
already said as much.)

A "Reviewed-by" tag in a patch is not a simple hard fact.  Neither a
layman nor an automaton can draw appropriate conclusions from it.  That
doesn't mean I'm against such tags, on the contrary.  They may help us
to (a) look harder for review, (b) have a better picture of actual lack
of review, patch by patch, subsystem by subsystem, and (c) get more
volunteer reviewers by emphasizing the merits of code review.  Alas,
experience and broad knowledge in kernel development are certainly
prerequisites to become a good reviewer, so don't get high hopes that
reviewers will suddenly come in droves when we appropriately credit
their work.
-- 
Stefan Richter
-=====-=-=== -==- =-=-=
http://arcgraph.de/sr/
