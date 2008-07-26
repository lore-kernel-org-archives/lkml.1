Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYGZNmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYGZNmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYGZNmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:42:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38567 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYGZNmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:42:19 -0400
Date: Sat, 26 Jul 2008 15:41:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080726134156.GC4401@elte.hu>
References: <20080725134159.GA7493@amd.com> <20080725225724J.fujita.tomonori@lab.ntt.co.jp> <20080725141425.GB7493@amd.com> <20080725233325W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725233325W.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Fri, 25 Jul 2008 16:14:25 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > > > If not, I suggest that we (you?) introduce one in a follow-on patch
> > > > series and fix the iommu_num_pages function then.
> > > 
> > > That's fine by me. Or I could try to find a solution and submit new
> > > patchset with your AMD and GART patches.
> > 
> > Thats also possible. But I prefer to fix that incrementally and merge
> > this first step.
> > 
> > > BTW, I prefer to push this patchset via -mm rather than x86 since
> > > after all we need to clean up all the IOMMUs.
> > 
> > Push it through -mm would make sense since it touches generic code in
> > lib/. On the other side in x86 we would avoid merge conflicts with
> > updates in AMD IOMMU and GART code.
> 
> Ok, I have no preference. It's not urgent and I can work on this later 
> on. I leave it to you and x86 maintainers.

ok, i'll apply the 3 patches to tip/x86/iommu. As usual, feel free to 
send IOMMU cleanups/generalizations/fixes against tip/master:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
