Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759123AbYLPWIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbYLPWIV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYLPWIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:08:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58613 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYLPWIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:08:09 -0500
Date: Tue, 16 Dec 2008 23:07:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with
	remap_pfn_range and vm_insert_pfn
Message-ID: <20081216220746.GE14787@elte.hu>
References: <20081126002157.475142000@intel.com> <7E82351C108FA840AB1866AC776AEC464338C11E@orsmsx505.amr.corp.intel.com> <20081216195154.GB4501@elte.hu> <20081216220502.GC22722@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216220502.GC22722@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> On Tue, Dec 16, 2008 at 08:51:54PM +0100, Ingo Molnar wrote:
> > 
> > * Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
> > 
> > > Ingo,
> > > 
> > > Haven't seen any comments on the patches here. Can you push these 
> > > patches along to tip.
> > 
> > while the main focus of the changes are x86, they touch the MM 
> > non-trivially too:
> > 
> >    include/linux/mm.h |    9 +++++++++
> >    mm/memory.c        |    7 +++----
> >    2 files changed, 12 insertions(+), 4 deletions(-)
> > 
> >    mm/memory.c |    2 ++
> >    1 file changed, 2 insertions(+)
> > 
> >    include/linux/mm.h |    3 +++
> >    mm/memory.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
> >    2 files changed, 46 insertions(+)
> > 
> >    include/linux/mm.h |    6 +++++
> >    mm/memory.c        |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >    2 files changed, 59 insertions(+), 1 deletion(-)
> > 
> > So when you sent this a month ago i asked the MM folks whether they have 
> > any problems with these patches. Acks (or objections) from Andrew, Nick or 
> > Hugh would be nice to have.
> 
> Last I looked at them, I think all my questions were cleared up.

does that transform into a:

  Acked-by: Nick Piggin <npiggin@suse.de>

? :-)

	Ingo
