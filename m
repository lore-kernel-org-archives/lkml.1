Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZAJXsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZAJXsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZAJXsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:48:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46617 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZAJXsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:48:41 -0500
Date: Sun, 11 Jan 2009 00:48:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 15/16] dma-debug: x86 architecture bindings
Message-ID: <20090110234818.GC20843@elte.hu>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-16-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231517970-20288-16-git-send-email-joerg.roedel@amd.com>
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

> @@ -175,6 +189,8 @@ dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
>  	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
>  
>  	BUG_ON(!valid_dma_direction(direction));
> +        debug_sync_single_range_for_device(hwdev, dma_handle, offset,

whitespace damage here.

	Ingo
