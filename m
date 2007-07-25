Return-Path: <linux-kernel-owner+w=401wt.eu-S1765536AbXGYUzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765536AbXGYUzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbXGYUzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:55:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbXGYUzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:55:12 -0400
Message-ID: <46A7B8A9.4040400@redhat.com>
Date: Wed, 25 Jul 2007 16:55:05 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Ingo Molnar <mingo@elte.hu>, Tong Li <tong.n.li@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu> <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com> <20070725192442.GC4463@elte.hu> <46A7B4DE.4030301@nortel.com>
In-Reply-To: <46A7B4DE.4030301@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Ingo Molnar wrote:
> 
>> the 3s is the problem: change that to 60s! We no way want to 
>> over-migrate for SMP fairness, the change i did gives us reasonable 
>> long-term SMP fairness without the need for high-rate rebalancing.
> 
> Actually, I do have requirements from our engineering guys for 
> short-term fairness.  They'd actually like decent fairness over even 
> shorter intervals...1 second would be nice, 2 is acceptable.
> 
> They are willing to trade off random peak performance for predictability.
> 
> Chris
> 

The sysctls for CFS have nanosecond resolution.  They default to 
millisecond-order values, but you can set them much lower.  See sched_fair.c for 
the knobs and their explanations.

	-- Chris
