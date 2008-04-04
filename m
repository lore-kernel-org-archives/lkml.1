Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbYDDTjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbYDDTjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYDDTix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:38:53 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:3938 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbYDDTiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:38:52 -0400
X-SourceIP: 80.56.237.116
Message-Id: <20080404193332.348493000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 Apr 2008 21:33:32 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [RFC PATCH 0/2] fast_gup for shared futexes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series removes mmap_sem from the fast path of shared futexes by
making use of Nick's recent fast_gup() patches. Full series at:

  http://programming.kicks-ass.net/kernel-patches/futex-fast_gup/v2.6.24.4-rt4/

--

