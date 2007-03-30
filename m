Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXC3G1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXC3G1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 02:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXC3G1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 02:27:11 -0400
Received: from mtaout3.012.net.il ([84.95.2.7]:58055 "EHLO mtaout3.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbXC3G1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 02:27:11 -0400
Date: Fri, 30 Mar 2007 09:27:04 +0300
From: Avi Kivity <avi@qumranet.com>
Subject: Re: [2.6.21-rc5-git1][KVM] exception on start VM
In-reply-to: <200703292201.l2TM1fO4005275@posidon.tmr.com>
To: Bill Davidsen <davidsen@posidon.tmr.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <460CADB8.9090607@qumranet.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Fri,
 30 Mar 2007 09:27:04 +0300 (IDT)
References: <200703292201.l2TM1fO4005275@posidon.tmr.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Starting a VM for Win98SE:
>
> posidon:root> /usr/local/kvm-15/bin/qemu -m 128 -hda Win98SE-2.kvm 
> exception 13 (0)
> rax 00000000f000ff53 rbx 0000000000000000 rcx 000000000000005a rdx 000000000000000e
> rsi 00000000001100c4 rdi 000000000002a002 rsp 0000000000086650 rbp 000000000000667a
> r8  0000000000000000 r9  0000000000000000 r10 0000000000000000 r11 0000000000000000
> r12 0000000000000000 r13 0000000000000000 r14 0000000000000000 r15 0000000000000000
> rip 000000000000d350 rflags 00237206
> cs fff8 (000fff80/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> ds 0000 (00000000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> es 0000 (00000000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> ss 103f (000103f0/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> fs 0000 (00000000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> gs 0000 (00000000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
> tr 0000 (08850000/00002088 p 1 dpl 0 db 0 s 0 type b l 0 g 0 avl 0)
> ldt 0000 (00000000/0000ffff p 1 dpl 0 db 0 s 0 type 2 l 0 g 0 avl 0)
> gdt 87244/2f
> idt 0/3ff
> cr0 60000010 cr2 0 cr3 0 cr4 0 cr8 0 efer 0
> Aborted
> posidon:root>
>
>
> Hope that's useful, I was looking at nbd issues and just tried for 
> curiosity.
>
>   

Known issue.  It will be a while before we can support the '95 family on 
Intel as it makes heavy use of real mode.

Please copy kvm-devel@lists.sourceforge.net on kvm issues, a per 
MAINTAINERS.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

