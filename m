Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYH1Qde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYH1Qde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYH1Qd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:33:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45708 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYH1QdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:33:25 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5372"; a="5937428"
Message-ID: <48B6D353.6040001@qualcomm.com>
Date: Thu, 28 Aug 2008 09:33:23 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
References: <20080819103301.787700742@chello.nl> <20080828141513.GC31444@goodmis.org> <20080828143042.GA12644@elte.hu> <200808290036.35817.nickpiggin@yahoo.com.au>
In-Reply-To: <200808290036.35817.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 29 August 2008 00:30, Ingo Molnar wrote:
>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>>> For this, if this time limit does kick in, we should at the very least
>>> print something out to let the user know this happened. After all,
>>> this is more of a safety net anyway, and if we are hitting the limit,
>>> the user should be notified. Perhaps even tell the user that if this
>>> behaviour is expected, to up the sysctl <var> by more.
>> yeah, agreed, this is a reasonable suggestion. Peter, do you agree?
> 
> Seems reasonable. But I still think it should be disabled by default
> (it might not get caught in testing for example).

I cannot believe you guys are still arguing about this and calling each 
other stupid/incompetent/braindead and such (not this particular email 
but all the stuff before) :)

Seems to me like leaving RT throttling disabled by default is a 
reasonable compromise. Several people suggested that and the advantage 
is that it does not change the definition of SCHED_FIFO/RR by default.

I personally do not care that much what the default is. If Fedora, for 
example, starts enabling it by default I'll still have to change it. So 
it's not much different from enabled by default in the kernel.

Max


