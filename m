Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZHGAEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZHGAEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 20:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbZHGAEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 20:04:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607AbZHGAEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 20:04:38 -0400
Date: Thu, 6 Aug 2009 20:04:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Josh Triplett <josh@joshtriplett.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: Add vim script to enable folding for function_graph
 traces
In-Reply-To: <20090806145701.GB7661@feather>
Message-ID: <alpine.DEB.2.00.0908062004170.2840@gandalf.stny.rr.com>
References: <20090806145701.GB7661@feather>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Aug 2009, Josh Triplett wrote:

> function_graph traces look like nested function calls, complete with
> braces denoting the start and end of functions.  function-graph-fold.vim
> teaches vim how to fold these functions, to make it more convenient to
> browse them.
> 
> To use, :source function-graph-fold.vim while viewing a function_graph
> trace, or use "view -S function-graph-fold.vim some-trace" to load it
> from the command-line together with a trace.  You can then use the usual
> vim fold commands, such as "za", to open and close nested functions.
> While closed, a fold will show the total time taken for a call, as would
> normally appear on the line with the closing brace.  Folded functions
> will not include finish_task_switch(), so folding should remain
> relatively sane even through a context switch.
> 
> Note that this will almost certainly only work well with a single-CPU
> trace (e.g. trace-cmd report --cpu 1).  It also takes some time to run
> (a few seconds for a large trace on my laptop).  Nevertheless, I found
> it very handy to get an overview of a trace and then drill down on
> problematic calls.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Thanks Josh,

I queued it up for 32.

-- Steve
