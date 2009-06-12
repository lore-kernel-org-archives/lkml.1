Return-Path: <linux-kernel-owner+w=401wt.eu-S933553AbZFLKAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbZFLKAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761801AbZFLKAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:00:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:40154 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761365AbZFLKAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:00:19 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
 suspending
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20090612095206.GA13607@wotan.suse.de>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu>
	 <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
	 <20090612095206.GA13607@wotan.suse.de>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 19:59:34 +1000
Message-Id: <1244800774.7172.116.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Maybe if we just not make it a general "tweak gfpflag" bit (at
> least not until a bit more discussion), but a specific workaround
> for the local_irq_enable in early boot problem.
> 
> Seems like it would not be hard to track things down if we add
> a warning if we have GFP_WAIT and interrupts are not enabled...

But tweaking local_irq_enable() will have a lot more performance & bloat
impact overall on the normal case.

Cheers,
Ben.


