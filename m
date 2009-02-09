Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZBIKWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZBIKWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZBIKWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:22:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48225 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZBIKWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:22:24 -0500
Date: Mon, 9 Feb 2009 11:22:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: git pull: x86 header unification
Message-ID: <20090209102211.GJ20467@elte.hu>
References: <498CCFB5.3000706@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498CCFB5.3000706@goop.org>
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


(Cc:-ed lkml)

* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The following changes since commit 45c82b5a770be66845687a7d027c8b52946d59af:
>  Linus Torvalds (1):
>        Merge branch 'header-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git jsgf/x86/unify
>
> Thanks,
> 	J
>
> Jeremy Fitzhardinge (36):
>      x86: unify pte_none
>      x86: unify pte_same
>      x86: unify pte_present
>      x86: unify pud_present
>      x86: unify pgd_present
>      x86: unify pmd_present
>      x86: unify pmd_none
>      x86: unify pgd_page_vaddr
>      x86: unify pud_page_vaddr
>      x86: include pgtable_SIZE.h earlier
>      x86: unify pud_page
>      x86: unify pgd_page
>      x86: unify pud_index
>      x86: unify pud_offset
>      x86: unify pmd_page_vaddr
>      x86: unify pmd_page
>      x86: unify pmd_index
>      x86: unify pmd_offset
>      x86: remove redundant pfn_pmd definition
>      x86: unify pmd_pfn
>      x86: unify pmd_pfn
>      x86: unify pte_index
>      x86: unify pte_offset_kernel
>      x86: unify pud_large
>      x86: unify pgd_bad
>      x86: unify pgd_bad
>      x86: unify pmd_bad
>      x86: unify pages_to_mb
>      x86: unify pud_none
>      x86: unify pgd_none
>      x86: unify io_remap_pfn_range
>      x86: add and use pgd/pud/pmd_flags
>      x86: make pgd/pud/pmd/pte_none consistent
>      x86: asm/io.h: unify virt_to_phys/phys_to_virt
>      x86: asm/io.h: unify ioremap prototypes
>      x86: Fix compile error in arch/x86/kernel/early_printk.c
>
> arch/x86/include/asm/io.h             |   90 +++++++++++++++++
> arch/x86/include/asm/io_32.h          |   86 ----------------
> arch/x86/include/asm/io_64.h          |   59 -----------
> arch/x86/include/asm/page.h           |   15 +++
> arch/x86/include/asm/pgtable-2level.h |    2 -
> arch/x86/include/asm/pgtable-3level.h |   35 -------
> arch/x86/include/asm/pgtable.h        |  176 ++++++++++++++++++++++++++++++++-
> arch/x86/include/asm/pgtable_32.h     |   46 ---------
> arch/x86/include/asm/pgtable_64.h     |   64 ------------
> arch/x86/kernel/early_printk.c        |    1 -
> 10 files changed, 280 insertions(+), 294 deletions(-)

Pulled into tip/x86/headers, thanks Jeremy!

I'll keep watching out for any build fallout.

	Ingo
