Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXE3EIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXE3EIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXE3EH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:07:56 -0400
Received: from omta04ps.mx.bigpond.com ([144.140.83.156]:17305 "EHLO
	omta04ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXE3EHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:07:55 -0400
Message-ID: <465CF893.10906@bigpond.net.au>
Date: Wed, 30 May 2007 14:07:47 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: vatsa@in.ibm.com, Kirill Korotaev <dev@sw.ru>,
       Nick Piggin <nickpiggin@yahoo.com.au>, tingy@cs.umass.edu,
       ckrm-tech@lists.sourceforge.net, Balbir Singh <balbir@in.ibm.com>,
       efault@gmx.de, kernel@kolivas.org, linux-kernel@vger.kernel.org,
       tong.n.li@intel.com, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
References: <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <4658DF0F.5020208@bigpond.net.au> <20070529104805.GC31925@holomorphy.com> <465CC0B8.8050507@bigpond.net.au> <20070530024815.GA6909@holomorphy.com>
In-Reply-To: <20070530024815.GA6909@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta04ps.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Wed, 30 May 2007 04:07:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Wed, May 30, 2007 at 10:09:28AM +1000, Peter Williams wrote:
>> So what you're saying is that you think dynamic priority (or its 
>> equivalent) should be used for load balancing instead of static priority?
> 
> It doesn't do much in other schemes, but when fairness is directly
> measured by the dynamic priority, it is a priori more meaningful.
> This is not to say the net effect of using it is so different.

I suspect that while it's probably theoretically better it wouldn't make 
much difference on a real system (probably not enough to justify any 
extra complexity if there were any).  The exception might be on systems 
where there were lots of CPU intensive tasks that used relatively large 
chunks of CPU each time they were runnable which would give the load 
balancer a more stable load to try and balance.  It might be worth the 
extra effort to get it exactly right on those systems.  On most normal 
systems this isn't the case and the load balancer is always playing 
catch up to a constantly changing scenario.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
