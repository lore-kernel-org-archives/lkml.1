Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZFIOV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZFIOV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZFIOVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:21:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbZFIOVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:21:17 -0400
Date: Tue, 9 Jun 2009 16:21:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull][PATCH 0/4] amd-iommu fixes for tip/core/iommu
Message-ID: <20090609142110.GB32703@elte.hu>
References: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
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
> The following changes since commit 62a6f465f6572e1f28765c583c12753bb3e23715:
>   Ingo Molnar (1):
>         Merge branch 'dma-debug/2.6.31' of git://git.kernel.org/.../joro/linux-2.6-iommu into core/iommu
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes
> 
> Jiri Slaby (1):
>       amd_iommu: fix lock imbalance
> 
> Joerg Roedel (4):
>       Merge commit 'tip/core/iommu' into amd-iommu/fixes
>       amd-iommu: remove BUS_NOTIFY_BOUND_DRIVER handling
>       amd-iommu: detach device explicitly before attaching it to a new domain
>       amd-iommu: remove unnecessary "AMD IOMMU: " prefix
> 
>  arch/x86/kernel/amd_iommu.c |   22 ++++++----------------
>  1 files changed, 6 insertions(+), 16 deletions(-)
> 
> These patches fix issues with device assignment to KVM, a possible
> deadlock due to an unreleased lock and a minor printk style issue.
> Please pull.

Pulled into tip:core/iommu, thanks a lot Joerg!

	Ingo
