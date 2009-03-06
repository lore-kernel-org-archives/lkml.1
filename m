Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZCFT62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZCFT62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZCFT6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:58:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZCFT6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:58:18 -0500
Subject: Re: [Patch] mm tracepoints
From: Larry Woodman <lwoodman@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <20090306180154.GA20292@elte.hu>
References: <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com>
	 <20090306105627.3EF0.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com>
	 <20090306110423.GD21168@elte.hu>
	 <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com>
	 <20090306135547.GB21907@elte.hu>
	 <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com>
	 <20090306171016.GA32128@elte.hu> <1236361106.6326.595.camel@laptop>
	 <1236362197.6326.615.camel@laptop>  <20090306180154.GA20292@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 15:01:49 -0500
Message-Id: <1236369709.1476.86.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 19:01 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2009-03-06 at 18:38 +0100, Peter Zijlstra wrote:
> > > On Fri, 2009-03-06 at 18:10 +0100, Ingo Molnar wrote:
> > > > Looks pretty good and useful to me. I've Cc:-ed more mm folks, 
> > > > it would be nice to hear their opinion about these tracepoints.
> > > > 
> > > > Andrew, Nick, Peter, what do you think?
> > > 
> > > Bit sad we use the struct mm_struct * as mm identifier (little %lx vs %p
> > > confusion there too), but I suppose there simply isn't anything better.
> > 
> > > Things missing, 
> > 
> > Why only anon and filemap, that misses out on all the funky 
> > driver ->fault() handlers.
> 
> btw., does it include shm faults? I think all of this would be 
> handled if the tracepoint was at handle_mm_fault(), right?

The problem with this approach is you cant tell what kind of fault is
being encountered and how it will be handled until you are way down in
the functions that I added the tracepoints in...

The value of these tracepoint is the data you get from they are
currently located.

Larry

> 
> 	Ingo

