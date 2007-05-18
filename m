Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXERNPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXERNPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXERNO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:14:59 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2082 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754997AbXERNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:14:59 -0400
Date: Fri, 18 May 2007 23:14:55 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Luca <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Message-ID: <20070518131455.GA20918@gondor.apana.org.au>
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com> <20070514173823.GA7137@dreamland.darkstar.lan> <20070515014344.GA8850@gondor.apana.org.au> <20070515185212.GA18783@dreamland.darkstar.lan> <20070518031931.GA13048@gondor.apana.org.au> <68676e00705180509s64b737e2k37c5b2e713c96932@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68676e00705180509s64b737e2k37c5b2e713c96932@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 02:09:54PM +0200, Luca wrote:
> 
> Well, pretty sure. The OOPS says 2.6.22-rc1-libata-g705962cc-dirty,
> git agrees and I've done a full rebuild. The .config is generated
> using 'make oldconfig' using the 2.6.21 as baseline, maybe ALGAPI is
> coming from there?

Sorry, my mistake.  That bug only happens if you have padlock turned on.

Anyway, if possible could you post the complete dmesg when it crashes?
I'd like to see what has happened up to the point where it crashes.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
