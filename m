Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZAGNB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZAGNB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZAGNBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:01:45 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:41179 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750796AbZAGNBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:01:45 -0500
Date: Thu, 8 Jan 2009 00:01:29 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Willy Tarreau <w@1wt.eu>
Cc: Jarek Poplawski <jarkao2@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Changli Gao <xiaosuo@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107130129.GA26440@gondor.apana.org.au>
References: <20090106094138.GE25644@1wt.eu> <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124946.GA9677@ff.dom.local> <20090107125217.GA26235@gondor.apana.org.au> <20090107130031.GD6307@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107130031.GD6307@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 02:00:31PM +0100, Willy Tarreau wrote:
>
> that's what I was initially wondering about, but it looks like only linear
> data is copied. Will that cause too much a overhead ? (I don't like copying

For splicing from socket to socket or socket to file, all the
data will be linear with most drivers.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
