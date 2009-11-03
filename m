Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZKCPyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZKCPyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZKCPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:54:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZKCPyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:54:19 -0500
Date: Tue, 3 Nov 2009 16:53:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] IOMMU updates for 2.6.32-rc5
Message-ID: <20091103155358.GA19755@elte.hu>
References: <20091103112520.GI14009@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103112520.GI14009@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 012abeea669ea49636cf952d13298bb68654146a:
>   Linus Torvalds (1):
>         Linux 2.6.32-rc5
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes
> 
> Joerg Roedel (4):
>       x86/amd-iommu: Workaround for erratum 63
>       x86/amd-iommu: Un__init function required on shutdown
>       dma-debug: Fix compile warning with PAE enabled
>       Merge branches 'amd-iommu/fixes' and 'dma-debug/fixes' into iommu/fixes
> 
>  arch/x86/include/asm/amd_iommu.h |    1 +
>  arch/x86/kernel/amd_iommu.c      |    2 ++
>  arch/x86/kernel/amd_iommu_init.c |   24 +++++++++++++++++++++++-
>  lib/dma-debug.c                  |    6 ++++--
>  4 files changed, 30 insertions(+), 3 deletions(-)
> 
> The patches contain two important fixes for the AMD IOMMU driver (one
> erratum workaround and a section mismatch that only shows when the
> compiler does not inline the iommu_feature_disable function).
> Also included in this pull request is da dma-debug fix for a compilation
> warning on 32bit with PAE enabled. Please pull.

Pulled, thanks Joerg!

	Ingo
