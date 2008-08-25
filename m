Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYHYWEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYHYWEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYHYWEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:04:35 -0400
Received: from [198.99.130.12] ([198.99.130.12]:47417 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYHYWEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:04:35 -0400
Date: Mon, 25 Aug 2008 18:04:06 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UML build failure in 2.6.27-rc3
Message-ID: <20080825220406.GC12626@c2.user-mode-linux.org>
References: <E1KWBwC-0002dN-KE@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1KWBwC-0002dN-KE@closure.thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 11:19:00AM -0400, Theodore Ts'o wrote:
> Is this a known problem?
> 
>   SYMLINK arch/um/include/kern_constants.h
>   SYMLINK arch/um/include/sysdep
> make[2]: `arch/um/sys-i386/user-offsets.s' is up to date.
>   CHK     arch/um/include/user_constants.h
>   Using /usr/projects/linux/ext4 as source for kernel
>   GEN     /usr/projects/linux/uml/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    /usr/projects/linux/ext4/scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      arch/um/kernel/ptrace.o
> /usr/projects/linux/ext4/arch/um/kernel/ptrace.c:230: error: static declaration of ‘send_sigtrap’ follows non-static declaration
> include2/asm/ptrace-generic.h:51: error: previous declaration of ‘send_sigtrap’ was here
> make[2]: *** [arch/um/kernel/ptrace.o] Error 1
> make[1]: *** [arch/um/kernel] Error 2
> make: *** [sub-make] Error 2

Are you sure you have a consistent tree?  I see no declaration of
send_sigtrap in ptrace-generic.h.  There is one in asm-x86/ptrace.h
but it's not at line 51.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
