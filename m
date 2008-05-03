Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYECFV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYECFV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 01:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYECFVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 01:21:47 -0400
Received: from smtp.enter.net ([216.193.128.24]:1282 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbYECFVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 01:21:46 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Strange linux-next build error
Date: Sat, 3 May 2008 01:21:38 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805030121.39831.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After updating my local tree to the latest linux-next and starting a clean 
build I see this error *ONLY* the first time I start a "make bzImage"

  CC      arch/x86/kernel/acpi/sleep.o
  LDS     arch/x86/kernel/acpi/realmode/wakeup.lds
cc1: fatal error: opening output file 
arch/x86/kernel/acpi/realmode/wakeup.lds: Permission denied
compilation terminated.
make[4]: *** [arch/x86/kernel/acpi/realmode/wakeup.lds] Error 1
make[3]: *** [arch/x86/kernel/acpi/realmode/wakeup.bin] Error 2
make[2]: *** [arch/x86/kernel/acpi] Error 2
make[1]: *** [arch/x86/kernel] Error 2
make: *** [bzImage] Error 2

Restarting the build brings it through to completion. I've checked and there 
is no reason that this error should occur.

madman@strider:~/linux/linux-git/Documentation$ gcc --version
gcc (GCC) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)
Copyright (C) 2006 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

(I'll be booting this kernel tomorrow to test it - previous -next kernels have 
all faulted during boot)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
