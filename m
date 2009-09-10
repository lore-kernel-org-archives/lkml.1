Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbZIJQNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbZIJQNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZIJQMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:12:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:52391 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZIJQMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hOvXsPk+O7GBQbDt2EgkQWJrYNPziqNO+A+Ngx4NxcKxtWtlc2Efldf962Z75YmY4b
         /nlCJ/v/J7PoutmxMacDg3LuagZVcsA0g2F7+Hg9udqLsV7uHqO62rKm3pjDDsw9AV3P
         UP8jVxcOFFHmUwgneEm10Wg013kcgO/ouN/JA=
MIME-Version: 1.0
In-Reply-To: <1252598709.7360.0.camel@twins>
References: <20090908091304.GQ18599@kernel.dk>
	 <1252486344.28645.18.camel@marge.simson.net>
	 <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk>
	 <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu>
	 <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu>
	 <dda83e780909100902s32f076e7o87cebbbfc40d6dea@mail.gmail.com>
	 <1252598709.7360.0.camel@twins>
Date: Thu, 10 Sep 2009 09:12:11 -0700
Message-ID: <dda83e780909100912t45eeeb9cj5179edda565526bc@mail.gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Bret Towe <magnade@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Nikos Chantziaras <realnc@arcor.de>,
       Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 9:05 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2009-09-10 at 09:02 -0700, Bret Towe wrote:
>>
>> thanks to this thread and others I've seen several kernel tunables
>> that can effect how the scheduler performs/acts
>> but what I don't see after a bit of looking is where all these are
>> documented
>> perhaps thats also part of the reason there are unhappy people with
>> the current code in the kernel just because they don't know how
>> to tune it for their workload
>
> The thing is, ideally they should not need to poke at these. These knobs
> are under CONFIG_SCHED_DEBUG, and that is exactly what they are for.

even then I would think they should be documented so people can find out
what item is hurting their workload so they can better report the bug no?

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
