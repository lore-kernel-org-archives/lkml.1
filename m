Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753178AbYLRR2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYLRR2k (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYLRR2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:28:19 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56222 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752423AbYLRR2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:28:17 -0500
Date: Thu, 18 Dec 2008 18:28:09 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/8] crypto: compress - Add pcomp interface
In-Reply-To: <20081218061908.GB27951@gondor.apana.org.au>
Message-ID: <Pine.LNX.4.64.0812181820100.25762@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
 <20081217164036.539681327@vixen.sonytel.be> <20081218061908.GB27951@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, Herbert Xu wrote:
> On Wed, Dec 17, 2008 at 05:36:37PM +0100, Geert Uytterhoeven wrote:
> > @@ -3,7 +3,7 @@
> >  #
> >  
> >  obj-$(CONFIG_CRYPTO) += crypto.o
> > -crypto-objs := api.o cipher.o digest.o compress.o
> > +crypto-objs := api.o cipher.o digest.o compress.o pcompress.o
> 
> Sorry, you modelled it on the wrong type.  These are the original
> and obsolete types.  You should model it on one of the others.  I
> recommend the crypto_shash type which is most recent.

Can you please elaborate a bit more?

You mean pcomp should provide a struct crypto_type?
And the underlying algorithms shouldn't use crypto_alg directly anymore?

Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
