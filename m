Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYGOW2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYGOW2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYGOW2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:28:40 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47162 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbYGOW2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:28:39 -0400
Message-Id: <20080715222604.331269462@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 18:26:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [patch 00/17] Tracepoints v4 for linux-next
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 15 Jul 2008 22:27:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the newest release of the Tracepoints, following the feedback from Peter
Zijlstra. The main change is the creation of include/trace/ as a placeholder
from tracepoint headers.

The patchset applies over linux-next patch-v2.6.26-next-20080715 in this order :

#This a separate RCU update upon which the tracepoints depend
rcu-read-sched.patch

tracepoints.patch
tracepoints-documentation.patch
tracepoints-samples.patch

lttng-instrumentation-irq.patch
lttng-instrumentation-scheduler.patch
lttng-instrumentation-timer.patch
lttng-instrumentation-kernel.patch

lttng-instrumentation-filemap.patch
lttng-instrumentation-swap.patch
lttng-instrumentation-memory.patch
lttng-instrumentation-page.patch
lttng-instrumentation-hugetlb.patch

lttng-instrumentation-net.patch
lttng-instrumentation-ipv4.patch
lttng-instrumentation-ipv6.patch

ftrace-port-to-tracepoints.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
