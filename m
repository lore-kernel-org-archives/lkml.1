Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbXIVRUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbXIVRUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbXIVRUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:20:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50023 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbXIVRUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:20:19 -0400
Date: Sat, 22 Sep 2007 10:20:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Add CRC checksum for RCU lists
Message-ID: <20070922172005.GC11123@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1190313251.4518.14.camel@localhost.localdomain> <20070921171256.GA9059@linux.vnet.ibm.com> <Pine.LNX.4.58.0709211550330.29857@gandalf.stny.rr.com> <B4DA08E1-19C1-4D46-B480-0B880F1443C9@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B4DA08E1-19C1-4D46-B480-0B880F1443C9@mac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 03:04:47AM -0400, Kyle Moffett wrote:
> On Sep 21, 2007, at 17:32:08, Steven Rostedt wrote:
> >On Fri, 21 Sep 2007, Paul E. McKenney wrote:
> >>On Thu, Sep 20, 2007 at 02:34:11PM -0400, Steven Rostedt wrote:
> >>>-#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
> >>>+#ifdef CONFIG_RCU_CRC_HEADER_CHECK
> >>>+
> >>>+#define RCU_CRC_MAGIC 0xC4809168UL
> >>
> >>Very magic indeed -- Google doesn't find it, other than in your  
> >>patch.  ;-)
> >
> >Paul, I'm disappointed in you. That number doesn't ring a bell at  
> >all??
> >
> >(hint, ignore the 'C' that was added by me).
> 
> LOL!  The RCU patent number; very clever indeed!

Y'know, I newer did figure this one out!

I like it!!!  ;-)

							Thanx, Paul
