Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZIONhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZIONhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZIONhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:37:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:42261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZIONhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:37:14 -0400
Subject: Re: [PATCH 0/2] tracing: Tracing integration - dynamic ftrace for
 SystemTap
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>, paulus@samba.org,
       systemtap@sources.redhat.com
In-Reply-To: <1253021324.20020.88.camel@gandalf.stny.rr.com>
References: <4AAF6724.9080201@bk.jp.nec.com>
	 <1253009731.5506.39.camel@laptop>  <1253009974.5506.41.camel@laptop>
	 <1253021324.20020.88.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 15:36:56 +0200
Message-Id: <1253021816.5506.78.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 09:28 -0400, Steven Rostedt wrote:
> On Tue, 2009-09-15 at 12:19 +0200, Peter Zijlstra wrote:
> > On Tue, 2009-09-15 at 12:15 +0200, Peter Zijlstra wrote:
> > > On Tue, 2009-09-15 at 19:06 +0900, Atsushi Tsuji wrote:
> > > > The patches doesn't contain the performance counters integration,
> > > > since it is still in development. I think following implementations are
> > > > needed:
> > > > - add new type to perf_id (like PERF_TYPE_FTRACE)
> > > > - add event ids to struct dyn_ftrace
> > > > - add interfaces to reference event ids by user (via debugfs?)
> > > > - add probe function to count ftrace events (call do_perf_swcounter_event)
> > > 
> > > That's long since been done,.. 
> > 
> > Or are you talking about the mcount thing? Simply expose the mcount hook
> > as a regular tracepoint and perf can already use it.
> > 

> I'm not sure what you mean by exposing the mcount hook as a tracepoint.
> Or you mean make it a special file in debug/tracing/events/ that lets
> you enable it as a profile trace?

Either make it a single tracepoint on which you can apply filters or
make it generate a tracepoint per mcount site, I don't really mind ;-)

If kprobes can live in the same space, then surely the function tracer
can too ;-)

