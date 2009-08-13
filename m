Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZHMIKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZHMIKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZHMIKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:10:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:34746 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZHMIKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:10:07 -0400
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.orga,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090813074131.GH12143@elte.hu>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1250142522.3587.110.camel@pasglop>
	 <20090813160625B.fujita.tomonori@lab.ntt.co.jp>
	 <20090813074131.GH12143@elte.hu>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 18:09:41 +1000
Message-Id: <1250150981.3587.157.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ben, what's your preference? I waited for your reaction with these 
> bits, i.e. they are not in tip:core/iommu yet.

Oh I though they were... discard my previous private mail about
missing Ack's then :-)

I'll review them more in depth hopefully tomorrow but they look good.

> One variant would be what Fujita suggested: you could pull 
> core/iommu as a basis (it's a well-tested, problem-free tree at the 
> moment, with no big risky items), and then pull/apply the powerpc 
> specific bits from Fujita.

Or we can have the patches in core/iommu and I pull the whole thing
in powerpc-next. My main concern isn't which tree they go through but
that they are in powerpc-next for better testing.

Cheers,
Ben.

> A second variant would be that we could pull these bits into 
> core/iommu ... albeit you are right that the PowerPC tree is much 
> better at testing PowerPC patches.
> 
> A third variant would be to wait with these bits until the swiotlb 
> bits in core/iommu hit upstream. This would increase patch latency.
> 
> Any of these variants is good to me. What Fujita suggests seems to 
> be the best to me: #1 gets us the most testing and the lowest 
> latency - at the cost of tree dependency. We wont rebase core/iommu.
> 
> [ We've got three good tree properties: "tree independence",
>   "good testing", "low patch latency", but we cannot have all
>   three at once, we must pick two of them ;-) ]
> 
> 	Ingo

