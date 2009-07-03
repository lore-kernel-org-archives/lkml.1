Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZGCI5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZGCI5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZGCI52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:57:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48735 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZGCI51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:57:27 -0400
Date: Fri, 3 Jul 2009 10:57:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] AMD IOMMU fixes for 2.6.31-rc1
Message-ID: <20090703085718.GJ21833@elte.hu>
References: <1246609753-30929-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246609753-30929-1-git-send-email-joerg.roedel@amd.com>
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
> The following changes since commit 7c5371c403abb29f01bc6cff6c5096abdf2dc524:
>   Yinghai Lu (1):
>         x86: add boundary check for 32bit res before expand e820 resource to alignment
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes
> 
> Joerg Roedel (2):
>       amd-iommu: handle alias entries correctly in init code
>       amd-iommu: set evt_buf_size correctly
> 
>  arch/x86/kernel/amd_iommu_init.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> These two patches fix an uncorrect device table initialization 
> issue and a divide-by-zero error on an event log interrupt. Please 
> pull.

Pulled, thanks a lot Joerg!

	Ingo
