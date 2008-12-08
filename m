Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYLHOxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYLHOxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYLHOxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:53:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48751 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYLHOxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:53:00 -0500
Date: Mon, 8 Dec 2008 15:52:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc8
Message-ID: <20081208145251.GA20474@elte.hu>
References: <20081208143653.GQ12816@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208143653.GQ12816@amd.com>
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
> The following changes since commit 218d11a8b071b23b76c484fd5f72a4fe3306801e:
>   Jonathan Corbet (1):
>         Fix a race condition in FASYNC handling
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28
> 
> Joerg Roedel (5):
>       AMD IOMMU: fix iommu_map_page function
>       AMD IOMMU: fix loop counter in free_pagetable function
>       AMD IOMMU: fix typo in comment
>       AMD IOMMU: fix WARN_ON in dma_ops unmap path
>       AMD IOMMU: __unmap_single: check for bad_dma_address instead of 0
> 
>  arch/x86/kernel/amd_iommu.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> This are some small bugfixes which were found during the implementation
> of the KVM support and further code review. Please pull.

pulled into tip/x86/urgent, thanks Joerg!

	Ingo
