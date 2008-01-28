Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbYA1Vsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbYA1Vsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYA1Vsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:48:30 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:44591 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYA1Vsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:48:30 -0500
Message-ID: <479E4D74.8060800@qualcomm.com>
Date: Mon, 28 Jan 2008 13:47:32 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: [CPUISOL] CPU isolation extensions
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	<1201511305.6149.30.camel@lappy>	<20080128085910.7d38e9f5.pj@sgi.com>	<479E20DA.2080403@qualcomm.com> <20080128130637.60db148e.pj@sgi.com>
In-Reply-To: <20080128130637.60db148e.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> So far it seems that extending cpu_isolated_map
>> is more natural way of propagating this notion to the rest of the kernel.
>> Since it's very similar to the cpu_online_map concept and it's easy to integrated
>> with the code that already uses it. 
> 
> If it were just realtime support, then I suspect I'd agree that
> extending cpu_isolated_map makes more sense.
> 
> But some people use realtime on systems that are also heavily
> managed using cpusets.  The two have to work together.  I have
> customers with systems running realtime on a few CPUs, at the
> same time that they have a large batch scheduler (which is layered
> on top of cpusets) managing jobs on a few hundred other CPUs.
> Hence with the cpuset 'sched_load_balance' flag I think I've already
> done what I think is one part of what your patches achieve by extending
> the cpu_isolated_map.
> 
> This is a common situation with "resource management" mechanisms such
> as cpusets (and more recently cgroups and the subsystem modules it
> supports.)  They cut across existing core kernel code that manages such
> key resources as CPUs and memory.  As best we can, they have to work
> with each other.

Thanks for the info Paul. I'll definitely look into using this flag instead 
and reply with pros and cons (if any).

Max
 

