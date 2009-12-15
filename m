Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZLOLoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZLOLoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZLOLoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:44:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZLOLoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:44:11 -0500
Date: Tue, 15 Dec 2009 12:43:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: bisected crash due to "x86: Move swiotlb initialization before
 dma32_free_bootmem"
Message-ID: <20091215114351.GA32722@elte.hu>
References: <4B2752A9.10903@kernel.org>
 <20091215182243R.fujita.tomonori@lab.ntt.co.jp>
 <20091215105650.GA13214@elte.hu>
 <20091215201039V.fujita.tomonori@lab.ntt.co.jp>
 <4B277235.4010308@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B277235.4010308@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 15 Dec 2009 11:56:50 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >>
> >>> There are a few people who hit this. How many people use a box with over 
> >>> 256GB memory?
> >>>
> >>> And you can work around this with "dma32_size" kernel boot option.
> >> Well, since the kernel has not crashed before this change there's really just 
> >> two options as per upstream kernel regression policy: either we fix it or we 
> >> revert it.
> > 
> > As I wrote, here is a patch that can be applied to cleanly to the git
> > head:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/tomo/misc/0001-x86-two-stage-swiotlb-initialization.patch
> > 
> > It fixes the problem. Yinghai, can you test it? It should work but
> > it's good to confirm it.
> 
> i tested already, it works.

Ok, mind someone please resend the agreed-upon patch with a Tested-by/Acked-by 
line so that i can apply it?

Thanks,

	Ingo
