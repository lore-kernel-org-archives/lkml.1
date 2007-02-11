Return-Path: <linux-kernel-owner+w=401wt.eu-S1750703AbXBKPx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750703AbXBKPx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbXBKPx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:53:57 -0500
Received: from il.qumranet.com ([82.166.9.18]:32953 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbXBKPx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:53:56 -0500
Message-ID: <45CF3BF0.2070103@qumranet.com>
Date: Sun, 11 Feb 2007 17:53:20 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: KVM oops: killing interrupt handler
References: <45CE20E5.8000107@gmail.com> <45CEDB95.2020705@qumranet.com> <4af2d03a0702110601g36b4780fuec82be8290d6a397@mail.gmail.com>
In-Reply-To: <4af2d03a0702110601g36b4780fuec82be8290d6a397@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 2/11/07, Avi Kivity <avi@qumranet.com> wrote:
>> Jiri Slaby wrote:
>> > Hi!
>> >
>> > My schoolmate got this while using kvm-12 on 2.6.20-rc6:
>> > http://www.fi.muni.cz/~xslaby/sklad/kvm-intel-panic/a/
>> >
>> > Unfortunately it's only shots taken by camera. If we are able to
>> > reproduce it in 2.6.20, we'll grab netconsole output.
>> >
>>
>> What guest? what host?  How to reproduce?
>
> It's intel core 2 duo emulating 32-bit wxp. It happened after
> suspend/resume (he doesn't know if qemu was actually running) of the
> machine.
>

kvm suspend/resume support is only present in -mm (what's more, I don't 
think in any released -mm).  A workaround is to rmmod kvm_intel before 
suspending.



-- 
error compiling committee.c: too many arguments to function

