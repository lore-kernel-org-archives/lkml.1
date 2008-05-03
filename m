Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYECWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYECWbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYECWbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:31:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:34538 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYECWbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:31:37 -0400
Subject: Re: 'global' rq->clock
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, andi@firstfloor.org
In-Reply-To: <20080503.122734.01023096.davem@davemloft.net>
References: <20080503082849.GA29605@elte.hu>
	 <20080503.020502.226847930.davem@davemloft.net>
	 <20080503101016.GA18801@elte.hu>
	 <20080503.122734.01023096.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 04 May 2008 08:30:55 +1000
Message-Id: <1209853855.26383.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-03 at 12:27 -0700, David Miller wrote:
> > ( although please note that the growing generalization that goes on
> >   _did_ find a subtle nohz problem on sparc64 early in the merge
> window,
> >   so it's not like these changes are totally useless to you. )
> 
> Note that this bug theoretically exists on every platform,
> even x86, and only sparc64 is fixed at the moment by adding
> the irq_{entry,exit}() guards around all of it's IPI handlers.

What is the bug ?

IPIs on power are normal interrupts, so they do happen in irq_entry/exit
blocks but I'm curious to know what the root bug is :-)

Ben.


