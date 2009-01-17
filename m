Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbZAQBbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbZAQBbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 20:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZAQBa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 20:30:59 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:17271 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbZAQBa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 20:30:58 -0500
Subject: Re: [PATCH 0/2] ftrace: updates to tip
From: Chris Mason <chris.mason@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090116222600.GA3899@elte.hu>
References: <20090116004050.273665842@goodmis.org>
	 <1232142467.5090.19.camel@think.oraclecorp.com>
	 <20090116222600.GA3899@elte.hu>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 20:30:32 -0500
Message-Id: <1232155832.5090.29.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.497134BC.0041:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 23:26 +0100, Ingo Molnar wrote:
> * Chris Mason <chris.mason@oracle.com> wrote:

> > 
> > The short version is: thanks Steve, this is really cool!
> > 
> > 12058 hits: 
> >  <= check_preempt_wakeup
> >  <= try_to_wake_up
> >  <= wake_up_process
> >  <= __mutex_unlock_slowpath
> >  <= mutex_unlock
> >  <= btrfs_tree_unlock
> >  <= unlock_up
> >  ===========
> 
> Cool! We've got scripts/tracing/ [with one Python script in it already] - 
> so if this is tidied up to be generally useful we could put it there.
> 

For it to be generally useful I think it would need a way to pull out
the marker for which function is the start of the stack trace.  Some
parse friendly tags would be great.

Other than that I'd add some magic to actually start the tracing for a
given function.  Are there other things people would like it to do?

> The other thing is that there's the statistics framework of ftrace, being 
> worked on by Frederic and Steve. That tries to handle and provide 
> higher-order summaries/"views" of plain traces, like histograms and counts 
> - provided by the kernel.

Ok, I tried to keep it simple because I was hoping others had plans as
well ;)

> 
> Maybe the above type of multi-dimensional-stack-trace based histogram 
> could fit into the statistics framework too?

I'd hope so, just a question of how to keep it clear and usable.

-chris


