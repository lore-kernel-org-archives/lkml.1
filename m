Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZBQPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZBQPMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZBQPL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:11:59 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42336 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZBQPL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:11:59 -0500
Date: Tue, 17 Feb 2009 07:11:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090217151156.GC6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090216095059.GL6182@elte.hu> <87hc2u61e9.fsf@free.fr> <20090216122632.GA3158@elte.hu> <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com> <20090216200923.GA28938@elte.hu> <20090216223944.GF6785@linux.vnet.ibm.com> <20090217061142.GA5316@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217061142.GA5316@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 07:11:42AM +0100, Damien Wyart wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2009-02-16 14:39]:
> > What is the easiest way for me to make it easy to trace the return path
> > from __rcu_pending()?  Make each return path call an empty function
> > located off where the compiler cannot see it, I guess...  Diagnostic
> > patch along these lines below.  Frederic, Damien, could you please give
> > it a go?  (And of course please let me know if something else is
> > needed.)
> 
> As Frederic already sent a trace (made with another method), I'll
> consider for now mine would not be very useful at this stage, so I'm
> waiting for further instructions.
> 
> If you need further testing for me, do not hesitate to ask...

I would be very interested to hear whether or not my patch removing
rcu_pending() and rcu_check_callbacks() from the x86_32 idle loop
fixes the problem for you.

						Thanx, Paul
