Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbXKNQrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbXKNQrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXKNQrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:47:35 -0500
Received: from ik-out-1112.google.com ([66.249.90.178]:5845 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbXKNQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J5xMwSoWaPWUEzd8sTWt9Rw9Xv5bOiW336u9wDVmUQ8IQ/KZFmxzWTNaNtiqD01r7IqUBSmvVIkx8wEPzDmjGMEbsWNfkhir+2EOWMFifTWjch5L6Au3NGbOmcykcTExCutbTmK0FNGmRv1Yteqkmnu4XpJ4g/VXqBsHaAcG1nk=
Message-ID: <2c0942db0711140847p1f9cd07fo959ffbe44c72a7d2@mail.gmail.com>
Date: Wed, 14 Nov 2007 08:47:28 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "martinpeterclarke@tiscali.co.uk" <martinpeterclarke@tiscali.co.uk>
Subject: Re: PROBLEM: IM Kernel Failure 12/11/07
Cc: linux-kernel@vger.kernel.org, martin.clarke@investmaster.com
In-Reply-To: <3189710.1195055945259.JavaMail.root@ps36.mc.tiscali.sys>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3189710.1195055945259.JavaMail.root@ps36.mc.tiscali.sys>
X-Google-Sender-Auth: 59841da676d5e4ff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 7:59 AM, martinpeterclarke@tiscali.co.uk
<martinpeterclarke@tiscali.co.uk> wrote:
> This is the 5th attempt to email you!  I keep being Greylisted!  I've
> extracted the minimal info from a zip which may be failing.

Yeah, don't send .zip files to the list.

> [5.] Output of Oops.. message (if applicable) with symbolic
> information resolved (see Documentation/oops-tracing.txt)
>
>         NO OOPS'ES !

There is, actually. See below.

> Linux pleco.investmaster.com 2.4.9-e.38smp #1 SMP Wed Feb 11 00:09:01
> EST 2004 i686 unknown

This is a somewhat ancient kernel. That said, has it been running fine
until recently? If so, you may want to investigate hardware issues
(failing power supply, bad RAM). Regardless, you may want to check if
updated kernels are available for that distribution. (RedHat
Enterprise Edition?)

> 2639    Nov  12 22:01:37  pleco kernel: Unable to handle kernel paging
> request at virtual address 1aaf2008
> 2640    Nov  12 22:01:37  pleco kernel: printing eip:
> 2641    Nov  12 22:01:37  pleco kernel: c01315df
> 2642    Nov  12 22:01:37  pleco kernel: *pde = 0
> 2643    Nov  12 22:01:37  pleco kernel: Oops: 00
> 2644    Nov  12 22:01:37  pleco kernel: Kernel 2.4.9-e.38smp
> 2645    Nov  12 22:01:37  pleco kernel: CPU: 0
> 2646    Nov  12 22:01:37  pleco kernel: EIP: 0010:
> [do_generic_file_read+463/1680]    Tainted: P
> 2647    Nov  12 22:01:37  pleco kernel: EIP: 0010:[<c01315df>]
> Tainted: P
> 2648    Nov  12 22:01:37  pleco kernel: EFLAGS: 10206
> 2649    Nov  12 22:01:37  pleco kernel: EIP isat do_generic_file_read
> [kernel] 0x1cf
> 2650    Nov  12 22:01:37  pleco kernel: eax: 1aaf2000   ebx: 00000001
> ecx: 00000013   edx: f77d5378
> 2651    Nov  12 22:01:37  pleco kernel: esi: 00000000   edi: e43e8d38
> ebp: 00000000   esp: e2525ef8
> 2652    Nov  12 22:01:37  pleco kernel: ds: 0018   es: 0018   ss: 0018
> 2653    Nov  12 22:01:37  pleco kernel: Processtar (pid: 20836,
> stackpage=e2525000)
> 2654    Nov  12 22:01:37  pleco kernel: Stack: 00001000 f77d537c 00000001
> 00000000 00000000 e43e8c80 00000322 e43e8c80
> 2655    Nov  12 22:01:37  pleco kernel: 00000004 00008001 00000000
> 0806f528 00000000 00001600 c0131c27 cc263bc0
> 2656    Nov  12 22:01:37  pleco kernel: cc263be0 e2525f48 c0131aa0
> 00000000 00000000 00001600 0806f528 00000000
> 2657    Nov  12 22:01:37  pleco kernel: Call Trace:
> [generic_file_new_read+103/128] generic_file_new_read [kernel] 0x67
> (0xe2525f30)
> 2658    Nov  12 22:01:37  pleco kernel: Call Trace: [<c0131c27>]
> generic_file_new_read [kernel] 0x67 (0xe2525f30)
> 2659    Nov  12 22:01:37  pleco kernel: [file_read_actor+0/256]
> file_read_actor [kernel] 0x0 (0xe2525f40)
> 2660    Nov  12 22:01:37  pleco kernel: [<c0131aa0>] file_read_actor
> [kernel] 0x0 (0xe2525f40)
> 2661    Nov  12 22:01:38  pleco kernel: [generic_file_read+27/32]
> generic_file_read [kernel] 0x1b (0xe2525f64)
> 2662    Nov  12 22:01:38  pleco kernel: [<c0131bbb>] generic_file_read
> [kernel] 0x1b (0xe2525f64)
> 2663    Nov  12 22:01:38  pleco kernel: [sys_red+150/288] sys_read
> [kernel] 0x96 (0xe2525f7c)

"sys_red"?

> 2664    Nov  12 22:01:38  pleco kernel: [<c0145cd6>] sys_read [kernel]
> 0x96 (0xe2525f7c)
> 2665    Nov  12 22:01:38  pleco kernel: [sys_open+149/224] sys_open
> [kernel] 0x95 (0xe2525fa4)
> 2666    Nov  12 22:01:38  pleco kernel: [<c01456e5>] sys_open [kernel]
> 0x95 (0xe2525fa4)
> 2667    Nov  12 22:01:38  pleco kernel: [system_call+51/56] system_call
> [kernel] 0x33 (0xe2525fc0)
> 2668    Nov  12 22:01:38  pleco kernel: [<c01073e3>] system_call [kernel]
> 0x33 (0xe2525fc0)
> 2669    Nov  12 22:01:38  pleco kernel:
> 2670    Nov  12 22:01:38  pleco kernel:
> 2671    Nov  12 22:01:38  pleco kernel: Code: 3 9 78 08 75 f4 39 68 0c 75
> ef 89 c6 85 f6 0f 84 8d 02 00 00

And there's the oops, which'll have to be interpreted by someone with
better kernel skills than I have, I'm afraid.

Ray
