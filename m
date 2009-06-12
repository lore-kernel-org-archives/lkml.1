Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbZFLJyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbZFLJyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZFLJyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:54:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35768 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZFLJyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:54:43 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
 suspending
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20090612095206.GA13607@wotan.suse.de>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu>
	 <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
	 <20090612095206.GA13607@wotan.suse.de>
Date: Fri, 12 Jun 2009 12:54:44 +0300
Message-Id: <1244800484.30512.39.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 11:52 +0200, Nick Piggin wrote:
> Maybe if we just not make it a general "tweak gfpflag" bit (at
> least not until a bit more discussion), but a specific workaround
> for the local_irq_enable in early boot problem.
> 
> Seems like it would not be hard to track things down if we add
> a warning if we have GFP_WAIT and interrupts are not enabled...

AFAICT, the point is that Ben thinks that we shouldn't go and try to fix
up all the callers. But yes, we could certainly do that too.

			Pekka

