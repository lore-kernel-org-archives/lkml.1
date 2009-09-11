Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbZIKJ01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbZIKJ01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZIKJ00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:26:26 -0400
Received: from lo.gmane.org ([80.91.229.12]:37554 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbZIKJ00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:26:26 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mat <jackdachef@gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Fri, 11 Sep 2009 09:26:05 +0000 (UTC)
Message-ID: <loom.20090911T111945-871@post.gmane.org>
References: <20090906205952.GA6516@elte.hu> <200909102239.48750.Martin@lichtvoll.de> <20090910204252.GA28230@elte.hu> (sfid-20090910_225409_920256_CA47A016) <200909102319.36524.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 78.43.145.83 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.2) Gecko/20090910 Firefox/3.5.2)
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


