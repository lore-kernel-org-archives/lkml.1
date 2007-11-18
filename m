Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbXKREEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbXKREEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 23:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbXKREEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 23:04:46 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4496 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755269AbXKREEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 23:04:45 -0500
Date: Sun, 18 Nov 2007 12:04:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-crypto@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mb@bu3sch.de
Subject: Re: [RFC HIFN 00/02]: RNG support
Message-ID: <20071118040436.GA25705@gondor.apana.org.au>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain> <20071117195324.GA4010@2ka.mipt.ru> <20071118031402.GA25388@gondor.apana.org.au> <473FB1E0.600@trash.net> <20071118040401.GA25625@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071118040401.GA25625@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2007 at 12:04:01PM +0800, Herbert Xu wrote:
> On Sun, Nov 18, 2007 at 04:30:40AM +0100, Patrick McHardy wrote:
> >
> > On a related issue, I think the rng interface is not very suitable
> > for chips like HIFN that have a constant random bandwidth, it would
> > make a lot more sense to return the time to wait to the core, instead
> > of waiting 10us in all cases. 256 cycles at a speed of 266MHz comes
> > down to 0.96us, so we're waiting about 10 times as long as necessary.
> > Since its busy waiting anyway, I'd think that from a performance POV
> > constant polling or returning the exact amount of time would be more
> > reasonable.
> 
> I agree, a better interface would be to let the hardware do the
> blocking where necessary.

I meant the hardware driver of course.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
