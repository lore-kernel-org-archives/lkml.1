Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbZLJNZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbZLJNZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbZLJNZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:25:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203AbZLJNZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:25:48 -0500
Date: Thu, 10 Dec 2009 14:25:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] AMD IOMMU fixes for 2.6.33
Message-ID: <20091210132546.GA2952@elte.hu>
References: <1260446135-16460-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260446135-16460-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 4528752f49c1f4025473d12bc5fa9181085c3f22:
>   Darrick J. Wong (1):
>         x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes
> 
> Joerg Roedel (2):
>       x86/amd-iommu: Fix passthrough mode
>       x86/amd-iommu: Fix PCI hotplug with passthrough mode
> 
>  arch/x86/include/asm/amd_iommu_proto.h |    4 ++-
>  arch/x86/kernel/amd_iommu.c            |   46 +++++++++++++++++++++++++++++---
>  arch/x86/kernel/amd_iommu_init.c       |    9 ++++++
>  3 files changed, 54 insertions(+), 5 deletions(-)
> 
> The data structure changes introduced a regression when the IOMMU runs in
> passthrough mode. These updates fix these regressions. Please pull.

Pulled, thanks a lot Joerg!

	Ingo
