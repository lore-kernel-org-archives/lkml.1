Return-Path: <linux-kernel-owner+w=401wt.eu-S937671AbXG0RRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937671AbXG0RRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765835AbXG0RQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:16:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937619AbXG0RQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:16:55 -0400
Message-ID: <46AA287D.8070200@redhat.com>
Date: Fri, 27 Jul 2007 13:16:45 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Tong Li <tong.n.li@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>  <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu>  <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>  <20070725192442.GC4463@elte.hu>  <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com>  <20070726213154.GA26569@elte.hu> <1185487225.3122.11.camel@tongli.jf.intel.com> <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com>
In-Reply-To: <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tong Li wrote:
> I'd like to clarify that I'm not trying to push this particular code to 
> the kernel. I'm a researcher. My intent was to point out that we have a 
> problem in the scheduler and my dwrr algorithm can potentially help fix 
> it. The patch itself was merely a proof-of-concept. I'd be thrilled if 
> the algorithm can be proven useful in the real world. I appreciate the 
> people who have given me comments. Since then, I've revised my 
> algorithm/code. Now it doesn't require global locking but retains strong 
> fairness properties (which I was able to prove mathematically).

Thanks for doing this work.  Please don't take the implementation criticism as a 
lack of appreciation for the work.  I'd like to see dwrr in the scheduler, but 
I'm skeptical that re-introducing expired runqueues is the most efficient way to 
do it.

Given the inherently controversial nature of scheduler code, particularly that 
which attempts to enforce fairness, perhaps a concise design document would help 
us come to an agreement about what we think the scheduler should do and what 
tradeoffs we're willing to make to do those things.  Do you have a design 
document we could discuss?

	-- Chris
