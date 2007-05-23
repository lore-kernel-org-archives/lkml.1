Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbXEWVbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbXEWVbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbXEWVay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:30:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32881
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXEWVax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:30:53 -0400
Date: Wed, 23 May 2007 14:30:56 -0700 (PDT)
Message-Id: <20070523.143056.115914753.davem@davemloft.net>
To: mingo@elte.hu
Cc: herbert@gondor.apana.org.au, kaber@trash.net, kernel@prachanda.info,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, netdev@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070523114021.GA21880@elte.hu>
References: <46541DC4.4090501@trash.net>
	<20070523112559.GA24604@gondor.apana.org.au>
	<20070523114021.GA21880@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 23 May 2007 13:40:21 +0200

> 
> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > [NET_SCHED]: Fix qdisc_restart return value when dequeue is empty
> > 
> > My previous patch that changed the return value of qdisc_restart 
> > incorrectly made the case where dequeue returns empty continue 
> > processing packets.
> > 
> > This patch is based on diagnosis and fix by Patrick McHardy.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> also:
> 
>   Reported-and-debugged-by: Anant Nitya <kernel@prachanda.info>

Applied, thanks everyone.
