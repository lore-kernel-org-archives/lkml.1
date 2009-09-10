Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZIJQdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZIJQdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZIJQdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:33:46 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:29351 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZIJQdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GdJmkbJq4LK1r8zM1ZgmWozvm5f9BdQD/Imx73oDVw1cMfGEH97WcMzoylbRYN8/4c
         A42ZRdETjbxJD/SayMA546eTWo9z1YIfgb3BCejLlKLWnLx3FuLC2GQjWoJudYrBgFSv
         UVaS6Xs2doVGjVYYnRxXzS3aHy62IbwswAnDM=
MIME-Version: 1.0
In-Reply-To: <20090910162611.GA31265@elte.hu>
References: <1252486344.28645.18.camel@marge.simson.net>
	 <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk>
	 <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de>
	 <20090910060824.GF1335@elte.hu>
	 <dda83e780909100902s32f076e7o87cebbbfc40d6dea@mail.gmail.com>
	 <1252598709.7360.0.camel@twins>
	 <dda83e780909100912t45eeeb9cj5179edda565526bc@mail.gmail.com>
	 <20090910162611.GA31265@elte.hu>
Date: Thu, 10 Sep 2009 09:33:37 -0700
Message-ID: <dda83e780909100933q28cd1e06kcbceec53d2c94936@mail.gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Bret Towe <magnade@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nikos Chantziaras <realnc@arcor.de>, Jens Axboe <jens.axboe@oracle.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 9:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Bret Towe <magnade@gmail.com> wrote:
>
>> On Thu, Sep 10, 2009 at 9:05 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Thu, 2009-09-10 at 09:02 -0700, Bret Towe wrote:
>> >>
>> >> thanks to this thread and others I've seen several kernel tunables
>> >> that can effect how the scheduler performs/acts
>> >> but what I don't see after a bit of looking is where all these are
>> >> documented
>> >> perhaps thats also part of the reason there are unhappy people with
>> >> the current code in the kernel just because they don't know how
>> >> to tune it for their workload
>> >
>> > The thing is, ideally they should not need to poke at these.
>> > These knobs are under CONFIG_SCHED_DEBUG, and that is exactly
>> > what they are for.
>>
>> even then I would think they should be documented so people can
>> find out what item is hurting their workload so they can better
>> report the bug no?
>
> Would be happy to apply such documentation patches. You could also
> help start adding a 'scheduler performance' wiki portion to
> perf.wiki.kernel.org, if you have time for that.

time isn't so much the issue but not having any clue as to what any
of the options do
