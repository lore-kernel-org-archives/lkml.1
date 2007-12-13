Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbXLMRhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbXLMRhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761397AbXLMRhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:37:01 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:52289 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760431AbXLMRg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:36:59 -0500
Date: Thu, 13 Dec 2007 12:36:47 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gautham R Shenoy <ego@in.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 0/6] RCU: Preemptible-RCU
In-Reply-To: <20071213170348.GA25981@in.ibm.com>
Message-ID: <Pine.LNX.4.58.0712131230220.3369@gandalf.stny.rr.com>
References: <20071213170348.GA25981@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007, Gautham R Shenoy wrote:

>
> Currently it is based against the latest linux-2.6-sched-devel.git
>
> Awaiting your feedback!

Hi Gautham,

Thanks for posting this. I believe this is the same version of preempt RCU
as we have in the RT patch. It seems to be very stable. I ran the RT patch
version of the RCU Preempt (just the Preempt RCU patches without RT on
latest git) on a 64way box and the results seems just as good (if not
slightly better) than classic RCU!  I'll rerun this patch series on that
box and post the results.

>From what I'm seening with this, is that it is ready for mainline. These
patches should probably go into -mm and be ready for 2.6.25.  If Andrew
wants to wait for my results, I'll run them tonight.

Thanks Gautham, Paul and Dipankar for all this great work!

-- Steve

