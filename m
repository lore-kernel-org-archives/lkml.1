Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbZJ0Uuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbZJ0Uuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932251AbZJ0Uuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:50:39 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42747 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbZJ0Uui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Di0nqIUS+aSCQ1M5z2WAfZDVDXPY2P0b/Lv7I+RQQwBpPrPQp9d66gw1Ic1lS3kIy5
         1ROq/yP2vRVhuSb+bpbo7m9TvMvAx2Tys5VrmTM2uwRkanCe2SVTlzX7cmqNI+0SBWNM
         xVO4iqbYXRYbjGhSAJ5Iq40ZlSSUeUYY1l2/c=
MIME-Version: 1.0
Date: Tue, 27 Oct 2009 16:50:42 -0400
Message-ID: <55e03a0a0910271350r6900aaf3qed4cbf31b6359727@mail.gmail.com>
Subject: 2.6.32-rc5-git3 compile problems
From: Alex <mysqlstudent@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I receive the following error when using defconfig on 2.6.32-rc5-git3:

  CC      kernel/seccomp.o
  CC      kernel/rcutree.o
kernel/rcutree.c: In function `__rcu_init':
kernel/rcutree.h:296: sorry, unimplemented: inlining failed in call to
'rcu_bootup_announce': function body not available
kernel/rcutree.c:1702: sorry, unimplemented: called from here
make[1]: *** [kernel/rcutree.o] Error 1
make: *** [kernel] Error 2

Is this something I'm doing wrong? I'm actually trying to compile
2.6.31.5 with the default config, and it too fails, for another
reason. I'm having difficulty compiling 2.6.31 and 2.6.31.5 on x86
with gcc-3.4.4 and binutils-2.20.51.0.2. I'm also using glibc-2.3.6.

 AS      arch/x86/lib/thunk_32.o
 CC      arch/x86/lib/usercopy_32.o
 AR      arch/x86/lib/lib.a
 LD      vmlinux.o
 MODPOST vmlinux.o
 GEN     .version
 CHK     include/linux/compile.h
 UPD     include/linux/compile.h
 CC      init/version.o
 LD      init/built-in.o
 LD      .tmp_vmlinux1
drivers/built-in.o: In function `con_init':
vt.c:(.init.text+0x3c5b): undefined reference to `.L1446'
make: *** [.tmp_vmlinux1] Error 1

I'd sure appreciate any pointers on how to troubleshoot this.

Thanks,
Alex
