Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180Ab0AGNPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab0AGNPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567Ab0AGNPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:15:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41568 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0AGNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:15:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=FZey-0LJvhJXiqaw6WAA:9 a=5MDFvkrlsBTuuZ5KAUiWkHRrp1QA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <1262853855.4049.86.camel@laptop>
References: <20100107044007.GA22863@Krystal>
	 <1262842854.28171.3710.camel@gandalf.stny.rr.com>
	 <20100107061955.GC25786@Krystal>  <20100107063558.GC12939@feather>
	 <1262853855.4049.86.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 08:15:31 -0500
Message-ID: <1262870131.28171.3711.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 09:44 +0100, Peter Zijlstra wrote:

> A simple:
> 
>   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
>      if (cpu_curr(cpu)->mm == current->mm)
>         smp_call_function_single(cpu, func, NULL, 1);
>   }

I like this algorithm the best ;-)

-- Steve


