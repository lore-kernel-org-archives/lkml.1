Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZCYMy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZCYMy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZCYMyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:54:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51153 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZCYMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:54:20 -0400
Date: Wed, 25 Mar 2009 13:54:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
Message-ID: <20090325125407.GA32744@elte.hu>
References: <20090325113021.781490788@chello.nl> <20090325113317.104545398@chello.nl> <20090325121811.GC11571@elte.hu> <1237984033.7972.865.camel@twins> <20090325123514.GB28639@elte.hu> <1237984864.7972.896.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237984864.7972.896.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-03-25 at 13:35 +0100, Ingo Molnar wrote:
> 
> > > Also, when mixing streams (events,mmap) is a single: you missed 
> > > 'n' events still good?
> > 
> > How would such mixing work? Multiple counters streaming into the 
> > same mmap area?
> 
> No basically having overflow events and mmap-vma changed events in 
> a single output stream.

ah, and i missed the impact of variable size records - that too 
makes it somewhat impractical to emit overflow records in situ. (the 
kernel does not really know the precise start of the previous 
record, typically.)

	Ingo
