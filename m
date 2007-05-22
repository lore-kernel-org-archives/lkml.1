Return-Path: <linux-kernel-owner+w=401wt.eu-S965966AbXEVQtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966AbXEVQtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbXEVQtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:49:07 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:46962 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXEVQtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:49:06 -0400
Message-ID: <46531EF6.3020204@nortel.com>
Date: Tue, 22 May 2007 10:48:54 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com> <20070521082926.GH19966@holomorphy.com> <20070521085703.GA18755@elte.hu>
In-Reply-To: <20070521085703.GA18755@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2007 16:48:58.0860 (UTC) FILETIME=[17E7B2C0:01C79C91]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> CFS is fair even on SMP. Consider for example the worst-case 
> 3-tasks-on-2-CPUs workload on a 2-CPU box:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2658 mingo     20   0  1580  248  200 R   67  0.0   0:56.30 loop
>  2656 mingo     20   0  1580  252  200 R   66  0.0   0:55.55 loop
>  2657 mingo     20   0  1576  248  200 R   66  0.0   0:55.24 loop
> 
> 66% of CPU time for each task. The 'TIME+' column shows a 2% spread 
> between the slowest and the fastest loop after just 1 minute of runtime 
> (and the spread gets narrower with time).

Is there a way in CFS to tune the amount of time over which the load 
balancer is fair?  (Of course there would be some overhead involved.)

Chris
