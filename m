Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZIJNeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZIJNeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 09:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbZIJNeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 09:34:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbZIJNeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 09:34:23 -0400
Subject: Re: [PATCH v2] tracing: Clean up trace.h
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4AA863A7.5030909@cn.fujitsu.com>
References: <4AA8579B.4020706@cn.fujitsu.com>
	 <1252549061.18996.3.camel@gandalf.stny.rr.com>
	 <4AA863A7.5030909@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Sep 2009 09:34:24 -0400
Message-Id: <1252589664.18996.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 10:25 +0800, Li Zefan wrote:
> 于 2009年09月10日 10:17, Steven Rostedt 写道:
> > On Thu, 2009-09-10 at 09:34 +0800, Li Zefan wrote:
> >> - remove some dead code
> >> - remove @stats from struct tracer
> >> - move DEFINE_COMPARISON_PRED() and DEFINE_EQUALITY_PRED()
> >>   to kernel/trace/trace_events_filter.c
> >>
> > 
> > Actually, Li if you don't mind, I'm going to break this up into separate
> > patches. Each of the above "topics" really should be a separate patch.
> > It makes bisecting and such nicer if for some strange reason this patch
> > became the cause.
> > 
> 
> Actually it does more than I described:
> 
> - indent some lines
> - fix a typo in comment
> - remove trace_field_cont
> - remove tracer_switch_ops
> - remove @stats from struct tracer
> - move 2 macros to trace_events_filter.c
> 
> I'm not sure it worths breaking into several patches, since each of them
> is trivial.
> 
> But I won't mind if you break this up, or if you want me to do
> this.

Yeah I already broke it up and sent it out. Some could go together, but
I did not like moving code mixed with other cleanups.

Thanks,

-- Steve


