Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbXGXGKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbXGXGKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbXGXGKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:10:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41712 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbXGXGKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:10:39 -0400
Date: Mon, 23 Jul 2007 23:10:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>, "ck list" <ck@vds.kolivas.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-Id: <20070723231015.34b22dcb.akpm@linux-foundation.org>
In-Reply-To: <2c0942db0707232301o5ab428bdrd1bc831cacf806c@mail.gmail.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<200707102015.44004.kernel@kolivas.org>
	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46A57068.3070701@yahoo.com.au>
	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	<20070723221846.d2744f42.akpm@linux-foundation.org>
	<2c0942db0707232301o5ab428bdrd1bc831cacf806c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 23:01:41 -0700 "Ray Lee" <ray-lk@madrabbit.org> wrote:

> So, what do I measure to make this an objective problem report?

Ideal would be to find a reproducible-by-others testcase which does what you
believe to be the wrong thing.

> And if
> I do that (and it shows a positive result), will that be good enough
> to argue for inclusion?

That depends upon whether there are more suitable ways of fixing "the
wrong thing".

There may not be - it could well be that present behaviour
is correct for the testcase, but it leaves the system in the wrong
state for your large workload shift.  In that case, prefetching (ie:
restoring system state approximately to that which prevailed prior to
"testcase") might well be a suitable fix.
