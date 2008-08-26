Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbYHZQIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbYHZQIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbYHZQIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:08:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55180 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbYHZQIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:08:44 -0400
Date: Tue, 26 Aug 2008 09:08:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] state machine based rcu
Message-ID: <20080826160838.GA11279@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48AD8969.7060900@colorfullife.com> <20080822190250.GH6744@linux.vnet.ibm.com> <48AFC751.2020806@colorfullife.com> <20080824170949.GG6851@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824170949.GG6851@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 10:09:49AM -0700, Paul E. McKenney wrote:
> On Sat, Aug 23, 2008 at 10:16:17AM +0200, Manfred Spraul wrote:
> > Btw, does STP still exist? I'd like to do some testing on real SMP 
> > hardware. http://stp.testing.osdl.org/ appears to be dead.
> 
> I believe that it has indeed passed on.
> 
> I have occasional access to some 128-CPU machines, but they both
> currently being used for a week-long test sequence, so I won't have
> access to them for some time.  Once they free up, I would be happy to
> run some short (a few hours) tests on them, given a patch stack starting
> from a Linux release (e.g., 2.6.27-rc1).  Given such a patch stack, I
> can simply point the machine at it.  The automated test system doesn't
> yet understand git trees.  :-/

The big long test is over, so if you can send me a patch against some
Linus tree, I will see about testing your code.  Assuming someone else
doesn't jump on the machines first, that is...  :-/

							Thanx, Paul
