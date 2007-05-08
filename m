Return-Path: <linux-kernel-owner+w=401wt.eu-S967315AbXEHLSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967315AbXEHLSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967301AbXEHLSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:18:41 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4839 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967311AbXEHLSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:18:40 -0400
Message-ID: <46405C92.1080003@shadowen.org>
Date: Tue, 08 May 2007 12:18:42 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Shani Moideen <shani.moideen@wipro.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: Re: [KJ PATCH] Replacing memset(<addr>,0,PAGE_SIZE) with clear_page()
 in mm/memory.c
References: <1178621156.3598.10.camel@shani-win>
In-Reply-To: <1178621156.3598.10.camel@shani-win>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shani Moideen wrote:
> Hi,
> 
> Replacing memset(<addr>,0,PAGE_SIZE) with clear_page() in mm/memory.c.
> 
> Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
> ----
> 
> thanks.
> 
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index e7066e7..2780d07 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1505,7 +1505,7 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
>                  * zeroes.
>                  */
>                 if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE))
> -                       memset(kaddr, 0, PAGE_SIZE);
> +                       clear_page(kaddr);
>                 kunmap_atomic(kaddr, KM_USER0);
>                 flush_dcache_page(dst);
>                 return;
> 
> 

This looks to be whitespace dammaged?

-apw

use tabs not spaces
PATCH: -:64:
FILE: b/mm/memory.c:1508:
+                       clear_page(kaddr);$

