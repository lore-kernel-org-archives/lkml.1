Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYLLOWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYLLOWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYLLOW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:22:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbYLLOWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:22:25 -0500
Subject: Re: CFS scheduler OLTP perforamnce
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Ma, Chinang" <chinang.ma@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>
In-Reply-To: <87wse5bhu4.fsf@basil.nowhere.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>
	 <1229083933.12883.179.camel@twins>  <87wse5bhu4.fsf@basil.nowhere.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Dec 2008 15:22:15 +0100
Message-Id: <1229091735.25485.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 15:15 +0100, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> >> 
> >> It seems that in this case renice to higher priority with CFS did not
> >> reduce scheduling latency as well as SCHED_RR.
> >
> > Is there a question in this email?
> 
> The question is how to make nice perform as well as SCHED_RR.

Depending on the circumstances, you can't - SCHED_RR doesn't bother with
fairness.

That is not to say there is no room for improvement, but that really
needs more information.
