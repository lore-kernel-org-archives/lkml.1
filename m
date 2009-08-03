Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbZHCF4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbZHCF4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZHCF4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:56:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60552 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbZHCF4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:56:34 -0400
Date: Mon, 3 Aug 2009 07:56:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
	pci-dma-compat.h
Message-ID: <20090803055608.GB19428@elte.hu>
References: <20090714092354.GL19087@amd.com> <20090714.131224.205307048.davem@davemloft.net> <20090721160538.GL25756@amd.com> <20090721.121519.239732131.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721.121519.239732131.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Tue, 21 Jul 2009 18:05:38 +0200
> 
> > Hmm these checks sound specific and hard to maintain. I think 
> > its best to give architectures the option whether to enable this 
> > check or not.
> 
> No matter how the arch works in this area, there should be some 
> kind of sanity check.
> 
> So, it probably makes sense to allow an arch to override the 
> validation function rather than turn the test completely off.

I'm wondering how sparc32 handles core_kernel_text() & friends? 

Those functions already assume that the bits between _stext and 
_etext are all core kernel text and not generic pages freed back to 
the buddy.

	Ingo
