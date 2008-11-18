Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYKRNwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYKRNwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYKRNv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:51:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46976 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYKRNvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:51:55 -0500
Date: Tue, 18 Nov 2008 14:51:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       hawk@pld-linux.org, stable@kernel.org
Subject: Re: [PATCH] x86: always select SWIOTLB on x86_64
Message-ID: <20081118135105.GD31146@elte.hu>
References: <1227008661-1609-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227008661-1609-1-git-send-email-joerg.roedel@amd.com>
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

> Impact: fixes korg bugzilla 11980
> 
> A kernel for a 64bit x86 system should always contain the swiotlb code
> in case it is booted on a machine without any hardware IOMMU supported
> by the kernel and more than 4GB of RAM. This patch changes Kconfig to
> always compile swiotlb into the kernel for x86_64.
> 
> Cc: hawk@pld-linux.org
> Cc: stable@kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/x86/iommu, thanks Joerg!

	Ingo
