Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZBPXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZBPXRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZBPXRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:17:11 -0500
Received: from ozlabs.org ([203.10.76.45]:53353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZBPXRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:17:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/4] generic-smp: properly allocate the cpumasks
Date: Tue, 17 Feb 2009 09:47:05 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.609493567@chello.nl>
In-Reply-To: <20090216164114.609493567@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170947.06133.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 03:08:50 Peter Zijlstra wrote:
> Its not deemed proper to have full cpumasks in data anymore, we have to
> dynamically allocate them based on runtime determined dimensions of the
> machine in question.

Wow, thanks.

But FYI I would have been happy with allocating them for each possible CPU,
rather than doing the hotplug callback thing.

If you really *can* have 4096 CPUS, I'm not so upset about spending 2M; it's
when you've got 2 CPUs and the distro has set CONFIG_NR_CPUS=4096 that I
care about.

I'm not saying to fix it, I'm just saying you went beyond the call of duty.

Kudos,
Rusty.
