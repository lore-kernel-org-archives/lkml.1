Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZB1NgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZB1NgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZB1NgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:36:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52592 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZB1NgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:36:15 -0500
Date: Sat, 28 Feb 2009 14:36:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck fix for -tip
Message-ID: <20090228133602.GB17097@elte.hu>
References: <20090228130732.GA19243@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228130732.GA19243@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> Here's a fix for the "Fatal error". It seems that we missed a 
> few of the places where page tables are allocated. In any 
> case, this fixes it for me, please let me know if you see any 
> more fatal errors after this.

ok, will do.

> The following changes since commit 39bc66625d7a761f6e5c5b3d81d88e7c9359ca84:
>   Ingo Molnar (1):
>         kmemcheck: fix split_page() of the page allocator, fix
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip
> 
> Vegard Nossum (2):
>       x86: don't track page tables with kmemcheck
>       Revert "kmemcheck: disable CPA self-test"
> 
>  arch/x86/Kconfig.debug |    1 -
>  arch/x86/mm/init_64.c  |    4 ++--
>  arch/x86/mm/pageattr.c |    2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)

Pulled into tip:kmemcheck, thanks Vegard!

	Ingo
