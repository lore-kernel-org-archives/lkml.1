Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZGWOGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZGWOGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZGWOGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:06:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZGWOGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:06:31 -0400
Date: Thu, 23 Jul 2009 10:06:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various fixes
In-Reply-To: <20090723033514.153354674@goodmis.org>
Message-ID: <alpine.DEB.2.00.0907231005470.20997@gandalf.stny.rr.com>
References: <20090723033514.153354674@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Jul 2009, Steven Rostedt wrote:

> 
> Ingo,
> 
> These two patches are built against my last push, but perhaps these
> should go to 2.6.31. The first one fixes a bug that makes the 
> printk_format file useless (making trace_bprintk useless for binary
> readers). The other is a bug with the way the files may be truncated
> incorrectly.

I may pull these over to urgent. They probably should go into 31.

I'll make another pull request there instead.

Thanks,

-- Steve

> 
> Please pull the latest tip/tracing/core-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core-1
> 
> 
> Steven Rostedt (2):
>       tracing: show proper address for trace-printk format
>       tracing: only truncate ftrace files when O_TRUNC is set
> 
> ----
>  kernel/trace/ftrace.c       |    4 ++--
>  kernel/trace/trace.c        |    2 +-
>  kernel/trace/trace_events.c |    2 +-
>  kernel/trace/trace_printk.c |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> -- 
> 
