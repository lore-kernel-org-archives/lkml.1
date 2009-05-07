Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbZEGLT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbZEGLT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZEGLTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:19:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50207 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbZEGLTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:19:14 -0400
Date: Thu, 7 May 2009 13:18:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] remove DMA_nBIT_MASK macro
Message-ID: <20090507111846.GI28398@elte.hu>
References: <20090507141114M.fujita.tomonori@lab.ntt.co.jp> <4A0272C7.3060409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0272C7.3060409@cn.fujitsu.com>
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


* Yang Hongyang <yanghy@cn.fujitsu.com> wrote:

> FUJITA Tomonori wrote:
> > We replaced all DMA_nBIT_MASK macros with DMA_BIT_MASK(n) but why do
> > we still keep DMA_nBIT_MASK macros in include/linux/dma-mapping.h?
> > 
> > As long as these macros exist, people use them. The current git has
> > two users and linux-next have other users.
> > 
> > Is it better to remove DMA_nBIT_MASK macros completely now?

Can you see a way to emit build warnings? If yes then that might be 
a better solution instead of breaking in-the-pipeline code. We 
missed the upstream window of removing the facilities altogether, we 
could certainly do that in the next merge window though.

> CC:ingo
> 
> I have no objections,actually I used to remove all these defines in my
> first commit of these patch series,but got suggestions that keep these
> defines one more circle.Maybe it's time to remove these defines now or
> to remove at the end of this circle?
> 
> Reviewed-by:yanghy@cn.fujitsu.com

Thanks!

	Ingo
