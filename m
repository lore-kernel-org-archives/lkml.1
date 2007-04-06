Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXDFT07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXDFT07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXDFT07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:26:59 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49895 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXDFT06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:26:58 -0400
Date: Fri, 6 Apr 2007 12:23:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org,
       Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [stable] Linux 2.6.20.5
Message-ID: <20070406192354.GT10574@sequoia.sous-sol.org>
References: <20070406184208.GR10574@sequoia.sous-sol.org> <20070406184425.GS10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406184425.GS10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
> index 35172d3..a664231 100644
> --- a/crypto/scatterwalk.c
> +++ b/crypto/scatterwalk.c
> @@ -91,6 +91,8 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
>  		memcpy_dir(buf, vaddr, len_this_page, out);
>  		scatterwalk_unmap(vaddr, out);
>  
> +		scatterwalk_advance(walk, nbytes);
> +
>  		if (nbytes == len_this_page)
>  			break;
>  
> @@ -99,7 +101,5 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
>  
>  		scatterwalk_pagedone(walk, out, 1);
>  	}
> -
> -	scatterwalk_advance(walk, nbytes);
>  }
>  EXPORT_SYMBOL_GPL(scatterwalk_copychunks);

Argh, looks like 2.6.20.5 is brown paper bag material
