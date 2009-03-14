Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZCNDst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZCNDst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 23:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZCNDsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 23:48:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:43208 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZCNDsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 23:48:40 -0400
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: prasad@linux.vnet.ibm.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090311174115.GD9547@in.ibm.com>
References: <20090311121220.GI2282@elte.hu>
	 <Pine.LNX.4.44L0.0903111151580.2692-100000@iolanthe.rowland.org>
	 <20090311174115.GD9547@in.ibm.com>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 14:47:35 +1100
Message-Id: <1237002455.25062.83.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 23:11 +0530, K.Prasad wrote:
> With FCFS or an allocation mechanism without the (un)installed()
> callbacks we'd lose the ability to record requests and service them
> later when registers become availabile.
> 
> Say when (un)installed() callbacks are implemented for the proposed
> ftrace-plugin to trace kernel symbols, they can automatically stop/start
> tracing as and when registers become (un)available. This can be helpful when
> we wish to profile memory access over a kernel variable for a long duration
> (where small loss of tracing data can be tolerated), while the system would
> permit simultaneous user-space access (say a GDB session using 'hbreak').
> 
> Are we fine with disallowing such usage, which if done will let the requester
> of the breakpoint register 'poll' periodically to check availability.

Is that such a big deal ? Can't we just have the kernel degrade to
classic SW breakpoints ?

Smells like overengineering to me ...

Ben.


