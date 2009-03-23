Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZCWIJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZCWIJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZCWII7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:08:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43238 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZCWII6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:08:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: ftrace not working?
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200903231208.03723.knikanth@suse.de>
References: <200903231208.03723.knikanth@suse.de>
Message-Id: <20090323170234.6A12.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Mar 2009 17:08:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> I tried ftrace with the linus git 2.6.29 rc-6, & rc-8, but I always seem to
> get empty trace! Am I doing something wrong?
> 
> This is what I did.
> 
> linux-glcc:/data/git/linux-2.6 # cd /sys/kernel/debug/tracing/
> linux-glcc:/sys/kernel/debug/tracing # cat available_tracers 
> function_graph function sysprof sched_switch nop
> linux-glcc:/sys/kernel/debug/tracing # echo sched_switch > current_tracer 
> linux-glcc:/sys/kernel/debug/tracing # echo 1 > tracing_enabled 
> linux-glcc:/sys/kernel/debug/tracing # cat tracing_enabled 
> 1
> linux-glcc:/sys/kernel/debug/tracing # cat trace
> # tracer: sched_switch
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |

your operation seems fine and your .config seems fine too.
but my box works ftrace well on 2.6.29-rc8.

hmm...

Could you post followin operation result and dmesg?

# cat failures
# cat current_tracer
# cat trace_options
# cat buffer_size_kb
# cat dyn_ftrace_total_info
# cat trace_options
# cat set_ftrace_filter
# cat tracing_cpumask
# cat tracing_enabled
# cat tracing_on



