Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZBYOGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZBYOGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZBYOGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:06:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:51673 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZBYOGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:06:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hqoidH7n3mewFRExAiiIu7y9yCA493kwtzx8y9a6OW+yxwCBkBYSIA/3RQBiLvv1IV
         gwRwyOgsG5SOLV+pN64BoLgG3LDsZPIP/wSR2EX9coC9tqmjxKrieQ9l6UdCDc+Bw4i1
         SfCLa2XjgAFmx2bSGIiPjHF41TA4RNQLdWR1k=
MIME-Version: 1.0
In-Reply-To: <49A54C23.8090209@suse.de>
References: <49A54C23.8090209@suse.de>
Date: Wed, 25 Feb 2009 11:06:18 -0300
Message-ID: <82ecf08e0902250606g1e1a0a16l3a20fd1e8222d94e@mail.gmail.com>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
From: Thiago Galesi <thiagogalesi@gmail.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       Frank Seidel <frank@f-seidel.de>, akpm@linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
       lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        int i;
>        int ret;
>
> -       printk("\ntesting speed of %s\n", algo);
> +       printk(KERN_INFO "\ntesting speed of %s\n", algo);

Wouldn't it be better to take the first \n out as well??


-- 
-
Thiago Galesi
