Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZHMNbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZHMNbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 09:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZHMNbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 09:31:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:33244 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbZHMNbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:31:47 -0400
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>
Message-Id: <F7570C22-925A-4B34-AA27-04079071FD07@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1250159900.24143.7.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
Date: Thu, 13 Aug 2009 08:31:13 -0500
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1250142522.3587.110.camel@pasglop> <20090813160625B.fujita.tomonori@lab.ntt.co.jp> <20090813074131.GH12143@elte.hu> <1250150981.3587.157.camel@pasglop> <20090813085505.GA10671@elte.hu> <1250159900.24143.7.camel@pasglop>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 13, 2009, at 5:38 AM, Benjamin Herrenschmidt wrote:

> On Thu, 2009-08-13 at 10:55 +0200, Ingo Molnar wrote:
>
>>> Or we can have the patches in core/iommu and I pull the whole
>>> thing in powerpc-next. [...]
>>
>> Ok! We could also stage it a bit (one or two weeks) in a separate
>> branch and allow a rebase, should you find any bugs during testing?
>
> Sounds like a plan.
>
> I'll try to sort that out tomorrow, I can stick them in my -test  
> branch
> (which is rebase friendly) for a while too.

Getting them all in your -test branch gives Becky and I an opportunity  
to test them w/all the other PPC changes on the platforms we have that  
enable SWIOTLB today.

- k
