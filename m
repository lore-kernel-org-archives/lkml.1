Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbXIZIEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbXIZIEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXIZIEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:04:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:44668 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750863AbXIZIEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:04:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/F4xpYrwfFi/2Wsak/+KmjflFNGtyVm5vOqzIMDj
	1STGLNgkwwTAvP
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070925094712.GA29138@elte.hu>
References: <20070924214537.GA18980@elte.hu>
	 <1190700652.6482.7.camel@Homer.simpson.net>
	 <1190705759.11910.10.camel@Homer.simpson.net>
	 <1190709207.11226.6.camel@Homer.simpson.net>
	 <20070925091331.GA22905@elte.hu>
	 <1190711858.13861.10.camel@Homer.simpson.net>
	 <20070925094712.GA29138@elte.hu>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 10:04:29 +0200
Message-Id: <1190793869.3240.14.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 11:47 +0200, Ingo Molnar wrote:

> Maybe there's more to come: if we can get CONFIG_FAIR_USER_SCHED to work 
> properly then your Xorg will have a load-independent 50% of CPU time all 
> to itself. (Group scheduling is quite impressive already: i can log in 
> as root without feeling _any_ effect from a perpetual 'hackbench 100' 
> running as uid mingo. Fork bombs no more.) Will the Amarok gforce plugin 
> like that CPU time splitup? (or is most of the gforce overhead under 
> your user uid?)
> 
> it could also work out negatively, _sometimes_ X does not like being too 
> high prio. (weird as that might be.) So we'll see.

I piddled around with fair users this morning, and it worked well.  With
Xorg and Gforce as one user (X and Gforce are synchronous ATM), and a
make -j30 as another, I could barely tell the make was running.
Watching a dvd, I couldn't tell. Latencies were pretty darn good
throughout three hours of testing this and that.

	-Mike

