Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZB1JQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZB1JQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZB1JOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:14:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47541 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbZB1JOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:14:36 -0500
Date: Sat, 28 Feb 2009 10:14:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck fixes for -tip
Message-ID: <20090228091424.GB20533@elte.hu>
References: <20090228091201.GA28985@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228091201.GA28985@damson.getinternet.no>
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
> I hope this fixes all outstanding problems. We'll have to look 
> more closely at the CPA conflict (just a temporary Kconfig 
> workaround in place now), but this should allow your testing 
> to continue.
> 
> The following changes since commit 42f6e3ebe50cc97ce0459d4be1bed66117d104c1:
>   Ingo Molnar (1):
>         Merge branch 'for-tip' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip
> 
> Pekka Enberg (1):
>       kmemcheck: make kconfig accessible for other architectures
> 
> Vegard Nossum (6):
>       kmemcheck: add opcode self-testing at boot
>       kmemcheck: decode sign/zero-extension move instructions correctly
>       kmemcheck: bitfields: introduce hack to work around gcc bug
>       trace: annotate bitfields in struct ring_buffer_event
>       kmemcheck: fix split_page() of the page allocator
>       kmemcheck: disable CPA self-test
> 
>  arch/x86/Kconfig                  |    1 +
>  arch/x86/Kconfig.debug            |   89 +-----------------------------------
>  arch/x86/mm/kmemcheck/Makefile    |    2 +-
>  arch/x86/mm/kmemcheck/kmemcheck.c |   38 +++++++++------
>  arch/x86/mm/kmemcheck/opcode.c    |   46 ++++++++++++++-----
>  arch/x86/mm/kmemcheck/selftest.c  |   69 ++++++++++++++++++++++++++++
>  arch/x86/mm/kmemcheck/selftest.h  |    6 +++
>  include/linux/kmemcheck.h         |    9 +++-
>  include/linux/ring_buffer.h       |    6 ++-
>  kernel/trace/ring_buffer.c        |    3 +
>  lib/Kconfig.debug                 |    2 +
>  lib/Kconfig.kmemcheck             |   91 +++++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c                   |    8 +++
>  13 files changed, 252 insertions(+), 118 deletions(-)
>  create mode 100644 arch/x86/mm/kmemcheck/selftest.c
>  create mode 100644 arch/x86/mm/kmemcheck/selftest.h
>  create mode 100644 lib/Kconfig.kmemcheck

Pulled, thanks Vegard!

	Ingo
