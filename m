Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZA0QPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZA0QPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZA0QPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:15:08 -0500
Received: from mailhost-r6-m2.nerim.net ([78.40.49.196]:50291 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752084AbZA0QPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:15:08 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 11:15:07 EST
Date: Tue, 27 Jan 2009 17:05:36 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090127160536.GA2241@localhost.localdomain>
References: <20090120162537.GA2344@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120162537.GA2344@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just a heads up on this problem I sent a few days ago:

> Testing 2.6.29-rc2-git1, I notice something which doesn't happen with
> 2.6.28.1 on the same machine with the same config (minus new config
> entries for 2.6.29) : when the machine is idle, the load average
> reported by top is not 0.00 (it is with 2.6.28.1) but between 0.30 and
> 0.80 and either ksoftirqd/0 or ksoftirqd/1 is listed as number one in
> top output, with a few % of CPU. The machine seems to work fine but
> I think something is still wrong.

> Here is an example of top output :

> top - 17:23:40 up 19 min,  2 users,  load average: 0.42, 0.48, 0.34
> Tasks:  99 total,   1 running,  98 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.2%us,  0.5%sy,  0.0%ni, 99.1%id,  0.0%wa,  0.0%hi,  0.2%si, 0.0%st
> Mem:   2075420k total,   311920k used,  1763500k free,     4912k buffers
> Swap:  1212896k total,        0k used,  1212896k free,   115648k cached

>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>     4 root      15  -5     0    0    0 S    1  0.0   0:30.74 ksoftirqd/0
>     1 root      20   0  2100  692  588 S    0  0.0   0:00.47 init

> I attach dmesg, config and /proc/interrupts. Feel free to ask more info
> if needed.

The problem is still present in 2.6.29-rc2-git3 on this P4 machine, but
I do not see it on a Centrino laptop.

Config has not changed and I do not know if /proc/interrupts is useful
or not so I am not attaching anything for now, feel free to ask for more
information and I will do my best to provide it. I know someone else
also experienced this problem on his machines.

-- 
Damien Wyart
