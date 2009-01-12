Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZALCAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZALCAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 21:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZALB75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:59:57 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55477 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZALB74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:59:56 -0500
Date: Sun, 11 Jan 2009 17:59:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] rcu: convert rcupreempt trace to seq file
Message-ID: <20090112015954.GC6864@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <496852DE.7080802@cn.fujitsu.com> <20090110223151.GD7061@linux.vnet.ibm.com> <20090111013940.GL12885@elte.hu> <20090111050129.GA6131@nowhere> <20090111051604.GF7061@linux.vnet.ibm.com> <496A982E.3020103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496A982E.3020103@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 09:09:02AM +0800, Li Zefan wrote:
> >> The debugfs and seqfile handling and handled in the statistical
> >> tracing engine.
> >>
> >> You just have to provide an iterator for your stat entries through two callbacks:
> >>
> >> _ stat_start() -> gives the first entry
> >> _ stat_next() -> iterates over the next entry
> >>
> >> And an output callback
> >>
> >> _ stat_show() -> print one entry from your stat list
> >>
> >> And two optional things:
> >>
> >> _ stat_cmp() -> compare two entries, useful if you want your stats to be sorted
> >> _ stat_headers() -> provide the first line in your stat file, typically to describe your columns
> >>
> >> The last thing you need is to give a name to your trace file.
> >> You will retrieve it into /debugfs/tracing/trace_stat/your_file_name as a current snapshot
> >> of your stats.
> >>
> >> It is currently used by the branch tracer, and by a pending patch for a new workqueue
> >> tracer which will provide you a simple example.
> >>
> >> If you have any question about how to use it, don't hesitate to ask.
> > 
> > Li Zefan, is this something you would be willing to try?  Sounds like
> > it might be a good addition.
> 
> Sure, I'll try. :)

Very cool!  I look forward to seeing it!!!

							Thanx, Paul
