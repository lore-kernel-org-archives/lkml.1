Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYIRT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYIRT3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYIRT3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:29:01 -0400
Received: from gw.goop.org ([64.81.55.164]:50170 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbYIRT3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:29:00 -0400
Message-ID: <48D2ABFD.3040103@goop.org>
Date: Thu, 18 Sep 2008 12:29:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mpm@selenic.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
References: <20080910121217.GA16013@elte.hu> <20080910144812.GB18644@wotan.suse.de> <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org> <20080918111226.GD29968@elte.hu>
In-Reply-To: <20080918111226.GD29968@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> in 7 days that's about 7000 random bootups, 20% of which had TINY_SHMEM 
> enabled, half 32-bit, half 64-bit x86. It did not blow up in any way 
> that would have prevented the kernel from building its next random 
> version from within itself and it did not produce any kernel messages 
> with various random kernel debug, compile and boot options.
>   

Does anything in that workload actually use shared memory?

    J
