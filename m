Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbYLZAH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbYLZAH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 19:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYLZAHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 19:07:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45845 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYLZAHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 19:07:20 -0500
Message-ID: <49542030.4000907@jp.fujitsu.com>
Date: Fri, 26 Dec 2008 09:07:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-cpu-timers: clock_gettime(CLOCK_THREAD_CPUTIME_ID)
 goes backward
References: <4951F7E6.2080805@jp.fujitsu.com> <20081225082456.GA28479@elte.hu>
In-Reply-To: <20081225082456.GA28479@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ok - the issue is real, but there's a few implementational details. Did 
> you know about task_delta_exec()? This new function duplicates that 
> function's behavior - and task_delta_exec() is already used by posix 
> task/cpu timers.
> 
> I find your new task_total_exec() interface better (it's easier to use), 
> could you have a look at eliminating task_delta_exec() users and migrating 
> them over to task_total_exec()?

Yes.  There are only 2 users (clock_gettime() on thread timer and that on
process timer), so I'll post new patch with better description soon.

Thanks,
H.Seto

