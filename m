Return-Path: <linux-kernel-owner+w=401wt.eu-S1751133AbZJJEDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbZJJEDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 00:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZJJEDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 00:03:30 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:37689 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZJJEDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 00:03:30 -0400
Date: Fri, 9 Oct 2009 20:47:52 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC tip/core/rcu 0/3] Tiny RCU and expedited SRCU
Message-ID: <20091010034752.GA3527@feather>
References: <20091009224954.GA26516@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009224954.GA26516@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 03:49:54PM -0700, Paul E. McKenney wrote:
> This series rebases TINY_RCU and creates an expedited SRCU along with
> corresponding RCU torture tests.  These are post-2.6.32 material.
> 
> 							Thanx, Paul
> 
> 
>  include/linux/hardirq.h  |   24 ++++
>  include/linux/rcupdate.h |    6 +
>  include/linux/rcutiny.h  |  103 +++++++++++++++++
>  include/linux/srcu.h     |    1 
>  init/Kconfig             |    9 +
>  kernel/Makefile          |    1 
>  kernel/rcupdate.c        |    4 
>  kernel/rcutiny.c         |  282 ++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/rcutorture.c      |   26 +++-
>  kernel/srcu.c            |   75 ++++++++----
>  10 files changed, 502 insertions(+), 29 deletions(-)

For all three patches:
Acked-by: Josh Triplett <josh@joshtriplett.org>
