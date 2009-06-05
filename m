Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZFEAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZFEAiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbZFEAiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:38:06 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56071 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFEAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:38:05 -0400
Message-Id: <200906050038.n550c4Ja010907@www262.sakura.ne.jp>
Subject: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 09:38:04 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 04062009 #2085735, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.

"make allmodconfig" + "CONFIG_KVM=n" on 2.6.30-rc8 triggers build failure
when built with gcc 3.3.5 .

# make -s
/usr/src/all/vanilla/src/linux-2.6.30-rc8/arch/x86/Makefile:82: stack protector enabled but no compiler support
WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
arch/x86/mm/built-in.o(.init.text+0x43f7): In function `__change_page_attr':
arch/x86/mm/pageattr.c:114: undefined reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1


CONFIG_KVM=n is for avoiding gcc's internal error ( http://lkml.org/lkml/2009/6/4/14 ).
