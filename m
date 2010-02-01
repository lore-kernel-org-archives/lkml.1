Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0BAQAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:00:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:38973 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754510Ab0BAQAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:00:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+58nxpUm25atD4iUajj4Kw3EdP2OVH2nrQFH+FnT
	WP1rXeLXIOtiw4
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Mike Galbraith <efault@gmx.de>
To: rostedt@goodmis.org
Cc: Nick Piggin <npiggin@suse.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <1265037815.29013.0.camel@gandalf.stny.rr.com>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca> <20100201073341.GH9085@laptop>
	 <1265017350.24455.122.camel@laptop> <20100201101142.GE12759@laptop>
	 <1265020561.24455.142.camel@laptop> <20100201104901.GH12759@laptop>
	 <20100201144759.GD10894@Krystal>  <20100201145831.GB19520@laptop>
	 <1265037815.29013.0.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 01 Feb 2010 17:00:00 +0100
Message-Id: <1265040000.6312.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 10:23 -0500, Steven Rostedt wrote:
> On Tue, 2010-02-02 at 01:58 +1100, Nick Piggin wrote:

> > So I would prefer the simpler version that doesn't add overhead to
> > ctxsw, at least for the first implementation.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> ;-)

Yup, fast path needs to _lose_ some weight.

	-Mike

