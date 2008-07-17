Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbYGQTmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbYGQTmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbYGQTmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:42:42 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:49160 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYGQTml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:42:41 -0400
Message-Id: <487F6972.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 17 Jul 2008 13:46:58 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <torvalds@linux-foundation.org>, <pj@sgi.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpu hotplug, sched:
	Introduce	cpu_active_map	and	redoscheddomainmanagment (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
 <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com>
 <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com>
 <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com>
In-Reply-To: <487F9509.9050802@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Thu, Jul 17, 2008 at  2:52 PM, in message <487F9509.9050802@qualcomm.com>,
Max Krasnyansky <maxk@qualcomm.com> wrote: 
> Gregory Haskins wrote:
>>
>> Hi Max,
>>   Thanks for the pointers.  I see that I did indeed misunderstand the intent 
>> of the patch.  It seems you already solved the rebuild problem, and were
>> just trying to solve the "migrate to a dead cpu" problem that Linus mentions
>> as a solution with cpu_active_map.
>
> Yes. btw they are definitely related, because the reason we were blowing 
> away the domains is to avoid "migration to a dead cpu". ie We were relying
> on the fact that domain masks never contain cpus that are either dying or
> already dead.

Agreed.

>> 
>> Thoughts?
>
> None at this point :). I need to run right now and will try to look at this
> later today. My knowledge of the internal sched structs is definitely 
> lacking so I need to look at the rq->rd thing to have and opinion.

Sounds good, Max.  Thanks!

-Greg


