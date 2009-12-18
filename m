Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZLRLGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZLRLGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 06:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZLRLGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 06:06:00 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:65124 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZLRLF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 06:05:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FtytsrR1ZrxkkJ/OBxWWlC/2TMfdOoxAi1hX6HZPiYKk08QBCFXEKP1kurOyHJQp3r
         huT2fvh4slVOOltO6Zf88Ikdm7PbfnX0VIGuf7zNM/XZ+kH/eJNt8hgxzFD/IeClZVau
         NxewwS5EKM+wSNjVf/16/9pS4YdpGZsgtdpzA=
MIME-Version: 1.0
In-Reply-To: <1261133856.14314.39.camel@localhost>
References: <1261042383.14314.0.camel@localhost> <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com> 
	<20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost> 
	<28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com> 
	<20091218052344.GD417@elte.hu> <1261121405.30469.8.camel@marge.simson.net> 
	<1261133856.14314.39.camel@localhost>
From: Jason Garrett-Glaser <darkshikari@gmail.com>
Date: Fri, 18 Dec 2009 03:05:34 -0800
Message-ID: <28f2fcbc0912180305p47468508ybcb2f60cacb66c35@mail.gmail.com>
Subject: Re: x264 benchmarks BFS vs CFS
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 2:57 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> On Fri, 2009-12-18 at 08:30 +0100, Mike Galbraith wrote:
>> On Fri, 2009-12-18 at 06:23 +0100, Ingo Molnar wrote:
>>
>> > Having said that, we generally try to make things perform well without apps
>> > having to switch themselves to SCHED_BATCH. Mike, do you think we can make
>> > x264 perform as well (or nearly as well) under SCHED_OTHER as under
>> > SCHED_BATCH?
>>
>> It's not bad as is, except for ultrafast mode.  START_DEBIT is the
>> biggest problem there.  I don't think SCHED_OTHER will ever match
>> SCHED_BATCH for this load, though I must say I haven't full-spectrum
>> tested.  This load really wants RR scheduling, and wakeup preemption
>> necessarily perturbs run order.
>>
>> I'll probably piddle with it some more, it's an interesting load.
> Yes, i must say, very interresting, its very complicated and... oh wait,
> its just encoding a movie!

Your trolling is becoming a bit over-the-top at this point.  You
should also considering replying to multiple people in one email as
opposed to spamming a whole bunch in sequence.

Perhaps as the lead x264 developer I'm qualified to say that it
certainly is a very complicated load due to the strict ordering
requirements of the threading model--and that you should tone down the
whining just a tad and perhaps read a bit more about how BFS and CFS
work before complaining about them.

Jason
