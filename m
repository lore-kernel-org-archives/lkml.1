Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZFGJiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZFGJiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZFGJiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:38:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33273 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbZFGJiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:38:05 -0400
Date: Sun, 7 Jun 2009 11:37:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] dma-debug updates for 2.6.31
Message-ID: <20090607093758.GD31286@elte.hu>
References: <20090603082654.GA22359@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603082654.GA22359@amd.com>
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
> The following changes since commit 83cce2b69eaa4bc7535f98f75b79397baf277470:
>   Joerg Roedel (1):
>         Merge branches 'amd-iommu/fixes', 'amd-iommu/debug', 'amd-iommu/suspend-resume' and 'amd-iommu/extended-allocator' into amd-iommu/2.6.31
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug/2.6.31
> 
> FUJITA Tomonori (3):
>       dma-debug: use sg_dma_address accessor instead of using dma_address directly
>       dma-debug: use sg_dma_len accessor
>       dma-debug: fix debug_dma_sync_sg_for_cpu and debug_dma_sync_sg_for_device
> 
> Joerg Roedel (6):
>       dma-debug: re-add dma memory leak detection
>       dma-debug: add variables and checks for driver filter
>       dma-debug: add debugfs file for driver filter
>       dma-debug: add dma_debug_driver kernel command line
>       dma-debug: add documentation for the driver filter
>       Merge branches 'dma-debug/fixes' and 'dma-debug/driver-filter' into dma-debug/2.6.31
> 
>  Documentation/DMA-API.txt           |   12 ++
>  Documentation/kernel-parameters.txt |    7 +
>  lib/dma-debug.c                     |  291 ++++++++++++++++++++++++++++++++---
>  3 files changed, 288 insertions(+), 22 deletions(-)
> 
> The changes include some fixes and a new feature, the driver 
> filter. With this filter the dma-debug code can be instrumented to 
> only print error messages originating by a selected driver. The 
> driver to filter for can be set by a kernel command line or by a 
> new file in debugfs. Please pull.

Pulled into tip:core/iommu, thanks a lot Joerg!

	Ingo
