Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbXFKGxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbXFKGxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXFKGxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:53:09 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:54945 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXFKGxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:53:08 -0400
Date: Mon, 11 Jun 2007 15:51:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       Wolfgang Denk <wd@denx.de>
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070611065145.GA23404@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
	linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
	"Leech, Christopher" <christopher.leech@intel.com>,
	Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
	Wolfgang Denk <wd@denx.de>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <200706062132.37430.m.kozlowski@tuxland.pl> <20070606132439.3f59f0cf.akpm@linux-foundation.org> <20070606212831.GA1534@gondor.apana.org.au> <20070606164202.a3dcd176.akpm@linux-foundation.org> <Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr> <20070607070108.GA8013@gondor.apana.org.au> <20070607001218.742c0ba5.akpm@linux-foundation.org> <e9c3a7c20706102201y536de24ft2daf8fbed066e28f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20706102201y536de24ft2daf8fbed066e28f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 10:01:34PM -0700, Dan Williams wrote:
> Overall, I feel that async_tx is perhaps justifiably receiving the
> silent treatment because offload engines are not a mainstream
> occurrence.  Currently only people with an Xscale IOP or a PPC 440spe
> [4] will notice that mainline lacks support for all the features of
> their platform.  I see async_tx as a nod to the embedded space where
> offload engines act to make up for the absence of multi-Ghz CPUs with
> streaming SIMD instructions.
> 
For what it's worth, I'm planning on tying in the SH DMA stuff to
the dmaengine code, as the async_tx stuff certainly has quite a few bits
of interest. This is probably something I won't get around to for 2.6.23
though, due to time constraints.
