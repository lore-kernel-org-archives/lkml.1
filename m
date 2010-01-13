Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045Ab0AMQiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0AMQiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036Ab0AMQix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:38:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35233 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab0AMQiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:38:51 -0500
Date: Wed, 13 Jan 2010 17:37:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/8] rcu: add lockdep-based diagnostics to
 rcu_dereference()
Message-ID: <20100113163751.GA13300@elte.hu>
References: <20100105020345.GA32114@linux.vnet.ibm.com>
 <20100113092242.GA6739@elte.hu>
 <20100113161721.GC6803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113161721.GC6803@linux.vnet.ibm.com>
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

> On Wed, Jan 13, 2010 at 10:22:42AM +0100, Ingo Molnar wrote:
> > 
> > FYI, i'm getting various runtime warnings triggered by the new RCU checks:
> > 
> >  [   20.630034] WARNING: at net/core/sock.c:1076 __sk_free+0x108/0x140()
> > 
> > bootlog and config attached.
> 
> Gah!!!  I forgot to label the RCU-lockdep stuff "RFC"!!!  Could you
> please rewind tip/core/rcu back to b6407e8639 ("rcu: Give different
> levels of the rcu_node hierarchy distinct lockdep names")?

Sure - i have done that.

> I have fixes for many of the warnings below, both as modifications to uses 
> of RCU and as modifications to the check code itself.  But I have been 
> building a new patchsets rather than keeping patches on top of this 
> patchset.  I also have modifications in the works to ease transition, for 
> example, but having a separate CONFIG_PROVE_RCU.

Sure, no problem!

	Ingo
