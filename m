Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZFPHjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZFPHjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZFPHiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:38:55 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58361 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZFPHiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:38:54 -0400
Message-Id: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp>
Subject: [x86] Build error at arch/x86/boot/bioscall.S
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Jun 2009 16:38:54 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 16062009 #2124512, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried to build 03347e2592078a90df818670fddf97a33eec70fb and got this error.

(...snipped...)
WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
/usr/src/all/linux/kernel/git/torvalds/linux-2.6.git/usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/all/linux/kernel/git/torvalds/linux-2.6.git/usr/include/mtd/jffs2-user.h:21: userspace cannot call function or variable defined in the kernel
Documentation/accounting/getdelays.c: In function `main':
Documentation/accounting/getdelays.c:249: warning: `cmd_type' might be used uninitialized in this function
Documentation/spi/spidev_fdx.c: In function `do_msg':
Documentation/spi/spidev_fdx.c:61: warning: cast from pointer to integer of different size
Documentation/spi/spidev_fdx.c:64: warning: cast from pointer to integer of different size
arch/x86/boot/bioscall.S: Assembler messages:
arch/x86/boot/bioscall.S:68: Error: `68(%esp)' is not a valid 16 bit base/index expression
make[1]: *** [arch/x86/boot/bioscall.o] Error 1
make: *** [bzImage] Error 2

# gcc --version
gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)
Copyright (C) 2003 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Regards.
