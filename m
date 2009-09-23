Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZIWIzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZIWIzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZIWIzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:55:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbZIWIzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:55:17 -0400
Date: Wed, 23 Sep 2009 10:55:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@hardeman.nu,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] input: Fix build failures
	caused by Kconfig Winbond WPCD376I Consumer IR hardware driver
	Kconfig entry
Message-ID: <20090923085512.GC3737@elte.hu>
References: <20090923072444.GA27150@elte.hu> <20090923003918.505db5b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923003918.505db5b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 23 Sep 2009 09:24:44 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ( ob-sidenote: Andrew, i did not find the patch for commit 16af5bb on 
> >   lkml and it's now upstream. It would be highly useful if you Cc:-ed 
> >   lkml with submitted patches like all maintainers do, so that patterns 
> >   can be grepped for and discussions can be continued quickly instead of 
> >   created anew. It would also significantly increase the S/N ratio of 
> >   lkml. Thanks! )
> 
> I did that a couple of times a few years back and vger had a heart 
> attack.  I could cc the lower-subscriber-count mm-commits but that 
> wouldn't help much.

Mass mailings of this order of magnitude are more common now and vger 
ought to cope. It would be sad to skip the useful stuff while keeping 
all the noise ;-)

At least as far as i'm concerned i grep for a commit's title and reply 
to the last relevant mail in the thread that comes up on lkml. That kind 
of activity would be sufficiently helped by a summary mail Cc:-ed to 
lkml. (And there's rumors that there's a wonderful new tool for that, 
written by a git - so i heard.)

Alternatively (or in addition to that) the mm commits list could Cc: 
over to lkml.

( It might even use LKML-Reference tag for that purpose - that way 
  patches which are queued up (or updated) in -mm will show up on lkml 
  gradually and in relevant threads. Highly useful in practice - not 
  only does it make the flow of patches more transparent on lkml, it 
  also links the commit back to the discussion and allows others to 
  chime in later in the discussion (even if they were not Cc:-ed and are 
  hence outside the usual scope of mm-commits). Dunno whether you 
  consider it worth it to update the mm-commits scripts to that end. 
  Since you pick patches from emails it seems a perfect match to me. 
  YMMV. )

And if that is done then git-commits-head@vger.kernel.org could Cc: back 
to lkml if a LKML-Reference tag is present, and the 'hits upstream' 
notification would thus thread back to the original discussion as well.

All in the name of eternal laziness.

> 16af5bb doesn't exist btw - you want e258b80e691f1f3ae83a60aa80eaf7322bd55ec4.

Yeah, you are right, i meant e258b80e (correctly mentioned in the 
changelog).

	Ingo
