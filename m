Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbYJ0EnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbYJ0EnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 00:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYJ0EnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 00:43:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56729 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYJ0Em6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 00:42:58 -0400
Date: Mon, 27 Oct 2008 10:13:19 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081027044319.GA4386@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081023054335.GC3280@in.ibm.com> <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com> <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com> <20081025060157.GA4614@in.ibm.com> <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 10:17:03AM +0900, KAMEZAWA Hiroyuki wrote:
> On Sat, 25 Oct 2008 08:38:52 -0700
> "Paul Menage" <menage@google.com> wrote:
> 
> > On Fri, Oct 24, 2008 at 11:01 PM, Bharata B Rao
> > <bharata@linux.vnet.ibm.com> wrote:
> > >
> > > Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > 
> > Reviewed-by: Paul Menage <menage@google.com>

Thanks Paul.

> > 
> > So in technical terms this patch looks fine now. There's still the
> > question of whether it's OK to change the existing API, since it's
> > been in the kernel in its currently (non-hierarchical) form for
> > several releases now.

Hmm... Can we consider this as an API change ? Currently cpuacct.usage
readers of a parent accounting group are missing the usage contributions
from its children groups. I would consider this patch as fixing the
above problem by correctly reflecting the cpu usage for every accounting
group.

> > 
> Hmm..how about having 2 params as "aggregated usage" and "private usage" ?
> 
>  cpuacct.usage.
>  cpuacct.all_subtree_usage.

Is there really a need to differentiate between aggregated and private
usage other than to maintain the current behaviour ?

Regards,
Bharata.
