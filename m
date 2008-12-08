Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYLHB0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYLHB0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 20:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYLHB0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 20:26:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53039 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYLHB0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 20:26:39 -0500
Message-ID: <493C776F.9080005@cn.fujitsu.com>
Date: Mon, 08 Dec 2008 09:25:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] export percpu cpuacct cgroup stats
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>	 <49376BE3.1040909@cn.fujitsu.com>	 <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>	 <b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com>	 <4938DE1C.6070608@cn.fujitsu.com> <b040c32a0812051010m11e9d376qcd77a3a71a4f42b9@mail.gmail.com>
In-Reply-To: <b040c32a0812051010m11e9d376qcd77a3a71a4f42b9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote:
> On Thu, Dec 4, 2008 at 11:54 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> +             seq_printf(m, "%llu ", percpu);
>> Should be:
>> +               seq_printf(m, "%llu ", (unsigned long long)percpu);
>>
>> Otherwsise:
>> kernel/sched.c: In function 'cpuacct_percpu_seq_read':
>> kernel/sched.c:9359: warning: format '%llu' expects type 'long long unsigned int',
>> but argument 3 has type 'u64'
> 
> I'm curious what compiler and CPU arch target are you using that cause
> compiler to spit out this warning message?  On x86_64 u64 is unsigned
> long long and gcc v4.2.4 doesn't give such warning.
> 

I tried it on IA64, and gcc version is 4.1.2.

On IA64, u64 is unsigned long.

