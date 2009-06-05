Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZFEDZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZFEDZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZFEDZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:25:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51647 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZFEDZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:25:01 -0400
Message-Id: <200906050324.n553OxXg045029@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 12:24:59 +0900
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp> <20090605023835.GA7933@cr0.nay.redhat.com>
In-Reply-To: <20090605023835.GA7933@cr0.nay.redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05062009 #2086045, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> Probably you are compiling on i386?
Yes. Debian Sarge for i386.

> All the types in __change_page_attr() are either 'long' or 'int', how
> can gcc generate software divide for these integer operations?

"make allnoconfig" compiles fine. Maybe config dependent?

$ make -s allnoconfig
#
# configuration written to .config
#
$ make -sj2
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
/usr/src/all/vanilla/src/linux-2.6.30-rc8/arch/x86/include/asm/processor.h: In function `native_get_debugreg':
/usr/src/all/vanilla/src/linux-2.6.30-rc8/arch/x86/include/asm/processor.h:497: warning: asm operand 0 probably doesn't match constraints
/usr/src/all/vanilla/src/linux-2.6.30-rc8/arch/x86/include/asm/processor.h: In function `native_set_debugreg':
/usr/src/all/vanilla/src/linux-2.6.30-rc8/arch/x86/include/asm/processor.h:524: warning: asm operand 0 probably doesn't match constraints
Root device is (8, 1)
Setup is 12120 bytes (padded to 12288 bytes).
System is 619 kB
CRC d7077162
Kernel: arch/x86/boot/bzImage is ready  (#1)
