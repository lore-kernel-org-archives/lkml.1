Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbZLOK5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbZLOK5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbZLOK5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:57:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43363 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759579AbZLOK5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:57:10 -0500
Date: Tue, 15 Dec 2009 11:56:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yinghai@kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org
Subject: Re: bisected crash due to "x86: Move swiotlb initialization before
 dma32_free_bootmem"
Message-ID: <20091215105650.GA13214@elte.hu>
References: <ada8wd4brwk.fsf@roland-alpha.cisco.com>
 <20091215175439V.fujita.tomonori@lab.ntt.co.jp>
 <4B2752A9.10903@kernel.org>
 <20091215182243R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215182243R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> There are a few people who hit this. How many people use a box with over 
> 256GB memory?
> 
> And you can work around this with "dma32_size" kernel boot option.

Well, since the kernel has not crashed before this change there's really just 
two options as per upstream kernel regression policy: either we fix it or we 
revert it.

	Ingo
