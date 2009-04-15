Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZDOLVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZDOLVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbZDOLU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:20:59 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:39919 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752219AbZDOLU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:20:58 -0400
Date: Wed, 15 Apr 2009 19:20:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] crypto: add self-tests for rfc4309(ccm(aes))
Message-ID: <20090415112053.GA10188@gondor.apana.org.au>
References: <200904091434.59639.jarod@redhat.com> <20090410023108.GA7933@localhost.localdomain> <200904131703.50196.jarod@redhat.com> <200904131911.01596.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904131911.01596.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 07:11:00PM -0400, Jarod Wilson wrote:
>
> +			case -EBADMSG:
> +				if (template[i].novrfy)
> +					/* verification failure was expected */
> +					goto next_aead_vector;
>  				/* fall through */

We should also fail if novrfy is true and we get a 0 return value.

I'd also prefer to have the novrfy infrastructure changes to go
into a separate patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
