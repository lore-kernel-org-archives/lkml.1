Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZKRCik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZKRCik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 21:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZKRCij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 21:38:39 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43490 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbZKRCii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 21:38:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZlZ3+00s/fRU/bR/wvYz9loGDyfkYr8IqO5EPvqyi24AAxF/WAnA6kLewPw1DFyfB5
         PIQKsAvsT4DDCnmotyShjWulgX4S6OXA168iXIhiPlYvGbi5JlEcOd1/hWGsJK+0D4m+
         TVjku+wKCFgdLHTzBYEi6vMYIxF/TiXKzNXP8=
MIME-Version: 1.0
In-Reply-To: <86802c440911171311s1313abf5h4059422b1214ec75@mail.gmail.com>
References: <20091117191752.164451000@alcatraz.americas.sgi.com>
	 <20091117191757.651569000@alcatraz.americas.sgi.com>
	 <86802c440911171210x4780c08cg3b3260afd5d2bc5d@mail.gmail.com>
	 <4B030799.9020402@zytor.com>
	 <86802c440911171311s1313abf5h4059422b1214ec75@mail.gmail.com>
Date: Tue, 17 Nov 2009 18:38:44 -0800
Message-ID: <86802c440911171838q6e96670bnbf4db822484b7204@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 1:11 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Tue, Nov 17, 2009 at 12:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/17/2009 12:10 PM, Yinghai Lu wrote:
>>>>
>>>> The following lines have been removed:
>>>>
>>>>        CPU: Physical Processor ID:
>>>>        CPU: Processor Core ID:
>>>>        CPU %d/0x%x -> Node %d
>>>
>>> please don't.
>>>
>>
>> Why not?
>>
>> Or, more formally: please state the rationale for keeping them.
>>
> at least one distribution: SLES 11 mess it up when BSP is from socket
> 1 instead of socket0
>
> and above message does show kernel think BSP still from socket0, and
> other cores in that package are from socket1.

CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 24576K
BUG: unable to handle kernel paging request at ffffffffc07129b0
IP: [<ffffffff8049494b>] init_intel+0xea/0x14b
PGD 203067 PUD 204067 PMD 0
Oops: 0000 [1] SMP
last sysfs file:
CPU 0
Modules linked in:
Supported: Yes
Pid: 0, comm: swapper Not tainted 2.6.27.19-5-default #1
RIP: 0010:[<ffffffff8049494b>]  [<ffffffff8049494b>] init_intel+0xea/0x14b
RSP: 0018:ffffffff80965f48  EFLAGS: 00010202
RAX: 0000000020000000 RBX: 0000000000000044 RCX: 00000000000001a0
RDX: ffffffff808cbd14 RSI: 0000000000000046 RDI: 0000000020000000
RBP: 0000000020000000 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: ffffffff802223f1 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80a40080(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffffffc07129b0 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff80964000, task ffffffff806da380)
Stack:  0000000100000003 0000000100000000 ffffffff808cbd00 ffffe20000000000
 0000007800000000 ffffffff804943ef 0000000000000000 ffffffff80974fda
 0000000000000000 ffffffff8096de10 0000000000000000 ffffffff809a1510
Call Trace:
 [<ffffffff804943ef>] identify_cpu+0x3c/0xa3
 [<ffffffff80974fda>] check_bugs+0x9/0x2e
 [<ffffffff8096de10>] start_kernel+0x313/0x324
 [<ffffffff8096d38f>] x86_64_start_kernel+0xde/0xe4


Code: 0f a2 a8 1f 74 07 c1 e8 1a ff c0 eb 05 b8 01 00 00 00 66 89 85 d8 00 00 00
 65 44 8b 24 25 24 00 00 00 e8 c3 66 d8 ff 89 c5 48 98 <0f> bf 9c 00 b0 29 71 80
 83 fb ff 74 0d 0f a3 1d 91 a1 4c 00 19
RIP  [<ffffffff8049494b>] init_intel+0xea/0x14b
 RSP <ffffffff80965f48>
CR2: ffffffffc07129b0
---[ end trace 4eaa2a86a8e2da22 ]---


2.6.32 kernel corresponding part:

[    0.128855] CPU: Physical Processor ID: 1
[    0.129856] CPU: Processor Core ID: 0
[    0.130845] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.151454] CPU: L2 cache: 256K
[    0.152463] CPU: L3 cache: 24576K
[    0.153471] CPU 0/0x20 -> Node 0
[    0.168552] CPU 0 microcode level: 0xffff0008
[    0.169901] mce: CPU supports 22 MCE banks
