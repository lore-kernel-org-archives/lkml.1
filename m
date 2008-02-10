Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYBJGRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYBJGRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYBJGRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:17:08 -0500
Received: from ns3.system-techniques.com ([204.91.156.41]:46484 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYBJGRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:17:06 -0500
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2008 01:17:06 EST
Date: Sat, 9 Feb 2008 21:08:16 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: /bin/sh: -c: line 0: syntax error near unexpected token `;'
Message-ID: <Pine.LNX.4.64.0802092100530.30547@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hello All ,  In a recent pull of linus's tree (*) today @ 2008-02-10 
02:49 UTC  ,  Using a previously well behaving .config I now get ...
 		Tia ,  JimL


make -f scripts/Makefile.clean obj=sound/usb/usx2y
make -f scripts/Makefile.clean obj=usr
   rm -rf .tmp_versions
   rm -f arch/x86/boot/fdimage arch/x86/boot/image.iso arch/x86/boot/mtools.conf vmlinux System.map .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
rm -f include/config/kernel.release
echo 2.6.24 > include/config/kernel.release
set -e; ; mkdir -p include/linux/;      (echo \#define LINUX_VERSION_CODE 132632; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < /usr/src/linux-2.6.25-git-20080209/Makefile > include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s include/linux/version.h include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else ; mv -f include/linux/version.h.tmp include/linux/version.h; fi
/bin/sh: -c: line 0: syntax error near unexpected token `;'
/bin/sh: -c: line 0: `set -e; ; mkdir -p include/linux/;        (echo \#define 
LINUX_VERSION_CODE 132632; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < /usr/src/linux-2.6.25-git-20080209/Makefile > include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s include/linux/version.h include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else ; mv -f include/linux/version.h.tmp include/linux/version.h; fi'
make: *** [include/linux/version.h] Error 2


(*)git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
