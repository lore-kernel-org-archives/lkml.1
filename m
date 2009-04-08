Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbZDHHIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbZDHHIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbZDHHHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:07:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZDHHHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:07:49 -0400
Message-ID: <49DC4C82.40307@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:04:34 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jiaying Zhang <jiayingz@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 2/2] ftrace: Code cleanup for kernel/trace/trace_events_stage_*.h
References: <49D5E3EE.70201@cn.fujitsu.com> <49D5E44B.3080104@cn.fujitsu.com>	 <alpine.DEB.2.00.0904062153120.29426@gandalf.stny.rr.com> <5df78e1d0904072328v11e03131y5256d5c2ba9c03d@mail.gmail.com>
In-Reply-To: <5df78e1d0904072328v11e03131y5256d5c2ba9c03d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiaying Zhang wrote:
> Hi Steve,
> 
> I am looking at ftrace code more closely. It is also not clear to me why we
Hello, Zhang

Different people may have different taste on codeing style, but IMHO, separate
those complex definition into several files make me easy to understand.
It is only my personal code liking...

B.R.
Zhaolei

> want to define the trace event macros in three stage header files. I wonder
> whether it would be clearer if we merge them together. Then people don't
> need to look at three files to understand what is going on in event tracing.
> 
> Jiaying
> 
> On Mon, Apr 6, 2009 at 6:54 PM, Steven Rostedt <rostedt@goodmis.org
> <mailto:rostedt@goodmis.org>> wrote:
> 
> 
>     On Fri, 3 Apr 2009, Zhaolei wrote:
> 
>     > Add TRACE_FORMAT's define for trace_events_stage_2.h.
>     > Although it is already defined in trace_events_stage_1.h, we
>     should make each
>     > function independence.
>     >
>     > Move TP_fast_assign's define from trace_events_stage_2.h to
>     > trace_events_stage_3.h because it is used there.
>     >
>     > Unify TRACE_EVENT's 5th argument's name to "assign"
>     >
>     > Impact: cleanup, no functionality changed
>     >
>     > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com
>     <mailto:zhaolei@cn.fujitsu.com>>
> 
>     I see what you are doing here, but I'm a little hesitant to apply it.
>     I'm getting ready to travel, so I do not have the time to look deeper at
>     this today. I'll try to do it while I'm traveling.
> 
>     Thanks,
> 
>     -- Steve
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


