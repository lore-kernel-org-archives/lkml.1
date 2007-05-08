Return-Path: <linux-kernel-owner+w=401wt.eu-S934972AbXEHJzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934972AbXEHJzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934956AbXEHJzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:55:38 -0400
Received: from www.osadl.org ([213.239.205.134]:44800 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934818AbXEHJzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:55:37 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070508095130.GY3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
	 <1178556361.3042.16.camel@localhost.localdomain>
	 <20070508093957.GS3505@sequoia.sous-sol.org>
	 <1178617864.3042.309.camel@localhost.localdomain>
	 <20070508095130.GY3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 11:58:24 +0200
Message-Id: <1178618304.3042.320.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 02:51 -0700, Chris Wright wrote:
> That's what I was wondering, although i have same setup for 32-bit
> and it behaves as expected with cpu0 taking hpet or pit on irq0
> and lapic timer picked up on the other 3 cpus.
> 
> > > In addition lapic timer is firing there, and I'm seeing a higher
> > > interrupt load than I used to.  This is the same in your set and mine.
> > 
> > Is irq0 _and_ the lapic timer firing ?
> 
> Yes.

Hmm, that's even more strange. Can you please provide the output
of /proc/timer_list ?

	tglx


