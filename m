Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbYCDEL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbYCDEL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 23:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYCDELP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 23:11:15 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25944 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbYCDELO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 23:11:14 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5243"; a="888980"
Message-ID: <47CCCBDE.6040609@qualcomm.com>
Date: Mon, 03 Mar 2008 20:11:10 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
References: <20080202210828.840735763@polymtl.ca> <200803031512.51656.rusty@rustcorp.com.au> <47CC983C.8050000@qualcomm.com> <200803041336.56524.rusty@rustcorp.com.au>
In-Reply-To: <200803041336.56524.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rusty Russell wrote:
> On Tuesday 04 March 2008 11:30:52 Max Krasnyanskiy wrote:
>> Great. I might get some time later this week to think about this some more
>> and try things out. So if you have ideas/suggestions let me know.
> 
> Hmm, might be worth making stop_machine_run take a cpumask: I balked at it 
> originally, but introducing a section special case crosses the line I think.

Are you talking about a mask of which CPUs to stop  ?
That's essentially what I did with the cpu_isolated_map. But as Ingo and
others pointed out it's the wrong thing to do.
Or did you mean something else ?

Max
