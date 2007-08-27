Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbXH0Pzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbXH0Pzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbXH0Pzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:55:31 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41774 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbXH0Pza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:55:30 -0400
Message-Id: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:52:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 00/28] Add cmpxchg64_local and cmpxchg_local to each architecture
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:55:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the patch series for 2.6.23-rc3-mm1 that adds cmpxchg_local, and now
also cmpxchg64_local, to each architecture.

When the architecture supports it, it also defines cmpxchg64, but is is not
defined for architecture that does not support atomic 64 bits updates.

Following performance testing of the slub allocator with cmpxchg_local, these
patches should prove themselves useful in a near future.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
