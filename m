Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYLRWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYLRWyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYLRWyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:54:09 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34282 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbYLRWyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:54:07 -0500
Date: Thu, 18 Dec 2008 14:54:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de
Subject: Re: [PATCH -tip] v9 scalable classic RCU implementation
Message-ID: <20081218225403.GA24881@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081202222157.GA14911@linux.vnet.ibm.com> <20081202233144.GE6703@one.firstfloor.org> <20081202235145.GF6719@linux.vnet.ibm.com> <20081203001811.GF6703@one.firstfloor.org> <20081203004759.GG6719@linux.vnet.ibm.com> <20081203011042.GH6703@one.firstfloor.org> <20081203013659.GH6719@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203013659.GH6719@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 05:36:59PM -0800, Paul E. McKenney wrote:
> On Wed, Dec 03, 2008 at 02:10:42AM +0100, Andi Kleen wrote:
> > > On Power, I see a hang in all three flavors of RCU when CPU hotplug
> > > is enabled and dynticks is not.  I have not yet seen this hang on x86.
> > > On Power, the hang occurs in the CPU-offline code, and is identical to
> > > the hangs I was seeing in 2.6.27, except that "sleep 1" does not hang
> > > in recent 2.6.28 versions.  So the timeout is apparently failing to fire
> > > (or being ignored) for some other reason.
> > > 
> > > Is this similar to what you are seeing on x86?
> > 
> > Yes it is.
> 
> OK, then I will consider them to be the same bug for the moment.

Question based on some further testing over here...

Do you still get failures if you refrain from offlining CPU 0?

							Thanx, Paul
