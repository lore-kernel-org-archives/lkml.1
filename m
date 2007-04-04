Return-Path: <linux-kernel-owner+w=401wt.eu-S2992773AbXDDJNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992773AbXDDJNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992776AbXDDJNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:13:40 -0400
Received: from holomorphy.com ([66.93.40.71]:37304 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992773AbXDDJNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:13:39 -0400
Date: Wed, 4 Apr 2007 02:12:30 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-ID: <20070404091230.GJ2986@holomorphy.com>
References: <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org> <4612DCC6.7000504@cosmosbay.com> <46130BC8.9050905@yahoo.com.au> <1175675146.6483.26.camel@twins> <461367F6.10705@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461367F6.10705@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 06:55:18PM +1000, Nick Piggin wrote:
> +		rcu_read_lock();
> +		do {
> +			t->vma_cache_sequence = -1;
> +			t = next_thread(t);
> +		} while (t != curr);
> +		rcu_read_unlock();

LD_ASSUME_KERNEL=2.4.18 anyone?


-- wli
