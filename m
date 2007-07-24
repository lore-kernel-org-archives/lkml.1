Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbXGXFU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbXGXFU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXGXFTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:19:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487AbXGXFTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:19:13 -0400
Date: Mon, 23 Jul 2007 22:18:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>, "ck list" <ck@vds.kolivas.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-Id: <20070723221846.d2744f42.akpm@linux-foundation.org>
In-Reply-To: <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<200707102015.44004.kernel@kolivas.org>
	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46A57068.3070701@yahoo.com.au>
	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 21:53:38 -0700 "Ray Lee" <ray-lk@madrabbit.org> wrote:

> 
> Since this merge period has appeared particularly frazzling for
> Andrew, I've been keeping silent and waiting for him to get to a point
> where there's a breather. I didn't feel it would be polite to request
> yet more work out of him while he had a mess on his hands.

Let it just be noted that Con is not the only one who has expended effort
on this patch.  It's been in -mm for nearly two years and it has meant
ongoing effort for me and, to a lesser extent, other MM developers to keep
it alive.

> But, given this has come to a head, I'm asking now.
> 
> Andrew? You've always given the impression that you want this run more
> as an engineering effort than an artistic endeavour, so help us out
> here. What are your concerns with swap prefetch? What sort of
> comparative data would you like to see to justify its inclusion, or to
> prove that it's not needed?

Critera are different for each patch, but it usually comes down to a
cost/benefit judgement.  Does the benefit of the patch exceed its
maintenance cost over the lifetime of the kernel (whatever that is).

In this case the answer to that has never been clear to me.  The (much
older) fs-aio patches were (are) in a similar situation.

The other consideration here is, as Nick points out, are the problems which
people see this patch solving for them solveable in other, better ways? 
IOW, is this patch fixing up preexisting deficiencies post-facto?

To attack the second question we could start out with bug reports: system A
with workload B produces result C.  I think result C is wrong for <reasons>
and would prefer to see result D.

> Or are we reading too much into the fact that it isn't merged? In
> short, communicate please, it will help.

Well.  The above, plus there's always a lot of stuff happening in MM land,
and I haven't seen much in the way of enthusiasm from the usual MM
developers.

