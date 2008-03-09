Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYCIKVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYCIKVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYCIKVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:21:31 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:43024 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYCIKVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:21:30 -0400
Date: Sun, 9 Mar 2008 19:20:20 +0900
To: rct@frus.com, ink@jurassic.park.msu.ru
Cc: tomof@acm.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20080308012440.39177DBA2@gherkin.frus.com>
References: <20080307162116.GA18563@jurassic.park.msu.ru>
	<20080308012440.39177DBA2@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080309191950P.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 19:24:40 -0600 (CST)
rct@frus.com (Bob Tracy) wrote:

> Ivan Kokshaysky wrote:
> > Bob, can you give it a try?
> > 
> > Ivan.
> > 
> > diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
> > index be6fa10..e07a23f 100644
> > --- a/arch/alpha/kernel/pci_iommu.c
> > +++ b/arch/alpha/kernel/pci_iommu.c
> 
> This fixes things for me.  I'm running 2.6.25-rc4 + the above patch as
> I type this.

Great, thanks for testing!

Ivan, can you resend the patch with a description and signed-off-by?

Thanks,
