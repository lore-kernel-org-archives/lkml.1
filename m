Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYE2Cls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYE2Cls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 22:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYE2Cli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 22:41:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38110 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYE2Clh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 22:41:37 -0400
Date: Thu, 29 May 2008 08:20:39 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080529025039.GA12836@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483DA5E7.5050600@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 12:35:19PM -0600, Chris Friesen wrote:
> Srivatsa Vaddagiri wrote:
>
>> We seem to be skipping the last element in the task list always. In your
>> case, the lone task in Group a/b is always skipped because of this.
>
>> Updated patch (on top of 2.6.26-rc3 +
>> http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/)
>> below.  Pls let me know how it fares!
>
> Looking much better, but still some fairness issues with more complex 
> setups.
>
[snip]

> A 10-sec average was better, but we still see errors of 6%:
> 2478	72.8%
> 2477	64.0%
> 2479	63.2%

Yes I have observed that the delta from ideal fairness is much more than
desirable (although I used to get much better fairness with
2.6.25-rc1. Let me verify and get back).

-- 
Regards,
vatsa
