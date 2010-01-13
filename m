Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000Ab0AMQRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0AMQRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932Ab0AMQRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:17:30 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37983 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab0AMQR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:17:29 -0500
Date: Wed, 13 Jan 2010 08:17:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/8] rcu: add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100113161721.GC6803@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100105020345.GA32114@linux.vnet.ibm.com> <20100113092242.GA6739@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113092242.GA6739@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:22:42AM +0100, Ingo Molnar wrote:
> 
> FYI, i'm getting various runtime warnings triggered by the new RCU checks:
> 
>  [   20.630034] WARNING: at net/core/sock.c:1076 __sk_free+0x108/0x140()
> 
> bootlog and config attached.

Gah!!!  I forgot to label the RCU-lockdep stuff "RFC"!!!  Could you
please rewind tip/core/rcu back to b6407e8639 ("rcu: Give different
levels of the rcu_node hierarchy distinct lockdep names")?

I have fixes for many of the warnings below, both as modifications to
uses of RCU and as modifications to the check code itself.  But I have
been building a new patchsets rather than keeping patches on top of this
patchset.  I also have modifications in the works to ease transition,
for example, but having a separate CONFIG_PROVE_RCU.

Please accept my apologies for the mislabeling!!!

							Thanx, Paul

> Thanks,
> 
> 	Ingo

> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.33-rc4
> # Wed Jan 13 11:44:27 2010
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
