Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZCEN75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZCEN75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZCEN7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:59:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZCEN7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:59:48 -0500
Date: Thu, 5 Mar 2009 14:59:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: clean up use of system_state in
	virt_addr_valid and co
Message-ID: <20090305135939.GB14196@elte.hu>
References: <49AF35B0.2000302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AF35B0.2000302@goop.org>
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

> These two changes remove the tests based on system_state in the virt_addr_valid/phys_addr functions.
> It replaces the i386 test with an explicit flag to indicate whether the vmalloc range has been determined,
> and on x86-64, it pre-initializes the x86_phys_bits to a reasonable number so that there's no dependency
> on init order.
>
> 	J
>
> The following changes since commit 4d02f9f7dac27f801fed69be8ebb0b95b798b12c:
>  Ingo Molnar (1):
>        Merge branch 'x86/urgent'
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/virt
>
> Jeremy Fitzhardinge (2):
>      x86-32: use specific __vmalloc_start_set flag in __virt_addr_valid
>      x86-64: pre-initialize boot_cpu_data.x86_phys_bits to avoid system_state tests
>
> arch/x86/include/asm/pgtable_32_types.h |    5 +++++
> arch/x86/kernel/setup.c                 |    4 +++-
> arch/x86/mm/init_32.c                   |    3 +++
> arch/x86/mm/ioremap.c                   |   14 +++++---------
> 4 files changed, 16 insertions(+), 10 deletions(-)

Pulled into tip:x86/mm, thanks Jeremy!

Note, there were some conflicts with other changes so i 
cherry-picked them and fixed them up - please double-check the 
end result in tip:master.

Thanks,

	Ingo
