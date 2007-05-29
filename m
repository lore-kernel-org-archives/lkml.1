Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbXE2Shg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbXE2Shg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757946AbXE2ShO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:37:14 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43674 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbXE2ShN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:37:13 -0400
Message-Id: <20070529183356.192838687@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 29 May 2007 14:33:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/9] Conditional Calls
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 29 May 2007 18:37:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following Andi Kleen's advice, I splitted the jump-over-call into a speparate
piece of infrastructure so it can be used more widely.

It also use a hash table to permit cond_call enable/disable both when the
cond_call is armed and when a module containing an armed cond_call is loaded.

Please add at the end of the 2.6.22-mm1 series,

conditional-calls-architecture-independent-code.patch
conditional-calls-hash-table.patch
conditional-calls-non-optimized-architectures.patch
conditional-calls-kconfig-menus.patch
conditional-calls-i386-optimization.patch
conditional-calls-powerpc-optimization.patch
conditional-calls-documentation.patch
#
f00f-bug-use-cond-calls.patch
profiling-use-cond-calls.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
