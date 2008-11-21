Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYKURAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYKURAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYKURAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:00:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52583 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYKURAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:00:11 -0500
Date: Fri, 21 Nov 2008 17:59:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 10/10] x86: add checks for sync_sg* code
Message-ID: <20081121165948.GG733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-11-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-11-git-send-email-joerg.roedel@amd.com>
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

> +	for_each_sg(sg, s, nelems, i)
> +		check_sync(dev, s->dma_address, s->dma_length, 0,
> +			   direction, true);

curly braces needed for the multi-line loop body.

> +	for_each_sg(sg, s, nelems, i)
> +		check_sync(dev, s->dma_address, s->dma_length, 0,
> +			   direction, false);

ditto.

	Ingo
