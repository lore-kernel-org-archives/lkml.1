Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbZGCFxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbZGCFxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 01:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZGCFxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 01:53:01 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60262 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbZGCFxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 01:53:00 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
cc: linux-kernel@vger.kernel.org
from: aeriksson2@gmail.com
Subject: Re: 2.6.29.5 oops
In-reply-to: <20090630144136.GA11986@gambetta>
References: <20090630071009.B4E4F33C0ED@tippex.mynet.homeunix.org> <20090630144136.GA11986@gambetta>
Comments: In-reply-to Frederik Deweerdt <frederik.deweerdt@xprog.eu>
   message dated "Tue, 30 Jun 2009 16:41:36 +0200."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 03 Jul 2009 07:52:56 +0200
Message-Id: <20090703055256.39FC193CFF3@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.236.9
X-Scan-Result: No virus found in message 1MMbhj-0005zV-4N.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1MMbhj-0005zV-4N 99ba11675c30844351ee7dd93f245c46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


frederik.deweerdt@xprog.eu said:
> Jun 30 00:05:52 tv BUG: unable to handle kernel paging request at 0007a2cd
> 								    ^^^^^^^^ 
> [...]
> Jun 30 00:05:52 tv EAX: 0007a2cd EBX: f6031688 ECX: 0007a2cd EDX: fffffffe
> 			  ^^^^^^^^
> [...]
> Jun 30 00:05:52 tv Code: 0e 89 c7 89 d0 f2 ae 74 05 bf 01 00 00 00 4f 89 f8
> 5f c3 85 c9 57 89 c7 89 d0 74 05 f2 ae 75 01 4f 89 f8 5f c3 89 
> c1 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 c3 90 55 89 d5 57
> 56 

> Disassembling the above yields:
>  804a058:       89 d0                   mov    %edx,%eax
>  804a05a:       74 05                   je     804a061 <x+0x21>
>  804a05c:       f2 ae                   repnz scas %es:(%edi),%al
>  804a05e:       75 01                   jne    804a061 <x+0x21>
>  804a060:       4f                      dec    %edi
>  804a061:       89 f8                   mov    %edi,%eax
>  804a063:       5f                      pop    %edi
>  804a064:       c3                      ret    
>  804a065:       89 c1                   mov    %eax,%ecx
>  804a067:       89 c8                   mov    %ecx,%eax
>  804a069:       eb 06                   jmp    804a071 <x+0x31> 
>  804a06b:       80 38 00                cmpb   $0x0,(%eax)		 <== EIP
>  804a06e:       74 07                   je     804a077 <x+0x37>
>  804a070:       40                      inc    %eax
>  804a071:       4a                      dec    %edx
>  804a072:       83 fa ff                cmp    $0xffffffff,%edx
>  804a075:       75 f4                   jne    804a06b <x+0x2b>
>  804a077:       29 c8                   sub    %ecx,%eax
>  804a079:       c3                      ret    
>  804a07a:       90                      nop    
>  804a07b:       55                      push   %ebp

> A dereferencing which is more inline with the paging request noted above
> (compared to the push noted below). I guess it would be helpful if you could
> point to the right function using the above. 

Do you want _me_ to do that? I have no idea how to do it. I guess others might 
though.

/Anders

