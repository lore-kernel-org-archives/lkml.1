Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbYBVVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbYBVVEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYBVVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:04:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29339 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbYBVVEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:04:23 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="869389"
Message-ID: <47BF38D5.7090604@qualcomm.com>
Date: Fri, 22 Feb 2008 13:04:21 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH sched-devel 0/7] CPU isolation extensions
References: <47BE35B7.2070104@qualcomm.com> <b647ffbd0802220036v383961ddq5f07efe72f525ffc@mail.gmail.com>
In-Reply-To: <b647ffbd0802220036v383961ddq5f07efe72f525ffc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> Hi Max,
> 
>>  [ ... ]
>>  Last patch to the stop machine is potentially unsafe and is marked as experimental. Unfortunately
>>  it's currently the only option that allows dynamic module insertion/removal for above scenarios.
> 
> I'm puzzled by the following part (can be a misunderstanding from my side)
> 
> +config CPUISOL_STOPMACHINE
> +       bool "Do not halt isolated CPUs with Stop Machine (EXPERIMENTAL)"
> +       depends on CPUISOL && STOP_MACHINE && EXPERIMENTAL
> +       help
> +         If this option is enabled kernel will not halt isolated CPUs
> +         when Stop Machine is triggered. Stop Machine is currently only
> +         used by the module insertion and removal.
> 
> this "only" part. What about e.g. a 'cpu hotplug' case (_cpu_down())?
> (or we should abstract it a bit to the point that e.g. a cpu can be
> considered as 'a module'? :-)

My bad. I forgot to update that text. As you and other folks pointed out
stopmachine is used in a few other places besides module loading. We had 
a discussion about this awhile ago. I just forgot to update the text. 
Will do.

Max
