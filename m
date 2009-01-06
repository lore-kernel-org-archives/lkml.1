Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZAFHgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZAFHgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbZAFHgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:36:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbZAFHgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:36:41 -0500
Subject: Re: 2.6.27.8 scheduler bug - threads not being scheduled for long
 periods
From: Peter Zijlstra <peterz@infradead.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Greg KH <greg@kroah.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>
In-Reply-To: <20090105230218.GC20319@sgi.com>
References: <20090105175641.GA17055@sgi.com>
	 <1231188958.11687.12.camel@twins> <20090105215429.GA20319@sgi.com>
	 <20090105223621.GB20319@sgi.com>  <20090105230218.GC20319@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 08:36:26 +0100
Message-Id: <1231227386.11687.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 17:02 -0600, Dimitri Sivanich wrote:
> Peter,
> 
> On Mon, Jan 05, 2009 at 04:36:21PM -0600, Dimitri Sivanich wrote:
> > And sure enough, the rq->clock is sometimes going backwards.
> > 
> > The comment for sched_clock() in arch/ia64/kernel/head.S:
> >  * Return a CPU-local timestamp in nano-seconds.  This timestamp is
> >  * NOT synchronized across CPUs its return value must never be
> >  * compared against the values returned on another CPU.  The usage in
> >  * kernel/sched.c ensures that.
> > 
> > We will try this with CONFIG_HAVE_UNSTABLE_SCHED_CLOCKS.
> >
> 
> The testcase does indeed run with CONFIG_HAVE_UNSTABLE_SCHED_CLOCKS configured.

Ok, glad it worked out, thanks!
