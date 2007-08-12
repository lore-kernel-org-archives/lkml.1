Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbXHLO64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbXHLO64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 10:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbXHLO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 10:58:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46477 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbXHLO6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 10:58:43 -0400
Message-Id: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [patch 00/23] Atomic operations updates: add cmpxchg_local
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 14:58:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I have been asked for a cmpxchg_local implementation by Christoph Lameter so he
can use it to accelerate the slub allocator.

On some architectures, where cmpxchg is nothing more that a simple save/restore
interrupts surrounding the cmpxchg non atomic ops, I remove the code and make
them use the new "generic" version.

cmpxchg_local and cmpxchg64_local are made available on all architectures in
these patches. They use the best primitive known, either an atomic operation or
save/restore interrupts.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
