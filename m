Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbXLCV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbXLCV4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXLCVzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:55:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33951 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXLCVzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:55:51 -0500
Date: Mon, 3 Dec 2007 22:55:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Markus Metzger <markus.t.metzger@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com
Subject: Re: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071203215524.GA9825@elte.hu>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071201074044.GA13974@elte.hu> <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com> <200712031721.39013.ak@suse.de> <20071203164506.GA16135@elte.hu> <p73ir3fwvo2.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ir3fwvo2.fsf@bingen.suse.de>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Andi Kleen <ak@suse.de> wrote:
> >
> >> Just don't wait for that. utrace doesn't seem to have any concrete 
> >> plans to merge any time soon AFAIK[1] and it would be a shame to delay 
> >> an useful feature forever.
> >> 
> >> [1] At least the patches have not reached any mailing lists
> >
> > FYI, as far as arch/x86 goes, the merging of Roland's utrace 
> > preparatory patches is well underway in x86.git, and the merge went 
> > pretty well so far, with robust results. It's 49 patches so far:
> 
> I see. They are planning to just skip the public review stage?  
> Clever.

Andi, is this some kind of "destroy your years of kernel hacking 
credibility within a few days" contest that you are participating in?? 
What you are doing is getting really silly.

All ptrace cleanup patches from Roland were posted by him to lkml, and 
we picked them up from there. Review is ongoing, Roland replied to all 
feedback with more patches, and those were integrated as well. Final 
upstream merging of this depends on more review and test results (as 
usual), but it's looking good so far.

	Ingo
