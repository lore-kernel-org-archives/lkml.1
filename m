Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbZBFOu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbZBFOu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbZBFOur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:50:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62324 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZBFOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:50:46 -0500
Date: Fri, 6 Feb 2009 09:50:43 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
In-Reply-To: <20090206144609.GB18368@elte.hu>
Message-ID: <alpine.DEB.1.10.0902060950250.10059@gandalf.stny.rr.com>
References: <20090206065352.940088243@goodmis.org> <20090206065437.986292747@goodmis.org> <1233912891.4731.1.camel@laptop> <20090206144609.GB18368@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Feb 2009, Ingo Molnar wrote:

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2009-02-06 at 01:53 -0500, Steven Rostedt wrote:
> > 
> > > This code adds an in_nmi() macro that uses the current tasks preempt count
> > > to track when it is in NMI context. Other parts of the kernel can
> > > use this to determine if the context is in NMI context or not.
> > > 
> > > This code was inspired by the -rt patch in_nmi version that was
> > > written by Peter Zijlstra.
> > 
> > Which in turn I borrowed from Mathieu.
> 
> Steve, could you please fix the attribution?

Is it OK to rebase the branch to do so?

-- Steve

