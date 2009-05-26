Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZEZWZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZEZWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758836AbZEZWWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:55 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46203 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826AbZEZWWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EhxD8tZ7Vq/2T4yVGtVhu8tlmoZtKskt9PTDwf+jpoQtgjn6p7hMeS0LlLE+gpNy12
         N9GBVBG6hCZuBNGBkMux5CXk9mE9Ayn9HbnZqQ6MCctPAg0H6Ll868N20iKQzs8RYK0K
         JhA42cY8iOCPyW73N6VUOeYUZvwLAEitdciuU=
Date: Wed, 27 May 2009 00:22:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL v2][PATCH 0/10] tracing/core: various fixes
Message-ID: <20090526222251.GH5969@nowhere>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com> <20090526185524.GB5969@nowhere> <alpine.DEB.2.00.0905261730180.26705@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905261730180.26705@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 05:30:43PM -0400, Steven Rostedt wrote:
> 
> On Tue, 26 May 2009, Frederic Weisbecker wrote:
> > Steven Rostedt (5):
> >       tracing: add __print_flags for events
> >       tracing: add previous task state info to sched switch event
> >       tracing: add flag output for kmem events
> >       tracing: add __print_symbolic to trace events
> >       tracing: convert irq events to use __print_symbolic
> > 
> > Zhaolei (2):
> >       ftrace: Add task_comm support for trace_event
> >       ftrace: clean up of using ftrace_event_enable_disable()
> 
> BTW, these are in tip/tracing/ftrace :-/


Yes. I prepared the first request against tracing/core
and have discovered today what was in tracing/ftrace :)

But Zhaolei's patches are not the same. The v1 is on
tracing/ftrace, it doesn't contain the fix for the build
error. Then Ingo suggested me to cherry-pick the missing
patches in tracing/core from tracing/ftrace. And here came
the second pull request.

So, may be I should send a new request containing the last
fixes but against tracing/ftrace. So that we'll have
the same result without the kconfig tricks that solve the
build error.

Hm?

