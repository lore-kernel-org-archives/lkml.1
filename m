Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYDCKt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYDCKt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 06:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYDCKtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 06:49:21 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:39007 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYDCKtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 06:49:20 -0400
Message-ID: <47F4B625.7030007@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2008 16:19:09 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel.send@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Badari Pulavarty <pbadari@us.ibm.com>, michael@ellerman.id.au,
       linuxppc-dev@ozlabs.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: make mem_map allocation continuous v2.
References: <200804021525.48799.yhlu.kernel@gmail.com> <20080402155247.5e746be7.akpm@linux-foundation.org> <86802c440804021744m7c6e3d94vcb6af3ebcaa71b5b@mail.gmail.com> <200804021830.24563.yhlu.kernel@gmail.com> <20080402192223.5e8754a0.akpm@linux-foundation.org> <86802c440804022116j2a8fb745pf734f61542a8e287@mail.gmail.com>
In-Reply-To: <86802c440804022116j2a8fb745pf734f61542a8e287@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Apr 2, 2008 at 7:22 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Wed, 2 Apr 2008 18:30:24 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>>
>>  > v2 replace:
>>  >       [PATCH] mm: make mem_map allocation continuous.
>>  >       [PATCH] mm: allocate section_map for sparse_init
>>  >       [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
>>  >
>>
>>  err, no.
>>
>>
>>  >
>>  > diff --git a/mm/sparse.c b/mm/sparse.c
>>  > index f6a43c0..2881222 100644
>>  > --- a/mm/sparse.c
>>  > +++ b/mm/sparse.c
>>
>>  Sorry, but I'd rather not do it this way.  We presently have this:
>>
> 
> it replaces
> 
>>  mm-make-mem_map-allocation-continuous.patch
>>  mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
>>  mm-allocate-section_map-for-sparse_init.patch
>>  mm-allocate-section_map-for-sparse_init-update.patch
>>  mm-allocate-section_map-for-sparse_init-update-fix.patch
>>  mm-allocate-section_map-for-sparse_init-powerpc-fix.patch
> 
> others still needed
> 
> so mm-make-mem-map-allocation-continuous.patch will not break powerpc and ia64
> 
> YH
Hi,

Thanks, the patch fixes the issue. I am able to bootup without the kernel panic.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> 

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
