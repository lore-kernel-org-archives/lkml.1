Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZFPJw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZFPJw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZFPJwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:52:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbZFPJwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:52:19 -0400
Date: Tue, 16 Jun 2009 11:52:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [git pull][PATCH 0/6] amd-iommu fixes
Message-ID: <20090616095212.GA6432@elte.hu>
References: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 92db1e6af747faa129e236d68386af26a0efc12b:
>   Ingo Molnar (1):
>         Merge branch 'amd-iommu/fixes' of git://git.kernel.org/.../joro/linux-2.6-iommu into core/iommu
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes
> 
> Chris Wright (3):
>       amd-iommu: flush domain tlb when attaching a new device
>       amd-iommu: disable cmd buffer and evt logging before reprogramming iommu
>       amd-iommu: resume cleanup
> 
> Joerg Roedel (3):
>       amd-iommu: disable IOMMU hardware on shutdown
>       x86: disable IOMMUs on kernel crash
>       amd-iommu: set event buffer head and tail to 0 manually
> 
>  arch/x86/include/asm/amd_iommu.h |    2 ++
>  arch/x86/kernel/amd_iommu.c      |   16 ++++++++++++++++
>  arch/x86/kernel/amd_iommu_init.c |   26 +++++++++++++++++++-------
>  arch/x86/kernel/crash.c          |    6 ++++++
>  arch/x86/kernel/pci-dma.c        |    2 ++
>  5 files changed, 45 insertions(+), 7 deletions(-)
> 
> These patches mostly fixes issues in the AMD IOMMU driver with 
> kexec and kdump. Another fix is to disable the IOMMU hardware on 
> shutdown and crash to get out of the way for the BIOS. This fixed 
> power-off on my test machine. Please pull.

Pulled, thanks Joerg!

	Ingo
