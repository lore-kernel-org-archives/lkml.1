Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbZBYQN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbZBYQN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZBYQNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:13:17 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:55998 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZBYQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pPQSSZMO8whqtLhI8NjAYmMFXwkd7RVDFc2fYKVae5VbAkr/Nv/yz6sm32zXKyMzpr
         SnB0l2El7zej80/3FHZ0BlTcgFRY6ZV5Y8/e1PHGYBkTS6PE+vX0V+9wk21Z0RKIdtR7
         pnx+o6mM8wtUwHMS7OnFd+q0D4oJn0hKjvwOM=
Date: Wed, 25 Feb 2009 17:13:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] tracing/core: introduce per cpu tracing files
Message-ID: <20090225161309.GA5862@nowhere>
References: <49a4e2c1.0508d00a.21e6.2eea@mx.google.com> <20090225130202.GH26273@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225130202.GH26273@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 02:02:02PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: split up tracing output per cpu
> 
> > So this patch creates a new directory inside /debug/tracing 
> > (provided you have a debugfs mountpoint on /debug). Inside 
> > this directory, you will now find one trace_pipe file, one 
> > trace file and one latency_trace file per cpu. Which means if 
> > you have two cpus, you will have:
> > 
> > trace0
> > trace1
> > trace_pipe0
> > trace_pipe1
> 
> Very nice! I've applied your patches to tip:tracing/ftrace.
> 
> Could you please do one more tweak? The /debug/tracing/per_cpu/ 
> directory looks a bit cluttered on a 16-way box. It would be a 
> nicer structure to have per CPU directories, i.e.:
> 
>  /debug/tracing/per_cpu/cpu0/trace
>  /debug/tracing/per_cpu/cpu0/trace_pipe
>  /debug/tracing/per_cpu/cpu1/trace
>  /debug/tracing/per_cpu/cpu1/trace_pipe
> 
> etc.

Ah right, the only SMP machine I have has two CPU so I didn't
think about that.

> 
> Besides being easier to handle, this also makes it easy to 
> extend the list of per CPU attributes as well, without 
> cluttering the /debug/tracing/per_cpu/ directory.
> 
> 	Ingo


You're right, I will change that.

Thanks.

