Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYHYKfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYHYKfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYHYKfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:35:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:40691 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYHYKfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:35:06 -0400
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       manfred@colorfullife.com, dipankar@in.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
In-Reply-To: <1219447772.5197.98.camel@josh-work.beaverton.ibm.com>
References: <20080821234318.GA1754@linux.vnet.ibm.com>
	 <1219447772.5197.98.camel@josh-work.beaverton.ibm.com>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 12:34:56 +0200
Message-Id: <1219660496.8515.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-22 at 16:29 -0700, Josh Triplett wrote:

> > @@ -26,8 +27,10 @@
> >   * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> >   *
> >   * For detailed explanation of Read-Copy Update mechanism see -
> > - * 		Documentation/RCU
> > - *
> > + * 	Documentation/RCU
> > + * 	http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
> > + * 	http://lwn.net/Articles/263130/ (What is RCU's Usage?)
> > + * 	http://lwn.net/Articles/264090/ (What is RCU's API? + references)
> >   */
> 
> Why put these references here rather than in Documentation/RCU?  It
> seems easier to keep documentation up to date in one place.  If you
> think these represent a good "getting started" set of documents, how
> about a Documentation/RCU/ReadTheseFirst with links to them, or how
> about linking to them from whatisRCU.txt?

I actually like in code comments and 'documentation' more than
Documentation/ stuff. Mostly because Documentation/ is:
 - far away from the code
 - therefore, more easily bitrotted
 - and easily forgotten



