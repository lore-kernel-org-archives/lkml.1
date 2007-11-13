Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbXKMTmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbXKMTmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761257AbXKMTlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:41:14 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47647 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063AbXKMTlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:41:10 -0500
Message-Id: <20071113193349.214098508@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 14:33:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/7] LTTng Kernel Instrumentation (Architecture Independent)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:40:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I submit this instrumentation of the main kernel events using markers to the
Linux community as an RFC. This is the instrumentation LTTng (Linux Trace
Toolkit Next Generation, at http://ltt.polymtl.ca) uses.

In addition to this, I also have architecture dependent instrumentation for:
- traps
- system call entry/exit
- kernel thread creation
- IPC call
which I plan to submit a bit later, once these architecture independent core
instrumentation patches will have been discussed.

The goal here is be be able to tell "what the kernel is doing" so we can :
- get execution traces from bug reporters easily.
- help userspace developers to understand the interactions of their programs
  with other processes and with the kernel.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
