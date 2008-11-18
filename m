Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYKRPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYKRPta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYKRPtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:49:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34031 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYKRPtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:49:22 -0500
Date: Tue, 18 Nov 2008 16:49:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
Message-ID: <20081118154904.GI30358@elte.hu>
References: <20081118154322.GX13394@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118154322.GX13394@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> (sorry for resend, forgot to add the mailing lists)
> 
> Hi Ingo,
> 
> 
> The following changes since commit 4e14e833ac3b97a4aa8803eea49f899adc5bb5f4:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../sfrench/cifs-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28
> 
> Joerg Roedel (4):
>       AMD IOMMU: add parameter to disable device isolation
>       AMD IOMMU: enable device isolation per default
>       AMD IOMMU: fix fullflush comparison length
>       AMD IOMMU: check for next_bit also in unmapped area
> 
>  Documentation/kernel-parameters.txt |    4 +++-
>  arch/x86/kernel/amd_iommu.c         |    2 +-
>  arch/x86/kernel/amd_iommu_init.c    |    6 ++++--
>  3 files changed, 8 insertions(+), 4 deletions(-)
> 
> As the most important change these patches enable device isolation 
> per default. Tests have shown that there are drivers which have bugs 
> and do double-freeing of DMA memory. This can lead to data 
> corruption with a hardware IOMMU when multiple devices share the 
> same protection domain. Therefore device isolation should be enabled 
> by default. The full diff of these changes is appended. Please pull.

pulled into tip/x86/urgent, thanks Joerg!

	Ingo
