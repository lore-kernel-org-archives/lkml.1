Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYBKBr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYBKBr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 20:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYBKBrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 20:47:46 -0500
Received: from ns3.system-techniques.com ([204.91.156.41]:34855 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYBKBrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 20:47:45 -0500
Date: Sun, 10 Feb 2008 16:47:43 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc1 ,  syntax error near unexpected token `;'
In-Reply-To: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802101645230.4708@filesrv1.baby-dragons.com>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hello All ,  grabbed using git just moments ago .

make V=1 KBUILD_VERBOSE=1 INSTALL_PATH=/boot clean all install modules_install

...snip...
make -f scripts/Makefile.clean obj=sound/usb/usx2y
make -f scripts/Makefile.clean obj=usr
   rm -rf .tmp_versions
   rm -f arch/x86/boot/fdimage arch/x86/boot/image.iso arch/x86/boot/mtools.conf 
vmlinux System.map .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
rm -f include/config/kernel.release
echo 2.6.25-rc1 > include/config/kernel.release
set -e; ; mkdir -p include/linux/;      (echo \#define LINUX_VERSION_CODE 
132633; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) 
< /usr/src/linux-2.6.25-rc1-git/Makefile > include/linux/version.h.tmp; if [ -r 
include/linux/version.h ] && cmp -s include/linux/version.h 
include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else ; mv 
-f include/linux/version.h.tmp include/linux/version.h; fi
/bin/sh: -c: line 0: syntax error near unexpected token `;'
/bin/sh: -c: line 0: `set -e; ; mkdir -p include/linux/;        (echo \#define 
LINUX_VERSION_CODE 132633; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + 
((b) << 8) + (c))';) < /usr/src/linux-2.6.25-rc1-git/Makefile > 
include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s 
include/linux/version.h include/linux/version.h.tmp; then rm -f 
include/linux/version.h.tmp; else ; mv -f include/linux/version.h.tmp 
include/linux/version.h; fi'
make: *** [include/linux/version.h] Error 2


# scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux filesrv2 2.6.23-rc9 #1 SMP Wed Oct 3 02:12:33 UTC 2007 i686 pentium4 i386 GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.15.92.0.2
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.10
pcmciautils            014
pcmcia-cs              3.2.8
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Linux C++ Library      6.0.3
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.1
Sh-utils               5.97
udev                   097
Modules Loaded

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
