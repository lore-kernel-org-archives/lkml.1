Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYGXP3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYGXP3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYGXP3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:29:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYGXP3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:29:20 -0400
Message-ID: <48889C2C.6030309@redhat.com>
Date: Thu, 24 Jul 2008 11:13:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <20080724123755.GP31439@8bytes.org>	<20080724223309C.fujita.tomonori@lab.ntt.co.jp>	<4888925E.8050504@redhat.com> <20080724234111I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080724234111I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So please tell us what driver you hit the bug with. Can you give us
> the details?
>
>   

Sorry Fujita,  I had to re-install and reboot the system to get those 
details.

The cciss driver is the one that really went haywire for me on the large 
system.

It does two greater than PAGE_SIZE pci_alloc_consistent() calls -- one 
with 0x3a800 and the other with 0x4800.  Both calls seem to complete but 
my cciss was completely hosed.  I couldn't access it at all :(

The tg3 (which alloc's 0x8000 and 0x4000) actually worked but the 
network wasn't working very well.

P.

> Thanks,
>   
