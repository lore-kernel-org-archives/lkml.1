Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZDMD6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZDMD6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZDMD55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:57:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36119 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbZDMD54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:57:56 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueue tracepoints use TRACE_EVENT macro
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49E2B656.1020308@cn.fujitsu.com>
References: <20090413122350.6DFE.A69D9226@jp.fujitsu.com> <49E2B656.1020308@cn.fujitsu.com>
Message-Id: <20090413125653.6E01.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 13 Apr 2009 12:57:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> KOSAKI Motohiro wrote:
> >> Hi,
> >>
> >> hehe, I also have similar patch in my local patch queue ;)
> >>
> >>> +TRACE_EVENT(workqueue_insertion,
> >>> +
> >>> +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> >>> +
> >>> +	TP_ARGS(wq_thread, work),
> >>> +
> >>> +	TP_STRUCT__entry(
> >>> +		__array(	char,			thread_comm,	TASK_COMM_LEN	)
> >>> +		__field(	pid_t,			thread_pid			)
> >>> +		__field(	struct work_struct *,	work				)
> >>> +		__field(	work_func_t,		func				)
> >>> +	),
> > 
> > and, your patch exceed 80 character in many lines.
> > Please use checkpatch.pl script.
> Hello, Kosaki-san
> 
> Thanks for your comments for this patch,
> I'll merge your and other people's comments and send a V2.
> 
> About line exceed 80 characters, I do checkpatch before send, and I know that
> lines in TP_STRUCT__entry are too long.
> It it because I use similar format with other TRACE_EVENT definition.
> Actually, I don't know why we need to add prefix and postfix TABs, and is it
> necessary to use tab to make alignment for each fields.
> Who can give me teach? or I will use different format to fix this 80-char problem.

I'll send my patch today's later. please give me comment :)




