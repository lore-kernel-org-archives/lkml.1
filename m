Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYGDXzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYGDXzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYGDXzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:55:07 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42497 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbYGDXzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:55:06 -0400
Message-Id: <20080704235207.147809973@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 19:52:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC patch 00/12] Tracepoints v2
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,  4 Jul 2008 23:54:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the second release of kernel tracepoints, including the architecture
independent instrumentation taken from LTTng. I submit this for another round of
comments.

The patchset applies on 2.6.26-rc8 in this order :

# Instrumentation
tracepoints.patch
lttng-instrumentation-fs.patch
lttng-instrumentation-ipc.patch
lttng-instrumentation-kernel.patch
lttng-instrumentation-mm.patch
lttng-instrumentation-net.patch

# LTTng probes, using markers
traceprobes.patch
lttng-instrumentation-fs-tracepoints-probes.patch
lttng-instrumentation-ipc-tracepoints-probes.patch
lttng-instrumentation-kernel-tracepoints-probes.patch
lttng-instrumentation-mm-tracepoints-probes.patch
lttng-instrumentation-net-tracepoints-probes.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
