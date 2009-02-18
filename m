Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZBRBbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZBRBbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZBRB3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:29:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47591 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbZBRB3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:29:41 -0500
Date: Tue, 17 Feb 2009 20:29:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 6/6] ftrace: show unlimited when traceon or traceoff has
 no counter
In-Reply-To: <20090217182126.214630484@goodmis.org>
Message-ID: <alpine.DEB.1.10.0902172028540.14430@gandalf.stny.rr.com>
References: <20090217182048.233060814@goodmis.org> <20090217182126.214630484@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Feb 2009, Steven Rostedt wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: clean up
> 
> The traceon and traceoff function probes are confusing to developers
> to what happens when a counter is not specified. This should help
> clear things up.
> 
>  # echo "*:traceoff" > set_ftrace_filter

Silly cut and paste error. That should have been:

  # echo "do_fork:traceoff" > set_ftrace_filter

Oh well.

-- Steve

>  # cat /debug/tracing/set_ftrace_filter
> 
>   #### all functions enabled ####
>   do_fork:traceoff:unlimited
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
