Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYHFNZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYHFNZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYHFNZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:25:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbYHFNZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:25:01 -0400
Message-ID: <4899A5BF.1040802@redhat.com>
Date: Wed, 06 Aug 2008 09:23:11 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: jbarnes@virtuousgeek.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <20080723221033.GD13662@8bytes.org>	<20080724081528F.fujita.tomonori@lab.ntt.co.jp>	<200807281523.35469.jbarnes@virtuousgeek.org> <20080730094303W.fujita.tomonori@lab.ntt.co.jp> <4899993D.3060109@redhat.com>
In-Reply-To: <4899993D.3060109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>>  
>>> @@ -265,7 +268,7 @@ static dma_addr_t dma_map_area(struct device 
>>> *dev, dma_addr_t phys_mem,
>>>  static dma_addr_t
>>>  gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, 
>>> int dir)
>>>  {
>>> -    dma_addr_t map = dma_map_area(dev, paddr, size, dir);
>>> +    dma_addr_t map = dma_map_area(dev, paddr, size, dir, size - 1);
>>>     
>
> Maybe I'm missing something -- what implies  size has to be a power of 
> two?
>
> P.
>

Ixnay that last comment -- I geddit (duh.).

The implication of "size-1" is that size is always a power of two.

Jesse -- I'll have to post a follow-up patch to fix this.

P.
