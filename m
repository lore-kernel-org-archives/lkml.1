Return-Path: <linux-kernel-owner+w=401wt.eu-S933132AbXLMVKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbXLMVKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbXLMVKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:10:06 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:38585 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959AbXLMVKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:10:01 -0500
Date: Fri, 14 Dec 2007 02:39:36 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 0/6] RCU: Preemptible-RCU
Message-ID: <20071213210936.GB7304@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071213170348.GA25981@in.ibm.com> <Pine.LNX.4.58.0712131230220.3369@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0712131230220.3369@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve, 

On Thu, Dec 13, 2007 at 12:36:47PM -0500, Steven Rostedt wrote:
> On Thu, 13 Dec 2007, Gautham R Shenoy wrote:
> 
> >
> > Currently it is based against the latest linux-2.6-sched-devel.git
> >
> > Awaiting your feedback!
> 
> Hi Gautham,
> 
> Thanks for posting this. I believe this is the same version of preempt RCU
> as we have in the RT patch. It seems to be very stable. I ran the RT patch
> version of the RCU Preempt (just the Preempt RCU patches without RT on
> latest git) on a 64way box and the results seems just as good (if not
> slightly better) than classic RCU!  I'll rerun this patch series on that
> box and post the results.

The version of synchronize_sched() that's implemented in this patchset
requires these CPU-Hotplug patches -->
http://lkml.org/lkml/2007/11/15/239.

This is the reason why I rebased it against linux-2.6-sched-devel.git
since it already has those patches.

> 
> >From what I'm seening with this, is that it is ready for mainline. These
> patches should probably go into -mm and be ready for 2.6.25.  If Andrew
> wants to wait for my results, I'll run them tonight.
> 
> Thanks Gautham, Paul and Dipankar for all this great work!
> 

Anytime! That probably the only way I could teach myself how RCU works!

> -- Steve
> 

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
