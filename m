Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbYIEKuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbYIEKuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYIEKtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:49:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYIEKty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:49:54 -0400
Date: Fri, 5 Sep 2008 12:49:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: fix nommu_alloc_coherent allocation with NULL
	device argument
Message-ID: <20080905104910.GB17776@elte.hu>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080905104049.GY3189@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905104049.GY3189@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0013]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> I agree with this patch in principle. It fixes the problem. But I 
> think we should evaluate if we can change the dma_mask of the 
> fallback_dev to 24 bit.

ok - i kept this commit for now in tip/x86/iommu:

# 551b454: x86: gart alloc_coherent doesn't need to check NULL device argument

and will let you guys sort out how to do the others.

	Ingo
