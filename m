Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYLPTwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYLPTwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLPTwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:52:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41072 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYLPTwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:52:12 -0500
Date: Tue, 16 Dec 2008 20:51:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with
	remap_pfn_range and vm_insert_pfn
Message-ID: <20081216195154.GB4501@elte.hu>
References: <20081126002157.475142000@intel.com> <7E82351C108FA840AB1866AC776AEC464338C11E@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC464338C11E@orsmsx505.amr.corp.intel.com>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> Ingo,
> 
> Haven't seen any comments on the patches here. Can you push these 
> patches along to tip.

while the main focus of the changes are x86, they touch the MM 
non-trivially too:

   include/linux/mm.h |    9 +++++++++
   mm/memory.c        |    7 +++----
   2 files changed, 12 insertions(+), 4 deletions(-)

   mm/memory.c |    2 ++
   1 file changed, 2 insertions(+)

   include/linux/mm.h |    3 +++
   mm/memory.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
   2 files changed, 46 insertions(+)

   include/linux/mm.h |    6 +++++
   mm/memory.c        |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
   2 files changed, 59 insertions(+), 1 deletion(-)

So when you sent this a month ago i asked the MM folks whether they have 
any problems with these patches. Acks (or objections) from Andrew, Nick or 
Hugh would be nice to have.

	Ingo
