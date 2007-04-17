Return-Path: <linux-kernel-owner+w=401wt.eu-S1031031AbXDQAmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031031AbXDQAmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 20:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031043AbXDQAmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 20:42:40 -0400
Received: from omta01ps.mx.bigpond.com ([144.140.82.153]:53495 "EHLO
	omta01ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031031AbXDQAmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 20:42:39 -0400
Message-ID: <462417F5.2060507@bigpond.net.au>
Date: Tue, 17 Apr 2007 10:42:29 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
References: <200704150931.42268.a1426z@gawab.com> <200704161342.34498.a1426z@gawab.com> <46237483.6010801@bigpond.net.au> <200704161738.47956.a1426z@gawab.com>
In-Reply-To: <200704161738.47956.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 00:42:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Peter Williams wrote:
>> Al Boldi wrote:
>>> Reducing the prio-level granularity may also be helpful;
>> Because of some of the bit operations code makes it a bad idea to have
>> more than 160 priority levels, you're more or less limited to 60
>> priority levels for SCHED_OTHER tasks (as 100 are used for real time)
>> and you need 40 of these to pay some attention to niceness leaving you
>> about 20 priority levels to use for fiddling.  Is that enough?
>>
>> With spa_ebs (now that CPU rate caps have been removed), you have all 60
>> priorities available for fiddling with as niceness is taken care of when
>> calculating each task's entitlement.
> 
> Ok, increasing the number of prio-levels is one thing, but I was more 
> thinking of reducing the effective difference between each prio-level. For 
> example, this would allow max_tpt_bonus=18, while the effective range would 
> be 3, thus reducing granularity.  Would this be easily introduceable?

OK.  Now (I think) I see what you mean.  I think that you could achieve 
this effect by shortening the promotion interval which I think is still 
one of the tunables.  This effectively controls the strength of priority 
levels -- short promotion intervals weaken and long promotion intervals 
strengthen the effect of different priority levels.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
