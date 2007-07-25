Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbXGYJqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbXGYJqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXGYJqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:46:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38607 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbXGYJqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:46:14 -0400
Date: Wed, 25 Jul 2007 11:46:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
Message-ID: <20070725094605.GA9045@one.firstfloor.org>
References: <20070724083855.GA858@elte.hu> <20070724015441.8604d85d.akpm@linux-foundation.org> <1185270045.5439.249.camel@localhost.localdomain> <p73abtmt2y7.fsf@bingen.suse.de> <1185312559.5439.276.camel@localhost.localdomain> <1185345850.8197.64.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185345850.8197.64.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You could perhaps use C99 variable length arrays to avoid the stack
> waste when not needed, however Andi once told me that generates rather
> dubious code.

It generates frame pointers, but that's not that bad.  I'm not 
aware of any other bad side effects. Ok the compiler will limit
your goto usage, but that's more a good thing.

But since you always have to strictly limit the array in kernel code anyways
you could as well just allocate the fixed limit.

-Andi
