Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbYEBVsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbYEBVsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbYEBVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:48:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57945
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbYEBVs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:48:28 -0400
Date: Fri, 02 May 2008 14:48:27 -0700 (PDT)
Message-Id: <20080502.144827.158329188.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: efault@gmx.de, elendil@planet.nl, parag.warudkar@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209758186.6929.18.camel@lappy>
References: <200805022053.24779.elendil@planet.nl>
	<1209756423.4693.8.camel@marge.simson.net>
	<1209758186.6929.18.camel@lappy>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 02 May 2008 21:56:26 +0200

> Ok, the the below would need something that relates tick_timestamp's to
> one another.. probably sucks without it..
> 
> OTOH, Andi said he was working on a fastish global sched_clock() thingy,
> Andi got a link to that code?

While I'm fine with this kind of stuff being added to constantly cope
with x86's joke of a TSC register implementation, it's starting to
become an enormous burdon for platforms where the TICK source actually
works properly.

Heck, on my Niagara2 chips, all 64 cpus use the same physical register
for the TICK source, it physically can't get desynchronized :-)

So, a way to turn all of this muck off would be much appreciated.
I'm happy to test anything on sparc64, and I'm sure the powerpc
folks are as well.

And I also heard a rumor that Peter has access to a machine with a
stable tick source for testing :-)
