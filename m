Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbXKRK2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbXKRK2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXKRK2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:28:37 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46162
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXKRK2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:28:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC HIFN 00/02]: RNG support
Date: Sun, 18 Nov 2007 11:27:27 +0100
User-Agent: KMail/1.9.6
Cc: Patrick McHardy <kaber@trash.net>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       linux-crypto@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain> <473FB1E0.600@trash.net> <20071118040401.GA25625@gondor.apana.org.au>
In-Reply-To: <20071118040401.GA25625@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711181127.28326.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 November 2007 05:04:01 Herbert Xu wrote:
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
> 
> Michael, what do you think about this?

Patches are welcome. ;)

-- 
Greetings Michael.
