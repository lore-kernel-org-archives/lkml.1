Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0CFHjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 02:39:11 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37367 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0CFHjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 02:39:05 -0500
Message-ID: <4B920694.7060402@in.ibm.com>
Date: Sat, 06 Mar 2010 13:09:00 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: -next March 3: Boot failure on x86 (Oops)
References: <20100303174603.5be197ba.sfr@canb.auug.org.au> <4B8E83D4.6090507@in.ibm.com> <4B8F0CD0.1040507@kernel.org> <4B8F43DD.10002@in.ibm.com> <4B909FC5.8020800@kernel.org> <4B90A031.8090306@kernel.org> <4B90E07A.5090302@in.ibm.com> <4B910623.9020707@kernel.org>
In-Reply-To: <4B910623.9020707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>
> I'm having very difficult time imagining how 22b737f4 could have
> affected this as the patch is identical transformation of the previous
> code.  Also, 833af842 was released with 2.6.32 and stayed that way, so
> it really looks like a memory overrun / random corruption thing.  Can
> you please retry with kmalloc debug stuff turned on?
>   
With latest git (2.6.33-git11) the machine boots fine. So as you
mentioned this could be a memory overrun / random corruption issue.

I will try few more boots with latest / old git snapshots, and will
try to collect debug information on recreation.

Thanks
-Sachin

> Thanks.
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

