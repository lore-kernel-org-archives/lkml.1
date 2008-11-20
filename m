Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYKTJGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYKTJGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYKTJGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:06:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35370
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbYKTJGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:06:06 -0500
Date: Thu, 20 Nov 2008 01:06:06 -0800 (PST)
Message-Id: <20081120.010606.67799718.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: torvalds@linux-foundation.org, mingo@elte.hu, dada1@cosmosbay.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <200811182044.11055.nickpiggin@yahoo.com.au>
References: <alpine.LFD.2.00.0811171218470.18283@nehalem.linux-foundation.org>
	<20081117.125826.193693115.davem@davemloft.net>
	<200811182044.11055.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Tue, 18 Nov 2008 20:44:10 +1100

> On Tuesday 18 November 2008 07:58, David Miller wrote:
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > Date: Mon, 17 Nov 2008 12:30:00 -0800 (PST)
> >
> > > On Mon, 17 Nov 2008, David Miller wrote:
> > > > It's on my workstation which is a much simpler 2 processor
> > > > UltraSPARC-IIIi (1.5Ghz) system.
> > >
> > > Ok. It could easily be something like a cache footprint issue. And while
> > > I don't know my sparc cpu's very well, I think the Ultrasparc-IIIi is
> > > super- scalar but does no out-of-order and speculation, no?
> >
> > I does only very simple speculation, but you're description is accurate.
> 
> Surely it would do branch prediction, but maybe not indirect branch?

Right.
