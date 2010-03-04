Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0CDSN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:13:29 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:59501 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0CDSN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:13:27 -0500
Date: Thu, 4 Mar 2010 12:12:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 2/4] rcu: suppress RCU lockdep warnings
 during early boot
Message-ID: <20100304111245.GD21977@elte.hu>
References: <20100303154638.GA8576@linux.vnet.ibm.com>
 <1267631219-8713-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267631219-8713-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> @@ -154,6 +167,10 @@ static inline int rcu_read_lock_sched_held(void)
>  # define rcu_read_acquire_sched()	do { } while (0)
>  # define rcu_read_release_sched()	do { } while (0)
>  
> +static inline void debug_lockdep_rcu_update(void)
> +{
> +}
> +

Note, this method was only included for the !CONFIG_DEBUG_LOCK_ALLOC case, so 
i left it out for the time being.

Which may result in a somewhat incomplete debug state, but it would at least 
build with lockdep enabled ;-)

	Ingo
