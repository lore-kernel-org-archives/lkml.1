Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYKSVvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYKSVvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYKSVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:50:57 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:45989 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYKSVu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:50:56 -0500
Message-ID: <49248A35.4080401@nortel.com>
Date: Wed, 19 Nov 2008 15:50:45 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ken Chen <kenchen@google.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [patch] sched: add locking when update the task_group's	cfs_rq[]
  array.
References: <b040c32a0811182248s1174c82avf44c720ae2d14804@mail.gmail.com>	 <1227113662.29743.46.camel@lappy.programming.kicks-ass.net>	 <b040c32a0811190921g557edc4dy4725fb86107c2c54@mail.gmail.com> <1227128331.29743.61.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1227128331.29743.61.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2008 21:50:49.0089 (UTC) FILETIME=[E2669710:01C94A90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> Will it scale, half-way, I'd say. It races a little, but should
> converge. The biggest issue is that we're running with 10 bit fixed
> point math, and on large cpu machines you get into granularity problems.

Is there any way to get higher resolution math on 64-bit machines?  (I'm 
assuming that most larger SMP boxes will be 64-bit capable.)

Chris
