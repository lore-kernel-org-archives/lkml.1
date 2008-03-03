Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbYCCSzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbYCCSzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbYCCSzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:55:16 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43765 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760725AbYCCSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:55:14 -0500
Date: Mon, 3 Mar 2008 10:55:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
Message-ID: <20080303185511.GE12453@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com> <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com> <Pine.LNX.4.64.0802291330590.2723@scrub.home> <20080301193903.GC15887@linux.vnet.ibm.com> <Pine.LNX.4.64.0803020404040.2723@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803020404040.2723@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 04:06:10AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Sat, 1 Mar 2008, Paul E. McKenney wrote:
> 
> > Is this what you had in mind?  I don't have any way to test on a
> > system not supporting CONFIG_PREEMPT, but seems to work on x86.
> 
> Yes, looks fine.
> 
> > +config PREEMPT_RCU
> > +	bool "Preemptible RCU"
> > +	depends on PREEMPT
> > +	default n
> 
> "default n" isn't really necessary, it's already the default.

Fair enough.  But something like 125 Kconfig files in 2.6.25-rc3 have
at least one "default n" in them, so is it worth getting rid of it?
Seems to me that the explicit "default n" has some substantial readability
advantages.

						Thanx, Paul
