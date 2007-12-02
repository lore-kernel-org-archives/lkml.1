Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXLBCe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXLBCe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 21:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXLBCeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 21:34:17 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55750 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXLBCeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 21:34:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: [PATCH] fix x86-32 early fixmap initialization.
References: <47520F37.20657.4A6846F1@pageexec.freemail.hu>
	<m163zh5181.fsf@ebiederm.dsl.xmission.com>
	<86802c440712011824v4fdac3c4pfaf2f4d5ce93fe18@mail.gmail.com>
Date: Sat, 01 Dec 2007 19:32:29 -0700
In-Reply-To: <86802c440712011824v4fdac3c4pfaf2f4d5ce93fe18@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 1 Dec 2007 18:24:55 -0800")
Message-ID: <m1lk8d3jya.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Dec 1, 2007 5:34 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> pageexec@freemail.hu writes:
>>
>> > hello,
>> >
>> > i've just noticed that the chunk in i386/kernel/head.S ended up in a
>> > weird place, namely, it's not going to be executed as it's just after
>> > a 'jmp 3f' and before startup_32_smp, probably not what you intended.
>> > on a sidenote, the whole thing can be done in a single insn, like:
>> >
>> > movl $(swapper_pg_pmd - __PAGE_OFFSET + 0x067), (swapper_pg_dir -
>> > __PAGE_OFFSET+ 4092)
>> >
>> > PS: your email address ebiderman@xmisson.com in the commit seems to
>> > be wrong as well.
>>
>> Yes.  YH refresh one of my old patches and apparently got my email
>> address wrong.
>>
>> Thanks for the reminder I thought we had fixed this problem a while ago.
>
> i sent fix to andrew and andi. but it seems they missed it.

Well hopefully the new arch/x86 maintainers can pick up a simple bug fix.
Hopefully this code has not bit-rotted yet.

> BTW: how about your head32.c patch series.

I think it is a wonderful idea ;)

Right now I'm buried in the namespace work.

I am seeing my todo list shrink visibly on that day by day, but it is
still a mighty list.

Hopefully that list will won't include any patches that just need refreshing
and merging by the time 2.6.25 rolls around...

Eric
