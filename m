Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZCZXO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZCZXO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZCZXOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:14:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZCZXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:14:18 -0400
Date: Thu, 26 Mar 2009 19:14:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] tracing: add average time in function to function
 profiler
In-Reply-To: <20090327091507.f133257e.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.0903261910470.28807@gandalf.stny.rr.com>
References: <20090326010737.611522983@goodmis.org> <20090326010811.510051401@goodmis.org> <20090327091507.f133257e.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Mar 2009, Stephen Rothwell wrote:

> Hi Steve,
> 
> On Wed, 25 Mar 2009 21:07:39 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Show the average time in the function (Time / Hit)
> 
> Just wondering why we need to do this in the kernel ... there is already
> enough information for a user to figure these averages out.

I also plan on adding a profiler_option file to let you sort by Hit, Time, 
or Avg. I'm working on a project at the University that would like to see 
that. Yes, it can be done by userspace too, but it is very simple to do in 
the kernel (just pick what to sort by since it already has the sorting 
algorithm). Userspace, can do it, but it is much more clumsy at it.

-- Steve

