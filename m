Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbXK1PwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbXK1PwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbXK1Pvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:51:53 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47423 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbXK1Pvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:51:52 -0500
Date: Wed, 28 Nov 2007 07:51:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Huang <James.Huang@watchguard.com>
Cc: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
       jamesclhuang@yahoo.com, ego@in.ibm.com, akpm@linux-foundation.org
Subject: Re: __rcu_process_callbacks() in Linux 2.6
Message-ID: <20071128155131.GA4376@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <590353.52909.qm@web83819.mail.sp1.yahoo.com> <F474D80A8B96F34D8D70C85A98D6FC178D8BE7@VS02SE.wgti.net> <20071127023958.GF9136@linux.vnet.ibm.com> <20071128014915.GA28908@linux.vnet.ibm.com> <20071128062108.GA17777@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128062108.GA17777@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 10:21:08PM -0800, Paul E. McKenney wrote:
> On Tue, Nov 27, 2007 at 05:49:15PM -0800, Paul E. McKenney wrote:
> > On Mon, Nov 26, 2007 at 06:39:58PM -0800, Paul E. McKenney wrote:
> > > On Mon, Nov 26, 2007 at 02:48:08PM -0800, James Huang wrote:

[ . . . ]

> > > That is correct.  This does mean that we should be able to leverage
> > > locking primitives and memory barriers executed from the scheduling
> > > clock interrupt.
> > 
> > And I managed to get some time on a 64-CPU POWER5+ system.  Been running
> > rcutorture for about 2.5 hours without a failure (128 reader processes)
> > running through not quite 1.5M RCU updates.  Of course, this is not
> > proof that the Classic RCU implementation works, but is should provide
> > some reassurance.
> > 
> > I will keep it running until I get kicked off (probably rather soon).
> 
> More than seven hours, more than 4M RCU updates without failure.
> Someone else's turn for the machine.
> 
> Again, not proof, but at least some reassurance.

Just to avoid potential misunderstanding...  This testing in no way
changes my opinion that the RCU Classic implementation needs some
combination of documentation and rework.  It pretty clearly needs a
bit of both.  And the increase in core counts over the past few years
indicates that some scalability work is in order.

What this testing does demonstrate is that we are not in an emergency
situation.

						Thanx, Paul
