Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYEJVgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYEJVgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYEJVgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:36:44 -0400
Received: from jade.aracnet.com ([216.99.193.136]:41554 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYEJVgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:36:43 -0400
Message-ID: <482613B6.2080301@BitWagon.com>
Date: Sat, 10 May 2008 14:29:26 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com> <20080510123744.GB19109@one.firstfloor.org> <4825D8B4.3060600@goop.org> <20080510174841.GC31954@one.firstfloor.org> <4826095F.3070501@goop.org>
In-Reply-To: <4826095F.3070501@goop.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> Determining stack
> boundaries has always been a bit fraught.  Typically a stack switch has
> been determined heuristically by looking for a "large" change in stack
> pointer, but there's a callback to specifically mark a range of memory
> as a stack, so that movements into and out of a stack can be determined
> as a switch (added specifically to deal with small densely packed stacks
> in uml).

The valgrind+uml patches added a callback, "I am switching stacks >NOW<."
If possible then it is better to tell an interpreter what is happening,
rather than requiring that the interpreter [try to] figure it out.

-- 
John Reiser, jreiser@BitWagon.com
