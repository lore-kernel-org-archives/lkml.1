Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYISQDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYISQDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYISQCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:02:53 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:50013 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYISQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:02:52 -0400
Message-ID: <48D3CD48.4090701@colorfullife.com>
Date: Fri, 19 Sep 2008 18:03:20 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] rcu: introduce kfree_rcu()
References: <48D1D694.9010802@cn.fujitsu.com> <20080918064406.GC6397@linux.vnet.ibm.com> <48D2882B.9060806@colorfullife.com> <20080918174619.GA28186@linux.vnet.ibm.com>
In-Reply-To: <20080918174619.GA28186@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> The rcu_barrier() family of functions registers a callback on each CPU,
> and waits until all these callbacks have been invoked.  The CPU offlining
> process preserves the order of the callbacks that were registered on a
> given CPU.  Thus, when rcu_barrier() returns, all RCU callbacks previously
> registered are guaranteed to have already been invoked, regardless of
> what CPUs might have been offlined and onlined in the meantime.
>
>   
You are right: I mixed up rcu_barrier() and synchronize_rcu().

--
    Manfred
