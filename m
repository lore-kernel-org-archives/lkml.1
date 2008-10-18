Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbYJRQxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbYJRQxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 12:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYJRQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 12:53:48 -0400
Received: from host86-158-139-183.range86-158.btcentralplus.com ([86.158.139.183]:42978
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYJRQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:53:47 -0400
Message-ID: <48FA1494.10205@oak.selfip.net>
Date: Sat, 18 Oct 2008 17:53:40 +0100
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Oops 2.6.27-05178-g2e532d6
References: <48F9B2FE.1030306@oak.selfip.net> <20081018103948.GA2717@x200.localdomain>
In-Reply-To: <20081018103948.GA2717@x200.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sat, Oct 18, 2008 at 10:57:18AM +0100, Dave Haywood wrote:
>   
>> [  372.980378] BUG: unable to handle kernel NULL pointer dereference at 00000020
>> [  372.980400] IP: [<c0323d5c>] sock_poll+0xc/0x20
>> [  372.980425] *pde = 00000000
>> [  372.980435] Oops: 0000 [#1]
>> [  372.980574] last sysfs file: /sys/kernel/uevent_seqnum
>> [  372.980677]
>> [  372.980773] Pid: 5150, comm: squid Not tainted (2.6.27-05178-g2e532d6 #257) Deskpro
>> [  372.980934] EIP: 0060:[<c0323d5c>] EFLAGS: 00010246 CPU: 0
>> [  372.981036] EIP is at sock_poll+0xc/0x20
>> [  372.981133] EAX: cbf3c460 EBX: 00000000 ECX: 00000000 EDX: cddc8280
>> [  372.981235] ESI: cbf27f48 EDI: cd938ae0 EBP: cd938aec ESP: cbf27f20
>> [  372.981337]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>> [  372.981440] Process squid (pid: 5150, ti=cbf26000 task=cbec0510 task.ti=cbf26000)
>> [  372.981601] Stack:
>> [  372.981692]  00000296 c0195e8a cbf27f48 00002000 08553940 cbfba180 cbfba19c cbfba224
>> [  372.982004]  00000000 cbf26000 cd938aec cd938d2c cbfba224 cbfba180 00000003 cbf26000
>> [  372.982430]  c01963c7 00002000 08553940 cd938aec cbfba1f8 00000246 ca43f2d4 ca43f2c0
>> [  372.982940] Call Trace:
>> [  372.983033]  [<c0195e8a>] ep_send_events+0xea/0x2b0
>> [  372.983167]  [<c01963c7>] ep_poll+0x57/0x1c0
>> [  372.983297]  [<c016ed9e>] fget+0x9e/0xd0
>> [  372.983443]  [<c01965d8>] sys_epoll_wait+0xa8/0xb0
>>     
>
> Try this:
> http://marc.info/?l=linux-kernel&m=122428548613067&w=2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Thanks Alexy: This patch fixed it for me.  6 hours uptime with no problems.

Tested-By: Dave Haywood <tla@oak.selfip.net>

Dave.


