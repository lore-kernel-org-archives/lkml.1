Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYLCLzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYLCLzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYLCLzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:55:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41884 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYLCLzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:55:36 -0500
Date: Wed, 3 Dec 2008 12:55:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc7
Message-ID: <20081203115516.GA20786@elte.hu>
References: <20081203115116.GF12816@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203115116.GF12816@amd.com>
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
> The following changes since commit 061e41fdb5047b1fb161e89664057835935ca1d2:
>   Linus Torvalds (1):
>         Linux 2.6.28-rc7
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28
> 
> Joerg Roedel (2):
>       AMD IOMMU: set device table entry for aliased devices
>       AMD IOMMU: fix possible race while accessing iommu->need_sync
> 
> Richard Kennedy (1):
>       AMD IOMMU: struct amd_iommu remove padding on 64 bit
> 
>  arch/x86/include/asm/amd_iommu_types.h |   24 ++++++++++----------
>  arch/x86/kernel/amd_iommu.c            |   36 ++++++++++++++-----------------
>  2 files changed, 28 insertions(+), 32 deletions(-)
> 
> Beside the patch from Richard it contains a fix for a possible race 
> condition and an fix necessary after a specification update. Find the 
> full diff attached. Please pull.

Pulled into tip/x86/urgent, thanks Joerg!

	Ingo
