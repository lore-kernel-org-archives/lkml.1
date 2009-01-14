Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbZANL3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbZANL3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZANL3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:29:31 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:36471 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752587AbZANL3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:29:30 -0500
Date: Wed, 14 Jan 2009 22:29:03 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, zbr@ioremap.net, dada1@cosmosbay.com,
       w@1wt.eu, ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090114112903.GB18662@gondor.apana.org.au>
References: <20090114085308.GB4234@ff.dom.local> <20090114.012919.117682429.davem@davemloft.net> <20090114094215.GC4234@ff.dom.local> <20090114.020637.181791518.davem@davemloft.net> <20090114104716.GE4234@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114104716.GE4234@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:47:16AM +0000, Jarek Poplawski wrote:
>
> > > I don't think Herbert meant other ->sendpage() implementations, but I
> > > could miss something.
> > 
> > I think he did :-)
> 
> I hope Herbert will make it clear.

Yes I did mean the other splice paths, and in particular, the path
to disk.  I hope that's clear enough :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
