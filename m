Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016Ab0ADUtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0ADUtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828Ab0ADUtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:49:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab0ADUtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:49:39 -0500
Message-Id: <20100104182429.833180340@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jan 2010 19:24:29 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC][PATCH 0/8] Speculative pagefault -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch series implementing speculative page faults for x86.

Still needs lots of things sorted, like:

  - call_srcu()
  - ptl, irq and tlb-flush
  - a 2nd VM_FAULT_LOCK? return code to distuinguish between
    simple retry and must take mmap_sem semantics?

Comments?
-- 

