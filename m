Return-Path: <linux-kernel-owner+w=401wt.eu-S936025AbXJQAX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936025AbXJQAX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935458AbXJQAXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:23:13 -0400
Received: from omta03ps.mx.bigpond.com ([144.140.82.155]:62726 "EHLO
	omta03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761541AbXJQAXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:23:11 -0400
Message-ID: <471555EB.5060608@bigpond.net.au>
Date: Wed, 17 Oct 2007 10:23:07 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
References: <20071016094252.GD1000@ff.dom.local>
In-Reply-To: <20071016094252.GD1000@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [124.179.200.236] using ID pwil3058@bigpond.net.au at Wed, 17 Oct 2007 00:23:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On 16-10-2007 03:16, Peter Williams wrote:
> ...
>> I'd suggest that we modify sched_rr_get_interval() to return -EINVAL 
>> (with *interval set to zero) if the target task is not SCHED_RR.  That 
>> way we can save a lot of unnecessary code.  I'll work on a patch.
> ...
> 
> I like this idea! But, since this a system call maybe at least
> something like RFC would be nicer...

We would be just modifying the code to meet that specification so a 
patch would be OK.  Anyone who wants to comment will do so anyway :-).

> 
>>> Sorry for too harsh words.
>> I didn't consider them harsh.
> 
> So, I can't be mistaken for a rapper yet? I'll work on it...
> 
> Cheers,
> Jarek P.
> 
> PS: Peter, for some unknown reason I don't receive your messages.
> If you get back some errors from my side I'd be interested to see
> it (alternative: jarkao2 at gmail.com).

I haven't seen any bounce notifications.  I've added the qmail address 
as a CC.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
