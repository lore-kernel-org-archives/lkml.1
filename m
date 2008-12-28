Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYL1Jps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYL1Jps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 04:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL1Jpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 04:45:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYL1Jpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 04:45:38 -0500
Date: Sun, 28 Dec 2008 10:45:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, jeremy@goop.org,
       joerg.roedel@amd.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 0/3] swiotlb cleanups
Message-ID: <20081228094522.GD9022@elte.hu>
References: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20081228090537.GA9022@elte.hu> <20081228183522O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228183522O.fujita.tomonori@lab.ntt.co.jp>
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

> On Sun, 28 Dec 2008 10:05:37 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > This is minor swiotlb cleanups. It depends on the swiotlb highmem
> > > patchset:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git swiotlb
> > 
> > thanks, applied them to tip/core/iommu - after Becky's patchset as ported 
> > by Jeremy.
> 
> Thanks,
> 
> The log of tip/core/iommu looks really wired. Two patches claim to add 
> highmem support to swioblb. Becky completely reverts the Jeremy's and 
> does in a different way without any description.

one is Jeremy's that was tested on Xen. The other is Becky's stuff - that 
also extends it to powerpc - that is not yet fully tested though.

> As I wrote, I recommend you to reorder the patches. There is no point to 
> merge Jeremy's highmem patch.

"reordering" commits is not acceptable at this stage, we do append-only 
steps. If you can see any bug in the end result, let us know.

	Ingo
