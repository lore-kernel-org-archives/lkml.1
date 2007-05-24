Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXEXIME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXEXIME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbXEXILs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:11:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:13181 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbXEXILr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LJZCKWFXvjvkttBh2kpdei0DHk3M+Z+3QnLgbQIENRWlQoButOunqmqncWQx6vs9C895K5s0g5wNDyj5YvpfSu6Xnw29FYi+/ysmHaRAzLBfMnfbQLoyA93b0kITOF2DMwR0i12dc80ACvxVgRvqXrxpxV2ClOm2kSSowKQF1kk=
Message-ID: <a8e1da0705240111l790ee29emdd872cf6c56a5e37@mail.gmail.com>
Date: Thu, 24 May 2007 08:11:46 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: clameter@sgi.com
Subject: 2.6.22-rc2-mm1 SLUB oops
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I exec aumix from console, the kernel oops seems in modprobe
process, and after a while , system hanged.

BUG: unable to handle kernel paging request at virtual address 646c6f68
 printing eip:
c016531e
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: cifs snd_hda_intel snd_pcm snd_timer snd_page_alloc snd sound
core ipv6 capability commoncap e100 mii agpgart pcspkr psmouse
CPU:    0
EIP:    0060:[<c016531e>]    Not tainted VLI
EFLAGS: 00010002   (2.6.22-rc2-mm1 #2)
EIP is at __kmalloc_track_caller+0x3e/0x80
eax: 00000000   ebx: c054dc24   ecx: 646c6f68   edx: c1050960
esi: 00000286   edi: 000000d0   ebp: c013d8c5   esp: c30a1e98
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process modprobe (pid: 1741, ti=c30a0000 task=c1f0ef40 task.ti=c30a0000)
Stack: c013d866 00000282 f888803e c304194c f8888044 00000006 c0150505 f8840b0c
       c015049a 0000000f c304194c 00000258 c3041800 c013d8c5 c0521f10 00000000
       f8840b00 00000000 c3041a34 f8888080 f8887fa4 00000019 f8840b00 f8885000
Call Trace:
 [<c013d866>] add_sect_attrs+0x66/0x150
 [<c0150505>] kstrdup+0x35/0x70
 [<c015049a>] __kzalloc+0x1a/0x50
 [<c013d8c5>] add_sect_attrs+0xc5/0x150
 [<c013f04e>] load_module+0xa6e/0xc00
 [<c013f244>] sys_init_module+0x44/0x140
 [<c0104098>] syscall_call+0x7/0xb
 [<c0440000>] packet_dev_mc+0x10/0x80
 =======================
Code: 89 74 24 0c e8 24 f8 ff ff 89 c3 31 c0 85 db 74 24 9c 5e fa 8b 93 88 00 00
 00 85 d2 74 2b 8b 42 0c 85 c0 74 24 89 c1 0f b7 42 0a <8b> 04 81 89 42 0c 56 9d
 89 c8 8b 5c 24 08 8b 74 24 0c 8b 7c 24
EIP: [<c016531e>] __kmalloc_track_caller+0x3e/0x80 SS:ESP 0068:c30a1e98

Regards
dave
