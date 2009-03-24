Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbZCXQYC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbZCXQYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:24:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbZCXQXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:23:31 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39829 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762592AbZCXQX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:23:29 -0400
Message-Id: <20090324155625.420966314@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 11:56:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: [patch 0/9] LTTng core kernel instrumentation
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 24 Mar 2009 16:22:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the core of the Linux kernel LTTng instrumentation. I left out what I
considered that would be eventually covered by a wide syscall instrumentation
and I also picked the most important pieces of instrumentation. The LTTng tree
contains more tracepoints, some of which (e.g. mm instrumentation) will be
proposed later once we agree on the tracepoints proposed in this patchset.

Ingo, the irq and softirq instrumentation patches will probably clash with the
patches from Jason you currently have in your tree. Please see the individual
changelogs for details.

This patchset applies over 2.6.29 in the following order :

irq-handle-prepare-for-instrumentation.patch
lttng-instrumentation-irq.patch
lttng-instrumentation-tasklets.patch
lttng-instrumentation-softirq.patch
lttng-instrumentation-scheduler-fixup-task-migration.patch
lttng-instrumentation-timer.patch
lttng-instrumentation-kernel.patch
lttng-instrumentation-filemap.patch
lttng-instrumentation-swap.patch

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
