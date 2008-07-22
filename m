Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYGVOft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYGVOft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYGVOfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:35:41 -0400
Received: from saeurebad.de ([85.214.36.134]:50628 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYGVOfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:35:41 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [git pull] x86 fixes
References: <20080722140348.GA26267@elte.hu>
Date: Tue, 22 Jul 2008 16:35:14 +0200
In-Reply-To: <20080722140348.GA26267@elte.hu> (Ingo Molnar's message of "Tue,
	22 Jul 2008 16:03:48 +0200")
Message-ID: <87prp6j8bh.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar <mingo@elte.hu> writes:

> Linus,
>
> Please pull the latest x86 fixes git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
>
> Thanks,
>
> 	Ingo
>
> ------------------>
> Jan Kratochvil (1):
>       x86: fix crash due to missing debugctlmsr on AMD K6-3
>
> Jeremy Fitzhardinge (2):
>       x86: rename PTE_MASK to PTE_PFN_MASK
>       x86: add PTE_FLAGS_MASK

Are you serious?  It goes _this_ fast?  The patch came into my mbox at
8:00am this morning and you push it to Linus at 4:00pm already?

What about the inconsistency it introduces?  When I look at PAGE_MASK
for example, it masks out the PAGE offset.  PTE_MASK masks out PTE
specifca from a value.

Now, I assume PTE_PFN_MASK masks out the PFN.  Oh, wait, it masks the
protection bits.

Why not wait a bit longer before pushing things into mainline?

	Hannes
