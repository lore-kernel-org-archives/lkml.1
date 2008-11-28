Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYK1MH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYK1MH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYK1MHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:07:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbYK1MHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:07:10 -0500
Date: Fri, 28 Nov 2008 13:06:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: move GART specific stuff from iommu.h to gart.h
Message-ID: <20081128120643.GE18333@elte.hu>
References: <1227807555-10499-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227807555-10499-1-git-send-email-joerg.roedel@amd.com>
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

> Impact: cleanup
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/include/asm/gart.h      |   33 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/iommu.h     |   33 ---------------------------------
>  arch/x86/kernel/amd_iommu.c      |    1 +
>  arch/x86/kernel/amd_iommu_init.c |    1 +
>  arch/x86/kernel/early-quirks.c   |    1 +
>  arch/x86/kernel/pci-dma.c        |    1 +
>  arch/x86/kernel/setup.c          |    1 +
>  7 files changed, 38 insertions(+), 33 deletions(-)

applied to tip/x86/iommu, thanks Joerg!

	Ingo
