Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZBYN0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZBYN0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZBYN0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:26:33 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63445 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753416AbZBYN0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:26:32 -0500
Date: Wed, 25 Feb 2009 14:26:28 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
In-Reply-To: <20090225025605.GA30920@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.00.0902251425570.4063@vixen.sonytel.be>
References: <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be> <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au>
 <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be> <20090219040847.GA973@gondor.apana.org.au> <alpine.LRH.2.00.0902191005110.27630@vixen.sonytel.be> <20090219104250.GA9633@gondor.apana.org.au> <alpine.LRH.2.00.0902231822080.22762@vixen.sonytel.be>
 <20090225025605.GA30920@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Herbert Xu wrote:
> On Mon, Feb 23, 2009 at 06:32:19PM +0100, Geert Uytterhoeven wrote:
> >
> > Is the below (on top of my last patch series) what you have in mind?
> 
> Looks great to me!

OK.

> > Notes:
> >   - I had to drop the `const' from the `params' pointers of
> >     pcomp_alg.{,de}compress_setup().
> >     Trying to make nla_parse() take const nlattr structures instead seems to
> >     open a big can of worms...
> 
> I don't think that's a big deal.
> 
> >   - I should add a dependency of CONFIG_CRYPTO_ZLIB on CONFIG_NET (due to the
> >     need for nla_parse()). However, I don't like that.
> 
> Dave has OKed it for the attribute stuff to be moved into lib.
> So if you want to tackle that then be my guest :) Otherwise I'll
> look into moving it.

I already have a patch for that. I'll fold the netlink parsing into the
original series and will resubmit.

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
