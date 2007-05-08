Return-Path: <linux-kernel-owner+w=401wt.eu-S967758AbXEHEEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967758AbXEHEEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 00:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967754AbXEHEE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 00:04:29 -0400
Received: from ozlabs.org ([203.10.76.45]:54013 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967752AbXEHEE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 00:04:28 -0400
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with
	naughty	realtime	processes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <874pmoro1c.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
	 <1178545373.28438.7.camel@localhost.localdomain>
	 <877irkrq8a.wl%takeuchi_satoru@jp.fujitsu.com>
	 <1178593345.28438.29.camel@localhost.localdomain>
	 <874pmoro1c.wl%takeuchi_satoru@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 08 May 2007 14:04:06 +1000
Message-Id: <1178597046.28438.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 12:29 +0900, Satoru Takeuchi wrote:
> At Tue, 08 May 2007 13:02:25 +1000,
> Rusty Russell wrote:
> > We used to be able to create kernel threads higher than any userspace
> > priority.  If this is no longer true, I think that's OK: equal priority
> > still means we'll get scheduled, right?
> 
> IF SCHED_RR, yes. However, if SCHED_FIFO, no. Such process doen't have timeslice
> and only relinquish CPU time voluntarily.
> 
> # Hence this problem is complicated ;-(

OK, well, I agree with "don't do that" then 8)

Thanks,
Rusty.

