Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYGORID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYGORID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYGORHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:07:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:15008 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYGORHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QUtBk6VuuiAMVr2jfx/jAzgMLxVWg+qqFACU2GzeWvSXABvMG7IaYrKPm8s4fL0k2U
         f3dPIM3NKNpC5sP7AvRqiALoj2bXJel2UHGusM5umTLv2dVqc7rW/F8hWJu84DziRvLy
         XKEmJ9K2q3J+mimXrSAluTbIvVy+fHP2po9aI=
Message-ID: <6101e8c40807151007p3367a985sb3f70e876e109d76@mail.gmail.com>
Date: Tue, 15 Jul 2008 19:07:47 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.26
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
       stable@kernel.org
In-Reply-To: <20080710125126.GA25843@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080501102812.GA7151@gondor.apana.org.au>
	 <20080509132343.GA12979@gondor.apana.org.au>
	 <20080602080512.GA22059@gondor.apana.org.au>
	 <20080709003741.GA32340@gondor.apana.org.au>
	 <20080710125126.GA25843@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC stable]

On 7/10/08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Hi Linus:
>
> Just found a regression introduced back in 2.6.25.  This causes
> packet leaks when IPsec is in use.  When that leak grows it can
> eventually lead to hung connections (as their send buffers are
> used up) or worse.
>
> Please pull from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
>
> or
>
> master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
>
>
> Herbert Xu (1):
>       crypto: chainiv - Invoke completion function
>
>  crypto/chainiv.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> Thanks,
> --
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
