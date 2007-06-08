Return-Path: <linux-kernel-owner+w=401wt.eu-S967312AbXFHPA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967312AbXFHPA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbXFHPAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:00:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33274 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968AbXFHPAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:00:14 -0400
Date: Fri, 8 Jun 2007 08:00:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT] convert RCU Preempt tasklet into softirq.
Message-ID: <20070608150010.GA24579@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1181180051.18444.31.camel@localhost.localdomain> <20070607041411.GB1783@linux.vnet.ibm.com> <1181226138.18444.54.camel@localhost.localdomain> <20070607161754.GA11941@linux.vnet.ibm.com> <1181240819.10408.14.camel@localhost.localdomain> <1181242307.10408.17.camel@localhost.localdomain> <1181247369.10408.20.camel@localhost.localdomain> <20070608041651.GA19912@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608041651.GA19912@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 09:16:51PM -0700, Paul E. McKenney wrote:
> On Thu, Jun 07, 2007 at 04:16:09PM -0400, Steven Rostedt wrote:
> > On Thu, 2007-06-07 at 14:51 -0400, Steven Rostedt wrote:
> > 
> > > There might still be an issue here. With the patch I'm getting a really
> > > slow response time on networking. But that be because of other patches I
> > > have applied.
> > 
> > I removed this patch and I can still get the network slowdown/hang. So
> > this patch is unrelated to this issue. RCU on the otherhand has not been
> > cleared of suspicion.
> 
> Might the slowdown be due to different kernel threads running at different
> priorities?  I could easily believe that changing the priority of the
> kernel thread processing RCU callbacks could have a noticeable effect
> on performance in some cases.
> 
> In other news, passed a set of kernbenches at this end, so starting
> an rcutorture.

And rcutorture passed 8 hours on a 4-CPU Opteron box.

							Thanx, Paul
