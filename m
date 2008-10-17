Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYJQTd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYJQTd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbYJQTdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:33:17 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:59023 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYJQTdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:33:16 -0400
Message-ID: <48F8E86B.702@nortel.com>
Date: Fri, 17 Oct 2008 13:32:59 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: build failure on powerpc with current -git
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2008 19:33:00.0205 (UTC) FILETIME=[2A2145D0:01C9308F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current -git fails to build on 64-bit powerpc (failure log below) . 
  Initially I tried using my older toolchain, when I first saw the 
problem I built a new toolchain with crosstool (gcc 4.1.2 and binutils 
2.16.1) and tried again but got the same problem.

2.6.27 doesn't show this problem.

Any ideas what's going on and how I can fix it?

Thanks,

Chris


   LD      vmlinux.o
   MODPOST vmlinux.o
WARNING: modpost: Found 4 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
   GEN     .version
   CHK     include/linux/compile.h
   UPD     include/linux/compile.h
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
/opt/crosstool/gcc-4.1.2-glibc-2.3.6/powerpc64-unknown-linux-gnu/bin/powerpc64-unknown-linux-gnu-ld: 
BFD 2.16.1 internal error, aborting at 
/home/cfriesen/crosstool-0.43/build/powerpc64-unknown-linux-gnu/gcc-4.1.2-glibc-2.3.6/binutils-2.16.1/bfd/elflink.c 
line 6419 in elf_link_output_extsym

/opt/crosstool/gcc-4.1.2-glibc-2.3.6/powerpc64-unknown-linux-gnu/bin/powerpc64-unknown-linux-gnu-ld: 
Please report this bug.

make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

