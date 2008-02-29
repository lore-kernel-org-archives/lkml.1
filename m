Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbYB2Nxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbYB2Nxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYB2NxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:53:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbYB2NxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:53:21 -0500
Date: Fri, 29 Feb 2008 08:53:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roman Zippel <zippel@linux-m68k.org>
cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
In-Reply-To: <200802290534.57040.zippel@linux-m68k.org>
Message-ID: <Pine.LNX.4.58.0802290852060.8804@gandalf.stny.rr.com>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
 <200802290534.57040.zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Roman Zippel wrote:
>
> Also why is this a choice? Are more RCU types planned?

Why shouldn't it be a choice? You can have CLASSIC_RCU or PREEMPT_RCU, one
or the other and not both. Sounds perfect for being a choice.

-- Steve

