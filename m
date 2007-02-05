Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbXBEM2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbXBEM2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbXBEM2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:28:52 -0500
Received: from [82.147.213.92] ([82.147.213.92]:32845 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932138AbXBEM2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:28:51 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20 doesn't compile with gcc-3.2.2
Date: Mon, 5 Feb 2007 15:31:20 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051531.20326.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Doing the following results in an incomplete vmlinuz:

# make mrproper
# make allnoconfig
# make bzlilo

objcopy: arch/i386/boot/compressed/vmlinux.bin: File truncated
make[2]: *** [arch/i386/boot/compressed/vmlinux.bin] Error 1
make[1]: *** [arch/i386/boot/compressed/vmlinux] Error 2
make: *** [bzlilo] Error 2

# gcc -v
Reading specs from /usr/lib/gcc-lib/i586-mandrake-linux-gnu/3.2.2/specs
Configured with: ../configure --prefix=/usr --libdir=/usr/lib 
--with-slibdir=/lib --mandir=/usr/share/man --infodir=/usr/share/info 
--enable-shared --enable-threads=posix --disable-checking --enable-long-long 
--enable-__cxa_atexit --enable-languages=c,c++,ada,f77,objc,java 
--host=i586-mandrake-linux-gnu --with-system-zlib
Thread model: posix
gcc version 3.2.2 (Mandrake Linux 9.1 3.2.2-3mdk)


Is gcc-4.0.1 now the minimum required to compile the kernel?


Thanks!

--
Al

