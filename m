Return-Path: <linux-kernel-owner+w=401wt.eu-S1764310AbZANQqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764310AbZANQqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764160AbZANQpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:45:39 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:12743 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764156AbZANQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:45:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sj2GBgRvX1/QOtzVjLExTTTLE8g8HDJwj+VrYyCZ7Iks82H5PnH6a2hNkfiqmMbu+I
         C4v7/YVRQNqREH93PCytxdekw2lvszj+pbPxmY0xauqrtNkS3tf7tilY7XKjpcrdseuX
         cDEQcZh6fakdi+QGzWzSvEj/UlhQH2ntpRI44=
MIME-Version: 1.0
In-Reply-To: <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Date: Wed, 14 Jan 2009 22:15:37 +0530
Message-ID: <3f9a31f40901140845r6a0cd136ha27304c76001d1c7@mail.gmail.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 9:29 PM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:
> +static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pcomp *tfm)
> +{
> +       return __crypto_pcomp_alg(crypto_pcomp_tfm(tfm)->__crt_alg);
> +}
> +
> +static inline int crypto_pcomp_setup(struct crypto_pcomp *tfm,
> +                                    const void *params)
> +{
> +       return crypto_pcomp_alg(tfm)->setup(crypto_pcomp_tfm(tfm), params);
> +}
> +
> +static inline int crypto_pcomp_compress_init(struct crypto_pcomp *tfm)
> +{
> +       return crypto_pcomp_alg(tfm)->compress_init(crypto_pcomp_tfm(tfm));
> +}
> +
> +static inline int crypto_pcomp_compress_update(struct crypto_pcomp *tfm,
> +                                              struct comp_request *req)
> +{
> +       return crypto_pcomp_alg(tfm)->compress_update(crypto_pcomp_tfm(tfm),
> +                                                     req);
> +}
> +
> +static inline int crypto_pcomp_compress_final(struct crypto_pcomp *tfm,
> +                                             struct comp_request *req)
> +{
> +       return crypto_pcomp_alg(tfm)->compress_final(crypto_pcomp_tfm(tfm),
> +                                                    req);
> +}
> +
> +static inline int crypto_pcomp_decompress_init(struct crypto_pcomp *tfm)
> +{
> +       return crypto_pcomp_alg(tfm)->decompress_init(crypto_pcomp_tfm(tfm));
> +}
> +
> +static inline int crypto_pcomp_decompress_update(struct crypto_pcomp *tfm,
> +                                                struct comp_request *req)
> +{
> +       return crypto_pcomp_alg(tfm)->decompress_update(crypto_pcomp_tfm(tfm),
> +                                                       req);
> +}
> +
> +static inline int crypto_pcomp_decompress_final(struct crypto_pcomp *tfm,
> +                                               struct comp_request *req)
> +{
> +       return crypto_pcomp_alg(tfm)->decompress_final(crypto_pcomp_tfm(tfm),
> +                                                      req);
> +}

Can you please use expressive but short names ?

Thanks

--
JSR
