Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbYEJUpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbYEJUpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYEJUoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:44:54 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44384 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYEJUoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:44:54 -0400
Date: Sat, 10 May 2008 16:35:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       John Reiser <jreiser@BitWagon.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
Message-ID: <20080510203548.GA7804@c2.user-mode-linux.org>
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com> <4825D8A1.30008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4825D8A1.30008@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 06:17:21PM +0100, Jeremy Fitzhardinge wrote:
> No, I think valgrind+uml deliberately lets usermode code run directly on 
> the cpu, not under valgrind.  

It can be done either way.  Grinding userspace code as well is more
uniform, as there's no need to say "this clone should not be followed,
as it will become a UML process".  On the other hand, not grinding
processes means you don't need to figure out how to get the valgrind
engine into your processes.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
