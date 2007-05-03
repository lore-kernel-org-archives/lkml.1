Return-Path: <linux-kernel-owner+w=401wt.eu-S1031243AbXECN1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031243AbXECN1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031269AbXECN1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:27:44 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:60522 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031243AbXECN1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:27:43 -0400
Date: Thu, 3 May 2007 09:21:11 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Arne Georg Gleditsch <argggh@dolphinics.no>
cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       trivial@kernel.org, davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: convert crypto.h to UTF-8
In-Reply-To: <87r6pyqg2b.fsf@pelargir.dolphinics.no>
Message-ID: <alpine.DEB.0.98.0705030915240.21257@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
 <20070502044345.GA29384@gondor.apana.org.au> <alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
 <87r6pyqg2b.fsf@pelargir.dolphinics.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Did this file individually, per request. Will re-do the whole tree later 
> > as I'm still working on my handy-dandy testing and patching tools and 
> > don't have a lot of time outside of work until the summer gets underway.
> 
> While this is probably inevitable, it would be nice if there was some
> way to determine the actual coding system used for individual files.
> Especially if we're mixing latin1 and utf8 in the same tree.  Has
> something like adding "/* -*- coding: utf-8; -*- */" or similar to the
> top of converted files been considered?

There's no reason for any non-UTF-8 to be in the tree at all, so 
eventually it won't be a problem. I'm (slowly but surely) working on 
converting everything in the tree. GCC handles UTF-8 just fine, and all 
non-stupid/non-broken distributions of GNU/Linux and other major Un*ces 
should be based on (or at least compatible with) UTF-8 in basic 
operations. Files like the keymaps will be more work to convert, but they 
can be as well.

I'm operating on the assumption that anything in the tree that isn't UTF-8 
is ISO-8859-1. Of course, I'm also checking it by hand to make sure a 
small-O-with-umlaut doesn't become the Klingon logo...

Besides, based on the actual binary representation of UTF-8, it's 
extremely unlikely for any ISO-8859-1 string to be detected as UTF-8. VIm 
already does this: UTF-8 it handles natively, but open up one of these 
unpatched files in VIm and you'll see "[converted]" at the bottom of your 
screen. Should happen if you open the attached .patch.bin file in VIm.
