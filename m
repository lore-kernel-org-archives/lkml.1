Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYB1LP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYB1LP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 06:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYB1LPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 06:15:19 -0500
Received: from twin.jikos.cz ([213.151.79.26]:35711 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbYB1LPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 06:15:18 -0500
Date: Thu, 28 Feb 2008 12:13:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <20080227175726.ad6bda9d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802281211170.7699@twin.jikos.cz>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
 <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
 <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
 <20080219200852.GC11197@Krystal> <Pine.LNX.4.64.0802271532220.14380@schroedinger.engr.sgi.com>
 <20080227175726.ad6bda9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Andrew Morton wrote:

> Doing ++ on a u32 _is_ atomic wrt interrupts on x86 and probably lots of
> other architectures, so we're OK using unsigned there.  

So you make implicit assumptions about how gcc compiles your ++? I am 
afraid you can't do that, gcc is absolutely free to turn variable++; 
statement to non-atomic sequence of instructions (memory->register load, 
increment register, for example).

-- 
Jiri Kosina
SUSE Labs

