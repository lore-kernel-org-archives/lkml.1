Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYKUQ6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYKUQ6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbYKUQ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:57:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48017 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbYKUQ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:57:52 -0500
Date: Fri, 21 Nov 2008 17:57:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 07/10] x86: add checks for alloc/free_coherent code
Message-ID: <20081121165730.GE733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-8-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-8-git-send-email-joerg.roedel@amd.com>
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


please use this nice and clean structure init style:

> +	entry->type      = DMA_DEBUG_COHERENT;
> +	entry->dev       = dev;
> +	entry->cpu_addr  = virt;
> +	entry->size      = size;
> +	entry->dev_addr  = dma_addr;
> +	entry->direction = DMA_BIDIRECTIONAL;

here too:

> +	struct dma_debug_entry ref = {
> +		.type = DMA_DEBUG_COHERENT,
> +		.dev = dev,
> +		.cpu_addr = virt,
> +		.dev_addr = addr,
> +		.size = size,
> +		.direction = DMA_BIDIRECTIONAL,
> +	};

	Ingo
