Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbYCTTu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbYCTTu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYCTTuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:50:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56964 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYCTTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:50:14 -0400
Date: Thu, 20 Mar 2008 12:49:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       Mike Mason <mmlnx@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       David Smith <dsmith@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/4] Markers - depends on not PREEMPT_RCU
Message-ID: <20080320194941.GD9570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080320002737.918213455@polymtl.ca> <20080320002834.448782178@polymtl.ca> <20080320190335.GA12770@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320190335.GA12770@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 08:03:38PM +0100, Ingo Molnar wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > +++ linux-2.6-lttng/init/Kconfig	2008-03-19 18:27:43.000000000 -0400
> > @@ -742,6 +742,7 @@ config PROFILING
> >  
> >  config MARKERS
> >  	bool "Activate markers"
> > +	depends on !PREEMPT_RCU
> >  	help
> 
> Ugh, NACK. Please solve this properly... What kind of kernel 
> infrastructure is it what disables itself in the presence of another 
> piece of kernel infrastructure?

This is a reminder to me to get going on call_rcu_sched().  Until
I get that done and in, they don't have what they need to work
with preemptable RCU.  :-/

						Thanx, Paul
