Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbYEUAqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbYEUAqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760865AbYEUAqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:46:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56431 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbYEUAqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:46:20 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5299"; a="3281428"
Message-ID: <483370D9.4080704@qualcomm.com>
Date: Tue, 20 May 2008 17:46:17 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       rientjes@google.com
Subject: Re: Reverting per-cpuset "system" (IRQ affinity) patch
References: <48210101.1070205@google.com>	<20080506183138.546f42d9.akpm@linux-foundation.org>	<20080506204054.564fff32.pj@sgi.com>	<20080506223859.0b4fa876.pj@sgi.com>	<20080506204444.f4c38d0a.akpm@linux-foundation.org>	<20080506225228.d42630cf.pj@sgi.com>	<1210142681.13978.166.camel@twins>	<48233EEB.1010807@qualcomm.com>	<20080509102237.GE19617@elte.hu> <20080509062605.d911ba53.pj@sgi.com>
In-Reply-To: <20080509062605.d911ba53.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Ingo wrote:
>> none of this is upstream yet (nor is any of this even near to being 
>> ready for upstream), so there's nothing to revert.
> 
> I thought one of the earlier patches (Max's, perhaps) that we considered
> in this discussion back in Feb or March -did- end up close to traveling
> upstream, via the sched-devel tree going into linux-next, or some such.
> 
> However I can't claim to understand what (almost) went down there as
> well as Andrew or Stephen hopefully do.
> 
> 
>> Paul/Peter/Max, what's the current agreed-upon approach
> 
> Well ... we don't have an agreed on approach yet ;)
> 
> 
>> to merge these physical resource isolation features into cpusets
>> intelligently while still keeping the whole thing as usable and
>> practical to down-to-earth sysadmins as possible? That is the issue
>> that is blocking this whole topic from progressing.
> 
> Well, yeah, everyone wants "simple".  But that tends to degrade into
> each of us insisting that whatever we don't appreciate need for in the
> other guys proposal be removed.  That way lies not progress.

Yeah, unfortunately we did not make much progress. Partly because of 
disagreements and party because I was on a longish vacation and did not get a 
chance to push things forward. Now I'm back.

At this point I want to make a step back and redo some of the original patches 
without using cpusets. At least for now while we do not have clear agreement 
on how cpuset integration should look like it seems to make sense to simply 
extend existing interfaces. For the irqs specifically I'm just thinking of 
adding /proc/irq/default_smp_affinity. I'll send some patches later this week.

Max







