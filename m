Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYFKAQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYFKAQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYFKAPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:15:50 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45643 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753603AbYFKAPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:15:49 -0400
Date: Tue, 10 Jun 2008 17:15:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <200806111003.37167.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0806101712490.19088@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <200806101256.31615.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0806092012240.13024@schroedinger.engr.sgi.com>
 <200806111003.37167.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, Rusty Russell wrote:

> You're being obtuse.  See previous mail about the three possible 
> implementations of local_t, and the comment in asm-generic/local.h.

OK. I hope I responded in the other email in a more intelligent 
fashion.

> The paths forward are clear:
> 1) Improve x86 local_t (mostly orthogonal to the others, but useful).

Not sure about that. Its rarely used and the more general cpu alloc stuff 
can be used in lots of places as evident by the rest of the patchset. But 
lets leave it if its important for some reason.

> 2) Implement extensible per-cpu areas.
> 3) Generalize per-cpu accessors.
> 4) Extend or replace the module.c per-cpu allocator to alloc from the other
>    areas.
> 5) Convert alloc_percpu et al. to use the new code.

Yes thanks. We are mostly on the same wavelength.
