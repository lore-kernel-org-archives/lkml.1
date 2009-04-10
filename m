Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbZDJNrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbZDJNrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZDJNqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:46:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50959 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZDJNqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:46:49 -0400
Date: Fri, 10 Apr 2009 15:46:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: Output REC->var instead of __entry->varfor
	trace format
Message-ID: <20090410134643.GA24809@elte.hu>
References: <49DC6751.30308@cn.fujitsu.com> <49DC679D.2090901@cn.fujitsu.com> <20090408120627.GA17179@elte.hu> <2EAA5B9CE11E4D62AB83F83D5CB25C17@zhaoleiwin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2EAA5B9CE11E4D62AB83F83D5CB25C17@zhaoleiwin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> * From: "Ingo Molnar" <mingo@elte.hu>
> > 
> > * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> > 
> >> print fmt: "irq=%d return=%s", __entry->irq, __entry->ret ? \"handled\" : \"unhandled\"
> >> 
> >> "__entry" should be convert to "REC" by __stringify() macro.
> >> 
> >> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> >> ---
> >>  kernel/trace/trace_events_stage_2.h |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > good fix, but it is causing build trouble when applied to latest 
> > tip/master:
> > 
> > include/trace/sched_event_types.h:257:1: error: macro "__stringify" 
> > passed 3 arguments, but takes just 1
> Hello, Ingo
> 
> I tested this patch before send, but haven't see this error. env 
> is: gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)
> 
> This patch need on top of my previous one: [PATCH 1/2] Make 
> __stringify support variable argument macro Maybe this is the 
> reason.

ah, indeed - i missed the 1/2 patch. I'll have another look.

	Ingo
