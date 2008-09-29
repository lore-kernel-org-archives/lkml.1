Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYI2Hpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYI2Hpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 03:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYI2Hpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 03:45:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYI2Hpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 03:45:43 -0400
Date: Mon, 29 Sep 2008 09:45:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] kmemcheck updates (for -tip)
Message-ID: <20080929074530.GB9664@elte.hu>
References: <20080928170316.GA6893@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928170316.GA6893@localhost.localdomain>
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
> Here comes next batch of kmemcheck patches. Temporary work-around for
> x86_64 is to not track >4k pages. It would be nice to have this sorted
> out properly, but there is not enough time for me to look into it at
> the moment.
> 
> The following changes since commit 4b7f562ea9736b8b111ffeb60a7311075ce76849:
>   Ingo Molnar (1):
>         kmemcheck: build fix
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip
> 
> Vegard Nossum (4):
>       kmemcheck: hide/show pages in each iteration of a REP instruction #2
>       kmemcheck: lazy checking for MOVS instructions
>       Revert "kmemcheck: use set_memory_4k() instead of disabling PSE"
>       x86: use REP MOVS instruction for memcpy if kmemcheck is enabled
> 
>  arch/x86/Makefile                 |    5 ++
>  arch/x86/kernel/cpu/common.c      |    7 ++
>  arch/x86/kernel/head_32.S         |    2 +-
>  arch/x86/mm/init_32.c             |    2 +-
>  arch/x86/mm/kmemcheck/kmemcheck.c |  127 +++++++++++++++++++++++++++++++++++--
>  include/asm-x86/string_32.h       |    8 +++
>  include/asm-x86/string_64.h       |    8 +++
>  mm/kmemcheck.c                    |    8 +++
>  8 files changed, 159 insertions(+), 8 deletions(-)

pulled into tip/kmemcheck, thanks Vegard!

	Ingo
