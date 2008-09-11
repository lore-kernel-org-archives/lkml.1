Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbYIKIV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbYIKIV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYIKIVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:21:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45496 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbYIKIVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:21:15 -0400
Date: Thu, 11 Sep 2008 10:20:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: unify using pci_mmcfg_insert_resource
Message-ID: <20080911082059.GB27425@elte.hu>
References: <1220083122-4058-1-git-send-email-yhlu.kernel@gmail.com> <200809101149.06592.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101149.06592.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Ingo, is this stuff in the same branch with the BAR debugging fix?

it's in x86/core:

# x86/core: ebd60cd: x86: unify using pci_mmcfg_insert_resource

and has spread to other topics as well:

# irq/sparseirq: ebd60cd: x86: unify using pci_mmcfg_insert_resource
# timers/hpet-percpu: ebd60cd: x86: unify using pci_mmcfg_insert_resource
# x86/mm-debug: ebd60cd: x86: unify using pci_mmcfg_insert_resource
# x86/spinlocks: ebd60cd: x86: unify using pci_mmcfg_insert_resource
# x86/unify-cpu-detect: ebd60cd: x86: unify using pci_mmcfg_insert_resource

i.e. it's quite intervoven. You should be able to cherry pick it cleanly 
into your tree without any other -tip changes if you track -tip as a 
remote:

  git cherry-pick ebd60cd

if it's not that simple then please let me know and i'll separate it out 
into a separate, -git based topic.

	Ingo
