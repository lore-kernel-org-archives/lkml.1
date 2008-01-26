Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbYAZAnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbYAZAnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYAZAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:43:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50748 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbYAZAnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:43:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479A8203.40804@s5r6.in-berlin.de>
Date: Sat, 26 Jan 2008 01:42:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Valdis.Kletnieks@vt.edu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: using LKML for subsystem development (was Re: Linux 2.6.24)
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl> <4799D770.2070203@cateee.net> <479A75D4.6070607@s5r6.in-berlin.de>
In-Reply-To: <479A75D4.6070607@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I already deleted the posting I'm going to reply to, therefore
References and In-Reply-To are wrong.  Sorry.)

On 2008-01-25, Ingo Molnar wrote in http://lkml.org/lkml/2008/1/25/320:
> * Giacomo A. Catenazzi <cate@cateee.net> wrote:
>> As a tester, I'm not so happy.
>> The last few merge windows were a nightmare for us (the tester).
>> It remember me the 2.1.x times, but with few differences:
>> - more changes, so bugs are unnoticed/ignored in the first weeks or
>> - or people are pushing more patches possible, so they delay
>>   bug corrections to later times (after merge windows).
> 
> i think this heavily varies per subsystem.
> 
> v2.6.24-rc was pretty bad due to the sglist design bug that crept in and 
> that kept most of the IO hackers busy for a few weeks, while testsystems 
> kept crashing and no progress was made on _other_ bugs. v2.6.24 early 
> rc's were also marred by half-cooked networking patches messing up 
> bisectability. I've seen a number of testers give up on that alone. 
> There was an unusually high flux of networking fixes throughout v2.6.24, 
> up to the very last day before the release.
> 
> Since it's Friday already, i put the blame for that on all the 
> subsystems that do not develop on lkml! :-)
> 
> It is _very_ hard for us to judge the stability and sanity of a 
> subsystem (and the risk factor of upcoming features!) if it's not 
> developed on lkml. Observing the bugs alone helps in getting a picture, 
> but it does not help the testers of early -rc's:
[...]
> there's way too much 'surprise factor' 
> in the git merges and all the hidden development that is not directly 
> visible on lkml. The 'surprise factor' is not even come mainly from 
> combining all the trees together (that is relatively easy), it is in the 
> cumulative risk factor that is hard to get right due to development not 
> always being done on lkml.
> 
> Case point from arch/x86: everyone who follows lkml could have predicted 
> it from the PAT development discussions that PAT is simply not ready 
> yet. We deferred it to v2.6.26,

The remedy can't just be to Cc: LKML all the time.  This would shift the
burden of directing the "general public's" attention from the domain
experts to the general public.  How will subscribers of LKML decide
which discussion threads in the huge amount of traffic are worth to
glance at?  Each of us has only a limited amount of time for LKML
consumption.

Even if you only look at the Subject: and number of postings in a
thread, how to judge whether there is a stability risk for the next -rc
in the making, without experience or personal interest in the domain?

> but had we tried to cram it into v2.6.25 
> and had it broken boxes left and right, we'd rightfully be confronted 
> with all the existing lkml track record that suggested bad PAT related 
> problems and predicted the outcome. For subsystems that do not develop 
> on lkml, no such lkml track record exists and the danger of introducing 
> bad patches and ruining early -rc's increases.

Having a track record in list archives doesn't prevent bugs from happen,
at least not directly.  It might help to clarify who's responsible, if
the changelog doesn't tell us already, and thus might have a positive
long term effect on quality.  (I work in an industry where it is often
hard to identify responsibilities which IMO contributes to chronic
quality issues in that industry.)

Anyhow, I will try to remember to add a list archive pointer into my
future "what's in abc123-2.6.git" messages, so that those who care can
browse over the topics and threads to get at least a superficial
impression of what went on on the development list behind LKML's back.

(I usually also add Cc: LKML to discussions when I get the feeling that
the expertise and judgment on the development list might not be
sufficient during a respective stage of development --- but of course my
judgment of when to involve LKML isn't objective and perfect.  That is,
I /don't/ claim this to be the best way to handle subsystem development
discussions.)
-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/
