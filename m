Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZIKKKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZIKKKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 06:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZIKKKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 06:10:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64700 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZIKKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 06:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=kEtqb0zZNDxGnFU/x4SwnzrS/gFzh9U3+qzFLagkVyt+sijl1DIC5w3W5OE2sMOMJW
         Xtflp4oBJEnc5Euha8jWU0ccVswl7UpL4QXS38b8+I+p1Erdu1xnXnyRWIZmHUZnP8ZC
         TBjMH/9TfKlzoT8eHTWuCQCSio2DtaQ8KKM7Q=
MIME-Version: 1.0
Date: Fri, 11 Sep 2009 12:10:16 +0200
Message-ID: <e85b9d30909110310w210fd154k17544bf4d78a0df8@mail.gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Mat <jackdachef@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Martin@lichtvoll.de
Cc: Jens Axboe <jens.axboe@oracle.com>, a.p.zijlstra@chello.nl,
       Nikos Chantziaras <realnc@arcor.de>, efault@gmx.de,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald <Martin <at> lichtvoll.de> writes:

>
> Am Donnerstag 10 September 2009 schrieb Ingo Molnar:

[snip]

> > what is /debug/sched_features - is NO_NEW_FAIR_SLEEPERS set? If not
> > set yet then try it:
> >
> >   echo NO_NEW_FAIR_SLEEPERS > /debug/sched_features
> >
> > that too might make things more fluid.

Hi Martin,

it made an tremendous difference which still has to be tested out :)

Hi Ingo,

which adverse effect could

cat /proc/sys/kernel/sched_wakeup_granularity_ns
0

have on the throughput ?

Concerning that "NO_NEW_FAIR_SLEEPERS" switch - isn't it as easy as to

do the following ? (I'm not sure if there's supposed to be another debug)

echo NO_NEW_FAIR_SLEEPERS > /sys/kernel/debug/sched_features

which after the change says:

cat /sys/kernel/debug/sched_features
NO_NEW_FAIR_SLEEPERS NO_NORMALIZED_SLEEPER ADAPTIVE_GRAN WAKEUP_PREEMPT
START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY SYNC_WAKEUPS NO_HRTICK NO_DOUBLE_TICK
ASYM_GRAN LB_BIAS LB_WAKEUP_UPDATE ASYM_EFF_LOAD NO_WAKEUP_OVERLAP LAST_BUDDY
OWNER_SPIN

I hope that's the correct switch ^^

Greetings and please keep on improving the scheduler (especially with regards to
the desktop crowd)

Regards

Mat


(Sorry for the "double-post" - this one is including all of the CC
which GMane left out :) )
