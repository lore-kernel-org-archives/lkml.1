Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbXIZL3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbXIZL3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXIZL3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:29:42 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:4253 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbXIZL3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:29:41 -0400
Date: Wed, 26 Sep 2007 13:29:19 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926112919.GN3337@deprecation.cyrius.com>
References: <20070926085202.GE3337@deprecation.cyrius.com> <1190802208.7318.5.camel@Homer.simpson.net> <20070926104814.GM3337@deprecation.cyrius.com> <20070926112137.GA13876@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926112137.GA13876@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2007-09-26 13:21]:
> > > I noticed on the iperf website a patch which contains sched_yield().
> > > http://dast.nlanr.net/Projects/Iperf2.0/patch-iperf-linux-2.6.21.txt
> 
> great! Could you try this too:
>    echo 1 > /proc/sys/kernel/sched_compat_yield
> 
> does it fix iperf performance too (with the yield patch applied to
> iperf)?

Yes, this gives me good performance too.

> I think the real fix would be for iperf to use blocking network IO
> though, or maybe to use a POSIX mutex or POSIX semaphores.

So it's definitely not a bug in the kernel, only in iperf?

(CCing Stephen Hemminger who wrote the iperf patch.)
-- 
Martin Michlmayr
http://www.cyrius.com/
