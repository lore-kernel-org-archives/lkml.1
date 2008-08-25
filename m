Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYHYPRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYHYPRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYHYPQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:16:57 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54540 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYHYPQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:16:56 -0400
Date: Mon, 25 Aug 2008 08:16:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       manfred@colorfullife.com, dipankar@in.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080825151645.GB6745@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <1219447772.5197.98.camel@josh-work.beaverton.ibm.com> <1219660496.8515.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219660496.8515.22.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 12:34:56PM +0200, Peter Zijlstra wrote:
> On Fri, 2008-08-22 at 16:29 -0700, Josh Triplett wrote:
> 
> > > @@ -26,8 +27,10 @@
> > >   * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> > >   *
> > >   * For detailed explanation of Read-Copy Update mechanism see -
> > > - * 		Documentation/RCU
> > > - *
> > > + * 	Documentation/RCU
> > > + * 	http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
> > > + * 	http://lwn.net/Articles/263130/ (What is RCU's Usage?)
> > > + * 	http://lwn.net/Articles/264090/ (What is RCU's API? + references)
> > >   */
> > 
> > Why put these references here rather than in Documentation/RCU?  It
> > seems easier to keep documentation up to date in one place.  If you
> > think these represent a good "getting started" set of documents, how
> > about a Documentation/RCU/ReadTheseFirst with links to them, or how
> > about linking to them from whatisRCU.txt?
> 
> I actually like in code comments and 'documentation' more than
> Documentation/ stuff. Mostly because Documentation/ is:
>  - far away from the code
>  - therefore, more easily bitrotted
>  - and easily forgotten

I know!!!

#ifdef JOSH_TRIPLETT
 * 	Documentation/RCU
 * 	http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
 * 	http://lwn.net/Articles/263130/ (What is RCU's Usage?)
 * 	http://lwn.net/Articles/264090/ (What is RCU's API? + references)
#elif PETER_ZIJLSTRA
 * 	Documentation/RCU
#endif

(Sorry, couldn't resist!!!)

Seriously, I know where all the documentation is, as I wrote most of it.
These comments are for you guys.  So, any thoughts on how I should
resolve this?  My default is, as always, a coin flip.  ;-)

							Thanx, Paul
