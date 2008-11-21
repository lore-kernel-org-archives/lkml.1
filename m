Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYKUQno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYKUQno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbYKUQnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:43:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbYKUQnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:43:15 -0500
Date: Fri, 21 Nov 2008 17:42:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 02/10] x86: add data structures for DMA-API debugging
Message-ID: <20081121164254.GC733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-3-git-send-email-joerg.roedel@amd.com>
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

> +#ifndef __ASM_X86_DMA_DEBUG
> +#define __ASM_X86_DMA_DEBUG
> +
> +/* Allocation flags */
> +#define DMA_DEBUG_SINGLE        0
> +#define DMA_DEBUG_SG            1
> +#define DMA_DEBUG_COHERENT      2

please use enum for such internal flags, not define.

> +
> +struct device;
> +struct list_head;
> +
> +struct dma_debug_entry {
> +	struct list_head list;
> +	struct device *dev;
> +	int type;
> +	void *cpu_addr;
> +	u64 dev_addr;
> +	u64 size;
> +	int direction;
> +};

please align new x86/include structures vertically like this:

> +struct dma_debug_entry {
> +	struct list_head	list;
> +	struct device		*dev;
> +	int			type;
> +	void			*cpu_addr;
> +	u64			dev_addr;
> +	u64			size;
> +	int			direction;
> +};

[ for the arts major students reading lkml ;-) ]

	Ingo
