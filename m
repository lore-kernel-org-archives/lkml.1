Return-Path: <linux-kernel-owner+w=401wt.eu-S1763045AbXGYNuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763045AbXGYNuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXGYNud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:50:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46934 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXGYNuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:50:32 -0400
Date: Wed, 25 Jul 2007 15:50:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jos Poortvliet <jos@mijnkamer.nl>, david@lang.hm,
       Nick Piggin <nickpiggin@yahoo.com.au>, Valdis.Kletnieks@vt.edu,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>,
       linux-mm@kvack.org, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Message-ID: <20070725135016.GA18633@elte.hu>
References: <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com> <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com> <5c77e14b0707250353r48458316x5e6adde6dbce1fbd@mail.gmail.com> <46A75062.1050809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A75062.1050809@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> Nick Piggin is the person to convince it seems and if I've read things 
> right (I only stepped into this thing at the updatedb mention, so 
> maybe I haven't) his main question is _why_ the hell it helps 
> updatedb. [...]

btw., i'd like to make this clear: if you want stuff to go upstream, do 
not concentrate on 'convincing the maintainer'.

Instead concentrate on understanding the _problem_, concentrate on 
making sure that both you and the maintainer understands the problem 
correctly, possibly write some testcase that clearly exposes it, and 
help the maintainer debug the problem. _Optionally_, if you find joy in 
it, you are also free to write a proposed solution for that problem and 
submit it to the maintainer.

But a "here is a solution, take it or leave it" approach, before having 
communicated the problem to the maintainer and before having debugged 
the problem is the wrong way around. It might still work out fine if the 
solution is correct (especially if the patch is small and obvious), but 
if there are any non-trivial tradeoffs involved, or if nontrivial amount 
of code is involved, you might see your patch at the end of a really 
long (and constantly growing) waiting list of patches.

	Ingo
