Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYLPTA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYLPTA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYLPTAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:00:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYLPTAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:00:49 -0500
Date: Tue, 16 Dec 2008 20:00:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU fix for 2.6.28-rc8
Message-ID: <20081216190021.GN11683@elte.hu>
References: <20081216182110.GQ3407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216182110.GQ3407@amd.com>
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
> 
> The following changes since commit 1bda71282ded6a2e09a2db7c8884542fb46bfd4f:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28
> 
> Joerg Roedel (1):
>       AMD IOMMU: allocate rlookup_table with __GFP_ZERO
> 
>  arch/x86/kernel/amd_iommu_init.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> Its an important fix for a bug which triggered a panic at boot in
> long-duration reboot tests. Please pull.

pulled into tip/x86/urgent, thanks Joerg!

	Ingo
