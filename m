Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZHYSmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZHYSmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZHYSmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:42:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56535 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbZHYSmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:42:02 -0400
Date: Tue, 25 Aug 2009 11:41:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip 0/2] Temporary RCU fixes for notrace and hotplug CPU
Message-ID: <20090825184157.GK6616@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090824164112.GA13693@linux.vnet.ibm.com> <20090825065501.GA29162@elte.hu> <20090825154025.GD6616@linux.vnet.ibm.com> <20090825181907.GC3277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825181907.GC3277@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 08:19:07PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Aug 25, 2009 at 08:55:01AM +0200, Ingo Molnar wrote:
> > > 
> > > FYI, -tip testing found a new build warning on SH caused by the RCU 
> > > tree (i suspect this warning triggers on other architectures as 
> > > well):
> > > 
> > > /home/mingo/tip/kernel/rcutree.c:88: warning: '__rcu_offline_cpu' 
> > > declared 'static' but never defined
> > 
> > <red face>
> > 
> > > it's harmless, but since we are generally trying to fix all warnings 
> > > and gravitate towards more and more -Werror subsystems, it would be 
> > > nice to fix this.
> > 
> > Indeed, and I have updated my build-output-check script to alert 
> > me to warning messages from my multiple-configuration test runs.  
> > Please see below for patch.
> 
> btw., you can unset CONFIG_ALLOW_WARNINGS in -tip kernels to turn 
> build warnings into build failures - and those are harder to miss.

Thank you for the tip!!!

							Thanx, Paul
