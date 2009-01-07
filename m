Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZAGNEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZAGNEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZAGNDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:03:53 -0500
Received: from 1wt.eu ([62.212.114.60]:1222 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbZAGNDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:03:52 -0500
Date: Wed, 7 Jan 2009 14:00:31 +0100
From: Willy Tarreau <w@1wt.eu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jarek Poplawski <jarkao2@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Changli Gao <xiaosuo@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107130031.GD6307@1wt.eu>
References: <20090106085442.GA9513@ff.dom.local> <20090106094138.GE25644@1wt.eu> <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124946.GA9677@ff.dom.local> <20090107125217.GA26235@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107125217.GA26235@gondor.apana.org.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:52:17PM +1100, Herbert Xu wrote:
> On Wed, Jan 07, 2009 at 12:49:46PM +0000, Jarek Poplawski wrote:
> > 
> > Hmm... in any case: take 3
> 
> Yes this should fix the corruption but it kind of defeats the
> purpose of splice by copying the data.

that's what I was initially wondering about, but it looks like only linear
data is copied. Will that cause too much a overhead ? (I don't like copying
at all anyway, but if it can help us find the cause, I'll happily test it).

BTW, Jarek, don't be sorry, I *am* expecting to crash my laptop a number of
times before ensuring the bug is fixed. I just don't want to lose my data.

Cheers,
Willy

