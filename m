Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZCEPAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZCEPAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZCEPAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:00:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbZCEPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:00:05 -0500
Date: Thu, 5 Mar 2009 10:00:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: prasad@linux.vnet.ibm.com, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 11/11] ftrace plugin for kernel symbol tracing using HW
 Breakpoint interfaces
In-Reply-To: <20090305063703.GB5359@nowhere>
Message-ID: <alpine.DEB.2.00.0903050959260.26101@gandalf.stny.rr.com>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305044333.GM17747@in.ibm.com> <20090305063703.GB5359@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 5 Mar 2009, Frederic Weisbecker wrote:
> >  
> > +struct trace_ksym {
> > +	struct trace_entry	ent;
> > +	struct hw_breakpoint	*ksym_hbkpt;
> > +	unsigned long		ksym_addr;
> > +	unsigned long		ip;
> > +	pid_t			pid;
> 
> 
> Just a doubt here.
> The current pid is automatically recorded on trace_buffer_lock_reserve()
> (or unlock_commit, don't remember), so if this pid is the current one, you
> don't need to reserve a room for it, current pid is on struct trace_entry.

Heh, I guess I should have read the rest of the thread before replying.
Frederic beat me to it ;-)

-- Steve
