Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYE2W7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYE2W7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYE2W7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:59:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17975 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYE2W7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:59:41 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5306"; a="3336081"
Message-ID: <483F3559.1030806@qualcomm.com>
Date: Thu, 29 May 2008 15:59:37 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Give cpusets exclusive control over sched domains
 (ie remove cpu_isolated_map)
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>	<1212085023-22284-3-git-send-email-maxk@qualcomm.com> <20080529173759.ccbaf8ef.pj@sgi.com>
In-Reply-To: <20080529173759.ccbaf8ef.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Well .. if you can just resent patches for no apparent reason, with
> no apparent change, I guess I can just resent my reply, similarly.
Sorry I just updated and resent all my outstanding sched fixes.

btw I suppose you missed my reply. Where I provided the reasoning. Also Ingo 
at some point accepted a patch from Peter that partially removed the isolated 
map. This is just more complete version.

Anyway, I do not really care that much for this particular patch. But I do 
care about cpu hotplug / domain handling issues. Can you please look at that 
instead of resending your replies ;-).
I'm talking about
[PATCH] sched: CPU hotplug events must not destroy scheduler domains created 

by the cpusets

Also please ack (take 3) version of the default irq affinity patch that 
includes your latest comments.

Thanx
Max

> 
> Max wrote:
>> -marked isolated using the kernel boot time "isolcpus=" argument.
> 
> Yeah ... a hack ... but I suspect some folks use it.
> 
> I'm reluctant to discard features visible to users, unless
> they are getting in the way of more serious stuff.
> 
> I'd have figured that this hack was not all that much of
> a pain to the kernel code.



