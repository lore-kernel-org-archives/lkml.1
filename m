Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZBDJCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZBDJCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZBDJBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:01:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57991
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbZBDJBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:01:49 -0500
Date: Wed, 04 Feb 2009 01:01:46 -0800 (PST)
Message-Id: <20090204.010146.18100191.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: w@1wt.eu, zbr@ioremap.net, jarkao2@gmail.com, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090204085907.GA19388@gondor.apana.org.au>
References: <20090204081201.GB10445@ioremap.net>
	<20090204085432.GA21638@1wt.eu>
	<20090204085907.GA19388@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 4 Feb 2009 19:59:07 +1100

> On Wed, Feb 04, 2009 at 09:54:32AM +0100, Willy Tarreau wrote:
> >
> > My server is running 2.4 :-), but I observed the same issues with older
> > 2.6 as well. I can certainly imagine that things have changed a lot since,
> > but the initial point remains : jumbo frames are expensive to deal with,
> > and with recent NICs and drivers, we might get close performance for
> > little additional cost. After all, initial justification for jumbo frames
> > was the devastating interrupt rate and all NICs coalesce interrupts now.
> 
> This is total crap! Jumbo frames are way better than any of the
> hacks (such as GSO) that people have come up with to get around it.
> The only reason we are not using it as much is because of this
> nasty thing called the Internet.

Completely agreed.

If Jumbo frames are slower, it is NOT some fundamental issue.  It is
rather due to some misdesign of the hardware or it's driver.
