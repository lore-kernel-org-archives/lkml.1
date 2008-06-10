Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYFJOJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYFJOJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbYFJOJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:09:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54559 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYFJOJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:09:06 -0400
To: jdike@addtoit.com
CC: miklos@szeredi.hu, peter.oberparleiter@de.ibm.com,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       oberparleiter@googlemail.com
In-reply-to: <20080610135729.GA6087@c2.user-mode-linux.org> (message from Jeff
	Dike on Tue, 10 Jun 2008 09:57:29 -0400)
Subject: Re: 2.6.26-rc5-mm1: uml link error
References: <E1K5oBn-0006v4-KJ@pomaz-ex.szeredi.hu> <484E5CBB.2040203@de.ibm.com> <E1K61st-0008JT-9e@pomaz-ex.szeredi.hu> <20080610135729.GA6087@c2.user-mode-linux.org>
Message-Id: <E1K64Wj-0000Bj-Fu@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Jun 2008 16:08:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hmm, uml still doesn't boot with this patch, it dies while calling the
> > constructors.  So maybe that SORT contruct is still needed?
> > 
> > #17 0x08049793 in do_ctors () at init/main.c:706
> > #18 0x080499cc in do_basic_setup () at init/main.c:789
> > #19 0x08049a43 in kernel_init (unused=0x0) at init/main.c:897
> 
> This doesn't look like it's in do_initcalls.  What happens with
> "initcall_debug"?

Same output:

mszeredi@tucsk:/store/uml> /store/quilt/linux/linux initcall_debug umid=uml
Locating the bottom of the address space ... 0x0
Locating the top of the address space ... 0xffffd000
Core dump limits :
        soft - NONE
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...missing
Checking for tmpfs mount on /dev/shm...nothing mounted on /dev/shm
Checking PROT_EXEC mmap in /tmp/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
  - PTRACE_LDT...not found
UML running in SKAS0 mode
Adding 19943424 bytes to physical memory to account for exec-shield gap
Aborted (core dumped)
