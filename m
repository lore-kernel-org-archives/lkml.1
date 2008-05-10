Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYEJVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYEJVYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYEJVYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:24:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbYEJVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:24:24 -0400
Date: Sat, 10 May 2008 23:31:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       John Reiser <jreiser@BitWagon.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
Message-ID: <20080510213135.GD31954@one.firstfloor.org>
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com> <20080510123744.GB19109@one.firstfloor.org> <4825D8B4.3060600@goop.org> <20080510174841.GC31954@one.firstfloor.org> <4826095F.3070501@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4826095F.3070501@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, as soon as the stack pointer changes, everything below it is 
> invalidated (except if the stack-pointer change was actually determined 
> to be a stack switch).

It might in theory, but at least it doesn't for my test program.

-Andi
