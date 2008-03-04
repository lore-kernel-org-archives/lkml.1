Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbYCDAbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbYCDAbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYCDAa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:30:57 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1518 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYCDAaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:30:55 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5243"; a="884867"
Message-ID: <47CC983C.8050000@qualcomm.com>
Date: Mon, 03 Mar 2008 16:30:52 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
References: <20080202210828.840735763@polymtl.ca> <47C84DCD.5040803@qualcomm.com> <20080229191559.GA18339@elte.hu> <200803031512.51656.rusty@rustcorp.com.au>
In-Reply-To: <200803031512.51656.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

> On Saturday 01 March 2008 06:15:59 Ingo Molnar wrote:
>> Right now the answer is: "if you want to do hard RT then avoid doing
>> things like loading modules". (which you should avoid while doing
>> hard-RT anyway)
> 
> Hi Ingo,
> 
>      I agree, but Max is doing a service by making more people aware of the 
> limitations of stop_machine so they don't sprinkle it around like candy :)
Exactly. I'm glad we're on same page on this.

> I think the module load case can be reasonably fixed; it's in my backlog now.
Great. I might get some time later this week to think about this some more and 
try things out. So if you have ideas/suggestions let me know.

Max
