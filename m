Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYGJDOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYGJDOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 23:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYGJDOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 23:14:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56237 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYGJDOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 23:14:04 -0400
From: "Takashi Nishiie" <t-nishiie@np.css.fujitsu.com>
To: "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       <akpm@linux-foundation.org>, "'Ingo Molnar'" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>,
       "'Peter Zijlstra'" <peterz@infradead.org>
Cc: "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Masami Hiramatsu'" <mhiramat@redhat.com>,
       "'Frank Ch. Eigler'" <fche@redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>,
       "'Eduard - Gabriel Munteanu'" <eduard.munteanu@linux360.ro>
References: <20080709145929.352201601@polymtl.ca> <20080709150045.025136754@polymtl.ca> <20080709153434.GA9186@Krystal> <20080709162158.GB10601@Krystal> <20080709190957.GA16779@Krystal>
In-Reply-To: <20080709190957.GA16779@Krystal>
Subject: RE: [PATCH] ftrace port to tracepoints (linux-next)
Date: Thu, 10 Jul 2008 12:14:01 +0900
Message-ID: <010401c8e23b$020b6c30$06224490$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acjh94VSI4e6molBSHC3X1aU77hYJQAQccOA
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,Mathieu

I think that it is wonderful that the source code becomes simple by 
changing kernel markers to tracepoints. 

However, it seems to forget to correct the error message.

For example.
Mathieu Wrote:
>-	ret = marker_probe_register("kernel_sched_wakeup",
>-			"pid %d state %ld ## rq %p task %p rq->curr %p",
>-			wake_up_callback,
>-			&ctx_trace);
>+	ret = register_trace_sched_wakeup(probe_sched_wakeup);
> 	if (ret) {
> 		pr_info("wakeup trace: Couldn't add marker"
> 			" probe to kernel_sched_wakeup\n");
> 		return ret;
> 	}

 	if (ret) {
- 		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return ret;
 	}

Thank you,
--
Takashi Nishiie



