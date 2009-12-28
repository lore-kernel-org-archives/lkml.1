Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbZL1Jzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbZL1Jzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZL1Jzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:55:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:43338 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZL1Jzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TjVj1uqcok/qcx4hteuwYE4VEi6mIOJr09iwfe1gzr5obcPl6IG2LSB9u7GWLv9d1+
         T9bX3L+OhRrsA+G1zd0iHTlm6/Umb6wF+mlXnZt/AQbYz8OYQzbaPqQYp2SMt7h05383
         /0hBEDG+wCbFGf23TS+Oo5/dInaj58noc1hi0=
Date: Mon, 28 Dec 2009 12:55:46 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net,
       tglx@linutronix.de
Subject: Re: [PATCH] x86, perfctr: remove unused func
	avail_to_resrv_perfctr_nmi()
Message-ID: <20091228095546.GA4884@lenovo>
References: <20091224015441.6005.4408.sendpatchset@localhost.localdomain> <20091224150458.GA5143@lenovo> <20091228083845.GK28652@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228083845.GK28652@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 09:38:45AM +0100, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > On Thu, Dec 24, 2009 at 01:54:47AM +0000, Naga Chumbalkar wrote:
> > > avail_to_resrv_perfctr_nmi() is neither EXPORT'd, nor used in the file.
> > > So remove it.
> > > 
> > > Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
> > > ---
> > >  arch/x86/include/asm/nmi.h             |    1 -
> > >  arch/x86/kernel/cpu/perfctr-watchdog.c |   11 -----------
> > >  2 files changed, 0 insertions(+), 12 deletions(-)
> > > 
> > 
> > Hi Naga, this looks good to me! Thanks.
> > 
> > Is there any plans to use this routine in future
> > so we shouldn't touch this snippet?
> 
> Not that i know of.

ok, then we could apply this patch I think, at least for
a while.

> 
> In fact we should transform/migrate the NMI watchdog driver by making it based 
> on a kernel-internal created perf event. (which is what the NMI watchdog 
> really is: a periodic NMI event occuring once per second and running a 
> callback function.)

Yes, this would be great. I'll try to find out some time for this
task, though no promises :) If someone get it done earlier I would
really appreciate.

> 
> That would give us NMI watchdog support on all future x86 CPUs, automatically 
> - without having to extend the arch/x86/kernel/cpu/perfctr-watchdog.c code for 
> it.
> 
> 	Ingo
> 
	-- Cyrill
