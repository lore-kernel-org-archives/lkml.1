Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZBPH5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZBPH5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZBPH5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:57:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZBPH5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:57:43 -0500
Date: Mon, 16 Feb 2009 08:57:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] some core Xen updates
Message-ID: <20090216075729.GA6182@elte.hu>
References: <49908591.5020406@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49908591.5020406@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
>
> Here's some core Xen changes: bug fixes, debuggability improvements and cleanups.
> These are based on tip/x86/xen, but I've merged in tip/master to bring it up to date
> before adding my changes.
>
> BTW, I killed off all the jsgf/* branches in xen.git, but I think you've either
> already picked up all the push requests, or I'll resend anything missing.
>
> Thanks,
> 	J
>
> The following changes since commit a1c51abb06bf03bef6ff973e43cf20a0fa48384f:
>  Ingo Molnar (1):
>        Merge branch 'x86/urgent'
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/core
>
> Ian Campbell (2):
>      Fix xen_flush_tlb_others
>      xen: record and display initiator of each multicall when debugging
>
> Jeremy Fitzhardinge (5):
>      Merge remote branch 'tip/master' into tip/fixups
>      xen: short-circuit tests for dom0
>      xen: degrade BUG to WARN when multicall fails
>      xen: do multicall callbacks with interrupts disabled
>      Merge branch 'tip/fixups' into xen/core
>
> arch/x86/include/asm/xen/hypervisor.h |   28 ++++++++++++++++++----------
> arch/x86/xen/mmu.c                    |    3 ---
> arch/x86/xen/multicalls.c             |   15 ++++++++++-----
> 3 files changed, 28 insertions(+), 18 deletions(-)

Pulled into tip:x86/xen, thanks Jeremy!

	Ingo
