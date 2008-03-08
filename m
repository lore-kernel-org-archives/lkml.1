Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYCHBYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYCHBYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbYCHBYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:24:43 -0500
Received: from gherkin.frus.com ([192.158.254.49]:48653 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbYCHBYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:24:42 -0500
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
In-Reply-To: <20080307162116.GA18563@jurassic.park.msu.ru> "from Ivan Kokshaysky
 at Mar 7, 2008 07:21:16 pm"
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date: Fri, 7 Mar 2008 19:24:40 -0600 (CST)
CC: FUJITA Tomonori <tomof@acm.org>, rct@frus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080308012440.39177DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> Bob, can you give it a try?
> 
> Ivan.
> 
> diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
> index be6fa10..e07a23f 100644
> --- a/arch/alpha/kernel/pci_iommu.c
> +++ b/arch/alpha/kernel/pci_iommu.c

This fixes things for me.  I'm running 2.6.25-rc4 + the above patch as
I type this.

Thanks!

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
