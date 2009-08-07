Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZHGOSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZHGOSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbZHGOSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:18:04 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:57084 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbZHGOSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:18:03 -0400
Date: Sat, 8 Aug 2009 00:16:48 +1000
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ftrace: add tracepoint for timer
Message-ID: <20090807141648.GE4685@kryten>
References: <4A7A4153.3040207@cn.fujitsu.com> <20090806024804.GB4685@kryten> <4A7A4C45.3040008@cn.fujitsu.com> <20090807105616.GA24916@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807105616.GA24916@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> timer _handler_ entry/exit is a pretty good lifecycle name as well - 
> and it nicely fits into the irq/softirq naming Anton mentioned. 
> Maybe this list:
> 
>  timer_init
>  timer_start
>  timer_expire_entry
>  timer_expire_exit
>  timer_cancel
> 
> works for you Anton?

That looks good to me. Thanks Ingo.

Anton
