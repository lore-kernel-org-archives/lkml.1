Return-Path: <linux-kernel-owner+w=401wt.eu-S1751235AbZL1IYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbZL1IYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZL1IYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:24:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52698 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZL1IYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:24:50 -0500
Date: Mon, 28 Dec 2009 09:24:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IOMMU updates for 2.6.33-rc1
Message-ID: <20091228082427.GF28652@elte.hu>
References: <1261408929-6261-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261408929-6261-1-git-send-email-joerg.roedel@amd.com>
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
> 
> The following changes since commit 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f:
>   Linus Torvalds (1):
>         Linux 2.6.33-rc1
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes
> 
> Joerg Roedel (2):
>       x86/amd-iommu: Fix initialization failure panic
>       Merge branches 'dma-debug/fixes' and 'amd-iommu/fixes' into iommu/fixes
> 
> Shaun Ruffell (1):
>       dma-debug: Do not add notifier when dma debugging is disabled.
> 
>  arch/x86/kernel/amd_iommu_init.c |   10 ++++++++++
>  lib/dma-debug.c                  |    5 +++++
> 
> These two patches fix possible kernel null-pointer dereferences in the 
> initialization path of AMD IOMMU and the device notifier path of dma-debug. 
> Please pull.
> 
> 	Joerg
> 
>  2 files changed, 15 insertions(+), 0 deletions(-)

Pulled, thanks a lot Joerg!

	Ingo
