Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbZLPKcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbZLPKcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbZLPKcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:32:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970AbZLPKcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:32:11 -0500
Subject: Re: [PATCH RFC tip/core/rcu 18/18] rcu: add primitives to check
 for RCU read-side critical sections
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <12609181613745-git-send-email->
References: <20091215230213.GA9093@linux.vnet.ibm.com>
	 <12609181613745-git-send-email->
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 11:31:34 +0100
Message-ID: <1260959494.17860.46.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 15:02 -0800, Paul E. McKenney wrote:
> 
> Also create rcu_dereference_check(), which takes a second boolean argument
> into which one puts rcu_read_lock_held() or similar.  For example:
> 
>         rcu_dereference_check(gp, rcu_read_lock_held() ||
>                                   lockdep_is_held(my_lock));

Ah, so you're going to tackle this the other way around, interesting :-)

