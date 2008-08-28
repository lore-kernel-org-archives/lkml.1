Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbYH1AtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbYH1AtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYH1AtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:49:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54951
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbYH1AtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:49:00 -0400
Date: Wed, 27 Aug 2008 17:48:55 -0700 (PDT)
Message-Id: <20080827.174855.126675086.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: andi@firstfloor.org, rick.jones2@hp.com, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, denys@visp.net.lb, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808281045.03460.nickpiggin@yahoo.com.au>
References: <20080827.151824.14173512.davem@davemloft.net>
	<20080827223952.GE26610@one.firstfloor.org>
	<200808281045.03460.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 28 Aug 2008 10:45:03 +1000

> On Thursday 28 August 2008 08:39, Andi Kleen wrote:
> > On Wed, Aug 27, 2008 at 03:18:24PM -0700, David Miller wrote:
> > > From: Andi Kleen <andi@firstfloor.org>
> > > Date: Wed, 27 Aug 2008 18:27:35 +0200
> > >
> > > > > Those banks really want to crank down on latency - to the point they
> > > > > start disabling interrupt coalescing.  I bet they'd toss anything out
> > > > > they could to shave another microsecond.
> > > >
> > > > This change would actually likely lower their latency.
> > >
> > > They want the timestamps, but they want it to match when the packet
> > > arrived at their system as closely as is reasonably possible.
> >
> > Then they should use hardware time stamps which are increasingly
> > available (e.g. current Intel e1000 design has them and I expect
> > others too).
> 
> Would it make sense to make a new option for these socket timestamps
> and encourage some apps move over to it?

We don't have support to using these specific hardware provided timestamps
sources yet, so it's kind of premature to recommend the facility to
applications. :)

