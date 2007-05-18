Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbXERDTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbXERDTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbXERDTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:19:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3350 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755457AbXERDTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:19:40 -0400
Date: Fri, 18 May 2007 13:19:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Message-ID: <20070518031931.GA13048@gondor.apana.org.au>
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com> <20070514173823.GA7137@dreamland.darkstar.lan> <20070515014344.GA8850@gondor.apana.org.au> <20070515185212.GA18783@dreamland.darkstar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515185212.GA18783@dreamland.darkstar.lan>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 08:52:12PM +0200, Luca Tettamanti wrote:
>
> CONFIG_CRYPTO_ALGAPI=m

Are you sure you're actually running 2.6.22-rc1? Due to a bug
in the padlock patch present in 2.6.22-rc1 it shouldn't be
possible to select ALGAPI as a module.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
