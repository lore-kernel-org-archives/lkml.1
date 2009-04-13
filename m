Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZDMDuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZDMDuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZDMDuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:50:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZDMDuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:50:04 -0400
Message-ID: <49E2B656.1020308@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 11:49:42 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueue tracepoints
 use TRACE_EVENT macro
References: <49E28D4B.5040802@cn.fujitsu.com> <20090413103639.6DF4.A69D9226@jp.fujitsu.com> <20090413122350.6DFE.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090413122350.6DFE.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> Hi,
>>
>> hehe, I also have similar patch in my local patch queue ;)
>>
>>> +TRACE_EVENT(workqueue_insertion,
>>> +
>>> +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
>>> +
>>> +	TP_ARGS(wq_thread, work),
>>> +
>>> +	TP_STRUCT__entry(
>>> +		__array(	char,			thread_comm,	TASK_COMM_LEN	)
>>> +		__field(	pid_t,			thread_pid			)
>>> +		__field(	struct work_struct *,	work				)
>>> +		__field(	work_func_t,		func				)
>>> +	),
> 
> and, your patch exceed 80 character in many lines.
> Please use checkpatch.pl script.
Hello, Kosaki-san

Thanks for your comments for this patch,
I'll merge your and other people's comments and send a V2.

About line exceed 80 characters, I do checkpatch before send, and I know that
lines in TP_STRUCT__entry are too long.
It it because I use similar format with other TRACE_EVENT definition.
Actually, I don't know why we need to add prefix and postfix TABs, and is it
necessary to use tab to make alignment for each fields.
Who can give me teach? or I will use different format to fix this 80-char problem.

Thanks
Zhaolei
> 
> 
> 
> 


