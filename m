Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbZANBYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbZANBYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbZANBYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:24:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41251
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754733AbZANBY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:24:29 -0500
Date: Tue, 13 Jan 2009 17:24:30 -0800 (PST)
Message-Id: <20090113.172430.177897618.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: zbr@ioremap.net, dada1@cosmosbay.com, w@1wt.eu, ben@zeus.com,
       jarkao2@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090114005110.GA6814@gondor.apana.org.au>
References: <20090113.161625.111759506.davem@davemloft.net>
	<20090114005110.GA6814@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 14 Jan 2009 11:51:10 +1100

> We can probably do that for spliced data that end up going to
> the networking stack again.  However, as splice is generic the
> data may be headed to a destination other than the network stack.
> 
> In that case to make dataref work we'd need some mechanism
> that allows non-network entities to get/drop this ref count.

I see.

I'll think about this some more.
