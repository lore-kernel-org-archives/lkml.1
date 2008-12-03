Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYLCHYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYLCHYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYLCHYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:24:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865AbYLCHYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:24:36 -0500
Date: Wed, 3 Dec 2008 08:24:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [RESEND] [PATCH] x86: remove dead BIO_VMERGE_BOUNDARY
	definition
Message-ID: <20081203072414.GA17580@elte.hu>
References: <20081203145304E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203145304E.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This is for 2.6.29 (against tip/master), a resend of:
> 
> http://marc.info/?l=linux-kernel&m=122482703716620&w=2
>
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] x86: remove dead BIO_VMERGE_BOUNDARY definition
> 
> The block layer dropped the virtual merge feature
> (b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY
> definition is meaningless now.

ok - for the previous submission there was some discussion about 
what the dependencies of this cleanup are, so it got skipped. 
Looks good.

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  arch/x86/include/asm/io.h    |    2 --
>  arch/x86/include/asm/io_64.h |    2 --
>  arch/x86/kernel/pci-dma.c    |    6 ------
>  3 files changed, 0 insertions(+), 10 deletions(-)

applied to tip/x86/iommu, thanks!

	Ingo
