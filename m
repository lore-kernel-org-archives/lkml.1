Return-Path: <linux-kernel-owner+w=401wt.eu-S1764319AbXK3Sp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764319AbXK3Sp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762813AbXK3Sps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:45:48 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48217 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762843AbXK3Spr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:45:47 -0500
Message-ID: <47505A53.8080906@linux.vnet.ibm.com>
Date: Sat, 01 Dec 2007 00:15:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: dhaval@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       skumar@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, menage@google.com
Subject: Re: [PATCH] sched: cpu accounting controller (V2)
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <20071113074805.GA13499@linux.vnet.ibm.com> <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com> <20071129191737.GH5681@linux.vnet.ibm.com> <20071129113035.bbdf35db.akpm@linux-foundation.org> <20071129201833.GA18023@linux.vnet.ibm.com> <20071130124225.GM5681@linux.vnet.ibm.com> <475005F7.7080702@linux.vnet.ibm.com> <20071130135331.GA7145@elte.hu>
In-Reply-To: <20071130135331.GA7145@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Srivatsa Vaddagiri wrote:
>> [snip]
>>
>>> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> thx. Have you done targeted testing of it as well? The (v2) patch is in 
> sched-devel.git:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> 
> 	Ingo

Tested the patches on top of 2.6.24-rc3. The patches work fine. Ran some
simple tests like cpuspin (spin on the cpu), ran several tasks in the
same group and timed them. Compared their time stamps with cpuacct.usage.

Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
