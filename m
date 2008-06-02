Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbYFBN7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbYFBN7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbYFBN7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:59:04 -0400
Received: from saeurebad.de ([85.214.36.134]:58254 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbYFBN7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:59:01 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Chris Malley <mail@chrismalley.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 03/14] bootmem: add documentation to API functions
References: <20080530194220.286976884@saeurebad.de>
	<20080530194737.756122438@saeurebad.de>
	<1212409084.25657.0.camel@helix.beotel.net>
Date: Mon, 02 Jun 2008 15:58:22 +0200
In-Reply-To: <1212409084.25657.0.camel@helix.beotel.net> (Chris Malley's
	message of "Mon, 02 Jun 2008 13:18:04 +0100")
Message-ID: <87d4n0rla9.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Chris Malley <mail@chrismalley.co.uk> writes:

> On Fri, 2008-05-30 at 21:42 +0200, Johannes Weiner wrote:
>
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>> ---
>> 
>>  mm/bootmem.c |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 146 insertions(+), 1 deletion(-)
>> 
>> --- a/mm/bootmem.c
>> +++ b/mm/bootmem.c
>
> [snip]
>
>>  
>> +/**
>> + * reserve_bootmem_node - mark a page range as reserved
>> + * @addr: starting address of the range
>> + * @size: size of the range in bytes
>
> kerneldoc arguments don't match the actual function definition.
>
>> + *
>> + * Partial pages will be reserved.
>> + *
>> + * Only physical pages that actually reside on @pgdat are marked.
>> + */
>>  void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
>>  				 unsigned long size, int flags)
>>  {
>> @@ -331,6 +390,16 @@ void __init reserve_bootmem_node(pg_data
>>  }
>>  
>>  #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
>> +/**
>> + * reserve_bootmem - mark a page range as usable
>> + * @addr: starting address of the range
>> + * @size: size of the range in bytes
>
>
> and here (missing @flags)
>
>> ﻿﻿+ *
>> + * Partial pages will be reserved.
>> + *
>> + * All physical pages within the range are marked, no matter what
>> + * node they reside on.
>> + */
>>  int __init reserve_bootmem(unsigned long addr, unsigned long size,
>>  			    int flags)
>>  {
>> @@ -499,6 +568,19 @@ found:
>>  	return ret;
>>  }
>>  

Will be updated in the next send-out.  Thanks for your time.

	Hannes
