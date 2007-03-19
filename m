Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbXCSLIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbXCSLIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 07:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbXCSLIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 07:08:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33038 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbXCSLIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 07:08:48 -0400
Date: Mon, 19 Mar 2007 12:08:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@mbligh.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070319110844.GA17402@one.firstfloor.org>
References: <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org> <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain> <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com> <20070316114415.GA26403@one.firstfloor.org> <Pine.LNX.4.64.0703181608320.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703181608320.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> And those machines are basically identical to perfectly regular i386 
> platforms.

For modern (2001+) i386 platforms sure. The problem is the old and the weird.

> 
> So the whole argument that it would "diverge" is total crap. It obviously 
> won't diverge, simply because the support for old setups is needed on 
> x86-64 *regardless* of whether 32-bit support exists on the same platform 
> or not.

There is still some unneeded old platform code on x86-64 that will
be removed (although I'm slowly discovering that some like the irq 0 
hacks are still needed :/). 

i386 support goes much farther back than the earlier x86-64
code supported, not even talking about complications like the weird
and fragile subarchs i386 has.

And x86-64 since it supports only modern systems is easier
to hack because it's much easier to regression test and only
needs to care about reasonably modern hardware. That is for 
example it has new smpboot and i386 doesn't and has extended 
per CPU IRQ vectors and i386 doesn't and has new machine check
code and i386 doesn't etc.etc.

It was basically a new start in many areas.

-Andi

