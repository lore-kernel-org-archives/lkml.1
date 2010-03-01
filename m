Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab0CAJdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:33:43 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:48636 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0CAJdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:33:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pBDRTNCbz1bSFu5FVbXEue4I5u5lvw9sNOTnaEkHGFGThZUWWT+hlTYXKEqC3Acyi8
         byBbLu2WpIfZDLqKlB+MLrW6zm2kWQIvjuDwLfmKCT5vWgce2y+O6iEaav+Ct8P9tULw
         c/BaGHfZg4ppSBkYCG0yMh25rfQFhu+bgdRJs=
MIME-Version: 1.0
In-Reply-To: <19339.35216.412591.13392@pilspetsen.it.uu.se>
References: <4B8984EE.8090605@gmail.com>
	 <20100228211511.60981829@infradead.org>
	 <19339.35216.412591.13392@pilspetsen.it.uu.se>
Date: Mon, 1 Mar 2010 11:33:40 +0200
Message-ID: <b6fcc0a1003010133w45515b17g365d42afd6407eb8@mail.gmail.com>
Subject: Re: [PATCH v1] compiler: prevent dead store elimination
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Arjan van de Ven <arjan@infradead.org>, Roel Kluin <roel.kluin@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, penberg@cs.helsinki.fi,
       Brian Gerst <brgerst@gmail.com>, andi@firstfloor.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       Herbert@gondor.apana.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 11:32 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Arjan van de Ven writes:
>  > On Sat, 27 Feb 2010 21:47:42 +0100
>  > Roel Kluin <roel.kluin@gmail.com> wrote:
>  > > +void secure_bzero(void *p, size_t n)
>  > > +{
>  > > +  memset(p, 0, n);
>  > > +  ARRAY_PREVENT_DSE(p, n);
>  > > +}
>  > > +EXPORT_SYMBOL(secure_bzero);
>  >
>  >
>  > please don't introduce bzero again to the kernel;
>  >
>  > make it secure_memset() please.

What's so secure in this function? :^)
