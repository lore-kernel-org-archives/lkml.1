Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYLCBAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYLCBAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYLCA7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:59:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39715 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbYLCA7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:59:43 -0500
Date: Wed, 3 Dec 2008 02:10:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       manfred@colorfullife.com, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de
Subject: Re: [PATCH -tip] v9 scalable classic RCU implementation
Message-ID: <20081203011042.GH6703@one.firstfloor.org>
References: <20081202222157.GA14911@linux.vnet.ibm.com> <20081202233144.GE6703@one.firstfloor.org> <20081202235145.GF6719@linux.vnet.ibm.com> <20081203001811.GF6703@one.firstfloor.org> <20081203004759.GG6719@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203004759.GG6719@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Power, I see a hang in all three flavors of RCU when CPU hotplug
> is enabled and dynticks is not.  I have not yet seen this hang on x86.
> On Power, the hang occurs in the CPU-offline code, and is identical to
> the hangs I was seeing in 2.6.27, except that "sleep 1" does not hang
> in recent 2.6.28 versions.  So the timeout is apparently failing to fire
> (or being ignored) for some other reason.
> 
> Is this similar to what you are seeing on x86?

Yes it is.

-Andi
-- 
ak@linux.intel.com
