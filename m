Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZCXVTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZCXVTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZCXVRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:17:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47164
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbZCXVRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:17:15 -0400
Date: Tue, 24 Mar 2009 14:17:02 -0700 (PDT)
Message-Id: <20090324.141702.206697701.davem@davemloft.net>
To: mingo@elte.hu
Cc: herbert@gondor.apana.org.au, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090324205444.GA11693@elte.hu>
References: <20090324160241.GA11060@elte.hu>
	<20090324191900.GA24595@elte.hu>
	<20090324205444.GA11693@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 24 Mar 2009 21:54:44 +0100

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Same forcedeth box i reported before. Config below. (note: if 
> > > you want to use it you need to run it through 'make oldconfig', 
> > > with all defaults accepted)
> > 
> > Hm, i just had a test failure (hung interface) with this too.
> > 
> > I'll go back to the original straight revert of "303c6a0: gro: Fix 
> > legacy path napi_complete crash", and will test it overnight - to 
> > establish a baseline of stability again. (to make sure there are 
> > no other bugs interacting)
> 
> FYI, this plain revert is holding up fine in my tests so far - 50 
> random iterations - the previous one failed after 5 iterations.

Something must be up with respect to letting interrupts in during
certain windows of time, or similar.

I'll take a look at this and hopefully Herbert or myself will be
able to figure it out.
