Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZEYQ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZEYQ4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZEYQ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:56:24 -0400
Received: from mail-px0-f103.google.com ([209.85.216.103]:42071 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZEYQ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=exxK55bbsDMGpjSy2bAAakN8MXrU3AEDUTOTEwONQhv37TjgxnlDp17WHsO2+FnL3t
         Xq4z18DQ7jA4h9JnPiwTeu6vBPjkOlvJrVs7ZXS2raXG2r548TkI9wfZyz+fIZRl+j03
         9dajDip1NEYU1pptMyl4rWDQNXLqVGiig9Aus=
MIME-Version: 1.0
Date: Mon, 25 May 2009 22:26:25 +0530
Message-ID: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com>
Subject: Unable to compile 2.6.30-rc7 on RHEL 4 - GCC 3.4.6
From: debian developer <debiandev@gmail.com>
To: linux kernel <kernelnewbies@nl.linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am getting this error when trying to compile the latest rc:

/in/inndesk171/linux-2.6.28/arch/x86/Makefile:82: stack protector
enabled but no compiler support
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC      init/main.o
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h: In
function `start_kernel':
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
warning: asm operand 1 probably doesn't match constraints
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1570:
warning: asm operand 2 probably doesn't match constraints
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
warning: asm operand 1 probably doesn't match constraints
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1570:
warning: asm operand 2 probably doesn't match constraints
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1599:
warning: asm operand 1 probably doesn't match constraints
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
error: impossible constraint in `asm'
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1570:
error: impossible constraint in `asm'
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
error: impossible constraint in `asm'
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1570:
error: impossible constraint in `asm'
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1599:
error: impossible constraint in `asm'
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1568:
warning: 'f' might be used uninitialized in this function
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1568:
warning: 'f' might be used uninitialized in this function
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1568:
warning: 'f' might be used uninitialized in this function
/in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1568:
warning: 'f' might be used uninitialized in this function
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2


The gcc version is as follows:
debiandev@inndesk171[80] gcc -v
Reading specs from /usr/lib/gcc/x86_64-redhat-linux/3.4.6/specs
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info --enable-shared --enable-threads=posix
--disable-checking --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-java-awt=gtk
--host=x86_64-redhat-linux
Thread model: posix
gcc version 3.4.6 20060404 (Red Hat 3.4.6-9)


Is this gcc version no longer usable to compile the latest kernel?

Thanks,
DD
