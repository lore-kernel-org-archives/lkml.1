Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYE2QgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYE2QgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYE2QgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:36:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40998 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYE2QgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:36:05 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5306"; a="3322018"
Message-ID: <483EDB70.2080708@qualcomm.com>
Date: Thu, 29 May 2008 09:36:00 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] [sched] Give cpusets exclusive control over sched domains
 (ie remove cpu_isolated_map)
References: <1211926006-11559-1-git-send-email-maxk@qualcomm.com>	<1211926006-11559-2-git-send-email-maxk@qualcomm.com>	<1211926006-11559-3-git-send-email-maxk@qualcomm.com> <20080529003019.985de0ab.pj@sgi.com>
In-Reply-To: <20080529003019.985de0ab.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
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
> 

I bet it will be tempting to extend it for other uses. Just like it was for me 
:). It looks just like another cpu_*map and stuff.

We could emulate isolcpu= boot option (the only visible user interface) via 
cpusets I suppose. But I'd rather not.
Since we do not plan on supporting it I'd say lets get rid of it.

Max



