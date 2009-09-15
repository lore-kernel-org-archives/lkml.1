Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZION2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZION2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZION2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:28:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35709 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZION2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:28:42 -0400
Subject: Re: [PATCH 0/2] tracing: Tracing integration - dynamic ftrace for
 SystemTap
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>, paulus@samba.org,
       systemtap@sources.redhat.com
In-Reply-To: <1253009974.5506.41.camel@laptop>
References: <4AAF6724.9080201@bk.jp.nec.com>
	 <1253009731.5506.39.camel@laptop>  <1253009974.5506.41.camel@laptop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 15 Sep 2009 09:28:44 -0400
Message-Id: <1253021324.20020.88.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 12:19 +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-15 at 12:15 +0200, Peter Zijlstra wrote:
> > On Tue, 2009-09-15 at 19:06 +0900, Atsushi Tsuji wrote:
> > > The patches doesn't contain the performance counters integration,
> > > since it is still in development. I think following implementations are
> > > needed:
> > > - add new type to perf_id (like PERF_TYPE_FTRACE)
> > > - add event ids to struct dyn_ftrace
> > > - add interfaces to reference event ids by user (via debugfs?)
> > > - add probe function to count ftrace events (call do_perf_swcounter_event)
> > 
> > That's long since been done,.. 
> 
> Or are you talking about the mcount thing? Simply expose the mcount hook
> as a regular tracepoint and perf can already use it.
> 

Peter,

I'm not sure what you mean by exposing the mcount hook as a tracepoint.
Or you mean make it a special file in debug/tracing/events/ that lets
you enable it as a profile trace?


-- Steve

