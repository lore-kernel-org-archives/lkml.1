Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbXK1RDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbXK1RDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbXK1RDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:03:01 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49818 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758856AbXK1RDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:03:00 -0500
To: jdike@addtoit.com
CC: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <E1IxQEX-0007Ji-TV@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Wed, 28 Nov 2007 17:57:57 +0100)
Subject: Re: -rt doesn't compile for UML
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu> <20071128150840.GB5518@c2.user-mode-linux.org> <E1IxOzn-00075w-Gq@dorka.pomaz.szeredi.hu> <20071128154152.GA742@elte.hu> <E1IxPKU-00079S-UH@dorka.pomaz.szeredi.hu> <20071128160501.GA7986@elte.hu> <E1IxQEX-0007Ji-TV@dorka.pomaz.szeredi.hu>
Message-Id: <E1IxQJM-0007LZ-1w@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 18:02:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, managed to make it compile, but then something goes wrong in
> tracer_alloc_bootmem().

It needs 32M, and uml has that much by default.  Doh.

But something is still wrong:

> /store/quilt/linux/linux mem=64
Core dump limits :
        soft - 0
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...missing
Checking for tmpfs mount on /dev/shm...nothing mounted on /dev/shm
Checking PROT_EXEC mmap in /tmp/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found: Invalid argument
  - PTRACE_LDT...not found: Invalid argument
UML running in SKAS0 mode
setup_physmem - mapping -8093632 bytes of memory at 0x0x8800000 failed - errno = -12

Miklos
