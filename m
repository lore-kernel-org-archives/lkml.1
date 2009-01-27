Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZA0M6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZA0M6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbZA0M6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:58:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbZA0M6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:58:32 -0500
Date: Tue, 27 Jan 2009 13:58:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: intel_cacheinfo: fix compiler warning
Message-ID: <20090127125811.GC23121@elte.hu>
References: <497E6CAF.9030707@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E6CAF.9030707@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: fix compiler warning
> 
> fix the following warning;
>   CC      arch/x86/kernel/cpu/intel_cacheinfo.o
> arch/x86/kernel/cpu/intel_cacheinfo.c:314: warning: 'cpuid4_cache_lookup' defined but not used
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)

Applied to tip/cpus4096 (where this warning originates from), thanks!

	Ingo
