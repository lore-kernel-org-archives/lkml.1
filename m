Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbZD3JXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbZD3JXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZD3JXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:23:11 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:48700 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZD3JXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:23:09 -0400
Message-ID: <49F96DFF.2060105@in.ibm.com>
Date: Thu, 30 Apr 2009 14:53:11 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, dwmw2@infradead.org
Subject: Next April 30: x86 allnoconfig failure (iommu)
References: <20090430172923.bf9697c2.sfr@canb.auug.org.au>
In-Reply-To: <20090430172923.bf9697c2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todays Next tree build(x86 allnoconfig) failed with following
error.

arch/x86/built-in.o: In function `iommu_setup':
pci-dma.c:(.init.text+0x3101): undefined reference to `iommu_pass_through'
arch/x86/built-in.o: In function `pci_swiotlb_init':
(.init.text+0x805a): undefined reference to `iommu_pass_through'
make: *** [.tmp_vmlinux1] Error 1

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

