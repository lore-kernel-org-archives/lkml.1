Return-Path: <linux-kernel-owner+w=401wt.eu-S934080AbYEULJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbYEULJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760357AbYEULJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:09:07 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:36254 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759528AbYEULJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:09:06 -0400
Message-ID: <483402CE.9000706@hp.com>
Date: Wed, 21 May 2008 07:09:02 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: /proc/lock_stat "stuck"
References: <483313DD.2020904@hp.com> <1211361380.6463.63.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1211361380.6463.63.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-05-20 at 14:09 -0400, Alan D. Brunelle wrote:
>> I'm attempting to use /proc/lock_stat to gather some information during
>> some benchmarking runs, but what I find happens is as follows:
>>
>> 1. I boot the system - 2.6.26-rc3 kernel + CONFIG_LOCK_STAT=y
>>
>> 2. I can then look at /proc/lock_stat, and it has valid-looking values
>>
>> 3. I wait a while, do some stuff, but when I look at /proc/lock_stat
>> again the values have not changed.
>>
>> 4. If I clear the counters - echo 0 > /proc/lock_stat - the counters
>> never increase, and no information besides the headers are output when I
>> cat /proc/lock_stat.
>>
>>
>> Is there something that one needs to do to get counter updates?
> 
> Did you get lockdep warnings? Those disable all lock debugging,
> including lockstat.

Hi Peter -

Yesterday, during boots I /was/ getting a problem with NVIDIA ck804xrom
registration problems -  "Unable to register resource" - it did produce
a stack trace w/ lock calls in the stack. Since then I've cut /way/ back
on my .config, and I don't see that problem anymore, and the lock stats
seem to be updating correctly with this new .config. [If I have time
later today, I'll go back to the old .config and try to track down the
ck804xrom issue.]

Thanks for the hint about watching for lockdep issues,
Alan
