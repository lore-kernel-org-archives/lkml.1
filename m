Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbYFBMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbYFBMoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYFBMoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:44:08 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:35528 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbYFBMoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=HY0dsIY9lufe4hAEqimFXNRjkz9sBWd0HAskW2xoz0ukb/4vVsRbo2+xurUR0O+An3qp6Qkva863AqAnwQdLWTtSYqbk+kxLwm8C8XO022g/dEhDx/qJuiK2NSu8gchfvCsiO5wPQyEx7NZ+NYQdZnTTS1oHq+/LfiEjL1DnMjM=
Subject: Re: [PATCH -mm 03/14] bootmem: add documentation to API functions
From: Chris Malley <mail@chrismalley.co.uk>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080530194737.756122438@saeurebad.de>
References: <20080530194220.286976884@saeurebad.de>
	 <20080530194737.756122438@saeurebad.de>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Jun 2008 13:18:04 +0100
Message-Id: <1212409084.25657.0.camel@helix.beotel.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 21:42 +0200, Johannes Weiner wrote:

> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
> 
>  mm/bootmem.c |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 146 insertions(+), 1 deletion(-)
> 
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c

[snip]

>  
> +/**
> + * reserve_bootmem_node - mark a page range as reserved
> + * @addr: starting address of the range
> + * @size: size of the range in bytes

kerneldoc arguments don't match the actual function definition.

> + *
> + * Partial pages will be reserved.
> + *
> + * Only physical pages that actually reside on @pgdat are marked.
> + */
>  void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
>  				 unsigned long size, int flags)
>  {
> @@ -331,6 +390,16 @@ void __init reserve_bootmem_node(pg_data
>  }
>  
>  #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
> +/**
> + * reserve_bootmem - mark a page range as usable
> + * @addr: starting address of the range
> + * @size: size of the range in bytes


and here (missing @flags)

> ﻿﻿+ *
> + * Partial pages will be reserved.
> + *
> + * All physical pages within the range are marked, no matter what
> + * node they reside on.
> + */
>  int __init reserve_bootmem(unsigned long addr, unsigned long size,
>  			    int flags)
>  {
> @@ -499,6 +568,19 @@ found:
>  	return ret;
>  }
>  

cheers
Chris

