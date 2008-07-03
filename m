Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYGCQqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYGCQqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYGCQqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:46:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47795 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbYGCQqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:46:44 -0400
X-Greylist: delayed 2074 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 12:46:44 EDT
Message-Id: <20080703160526.637679319@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 12:05:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch 0/3] Tracepoints
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  3 Jul 2008 16:11:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the new tracepoint infrastructure, heavily inspired from the Markers. It
applies on 2.6.26-rc8. I also post my fs/ LTTng instrumentation as an example
of the resulting code using tracepoints. Please feel free to comment.

- Tracepoints allow more complete type checking (at compile-time) than markers.
- They allow to connect probes involving in-kernel tracers which must be aware
  of complex types such as "struct task_struct *" (not just a void *).
- They are not meant as a replacement for markers, since they do not allow
  one-liner printk-style addition of tracing statements for debugging purpose.
- They require a declaration in a header file, which creates a nice stable API.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
