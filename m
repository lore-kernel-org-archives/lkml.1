Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZHFCxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZHFCxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZHFCxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:53:02 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42470 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZHFCxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:53:00 -0400
Date: Thu, 6 Aug 2009 12:48:04 +1000
From: Anton Blanchard <anton@samba.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ftrace: add tracepoint for timer
Message-ID: <20090806024804.GB4685@kryten>
References: <4A7A4153.3040207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A4153.3040207@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Example ftrace output:
>   insmod-1712  [000]   145.901459: timer_init: timer=d0ace4b4
>   insmod-1712  [000]   145.901469: timer_start: timer=d0ace4b4 func=timer_fun expires=4294813629 timeout=199
>   <idle>-0     [000]   146.100230: timer_cancel: timer=d0ace4b4
>   <idle>-0     [000]   146.100233: timer_expire: timer=d0ace4b4 jiffies=4294813629
>   <idle>-0     [000]   146.100627: timer_callback_done: func=d0ace4b4

Sorry I haven't followed the thread, but I was wondering why you changed
the name of the entry and exit tracepoints (ie timer_entry/timer_exit). 

I think consistent naming is important to match the other static
tracepoints, such as softirq_entry/softirq_exit, irq_entry/irq_exit and
tasklet_entry/tasklet_exit.

Anton
