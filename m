Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYEFSTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYEFSTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYEFSSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:18:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:28666 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYEFSSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VE5O4Z4MiVczVqrTR4VJj0K7czaZpr5+JRIqHWmk4p8Y/cX1mVvHMpRZas0oq8qtGW/8J9oiKFjkGufLjsWty6XeGEBlft45InRzftv702dn78qnfUcvTTRSKLocwkfQ+ufE3nNohg3rzfu+8P6qGexQWZhHL0aNDbF43wWoTJE=
Message-ID: <6101e8c40805061118u440cb332vf128085bb7df98c@mail.gmail.com>
Date: Tue, 6 May 2008 20:18:28 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] mm/page_alloc.c: fix a typo
Cc: "Andrew Morton" <akpm@linux-foundation.org>, clameter@sgi.com,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, stable@kernel.org
In-Reply-To: <4820272C.4060009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4820272C.4060009@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: stable

On 5/6/08, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bdd5c43..d0ba10d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -303,7 +303,7 @@ static void destroy_compound_page(struct page *page,
> unsigned long order)
>  	for (i = 1; i < nr_pages; i++) {
>  		struct page *p = page + i;
>
> -		if (unlikely(!PageTail(p) |
> +		if (unlikely(!PageTail(p) ||
>  				(p->first_page != page)))
>  			bad_page(page);
>  		__ClearPageTail(p);
> -- 1.5.4.rc3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
