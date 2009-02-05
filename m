Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZBEVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZBEVC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZBEVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:02:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53615 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbZBEVCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:02:50 -0500
Date: Thu, 5 Feb 2009 22:02:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Greear <greearb@candelatech.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: Re: PATCH:  Allow user to force 'tsc' to be treated as stable.
Message-ID: <20090205210239.GD21500@elte.hu>
References: <498B42C5.7010905@candelatech.com> <20090205195945.GE3129@elte.hu> <498B4E44.9080607@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B4E44.9080607@candelatech.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Greear <greearb@candelatech.com> wrote:

> Ingo Molnar wrote:
>> * Ben Greear <greearb@candelatech.com> wrote:
>>
>>> Allow user to force TSC as stable clock-source.
>>> Works around BIOS issues in the FWA-7304 (Via CN700 chipset)
>>> system, and possibly others.
>>>
>>> This is against 2.6.29-rc3.
>>
>> What 'issues' does that work around, exactly?
>
> Without this, my system comes up with no stable high-res
> clock, and the getnstimeofday seems to return something
> with around 1ms granularity.  I have HZ set to 1000, so
> its probably just using the 'jiffy' clocksource.
> This in turn screws up my patched version of pktgen and
> likely is sub-optimal for other things as well.
>
> It seems the TSC on this system is stable, but I got lost
> trying to understand the watchdog testing code, so I'm
> not certain if it is wrong or not.  With this force in
> place, the system seems stable and ran overnight under
> network load fine.

What does this tool output:

 http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

? (you can run it both the patched or on the unpatched system)

	Ingo
