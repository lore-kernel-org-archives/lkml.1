Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbXHFDUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbXHFDUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 23:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXHFDUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 23:20:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33475 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXHFDUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 23:20:36 -0400
Date: Sun, 5 Aug 2007 20:20:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RT] put in a relatively high number for rcu read lock upper limit.
Message-ID: <20070806032031.GE13916@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1186289484.636.5.camel@localhost.localdomain> <1186290332.636.8.camel@localhost.localdomain> <20070805065948.GB515@elte.hu> <Pine.LNX.4.58.0708051019560.8421@gandalf.stny.rr.com> <20070805150449.GA19418@linux.vnet.ibm.com> <1186328100.636.19.camel@localhost.localdomain> <20070805175310.GB3244@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805175310.GB3244@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 07:53:10PM +0200, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Paul and Ingo,
> > 
> > Should we just remove the upper limit check, or is something like this 
> > patch sound?
> 
> i've changed the limit to 30 (the same depth limit is used by lockdep).
> 
> beyond that we could get stack overflow, etc.

Works for me!

						Thanx, Paul
