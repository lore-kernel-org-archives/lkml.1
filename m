Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbXE3OCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbXE3OCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbXE3OCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:02:34 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46322 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbXE3OCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:02:33 -0400
Message-Id: <20070530140025.917261793@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:00:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/9] Conditional Calls - for 2.6.22-rc2-mm1
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:02:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the port of the conditional calls to 2.6.22-rc2-mm1.

Quoting my last post:

Following Andi Kleen's advice, I splitted the jump-over-call into a speparate
piece of infrastructure so it can be used more widely.

It also use a hash table to permit cond_call enable/disable both when the
cond_call is armed and when a module containing an armed cond_call is loaded.

Please add at the end of the 2.6.22-rc2-mm1 series,

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
