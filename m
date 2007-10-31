Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXJaLYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXJaLYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJaLYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:24:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56452 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbXJaLYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:24:39 -0400
Message-ID: <472865E8.4070908@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2007 16:54:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Swap delay accounting, include lock_page() delays
References: <20071031075243.22225.53636.sendpatchset@balbir-laptop> <200710311841.53671.nickpiggin@yahoo.com.au> <200710312010.33833.nickpiggin@yahoo.com.au>
In-Reply-To: <200710312010.33833.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 31 October 2007 18:41, Nick Piggin wrote:
>> On Wednesday 31 October 2007 18:52, Balbir Singh wrote:
>>> Reported-by: Nick Piggin <nickpiggin@yahoo.com.au>
>>>
>>> The delay incurred in lock_page() should also be accounted in swap delay
>>> accounting
>>>
>>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Ah right, I forgot to resend this one, sorry. Thanks for remembering.
> 
> Although, I think I had a bit more detail in the changelog which
> I think should be kept.
> 
> Basically, swap delay accounting seems quite broken as of now,
> because what it is counting is the time required to allocate a new
> page and submit the IO, but not actually the time to perform the IO
> at all (which I'd expect will be significant, although possibly in
> some workloads the actual page allocation will dominate).
> 

This looks quite good to me. I'm off attending a wedding, I'll resend
the patch when I am back.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
