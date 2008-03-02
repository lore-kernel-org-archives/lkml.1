Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYCBDJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYCBDJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 22:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYCBDJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 22:09:16 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:35883 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYCBDJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 22:09:15 -0500
Date: Sun, 2 Mar 2008 04:09:03 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
In-Reply-To: <Pine.LNX.4.58.0803011602300.30335@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.64.0803020406290.2723@scrub.home>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
 <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0802291330590.2723@scrub.home> <20080301193903.GC15887@linux.vnet.ibm.com>
 <Pine.LNX.4.58.0803011602300.30335@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 1 Mar 2008, Steven Rostedt wrote:

> >  config CLASSIC_RCU
> > -	bool "Classic RCU"
> > +	def_bool !PREEMPT_RCU
> >  	help
> >  	  This option selects the classic RCU implementation that is
> >  	  designed for best read-side performance on non-realtime
> > -	  systems.
> 
> Actually Paul, you don't need to make this an "option". Simply the default
> if PREEMPT_RCU is not selected. In otherwords, no prompt.
> 
> 	config CLASSIC_RCU
> 	  bool
> 	  depends on !PREEMPT_RCU
> 	  default y

There is no prompt. :)
"def_bool !PREEMPT_RCU" does the same as this.

bye, Roman
