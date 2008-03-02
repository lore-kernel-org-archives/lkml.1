Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYCBDKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYCBDKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 22:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYCBDKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 22:10:39 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:35894 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbYCBDKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 22:10:39 -0500
Date: Sun, 2 Mar 2008 04:06:10 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
In-Reply-To: <20080301193903.GC15887@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0803020404040.2723@scrub.home>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
 <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0802291330590.2723@scrub.home> <20080301193903.GC15887@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 1 Mar 2008, Paul E. McKenney wrote:

> Is this what you had in mind?  I don't have any way to test on a
> system not supporting CONFIG_PREEMPT, but seems to work on x86.

Yes, looks fine.

> +config PREEMPT_RCU
> +	bool "Preemptible RCU"
> +	depends on PREEMPT
> +	default n

"default n" isn't really necessary, it's already the default.

bye, Roman

