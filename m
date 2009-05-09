Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZEIIcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZEIIcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZEIIcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:32:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZEIIcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:32:03 -0400
Date: Sat, 9 May 2009 10:31:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       gorcunov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       riel@redhat.com, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
Message-ID: <20090509083116.GC3656@elte.hu>
References: <1241795428.28600.60.camel@penberg-laptop> <alpine.DEB.1.10.0905081128241.26361@qirst.com> <1241797279.28600.65.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241797279.28600.65.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, 2009-05-08 at 11:29 -0400, Christoph Lameter wrote:
> > On Fri, 8 May 2009, Pekka Enberg wrote:
> > 
> > > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > >
> > > This patch introduces a GFP_PANIC flag that can be used as an annotation
> > > that an early-boot call to kmalloc() or alloc_pages() is expected to
> > > never fail.
> > 
> > I think the early-boot requirement needs to be dropped. Make this safe to
> > be used at anytime.
> 
> OK, here's an updated patch description:
> 
> Subject: [PATCH 1/2] mm: Introduce GFP_PANIC
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch introduces a GFP_PANIC flag that can be used as an annotation
> that a kmalloc() or alloc_pages() call is expected to never fail which is
> useful for early-boot code, for example.
> 
> To save one GFP flag bit, use a combination of __GFP_NOFAIL and
> __GFP_NOREPEAT to make sure we always end up in the "nopage" path of the
> page allocator if an allocation fails.
> 
> [ gorcunov@openvz.org: initial version of the patch ]
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Thanks Pekka for taking care of this,

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
