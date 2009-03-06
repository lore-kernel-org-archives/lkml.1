Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZCFTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZCFTJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZCFTJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:09:24 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:55329 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbZCFTJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:09:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ekxiMgRnyyM24WpSK3+YHciBxG9f4xsxcWoOU2vTZwmtxPN7oQCX0SZuw1ct/LFiei
         meH4zjiQciM8FnCJ4h008vIKJwlwlOmyDhMZ5OqiEnmNKmlAgJHjrD4knpb1IRfO8k8n
         QFv67fvNOYdawJBuYLn+RsQp/mc4KkZ5fZmX8=
Date: Fri, 6 Mar 2009 20:09:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/5 v3] tracing/core: drop the old ftrace_printk
	implementation in favour of ftrace_bprintk
Message-ID: <20090306190917.GD7329@nowhere>
References: <1236356510-8381-1-git-send-email-fweisbec@gmail.com> <1236356510-8381-5-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903061146000.23248@gandalf.stny.rr.com> <20090306170222.GA11285@elte.hu> <20090306171413.GB32128@elte.hu> <alpine.DEB.2.00.0903061302210.23248@gandalf.stny.rr.com> <20090306184904.GA24571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306184904.GA24571@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 07:49:04PM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Fri, 6 Mar 2009, Ingo Molnar wrote:
> > > > 
> > > > i've put them into a separate branch forked off 
> > > > tip:tracing/ftrace: tip:tracing/printk. The two vsprintf 
> > > > patches are in tip:core/printk and merged into tracing/ftrace.
> > > > 
> > > > You can thus apply your current enhancements without any 
> > > > interaction with me - and merge tracing/printk into the 
> > > > tip:tracing/ftrace branch on your own schedule, ok?
> > > 
> > > ah - i misunderstood - i see that it interacts with your commits 
> > > from last night.
> > > 
> > > I've excluded tip:tracing/printk from tip:master for now and 
> > > will let you guys fix it up when you have time for it.
> > 
> > Ingo,
> > 
> > It compiles fine. Only a new item in the struct was added, nothing was 
> > removed. It just prints out a bit funny ;-)
> > 
> > You can go ahead and merge it into tracing/ftrace, and then I 
> > can work with that to fix up the formatting.
> 
> triggers this build failure on certain configs:
> 
> kernel/trace/trace.c:1205: error: implicit declaration of function 'vbin_printf'
> kernel/trace/trace_output.c:64: error: implicit declaration of function 'bstr_printf'
> 
> so i've excluded it from tip:master again for now.
> 
> 	Ingo


This is weird. Can you send me one of these configs please?

