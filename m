Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYGPRBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYGPRBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbYGPRBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:01:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42227 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbYGPRBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:01:11 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5340"; a="4596717"
Message-ID: <487E2950.7030905@qualcomm.com>
Date: Wed, 16 Jul 2008 10:01:04 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>	 <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>	 <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>	 <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com>	 <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org>	 <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com>	 <487C1374.8020404@qualcomm.com>	 <alpine.LFD.1.10.0807142104250.3017@woody.linux-foundation.org>	 <20080715083223.GA2600@elte.hu> <487C62FB.6030304@qualcomm.com>	 <20080715085738.GA6325@elte.hu>  <487D96C9.7070502@qualcomm.com> <1216192222.5232.7.camel@twins>
In-Reply-To: <1216192222.5232.7.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-07-15 at 23:35 -0700, Max Krasnyansky wrote:
>> There are now three patches that are outstanding (pending reviews, etc) on this:
>>
>> 1. cpu hotplug, sched: Introduce cpu_active_map and redo sched\
>> 		    domain managment (take 2)
>>
>> 2. cpu hotplug: Make cpu_active_map synchronization dependency clear
>>
>> 3. cpuset: Make rebuild_sched_domains() usable from any context (take 2)
>>
>> Please review/ack/nak/etc.
>>
>> ----
>> Linus ACKed #1 and Ingo seemed to be more or less ok with it. We need ACKs
>> from Dmitry, Peter and Greg on the general approach and due to some
>> non-trivial merges with their stuff. RT balancer cpupri thingy and and RT
>> bandwidth handling.
> 
> ACK
> 
>> #2 Should be fairly straightforward.
> 
> Has a misformed comment, ACK when that's fixed.
> 
>> #3 Need ACKs from Paul J. and Paul M. overall they seemed ok with the first
>> version, and new version implements the suggested workqueue based rebuild.
> 
> Has more misformed comments. Please use
> 
>  /*
>   * this is a multiline
>   * comment
>   */
> 
> instead of
> 
>   /* this is a multiline
>    * comment */

Got it. Will fix and resend.

Thanx for the ACKs and review.

Max


