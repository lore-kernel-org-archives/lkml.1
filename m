Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbXEXHOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbXEXHOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXEXHOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:14:45 -0400
Received: from [208.97.132.5] ([208.97.132.5]:40399 "EHLO
	spaceymail-a2.g.dreamhost.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755048AbXEXHOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:14:44 -0400
X-Greylist: delayed 27577 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 03:14:44 EDT
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
Date: Thu, 24 May 2007 12:42:29 +0530
User-Agent: KMail/1.9.6
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       herbert@gondor.apana.org.au, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, netdev@vger.kernel.org
References: <46541DC4.4090501@trash.net> <20070523114021.GA21880@elte.hu> <20070523.143056.115914753.davem@davemloft.net>
In-Reply-To: <20070523.143056.115914753.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241242.32125.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 03:00:56 David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 23 May 2007 13:40:21 +0200
>
> > * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > [NET_SCHED]: Fix qdisc_restart return value when dequeue is empty
> > >
> > > My previous patch that changed the return value of qdisc_restart
> > > incorrectly made the case where dequeue returns empty continue
> > > processing packets.
> > >
> > > This patch is based on diagnosis and fix by Patrick McHardy.
> > >
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >
> > also:
> >
> >   Reported-and-debugged-by: Anant Nitya <kernel@prachanda.info>
>
> Applied, thanks everyone.

Networking lag I been seeing since 2.6.22-rc1, disappeared after applying this 
patch. Thanks to everyone who helped me run my system sane again. :)

Reagards
Ananitya

-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
