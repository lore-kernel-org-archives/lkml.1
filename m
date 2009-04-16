Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZDPOzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZDPOzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZDPOzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:55:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbZDPOzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:55:04 -0400
Date: Thu, 16 Apr 2009 10:55:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: Code cleanup for
 kernel/trace/trace_events_stage_*.h
In-Reply-To: <alpine.DEB.2.00.0904062153120.29426@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904161053590.6495@gandalf.stny.rr.com>
References: <49D5E3EE.70201@cn.fujitsu.com> <49D5E44B.3080104@cn.fujitsu.com> <alpine.DEB.2.00.0904062153120.29426@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 6 Apr 2009, Steven Rostedt wrote:

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

Hi Zhao,

As you probably noticed, the staging code has been combined into 
include/trace/ftrace.h

Is this patch (or a variant) still needed?

-- Steve

