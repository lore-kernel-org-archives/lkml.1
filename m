Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYIRH1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYIRH1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYIRH1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:27:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbYIRH1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:27:39 -0400
Date: Thu, 18 Sep 2008 09:27:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] AMD IOMMU fixes for 2.6.27-rc6
Message-ID: <20080918072725.GA3750@elte.hu>
References: <20080917142338.GA24392@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917142338.GA24392@amd.com>
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
> please pull two fixes for possible race conditions in the AMD IOMMU
> command buffer handling code from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-2.6.27
> 
> These patches should be merged into 2.6.27 because they are important
> bugfixes. The diff is small enough so I attached it to this email.

pulled these two commits into tip/x86/urgent, thanks Joerg!

> Joerg Roedel (2):
>       AMD IOMMU: set iommu sunc flag after command queuing
>       AMD IOMMU: protect comletion wait loop with iommu lock

(FYI, i respun the commits, to fix the s/comletion/completion typo, and 
to rebase the fixes to -git.)

	Ingo
