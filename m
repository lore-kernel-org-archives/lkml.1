Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZFPJx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZFPJx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZFPJxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:53:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42292 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZFPJxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:53:50 -0400
Date: Tue, 16 Jun 2009 11:53:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull][PATCH 0/2] dma-debug fixes
Message-ID: <20090616095345.GB6432@elte.hu>
References: <1245142330-7067-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245142330-7067-1-git-send-email-joerg.roedel@amd.com>
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
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug/fixes
> 
> Joerg Roedel (2):
>       dma-debug: check for sg_call_ents in best-fit algorithm too
>       dma-debug: be more careful when building reference entries
> 
>  lib/dma-debug.c |  149 ++++++++++++++++++++++++++++++++++++-------------------
>  1 files changed, 98 insertions(+), 51 deletions(-)
> 
> These patches fix some false positive warnings which occured also 
> with the change to the best-fit search in hash_bucket_find(). 
> Please pull.

Pulled, thanks Joerg!

	Ingo
