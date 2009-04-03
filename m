Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbZDCO3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbZDCO3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZDCO3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:29:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbZDCO3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:29:40 -0400
Date: Fri, 3 Apr 2009 16:29:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] dma-debug fixes for 2.6.30-rc
Message-ID: <20090403142917.GA17804@elte.hu>
References: <20090403135014.GG22472@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403135014.GG22472@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 8fe74cf053de7ad2124a894996f84fa890a81093:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug
> 
> Joerg Roedel (1):
>       x86/dma: unify definition of pci_unmap_addr* and pci_unmap_len macros
> 
>  arch/x86/include/asm/pci.h    |   36 ++++++++++++++++++++++++++++++++----
>  arch/x86/include/asm/pci_32.h |   34 ----------------------------------
>  arch/x86/include/asm/pci_64.h |   22 ----------------------
>  3 files changed, 32 insertions(+), 60 deletions(-)
>  delete mode 100644 arch/x86/include/asm/pci_32.h

Pulled into x86/urgent, thanks Joerg!

> This unification fixes dma-debug false positives on i386 reporting 
> that a dma mapping was freed with another length than it was 
> allocated. The full diff is also attached. This patch is against 
> linus/master since your HEAD of latest tip/core/iommu branch is 
> currently 2.6.29 final. Please pull.

Yeah - we merged -tip to latest -git just yesterday, so some of the 
topics were still lagging behind.

I've forwarded core/iommu to latest -git, so it should be fine from 
now on to use as a base.

	Ingo
