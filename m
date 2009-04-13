Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZDMDZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZDMDZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZDMDZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:25:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52025 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbZDMDZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:25:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueue tracepoints use TRACE_EVENT macro
Cc: kosaki.motohiro@jp.fujitsu.com, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090413103639.6DF4.A69D9226@jp.fujitsu.com>
References: <49E28D4B.5040802@cn.fujitsu.com> <20090413103639.6DF4.A69D9226@jp.fujitsu.com>
Message-Id: <20090413122350.6DFE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 13 Apr 2009 12:25:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> hehe, I also have similar patch in my local patch queue ;)
> 
> > +TRACE_EVENT(workqueue_insertion,
> > +
> > +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> > +
> > +	TP_ARGS(wq_thread, work),
> > +
> > +	TP_STRUCT__entry(
> > +		__array(	char,			thread_comm,	TASK_COMM_LEN	)
> > +		__field(	pid_t,			thread_pid			)
> > +		__field(	struct work_struct *,	work				)
> > +		__field(	work_func_t,		func				)
> > +	),

and, your patch exceed 80 character in many lines.
Please use checkpatch.pl script.



