Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYGXOds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYGXOds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYGXOdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:33:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbYGXOdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:33:39 -0400
Message-ID: <4888925E.8050504@redhat.com>
Date: Thu, 24 Jul 2008 10:31:58 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <488854DB.60307@redhat.com>	<20080724193457S.fujita.tomonori@lab.ntt.co.jp>	<20080724123755.GP31439@8bytes.org> <20080724223309C.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080724223309C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> But I think Prarit is right with this change. If the interface defines
>> this behavior the IOMMU drivers have to implement it. I am just
>> wondering that the problem never showed up before. The GART driver is a
>> few years old now.
>>     
>
> Yeah, I'm not against fixing IOMMUs to make alloc_consistent return
> the reqeuested size aligned memory. My point is that it's not likely
> to fix anything. Even with the patch, we hit the above problem because
> as I explained, the root cause of the problem is the boundary issue;
> we need to fix pci-dma.c
>
>   

Sorry, I misquoted code up there and was looking for a clear example of 
where this would happen.  The issue I'm trying to resolve didn't happen 
on the skge -- it was just a convenient piece of code to examine and 
point out ;)

P.
