Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572Ab0AIAUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0AIAUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382Ab0AIAUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:20:48 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38575 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0AIAUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:20:47 -0500
Date: Fri, 8 Jan 2010 16:20:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100109002043.GD6816@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com> <20100107183946.GL6764@linux.vnet.ibm.com> <1262890782.28171.3738.camel@gandalf.stny.rr.com> <20100107191657.GN6764@linux.vnet.ibm.com> <1262893243.28171.3753.camel@gandalf.stny.rr.com> <20100107205830.GR6764@linux.vnet.ibm.com> <1262900140.28171.3773.camel@gandalf.stny.rr.com> <20100108235338.GA18050@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108235338.GA18050@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 06:53:38PM -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > Well, if we just grab the task_rq(task)->lock here, then we should be
> > OK? We would guarantee that curr is either the task we want or not.
> 
> Hrm, I just tested it, and there seems to be a significant performance
> penality involved with taking these locks for each CPU, even with just 8
> cores. So if we can do without the locks, that would be preferred.

How significant?  Factor of two?  Two orders of magnitude?

							Thanx, Paul
