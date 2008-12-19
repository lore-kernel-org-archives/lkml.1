Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYLSITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYLSITV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYLSITE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:19:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35084 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbYLSITD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:19:03 -0500
Date: Fri, 19 Dec 2008 09:18:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: beckyb@kernel.crashing.org, jeremy@goop.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       jbeulich@novell.com, joerg.roedel@amd.com, benh@kernel.crashing.org
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
	of swiotlb
Message-ID: <20081219081835.GA9097@elte.hu>
References: <4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp> <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org> <20081219114808C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219114808C.fujita.tomonori@lab.ntt.co.jp>
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

> On Thu, 18 Dec 2008 12:17:54 -0600
> Becky Bruce <beckyb@kernel.crashing.org> wrote:
> 
> > > Can you be more specific? What architecture is plan to use highmem
> > > support in swiotlb?
> > 
> > 32-bit powerpc needs this support - I was actually about to push a  
> > similar set of patches.  We have several processors that support 36  
> > bits of physical address space and do not have any iommu capability.   
> > The rest of the kernel support for those processors is now in place,  
> > so swiotlb is the last piece of the puzzle for that to be fully  
> > functional.  I need to take a closer look at this series to see  
> > exactly what it's doing and how it differs from what I've been testing.
> 
> Ah, thanks,
> 
> Then I accept that highmem support in lib/swiotbl.c is generically 
> useful and we have to live with the ugly complication due to it.

Great! And we of course want to make the best possible job here - so 
whenever you notice any area that could be done better and less 
intrusively, please mention it.

	Ingo
