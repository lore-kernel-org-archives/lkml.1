Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYLLO1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYLLO1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbYLLO1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:27:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45453 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230AbYLLO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:27:42 -0500
Date: Fri, 12 Dec 2008 15:39:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Ma, Chinang" <chinang.ma@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>
Subject: Re: CFS scheduler OLTP perforamnce
Message-ID: <20081212143930.GI25779@one.firstfloor.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com> <1229083933.12883.179.camel@twins> <87wse5bhu4.fsf@basil.nowhere.org> <1229091735.25485.8.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229091735.25485.8.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 03:22:15PM +0100, Peter Zijlstra wrote:
> On Fri, 2008-12-12 at 15:15 +0100, Andi Kleen wrote:
> > Peter Zijlstra <peterz@infradead.org> writes:
> > >> 
> > >> It seems that in this case renice to higher priority with CFS did not
> > >> reduce scheduling latency as well as SCHED_RR.
> > >
> > > Is there a question in this email?
> > 
> > The question is how to make nice perform as well as SCHED_RR.
> 
> Depending on the circumstances, you can't - SCHED_RR doesn't bother with
> fairness.

When the spread between nice levels (negative/positive) is large enough
at least the log writer should be able to schedule soon most of the
time, no?

At least that doesn't seem to work.

Also in general there seems to be a starvation issue here between
producer and consumer.

-Andi
