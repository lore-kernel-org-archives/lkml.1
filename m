Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYEKLd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYEKLd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYEKLdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:33:18 -0400
Received: from jade.aracnet.com ([216.99.193.136]:35479 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbYEKLdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:33:17 -0400
Message-ID: <4826D74F.7060505@BitWagon.com>
Date: Sun, 11 May 2008 04:23:59 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com> <4825D8A1.30008@goop.org> <20080510203548.GA7804@c2.user-mode-linux.org>
In-Reply-To: <20080510203548.GA7804@c2.user-mode-linux.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:

> ... not grinding processes means you don't need to figure out
> how to get the valgrind engine into your processes.

One easy way to force valgrind into a process is for load_elf_binary()
in fs/binfmt_elf.c to force a PT_INTERP which loads memcheck via
true user-mode calls, then chains to the original PT_INTERP.

-- 
John Reiser, jreiser@BitWagon.com
