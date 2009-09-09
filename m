Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZIISXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZIISXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZIISXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:23:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56165 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbZIISXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:23:00 -0400
Date: Wed, 9 Sep 2009 11:23:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH tip/core/rcu 0/3] increase rcutorture intensity and fix
	a couple resulting bugs
Message-ID: <20090909182300.GE6749@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090908225349.GA19524@linux.vnet.ibm.com> <21629.1252518239@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21629.1252518239@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 01:43:59PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 08 Sep 2009 15:53:49 PDT, "Paul E. McKenney" said:
> > This patch series increases the intensity of rcutorture testing for
> > TREE_PREEMPT_RCU and provides fixes for a couple resulting bugs.
> 
> Minor bisection nit - should patch 1/3 be renumbered to 3/3, so the two bugfix
> patches go in before the patch that makes the unpatched bugs visible? Otherwise
> if a bisect waypoint happens to land on 1/3, oddness can happen...

Agreed.  That said, the larger series of patches that this patchset
is part of has several other similar bisection issues.  My guess is that
the larger series will be refactored at some point.

Besides which, I expect to be sending in more bug fixes...

							Thanx, Paul
