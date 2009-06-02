Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZFBMv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZFBMv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZFBMvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:51:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZFBMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:51:51 -0400
Date: Tue, 2 Jun 2009 08:51:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/10] [GIT PULL] tracing: various updates
In-Reply-To: <20090602092840.GA10421@elte.hu>
Message-ID: <alpine.DEB.2.00.0906020842020.14994@gandalf.stny.rr.com>
References: <20090602044315.439593107@goodmis.org> <20090602083043.GC12411@elte.hu> <20090602092840.GA10421@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Jun 2009, Ingo Molnar wrote:

> 
> -tip testing found this build failure:
> 
> kernel/trace/trace.h: In function ?ftrace_trace_task?:
> kernel/trace/trace.h:605: error: implicit declaration of function ?test_tsk_trace_trace?
> 
> I suspect one of the Kconfig changes/cleanups. Config attached.

What branch? The config does not apply well to either master or 
tracing/ftrace.

I compiled it on both branches here and it worked fine. But I had to 
disable the LZMA compression because I don't have that, and I had to 
select the default choices, since the config does not match the options.

-- Steve
