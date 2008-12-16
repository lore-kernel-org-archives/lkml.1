Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbYLPPzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbYLPPzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758846AbYLPPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:53:46 -0500
Received: from koef.zs64.net ([212.12.50.230]:57658 "EHLO koef.zs64.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835AbYLPPxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:53:44 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2008 10:53:44 EST
Date: Tue, 16 Dec 2008 10:46:55 -0500
From: Martin Cracauer <cracauer@cons.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Robert Richter <robert.richter@amd.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Stephane Eranian <eranian@googlemail.com>,
       Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       perfctr-devel@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Perfctr-devel] [patch] Performance Counters for Linux, v4
Message-ID: <20081216154655.GB32787@cons.org>
References: <20081214212829.GA9435@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214212829.GA9435@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote on Sun, Dec 14, 2008 at 10:28:29PM +0100: 
> We are pleased to announce the v4 release of our performance counters 
> subsystem implementation. The kernel changes can be picked up from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core
> 
>   (also in the master branch. There's also a kernel patch attached 
>    below.)
> 
> The biggest new feature in this release is the implementation of 
> "performance counter inheritance" for the per task counters: the ability 
> to extend performance counters to cover the execution of child tasks 
> too, transparently and automatically - following them to other CPUs.

Does this come with a PAPI frontend or is one planned?

I picked the old perfctr mainly because I need PAPI.  Outside-process
measurement doesn't do for my application, I need subdivisions in my
code.

Thanks
	Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
