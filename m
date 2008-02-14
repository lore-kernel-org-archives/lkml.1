Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbYBNTcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbYBNTcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbYBNTco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:32:44 -0500
Received: from mail.trixing.net ([87.230.125.58]:38750 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbYBNTcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:32:43 -0500
X-Greylist: delayed 1678 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2008 14:32:43 EST
Message-ID: <47B490A8.3050500@gmail.com>
Date: Thu, 14 Feb 2008 20:04:08 +0100
From: Jan Dittmer <jan.dittmer@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-am33-list@redhat.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Cross-Compiling mn10300: Assembler messages: junk at end of line:
 0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

defconfig build:

+ make ARCH=mn10300 HOSTCC=gcc-4.0 CROSS_COMPILE=mn10300-elf- 
CROSS32_COMPILE= O=../2.6.25-rc1-mn10300/
   Using /usr/src/xtest/linux-2.6 as source for kernel
   GEN     /usr/src/xtest/2.6.25-rc1-mn10300/Makefile
   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   CALL    /usr/src/xtest/linux-2.6/scripts/checksyscalls.sh
   CHK     include/linux/compile.h
   AS      arch/mn10300/kernel/kernel_execve.o
/usr/src/xtest/linux-2.6/arch/mn10300/kernel/kernel_execve.S: Assembler 
messages:
/usr/src/xtest/linux-2.6/arch/mn10300/kernel/kernel_execve.S:33: Error: 
junk at end of line: `0'
/usr/src/xtest/linux-2.6/arch/mn10300/kernel/kernel_execve.S:34: Error: 
junk at end of line, first unrecognized character is `m'
make[2]: *** [arch/mn10300/kernel/kernel_execve.o] Error 1
make[1]: *** [arch/mn10300/kernel] Error 2
make: *** [sub-make] Error 2


Expected? Toolchain problem? Tools from ftp.redhat.com,
Version 3.4-am33-04r2-5. Host is x86.

Thanks,

Jan Dittmer
