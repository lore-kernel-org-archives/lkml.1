Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYKUQkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYKUQkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYKUQkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:40:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbYKUQkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:40:35 -0500
Date: Fri, 21 Nov 2008 17:40:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 01/10] x86: add Kconfig entry for DMA-API debugging
Message-ID: <20081121164014.GB733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-2-git-send-email-joerg.roedel@amd.com>
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

> +config DMA_API_DEBUG
> +	default n

'default n' can be omitted in general from interactive Kconfig 
entries.

> +	bool "Enable debugging of DMA-API usage"
> +	depends on X86

perhaps add a proper dependency on iommu or swiotlb presence as well - 
in case we decide to make it all disable-able again and dont have the 
callbacks present?

	Ingo
