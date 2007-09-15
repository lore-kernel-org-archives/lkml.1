Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbXIOSlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbXIOSlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXIOSky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:40:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38964 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXIOSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:40:53 -0400
Message-ID: <46EC2702.3090000@oracle.com>
Date: Sat, 15 Sep 2007 11:40:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org> <20070915183412.GA14501@one.firstfloor.org>
In-Reply-To: <20070915183412.GA14501@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Andi, anything comes to mind?
> 
> No, unfortunately not. There weren't any changes to entry.S recently
> that could corrupt the error code as far as I remember. Also cannot think of 
> something else.
> 
> A version where it started happening would be useful.

I'll begin testing older kernels then.


Had another on recent last night (probably not helpful):

[58169.607164] Unable to handle kernel paging request at 00000000ff018915 RIP:
[58169.611784]  [<0000000000506986>]
[58169.617570] PGD d4380067 PUD 0
[58169.620757] Oops: 0000 [1] SMP
[58169.623943] CPU 2
[58169.625970] Modules linked in: loop
[58169.629496] Pid: 26735, comm: crashme Not tainted 2.6.23-rc6-git4 #1
[58169.635842] RIP: 0033:[<0000000000506986>]  [<0000000000506986>]
[58169.641861] RSP: 002b:00007fff14d3f9a0  EFLAGS: 00010247
[58169.647171] RAX: 0000000000506909 RBX: 00002b8695e82c00 RCX: 00002b8695f15b37
[58169.654298] RDX: 0000000000000000 RSI: 0000000000401476 RDI: 000000000000000a
[58169.661426] RBP: 00007fff14d3f9a0 R08: 00007fff14d3f8f0 R09: 0000000000000000
[58169.668553] R10: 0000000000000008 R11: 0000000000000212 R12: 0000000000000000
[58169.675680] R13: 00007fff14d3fb90 R14: 0000000000000000 R15: 0000000000000000
[58169.682808] FS:  00002b86960b46d0(0000) GS:ffff81011fc75840(0000) knlGS:0000000000000000
[58169.690889] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[58169.696630] CR2: 00000000ff018915 CR3: 00000000d8820000 CR4: 00000000000006e0
[58169.703757] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[58169.710885] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[58169.718014] Process crashme (pid: 26735, threadinfo ffff8100cd176000, task ffff81011fffe040)
[58169.726439]
[58169.727937] RIP  [<0000000000506986>]
[58169.731609]  RSP <00007fff14d3f9a0>
[58169.735100] CR2: 00000000ff018915
[58169.738710] Kernel panic - not syncing: Fatal exception
[58169.743953] Rebooting in 30 seconds..

