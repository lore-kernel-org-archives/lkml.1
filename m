Return-Path: <linux-kernel-owner+w=401wt.eu-S935064AbXGXLSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935064AbXGXLSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbXGXLSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:18:15 -0400
Received: from ns.suse.de ([195.135.220.2]:46720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbXGXLSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:18:15 -0400
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
References: <20070724083855.GA858@elte.hu>
	<20070724015441.8604d85d.akpm@linux-foundation.org>
	<1185270045.5439.249.camel@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Jul 2007 14:13:04 +0200
In-Reply-To: <1185270045.5439.249.camel@localhost.localdomain>
Message-ID: <p73abtmt2y7.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> > What a truly putrid patch.  I am suspecting that this was a quick
> > get-you-out-of-trouble thing, which then got forgotten about.
> > 
> > We have two months to do the "right fix".  Please?
> 
> Working on it... 

Ideally the patch would DTRT even on non preemptible kernels,
aka do cond_resched()s when needed.

-Andi
