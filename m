Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYKUQ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYKUQ6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbYKUQ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:58:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbYKUQ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:58:32 -0500
Date: Fri, 21 Nov 2008 17:58:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 06/10] x86: add check code for map/unmap_sg code
Message-ID: <20081121165809.GF733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-7-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-7-git-send-email-joerg.roedel@amd.com>
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


please use this nice structure init style:

> +		entry->type      = DMA_DEBUG_SG;
> +		entry->dev       = dev;
> +		entry->cpu_addr  = sg_virt(s);
> +		entry->size      = s->length;
> +		entry->dev_addr  = s->dma_address;
> +		entry->direction = direction;

here too:

> +		struct dma_debug_entry ref = {
> +			.type = DMA_DEBUG_SG,
> +			.dev = dev,
> +			.cpu_addr = sg_virt(s),
> +			.dev_addr = s->dma_address,
> +			.size = s->length,
> +			.direction = dir,

	Ingo
