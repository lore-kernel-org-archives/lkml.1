Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbXKQPah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbXKQPah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 10:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXKQPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 10:30:29 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4084 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbXKQPa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 10:30:28 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: andi@firstfloor.org (Andi Kleen)
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
Cc: alan@lxorguk.ukuu.org.uk, peterz@infradead.org, dmutters@gmail.com,
       mnemo@minimum.se, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <p737ikhat9x.fsf@bingen.suse.de>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1ItPbD-0005Vi-00@gondolin.me.apana.org.au>
Date: Sat, 17 Nov 2007 23:28:47 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
>
> Pretty much all the per process limits would need to be per uid to be really
> useful in general. I'm hoping that we'll get some of that out of the recent

You've hit the nail on the head.  I've always liked to have
per-uid limits on network sockets too as otherwise you either
have to cope with some rogue user taking all your TCP memory
away or worse all of your kernel memory.  Luckily the former
isn't fatal because each TCP socket has a guaranteed 4K so they
will still operate but it's still suboptimal.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
