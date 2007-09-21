Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXIUJJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXIUJJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXIUJJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:09:16 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:44839 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXIUJJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:09:15 -0400
Message-ID: <46F38A11.5040803@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2007 14:38:33 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce ext4_find_next_bit
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <46F36801.3070908@linux.vnet.ibm.com>
In-Reply-To: <46F36801.3070908@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Balbir Singh wrote:
> Aneesh Kumar K.V wrote:
>> Also add generic_find_next_le_bit
>>
>> This gets used by the ext4 multi block allocator patches.
>>
> 
> Looks like it's a straight forward on Little Endian Architectures.
> I see something for powerpc, what about other architectures?
> 
>
All include/asm-<arch>/bitops.h except powerpc have 

#include <asm-generic/bitops/ext2-non-atomic.h>

and ext2-non-atomic.h have #include <asm-generic/bitops/le.h>


-aneesh
