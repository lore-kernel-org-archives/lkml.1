Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZJZC2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZJZC2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 22:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZJZC2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:28:23 -0400
Received: from relay4-v.mail.gandi.net ([217.70.178.78]:34679 "EHLO
	relay4-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbZJZC2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:28:22 -0400
Date: Sun, 25 Oct 2009 19:27:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/6] rcu: Tiny RCU, expedited RCU,
 rcutorture fixes, lockdep simplification
Message-ID: <20091026022746.GA30796@feather>
References: <20091026020253.GA11350@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026020253.GA11350@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 07:02:53PM -0700, Paul E. McKenney wrote:
> Updated patches for post 2.6.32:
> 
> o	RCU the Bloatwatch Edition, v8
> 
> o	Add synchronize_rcu_expedited().
> 
> o	Add rcutorture tests for synchronize_rcu_expedited().
> 
> o	Update RCU documentation for synchronize_rcu_expedited().
> 
> o	Make rcutorture list the torture types it knows about when
> 	complaining about the one specified.
> 
> o	Simplify creation of the separate lockdep class for the
> 	root rcu_node structure's lock.
> 
> 
>  b/Documentation/RCU/whatisRCU.txt |    3 
>  b/include/linux/hardirq.h         |   24 +++
>  b/include/linux/rcupdate.h        |    6 
>  b/include/linux/rcutiny.h         |   97 ++++++++++++
>  b/include/linux/srcu.h            |    1 
>  b/init/Kconfig                    |    9 +
>  b/kernel/Makefile                 |    1 
>  b/kernel/rcupdate.c               |    4 
>  b/kernel/rcutiny.c                |  295 +++++++++++++++++++++++++++++++++++++-
>  b/kernel/rcutorture.c             |   26 ++-
>  b/kernel/rcutree.c                |    5 
>  b/kernel/rcutree.h                |    3 
>  b/kernel/srcu.c                   |   75 ++++++---
>  kernel/rcutorture.c               |    7 
>  14 files changed, 519 insertions(+), 37 deletions(-)

For all 6 patches:
Acked-by: Josh Triplett <josh@joshtriplett.org>
