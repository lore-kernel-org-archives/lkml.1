Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752049AbYLRM2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbYLRM2h (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYLRM22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:28:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58068 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYLRM21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:28:27 -0500
Date: Thu, 18 Dec 2008 13:28:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] more AMD IOMMU fixes for 2.6.28-rc8
Message-ID: <20081218122801.GC25715@elte.hu>
References: <20081217155415.GV3407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217155415.GV3407@amd.com>
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
> The following changes since commit 83fd5cc6481c6b7fa8b45f8a7e0aa7120213430b:
>   Joerg Roedel (1):
>         AMD IOMMU: allocate rlookup_table with __GFP_ZERO
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28
> 
> Joerg Roedel (2):
>       AMD IOMMU: set cmd buffer pointers to zero manually
>       AMD IOMMU: panic if completion wait loop fails
> 
>  arch/x86/kernel/amd_iommu.c      |    5 +++--
>  arch/x86/kernel/amd_iommu_init.c |    4 ++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> They fix another problem discovered in long-running reboot tests. Please 
> pull. The diff is attached.

pulled, thanks Joerg!

	Ingo
