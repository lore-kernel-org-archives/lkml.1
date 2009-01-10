Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZAJXrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZAJXrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZAJXrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:47:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZAJXrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:47:10 -0500
Date: Sun, 11 Jan 2009 00:46:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 14/16] dma-debug: add checks for sync_single_sg_*
Message-ID: <20090110234641.GB20843@elte.hu>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-15-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231517970-20288-15-git-send-email-joerg.roedel@amd.com>
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

> +void debug_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
> +			   int nelems, int direction)
> +{
> +	struct scatterlist *s;
> +	int i;
> +
> +	if (global_disable)
> +		return;

"if (unlikely(global_disable))" i suspect?

	Ingo
