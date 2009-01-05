Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZAEXC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZAEXC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZAEXCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:02:21 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54816 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750823AbZAEXCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:02:20 -0500
Date: Mon, 5 Jan 2009 17:02:18 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Greg KH <greg@kroah.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>
Subject: Re: 2.6.27.8 scheduler bug - threads not being scheduled for long periods
Message-ID: <20090105230218.GC20319@sgi.com>
References: <20090105175641.GA17055@sgi.com> <1231188958.11687.12.camel@twins> <20090105215429.GA20319@sgi.com> <20090105223621.GB20319@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105223621.GB20319@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Mon, Jan 05, 2009 at 04:36:21PM -0600, Dimitri Sivanich wrote:
> And sure enough, the rq->clock is sometimes going backwards.
> 
> The comment for sched_clock() in arch/ia64/kernel/head.S:
>  * Return a CPU-local timestamp in nano-seconds.  This timestamp is
>  * NOT synchronized across CPUs its return value must never be
>  * compared against the values returned on another CPU.  The usage in
>  * kernel/sched.c ensures that.
> 
> We will try this with CONFIG_HAVE_UNSTABLE_SCHED_CLOCKS.
>

The testcase does indeed run with CONFIG_HAVE_UNSTABLE_SCHED_CLOCKS configured.
