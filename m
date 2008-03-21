Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYCUUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYCUUMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbYCUUMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:12:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbYCUUMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:12:23 -0400
Date: Fri, 21 Mar 2008 21:12:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
Message-ID: <20080321201211.GA21609@elte.hu>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu> <20080321134128.GO27245@elte.hu> <3343.1206128318@turing-police.cc.vt.edu> <20080321195813.GC16179@elte.hu> <4945.1206129958@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4945.1206129958@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Fri, 21 Mar 2008 20:58:13 BST, Ingo Molnar said:
> 
> > no, we frequently regenerate the x86.git tree so the dates have little 
> > relevance. If for any particular pull, x86/base is good and x86/latest 
> > is bad, then the bug is somewhere in those 200-300 patches inbetween. 
> > They are lined up linearly so should be perfectly bisectable.
> 
> OK, off to go try the last few bisects then...

well ... your git bisection log does look suspiciously 'good', so 
something is wrong thee i think :-(

the chance to get 8 'good' bisection points in a row is 1:256. OTOH, the 
freshest x86 patches are always at the 'end' of the queue - which are 
also the ones most likely to break anything.

Are you sure the x86/base point is indeed 'good'? You can check it via:

 git-checkout -b tmp x86/base

and build+boot it.

	Ingo
