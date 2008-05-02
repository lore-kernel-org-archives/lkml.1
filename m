Return-Path: <linux-kernel-owner+w=401wt.eu-S936361AbYEBWH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936361AbYEBWH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965015AbYEBWHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:07:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51352 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965016AbYEBWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:07:46 -0400
Subject: Re: 'global' rq->clock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: efault@gmx.de, elendil@planet.nl, parag.warudkar@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
In-Reply-To: <20080502.144827.158329188.davem@davemloft.net>
References: <200805022053.24779.elendil@planet.nl>
	 <1209756423.4693.8.camel@marge.simson.net> <1209758186.6929.18.camel@lappy>
	 <20080502.144827.158329188.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 03 May 2008 00:07:34 +0200
Message-Id: <1209766054.6929.29.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 14:48 -0700, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri, 02 May 2008 21:56:26 +0200
> 
> > Ok, the the below would need something that relates tick_timestamp's to
> > one another.. probably sucks without it..
> > 
> > OTOH, Andi said he was working on a fastish global sched_clock() thingy,
> > Andi got a link to that code?
> 
> While I'm fine with this kind of stuff being added to constantly cope
> with x86's joke of a TSC register implementation, it's starting to
> become an enormous burdon for platforms where the TICK source actually
> works properly.
> 
> Heck, on my Niagara2 chips, all 64 cpus use the same physical register
> for the TICK source, it physically can't get desynchronized :-)
> 
> So, a way to turn all of this muck off would be much appreciated.
> I'm happy to test anything on sparc64, and I'm sure the powerpc
> folks are as well.
> 
> And I also heard a rumor that Peter has access to a machine with a
> stable tick source for testing :-)

Yeah, I was thinking of a way for architectures to signify how much help
they need building the various clocks. Sparc, power and s390 would not
need any help.

