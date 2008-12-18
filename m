Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753296AbYLRVDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYLRVDV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYLRVDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:03:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYLRVDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:03:09 -0500
Date: Thu, 18 Dec 2008 22:02:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Becky Bruce <beckyb@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
        jbeulich@novell.com, joerg.roedel@amd.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
	of swiotlb
Message-ID: <20081218210231.GB24271@elte.hu>
References: <20081216203513.GA14787@elte.hu> <20081217142637V.fujita.tomonori@lab.ntt.co.jp> <4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp> <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org>
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


* Becky Bruce <beckyb@kernel.crashing.org> wrote:

>> Can you be more specific? What architecture is plan to use highmem 
>> support in swiotlb?
>
> 32-bit powerpc needs this support - I was actually about to push a 
> similar set of patches.  We have several processors that support 36 bits 
> of physical address space and do not have any iommu capability.  The 
> rest of the kernel support for those processors is now in place, so 
> swiotlb is the last piece of the puzzle for that to be fully functional.  
> I need to take a closer look at this series to see exactly what it's 
> doing and how it differs from what I've been testing.
>
> So there is another immediate use case, and I'd really hate to see this 
> code duplicated.  It should be entirely possible to remove the 
> assumption that we can save off the VA of the original buffer, which is 
> the thing that precludes HIGHMEM support, and still have nice readable, 
> maintainable code.

you can have a look at Jeremy's current lineup of patches in 
tip/core/iotlb:

   http://people.redhat.com/mingo/tip.git/README

(also integrated into tip/master)

What would be needed to make it suit your usecase too?

	Ingo
