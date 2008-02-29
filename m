Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbYB2T6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbYB2T6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758666AbYB2T6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:58:08 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36956 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbYB2T6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:58:07 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5242"; a="1036155"
Message-ID: <47C863CB.404@qualcomm.com>
Date: Fri, 29 Feb 2008 11:58:03 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal> <20080228163303.GA6195@redhat.com> <47C73121.2000109@qualcomm.com> <20080229090050.GA19519@elte.hu> <47C84DCD.5040803@qualcomm.com> <20080229191559.GA18339@elte.hu>
In-Reply-To: <20080229191559.GA18339@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Max Krasnyanskiy <maxk@qualcomm.com> wrote:
> 
>> btw Being an RT guy you do not think that stop machine is evil ? [...]
> 
> i'm not "an RT guy", -rt is just one of the many projects i've been 
> involved with.
> 
> and no, i dont think stop machine is "evil" - it's currently the best 
> way to do certain things. If you can solve it better then sure, i'm 
> awaiting your patches - but the only patch i saw from you so far was the 
> one that turned off stop-machine for isolated cpus - which was 
> incredibly broken and ignored the problem altogether.
Ingo, I got it. My patch was a hack. Moving on. Seriously there is no need to 
say it ten thousand times ;-).

You clipped the part where I elaborated what exactly is evil about the stop 
machine. I clearly said that yes for some things there is just no other way 
but in general we should _try_ to avoid it. Note that I did not say "we must" 
I'm saying we should try.

> Right now the answer is: "if you want to do hard RT then avoid doing 
> things like loading modules". (which you should avoid while doing 
> hard-RT anyway)
That's just not practical. Sure you can have some kind of stripped down 
machine but then you loose a lot of flexibility. Again "should" is the keyword 
here. For a lot of workloads hard-RT has to coexist with a bunch of other things.

Max

