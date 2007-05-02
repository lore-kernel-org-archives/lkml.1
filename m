Return-Path: <linux-kernel-owner+w=401wt.eu-S1767143AbXEBWnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767143AbXEBWnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767138AbXEBWnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:43:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:32548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767143AbXEBWng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,482,1170662400"; 
   d="scan'208";a="82901931"
Message-ID: <46391416.3020708@linux.intel.com>
Date: Wed, 02 May 2007 15:43:34 -0700
From: chandramouli narayanan <mouli@linux.intel.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21 2/3] x86_64: EFI64 support
References: <20070501185945.237601000@em64tdvp.jf.intel.com> <20070501190110.958988000@em64tdvp.jf.intel.com> <200705022255.37791.ak@suse.de>
In-Reply-To: <200705022255.37791.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>  		if (type && ei->type != type) 
>> @@ -148,6 +178,29 @@ int __init e820_all_mapped(unsigned long
>>  unsigned long __init find_e820_area(unsigned long start, unsigned long end, unsigned size) 
>>  { 
>>  	int i; 
>> +	if (efi_enabled) {
>> +		efi_memory_desc_t *md;
>>     
>
> Please convert the memory map from EFI into the e820 map in one place. This
> would avoid all these weird special cases. Also custom memory map would
> just work then.
>   
I will work on this and provide an update patch.
> I know i386 doesn't do it this way, but it's wrong and we'll eventually
> fix it there too.
>
> Also you have a few arbitary and white space changes in there that should be removed.
>
>   
oops! I will fix this too.
> -Andi
>   
- mouli
