Return-Path: <linux-kernel-owner+w=401wt.eu-S1764169AbYCGTG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764169AbYCGTG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762263AbYCGTGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:06:16 -0500
Received: from gherkin.frus.com ([192.158.254.49]:47187 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762355AbYCGTGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:06:15 -0500
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
In-Reply-To: <20080307162116.GA18563@jurassic.park.msu.ru> "from Ivan Kokshaysky
 at Mar 7, 2008 07:21:16 pm"
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date: Fri, 7 Mar 2008 13:06:10 -0600 (CST)
CC: FUJITA Tomonori <tomof@acm.org>, rct@frus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080307190610.2B4E2DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Fri, Mar 07, 2008 at 11:56:40PM +0900, FUJITA Tomonori wrote:
> > Very sorry, I probably broke the IOMMU. I don't have the hardware so
> > I've not tested the patches.
> 
> Unfortunately, I was not able to test these patches either, as my
> alpha with iommmu and scsi is disassembled at the moment, thanks to
> dead CPU fan...
> 
> (...)
> 
> Perhaps it was that, if the scsi driver set max_seg_size to something
> other than default 65536 (and not a power of two)...
> 
> Bob, can you give it a try?
> 
> diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
> index be6fa10..e07a23f 100644
> --- a/arch/alpha/kernel/pci_iommu.c
> +++ b/arch/alpha/kernel/pci_iommu.c
> (...)

In the interest of efficiency, I'll try Ivan's patch against -rc4 before
I do anything else (although I *do* have my git tree updated and ready
for abuse if it comes to that :-)).  New kernel is building: I'll be able
to test it in about five hours (when I can get back to where the machine
is).

As usual, thanks to everyone for the quick responses.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
