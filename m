Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYDDT5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYDDT5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYDDT5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:57:08 -0400
Received: from www.tglx.de ([62.245.132.106]:49448 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075AbYDDT5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:57:07 -0400
Date: Fri, 4 Apr 2008 21:56:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/2] fast_gup for shared futexes
In-Reply-To: <20080404193332.348493000@chello.nl>
Message-ID: <alpine.LFD.1.10.0804042154580.3224@apollo.tec.linutronix.de>
References: <20080404193332.348493000@chello.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Peter Zijlstra wrote:
> Hi,
> 
> this patch series removes mmap_sem from the fast path of shared futexes by
> making use of Nick's recent fast_gup() patches. Full series at:
> 
>   http://programming.kicks-ass.net/kernel-patches/futex-fast_gup/v2.6.24.4-rt4/

Looks good at the first glance. Need to look at the corner cases, but
the code does not really depend on mmap_sem anymore so the chance that
it blows up is pretty low.

Thanks,

	tglx
