Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZDHHEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZDHHEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbZDHHEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:04:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49008 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZDHHEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:04:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=rm2nKJFSS4j5pbu7qWYWkRxnjRNWD5JqKLBhlBv/AVAnrBbEbjyfvdSlg2qEcZX2n
	ld+alQyieiKe4rQBygT7g==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904062153120.29426@gandalf.stny.rr.com>
References: <49D5E3EE.70201@cn.fujitsu.com> <49D5E44B.3080104@cn.fujitsu.com>
	 <alpine.DEB.2.00.0904062153120.29426@gandalf.stny.rr.com>
Date: Wed, 8 Apr 2009 00:04:24 -0700
Message-ID: <5df78e1d0904080004y7be9b31k524c32aeed787c1f@mail.gmail.com>
Subject: Re: [PATCH 2/2] ftrace: Code cleanup for kernel/trace/trace_events_stage_*.h
From: Jiaying Zhang <jiayingz@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

I am looking at ftrace code more closely. It is also not clear to me why we
want to define the trace event macros in three stage header files. I wonder
whether it would be clearer if we merge them together. Then people don't
need to look at three files to understand what is going on in event tracing.

Jiaying

On Mon, Apr 6, 2009 at 6:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 3 Apr 2009, Zhaolei wrote:
>
> > Add TRACE_FORMAT's define for trace_events_stage_2.h.
> > Although it is already defined in trace_events_stage_1.h, we should make each
> > function independence.
> >
> > Move TP_fast_assign's define from trace_events_stage_2.h to
> > trace_events_stage_3.h because it is used there.
> >
> > Unify TRACE_EVENT's 5th argument's name to "assign"
> >
> > Impact: cleanup, no functionality changed
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>
> I see what you are doing here, but I'm a little hesitant to apply it.
> I'm getting ready to travel, so I do not have the time to look deeper at
> this today. I'll try to do it while I'm traveling.
>
> Thanks,
>
> -- Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
