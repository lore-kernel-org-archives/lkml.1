Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXKET6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXKET6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXKET63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:58:29 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54728 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbXKET62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:58:28 -0500
Date: Mon, 5 Nov 2007 20:58:27 +0100
From: Andreas Mohr <andi@lisas.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andreas Mohr <andi@lisas.de>, Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-ID: <20071105195827.GA24117@rhlx01.hs-esslingen.de>
References: <20071031211321.GA8363@rhlx01.hs-esslingen.de> <47290096.7080207@oracle.com> <20071101121133.GA14807@rhlx01.hs-esslingen.de> <20071101082457.ff9a5d67.randy.dunlap@oracle.com> <20071101221606.GA10116@rhlx01.hs-esslingen.de> <20071101160857.6e877307.rdunlap@xenotime.net> <20071102020118.GA13852@gondor.apana.org.au> <20071102200935.GA14153@rhlx01.hs-esslingen.de> <20071102131707.6023a5b7.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102131707.6023a5b7.rdunlap@xenotime.net>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 02, 2007 at 01:17:07PM -0700, Randy Dunlap wrote:
> On Fri, 2 Nov 2007 21:09:35 +0100 Andreas Mohr wrote:
> 
> > Hi,
> 
> > I'm now quite certain on which side to tweak things ;)
> 
> The other parts of your patch should probably be merged IMO.

Hmm, that particular part consists of _two_ transformations:
- removing the leading dot
- keep everything before [:punct:]

and the first transformation doesn't work on certain dash versions
the way it's currently coded.

> Would you resend a trimmed-down patch?
> or should I do it?

Feel free to go ahead, otherwise I'll try another patch sometime soon.
All I care about is that the result works on (at least)
one shell implementation _more_ than the current status ;)

Thanks a lot,

Andreas Mohr
