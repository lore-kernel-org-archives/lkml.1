Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZCFTTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZCFTTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZCFTTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:19:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36200 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbZCFTTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:19:08 -0500
Subject: Re: [Patch] mm tracepoints
From: Larry Woodman <lwoodman@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090306171016.GA32128@elte.hu>
References: <1233306324.11332.11.camel@nigel-laptop>
	 <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com>
	 <20090306105627.3EF0.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com>
	 <20090306110423.GD21168@elte.hu>
	 <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com>
	 <20090306135547.GB21907@elte.hu>
	 <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com>
	 <20090306171016.GA32128@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 14:22:00 -0500
Message-Id: <1236367320.1476.82.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 18:10 +0100, Ingo Molnar wrote:
> * Larry Woodman <lwoodman@redhat.com> wrote:
> 
> > > Would that be useless or controversial? We know from 
> > > vma->mapping which inode it maps to. Knowing which file is 
> > > faulting in can be useful - especially when addresses are a 
> > > moving target such as under PIE or with dlopen(), etc.
> > > 
> > > 	Ingo
> > 
> > Attached is the updated patch that applies and builds 
> > correctly (sorry I missed the lockdep tracepoints that were 
> > added at the last minute). [...]
> 
> Looks pretty good and useful to me. I've Cc:-ed more mm folks, 
> it would be nice to hear their opinion about these tracepoints.
> 
> Andrew, Nick, Peter, what do you think?
> 
> About the motivation of these tracepoints: i suspect these 
> tracepoints reflect your years-long experience in dealing with 
> various MM regressions in the enterprise space and these 
> tracepoints would help understand such regressions 
> faster/easier?

Exactly, and without running some "debug enhanced kernel".

> 
> > [...]  As far as the filename:offset is concerned I am working 
> > on that.  Its not as simple as it looks because we have to 
> > follow a variable list of structs that can be null terminated 
> > several places along the way.
> 
> It's definitely not simple! I dont think it should be in this 
> base patch at all - it should be an add-on.
> 
> 	Ingo

